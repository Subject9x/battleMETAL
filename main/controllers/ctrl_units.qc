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
  Garbage collection on truly dead unit,
  one-way execution, use carefully.
*/
void() ctrl_unit_cleanup_player={
  if( (self.flags & FL_CLIENT) ){
    ctrl_unit_remove_cam(self.cockpit);
  }
  ctrl_unit_remove_piece(self.torsoCenter);
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.armLeft);
  ctrl_unit_remove_piece(self.armRight);
  ctrl_unit_remove_piece(self.legs);
  
  ctrl_weapon_remove_all();
  remove(self.hud_ent);
};

void() ctrl_unit_cleanup_mech={
  ctrl_unit_remove_piece(self.cockpit);
  ctrl_weapon_remove_all();
  ctrl_unit_remove_piece(self.armLeft);
  ctrl_unit_remove_piece(self.armRight);
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.torsoCenter);
  ctrl_unit_remove_piece(self.legs);
};

void() ctrl_unit_cleanup_tank={
  ctrl_unit_remove_piece(self.cockpit);
  ctrl_weapon_remove_all();
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.torsoCenter);
  ctrl_unit_remove_piece(self.legs);
};
/*
  Call's unit sub-piece's th_die() function but does not remove!
*/
void( entity comp ) ctrl_unit_part_death={
  local entity parentSelf;
  if( comp.th_die && comp.deadflag >= DEAD_NO ){
    parentSelf = self;
    self = comp;
      if( self.model ){
        if( (self != world) && (self.owner == parentSelf) ){
          self.th_die();
        }
      }
    self = parentSelf;
  }
};

/*
  Removes component from Unit, it's one-way so be careful!
*/
void(entity unitPiece) ctrl_unit_remove_piece={
  local entity this;
  if( (unitPiece.owner == self) && unitPiece.partTypeId ){
    remove(unitPiece);
  }
};

/*
  Deals with removing a player camera from the server.
*/
void(entity unitCam) ctrl_unit_remove_cam={
  self.weaponmodel = self.weaponmodel;
  self.weaponframe = 0;
  remove(self.cockpit);
};

/*
  putting map object SendEntity controllers here for a hot sec.
*/
/*
  OBJECT - Nav Point
*/
float( float isNew, float changedFlags ) send_nav_point={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteByte( MSG_ENTITY, changedFlags );
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
  if( (changedFlags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  return TRUE;
};


/*
  OBJECT - Mission Objective
*/
float( float isNew, float changedFlags ) send_objective={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteByte( MSG_ENTITY, changedFlags );
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
  if( (changedFlags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  
  return TRUE;
};

/*
  OBJECT - Player Deploy point
*/
float( float isNew, float changedFlags ) send_deploy_point={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteByte( MSG_ENTITY, changedFlags );
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
  if( (changedFlags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  //EVENT - New Ent
  if( (changedFlags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  
  return TRUE;
};


float( float isNew, float changedFlags ) send_damage_zone={
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_MAP );
  WriteByte( MSG_ENTITY, changedFlags );
  WriteByte( MSG_ENTITY, DATA_MAP_DMG );
  //============
  
  if( (changedFlags & SENDFLAG_MOVE) ){
    //changes damage types / boundary size
    WriteCoord( MSG_ENTITY, self.absmin_x );
    WriteCoord( MSG_ENTITY, self.absmin_y );
    WriteCoord( MSG_ENTITY, self.absmin_z );
    
    WriteCoord( MSG_ENTITY, self.absmax_x );
    WriteCoord( MSG_ENTITY, self.absmax_y );
    WriteCoord( MSG_ENTITY, self.absmax_z );
    
    WriteByte( MSG_ENTITY, self.damageType );
    WriteByte( MSG_ENTITY, self.count );
    WriteByte( MSG_ENTITY, self.count1 );
    WriteCoord( MSG_ENTITY, self.compAltOffset_x );
    WriteCoord( MSG_ENTITY, self.compAltOffset_y );
    WriteCoord( MSG_ENTITY, self.compAltOffset_z );
    WriteCoord( MSG_ENTITY, self.dest_x );
    WriteCoord( MSG_ENTITY, self.dest_y );
    WriteCoord( MSG_ENTITY, self.dest_z );
  }
  
  if( (changedFlags & SENDFLAG_BURN) ){
    //use to adjust isActive, toggling the field
    WriteByte( MSG_ENTITY, self.isActive );
  }
  
  if( (changedFlags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, self.spawnflags );
    WriteCoord( MSG_ENTITY, self.dest1_x );
    WriteCoord( MSG_ENTITY, self.dest1_y );
    WriteCoord( MSG_ENTITY, self.dest1_z );
  }
  return TRUE;
};

