/*
battleMETAL
Author: Peter Roohr
Date: 9/5/2016
Overview: 
  implementation for center torso updates
*/

void() ctrl_mech_update={
  local entity weapon;
  local vector rootAngl;
  local vector rootTorCAngl;
  local vector offsetAngl;
  
  if( (self.flags & FL_CLIENT)){
    ctrl_updateCenterTorso(); 
    ctrl_updateLegs();
    rootAngl = self.angles;
    rootTorCAngl = [0, self.v_angle_y, 0];
  }
  else{
    ai_ctrl_updateCenterTorso();
    
    self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
    self.ai_weaponEnergy = 0;
    self.currentWeaponGroup = 0;

    rootAngl = self.angles;
    rootTorCAngl = self.torC_angl;  //controlled by AI api
  }
  
  //damage-based cosmetics for unit component pieces
  makevectors(rootAngl);
  self.torC_hitOffset = self.origin + (v_right * self.torC_compAltOffset_x) + (v_up * self.torC_compAltOffset_y) + (v_forward * self.torC_compAltOffset_z);
  self.torC_org = self.origin + (v_right * self.torC_compOffset_x) + (v_up * self.torC_compOffset_y) + (v_forward * self.torC_compOffset_z);
  self.torC_angl_y = rootTorCAngl_y;

  if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
    self.torC_angl_x = self.v_angle_x;
  }

  self.legs_hitOffset = self.origin + (v_right * self.legs_compAltOffset_x) + (v_up * self.legs_compAltOffset_y) + (v_forward * self.legs_compAltOffset_z);
  self.legs_org = self.origin + (v_right * self.legs_compOffset_x) + (v_up * self.legs_compOffset_y) + (v_forward * self.legs_compOffset_z);
  
  makevectors(rootTorCAngl);
  if( (self.unitModFlags & MOD_HAS_TOR_L) ){
    self.torL_hitOffset = self.origin + (v_right * self.torL_compAltOffset_x) + (v_up * self.torL_compAltOffset_y) + (v_forward * self.torL_compAltOffset_z);
    self.torL_org = self.origin + (v_right * self.torL_compOffset_x) + (v_up * self.torL_compOffset_y) + (v_forward * self.torL_compOffset_z);
    self.torL_angl_y = self.torC_angl_y;
    if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_L) ){
      self.torL_angl_x = self.torC_angl_x;
    }
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) ){
    self.torR_hitOffset = self.origin + (v_right * self.torR_compAltOffset_x) + (v_up * self.torR_compAltOffset_y) + (v_forward * self.torR_compAltOffset_z);
    self.torR_org = self.origin + (v_right * self.torR_compOffset_x) + (v_up * self.torR_compOffset_y) + (v_forward * self.torR_compOffset_z);
    self.torR_angl_y = self.torC_angl_y;
    if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_R) ){
      self.torR_angl_x = self.torC_angl_x;
    }
  }

  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armR_hitOffset = self.origin + (v_right * self.armR_compAltOffset_x) + (v_up * self.armR_compAltOffset_y) + (v_forward * self.armR_compAltOffset_z);
    self.armR_org = self.origin + (v_right * self.armR_compOffset_x) + (v_up * self.armR_compOffset_y) + (v_forward * self.armR_compOffset_z);
    self.armR_angl = [self.v_angle_x, self.torC_angl_y, 0];
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armL_hitOffset = self.origin + (v_right * self.armL_compAltOffset_x) + (v_up * self.armL_compAltOffset_y) + (v_forward * self.armL_compAltOffset_z);
    self.armL_org = self.origin + (v_right * self.armL_compOffset_x) + (v_up * self.armL_compOffset_y) + (v_forward * self.armL_compOffset_z);
    self.armL_angl = [self.v_angle_x, self.torC_angl_y, 0];
  }

  weapon = self.w_slot;
  while(weapon){
    if( weapon.owner != self ){
      continue;
    }
    if( (self.flags & FL_MONSTER) ){
      ctrl_weapon_think_ai(weapon);
    }
    util_getPartFromName(weapon.partParentId, self);

    offsetAngl = T_PART_PARENT_ANGL; 
    makevectors(offsetAngl);
    weapon.origin = self.origin + (v_up * weapon.compOffset_y) + (v_forward * weapon.compOffset_z) + (v_right * weapon.compOffset_x);
    weapon.angles = T_PART_PARENT_ANGL;
    setorigin(weapon, weapon.origin);
    weapon = weapon.w_slot;
  }

  if(self.critBuffer > 0){
    if( (self.critBuffer & M_TOR_LEFT) && !(self.criticalHits & M_ARM_LEFT) )
    {
      self.critBuffer = self.critBuffer | M_ARM_LEFT;
    }
    
    if( (self.critBuffer & M_TOR_RIGHT) && !(self.criticalHits & M_ARM_RIGHT) )
    {
      self.critBuffer = self.critBuffer | M_ARM_RIGHT;
    }    
    ctrl_mech_critical_hits();
    self.critBits = 0 | self.critBuffer;
    self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
    
    if( (self.critBits & M_REPAIR) ){
      self.criticalHits = self.criticalHits - (self.criticalHits & self.critBuffer);
    }
    else{
      self.criticalHits = self.criticalHits | self.critBits;
    }
    self.critBuffer = 0;
  }
};

