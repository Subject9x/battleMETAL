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
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  makevectors(self.angles);
  setmodel(self, "models/map/ruins/ruin_small.obj");
  
  self.origin = self.origin + (v_up * (self.maxs_z * -0.05));
  setorigin(self, self.origin);
  
  te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
  PointSound_Dynamic(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);

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
  local float prevBurn;
  local float voiceId;
  local float mapKey;
  local float vipKey;
  local float muted;
  local float hp;

  hp = 0;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  prevBurn = 0 | self.burnBits;
  
  turretAng = self.v_angle;
  turretAng_x = 0;
  
  self.clientServerNum = self.entnum;

  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    
    self.faction = ReadByte();
    self.vec_size = ReadByte();
    self.data_idx = ReadByte();
    self.canTarget = ReadByte();
    mapKey = ReadChar();
    vipKey = ReadChar();
    muted = ReadChar();
    if( mapKey ){
      self.spawnflags = self.spawnflags | IS_MAPKEY;
    }
    if( vipKey ){
      self.spawnflags = self.spawnflags | IS_VIP;
    }
    if( muted ){
      self.spawnflags = self.spawnflags | MUTE_ME;
    }
    self.subType = ReadChar();
    self.deadflag = ReadByte();
    if(self.deadflag == DEAD_NO){
      self.health = ReadByte();
      hp = self.health;
    }
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  //EVENT - death
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  //EVENT - faction changed
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = fabs(ReadByte());
  }
  
  //EVENT - health dropped below threshold
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = fabs(rint(ReadLong()));
  }
  
  if( (changeFlags & SENDFLAG_CAMERA) ){
    self.groundEnt = ReadByte();
    //FIX ME
    /*if( self.groundEnt ){
      if( !(self.spawnflags & NO_DROP) ){
        if( isNew ){
          data_building_generate_foundation();
        }
      }
    }*/
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = fabs(ReadByte());
    self.health = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = fabs(rint(ReadLong()));
    sendevent_handle_weaponfire();
  }
  
  //EVENT - turret rotated
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.torC_angl_x = anglemod(ReadAngle());
    self.torC_angl_y = anglemod(ReadAngle());
    
    self.torC_angl_x = 0; //todo zero-out or fix serverside
    self.torC_angl_z = 0;

    self.v_angle = self.torC_angl;
  }
  
  //EVENT - voice chatter
  if( (changeFlags & SENDFLAG_VOICE) ){
    if( !(changeFlags & SENDFLAG_UPDATE_FULL) ){
      voiceId = ReadByte();
      snd_hud_trnsmsn_addtoqueue(self.ai_voice_group, voiceId, self.ai_voice_limit, self.entnum);
    }
  }
  
  if( isNew ){
    self.rootAngle = self.angles;
    self.predraw = predraw_turret;
    data_sync_new_turret(self.data_idx);
    if( self.deadflag == DEAD_NO){
      self.health = hp;
      if( !(self.spawnflags & MUTE_ME) ){
        self.ai_muted = FALSE;
        ai_voice_ini( TRUE );
        self.ai_voice_limit = 1;
      }
    }
    else{
      model_misc_building_ruins_set();
    }
  }
  
  //HANDLE EVENT - dead
  if(prevDeadFlag == DEAD_NO && self.deadflag == DEAD_DEAD){
    sendevent_turret_die();
  }
  
  //other events only fire when NOT dead.
  if( self.deadflag == DEAD_NO ){
    //HANDLE EVENT - new burning fire
    if( self.burnBits != prevBurn && self.burnBits != FALSE ){
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
  }
};

void() interpolate_turret={
  local entity parent;
  local entity wepn;
  local vector saved;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
  
  self.rootOrigin = self.origin;
  self.rootAngle = self.angles;
  
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
  
  if(self.cl_lod_unit){
    self.cl_lod_weapon = TRUE;
    if( vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE / 2 ){
      self.cl_lod_weapon = FALSE;
    }
  }

  setmodel(self, self.legs_mdl);
  self.skin = 0;
  self.angles = self.rootAngle;
  if(self.cl_lod_unit){
    addentity(self);
  }
  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  
  
  makevectors(self.angles);
  self.torC_org =  self.rootOrigin + (v_right * self.torC_compOffset_x) + (v_forward * self.torC_compOffset_z) + (v_up * self.torC_compOffset_y);
  setmodel(self, self.torC_mdl);
  self.origin = self.torC_org;
  self.angles = self.torC_angl;
  self.skin = 0;
  if(self.cl_lod_unit){
    addentity(self);
  }
  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  setsize(self, self.cache_mins, self.cache_maxs);

  if(self.weaponEnt1.data_idx){
    predraw_unit_weapon(self.weaponEnt1, self.cl_lod_weapon);
  }
  if(self.weaponEnt2.data_idx){
    predraw_unit_weapon(self.weaponEnt2, self.cl_lod_weapon);
  }
  if(self.weaponEnt3.data_idx){
    predraw_unit_weapon(self.weaponEnt3, self.cl_lod_weapon);
  }
  if(self.weaponEnt4.data_idx){
    predraw_unit_weapon(self.weaponEnt4, self.cl_lod_weapon);
  }
  if(self.weaponEnt5.data_idx){
    predraw_unit_weapon(self.weaponEnt5, self.cl_lod_weapon);
  }
  if(self.weaponEnt6.data_idx){
    predraw_unit_weapon(self.weaponEnt6, self.cl_lod_weapon);
  }
  if(self.weaponEnt7.data_idx){
    predraw_unit_weapon(self.weaponEnt7, self.cl_lod_weapon);
  }
  if(self.weaponEnt8.data_idx){
    predraw_unit_weapon(self.weaponEnt8, self.cl_lod_weapon);
  }
  if(self.weaponEnt9.data_idx){
    predraw_unit_weapon(self.weaponEnt9, self.cl_lod_weapon);
  }
  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  self.mins = self.cache_mins;
  self.maxs = self.cache_maxs;
};

void() predraw_turret={
  if(self.deadflag == DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
};