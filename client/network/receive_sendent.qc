/*
battleMETAL
Author: Peter Roohr
Date: 3/10/2020
Overview: 
  impl file for SendEntity functionality....sigh.
  I don't even know if it's worth it to try this.
*/



void(entity enEntity) GetAlignedSurfaceAngles=
{ // Return Aligned Surface Angles
	// NOTE: div0 from Team Alientrap completely designed this algorithm.
	// Thanks div0!
	// Acquire Surface Normal
	traceline (enEntity.origin, enEntity.origin - '0 0 256', TRUE, enEntity);
	
	if(trace_fraction != 1)
	{ // Trace Found Surface; Continue
		local vector vNormal;
			vNormal = trace_plane_normal;
		
		// Derive Vectors
		makevectors(enEntity.angles);
			
		// Assign Aligned Angles
		enEntity.angles = vectoangles( normalize(v_forward - ( (v_forward * vNormal) / (v_up * vNormal)) * v_up) );
	}
}


void() sendent_empty_think={
  
  self.think = sendent_empty_think;
  self.nextthink = time + 0.001;
};

void() sendent_ai_think={
  local vector v1;
  
  makevectors(self.v_angle);
  v1 = self.origin;
  traceline(v1, v1 + v_forward*10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  
  self.think = sendent_ai_think;
  self.nextthink = time + 0.001;
};
//implementing parts of Spike's CSQC-only mod code here
void() interpolate_origin={
  local float newLerp;
  //interpolate origins and angles so that they're synced to the thinks.
  //interpolation = latency.
  if (self.nextthink != self.frame1time)
  {
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    self.frame2 = self.frame1;
    self.frame1 = self.frame;
    self.origin2 = self.origin1;
    self.origin1 = self.origin;
    self.angle2 = self.angle1;
    self.angle1 = self.angles_y;
  }
  newLerp = (time - self.frame2time) /(self.frame1time - self.frame2time);
  newLerp = 1 - bound(0, newLerp, 1);
  self.lerpfrac = newLerp;
  self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
};

void() interpolate_angle={
  local float savedang;
  local float dir;
 
  savedang = self.angles_y;
  dir = (self.angle2-self.angle1);
  if (dir > 180){
    dir -= 360;
  }
  else if (dir < -180){
    dir += 360;
  }
  self.angles_y = self.angle1 + (dir*self.lerpfrac);
};

void() interpolate_ground={
  if (self.flags & (FL_ONGROUND|FL_PARTIALGROUND|FL_FLY|FL_SWIM))
  {
    //while its onground, it should move at the same animation speed as it animates
    vector saved = self.origin;						
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    if (self.flags & (FL_ONGROUND|FL_PARTIALGROUND)){
      self.origin_z = saved_z;	//try and avoid monsters on plats juddering separately from the plat_center_touch. could probably do something better based on dotproducts with the direction of motion or something. not sure.
    }
    self.origin = saved;
  }
  else
  {
    //but if its in free-fall, don't lag it.
    //no nasty surprises when it does hit the ground please.
    self.origin2 = self.origin1 = self.origin;
  }
};
//-----------------------------------

/*
  Entry point for handler api
*/
void( float isNew ) sendent_handle_update={
  local float entType;
  local float entFlags;
  
  entType = ReadByte();
  entFlags = ReadCoord(); //expanding entFlags values -> data/common
  
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
    case SENDTYPE_TERRAIN:
      sendent_handle_terrain( isNew, entFlags );
      break;
    case SENDTYPE_MISC:
      sendent_handle_misc( isNew, entFlags );
      break;
    case SENDTYPE_MISC_BLD:
      sendent_handle_misc_bld( isNew, entFlags );
      break;
  }
};

/*
  SendEntity - Map Objects ====================================
*/
void( float isNew, float changeFlags ) sendent_handle_terrain={
  if( (changeFlags & SENDFLAG_NEWENT) ){
    setmodel( self, modelnameforindex(ReadShort()) );
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.angles_x = ReadAngle();
    self.angles_y = ReadAngle();
    self.angles_z = ReadAngle();
  }
  if(isNew){
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
    self.drawmask = MASK_ENGINE;
    self.solid = SOLID_BSP;
    self.movetype = MOVETYPE_NONE;
    self.classname = "map_terrain";
  }
};

/*
  SendEntity - Map Objects ====================================
*/
void( float isNew, float changeFlags ) sendent_handle_misc={
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = ReadAngle();
    self.angles_y = ReadAngle();
    self.angles_z = ReadAngle();
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    setmodel( self, modelnameforindex(ReadCoord()) );
  }
  
  if(isNew){
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
    self.drawmask = MASK_ENGINE;
    self.solid = SOLID_BSP;
    self.movetype = MOVETYPE_NONE;
    self.deadflag = DEAD_NO;
    self.data_type = DATA_BLD;
  }
};


