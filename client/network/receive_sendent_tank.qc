/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI tanks
    tanks have turrets
  
  handles
    sv/main/controllers/ctrl_tank.ctrl_send_tank()
*/

/*
  EVENT - MOVE
*/
void() sendevent_tank_move={
  local entity weps;
  
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    if( weps.partParentId == M_LEGS ){
      weps.angles = self.angles;
    }
    else{
      weps.angles = self.torsoCenter.angles;
    }
  }
};

/*
  EVENT - DEATH
*/
void() sendevent_tank_die={
  local entity weps;
  local entity rem;
  local float wId;
  
  weps = self.w_slot;
  for(wId = 0; wId < self.hardpoint_cnt; wId = wId + 1){
    rem = weps;
    weps = rem.w_slot;
    sendent_handle_remove(rem);
  }
  sendent_handle_remove(self.torsoCenter);
  
  data_vehicle_wreck();
  
  traceline(self.origin + (v_up * self.maxs_z * 0.67), self.origin + (v_up * -128), TRUE, self);
  te_missile_explode( trace_endpos + (v_up * 4) , self.vec_size + 1, '0.9 0.75 0.45', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
};

/*
  SendEntity - Tank =======================================
*/
void( float isNew, float changeFlags ) sendent_handle_tank={
  local float prevShield;
  local float pclEffect;
  local vector turretAng;
  local string newName;
  local float prevDeadFlag;
  local float voiceId;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    sendevent_tank_move();
  }
  
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
  }
  
  //EVENT - DEATH
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  //EVENT - NEW ENTITY
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
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
    self.ai_muted = ReadByte();
    newName = ReadString();
  }
  
  if( isNew ){
    setorigin(self, self.origin);
    cacheGlobalString(self.netname, newName )
    data_sync_new_vehicle( self.data_idx );
    self.predraw = predraw_tank;
    self.canTarget = TRUE;
    if( !self.ai_muted ){
      ai_voice_ini( TRUE );
      self.ai_voice_limit = 1;
    }
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  //EVENT - TURRET ROTATES
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = 0;
    self.v_angle = turretAng;
    self.v_angle_x = self.v_angle_x * -1;
    turretAng_x = 0;
    sendevent_turret_update( turretAng );
  }
  
  //EVENT - CRITICAL HIT
  if( (changeFlags & SENDFLAG_CRIT) ){
    pclEffect = ReadByte();
    if( pclEffect > 0 ){
      self.pcl_effectnum = pclEffect;
    }
  }
  //EVENT - DEAD AND BURNING
  if( (changeFlags & SENDFLAG_BURN) ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      if( self.pcl_effectnum == 0 ){
        self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE");
      }
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
  
  //EVENT - voice chatter
  if( (changeFlags & SENDFLAG_VOICE) ){
    if( !(changeFlags & SENDFLAG_NEWENT) ){
      voiceId = ReadByte();
      snd_hud_trnsmsn_addtoqueue(self.ai_voice_group, voiceId, self.ai_voice_limit, self.entnum);
    }
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );  
  
  //Shield strike event
  if( self.shieldHitFlag != 0 && time > self.shieldEffectTime){
    if( (self.shieldHitFlag < SHIELD_HIT_EXP) && (self.shield > 0 && self.shield < 100.01) ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
  
  //HANDLE EVENT - dead
  if( self.deadflag > DEAD_NO && prevDeadFlag == DEAD_NO ){
    sendevent_tank_die();
  }
};

void() interpolate_tank={
  local entity parent;
  local entity wepn;
  local vector saved;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
	setorigin(self, self.origin);
  
  parent = self;
  
  GetAlignedSurfaceAngles(self);
  
  if( self.torsoCenter != world ){
    saved = self.angles;
    saved_x = 0;
    makevectors(saved);
    self = self.torsoCenter;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles_x = parent.angles_x;
    self = parent;
  }
  
  wepn = self.w_slot;
  while( (wepn != world) ){
    self = wepn;
      if( self.partParentId == M_LEGS ){
        saved = parent.angles;
        saved_x = 0;
        makevectors(saved);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        saved = parent.origin + saved;
        self.angles = parent.angles + self.w_adj_ang;
      }
      else{
        saved = parent.torsoCenter.angles;
        //saved_x = 0;
        makevectors(saved);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        saved = parent.torsoCenter.origin + saved;
        self.angles = parent.torsoCenter.angles + self.w_adj_ang;
      }
      self.origin = saved;
    self = parent;
    wepn = wepn.w_slot;
  }
};

void() predraw_tank={
  if(self.deadflag==DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
};