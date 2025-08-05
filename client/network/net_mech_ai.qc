/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI mechs
  
  handles
    sv/main/controllers/ctrl_mech.ctrl_send_mech_ai()
*/

void() mech_ai_think={
  local vector v1;
  
  makevectors(self.v_angle);
  v1 = self.origin + (v_up * self.cameraOffset_y);
  traceline(v1, v1 + v_forward*10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  
  self.think = mech_ai_think;
  self.nextthink = time + 0.001;
  self.legs_nextthink = time + 0.001;
};
/*
  EVENT - DEATH =====================================
*/
void() mech_corpse_remove={
  if(!wasfreed(self)){
    self.drawmask = 0;
    if(self.effect1 != world ){
      remove(self.effect1);
    }
    if( self.unit_legs && !wasfreed(self.unit_legs) ){
      remove(self.unit_legs);
    }
    remove(self);
  }
};

void() mech_ai_die_stand1;
void() sendevent_mech_ai_die={
  local entity weps;
  local entity rem;
  local float wId;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  makevectors(self.angles);
  te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size * 2, '0.9 0.75 0.45', 0.01 );
  Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, (0.75 + (random() * 0.25)) * 110 , SOUNDFLAG_DYNAMIC_INT);  
  
  self.colormod = '0.45 0.45 0.45';
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.effect1 = te_building_fire_start( self );
  self.effect1.origin = self.origin;
  self.effect1.origin_z = self.effect1.origin_z + self.maxs_z;
  self.legs_angl_y = self.legDir;
  self.legs_frame = self.unit_legs.frame;
  
  if( self.unit_legs && !wasfreed(self.unit_legs) ){
    self.unit_legs.think = SUB_Remove;
    self.unit_legs.nextthink = time + 0.1;
    
  }
  self.think = mech_ai_die_stand1;
  self.nextthink = time + 0.01;
};

