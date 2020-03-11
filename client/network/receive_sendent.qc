/*
battleMETAL
Author: Peter Roohr
Date: 3/10/2020
Overview: 
  impl file for SendEntity functionality....sigh.
  I don't even know if it's worth it to try this.
*/

/*
  Entry point for handler api
*/
void( float isNew ) sendent_handle_update={
  local float entType;
  local float entFlags;
  
  entType = ReadByte();
  entFlags = ReadByte();

  switch(entType){
    case SENDTYPE_TANK:
      sendent_handle_tank( isNew, entFlags );
      break;
    case SENDTYPE_SPG:
      sendent_handle_spg( isNew, entFlags );
      break;
    case SENDTYPE_GEV:
      sendent_handle_gev( isNew, entFlags );
      break;
    case SENDTYPE_TURRET:
      sendent_handle_turret( isNew, entFlags );
      break;
    case SENDTYPE_BUILD:
      sendent_handle_building( isNew, entFlags );
      break;
  }
  client_get_contact();
};


void( float isNew, float changeFlags ) sendent_handle_tank={
  local float turretModelID;
  local float turretFlag;
  local entity turret;
  local vector turretAng;
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    setorigin(self, self.origin);
    
    if( self.torsoCenter != world){
      makevectors(self.angles);
      self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
  }
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
    if( self.torsoCenter != world ){
      self.torsoCenter.angles_x = turretAng_x;
      self.torsoCenter.angles_y = turretAng_y;
      self.torsoCenter.angles_z = turretAng_z;
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    setmodelindex(self, ReadByte());
    self.skin =  ReadByte();
    self.drawmask = MASK_ENGINE;
    turretFlag = ReadByte();
    if( turretFlag  ){
      turretModelID = ReadByte();
      turret = spawn();
      setmodelindex(turret, turretModelID);
      turret.compOffset_x = ReadCoord();
      turret.compOffset_y = ReadCoord();
      turret.compOffset_z = ReadCoord();
      turret.drawmask = MASK_NORMAL;
      self.torsoCenter = turret;
    }
  }
};

void( float isNew, float changeFlags) sendent_handle_spg={
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    setorigin(self, self.origin);
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    setmodelindex(self, ReadByte());
    self.skin =  ReadByte();
    self.drawmask = MASK_ENGINE;
  }
};

void( float isNew, float changeFlags) sendent_handle_gev={
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    setorigin(self, self.origin);
    if( self.torsoCenter ){
      makevectors(self.angles);
      self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
  }
  if( (changeFlags & SENDFLAG_TURRET) ){
    //self.torsoCenter.angles_x = ReadCoord();
    //self.torsoCenter.angles_y = ReadCoord();
    //self.torsoCenter.angles_z = ReadCoord();
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    setmodelindex(self, ReadByte());
    self.skin =  ReadByte();
    self.drawmask = MASK_ENGINE;
    if( (self.flags & FL_TURRET) ){
      //self.torsoCenter = spawn();
      ///setmodelindex(self.torsoCenter, ReadByte());
      //self.torsoCenter.compOffset_x = ReadCoord();
      //self.torsoCenter.compOffset_y = ReadCoord();
      //self.torsoCenter.compOffset_z = ReadCoord();
      //self.torsoCenter.drawmask = MASK_NORMAL;
    }
  }
};

void( float isNew, float changeFlags) sendent_handle_turret={
  local vector turretAng;
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
    if( self.torsoCenter != world ){
      self.torsoCenter.angles_x = turretAng_x;
      self.torsoCenter.angles_y = turretAng_y;
      self.torsoCenter.angles_z = turretAng_z;
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    setorigin(self, self.origin);
    
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    
    data_sync_new_turret(self.data_idx);
    
    self.drawmask = MASK_ENGINE;
    
  }
};

void( float isNew, float changeFlags) sendent_handle_building={
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
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
  }

  if( (changeFlags & SENDFLAG_NEWENT) ){
    
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    setorigin(self, self.origin);
    
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    
    data_sync_new_building(self.data_idx);
    
    self.drawmask = MASK_ENGINE;
  }
};