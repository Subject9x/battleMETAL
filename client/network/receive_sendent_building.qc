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
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  self.scale = 1; //just in case you altered scale during other deaths anim, <cough>
  self.alpha = 1; //just in case you altered scale during other deaths anim, <cough>
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
    
    local entity key, parentKey;
    
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
  
  prevShield = self.shield;
  prevDeadflag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_ENERGY) ){
    self.energy = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
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
    self.deadflag = DEAD_NO;
    self.predraw = predraw_building;
    self.drawmask = MASK_ENGINE;
    self.scale = 1;
    self.alpha = 1;
    makevectors(self.angles);
    data_sync_new_building(self.data_idx);
    self.data_type = DATA_BLD;
    self.flags = self.flags | FL_MONSTER; 
    self.colormod = '1 1 1';
    setorigin(self, self.origin);
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
  
  //HANDLE EVENT - Shield explode
  sendevent_shield_explode( prevShield );
  
  //Shield strike event
  if( self.shieldHitFlag == TRUE && (self.shield > 0 && self.shield < 100.01)){
    if( time > self.shieldEffectTime ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
  
  //HANDLE EVENT - dead
  if( self.deadflag > DEAD_NO && prevDeadflag == DEAD_NO){
    if( self.th_die ){
      self.th_die();
    }
    else{
      data_building_death1(); 
    }
  }
};

float() predraw_building={
  setorigin(self, self.origin);
  
  if(self.render_dlights){
    self.render_dlights();
  }
  
  return FALSE;
};