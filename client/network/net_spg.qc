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
  EVENT - DEATH
*/
void() sendevent_spg_die={
  data_vehicle_wreck();
  
  makevectors([0, self.cacheGroundAngle_y, 0]);
  traceline(self.cacheGroundPos + (v_up * ((self.maxs_z * 0.67) * 4)), self.cacheGroundPos + (v_up * -128), TRUE, self );
  te_missile_explode( trace_endpos,  self.vec_size + 1, '0.9 0.75 0.45', 0.01 ) ;
  PointSound_Dynamic( trace_endpos, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT );
};

/*
  SendEntity - SPG =======================================
*/
void( float isNew, float changeFlags) sendent_handle_spg={
  local float prevShield;
  local string newName;
  local float prevDeadFlag;
  local float voiceId;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  self.clientServerNum = self.entnum;

  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
    self.v_angle = self.angles;
  }
  
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    self.data_idx = ReadByte();
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.ai_muted = ReadByte();
    self.subType = ReadChar();
    newName = ReadString();
    self.deadflag = ReadByte();
  }
  
  if( isNew ){
    data_sync_new_vehicle(self.data_idx);
    if( self.deadflag == DEAD_NO ){
      cacheGlobalString(self.netname, newName )
      
      self.predraw = predraw_spg;
      self.canTarget = TRUE;
      if( !self.ai_muted ){
        self.ai_muted = FALSE;
        ai_voice_ini( TRUE );
        self.ai_voice_limit = 1;
        
      }
    }
    else{
      data_vehicle_wreck();
    }
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
    self.health = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.pcl_effectnum = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      if( self.pcl_effectnum == 0 ){
        self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE");
      }
      //particleDraw = vlen(CLIENT_vis_org - self.origin); 
      //if( particleDraw < PARTICLE_HAZ_DISTANCE ){
      //  makevectors(self.angles);
      //  pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
      //}
    }
  }
  
  if( (changeFlags & SENDFLAG_TARGET) ){
    self.getTarget = ReadLong();
    self.enemy = findfloat(world, entnum, self.getTarget);
  }
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = ReadLong();
    sendevent_handle_weaponfire();
  }
  
  //EVENT - voice chatter
  if( (changeFlags & SENDFLAG_VOICE) ){
    if( !(changeFlags & SENDFLAG_UPDATE_FULL) ){
      voiceId = ReadByte();
      snd_hud_trnsmsn_addtoqueue(self.ai_voice_group, voiceId, self.ai_voice_limit, self.entnum);
    }
  }

  if( (changeFlags & SENDFLAG_FACTION)){
    self.faction = ReadByte();
  }
  
   //HANDLE EVENT - Shield explode
  if( self.shield > 100 && (prevShield <= 100 && prevShield != 0) ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
  else{
    //HANDLE EVENT - Shield hit
    if( self.shieldHitFlag != 0 && time > self.shieldEffectTime){
      if( (self.shieldHitFlag < SHIELD_HIT_EXP) && (self.shield > 0 && self.shield < 100.01) ){
        self.shieldEffectTime = time + 0.5;
        te_shield_hit();
      }
    }
  }
  
  //HANDLE EVENT - dead
  if( self.deadflag > DEAD_NO && prevDeadFlag == DEAD_NO ){
    if( self.deadflag == DEAD_RAMMED ){
      Sound7_Dynamic(self, CHAN_BODY, "sound/fx_ram_hit%s.ogg", 1.0, ATTN_NORM, (0.5 + random()/2) * 125, SOUNDFLAG_DYNAMIC_INT);
    }
    sendevent_spg_die();
  }
};

void() predraw_spg={
  if(self.deadflag == DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
};