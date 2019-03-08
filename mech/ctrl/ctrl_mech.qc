/*
mech mod
Author: Peter Roohr
Date: 9/5/2016
Overview: implementation for center torso updates
*/

void() ctrl_updateCenterTorso={
  local float diff;
  local float mx, my;
  local float rate;
  local entity cam;
  local vector v1;
  
  if( (self.flags & FL_CLIENT) ){
    if(time > self.laser_sight_timer){
      makevectors(self.v_angle);
      v1 = self.e_cam.origin;
      traceline(v1, v1 + v_forward*10000, FALSE, self);
      self.laser_sight_org = trace_endpos;
      self.laser_sight_timer = time + 0.05;
    }
  }
  else{
    makevectors(self.v_angle);
    v1 = self.origin + (v_right * cam.c_ofs_x) + (v_up*cam.c_ofs_y) + (v_forward*cam.c_ofs_z);
    traceline(v1, v1 + v_forward * 10000, FALSE, self);
    self.laser_sight_org = trace_endpos;
    self.laser_sight_timer = time + 0.05;
  }

  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if(self.en_cur > -1){
      diff = self.en_rate;
      if( self.stat_plr_stt == PLAYER_SPRINT_ON ){
        diff = diff * 0.35;
      }
      self.en_cur = self.en_cur + diff;
    }  
    if(self.sh_cur < self.sh_max){
      if(time > self.sh_hit){
        if(self.en_cur > 0){
          self.sh_cur = self.sh_cur + self.sh_rate;
          self.en_cur = self.en_cur - self.sh_rate;
          if(self.sh_cur > self.sh_max){
            self.sh_cur = self.sh_max;
          }
        }
      }
    }
    if(self.en_cur < 0){
      self.en_cur = 0;
    }
    else if(self.en_cur > self.en_max){
      self.en_cur = self.en_max;
    }
  }
  
  if((self.flags & FL_CLIENT)){
    mx = self.movement_x;
    if(mx < 0){
      mx = mx * -1;
    }
    
    my = self.movement_y;
    if(my < 0){
      my = my * -1;
    }
    rate = self.spreadDefault_z;
    //accuracy / spread mechanics
    if( (my != 0) || (mx != 0) ) {
      //unit is moving, increase spread factor
      if( !self.stat_rdr_mode ){
        rate = rate + ( rate * 0.5 );
      }
      rate = rate - self.accuracyMod;
      self.accuracy = self.accuracy + rate;
      if( self.accuracy > self.spreadDefault_y ){
        self.accuracy = self.spreadDefault_y;
      }
    }
    if( (my == 0) && (mx == 0) ){
      //standing still, lessen the spread
      if( self.stat_rdr_mode ){
        rate = rate + (rate * 0.25);
      }
      rate = rate + self.accuracyMod;
      self.accuracy = self.accuracy - rate;
      if( self.accuracy < self.spreadDefault_x ){
        self.accuracy = self.spreadDefault_x;
      }
    }
  }
  
  //damage-based cosmetics for unit component pieces
  local entity piece;
  local float hp;
  local vector spark;
  local entity partParent;
  piece = self.c_part;
  while( piece ){
    if( piece.deadflag <= DEAD_NO ){
      hp = piece.health / piece.max_health;
      if( hp < 0.75){
        spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
        pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5, 1);
        if( hp < 0.5){
          spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5, 1.25);
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5, 1.5);
          if( hp < 0.25){
            spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5, 1.5);
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5, 1.75);
          }
        }
      }
    }
    else{
      partParent = util_getPartFromName(piece.c_parent, self); 
      if( partParent.deadflag <= DEAD_NO ){
        spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
        pointparticles( particleeffectnum("TE_MECHPIECE_DEAD_BURN"), spark, normalize( spark - piece.origin) * 5, 1);
      }
    }
    piece = piece.c_part;
  }
};

void() ctrl_component_die={
  if(self.deadflag <= DEAD_NO){
    local entity piece;
    local entity this;
    
    piece = self;
    
    te_missile_explode( self.origin, self.owner.vec_size, '1 0.25 0.75', random() * (self.vec_size * 1.5), 2); 
    te_mech_piece_explode( piece, piece.origin, piece.angles, self.owner.velocity, piece.model, piece.skin );

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
    setorigin( self, self.origin );
    
    if(self.comp_id == M_TOR_LEFT){
      killed(self.owner.e_arm_l, self, 0);
    }
    else if(self.comp_id == M_TOR_RIGHT){
      killed(self.owner.e_arm_r, self, 0);
    }
    
    local entity c;
    c = self.owner.w_slot;
    while(c){
      if(c.c_parent == self.comp_id){
        killed(c, self, 0);
      }
      c = c.w_slot;
    }
    
    self.health = 0;
    
    if((self.owner.flags & (FL_MONSTER | FL_DISARMED))){
      //if the bot loses all guns, have it panic
      this = self;
      self = self.owner;
        self.th_pain( self.owner.enemy );
      self = this;
    }
  }
};

void() ctrl_component_burn={
  local vector spark;
  makevectors( self.angles );
  spark = self.origin + (v_up * 10);
  pointparticles( particleeffectnum("TE_MECHPIECE_DEAD_BURN"), spark, normalize( spark - self.origin) * 5, self.vec_size * 1.5);
  self.think = ctrl_component_burn;
  self.nextthink = time + 0.1;
  if( time > self.ai_action_time ){
    self.think = ctrl_component_drop;
    self.nextthink = time + 0.1;
    self.ai_action_time = time + 7200;
    return;
  }
};


void() ctrl_component_drop={

  self.think = SUB_Remove;
  self.nextthink = self.ai_action_time;
};

void() touch_mech={
  if(other == world){
    return;
  }
  if( (other.flags & FL_CLIENT) || (other.flags & FL_MONSTER) ){
    local float dif;
    dif = self.vec_size - other.vec_size;
    if(dif == 2){
      if(other.data_type == DATA_VEHC){
        t_damage(other, self, self, other.max_health, DMG_BAL, other.origin, '0 0 0');
      }
      else{
        t_damage(other, self, self, self.max_health * 0.15, DMG_BAL, other.origin, '0 0 0');
      }
    }
    else if(dif == 1){
      if(other.data_type == DATA_VEHC){
        t_damage(other, self, self, other.max_health , DMG_BAL, other.origin, '0 0 0');
      }
      else{
        t_damage(other, self, self, self.max_health*0.15, DMG_BAL, other.origin, '0 0 0');
      }
    
    }
    else if(dif == 0){
      if(other.data_type == DATA_VEHC){
        t_damage(other, self, self, other.max_health / 4, DMG_BAL, other.origin, '0 0 0');
      }
    }
    else if(dif == -1){
      if(other.data_type != DATA_VEHC){
        t_damage(self, other, other, other.max_health / 1.5, DMG_BAL, self.origin, '0 0 0');
      }
    }
    else if(dif == -2){
      if(other.data_type != DATA_VEHC){
        t_damage(self, other, other, other.max_health / 2, DMG_BAL, self.origin, '0 0 0');
      }
    }
  }
};

void() touch_mechPiece={
  if(other == world){
    return;
  }
  if( other.classname == MECH_PIECE ){
    return;
  }
  
  BecomeExplosion();
  
};