void() ctrl_updateCenterTorso={
  local float mx, my;
  local float rate;
  
  if( time > self.laser_sight_timer ){
    makevectors(self.v_angle);
    self.dphitcontentsmask = 0 | DPCONTENTS_OPAQUE | Q3SURFACEFLAG_SKY | DPCONTENTS_SOLID | DPCONTENTS_BODY;
    
    if(self.chaseActive){
      traceline(self.origin, self.origin + (v_up * 22) + (v_forward * -96), MOVE_MISSILE, self);
      self.laser_sight_start = trace_endpos;
      
    }
    else{
      self.laser_sight_start = self.cameraOrigin;
    }

    traceline(self.laser_sight_start, self.laser_sight_start + (v_forward * 10000), MOVE_MISSILE, self);

    self.laser_sight_org = trace_endpos;
    self.laser_sight_timer = time + 0.05;
  }
  
  self.dphitcontentsmask = rint(0);

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

  local vector minsAdj;
  local vector maxsAdj;
  
  minsAdj = '0 0 0';
  maxsAdj = '0 0 0';

  legSoak = FALSE;
  if( (self.critBuffer & M_ARM_LEFT) && !(self.criticalHits & M_ARM_LEFT)){
    te_vehicle_chunk( self.armL_mdl, self.armL_org, '0 0 0', self.armL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    minsAdj = minsAdj + [self.cache_mins_x * -0.05, self.cache_mins_y * -0.05, 0];
    maxsAdj = maxsAdj - [self.cache_maxs_x * 0.05, self.cache_maxs_y * 0.05, 0];
  }

  if( (self.critBuffer & M_ARM_RIGHT) && !(self.criticalHits & M_ARM_RIGHT)){
    te_vehicle_chunk(  self.armR_mdl, self.armR_org, '0 0 0', self.armR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    minsAdj = minsAdj + [self.cache_mins_x * -0.05, self.cache_mins_y * -0.05, 0];
    maxsAdj = maxsAdj - [self.cache_maxs_x * 0.05, self.cache_maxs_y * 0.05, 0];
  }
  if( (self.critBuffer & M_TOR_LEFT) && !(self.criticalHits & M_TOR_LEFT)){
    if( (self.unitModFlags & MOD_HAS_SHIELD) ){
      self.shieldMax = self.cache_shieldMax * 0.25;
    }
    te_vehicle_chunk(  self.torL_mdl, self.torL_org, '0 0 0', self.torL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    minsAdj = minsAdj + [self.cache_mins_x * -0.1, self.cache_mins_y * -0.1, 0];
    maxsAdj = maxsAdj - [self.cache_maxs_x * 0.1, self.cache_maxs_y * 0.1, 0];
  }
  if( (self.critBuffer & M_TOR_RIGHT) && !(self.criticalHits & M_TOR_RIGHT)){
    if( (self.unitModFlags & MOD_HAS_SHIELD) ){
      self.shieldMax = self.cache_shieldMax * 0.25;
    }
    te_vehicle_chunk(  self.torR_mdl, self.torR_org, '0 0 0', self.torR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.owner.vec_size / 10) + 0.25 );
    minsAdj = minsAdj + [self.cache_mins_x * -0.1, self.cache_mins_y * -0.1, 0];
    maxsAdj = maxsAdj - [self.cache_maxs_x * 0.1, self.cache_maxs_y * 0.1, 0];
  }
  
  self.mins = self.mins + minsAdj;
  self.maxs = self.maxs + maxsAdj;

  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);

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
    self.cache_speed_accel = self.data_speed_accel;
    
    if( (self.flags & FL_CLIENT) ){
      self.data_speed_forward = self.data_speed_forward * 0.7;
      self.data_speed_strafe = self.data_speed_strafe * 0.8;
      self.data_speed_backward = self.data_speed_backward * 0.75;
      self.data_speed_accel = self.data_speed_accel * 0.5;
      self.SendFlags = self.SendFlags | SENDFLAG_EFLAGS;
    }
    else{
      //AI suffers way more for blown legs
      self.data_speed_forward = self.data_speed_forward * 0.5;
      self.data_speed_backward = self.data_speed_backward * 0.5;
      self.data_speed_accel = self.data_speed_accel * 0.25;
      if( !(self.damageValue & M_LEGS) ){
        self.damageValue = self.damageValue | M_LEGS;
      }
    }
  }
};


