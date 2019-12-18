/*
battleMETAL
Author: Peter Roohr
Date: 9/5/2016
Overview: 
  implementation for center torso updates
*/

void() ctrl_update_mechplayer={
  local entity parent;
  local entity wep;  
  local entity piece;
  local float hp;
  local vector spark;
  local entity partParent;
  
  parent = self;
  
  ctrl_updateCenterTorso();
  
  if( self.legs.deadflag == DEAD_NO ){
    self = self.legs;
      ctrl_updateLegs();
    self = parent;
  }
  
  //damage-based cosmetics for unit component pieces
  piece = self.partNext;
  self.torsoLeft.hitOffset = self.origin + (v_right * self.torsoLeft.compAltOffset_x) + (v_up * self.torsoLeft.compAltOffset_y);
  self.torsoRight.hitOffset = self.origin + (v_right * self.torsoRight.compAltOffset_x) + (v_up * self.torsoRight.compAltOffset_y);
  self.armRight.hitOffset = self.origin + (v_right * self.armRight.compAltOffset_x) + (v_up * self.armRight.compAltOffset_y);
  self.armLeft.hitOffset = self.origin + (v_right * self.armLeft.compAltOffset_x) + (v_up * self.armLeft.compAltOffset_y);
  self.torsoCenter.hitOffset = self.origin + (v_right * self.torsoCenter.compAltOffset_x) + (v_up * self.torsoCenter.compAltOffset_y);
  
  for(piece = self.partNext; piece.owner == self; piece = piece.partNext){
    if( piece.classname != MECH_PIECE ){
      continue;
    }
    if( piece.deadflag <= DEAD_NO ){
      hp = piece.health / piece.max_health;
      if( hp < 0.75){
        spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
        pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
        if( hp < 0.5){
          spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
          if( hp < 0.25){
            spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
          }
        }
      }
    }
    else{
      partParent = util_getPartFromName(piece.partParentId, self); 
      if( partParent.deadflag > DEAD_NO ){
        continue;
      }
      spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
      spark = te_apply_wind( spark );
      pointparticles( particleeffectnum("TE_MECHPIECE_DEAD_BURN"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
    }
  }
};

void() ai_ctrl_update_mechplayer={
  local entity wep;
  local entity piece;
  local float hp;
  local vector spark;
  local entity partParent;
  
  ai_ctrl_updateCenterTorso();
  
  self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
  self.ai_weaponEnergy = 0;
  self.currentWeaponGroup = 0;
  wep = self.w_slot;
  while(wep){
    ctrl_weapon_think_ai(wep);
    wep = wep.w_slot;
  }
  //damage-based cosmetics for unit component pieces
  self.torsoLeft.hitOffset = self.origin + (v_right * self.torsoLeft.compAltOffset_x) + (v_up * self.torsoLeft.compAltOffset_y);
  self.torsoRight.hitOffset = self.origin + (v_right * self.torsoRight.compAltOffset_x) + (v_up * self.torsoRight.compAltOffset_y);
  self.armRight.hitOffset = self.origin + (v_right * self.armRight.compAltOffset_x) + (v_up * self.armRight.compAltOffset_y);
  self.armLeft.hitOffset = self.origin + (v_right * self.armLeft.compAltOffset_x) + (v_up * self.armLeft.compAltOffset_y);
  self.torsoCenter.hitOffset = self.origin + (v_right * self.torsoCenter.compAltOffset_x) + (v_up * self.torsoCenter.compAltOffset_y);
  
  piece = self.partNext;
  for(piece = self.partNext; piece.owner == self; piece = piece.partNext){
    if( piece.classname != MECH_PIECE ){
      continue;
    }
    if( piece.deadflag <= DEAD_NO ){
      hp = piece.health / piece.max_health;
      if( hp < 0.75){
        spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
        pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
        if( hp < 0.5){
          spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
          if( hp < 0.25){
            spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
          }
        }
      }
    }
    else{
      partParent = util_getPartFromName(piece.partParentId, self); 
      if( partParent.deadflag > DEAD_NO ){
        continue;
      }
      spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
      spark = te_apply_wind( spark );
      pointparticles( particleeffectnum("TE_MECHPIECE_DEAD_BURN"), spark, normalize( spark - piece.origin) * 5 * WINDDIR_z, 1);
    }
  }
};

void() ctrl_updateCenterTorso={
  local float diff;
  local float mx, my;
  local float rate;
  local entity cam;
  local vector v1;

  if( time > self.laser_sight_timer ){
    makevectors(self.v_angle);
    v1 = self.cockpit.origin;
    traceline(v1, v1 + v_forward*10000, FALSE, self);
    self.laser_sight_org = trace_endpos;
    self.laser_sight_timer = time + 0.05;
  }

  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if( self.energy > -1 ){
      diff = self.energyRate;
      if( self.playerState == PLAYER_SPRINT_ON ){
        diff = diff * self.evasionDrain;
      }
      self.energy = self.energy + diff;
    }  
    if(self.shield < self.shieldMax){
      if(time > self.shieldHitDelay){
        if(self.energy > 0){
          self.shield = self.shield + self.shieldRate;
          self.energy = self.energy - (self.shieldRate * 3);
          if(self.shield > self.shieldMax){
            self.shield = self.shieldMax;
          }
        }
      }
    }
    if(self.energy < 0){
      self.energy = 0;
    }
    else if(self.energy > self.energyMax){
      self.energy = self.energyMax;
    }
  }
  
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
};

void() ai_ctrl_updateCenterTorso={
  local float diff;
  local float mx, my;
  local float rate;
  local entity cam;
  local vector v1;

  makevectors(self.torsoCenter.angles);
  v1 = self.origin + (v_right * cam.compOffset_x) + (v_up*cam.compOffset_y) + (v_forward*cam.compOffset_z);
  traceline(v1, v1 + v_forward * 10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  self.laser_sight_timer = time + 0.05;
    
  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if( self.energy > -1 ){
      diff = self.energyRate;
      if( self.playerState == PLAYER_SPRINT_ON ){
        diff = diff * self.evasionDrain;
      }
      self.energy = self.energy + diff;
    }  
    if(self.shield < self.shieldMax){
      if(time > self.shieldHitDelay){
        if(self.energy > 0){
          self.shield = self.shield + self.shieldRate;
          self.energy = self.energy - (self.shieldRate * 3);
          if(self.shield > self.shieldMax){
            self.shield = self.shieldMax;
          }
        }
      }
    }
    if(self.energy < 0){
      self.energy = 0;
    }
    else if(self.energy > self.energyMax){
      self.energy = self.energyMax;
    }
  }
};

void() ctrl_component_die={
  local entity piece;
  local entity this;
  local entity c;
  if( self.deadflag <= DEAD_NO ){
    piece = self;
    
    te_missile_explode( piece.origin, piece.owner.vec_size, '1 0.25 0.75', random() * (piece.vec_size * 1.5), 2); 
    te_mech_piece_explode( piece, piece.origin, piece.angles, piece.owner.velocity, piece.model, piece.skin );

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    self.health = 0;
    setorigin( self, self.origin );
    
    if( self.partTypeId == M_TOR_LEFT ){
      self.owner.armLeft.think = self.owner.armLeft.th_die;
      self.owner.armLeft.nextthink = time + 0.05;
      self.owner.armLeft.realowner = self.owner;
    }
    else if( self.partTypeId == M_TOR_RIGHT ){
      self.owner.armRight.think = self.owner.armRight.th_die;
      self.owner.armRight.nextthink = time + 0.05;
      self.owner.armRight.realowner = self.owner;
    }
    
    c = self.owner.w_slot;
    while(c){
      if(c.partParentId == self.partTypeId){
        c.think = c.th_die;
        c.nextthink = time + 0.1;
      }
      c = c.w_slot;
    }
    
    if((self.owner.flags & (FL_MONSTER | FL_DISARMED))){
      if( self.owner.th_pain && self.owner.health > 0){
        //if the bot loses all guns, have it panic
        this = self;
        self = this.owner;
          self.th_pain( self.enemy );
        self = this;
      }
    }
    if( (self.owner.flags & FL_CLIENT) ){
      client_send_critical_hit( self.owner );
    }
  }
};

void() ctrl_arm_die={    
  local entity piece;
  local entity this;
  local entity c;
  if( self.deadflag == DEAD_NO ){
    piece = self;
    
    te_missile_explode( piece.origin, piece.owner.vec_size, '1 0.25 0.75', random() * (piece.vec_size * 1.5), 2); 
    te_mech_piece_explode( piece, piece.origin, piece.angles, piece.owner.velocity, piece.model, piece.skin );

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;    
    self.health = 0;
    setsize(self, '0 0 0', '0 0 0');
    setorigin( self, self.origin );

    for( c = self.owner.w_slot; c.owner == self.owner; c = c.w_slot){
      if(c.partParentId != self.partTypeId){
        continue;
      }
      c.think = c.th_die;
      c.nextthink = time + 0.1;
    }
    
    if((self.owner.flags & (FL_MONSTER | FL_DISARMED))){
      if( self.owner.th_pain && self.owner.health > 0){
        //if the bot loses all guns, have it panic
        this = self;
        self = this.owner;
          self.th_pain( self.enemy );
        self = this;
      }
    }
    if( (self.owner.flags & FL_CLIENT) ){
      client_send_critical_hit( self.owner );
    }
  }
};

void() ctrlPlayerMechTouch={
  local float currentVel;
  local float rammage;
  local float feedbackDmgType;
  local float dot;
  local entity dead;
  
  //Ram damage....rammage? RAMMAGE
  if( time > self.ramCharge ){
    return;
  }
  if( other.takedamage < DAMAGE_YES ){
    return;
  }
  if( !(other.flags & FL_UNIT) ){
    return;
  }
  
  if( other.data_type != DATA_VEHC ){
    self.ramCharge = time;
    self.ramCool = time + self.ramUp;
    return;
  }
  makevectors ( self.ramAngle );
  dot = normalize (other.origin - self.origin) * v_forward;
	if( dot < 0.75 ){
		return;
  }
  rammage = max(self.vec_size, other.vec_size) + self.ramUp;
  rammage = rammage / 15;
  rammage = other.max_health * rammage;
  dead = t_damage(other, self, self, rammage, DMG_BAL, self.legs.origin, '0 0 0');
  
  if( self.shield <= 0 ){
    rammage = max(self.vec_size, dead.vec_size);
    if( rammage > self.vec_size ){
      rammage = rammage - self.vec_size;
      t_damage(self, self, self, rammage / 2, 0, self.legs.origin, '0 0 0');
    }
  }
  
  if( dead.deadflag < DEAD_NO ){
    self.velocity_z = other.maxs_z * 1.33;
    self.ramCharge = time;
    self.ramCool = time + self.ramUp / 2;
    return;
  }
  
};

void() ctrl_component_burn={
  local vector spark;
  spark = te_apply_wind( self.origin );
  pointparticles( particleeffectnum("TE_MECHPIECE_DEAD_BURN"), spark, normalize( spark - self.origin) * WINDDIR_z, 1);
  self.think = ctrl_component_burn;
  self.nextthink = time + 0.1;
  if( time > self.ai_action_time ){
    self.think = ctrl_component_drop;
    self.nextthink = time + 0.1;
    self.ai_action_time = time + 300;  //burn for 5min
    return;
  }
};

void() ctrl_component_drop={
  self.think = SUB_Remove;
  self.nextthink = self.ai_action_time;
};

void() touch_mechPiece={
  if( (other.flags & FL_UNIT) ){
    self.damageValue = random() * 25;  
    BecomeExplosion();
    self.touch = SUB_Null;
    return;
  }
};