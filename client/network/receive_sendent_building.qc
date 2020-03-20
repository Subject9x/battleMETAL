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
  SendEntity - Building =======================================
*/
void( float isNew, float changeFlags) sendent_handle_building={
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      
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
      setorigin(self, self.origin + (v_up * -10));
    }
  }

  if( (changeFlags & SENDFLAG_CRIT) ){
    if( self.effect1 ){
      if( self.effect2 ){
        if( !self.effect3 ){
          self.effect3 = te_building_fire_start( self );
        }
      }
      else{
        self.effect2 = te_building_fire_start( self );
      }
    }
    else{
      self.effect1 = te_building_fire_start( self );
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadCoord());
    self.angles_y = anglemod(ReadCoord());
    self.angles_z = anglemod(ReadCoord());
    
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    
    if( isNew ){
      self.solid = SOLID_SLIDEBOX;
      self.movetype = MOVETYPE_NONE;
      data_sync_new_building(self.data_idx);
      self.data_type = DATA_BLD;
      self.flags = self.flags | (FL_MONSTER | FL_UNIT); 
      self.colormod = '1 1 1';
      setorigin(self, self.origin);
      self.drawmask = MASK_ENGINE;
    }
  }
};