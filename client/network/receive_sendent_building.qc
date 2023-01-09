/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for turret buildings
  
  handles
    sv/main/controllers/ctrl_building.ctrl_send_building()
*/


/*
  isNew == TRUE 
  deadflag != DEAD_NO
*/
void() sendevent_building_new_ruins={
  self.scale = 1;
  self.alpha = 1;
  self.colormod = '1 1 1' * (random() * 0.5);
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;

  switch(self.vec_size){
    case 2:
      setmodel( self, "models/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel( self, "models/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel( self, "models/map/ruins/ruin_small.obj");
      break;
  }
  
  sendent_handle_remove(self.effect1);
  sendent_handle_remove(self.effect2);
  sendent_handle_remove(self.effect3);
};


/*
  EVENT - Death
*/
void() sendevent_building_die={
  local float zmid;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  self.solid = SOLID_NOT; //make sure to override so that particles won't trip.
  self.scale = 1; //just in case you altered scale during other deaths anim, <cough>
  self.alpha = 1; //just in case you altered alpha during other deaths anim, <cough>
  self.colormod = '1 1 1' * (random() * 0.5);
  
  switch( self.vec_size ){
    case 2:
      setmodel(self, "models/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel(self, "models/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel(self, "models/map/ruins/ruin_small.obj");
      break;
  }
  
  sendent_handle_remove(self.effect1);
  sendent_handle_remove(self.effect2);
  sendent_handle_remove(self.effect3);
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  self.think = SUB_Null;
  self.nextthink = time + 0.01;
};

/*
  SendEntity - Building =======================================
*/
void( float isNew, float changeFlags) sendent_handle_building={
  local float prevShield;
  local float prevDeadflag;
  local float prevBurn;
  local float voiceId;
  local float mapKey;
  local float vipKey;
  local float muted;
  
  prevShield = self.shield;
  prevDeadflag = self.deadflag;
  prevBurn = 0 | self.burnBits;
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    
    self.faction = ReadChar();
    self.vec_size = ReadChar();
    self.data_idx = ReadByte();
    self.canTarget = ReadChar();
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
    self.deadflag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = ReadChar();
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = fabs(rint(ReadLong()));
  }
  
  if( (changeFlags & SENDFLAG_ENERGY) ){
    self.energy = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
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
  
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  //rider for desired stat changes
  if( (changeFlags & SENDFLAG_EXDATA) ){
    if( self.data_idx == UI_BUILDING_repair_bay ){
      self.burstRate = ReadByte();
      self.critBits = fabs(rint(ReadLong()));
      if(self.critBits != FALSE ){
        self.targetEntId = ReadLong();
        self.enemy = findfloat( world, clientServerNum, self.targetEntId );
      }
      else{
        self.enemy = world;
      }
    }
    if( self.data_idx == UI_BUILDING_radar ){
      self.w_firetime = ReadByte();
    }
    if(  self.data_idx == UI_BUILDING_guard_tower ){
      self.partTypeId = ReadByte();
    }
  }
  
  //EVENT - voice chatter
  if( (changeFlags & SENDFLAG_VOICE) ){
    if( !(changeFlags & SENDFLAG_NEWENT) ){
      voiceId = ReadByte();
      snd_hud_trnsmsn_addtoqueue(self.ai_voice_group, voiceId, self.ai_voice_limit, self.entnum);
    }
  }
  
  if( isNew ){
    self.data_type = DATA_BLD;
    self.predraw = predraw_building;
    data_sync_new_building(self.data_idx); 
    if( self.deadflag == DEAD_NO ){
      if( (self.spawnflags & IS_MAPKEY) ){
        if( lastMapKeyObject ){
          //build linked list backwards for later forward iteration.
          lastMapKeyObject.w_slot = self;
          lastMapKeyObject = self;
        }
        else{
          //start chain
          mapKeyObject = self;
          lastMapKeyObject = self;
        }
      }
    }
    else if( self.deadflag == DEAD_DEAD){
      self.spawnflags = self.spawnflags - (self.spawnflags & IS_MAPKEY);
      self.spawnflags = self.spawnflags - (self.spawnflags & IS_VIP);
      sendevent_building_new_ruins();
    }
    
    setorigin(self, self.origin);
    if( !(self.spawnflags & MUTE_ME)  ){
      self.ai_muted = FALSE;
      ai_voice_ini( TRUE );
      self.ai_voice_limit = 1;
    }
  }
  
  //HANDLE EVENT - dead
  if( prevDeadflag == DEAD_NO && self.deadflag == DEAD_DYING ){
    self.colormod = '1 1 1';
    if( self.th_die ){
      self.th_die();
    }
    else{
      data_building_death1(); 
    }
  }
  else if( prevDeadflag == DEAD_DYING && self.deadflag == DEAD_DEAD ){
    sendevent_building_die();
  }
  
  if( self.deadflag == DEAD_NO ){
    //HANDLE EVENT - new burning fire
    if( self.burnBits != prevBurn && self.burnBits != FALSE ){
      if( (self.burnBits & WEAPON1) && self.effect1 != world ){
        self.effect1 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.85;
      }
      if( (self.burnBits & WEAPON2) && self.effect2 != world ){
        self.effect2 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.75;
      }
      if( (self.burnBits & WEAPON3) && self.effect3 != world ){
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

void() predraw_building={
  local vector cacheOrg;
  
  traceline(self.origin + [0,0, self.maxs_z], client_vis_org, FALSE, self);
  
  self.cl_lod_unit = TRUE;
  if( (trace_fraction != 1.0 && trace_ent == world) || vlen(client_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE * 2){
    self.cl_lod_unit = FALSE;
  }
  
  if( self.cl_lod_unit ){
    self.skin = self.faction - 1;
    setmodel(self, self.model);
    if(self.render_dlights){
      if( vlen(self.origin - client_vis_org) < PARTICLE_HAZ_DISTANCE){
        self.render_dlights();
      }
    }
    addentity(self);
  }
};