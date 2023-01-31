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


void() mech_corpse_th={
  self.think = mech_corpse_th;
  if( time > self.data_lifetime ){
    self.think = mech_corpse_remove;
  }
  self.nextthink = time + 0.1;
};


void() predraw_mech_corpse={
  local vector prevOrg;
  local vector prevAngle;
  
  prevOrg = self.origin;
  prevAngle = self.angles;
  
  interpolate_origin();
  interpolate_angle();
	
  self.origin = self.origin;
  self.rootOrigin = self.origin;
  self.rootAngle = self.angles;
  
  traceline(self.origin, CLIENT_vis_org, FALSE, self);
  
  self.cl_lod_unit = TRUE;
  if( (trace_fraction != 1.0 && trace_ent == world) || vlen(CLIENT_vis_org - self.rootOrigin) > PARTICLE_HAZ_DISTANCE){
    self.cl_lod_unit = FALSE;
  }
  
  if(self.cl_lod_unit){
    self.cl_lod_weapon = TRUE;
    if( vlen(CLIENT_vis_org - self.rootOrigin) > PARTICLE_HAZ_DISTANCE / 2 ){
      self.cl_lod_weapon = FALSE;
    }
    
    makevectors(self.angles);
    prevOrg = self.rootOrigin;
    prevAngle = self.angles;
    
    self.legs_org = self.rootOrigin + (v_right * self.legs_compOffset_x) + (v_forward * self.legs_compOffset_z) + (v_up * self.legs_compOffset_y);
    self.legs_angl = [0, self.angles_y, 0];
    self.legs_angl_y = self.legDir;
    
    self.frame = self.legs_frame;
    setmodel(self, self.legs_mdl);
    self.angles = self.legs_angl;
    self.origin = self.legs_org;
    self.colormod = CLR_DEF_WHITE * (self.legs_hp / self.legs_hpMax);
    addentity(self);
    self.origin = self.rootOrigin;
    self.angles = self.rootAngle;
    
    if( !(self.criticalHits & M_TOR_CENTER) ){
      if( strlen(self.torC_mdl ) > 0 ){
        self.torC_org = predraw_unit_part(self.torC_compOffset); 
        if((self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
          self.torC_angl_x = self.torC_angl_x * -1;
        }
        precache_model(self.torC_mdl);
        setmodel(self, self.torC_mdl);
        self.origin = self.torC_org;
        self.angles = self.torC_angl;
        
        self.colormod = CLR_DEF_WHITE * (self.torC_hp / self.torC_hpMax);
        
        addentity(self);
        self.origin = self.rootOrigin;
        self.angles = self.rootAngle;
      }
    }
    makevectors(self.torC_angl);
    if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.criticalHits & M_TOR_LEFT) ){
      if( strlen(self.torL_mdl ) > 0 ){
        self.torL_org = predraw_unit_part(self.torL_compOffset); 
        self.torL_angl = self.torC_angl;
        if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_L) ){
           self.torL_angl_x = self.torL_angl_x * -1;
        }
        precache_model(self.torL_mdl);
        setmodel(self, self.torL_mdl);
        self.angles = self.torL_angl;
        self.origin = self.torL_org;
        self.colormod = CLR_DEF_WHITE * (self.torL_hp / self.torL_hpMax);
        addentity(self);
        self.origin = self.rootOrigin;
        self.angles = self.rootAngle;
      }
    }
    
    if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.criticalHits & M_TOR_RIGHT) ){
      if( strlen(self.torR_mdl ) > 0 ){
        self.torR_org = predraw_unit_part(self.torR_compOffset); 
        self.torR_angl = self.torC_angl;
        if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_R) ){
           self.torR_angl_x = self.torR_angl_x * -1;
        }
        precache_model(self.torR_mdl);
        setmodel(self, self.torR_mdl);
        self.angles = self.torR_angl;
        self.origin = self.torR_org;
        self.colormod = CLR_DEF_WHITE * (self.torR_hp / self.torR_hpMax);
        addentity(self);
        self.origin = self.rootOrigin;
        self.angles = self.rootAngle;
      }
    }
    
    if( (self.unitModFlags & MOD_HAS_ARM_R) && !(self.criticalHits & M_ARM_RIGHT) ){
      if( strlen(self.armL_mdl ) > 0 ){
        self.armL_org = predraw_unit_part(self.armL_compOffset); 
        self.armL_angl = self.torC_angl;
        if((self.unitModFlags & MOD_MODEL_PITCH_ARM_L)){
          self.armL_angl_x = self.armL_angl_x * -1;
        }
        precache_model(self.armL_mdl);
        setmodel(self, self.armL_mdl);
        self.angles = self.armL_angl;
        self.origin = self.armL_org;
        self.colormod = CLR_DEF_WHITE * (self.armL_hp / self.armL_hpMax);
        addentity(self);
        self.origin = self.rootOrigin;
        self.angles = self.rootAngle;
      }
    }
    
   if( (self.unitModFlags & MOD_HAS_ARM_L) && !(self.criticalHits & M_ARM_LEFT) ){
      if( strlen(self.armR_mdl ) > 0 ){
        self.armR_org = predraw_unit_part(self.armR_compOffset); 
        self.armR_angl = self.torC_angl;
        if((self.unitModFlags & MOD_MODEL_PITCH_ARM_R)){
          self.armR_angl_x = self.armR_angl_x * -1;
        }
        precache_model(self.armR_mdl);
        setmodel(self, self.armR_mdl);
        self.angles = self.armR_angl;
        self.origin = self.armR_org;
        self.colormod = CLR_DEF_WHITE * (self.armR_hp / self.armR_hpMax);
        addentity(self);
        self.origin = self.rootOrigin;
        self.angles = self.rootAngle;
      }
    }
  }
  setsize(self, self.cache_mins, self.cache_maxs);
  self.colormod = CLR_DEF_WHITE;
};

