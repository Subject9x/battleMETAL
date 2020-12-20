/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI tank destroyers ( Self-propelled gun )
    SPGs dont have turrets
  
  handles
    sv/main/controllers/ctrl_tank.ctrl_send_spg()
*/

/*
  EVENT - MOVE
*/
void() sendevent_spg_move={
  local entity weps;
  makevectors(self.angles);
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    weps.angles = self.angles;
    weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
  }
};

/*
  EVENT - DEATH
*/
void() sendevent_spg_die={  local entity weps;
  local entity rem;
  local float wId;
  
  weps = self.w_slot;
  for(wId = 0; wId < self.hardpoint_cnt; wId = wId + 1){
    rem = weps;
    weps = rem.w_slot;
    sendent_handle_remove(rem);
  }
  
  data_vehicle_wreck();
  
  te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
};

/*
  SendEntity - SPG =======================================
*/
void( float isNew, float changeFlags) sendent_handle_spg={
  local float prevShield;
  local float pclEffect;
  local string newName;
  local float prevAttackFlag;
  local float prevDeadFlag;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
  }
  
  self.v_angle = self.angles;
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    if( self.deadflag == DEAD_NO ){
      self.flags = ReadCoord();
      self.faction = ReadByte();
      self.next_wepn1 = ReadByte();
      self.next_wepn2 = ReadByte();
      self.next_wepn3 = ReadByte();
      self.next_wepn4 = ReadByte();
      self.next_wepn5 = ReadByte();
      self.next_wepn6 = ReadByte();
      self.next_wepn7 = ReadByte();
      self.next_wepn8 = ReadByte();
      self.next_wepn9 = ReadByte();
      newName = ReadString();
    }
    else{
      self.faction = FALSE;
    }
  }
  
  if( isNew ){
    setorigin(self, self.origin);
    if( newName != "" ){
      self.netname = strzone(newName);
    }
    data_sync_new_vehicle(self.data_idx);
    self.predraw = predraw_spg;
    self.canTarget = TRUE;
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    sendevent_spg_move();
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  if( changeFlags & SENDFLAG_CRIT ){
    pclEffect = ReadByte();
    if( pclEffect > 0 ){
      self.pcl_effectnum = pclEffect;
    }
  }
  
  if( changeFlags & SENDFLAG_BURN ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      makevectors(self.angles);
      pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
    }
  }
  
  if( (changeFlags & SENDFLAG_TARGET) ){
    self.getTarget = rint(ReadCoord());
    self.enemy = findfloat(world, entnum, self.getTarget);
  }
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = ReadCoord();
    sendevent_handle_weaponfire();
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
  
  //Shield strike event
  if( self.shieldHitFlag == TRUE && (self.shield > 0 && self.shield < 100.01)){
    if( time > self.shieldEffectTime ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
  
  //HANDLE EVENT - dead
  if( self.deadflag > DEAD_NO && prevDeadFlag == DEAD_NO ){
    sendevent_spg_die();
  }
};

float() predraw_spg={
  if(self.deadflag == DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
  return FALSE;
};