void() ctrl_player_mech_touch={
  local float dot;
  local entity dead;
  local vector vec;
  local float mid;
  local float rammage;
  
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
  
  makevectors ( self.ramAngle );
  vec = normalize (self.origin - other.origin);
  dot = vec * v_forward;
  
	if( dot < 0.6 ){
    mid = vlen(self.origin - other.origin) * 0.5;
    vec = self.legs_org + (v_forward * mid);
    rammage = vlen(self.velocity) * 0.1;
    
    if((other.flags & FL_MONSTER)){
      other.ramAngle = normalize(self.velocity) * 100;
    }

    if( other.shield <= 0 )
    {
      t_damage(other, self, self, rammage , vec, self.velocity * 0.25);
      if( self.shield <= 0 ){
        t_damage(self, other, other, rammage , vec, self.velocity * -0.1);
      }
    }
    else
    {
      if(self.shield > 0)
      {
        t_damage_shield(self, other, other, other.shield, vec, TRUE);
        t_damage_shield(other, self, self, self.shield, vec, TRUE);
      }
      else
      {
        t_damage_shield(other, self, self, rammage, vec, TRUE);
        t_damage(self, other, other, other.shield * 0.1, vec, self.velocity * -0.1);
      }
    }

    if(other.data_type == DATA_VEHC){
      self.velocity_x = self.velocity_x * 0.85;
      self.velocity_y = self.velocity_y * 0.85;
    }
    else{
      self.ramCharge = time;
      self.ramCool = time + self.ramUp;
      self.velocity_x = self.velocity_x * 0.65;
      self.velocity_y = self.velocity_y * 0.65;
    }
    return;
  }  

  if( other.deadflag > DEAD_NO && other.data_type == DATA_VEHC){
    self.deadflag = DEAD_RAMMED;
    self.velocity_x = self.velocity_x * 0.75;
    self.velocity_y = self.velocity_y * 0.75;
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

float( entity to, float changedflags ) ctrl_send_mech_ai={

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
  
  if( (changedflags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteLong( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteChar( MSG_ENTITY, self.subType );
    if( strlen(self.netname) > 0 || self.netname){
      WriteString( MSG_ENTITY, self.netname );
    }
    else{
      WriteString( MSG_ENTITY, "none" );
    }
    
    WriteByte( MSG_ENTITY, self.deadflag );
    if( self.deadflag == DEAD_NO ){
      WriteLong( MSG_ENTITY,  self.criticalHits );
      WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100 );
      WriteByte( MSG_ENTITY, (self.torL_hp / self.torL_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.torR_hp / self.torR_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.armL_hp / self.armL_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.armR_hp / self.armR_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.legs_hp / self.legs_hpMax) * 100 );
      WriteByte( MSG_ENTITY, (self.shield / self.shieldMax) * 100);
    }
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100 );
    WriteByte( MSG_ENTITY, (self.torL_hp / self.torL_hpMax) * 100 );
    WriteByte( MSG_ENTITY, (self.torR_hp / self.torR_hpMax) * 100 );
    WriteByte( MSG_ENTITY, (self.armL_hp / self.armL_hpMax) * 100 );
    WriteByte( MSG_ENTITY, (self.armR_hp / self.armR_hpMax) * 100 );
    WriteByte( MSG_ENTITY, (self.legs_hp / self.legs_hpMax) * 100 );
    self.shieldHitFlag = 0;
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
    self.critBits = 0;
  }

  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_UPDATE_FULL) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }

  if( (changedflags & SENDFLAG_FACTION)){
    WriteByte(MSG_ENTITY, self.faction);
  }

  return TRUE;
};