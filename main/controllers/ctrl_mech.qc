/*
battleMETAL
Author: Peter Roohr
Date: 9/5/2016
Overview: 
  implementation for center torso updates
*/

void() ctrl_update_mechplayer={
  local entity piece;
  
  ctrl_updateCenterTorso(); 
  ctrl_updateLegs();
  
  //damage-based cosmetics for unit component pieces
  makevectors(self.angles);
  self.torC_hitOffset = self.origin + (v_right * self.torC_compAltOffset_x) + (v_up * self.torC_compAltOffset_y) + (v_forward * self.torC_compAltOffset_z);
  self.torC_org = self.origin + (v_right * self.torC_compOffset_x) + (v_up * self.torC_compOffset_y) + (v_forward * self.torC_compOffset_z);
  
  self.legs_hitOffset = self.origin + (v_right * self.legs_compAltOffset_x) + (v_up * self.legs_compAltOffset_y) + (v_forward * self.legs_compAltOffset_z);
  self.legs_org = self.origin + (v_right * self.legs_compOffset_x) + (v_up * self.legs_compOffset_y) + (v_forward * self.legs_compOffset_z);
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    self.torL_hitOffset = self.origin + (v_right * self.torL_compAltOffset_x) + (v_up * self.torL_compAltOffset_y) + (v_forward * self.torL_compAltOffset_z);
    self.torL_org = self.origin + (v_right * self.torL_compOffset_x) + (v_up * self.torL_compOffset_y) + (v_forward * self.torL_compOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    self.torR_hitOffset = self.origin + (v_right * self.torR_compAltOffset_x) + (v_up * self.torR_compAltOffset_y) + (v_forward * self.torR_compAltOffset_z);
    self.torR_org = self.origin + (v_right * self.torR_compOffset_x) + (v_up * self.torR_compOffset_y) + (v_forward * self.torR_compOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armR_hitOffset = self.origin + (v_right * self.armR_compAltOffset_x) + (v_up * self.armR_compAltOffset_y) + (v_forward * self.armR_compAltOffset_z);
    self.armR_org = self.origin + (v_right * self.armR_compOffset_x) + (v_up * self.armR_compOffset_y) + (v_forward * self.armR_compOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armL_hitOffset = self.origin + (v_right * self.armL_compAltOffset_x) + (v_up * self.armL_compAltOffset_y) + (v_forward * self.armL_compAltOffset_z);
    self.armL_org = self.origin + (v_right * self.armL_compOffset_x) + (v_up * self.armL_compOffset_y) + (v_forward * self.armL_compOffset_z);
  }

  piece = self.w_slot;
  while(piece){
    util_getPartFromName(piece.partParentId, self);
    makevectors(T_PART_PARENT_ANGL);
    piece.origin = self.origin + (v_up * piece.compOffset_y) + (v_forward * piece.compOffset_z) + (v_right * piece.compOffset_x);
    setorigin(piece, piece.origin);
    piece = piece.w_slot;
  }
  
  if(self.critBuffer > 0){
    
    if( (self.critBuffer & M_TOR_LEFT) && !(self.criticalHits & M_ARM_LEFT) ){
      self.critBuffer = self.critBuffer | M_ARM_LEFT;
    }
    if( (self.critBuffer & M_TOR_RIGHT) && !(self.criticalHits & M_ARM_RIGHT) ){
      self.critBuffer = self.critBuffer | M_ARM_RIGHT;
    }
    
    ctrl_mech_critical_hits();
    self.critBits = self.critBits | self.critBuffer;
    self.critBuffer = 0;
    self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
  }
  
  ctrl_mech_burn_frame();
};

void() ai_ctrl_update_mechplayer={
  local entity piece;
  
  ai_ctrl_updateCenterTorso();
  
  self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
  self.ai_weaponEnergy = 0;
  self.currentWeaponGroup = 0;
  
  piece = self.w_slot;
  while(piece){
    ctrl_weapon_think_ai(piece);
    piece = piece.w_slot;
  }
  
  makevectors(self.angles);
  self.torC_hitOffset = self.origin + (v_right * self.torC_compAltOffset_x) + (v_up * self.torC_compAltOffset_y) + (v_forward * self.torC_compAltOffset_z);
  self.torC_org = self.origin + (v_right * self.torC_compOffset_x) + (v_up * self.torC_compOffset_y) + (v_forward * self.torC_compOffset_z);
  
  self.legs_hitOffset = self.origin + (v_right * self.legs_compAltOffset_x) + (v_up * self.legs_compAltOffset_y) + (v_forward * self.legs_compAltOffset_z);
  self.legs_org = self.origin + (v_right * self.legs_compOffset_x) + (v_up * self.legs_compOffset_y) + (v_forward * self.legs_compOffset_z);
  
  makevectors(self.torC_angl);
  //damage-based cosmetics for unit component pieces
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    self.torL_hitOffset = self.origin + (v_right * self.torL_compAltOffset_x) + (v_up * self.torL_compAltOffset_y) + (v_forward * self.torL_compAltOffset_z);
    self.torL_org = self.origin + (v_right * self.torL_compOffset_x) + (v_up * self.torL_compOffset_y) + (v_forward * self.torL_compOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    self.torR_hitOffset = self.origin + (v_right * self.torR_compAltOffset_x) + (v_up * self.torR_compAltOffset_y) + (v_forward * self.torR_compAltOffset_z);
    self.torR_org = self.origin + (v_right * self.torR_compOffset_x) + (v_up * self.torR_compOffset_y) + (v_forward * self.torR_compOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armR_hitOffset = self.origin + (v_right * self.armR_compAltOffset_x) + (v_up * self.armR_compAltOffset_y) + (v_forward * self.armR_compAltOffset_z);
    self.armR_org = self.origin + (v_right * self.armR_compOffset_x) + (v_up * self.armR_compOffset_y) + (v_forward * self.armR_compOffset_z);
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armL_hitOffset = self.origin + (v_right * self.armL_compAltOffset_x) + (v_up * self.armL_compAltOffset_y) + (v_forward * self.armL_compAltOffset_z);
    self.armL_org = self.origin + (v_right * self.armL_compOffset_x) + (v_up * self.armL_compOffset_y) + (v_forward * self.armL_compOffset_z);
  }
  
  piece = self.w_slot;
  while(piece){
    util_getPartFromName(piece.partParentId, self);
    makevectors(T_PART_PARENT_ANGL);
    piece.origin = self.origin + (v_up * piece.compOffset_y) + (v_forward * piece.compOffset_z) + (v_right * piece.compOffset_x);
    setorigin(piece, piece.origin);
    piece = piece.w_slot;
  }
  
  if(self.critBuffer > 0){
    
    if( (self.critBuffer & M_TOR_LEFT) && !(self.criticalHits & M_ARM_LEFT) ){
      self.critBuffer = self.critBuffer | M_ARM_LEFT;
    }
    if( (self.critBuffer & M_TOR_RIGHT) && !(self.criticalHits & M_ARM_RIGHT) ){
      self.critBuffer = self.critBuffer | M_ARM_RIGHT;
    }
    
    ctrl_mech_critical_hits();
    self.critBits = self.critBits | self.critBuffer;
    self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
    self.critBuffer = 0;
  }
  ctrl_mech_burn_frame();
  
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
      laserOrg = self.cameraOrigin;
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
  
  makevectors(self.torC_angl);
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
          self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
        }
      }
      self.energy = bound(0, self.energy, self.energyMax);
      if( lastEne != self.energy){
        self.SendFlags = self.SendFlags | SENDFLAG_ENERGY;
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
  
  self.alpha = 1;
  self.scale = 1;
};


void() ctrl_mech_critical_hits={
  local entity item;
  local float legSoak;
  
  legSoak = FALSE;
  if( (self.critBuffer & M_ARM_LEFT) ){
    te_vehicle_chunk( self.armL_mdl, self.armL_org, '0 0 0', self.armL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_LEFT);
  }

  if( (self.critBuffer & M_ARM_RIGHT) ){
    te_vehicle_chunk(  self.armR_mdl, self.armR_org, '0 0 0', self.armR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_RIGHT);
  }
  if( (self.critBuffer & M_TOR_LEFT) ){
    if( (self.unitModFlags & MOD_HAS_SHIELD) ){
      self.shieldMax = self.shieldMax * 0.5;
    }
    te_vehicle_chunk(  self.torL_mdl, self.torL_org, '0 0 0', self.torL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_LEFT);
  }
  if( (self.critBuffer & M_TOR_RIGHT) ){
    if( (self.unitModFlags & MOD_HAS_SHIELD) ){
      self.shieldMax = self.shieldMax * 0.5;
    }
    te_vehicle_chunk(  self.torR_mdl, self.torR_org, '0 0 0', self.torR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_RIGHT);
  }
  
  item = self.w_slot;
  while(item){
    if( (self.critBuffer & item.partParentId) ){
      item.deadflag = DEAD_DEAD;
    }
    else if( (self.critBuffer & M_LEGS) && item.data_idx == UID_ITEM_turbo_charger){
      //turbo chargers can soak leg criticals!
      if( !legSoak ){
        legSoak = TRUE;
        item.deadflag = DEAD_DEAD;
      }
    }
    item = item.w_slot;
  }
  
  if( legSoak ){
    self.critBuffer = self.critBuffer - (self.critBuffer & M_LEGS);
  }
  
  if( (self.critBuffer & M_LEGS) ){
     
    //account for possible turbo charger upgrades.
    self.cache_speed_fwd = self.data_speed_forward;
    self.cache_speed_sid = self.data_speed_strafe;
    self.cache_speed_back = self.data_speed_backward;
    
    if( (self.flags & FL_CLIENT) ){
      self.data_speed_forward = self.data_speed_forward * 0.7;
      self.data_speed_strafe = self.data_speed_strafe * 0.8;
      self.data_speed_backward = self.data_speed_backward * 0.75;
      self.SendFlags = self.SendFlags | SENDFLAG_EFLAGS;
    }
    else{
      //AI suffers way more for blown legs
      self.data_speed_forward = self.data_speed_forward * 0.5;
      self.data_speed_strafe = self.data_speed_strafe * 0.67;
      self.data_speed_backward = self.data_speed_backward * 0.5;
      if( !(self.damageValue & M_LEGS) ){
        self.damageValue = self.damageValue | M_LEGS;
      }
    }
  }
};

void() ctrl_mech_burn_frame={

  if( !(self.criticalHits & M_ARM_LEFT) && !(self.burnBits & M_ARM_LEFT) && (self.unitModFlags & MOD_HAS_ARM_L) ){
    if( self.armL_hp < self.armL_hpMax * 0.67 ){
      self.burnBits = self.burnBits | M_ARM_LEFT;
    }
  }
  if( !(self.criticalHits & M_ARM_RIGHT) && !(self.burnBits & M_ARM_RIGHT) && (self.unitModFlags & MOD_HAS_ARM_R) ){
    if( self.armR_hp < self.armR_hpMax * 0.67 ){
      self.burnBits = self.burnBits | M_ARM_RIGHT;
    }
  }
  if( !(self.criticalHits & M_TOR_LEFT) && !(self.burnBits & M_ARM_RIGHT) && (self.unitModFlags & MOD_HAS_ARM_R) ){
    if( self.armR_hp < self.armR_hpMax * 0.5 ){
      self.burnBits = self.burnBits | M_ARM_RIGHT;
    }
  }
  if( !(self.criticalHits & M_LEGS) ){
    if( self.legs_hp < self.legs_hpMax * 0.5 ){
      self.burnBits = self.burnBits | M_LEGS;
    }
  }
  if( self.health < self.max_health * 0.33 ){
    self.burnBits = self.burnBits | M_TOR_CENTER;
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
    t_damage(other, self, self, other.max_health * 0.15, self.legs_org, '0 0 0');
    return;
  }  
  
  if( other.shield <= 0 ){
    if( self.vec_size > other.vec_size ){
      t_damage(other, self, self, other.max_health * 0.5 , self.legs_org, '0 0 0');
    }
    else{
      t_damage(other, self, self, other.max_health * 0.33, self.legs_org, '0 0 0');
    }
  }
  
  if( dead.deadflag < DEAD_NO ){
    self.velocity_z = other.maxs_z * 1.33;
    self.ramCharge = time;
    self.ramCool = time + self.ramUp / 2;
    return;
  }
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

  WriteByte( MSG_ENTITY, SENDTYPE_MECH_AI );
  WriteLong( MSG_ENTITY, changedflags );
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
    WriteShort( MSG_ENTITY, self.legs_angl_y);
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
    //placed here for just-in-time calculation
    // because not all SendFlags might be sent exactly when called, and the code originally was clearing out critBits
    WriteLong( MSG_ENTITY,  self.critBits );
    self.criticalHits = self.criticalHits | self.critBits;
    self.critBits = 0;
  }
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteLong( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteChar( MSG_ENTITY, self.subType );
    WriteString( MSG_ENTITY, self.netname );
    WriteByte( MSG_ENTITY, self.deadflag );
    
    if( self.deadflag != DEAD_NO ){
      WriteLong( MSG_ENTITY,   self.criticalHits );
    }
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    if( self.shieldHitFlag == 0 ){
      WriteByte( MSG_ENTITY, (self.torC_hp / self.torC_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.torL_hp / self.torL_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.torR_hp / self.torR_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.armL_hp / self.armL_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.armR_hp / self.armR_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.legs_hp / self.legs_hpMax) * 100 );
    }
  }
  
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteLong( MSG_ENTITY, self.attackFlag );
  }
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torC_angl_y );
    WriteAngle( MSG_ENTITY, self.torC_angl_z );
  }
  
  if( (changedflags & SENDFLAG_CRIT) ){
    //placed here for just-in-time calculation
    // because not all SendFlags might be sent exactly when called, and the code originally was clearing out critBits
    WriteLong( MSG_ENTITY,  self.critBits );
    self.criticalHits = self.criticalHits | self.critBits;
    self.critBits = 0;
  }
  
  if( (changedflags & SENDFLAG_BURN) ){
    WriteLong( MSG_ENTITY, self.burnBits );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  self.shieldHitFlag = 0;
  return TRUE;
};