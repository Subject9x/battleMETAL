/*
battleMETAL
Author: Peter Roohr
Date: 9/5/2016
Overview: 
  implementation for center torso updates
*/

void() ctrl_update_mechplayer={
  local entity parent;
  local entity piece;
  local float hp;
  local float newBurn;
  
  parent = self;
  
  ctrl_updateCenterTorso();
  
  if( self.legs.deadflag == DEAD_NO ){
    self = self.legs;
      ctrl_updateLegs();
    self = parent;
  }
  
  //damage-based cosmetics for unit component pieces
  piece = self.partNext;
  makevectors(self.angles);
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    self.torsoLeft.hitOffset = self.origin + (v_right * self.torsoLeft.compAltOffset_x) + (v_up * self.torsoLeft.compAltOffset_y) + (v_forward * self.torsoLeft.compAltOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    self.torsoRight.hitOffset = self.origin + (v_right * self.torsoRight.compAltOffset_x) + (v_up * self.torsoRight.compAltOffset_y) + (v_forward * self.torsoRight.compAltOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armRight.hitOffset = self.origin + (v_right * self.armRight.compAltOffset_x) + (v_up * self.armRight.compAltOffset_y) + (v_forward * self.armRight.compAltOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armLeft.hitOffset = self.origin + (v_right * self.armLeft.compAltOffset_x) + (v_up * self.armLeft.compAltOffset_y) + (v_forward * self.armLeft.compAltOffset_z);
  }
  self.torsoCenter.hitOffset = self.origin + (v_right * self.torsoCenter.compAltOffset_x) + (v_up * self.torsoCenter.compAltOffset_y) + (v_forward * self.torsoCenter.compAltOffset_z);

  newBurn = 0;
  for(piece = self.partNext; piece.owner == self; piece = piece.partNext){
    if( piece.classname != MECH_PIECE ){
      continue;
    }
    if( (self.burnBits & piece.partTypeId) ){
      continue;
    }
    if( piece.deadflag != DEAD_NO ){
      continue;
    }
    hp = piece.health / piece.max_health;
    if( hp < 0.67){
      if( !(self.burnBits & piece.partTypeId) ){
        newBurn = newBurn | piece.partTypeId; 
      }
    }
  }
  if( newBurn > 0 ){
    self.burnBits = self.burnBits | newBurn;
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_BURN;
  }
};

void() ai_ctrl_update_mechplayer={
  local entity wep;
  local entity piece;
  local float hp;
  local float newBurn;
  
  ai_ctrl_updateCenterTorso();
  
  self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
  self.ai_weaponEnergy = 0;
  self.currentWeaponGroup = 0;
  wep = self.w_slot;
  while(wep){
    ctrl_weapon_think_ai(wep);
    wep = wep.w_slot;
  }
  makevectors(self.angles);
  //damage-based cosmetics for unit component pieces
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    self.torsoLeft.hitOffset = self.origin + (v_right * self.torsoLeft.compAltOffset_x) + (v_up * self.torsoLeft.compAltOffset_y) + (v_forward * self.torsoLeft.compAltOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    self.torsoRight.hitOffset = self.origin + (v_right * self.torsoRight.compAltOffset_x) + (v_up * self.torsoRight.compAltOffset_y) + (v_forward * self.torsoRight.compAltOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armRight.hitOffset = self.origin + (v_right * self.armRight.compAltOffset_x) + (v_up * self.armRight.compAltOffset_y) + (v_forward * self.armRight.compAltOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armLeft.hitOffset = self.origin + (v_right * self.armLeft.compAltOffset_x) + (v_up * self.armLeft.compAltOffset_y) + (v_forward * self.armLeft.compAltOffset_z);
  }
  self.torsoCenter.hitOffset = self.origin + (v_right * self.torsoCenter.compAltOffset_x) + (v_up * self.torsoCenter.compAltOffset_y) + (v_forward * self.torsoCenter.compAltOffset_z);


  for(piece = self.partNext; piece.owner == self; piece = piece.partNext){
    if( piece.classname != MECH_PIECE ){
      continue;
    }
    if( (self.burnBits & piece.partTypeId) ){
      continue;
    }
    if( piece.deadflag != DEAD_NO ){
      continue;
    }
    hp = piece.health / piece.max_health;
    if( hp < 0.67){
      newBurn = newBurn | piece.partTypeId;
    }
  }
  if( !(self.burnBits & newBurn) ){
    self.burnBits = self.burnBits | newBurn;
    self.SendFlags = self.SendFlags | SENDFLAG_BURN;
  }
};

void() ctrl_updateCenterTorso={
  local float mx, my;
  local float rate;
  local vector laserHit;
  local vector laserOrg;
  
  if( time > self.laser_sight_timer ){
    makevectors(self.v_angle);
    if(self.chaseActive){
      laserOrg = self.origin + (v_up * 22) + (v_forward * -96);
      traceline(self.origin, laserOrg, TRUE, self);
      laserOrg = trace_endpos;
    }
    else{
      laserOrg = self.cockpit.origin;
    }
    laserHit = laserOrg + (v_forward * 10000);
    traceline(laserOrg, laserHit, FALSE, self);
    self.laser_sight_org = trace_endpos;
    self.laser_sight_timer = time + 0.05;
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
  local entity cam;
  local vector v1;
  
  makevectors(self.torsoCenter.angles);
  v1 = self.origin + (v_right * cam.compOffset_x) + (v_up*cam.compOffset_y) + (v_forward*cam.compOffset_z);
  traceline(v1, v1 + v_forward * 10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  self.laser_sight_timer = time + 0.05;
  
};

/*
  EXT_WORLD.StartFrame()
  
  called top of every frame, this synchronizes everyone's energy to ensure some more fairness.
  
*/
void() ctrl_unit_update_frame={
  local float diff;
  local float myShield;
  local float lastShield;
  local float lastEne;
  
  if( time > self.energyRegenTimer ){
    self.energyRegenTimer = time + 0.1;
    lastEne = self.energy;
    if( (self.flags & FL_CLIENT) ){
      if( (self.unitModFlags & MOD_HEAT_NOT_ENERGY)){
        diff = self.energyRate;
        if( self.moveState == MOVE_SPRINT ){
          diff = diff + self.evasionDrain;
        }
        self.energy = self.energy - diff;
      }
      else{
        //vanilla battleMETAL
        diff = self.energyRate;
        if( self.moveState == MOVE_SPRINT ){
          diff = diff - self.evasionDrain;
        }
        self.energy = self.energy + diff;
      }
      if( (self.unitModFlags & MOD_HAS_SHIELD) ){
        lastShield = self.shield;
        if(self.shield < self.shieldMax){
          if( (time > self.shieldHitDelay) && (time > self.shieldHitRegen) ){
            if(self.energy > 0){
              self.shield = self.shield + self.shieldRate;
              self.energy = self.energy - self.shieldRate;
            }
          }
        }
        self.shield = bound(0, self.shield, self.shieldMax);
        if( lastShield != self.shield ){
          //only send delta.
          self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_SHIELD;
        }
      }
      self.energy = bound(0, self.energy, self.energyMax);
      if( lastEne != self.energy){
        self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_ENERGY;
      }
    }
    else{
      //AI
      if( (self.unitModFlags & MOD_HEAT_NOT_ENERGY)){
        diff = self.energyRate;
        if( self.moveState == MOVE_SPRINT ){
          diff = diff + self.evasionDrain;
        }
        self.energy = self.energy - diff;
      }
      else{
        //vanilla battleMETAL
        diff = self.energyRate;
        if( self.moveState == MOVE_SPRINT ){
          diff = diff - self.evasionDrain;
        }
        self.energy = self.energy + diff;
      }
      
      if( (self.unitModFlags & MOD_HAS_SHIELD) ){
        lastShield = self.shield;
        if( time <= self.shieldHitRegen ) {
          myShield = self.shieldHitRegen - self.shieldHitRegenStart;
          myShield = (time - self.shieldHitRegenStart) / myShield;
          self.stat_client_shield =  100 - (myShield * 100) + 100;
        }
        else{
          if( !(self.damageValue & (M_TOR_LEFT|M_TOR_RIGHT))){
            if(self.shield < self.shieldMax){
              if( (time > self.shieldHitDelay) && (time > self.shieldHitRegen) ){
                if(self.energy > 0){
                  self.shield = self.shield + (self.shieldRate * 0.5);
                  self.energy = self.energy - (self.shieldRate * 2);
                }
              }
            }
          }
          self.stat_client_shield = (self.shield / self.shieldMax) * 100;
        }
        self.shield = max(0, self.shield);
      }
      self.energy = bound(0, self.energy, self.energyMax);
      if( lastEne != self.energy){
        self.SendFlags = self.SendFlags | SENDFLAG_ENERGY;
      }
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
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    ctrl_unit_part_death(self.torsoLeft);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    ctrl_unit_part_death(self.torsoRight);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    ctrl_unit_part_death(self.armLeft);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    ctrl_unit_part_death(self.armRight);
  }
  //ensures only new weapon data coming upstream is written.
  self.nextVecChoice = 0;
  self.next_wepn1 = 0;
  self.next_wepn2 = 0;
  self.next_wepn3 = 0;
  self.next_wepn4 = 0;
  self.next_wepn5 = 0;
  self.next_wepn6 = 0;
  self.next_wepn7 = 0;
  self.next_wepn8 = 0;
  self.next_wepn9 = 0;
  
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
  if( self.deadflag != DEAD_NO ){
    return;
  }
  piece = self;
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN && (self.unitModFlags & self.partTypeId) ){
    te_vehicle_chunk(self, '0 0 0', '0 0 0', particleeffectnum("TE_DEBRIS_TRAIL_MED"), self.owner.vec_size * 33, (self.owner.vec_size / 10) + 0.33);
  }
  self.owner.critBits = self.owner.critBits | self.partTypeId;
  self.owner.burnBits = self.owner.burnBits - (self.owner.burnBits & self.partTypeId);

  self.deadflag = DEAD_DEAD;
  self.effects = EF_NODRAW;
  self.health = 0;

  if( self.partTypeId == M_TOR_LEFT ){
    if( (self.owner.unitModFlags & MOD_HAS_ARM_L) ){
      self.owner.armLeft.think = self.owner.armLeft.th_die;
      self.owner.armLeft.nextthink = time + 0.1;
      self.owner.armLeft.realowner = self.owner;
    }
    if( (self.owner.critBits & (M_TOR_RIGHT | M_ARM_RIGHT)) && (self.owner.unitModFlags & MOD_HAS_SHIELD) ){
      self.owner.shieldMax = self.owner.shieldMax * 0.5;
    }
  }
  else if( self.partTypeId == M_TOR_RIGHT ){
    if( (self.owner.unitModFlags & MOD_HAS_ARM_R) ){
      self.owner.armRight.think = self.owner.armRight.th_die;
      self.owner.armRight.nextthink = time + 0.1;
      self.owner.armRight.realowner = self.owner;
    }
    if( (self.owner.critBits & (M_TOR_LEFT | M_ARM_LEFT)) && (self.owner.unitModFlags & MOD_HAS_SHIELD) ){
      self.owner.shieldMax = self.owner.shieldMax * 0.5;
    }
  }
  
  this = self;
  for( c = self.owner.w_slot; c.owner == self.owner; c = c.w_slot){
    if( c == world ){
      continue;
    }
    if(c.partParentId != this.partTypeId){
      continue;
    }
    if( c.th_die ){
      c.think = c.th_die;
      c.nextthink = time + (random() * 0.5);
    }
  }
  
  if((self.owner.flags & (FL_MONSTER | FL_DISARMED))){
    if( self.owner.th_pain && self.owner.health > 0){
      //if the bot loses all guns, have it panic
      self = this.owner;
        self.th_pain( self.enemy );
      self = this;
    }
  }
};

void() ctrl_arm_die={
  local entity this;
  local entity c;
  
  if( self.deadflag != DEAD_NO ){
    return;
  }
  if( ENT_SERVER_INFO.gameType == GAMEMODE_CAMPAIGN && (self.owner.unitModFlags & self.partTypeId) ){
    te_vehicle_chunk(self, '0 0 0', '0 0 0', particleeffectnum("TE_DEBRIS_TRAIL_MED"), self.owner.vec_size * 25, (self.owner.vec_size / 10) + 0.25);
  }
  
  self.owner.critBits = self.owner.critBits | self.partTypeId;
  self.owner.burnBits = self.owner.burnBits - (self.owner.burnBits & self.partTypeId);

  self.deadflag = DEAD_DEAD;
  self.effects = EF_NODRAW;
  self.health = 0;
  
  this = self;
  for( c = self.owner.w_slot; c.owner == self.owner; c = c.w_slot){
    if( c == world ){
      continue;
    }
    if(c.partParentId != this.partTypeId){
      continue;
    }
    if( c.th_die ){
      c.think = c.th_die;
      c.nextthink = time + (random() * 0.5);
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

float( float isNew, float changedflags ) ctrl_send_mech_ai={
  local float sendCrit;
  
  WriteByte( MSG_ENTITY, SENDTYPE_MECH_AI );
  WriteCoord( MSG_ENTITY, changedflags );
  //======================
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    
    WriteByte( MSG_ENTITY, self.moveState);
  }
  
  if( (changedflags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteShort( MSG_ENTITY, self.legs.angles_y);
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
    //placed here for just-in-time calculation
    // because not all SendFlags might be sent exactly when called, and the code originally was clearing out critBits
    sendCrit = self.critBits;
    self.criticalHits = self.criticalHits | self.critBits;
    self.critBits = 0;
    WriteCoord( MSG_ENTITY, sendCrit );
  }
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteCoord( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteString( MSG_ENTITY, self.netname );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
  }
  
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteCoord( MSG_ENTITY, self.attackFlag );
  }
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_z );
  }
  
  if( (changedflags & SENDFLAG_CRIT) ){
    //placed here for just-in-time calculation
    // because not all SendFlags might be sent exactly when called, and the code originally was clearing out critBits
    sendCrit = self.critBits;
    self.criticalHits = self.criticalHits | self.critBits;
    self.critBits = 0;
    WriteCoord( MSG_ENTITY, sendCrit );
  }
  
  if( (changedflags & SENDFLAG_BURN) ){
    WriteCoord( MSG_ENTITY, self.burnBits );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  self.shieldHitFlag = 0;
  return TRUE;
};