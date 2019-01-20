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
  
  if((self.flags & FL_CLIENT)){
    if(time > self.laser_sight_timer){
      makevectors(self.v_angle);
      v1 = self.origin + (v_right * cam.c_ofs_x) + (v_up*cam.c_ofs_y) + (v_forward*cam.c_ofs_z);
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
    if(self.en_cur >= 0){
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur > self.en_max){
        self.en_cur = self.en_max;
      }
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
    
    //accuracy / spread mechanics
    if( (my != 0) || (mx != 0) ) {
      //unit is moving, increase spread factor
      rate = self.spreadDefault_z;
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
      rate = self.spreadDefault_z;
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

void() ctrl_die_comp={
  if(self.deadflag <= DEAD_NO){
    local entity oself, tmp;
    local vector pvel;
    local float compType;
    compType = self.comp_id;
    oself = self;
    pvel = self.owner.velocity;
    newmis = spawn();
    self = newmis;
      setorigin(newmis, oself.origin);
      BecomeExplosion();
    self = oself;
    
    newmis = spawn();
    self = newmis;
      self.angles = oself.angles;
      if(pvel_x > 0 || pvel_y > 0 || pvel_z > 0){
        self.velocity = pvel + VelocityForDamage (100);
        self.avelocity_x = random()*150;
        self.avelocity_y = random()*150;
        self.avelocity_z = random()*100;
      }
      else{
        self.velocity = VelocityForDamage (100);
        self.avelocity_x = random()*150;
        self.avelocity_y = random()*150;
        self.avelocity_z = random()*100;
      }
      self.th_die = SUB_Remove;
      self.owner = oself.owner;
      util_setCollider(DAMAGE_AIM, SOLID_CORPSE, MOVETYPE_BOUNCE);
      util_setModel(oself.model, oself.owner.skin, 0);
      setsize(self, '-3 -3 -3', '3 3 3');
      setorigin(self, oself.origin);
      self.touch = touch_mechPiece;
      self.think = BecomeExplosion;
      self.nextthink = time + 100;
      self.colormod = oself.colormod;
      pvel = normalize(self.origin - oself.owner.origin) * 10;
      pvel_z = pvel_z + 50;
      te_debris( self.origin, self.angles, normalize(self.origin - oself.owner.origin) * 10, oself.owner.vec_size * 2, 1); 
    self = oself;

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
    setorigin( self, self.origin );
    
    if(compType == M_TOR_LEFT){
      killed(self.owner.e_arm_l, self, 0);
    }
    else if(compType == M_TOR_RIGHT){
      killed(self.owner.e_arm_r, self, 0);
    }
    
    local entity c;
    c = self.owner.w_slot;
    while(c){
      if(c.c_parent == compType){
        killed(c, self, 0);
      }
      c = c.w_slot;
    }
    
    self.health = 0;
    
    if((self.owner.flags & FL_MONSTER)){
      //if( ai_core_noguns()){
        //TODO - panic behavior
     // }
    }
  }
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