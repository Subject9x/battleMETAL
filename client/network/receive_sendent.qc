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
    enEntity.cacheGroundAngle = enEntity.angles;
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
  self.nextthink = time + 0.0001;
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
  dir = (self.angle2 - self.angle1);
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

void() predraw_building_msc={
  
  traceline(self.origin + [0,0, self.maxs_z], client_vis_org, FALSE, self);
  
  self.cl_lod_unit = TRUE;
  if( (trace_fraction != 1.0 && trace_ent == world) || vlen(client_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE * 2){
    self.cl_lod_unit = FALSE;
  }
  
  if( self.cl_lod_unit ){
    setmodel(self, self.model);
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
    addentity(self);
  }
};

void( float isNew, float changeFlags ) sendent_handle_misc_bld={
  local float prevDeadflag;
  local float mapKey;
  local float vipKey;
  
  prevDeadflag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    
    self.faction = ReadByte();
    self.vec_size = ReadByte();
    self.data_idx = ReadByte();
    self.canTarget = ReadByte();
    mapKey = ReadChar();
    vipKey = ReadChar();
    if( mapKey ){
      self.spawnflags = self.spawnflags | IS_MAPKEY;
    }
    if( vipKey ){
      self.spawnflags = self.spawnflags | IS_VIP;
    }
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
  }
  
  if(isNew){
    model_misc_building_set();
    self.predraw = predraw_building_msc;
    if( self.deadflag == DEAD_NO ){
      self.solid = SOLID_BSP;
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
    else{
      self.spawnflags = self.spawnflags - (self.spawnflags & IS_MAPKEY);
      self.spawnflags = self.spawnflags - (self.spawnflags & IS_VIP);
      self.solid = SOLID_NOT;
      model_misc_building_ruins_set();
    }
  }
  
  //HANDLE EVENT - dead
  if( prevDeadflag == DEAD_NO && self.deadflag == DEAD_DYING ){
    if( self.th_die ){
      self.th_die();
    }
    else{
      data_building_death1(); 
    }
  }
  else if( prevDeadflag == DEAD_DYING && self.deadflag == DEAD_DEAD ){
    model_misc_building_die();
  }
};

/*
  SendEntity - Projectile ====================================
*/
void() sendent_missile_think={

  if( self.deadflag == DEAD_NO ){
    if( vlen(self.origin - client_vis_org) < PARTICLE_HAZ_DISTANCE){
      if( self.traileffectnum ){
        trailparticles(world, self.traileffectnum, self.origin, self.origin1 );
      }
    }
  }
  
  self.think = sendent_missile_think;
  self.nextthink = time + 0.01;
};

void( float isNew, float changeFlags ) sendent_handle_missile={
  local float ownerId;
  local float prevImpactType;
  
  prevImpactType = self.impactType;
  
  self.oldvelocity = self.velocity;
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.damageValue = ReadByte();
    ownerId = ReadLong();
    self.owner = findfloat(world, entnum, ownerId);
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    self.velocity_x = ReadLong();
    self.velocity_y = ReadLong();
    self.velocity_z = ReadLong();
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
    self.deadflag = DEAD_NO;
    self.alpha = 1;
    self.scale = 1;
    self.think = sendent_missile_think;
    self.nextthink = time + 0.001;
    sendent_ini_interpolate();
    if( self.data_idx == UID_ITEM_debris ){
      data_sync_new_debris( self );
    }
    else{
      data_sync_new_projectile(self.data_idx);
      self.predraw = predraw_missile;
    }
    setmodel(self, self.model);
    setsize(self, '0 0 0', '0 0 0');
  }
  
  self.angles = vectoangles(self.velocity);
  //HANDLE EVENT - projectile hit.
  if( self.impactType > 0 && prevImpactType == FALSE ){
    self.deadflag = DEAD_DEAD;
    if( self.pcl_explode ){
      self.pcl_explode();
    }
    self.velocity = '0 0 0';
  }
};

