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
  EVENT - DEATH
*/
void() sendevent_tank_die={
  
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
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.ai_muted = ReadByte();
    newName = ReadString();
  }
  
  if( isNew ){
    setorigin(self, self.origin);
    data_sync_new_vehicle( self.data_idx );
    if(self.deadflag == DEAD_NO){
      cacheGlobalString(self.netname, newName )
      self.predraw = predraw_tank;
      self.canTarget = TRUE;
      if( !self.ai_muted ){
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
  }
  
  //EVENT - TURRET ROTATES
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.torC_angl_x = anglemod(ReadAngle());
    self.torC_angl_y = anglemod(ReadAngle());
    self.torC_angl_z = 0;
    self.v_angle = self.torC_angl;
    self.v_angle_x = self.v_angle_x * -1;
    self.torC_angl_x = 0;
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
      particleDraw = vlen(client_vis_org - self.origin); 
      if( particleDraw < PARTICLE_HAZ_DISTANCE ){
        makevectors(self.angles);
        pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
      }
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
  local vector chasOrg;
  local entity wepn;
  local vector saved;
  local vector cacheOrg;
  local vector cacheAngl;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
	setorigin(self, self.origin);
  
  makevectors(self.angles);
  traceline(self.origin, self.origin - (v_up * 512), TRUE, self);
  
  cacheOrg = self.origin;
  cacheAngl = self.angles;
  
  chasOrg = trace_endpos + (v_up * self.mins_z * -1 );
  
  traceline(self.origin, client_vis_org, FALSE, self);
  
  self.cl_lod_unit = TRUE;
  if( (trace_fraction != 1.0 && trace_ent == world) || vlen(client_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
    self.cl_lod_unit = FALSE;
  }
  
  if( self.cl_lod_unit ){
    self.cl_lod_weapon = TRUE;
    if( vlen(client_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE / 2 ){
      self.cl_lod_weapon = FALSE;
    }
    
    setmodel(self, self.legs_mdl);
    setsize(self, self.cache_mins, self.cache_maxs);
    GetAlignedSurfaceAngles(self);
    self.origin = chasOrg;
    self.cacheGroundPos = chasOrg;
    addentity(self);
    
    if( (self.flags & FL_TURRET) ){
      saved = self.angles;
      saved_x = 0;
      makevectors(saved);
      self.torC_org = chasOrg + (v_right * self.torC_compOffset_x) + (v_up * self.torC_compOffset_y) + (v_forward * self.torC_compOffset_z);
      
      setmodel(self, self.torC_mdl);
      self.origin =  self.torC_org;
      self.angles = self.torC_angl;
      addentity(self);
      self.origin = cacheOrg;
      self.angles = cacheAngl;
      setsize(self, self.cache_mins, self.cache_maxs);
    }

    if(self.cl_lod_weapon){
      if(self.weaponEnt1.data_idx){
        predraw_unit_weapon(self.weaponEnt1);
      }
      if(self.weaponEnt2.data_idx){
        predraw_unit_weapon(self.weaponEnt2);
      }
      if(self.weaponEnt3.data_idx){
        predraw_unit_weapon(self.weaponEnt3);
      }
      if(self.weaponEnt4.data_idx){
        predraw_unit_weapon(self.weaponEnt4);
      }
      if(self.weaponEnt5.data_idx){
        predraw_unit_weapon(self.weaponEnt5);
      }
      if(self.weaponEnt6.data_idx){
        predraw_unit_weapon(self.weaponEnt6);
      }
      if(self.weaponEnt7.data_idx){
        predraw_unit_weapon(self.weaponEnt7);
      }
      if(self.weaponEnt8.data_idx){
        predraw_unit_weapon(self.weaponEnt8);
      }
      if(self.weaponEnt9.data_idx){
        predraw_unit_weapon(self.weaponEnt9);
      }
    }
  }
  setsize(self, self.cache_mins, self.cache_maxs);
};

void() predraw_tank={
  if(self.deadflag==DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
};