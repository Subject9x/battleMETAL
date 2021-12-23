/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for turret buildings, a unique form of building
  
  handles
    sv/main/controllers/ctrl_building.ctrl_send_turret()
*/

void() sendevent_turret_die={
  local entity weps;
  local entity rem;
  local float wId;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  makevectors(self.angles);
  setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
  self.colormod = '0.85 0.85 0.85';
  
  self.origin = self.origin + (v_up * (self.maxs_z * -0.05));
  setorigin(self, self.origin);
  
  sendent_handle_remove(self.torsoCenter);
  
  weps = self.w_slot;
  for(wId = 0; wId < self.hardpoint_cnt; wId = wId + 1){
    rem = weps;
    weps = rem.w_slot;
    sendent_handle_remove(rem);
  }
  
  te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);

  sendent_handle_remove(self.effect1);
  sendent_handle_remove(self.effect2);
  sendent_handle_remove(self.effect3);
};

/*
  SendEntity - Turret =======================================
*/
void( float isNew, float changeFlags) sendent_handle_turret={
  local vector turretAng;
  local float prevShield;
  local float prevDeadFlag;
  local float voiceId;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  turretAng = self.v_angle;
  turretAng_x = 0;
  
  //EVENT - death
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if(self.deadflag != DEAD_NO){
      self.vec_size = ReadByte();
    }
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
  }
  
  if( (changeFlags & SENDFLAG_EXDATA) ){
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
  }
  
  //EVENT - New to player
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.spawnflags = ReadCoord();
    self.data_idx = ReadByte();
    if( !(self.spawnflags & MUTE_ME)  ){
      self.ai_muted = FALSE;
      ai_voice_ini( TRUE );
      self.ai_voice_limit = 1;
    }
  }
  
  if( isNew ){
    setorigin(self, self.origin);
    if( self.deadflag == DEAD_NO){
      self.think = sendent_ai_think;
      self.nextthink = time + 0.01;
      data_sync_new_turret(self.data_idx);
      self.canTarget = TRUE;
    }
    else{
      model_misc_building_ruins_set();
    }
    self.drawmask = MASK_ENGINE;
    self.predraw = predraw_turret;
    if( !(self.spawnflags & MUTE_ME) ){
      self.ai_muted = FALSE;
      ai_voice_ini( TRUE );
      self.ai_voice_limit = 1;
    }
  }
  
  if( (changeFlags & SENDFLAG_CAMERA) ){
    self.groundEnt = ReadByte();
    if( self.groundEnt ){
      if( !(self.spawnflags & NO_DROP) ){
        if( isNew ){
          data_building_generate_foundation();
        }
      }
    }
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = ReadCoord();
    sendevent_handle_weaponfire();
  }
  
  //EVENT - faction changed
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = ReadByte();
  }
  
  //EVENT - turret rotated
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = 0;
    self.v_angle = turretAng;
    self.v_angle_x = self.v_angle_x * -1;
    turretAng_x = 0;
    sendevent_turret_update( turretAng );
  }
  
  //EVENT - health dropped below threshold
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadCoord();
    if( self.burnBits > 0 ){
      if( (self.burnBits & WEAPON1) && !self.effect1.count ){
        self.effect1 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.85;
      }
      if( (self.burnBits & WEAPON2) && !self.effect2.count ){
        self.effect2 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.75;
      }
      if( (self.burnBits & WEAPON3) && !self.effect3.count ){
        self.effect3 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.67;
      }
    }
  }
  
  //EVENT - voice chatter
  if( (changeFlags & SENDFLAG_VOICE) ){
    if( !(changeFlags & SENDFLAG_NEWENT) ){
      voiceId = ReadByte();
      snd_hud_trnsmsn_addtoqueue(self.ai_voice_group, voiceId, self.ai_voice_limit, self.entnum);
    }
  }
  
  //HANDLE EVENT - dead
  if( self.deadflag > DEAD_NO && prevDeadFlag == DEAD_NO ){
    sendevent_turret_die();
  }
  
  //HANDLE EVENT - Shield explode
  sendevent_shield_explode( prevShield );
  
  //Shield strike event
  if( self.shieldHitFlag != 0 && time > self.shieldEffectTime){
    if( (self.shieldHitFlag < SHIELD_HIT_EXP) && (self.shield > 0 && self.shield < 100.01) ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
};

void() interpolate_turret={
  local entity parent;
  local entity wepn;
  local vector saved;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
  
  parent = self;
  makevectors(parent.angles);
  if( self.torsoCenter ){
    self = self.torsoCenter;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
    self = parent;
  }
  
  wepn = self.w_slot;
  while( (wepn != world) ){
    self = wepn;
      if( self.partParentId == M_LEGS ){
        makevectors(parent.angles);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        self.origin = parent.origin + saved ;
        self.angles = parent.angles;
      }
      else{
        makevectors(parent.torsoCenter.angles);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        self.origin = parent.origin + saved ;
        self.angles = parent.torsoCenter.angles;
      }
    self = parent;
    wepn = wepn.w_slot;
  }
};

void() predraw_turret={
  if(self.deadflag == DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
};