/*
  Promoted weapons to fully qualified and synced entities, the server
  needs to track these so why not just send the bare minimum over to the client?
*/
void( float isNew, float changeFlags ) sendent_handle_item={
  local float prevIdx;
  
  
  prevIdx = self.data_idx;
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.owner = findfloat(world, entnum, ReadLong());
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.owner = findfloat(world, entnum, ReadLong());
    self.w_group = rint(ReadLong());
    self.partParentId = rint(ReadLong());
    self.compOffset_x = ReadAngle();
    self.compOffset_y = ReadAngle();
    self.compOffset_z = ReadAngle();
  }
  
  if( (changeFlags & SENDFLAG_NEWUNIT) ){
    self.owner = findfloat(world, entnum, ReadLong());
    self.data_idx = ReadByte();
  }
  if( (changeFlags & SENDFLAG_DEAD) ){
  }
  
  if(self.data_idx != prevIdx && self.data_idx != 0){
    initialize_data_item_(self.data_idx);
    if(self.owner != world){
      switch(self.w_group){
        default:
          self.owner.weaponEnt1 = self;
          break;
        case WEAPON2:
          self.owner.weaponEnt2 = self;
          break;
        case WEAPON3:
          self.owner.weaponEnt3 = self;
          break;
        case WEAPON4:
          self.owner.weaponEnt4 = self;
          break;
        case WEAPON5:
          self.owner.weaponEnt5 = self;
          break;
        case WEAPON6:
          self.owner.weaponEnt6 = self;
          break;
        case WEAPON7:
          self.owner.weaponEnt7 = self;
          break;
        case WEAPON8:
          self.owner.weaponEnt8 = self;
          break;
        case WEAPON9:
          self.owner.weaponEnt9 = self;
          break;
      }
    }
  }
  
  if(isNew){
    //self.predraw = predraw_weapon_ent;
    self.deadflag = DEAD_NO;
    self.classname = "UNIT_ITEM";
    if( (self.owner.flags & FL_CLIENT) && self.owner.clientServerNum == player_localentnum ){
      CLIENT_weapon_state = CLIENT_weapon_state |  self.w_group;
    }
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
  local float wepId;
  
  particleDraw = vlen(client_vis_org - self.origin);
  
  wepId = 0;
  
  while( wepId < self.hardpoint_cnt){
    equip =  sendent_get_weapon( bitshift(1, wepId) );
    
    if( equip ){
      if( (self.attackFlag & equip.w_group) && equip.itemMuzzleFlash ){
        te_weapon_fire_handler(equip);
      }
    }
    
    wepId = wepId + 1;
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
  else{
    //dummy interpolate
    self.frame2time = 1;
    self.frame1time = 2;
  }
  self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);
};

vector( vector partOffset) predraw_unit_part={
  local vector offset;
  
 offset = self.origin + (v_right * partOffset_x) + (v_up * partOffset_y) + (v_forward * partOffset_z);
  
  if(self.clientServerNum == player_localentnum && cvar("chase_active") == FALSE){
    offset = offset - (v_forward * self.cameraOffset_z);
  }
  
  return offset;
};

vector( vector partOffset, .vector partAngles) predraw_unit_part_and_angle={
  local vector offset;
  
 offset = self.origin + (v_right * partOffset_x) + (v_up * partOffset_y) + (v_forward * partOffset_z);
  
  if(self.clientServerNum == player_localentnum && cvar("chase_active") == FALSE){
    offset = offset - (v_forward * self.cameraOffset_z);
  }
  
  self.partAngles_y = self.angles_y;
  self.partAngles_x = 0;
  return offset;
};



/*
  Player weapons (usually in the arms) inherit their pitch from their parent piece.
  therefore, the weapon offsets for CLIENT is based on the PARENT offset:
    wep.origin = parent.origin + wep.offset 
      where parent.origin has already been calculated.
*/
void(entity item) predraw_unit_weapon={
  local vector pOfs;
  local vector drawAng;
  local vector offset;
  local vector adjPartOffset;
  
  if(self.deadflag == DEAD_DEAD ){
    return;
  }
  if( item.model == "" ){
    return;
  }
  if( (self.criticalHits & item.partParentId) ){
    return;
  }
  
  util_getPartFromName( item.partParentId, self);
  
  adjPartOffset = item.compOffset - T_PART_PARENT_OFFSET;
  
  offset = T_PART_PARENT_ORG;
  drawAng = T_PART_PARENT_ANGL;
  drawAng_x = drawAng_x *-1;
  makevectors( drawAng);
  offset = offset + (v_up * adjPartOffset_y) + (v_right * adjPartOffset_x) + (v_forward * adjPartOffset_z);
  
  //we ignore FPV z offset because player muzzle flash for view-tracking in FPV should match actual game coords.
  
  setmodel(item, item.model);
  item.origin = offset;
  item.angles = T_PART_PARENT_ANGL;
  addentity(item);
};

entity(float weaponId) sendent_get_weapon={
  switch(weaponId){
     case WEAPON1:
      return self.weaponEnt1;
     case WEAPON2:
      return self.weaponEnt2;
     case WEAPON3:
      return self.weaponEnt3;
     case WEAPON4:
      return self.weaponEnt4;
     case WEAPON5:
      return self.weaponEnt5;
     case WEAPON6:
      return self.weaponEnt6;
     case WEAPON7:
      return self.weaponEnt7;
     case WEAPON8:
      return self.weaponEnt8;
     case WEAPON9:
      return self.weaponEnt9;
    default:
      return world;
  }
  return world;
};

/*
  SendEntity - Map Objects ====================================
  5.0.0
    I'm not sure this is exactly needed anymore.

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
    self.skin = ReadByte();
    self.modelindex = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    //todo - dead event.
  }
  
  if(isNew){
    self.movetype = MOVETYPE_NONE;
    self.deadflag = DEAD_NO;
    setmodel( self, modelnameforindex(self.modelindex) );
    setsize(self, self.mins, self.maxs);
    self.skin = self.skin;
    setorigin(self, self.origin);
    self.drawmask = 0;
  }
};
*/