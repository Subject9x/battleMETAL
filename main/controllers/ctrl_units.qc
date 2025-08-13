/*
battleMETAL
Author: Peter Roohr
Date: 03/04/2020
Overview: 
  Controllers manage some state-level behavior for the target object.
    these are separated from model-control (animation).
  
  this particular set is generic functions for almost all units
*/

/*
  cleans player weapon groups
*/
void() ctrl_unit_clean_wgroups={
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.w_group4 = 0;
  self.currentWeaponGroup = 0;
};

/*
  Call's unit sub-piece's th_die() function but does not remove!
*/
void( entity comp ) ctrl_unit_part_death={
  if( comp.th_die && comp.deadflag >= DEAD_NO ){
    TEMP_ENT1 = self;
    self = comp;
      if( self.model ){
        if( (self != world) && (self.owner == TEMP_ENT1) ){
          self.th_die();
        }
      }
    self = TEMP_ENT1;
  }
};

/*
  Removes component from Unit, it's one-way so be careful!
*/
void(entity unitPiece) ctrl_unit_remove_piece={
  if( (unitPiece.owner == self) && unitPiece.partTypeId ){
    remove(unitPiece);
  }
};

/*
  putting map object SendEntity controllers here for a hot sec.
*/
/*
  OBJECT - Nav Point
*/
float( entity to, float changedFlags ) send_nav_point={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteLong( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_NAVP );
  //--------
  
  //EVENT - Nav isActive change
  if( (changedFlags & SENDFLAG_TURRET) ){
    WriteByte( MSG_ENTITY, self.isActive );
  }
  
  //EVENT - Nav Set Origin
  if( (changedFlags & SENDFLAG_MOVE) ){
    if( self.data_type == DATA_NAVP ){
      WriteCoord( MSG_ENTITY, self.origin_x );
      WriteCoord( MSG_ENTITY, self.origin_y );
      WriteCoord( MSG_ENTITY, self.origin_z );
    }
    else{
      WriteCoord( MSG_ENTITY, self.view_ofs_x );
      WriteCoord( MSG_ENTITY, self.view_ofs_y );
      WriteCoord( MSG_ENTITY, self.view_ofs_z );
    }
  }
  
  //EVENT - Nav Change Faction
  if( (changedFlags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  //EVENT - new to player
  if( (changedFlags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  return TRUE;
};


/*
  OBJECT - Mission Objective
*/
float( entity to, float changedFlags ) send_objective={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteLong( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_OBJT );
  //--------
  
  //EVENT - isActive change
  if( (changedFlags & SENDFLAG_TURRET) ){
    WriteByte( MSG_ENTITY, self.isActive );
    WriteByte( MSG_ENTITY, self.aState );
  }
  
  //EVENT - Set Origin
  if( (changedFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  
  //EVENT - Change Faction
  if( (changedFlags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  //EVENT - New Ent
  if( (changedFlags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  
  return TRUE;
};

/*
  OBJECT - Player Deploy point
*/
float( entity to, float changedFlags ) send_deploy_point={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteLong( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_DEPL );
  //============
  
  //EVENT - isActive change
  if( (changedFlags & SENDFLAG_TURRET) ){
    WriteByte( MSG_ENTITY, self.isActive );
  }
  
  //EVENT - Set Origin
  if( (changedFlags & SENDFLAG_MOVE) ){
    if( self.data_type == DATA_DEPL ){
      WriteCoord( MSG_ENTITY, self.origin_x );
      WriteCoord( MSG_ENTITY, self.origin_y );
      WriteCoord( MSG_ENTITY, self.origin_z );
    }
    else{
      WriteCoord( MSG_ENTITY, self.view_ofs_x );
      WriteCoord( MSG_ENTITY, self.view_ofs_y );
      WriteCoord( MSG_ENTITY, self.view_ofs_z );
    }
  }
  
  //EVENT - Change Faction
  if( (changedFlags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  //EVENT - New Ent
  if( (changedFlags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteByte( MSG_ENTITY, self.isActive );
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  return TRUE;
};


float( entity to, float changedFlags ) send_damage_zone={
  local float newFlags;
    
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteLong( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_MAP_DMG );
  //============
  
  if( (changedFlags & SENDFLAG_BURN) ){
    //use to adjust isActive, toggling the field
  }
  
  if( (changedFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.isActive );
  }
  
  if( (changedFlags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, 1 );
  }
  
  if( (changedFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  } 
  if( (changedFlags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
  
  if( (changedFlags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteLong( MSG_ENTITY, self.spawnflags );
    WriteByte( MSG_ENTITY, self.damageType );
    WriteShort( MSG_ENTITY, self.alpha );
    WriteLong( MSG_ENTITY, self.wait );
  }
  return TRUE;
};

