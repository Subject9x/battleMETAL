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
  
  self.burnBits = 0;
  for(piece = self.partNext; piece.owner == self; piece = piece.partNext){
    if( piece.classname != MECH_PIECE ){
      continue;
    }
    if( piece.deadflag <= DEAD_NO ){
      hp = piece.health / piece.max_health;
      if( hp < 0.6){
        self.clientData.burnBits = self.clientData.burnBits | piece.partTypeId;
        self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_BURN;
      }
    }
  }
  if( self.burnBits > 0 ){
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_BURN;
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
  
  self.burnBits = 0;
  for(piece = self.partNext; piece.owner == self; piece = piece.partNext){
    if( piece.classname != MECH_PIECE ){
      continue;
    }
    if( piece.deadflag <= DEAD_NO ){
      hp = piece.health / piece.max_health;
      if( hp < 0.6){
        self.burnBits = self.burnBits | piece.partTypeId;
      }
    }
  }
  if( self.burnBits > 0 ){
    self.SendFlags = self.SendFlags | SENDFLAG_BURN;
  }
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_TURRET);
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
    self.laser_sight_timer = time + 0.1;
  }

  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if( self.energy > -1 ){
      diff = self.energyRate;
      if( self.moveState == MOVE_SPRINT ){
        diff = diff - self.evasionDrain;
      }
      self.energy = self.energy + diff;
    }  
    if(self.shield < self.shieldMax){
      if( (time > self.shieldHitDelay) && (time > self.shieldHitRegen) ){
        if(self.energy > 0){
          self.shield = self.shield + self.shieldRate;
          self.energy = self.energy - self.shieldRate;
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
      if( self.moveState == MOVE_SPRINT ){
        diff = diff - self.evasionDrain;
      }
      self.energy = self.energy + diff;
    }  
    if(self.shield < self.shieldMax){
      if( (time > self.shieldHitDelay) && (time > self.shieldHitRegen) ){
        if(self.energy > 0){
          self.shield = self.shield + (self.shieldRate * 0.5);
          self.energy = self.energy - (self.shieldRate * 2);
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

/*
  Specific death function for the player.
  Case: player disconnects.
  Case: player is killed in combat.
*/
void() ctrl_mech_die_player={
  local entity w_chain;

  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }
  ctrl_unit_part_death(self.torsoCenter);
  ctrl_unit_part_death(self.torsoLeft);
  ctrl_unit_part_death(self.torsoRight);
  ctrl_unit_part_death(self.armLeft);
  ctrl_unit_part_death(self.armRight);
  
  if( (self.flags & FL_CLIENT) ){
    ctrl_unit_part_death(self.legs);
  }
  self.alpha = 0.01;
  self.scale = 0.01;
};

/*
  This is the cosmetic aspect of a component being destroyed.
  the actualy entity is not removed until later.
*/  
void() ctrl_component_die={
  local entity piece;
  local entity this;
  local entity c;
  if( self.deadflag <= DEAD_NO ){
    piece = self;
    te_vehicle_chunk(self, '0 0 0', '0 0 0', particleeffectnum("TE_DEBRIS_TRAIL_MED"), self.owner.vec_size * 33, (self.owner.vec_size / 10) + 0.33);
    self.owner.critBits = self.owner.critBits & self.partTypeId;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW; 
    self.movetype = MOVETYPE_NONE;
    self.aiment = world;
    self.health = 0;
    setorigin( self, self.origin );

    if( self.partTypeId == M_TOR_LEFT ){
      self.owner.armLeft.think = self.owner.armLeft.th_die;
      self.owner.armLeft.nextthink = time + 0.1;
      self.owner.armLeft.realowner = self.owner;
      self.owner.damageValue = self.owner.damageValue | (M_TOR_LEFT | M_ARM_LEFT);
      if( !(self.owner.damageValue & (M_TOR_RIGHT | M_ARM_RIGHT) ) ){
        side_crit = TR_LEFT;
      }
    }
    else if( self.partTypeId == M_TOR_RIGHT ){
      self.owner.armRight.think = self.owner.armRight.th_die;
      self.owner.armRight.nextthink = time + 0.1;
      self.owner.armRight.realowner = self.owner;
      self.owner.damageValue = self.owner.damageValue | (M_TOR_RIGHT | M_ARM_RIGHT);
      if( !(self.owner.damageValue & (M_TOR_LEFT | M_ARM_LEFT) ) ){
        side_crit = TR_RIGHT;
      }
    }
    if( !(self.owner.SendFlags & SENDFLAG_CRIT) ){
      self.owner.SendFlags = self.owner.SendFlags | SENDFLAG_CRIT;
    }
    
    c = self.owner.w_slot;
    this = self;
    while(c){
      self = c;
        if(self.partParentId == this.partTypeId){
          self.think = self.th_die;
          self.nextthink = time + (random() * 0.5);
        }
      self = this;
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
  }
};

void() ctrl_arm_die={    
  local entity piece;
  local entity this;
  local entity c;
  if( self.deadflag == DEAD_NO ){
    te_vehicle_chunk(self, '0 0 0', '0 0 0', particleeffectnum("TE_DEBRIS_TRAIL_MED"), self.owner.vec_size * 25, (self.owner.vec_size / 10) + 0.25);
    self.owner.critBits = self.owner.critBits & self.partTypeId;
    if( self.partTypeId == M_ARM_LEFT && !(self.owner.damageValue & M_ARM_LEFT) ){
      self.owner.damageValue = self.owner.damageValue | M_ARM_LEFT;
    }
    else if( self.partTypeId == M_ARM_RIGHT && !(self.owner.damageValue & M_ARM_LEFT) ){
      self.owner.damageValue = self.owner.damageValue | M_ARM_RIGHT;
    }
    if( !(self.owner.SendFlags & SENDFLAG_CRIT) ){
      self.owner.SendFlags = self.owner.SendFlags | SENDFLAG_CRIT;
    }

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;  
    self.movetype = MOVETYPE_NONE;
    self.aiment = world;
    self.health = 0;
    setsize(self, '0 0 0', '0 0 0');
    setorigin( self, self.origin );
    
    this = self;
    for( c = self.owner.w_slot; c.owner == self.owner; c = c.w_slot){
      if( c == world ){
        continue;
      }
      self = c;
        if(self.partParentId != this.partTypeId){
          continue;
        }
        self.think = self.th_die;
        self.nextthink = time + (random() * 0.5);
      self = this;
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
  }
};

void() ctrl_player_mech_touch={
  local float dot;
  local entity dead;
  local vector vec;
  
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
    self.velocity = '0 0 0';
    return;
  }
  makevectors ( self.ramAngle );
  vec = normalize (self.origin - other.origin);
  dot = vec * v_forward;
  
	if( dot < 0.6 ){
    t_damage(other, self, self, other.max_health * 0.15, self.legs.origin, '0 0 0');
    return;
  }  
  
  if( other.shield <= 0 ){
    if( self.vec_size > other.vec_size ){
      t_damage(other, self, self, other.max_health * 0.5 , self.legs.origin, '0 0 0');
    }
    else{
      t_damage(other, self, self, other.max_health * 0.33, self.legs.origin, '0 0 0');
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

float( float isNew, float changeFlags ) ctrl_send_mech_ai={
  WriteByte( MSG_ENTITY, SENDTYPE_MECH_AI );
  WriteByte( MSG_ENTITY, changeFlags );

  WriteCoord( MSG_ENTITY, self.origin_x );
  WriteCoord( MSG_ENTITY, self.origin_y );
  WriteCoord( MSG_ENTITY, self.origin_z );
  
  WriteAngle( MSG_ENTITY, self.angles_x );
  WriteAngle( MSG_ENTITY, self.angles_y );
  WriteAngle( MSG_ENTITY, self.angles_z );

  //  WriteLong( MSG_ENTITY, self.flags ); // DEBUG - disabled for now.
  WriteShort( MSG_ENTITY, self.shield );

  if( (changeFlags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, num_for_edict(self));
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );

    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteString( MSG_ENTITY, self.netname );
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){}
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_z );
  }

  if( (changeFlags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.damageValue );
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    WriteLong( MSG_ENTITY, self.burnBits );
  }
  return TRUE;
};