void() mech_ai_die_stand1;

void() predraw_mech_corpse_legs={
  local vector cacheOrg;
  local vector cacheAngle;
  
  cacheOrg = self.origin;
  cacheAngle = self.angles;
  makevectors(self.angles);
  self.legs_org = self.origin + (v_forward * self.legs_compOffset_z) + (v_up * self.legs_compOffset_y) + (v_right * self.legs_compOffset_x);
  
  setmodel(self, self.legs_mdl);
  self.origin = self.legs_org;
  self.angles = self.legs_angl;
  addentity(self);
  
  self.origin = cacheOrg;
  self.angles = cacheAngle;
  
};

void() sendevent_mech_ai_die={
  local entity weps;
  local entity rem;
  local float wId;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  makevectors(self.angles);
  te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size * 2, '0.9 0.75 0.45', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.75)) * 100, 0 );
  
  self.colormod = '0.45 0.45 0.45';
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.effect1 = te_building_fire_start( self );
  self.effect1.origin = self.origin;
  self.effect1.origin_z = self.effect1.origin_z + self.maxs_z;
  self.legs_angl_y = self.legDir;
  self.legs_frame = self.unit_legs.frame;
  
  if( self.moveState == FALSE ){
    self.compOffset = self.origin;
    self.angles = self.torC_angl;
    self.angles_x = anglemod(self.angles_x + (crandom() * 20));
    self.angles_y = anglemod(self.angles_y + (crandom() * 10));
    self.predraw = predraw_mech_corpse;
    
    self.think = mech_ai_die_stand1;
    self.nextthink = time + 0.1;
  }
  else{
    self.predraw = predraw_mech_corpse_legs;
    self.classname = "wreck_mech";
    self.think = te_mech_dead_legs_burn;
    self.nextthink = servertime + frametime*0.5;
  }
  if( self.unit_legs && !wasfreed(self.unit_legs) ){
    remove(self.unit_legs);
  }
};

