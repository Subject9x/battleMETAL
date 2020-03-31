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
    case SENDTYPE_PLAYER:
      sendent_handle_player( isNew, entFlags );
      break;
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
    case SENDTYPE_MECH_AI:
      sendent_handle_mech_ai( isNew, entFlags );
      break;
    case SENDTYPE_PROJ:
      sendent_handle_missile( isNew, entFlags );
      break;
    case SENDTYPE_MAP:
      sendent_handle_map( isNew, entFlags );
      break;
  }
};

/*
  SendEntity - Projectile ====================================
*/
void( float isNew, float changeFlags) sendent_handle_missile={
  local float impactEvent;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = anglemod(ReadAngle());
  self.angles_y = anglemod(ReadAngle());
  self.angles_z = anglemod(ReadAngle());

  self.velocity_x = ReadCoord();
  self.velocity_y = ReadCoord();
  self.velocity_z = ReadCoord();

  if( changeFlags & SENDFLAG_IMPACT ){
    self.impactType = ReadByte();
    self.damageValue = ReadByte();
    if( self.pcl_explode ){
      self.pcl_explode();
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.damageValue = ReadByte();
    self.movetype = ReadByte();
    
    if( isNew ){
      self.solid = SOLID_NOT;
      self.alpha = 1;
      self.scale = 1;
      self.origin2 = self.origin;
      self.origin1 = self.origin;
      data_sync_new_projectile(self.data_idx);
      setmodel(self, self.model);
      setsize(self, '0 0 0', '0 0 0');
      setorigin(self, self.origin);
      self.drawmask = MASK_NORMAL;
      self.predraw = predraw_missile;
      self.nextthink = time + 0.1;
    }
  }
};

float() predraw_weapon={
  local vector ofs;
  local entity part;
  //makevectors(self.angles);
  //self.origin = self.owner.origin +(v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
  //setorigin(self, self.origin);
  return TRUE;
};

/*
  EVENT - Shields are eliminated
*/
void( float prevShield ) sendevent_shield_explode={
  //Shield Explode event
  if( self.shield <= 0 && prevShield > 0 ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
};


/*
  EVENT - Turret rotated
*/
void( vector turretAngles ) sendevent_turret_update={
  local entity weps;
  local vector angl;
  if( self.torsoCenter != world ){
    self.torsoCenter.angles_x = anglemod(turretAngles_x);
    self.torsoCenter.angles_y = anglemod(turretAngles_y);
    self.torsoCenter.angles_z = anglemod(turretAngles_z);
  }
};

void() sendent_ini_interpolate={
  self.frame2time = time + 0.05;
  self.frame1time = time + 0.05;
  self.origin2 = self.origin1;
  self.origin1 = self.origin;
  self.nextthink = time + 0.1;
};

void() sendent_setup_weapons={
  local entity this;
  local entity weps;
  this = self;
  weps = self.w_slot;
  while( weps != world ){
    self = weps;
      sendent_set_weapon();
      initialize_data_item_(self.data_idx);
      self.angles = this.angles;
      self.owner = this;
      self.movetype = MOVETYPE_NONE;
      self.solid = SOLID_NOT;
      setsize(self, '-1 -1 -1', '1 1 1');
      setmodel(self, self.model);
      if( self.partParentId == M_LEGS ){
        makevectors(this.angles);
        setorigin(self, this.origin + (v_forward * self.compOffset_z) + (v_right * self.compOffset_x) + (v_up * self.compOffset_y));
      }
      else{
        makevectors(this.torsoCenter.angles);
        setorigin(self, this.torsoCenter.origin + (v_forward * self.compOffset_z) + (v_right * self.compOffset_x) + (v_up * self.compOffset_y));
      }
    self = this;
    weps = weps.w_slot;
  }
};

entity( float partId ) sendent_get_entity_offset={
  switch( partId ){
    case M_TOR_CENTER:
      if( (self.flags & FL_TURRET) ){
        return self.torsoCenter;
      }
      return self;
    case M_TOR_RIGHT:
      return self.torsoRight;
    case M_TOR_LEFT:
      return self.torsoLeft;
    case M_LEGS:
      if( (self.data_type == DATA_VEHC) ){
        return self;  //edge case for hull-mounted weapons on a turreted object
      }
      return self.legs;
    case M_ARM_LEFT:
      return self.armLeft;
    case M_ARM_RIGHT:
      return self.armRight;
    default:
      return self;
  }
};

void() sendent_set_weapon={
  switch(self.w_group){
     case WEAPON1:
      self.data_idx = self.owner.next_wepn1;
      break;
     case WEAPON2:
      self.data_idx = self.owner.next_wepn2;
      break;
     case WEAPON3:
      self.data_idx = self.owner.next_wepn3;
      break;
     case WEAPON4:
      self.data_idx = self.owner.next_wepn4;
      break;
     case WEAPON5:
      self.data_idx = self.owner.next_wepn5;
      break;
     case WEAPON6:
      self.data_idx = self.owner.next_wepn6;
      break;
     case WEAPON7:
      self.data_idx = self.owner.next_wepn7;
      break;
     case WEAPON8:
      self.data_idx = self.owner.next_wepn8;
      break;
     case WEAPON9:
      self.data_idx = self.owner.next_wepn9;
      break;
  }
};