/*
  SendEntity - MECH AI =====================================
*/
void( float isNew, float changeFlags ) sendent_handle_mech_ai={
  local string newName;
  local float prevShield;
  local float prevDeadFlag;

  local float cthp, lthp, rthp, lahp, raph, lghp;
  cthp = 0;

  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  self.clientServerNum = self.entnum;
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.moveState = ReadByte();
    if(self.moveState != MOVE_STAND ){
      self.ai_dir = 1;
    }
    else{
      self.ai_dir = 0;
    }
  }
  
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
    self.legDir = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    self.critBits = ReadLong();
    if( self.critBits != 0 ){
      sendevent_mech_crit( self.critBits );
      self.criticalHits = self.criticalHits | self.critBits;
      self.critBits = 0;
    }
  }
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    self.data_idx = ReadByte();
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.ai_muted = ReadByte();
    self.subType = ReadChar();
    newName = ReadString();
    
    self.deadflag = ReadByte();
    if( self.deadflag == DEAD_NO ){
      handle_existing_crits(isNew, fabs(rint(ReadLong())));
      handle_existing_hp(isNew, ReadByte(), ReadByte(),ReadByte(),ReadByte(),ReadByte(),ReadByte());
      
      cthp = self.torC_hp;
      lthp = self.torL_hp;
      rthp = self.torR_hp;
      lahp = self.armL_hp;
      raph = self.armR_hp;
      lghp = self.legs_hp;

      self.shield = ReadByte();
    }
  }
  
  if( isNew ){
    if( self.deadflag == DEAD_NO ){
      if(newName != "none"){
        cacheGlobalString(self.netname, newName )
      }
      self.think = mech_ai_think;
      self.nextthink = time + 0.01;
      data_sync_new_mech_ai( self.data_idx );
      if(!self.unit_legs){
        self.unit_legs = spawn();
        self.unit_legs.skin = self.skin;
      }
    }
    else{
      data_sync_new_mech_ai( self.data_idx );
      pointparticles( PTC_WRECK_SMOKE, self.origin + '0 0 20', normalize( (self.origin + '0 0 20') - self.origin) * 5, 0.5);
    }
    if(cthp){
      self.torC_hp = cthp ;
      self.torL_hp = lthp ;
      self.torR_hp = rthp ;
      self.armL_hp = lahp ;
      self.armR_hp = raph ;
      self.legs_hp = lghp ;
    }
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
    self.torC_hp = ReadByte();
    self.torL_hp = ReadByte();
    self.torR_hp = ReadByte();
    self.armL_hp = ReadByte();
    self.armR_hp = ReadByte();
    self.legs_hp = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = fabs(rint(ReadLong()));
    sendevent_handle_weaponfire();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.torC_angl_x = anglemod(ReadAngle());
    self.torC_angl_y = anglemod(ReadAngle());
    self.torC_angl_z = anglemod(ReadAngle());
    self.v_angle = self.torC_angl;
    self.v_angle_x = self.v_angle_x * -1;
    self.torC_angl_x = 0;
  }
  
  //EVENT - CRITICAL HIT
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.critBits = ReadLong();
    if( self.critBits != 0 ){
      sendevent_mech_crit( self.critBits );
      self.criticalHits = self.criticalHits | self.critBits;
      self.critBits = 0;
    }
  }
  
  //EVENT - voice chatter
  if( (changeFlags & SENDFLAG_VOICE) ){
    if( !(changeFlags & SENDFLAG_UPDATE_FULL) ){
      snd_hud_trnsmsn_addtoqueue(self.ai_voice_group, ReadByte(), self.ai_voice_limit, self.entnum);
    }
  }

  if( (changeFlags & SENDFLAG_FACTION)){
    self.faction = ReadByte();
  }
  
  if( self.deadflag > DEAD_NO && prevDeadFlag == DEAD_NO ){
    sendevent_mech_ai_die();
  }
  
  if( self.deadflag == DEAD_NO ){
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

void() interpolate_mech_ai={
  local entity wepn;
  local float wId;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
  
  self.rootOrigin_x = self.origin_x;
  self.rootOrigin_y = self.origin_y;
  self.rootOrigin_z = self.origin_z;
  
  self.rootAngle = self.angles;
  
  local float hitcontent;
  hitcontent = CLIENT_server_ent.dphitcontentsmask;

  PVS_FAIL = FALSE;
  CLIENT_server_ent.dphitcontentsmask = 0 | PVS_HITCONTENT;
  traceline(self.rootOrigin + [0,0, self.maxs_z], CLIENT_vis_org, FALSE, CLIENT_server_ent);
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
  if(  PVS_FAIL || vlen(CLIENT_vis_org - self.rootOrigin) > PARTICLE_HAZ_DISTANCE){
    self.cl_lod_unit = FALSE;
  }
  
  self.cl_lod_weapon = TRUE;
  if( vlen(CLIENT_vis_org - self.rootOrigin) > PARTICLE_HAZ_DISTANCE / 2 ){
    self.cl_lod_weapon = FALSE;
  }
  
  makevectors([0, self.angles_y, self.angles_z]);
      
  setsize(self, self.cache_mins, self.cache_maxs);
  self.renderflags = 0;
  self.legs_org = self.rootOrigin + (v_right * self.legs_compOffset_x) + (v_forward * self.legs_compOffset_z) + (v_up * self.legs_compOffset_y);
  
  predraw_legs_nonclient();

  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  
  self.torC_org = predraw_unit_part(self.torC_compOffset); 
  if((self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
    self.torC_angl_x = self.torC_angl_x * -1;
  }
  self.colormod = CLR_DEF_WHITE * (self.torC_hp / 100) * 2;
  setmodel(self, self.torC_mdl);
  self.angles = self.torC_angl;
  self.origin = self.torC_org;
  
  if(self.cl_lod_unit){
    addentity(self);
  }

  makevectors(self.torC_angl);
  if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
    if( !(self.criticalHits & M_TOR_LEFT) ){
      self.torL_org = predraw_unit_part(self.torL_compOffset); 
      self.torL_angl = self.torC_angl;
      if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_L) ){
          self.torL_angl_x = self.torL_angl_x * -1;
      }
      self.colormod = CLR_DEF_WHITE * (self.torL_hp / 100) * 2;
      setmodel(self, self.torL_mdl);
      self.angles = self.torL_angl;
      self.origin = self.torL_org;
      if(self.cl_lod_unit){
        addentity(self);
      }
    }
  }
  
  if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
    if( !(self.criticalHits & M_TOR_RIGHT) ){
      self.torR_org = predraw_unit_part(self.torR_compOffset); 
      self.torR_angl = self.torC_angl;
      if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_R) ){
          self.torR_angl_x = self.torR_angl_x * -1;
      }
      self.colormod = CLR_DEF_WHITE * (self.torR_hp / 100) * 2;
      setmodel(self, self.torR_mdl);
      self.angles = self.torR_angl;
      self.origin = self.torR_org;
      if(self.cl_lod_unit){
        addentity(self);
      }
    }
  }
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
    if( !(self.criticalHits & M_ARM_LEFT) ){
      self.armL_org = predraw_unit_part(self.armL_compOffset); 
      self.armL_angl = self.torC_angl;
      if((self.unitModFlags & MOD_MODEL_PITCH_ARM_L)){
        self.armL_angl_x = self.armL_angl_x * -1;
      }
      self.colormod = CLR_DEF_WHITE * (self.armL_hp / 100) * 2;
      setmodel(self, self.armL_mdl);
      self.angles = self.armL_angl;
      self.origin = self.armL_org;
      if(self.cl_lod_unit){
        addentity(self);
      }
    }
  }
  
  if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
    if( !(self.criticalHits & M_ARM_RIGHT) ){
      self.armR_org = predraw_unit_part(self.armR_compOffset); 
      self.armR_angl = self.torC_angl;
      if((self.unitModFlags & MOD_MODEL_PITCH_ARM_R)){
        self.armR_angl_x = self.armR_angl_x * -1;
      }
      self.colormod = CLR_DEF_WHITE * (self.armR_hp / 100) * 2;
      setmodel(self, self.armR_mdl);
      self.angles = self.armR_angl;
      self.origin = self.armR_org;
      if(self.cl_lod_unit){
        addentity(self);
      }
    }
  }
  if(self.cl_lod_weapon){
    self.origin = self.rootOrigin;
    self.angles = self.rootAngle;
    render_mech_effect_burning();
  }

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
  
  self.mins = self.cache_mins;
  self.maxs = self.cache_maxs;
  self.origin = self.rootOrigin;
  setorigin(self, self.rootOrigin);
  self.angles = self.rootAngle;
  self.alpha = 1.0;
  self.scale = 1.0;
};

void() predraw_mech_ai={
  if(self.deadflag==DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
};