/*
  EVENT - CRITICAL =====================================
*/
void( float critical ) sendevent_mech_ai_crit={
  
  if( vlen(self.origin - CLIENT_vis_org) < PARTICLE_HAZ_DISTANCE){
    
    traceline(self.origin, CLIENT_vis_org, TRUE, self);
    
    if( trace_ent != world || trace_fraction == 1.0){
      if( ((self.unitModFlags & MOD_EXPLODE_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L)) && (critical & M_TOR_LEFT) ){
          te_missile_explode( self.torL_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      }
      if( ((self.unitModFlags & MOD_EXPLODE_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R)) && (critical & M_TOR_RIGHT) ){
          te_missile_explode( self.torR_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      }
      if( (self.unitModFlags & MOD_EXPLODE_ARM_L) && (critical & M_ARM_LEFT) ){
          te_missile_explode( self.armL_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      }
      if( (self.unitModFlags & MOD_EXPLODE_ARM_R) && (critical & M_ARM_RIGHT) ){
          te_missile_explode( self.armR_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      }
      if( (critical & M_LEGS) ){
        te_missile_explode( self.legs_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      }
    }
  }
  
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.75)) * 100, 0 );
};

void(float criticalHits) sendevent_mech_burn={  
  local vector offset;
  
  if( vlen(self.origin - CLIENT_vis_org) >= PARTICLE_HAZ_DISTANCE){
    return;
  }
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) && (criticalHits & M_TOR_LEFT) ){
    te_mech_crit( self.torL_org, '0 0 10');
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) && (criticalHits & M_TOR_RIGHT) ){
    te_mech_crit( self.torR_org, '0 0 10');
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) && (criticalHits & M_ARM_LEFT) ){
    if( !(self.critBits & M_TOR_LEFT) ){
      te_mech_crit( self.armL_org, '0 0 10');
    }
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) && (criticalHits & M_ARM_RIGHT) ){
    if( !(self.critBits & M_TOR_RIGHT) ){
      te_mech_crit( self.armR_org, '0 0 10');
    }
  }
  if( (criticalHits & M_LEGS) ){
    te_mech_crit( self.legs_org + '0 0 -10', '0 0 10');
  }
};
/*
  SendEntity - MECH AI =====================================
*/
void( float isNew, float changeFlags ) sendent_handle_mech_ai={
  local vector turretAng;
  local string newName;
  local float prevShield;
  local float prevDeadFlag;
  local float voiceId;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.moveState = ReadByte();
    if(self.moveState > 0 ){
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
    self.critBits = fabs(rint(ReadLong()));
    if( self.critBits != 0 ){
      sendevent_mech_ai_crit( self.critBits );
      self.criticalHits = self.criticalHits | self.critBits;
      self.critBits = 0;
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.ai_muted = ReadByte();
    self.subType = ReadChar();
    newName = ReadString();
    
    self.deadflag = ReadByte();
    if( self.deadflag != DEAD_NO ){
      self.criticalHits = fabs(rint(ReadLong()));
    }
  }
  
  if( isNew ){
    if( self.deadflag == DEAD_NO ){
      cacheGlobalString(self.netname, newName )
      self.think = mech_ai_think;
      self.nextthink = time + 0.01;
      data_sync_new_mech_ai( self.data_idx );
    }
    if(!self.unit_legs){
      self.unit_legs = spawn();
      self.unit_legs.skin = self.skin;
    }
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
    if( self.shieldHitFlag == 0 ){
      self.torC_hp = ReadByte() / 100 * self.torC_hpMax;
      self.torL_hp = ReadByte() / 100 * self.torL_hpMax;
      self.torR_hp = ReadByte() / 100 * self.torR_hpMax;
      self.armL_hp = ReadByte() / 100 * self.armL_hpMax;
      self.armR_hp = ReadByte() / 100 * self.armR_hpMax;
      self.legs_hp = ReadByte() / 100 * self.legs_hpMax;
    }
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
    self.critBits = fabs(rint(ReadLong()));
    if( self.critBits != 0 ){
      if( self.deadflag == DEAD_NO ){
        sendevent_mech_ai_crit( self.critBits );
      }
      self.criticalHits = self.criticalHits | self.critBits;
      self.critBits = 0;
    }
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = fabs(rint(ReadLong()));
    if( self.burnBits > 0 ){
      particleDraw = vlen(CLIENT_vis_org - self.origin);
      if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
        sendevent_mech_burn( self.burnBits );
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
  
  self.rootOrigin = self.origin;
  self.rootAngle = self.angles;
  
  traceline(self.origin, CLIENT_vis_org, FALSE, self);
  
  self.cl_lod_unit = TRUE;
  if( (trace_fraction != 1.0 && trace_ent == world) || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
    self.cl_lod_unit = FALSE;
  }
  
  if(self.cl_lod_unit){
    self.cl_lod_weapon = TRUE;
    if( vlen(CLIENT_vis_org - self.rootOrigin) > PARTICLE_HAZ_DISTANCE / 2 ){
      self.cl_lod_weapon = FALSE;
    }
    self.alpha = 1.0;
    self.scale = 1.0;
    self.renderflags = 0;
    
    makevectors(self.rootAngle);
    
    self.legs_org = self.rootOrigin + (v_right * self.legs_compOffset_x) + (v_forward * self.legs_compOffset_z) + (v_up * self.legs_compOffset_y);
    predraw_legs();
    
    if( !(self.criticalHits & M_TOR_CENTER) ){
      self.torC_org = predraw_unit_part(self.torC_compOffset); 
      if((self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
        self.torC_angl_x = self.torC_angl_x * -1;
      }
      setmodel(self, self.torC_mdl);
      self.angles = self.torC_angl;
      self.origin = self.torC_org;
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
        setmodel(self, self.torL_mdl);
        self.angles = self.torL_angl;
        self.origin = self.torL_org;
        addentity(self);
      }
    }
    
    if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
      if( !(self.criticalHits & M_TOR_RIGHT) ){
        self.torR_org = predraw_unit_part(self.torR_compOffset); 
        self.torR_angl = self.torC_angl;
        if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_R) ){
           self.torR_angl_x = self.torR_angl_x * -1;
        }
        setmodel(self, self.torR_mdl);
        self.angles = self.torR_angl;
        self.origin = self.torR_org;
        addentity(self);
      }
    }
    
    if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
      if( !(self.criticalHits & M_ARM_LEFT) ){
        self.armL_org = predraw_unit_part(self.armL_compOffset); 
        self.armL_angl = self.torC_angl;
        if((self.unitModFlags & MOD_MODEL_PITCH_ARM_L)){
          self.armL_angl_x = self.armL_angl_x * -1;
        }
        setmodel(self, self.armL_mdl);
        self.angles = self.armL_angl;
        self.origin = self.armL_org;
        addentity(self);
      }
    }
    
    if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
      if( !(self.criticalHits & M_ARM_RIGHT) ){
        self.armR_org = predraw_unit_part(self.armR_compOffset); 
        self.armR_angl = self.torC_angl;
        if((self.unitModFlags & MOD_MODEL_PITCH_ARM_R)){
          self.armR_angl_x = self.armR_angl_x * -1;
        }
        self.angles = self.armR_angl;
        self.origin = self.armR_org;
        setmodel(self, self.armR_mdl);
        
        addentity(self);
      }
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
  
  self.origin = self.rootOrigin;
  self.angles = self.rootAngle;
  setsize(self, self.cache_mins, self.cache_maxs);
  setorigin(self, self.origin);
  self.renderflags = 0 | RF_EXTERNALMODEL;
  self.alpha = 0.0;
  self.scale = 0.1;
  addentity(self);
  self.renderflags = 0;
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