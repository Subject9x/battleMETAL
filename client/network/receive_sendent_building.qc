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
  
  if( self.effect1.count && self.effect1 != world ){
    remove(self.effect1);
  }
  if( self.effect2.count && self.effect2 != world ){
    remove(self.effect2);
  }
  if( self.effect3.count && self.effect3 != world ){
    remove(self.effect3);
  }
  
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
};

/*
  SendEntity - Building =======================================
*/
void( float isNew, float changeFlags) sendent_handle_building={
  local float prevShield;
  
  prevShield = self.shield;
  self.energy = ReadShort();
  self.shield = ReadShort();
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());

    self.entId = ReadLong();
    self.data_idx = ReadByte();
    self.spawnflags = ReadLong();
  }    
  if( isNew ){
    makevectors(self.angles);
    data_sync_new_building(self.data_idx);
    self.data_type = DATA_BLD;
    self.flags = self.flags | (FL_MONSTER | FL_UNIT); 
    self.colormod = '1 1 1';
    setorigin(self, self.origin);
    self.drawmask = MASK_ENGINE;      
    self.scale = 1;
    self.alpha = 1;
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
  }
  
  //rider for desired stat changes
  if( (changeFlags & SENDFLAG_MOVE) ){
    if( self.data_idx == UI_BUILDING_repair_bay ){
      self.w_firetime = ReadByte();
      self.compAltOffset_x = ReadShort();
      self.compAltOffset_y = ReadShort();
      self.compAltOffset_z = ReadShort();
    }
    if( self.data_idx == UI_BUILDING_radar ){
      self.w_firetime = ReadByte();
    }
    if(  self.data_idx == UI_BUILDING_guard_tower ){
      self.partTypeId = ReadByte();
    }
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){     
    self.faction = ReadByte();
  }

  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadLong();
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

  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      self.origin_x = ReadCoord();
      self.origin_y = ReadCoord();
      self.origin_z = ReadCoord();
      
      self.angles_x = anglemod(ReadAngle());
      self.angles_y = anglemod(ReadAngle());
      self.angles_z = anglemod(ReadAngle());
      setorigin(self, self.origin);
      if( self.th_die ){
        self.th_die();
      }
      else{
        data_building_death1(); 
      }
    }
  } 
  
  //HANDLE EVENT - Shield explode
  sendevent_shield_explode( prevShield );
};