/*
  SendEntity - Map Objects ====================================
*/
void( float isNew, float changeFlags ) sendent_handle_misc_bld={
  local float prevDeadflag;
  
  prevDeadflag = self.deadflag;
  
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
    self.angles_x = ReadAngle();
    self.angles_y = ReadAngle();
    self.angles_z = ReadAngle();
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.vec_size = ReadByte();
    self.data_idx = ReadByte();
    self.faction = ReadByte();
    self.canTarget = ReadByte();
  }
  
  if(isNew){
    self.drawmask = MASK_ENGINE;
    if( self.deadflag == DEAD_NO ){
      self.solid = SOLID_BSP;
      self.movetype = MOVETYPE_NONE;
      model_misc_building_set();
    }
    else{
      model_misc_building_ruins_set();
    }
  }
  
  if( self.deadflag > DEAD_NO && prevDeadflag == DEAD_NO ){
    te_missile_explode( self.origin + (v_up * self.maxs_z * 0.5), self.vec_size, '0.9 0.75 0.45', 0.005 );
    sound7(self, CHAN_AUTO, "sound/fire/debris1.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.75)) * 100, 0 );
    model_misc_building_ruins_set();
  }
};

/*
  SendEntity - Projectile ====================================
*/
void() sendent_missile_think={
  if( (self.origin1 != world.origin) && (self.origin2 != world.origin) ){
    if( self.traileffectnum ){
      trailparticles(world, self.traileffectnum, self.origin2, self.origin1);
    }
  }
  self.think = sendent_missile_think;
  self.nextthink = time + 0.001;
};

void( float isNew, float changeFlags ) sendent_handle_missile={
  local float ownerId;
  local float prevImpactType;
  
  prevImpactType = self.impactType;
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.damageValue = ReadByte();
    ownerId = ReadCoord();
    self.owner = findfloat(world, entnum, ownerId);
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    self.oldvelocity = self.velocity;
    self.velocity_x = ReadShort();
    self.velocity_y = ReadShort();
    self.velocity_z = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    //only if you want to override angles == velocity;
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
  }
  
  if( changeFlags & SENDFLAG_IMPACT ){
    self.impactType = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    self.vec_size = ReadByte();
  }
  
  if( isNew ){
    self.solid = SOLID_BBOX;
    self.alpha = 1;
    self.scale = 1;
    if( self.data_idx == UID_ITEM_debris ){
      data_sync_new_debris( self );
    }
    else{
      data_sync_new_projectile(self.data_idx);
    }
    setmodel(self, self.model);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, self.origin);
    sendent_missile_think();
    self.drawmask = MASK_ENGINE;
    interpolate_origin();
    self.predraw = predraw_missile;
  }
  
  self.angles = vectoangles(self.velocity);
  //HANDLE EVENT - projectile hit.
  if( self.impactType > 0 && prevImpactType == FALSE ){
    if( self.pcl_explode ){
      self.pcl_explode();
    }
    self.velocity = '0 0 0';
  }
};

/*
  EVENT - Shields are eliminated
*/
void( float prevShield ) sendevent_shield_explode={
  //Shield Explode event
  if( self.shield > 100 && (prevShield <= 100 && prevShield != 0) ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
};


/*
  EVENT - entity attackFlag != 0, indicating an attack has been made by weapons
    scope = self is owning unit
*/
void() sendevent_handle_weaponfire={
  local entity equip;
  
  equip = self.w_slot;
  while( equip != world ){
    if( (self.attackFlag & equip.w_group) && equip.itemMuzzleFlash ){
      te_weapon_fire_handler(equip);
    }
    equip = equip.w_slot;
  }
};

/*
  EVENT - Turret rotated
*/
void( vector turretAngles ) sendevent_turret_update={
  if( self.torsoCenter != world ){
    self.torsoCenter.angles_x = anglemod(turretAngles_x);
    self.torsoCenter.angles_y = anglemod(turretAngles_y);
    self.torsoCenter.angles_z = anglemod(turretAngles_z);
  }
};

void() sendent_ini_interpolate={
  if (self.nextthink != self.frame1time){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    self.frame2 = self.frame1;
    self.frame1 = self.frame;
    self.origin2 = self.origin1;
    self.origin1 = self.origin;
    self.angle2 = self.angle1;
    self.angle1 = self.angles_y;
  }
  self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);
};

void() sendent_setup_weapons={
  local entity this;
  local entity weps;
  
  this = self;
  weps = self.w_slot;
  while( weps != world ){
    self = weps;
      self.owner = this;
      sendent_set_weapon();
      if( (this.flags & FL_DISARMED) ){
        initialize_data_item_(UID_ITEM_EMPTY);
      }
      else{
        initialize_data_item_(self.data_idx);
      }
      self.movetype = MOVETYPE_NONE;
      self.solid = SOLID_NOT;
      setsize(self, '-1 -1 -1', '1 1 1');
      setmodel(self, self.model);
      if( self.partParentId == M_LEGS ){
        makevectors(this.angles);
        self.origin = this.origin + (v_forward * self.compOffset_z) + (v_right * self.compOffset_x) + (v_up * self.compOffset_y);
        self.angles = this.angles;
      }
      else{
        makevectors(this.torsoCenter.angles);
        self.origin = this.torsoCenter.origin + (v_forward * self.compOffset_z) + (v_right * self.compOffset_x) + (v_up * self.compOffset_y);
        self.angles = this.torsoCenter.angles;
      }
      self.drawmask = MASK_NORMAL;
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
    default:
      self.data_idx = 0;
      break;
  }
};