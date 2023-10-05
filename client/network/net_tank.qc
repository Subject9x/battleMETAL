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
  local vector turretAng;
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
  }
  
  //EVENT - DEATH
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  //EVENT - NEW ENTITY
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
    self.health = ReadByte();
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
    self.pcl_effectnum = ReadByte();
  }
  //EVENT - DEAD AND BURNING
  if( (changeFlags & SENDFLAG_BURN) ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      if( self.pcl_effectnum == 0 ){
        self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE");
      }
      //todo - move me, this shouldnt be here
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
    sendevent_tank_die();
  }
};

void() interpolate_tank={
  local vector chasOrg;
  local entity wepn;
  local vector saved;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
  
	setorigin(self, self.origin);
  
  makevectors(self.angles);
  traceline(self.origin, self.origin - (v_up * 512), TRUE, self);
  
  self.rootOrigin = self.origin;
  self.rootAngle = self.angles;
  
  chasOrg = trace_endpos + (v_up * self.mins_z * -1 );
  self.originNext = chasOrg;
  
  // traceline(self.origin, CLIENT_vis_org, FALSE, self);
  
  local float hitcontent;
  hitcontent = CLIENT_server_ent.dphitcontentsmask;

  PVS_FAIL = FALSE;
  CLIENT_server_ent.dphitcontentsmask = 0 | PVS_HITCONTENT;
  traceline(self.origin + [0,0, self.maxs_z], CLIENT_vis_org, FALSE, CLIENT_server_ent);
  PVS_FRAC1 = trace_fraction;

  traceline([self.absmax_x, self.absmax_y , self.absmax_z], CLIENT_vis_org, FALSE, CLIENT_server_ent);
  PVS_FRAC2 = trace_fraction;

  traceline([self.absmin_x , self.absmin_y , self.absmax_z], CLIENT_vis_org, FALSE, CLIENT_server_ent);
  PVS_FRAC3 = trace_fraction;

  CLIENT_server_ent.dphitcontentsmask = hitcontent;
  
  if((PVS_FRAC1 < 0.9) && (PVS_FRAC2 < 0.9) && (PVS_FRAC3 < 0.9)){
    PVS_FAIL = TRUE;
  }

  self.cl_lod_unit = TRUE;
  if(  PVS_FAIL || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
    self.cl_lod_unit = FALSE;
  }

  // self.cl_lod_unit = TRUE;
  // if( (trace_fraction != 1.0 && trace_ent == world) || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
  //   self.cl_lod_unit = FALSE;
  // }
  
  if( self.cl_lod_unit ){
    self.cl_lod_weapon = TRUE;
    if( vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE / 2 ){
      self.cl_lod_weapon = FALSE;
    }
    
    setmodel(self, self.legs_mdl);
    setsize(self, self.cache_mins, self.cache_maxs);
    GetAlignedSurfaceAngles(self);
    self.origin = chasOrg;
    self.cacheGroundPos = chasOrg;
    addentity(self);
    self.origin = self.rootOrigin;
    self.angles = self.rootAngle;
    
    if( (self.flags & FL_TURRET) ){
      saved = self.angles;
      saved_x = 0;
      makevectors(saved);
      self.torC_org = chasOrg + (v_right * self.torC_compOffset_x) + (v_up * self.torC_compOffset_y) + (v_forward * self.torC_compOffset_z);
      
      setmodel(self, self.torC_mdl);
      self.origin =  self.torC_org;
      self.angles = self.torC_angl;
      addentity(self);
      self.origin = self.rootOrigin;
      self.angles = self.rootAngle;
      setsize(self, self.cache_mins, self.cache_maxs);
    }

    if(self.cl_lod_weapon){
      if( self.pcl_effectnum != 0 ){
         pointparticles( self.pcl_effectnum, self.cacheGroundPos, normalize( (self.cacheGroundPos + [0, 0, self.maxs_z]) - self.cacheGroundPos) * (10/2), 0.5);
      }
    
      if(self.weaponEnt1.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt1);
      }
      if(self.weaponEnt2.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt2);
      }
      if(self.weaponEnt3.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt3);
      }
      if(self.weaponEnt4.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt4);
      }
      if(self.weaponEnt5.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt5);
      }
      if(self.weaponEnt6.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt6);
      }
      if(self.weaponEnt7.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt7);
      }
      if(self.weaponEnt8.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt8);
      }
      if(self.weaponEnt9.data_idx){
        predraw_unit_weapon_tank(self.weaponEnt9);
      }
    }
  }
  setsize(self, self.cache_mins, self.cache_maxs);
  setorigin(self, self.rootOrigin);
  self.angles = self.rootAngle;
};

void() predraw_tank={
  if( self.deadflag != DEAD_NO ){
    return;
  }
  if(!self.interpolate_entity){
    return;
  }
  self.interpolate_entity();
};