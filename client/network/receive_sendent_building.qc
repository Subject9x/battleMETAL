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
  EVENT - Death
*/
void() sendevent_building_die={
  
  local entity key, parentKey;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  self.solid = SOLID_NOT; //make sure to override so that particles won't trip.
  self.scale = 1; //just in case you altered scale during other deaths anim, <cough>
  self.alpha = 1; //just in case you altered alpha during other deaths anim, <cough>
  self.colormod = '0.75 0.75 0.75';
  makevectors(self.angles);
  switch( self.vec_size ){
    case 2:
      setmodel(self, "q3mdl/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel(self, "q3mdl/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
      break;
  }
  setorigin(self, self.origin + (v_up * -3));
  
  sendent_handle_remove(self.effect1);
  sendent_handle_remove(self.effect2);
  sendent_handle_remove(self.effect3);
  
  if( (self.spawnflags & 4194304) ){
    self.spawnflags = self.spawnflags - (self.spawnflags & 4194304);
    key = mapKeyObject;
    parentKey = world;
    while( key ){
      if( key == self ){
        if( parentKey && parentKey != world ){
          parentKey.w_slot = key.w_slot;
        }
        else{
          mapKeyObject = key.w_slot;
        }
      }
      parentKey = key;
      key = key.w_slot;
    }
  }
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
};

/*
  SendEntity - Building =======================================
*/
void( float isNew, float changeFlags) sendent_handle_building={
  local float prevShield;
  local float prevDeadflag;
  local float voiceId;
  
  prevShield = self.shield;
  prevDeadflag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_ENERGY) ){
    self.energy = ReadShort();
  }
  
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
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.spawnflags = ReadCoord();
    self.data_idx = ReadByte();
    setorigin(self, self.origin);
  }
  
  if( isNew ){
    self.predraw = predraw_building;
    self.drawmask = MASK_ENGINE;
    self.scale = 1;
    self.alpha = 1;
    makevectors(self.angles);
    if( self.deadflag == DEAD_NO ){
      data_sync_new_building(self.data_idx);
      self.data_type = DATA_BLD;
      self.flags = self.flags | FL_MONSTER; 
      self.colormod = '1 1 1';
      if( self.th_walk ){
        self.th_walk();
      }
      if( (self.spawnflags & 4194304) ){
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
      
      self.canTarget = TRUE;
      if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
        self.canTarget = FALSE;
      }
      self.takedamage = DAMAGE_AIM;
    }
    else{
      model_misc_building_ruins_set();
    }
    setorigin(self, self.origin);
    if( !(self.spawnflags & MUTE_ME)  ){
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
  
  //rider for desired stat changes
  if( (changeFlags & SENDFLAG_EXDATA) ){
    if( self.data_idx == UI_BUILDING_repair_bay ){
      self.burstRate = ReadByte();
      self.w_firetime = ReadByte();
      if(self.w_firetime > FALSE ){
        self.targetEntId = ReadCoord();
      }
    }
    if( self.data_idx == UI_BUILDING_radar ){
      self.w_firetime = ReadByte();
    }
    if(  self.data_idx == UI_BUILDING_guard_tower ){
      self.partTypeId = ReadByte();
    }
  }
  
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = ReadByte();
  }

  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadCoord();
    if( self.burnBits > 0 ){
      if( (self.burnBits & WEAPON1) && self.effect1.owner != self ){
        self.effect1 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.85;
      }
      if( (self.burnBits & WEAPON2) && self.effect2.owner != self ){
        self.effect2 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.75;
      }
      if( (self.burnBits & WEAPON3) && self.effect3.owner != self ){
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
  if(prevDeadflag == DEAD_NO && self.deadflag == DEAD_DEAD){
    if( self.th_die ){
      self.th_die();
    }
    else{
      data_building_death1(); 
    }
    return;
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

void() predraw_building={
  setorigin(self, self.origin);
  
  if(self.render_dlights){
    self.render_dlights();
  }
};