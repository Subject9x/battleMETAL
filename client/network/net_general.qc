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
  
  
  if((self.flags & FL_TURRET)){
    makevectors(self.torC_angl);
    v1 = self.torC_org;
  }
  else{
    makevectors(self.angles);
    v1 = self.origin;
  }
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
  newLerp = (time - self.frame2time) /(self.frame2time - self.frame1time);
  newLerp = bound(0, newLerp, 10);
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
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
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
  
  PVS_FAIL = TRUE;
  traceline(self.origin + [0,0, self.maxs_z], CLIENT_vis_org, FALSE, self);
  PVS_FRAC1 = trace_fraction;

  traceline([self.absmax_x, self.absmax_y, self.absmax_z], CLIENT_vis_org, FALSE, self);
  PVS_FRAC2 = trace_fraction;

  traceline([self.absmin_x, self.absmin_y, self.absmax_z], CLIENT_vis_org, FALSE, self);
  PVS_FRAC3 = trace_fraction;

  if((PVS_FRAC1 == 1.0) || (PVS_FRAC2  == 1.0) || (PVS_FRAC3  == 1.0)){
    PVS_FAIL = FALSE;
  }

  self.cl_lod_unit = TRUE;
  if( PVS_FAIL || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE * 2){
    self.cl_lod_unit = FALSE;
  }
  
  if( self.cl_lod_unit ){
    setmodel(self, self.model);
    addentity(self);
  }
};

void( float isNew, float changeFlags ) sendent_handle_misc_bld={
  local float prevDeadflag;
  local float mapKey;
  local float vipKey;
  
  prevDeadflag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    self.clientServerNum = fabs(rint(ReadLong()));
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    
    self.faction = ReadByte();
    self.vec_size = ReadChar();
    self.data_idx = ReadByte();
    self.canTarget = ReadChar();
    mapKey = ReadChar();
    vipKey = ReadChar();
    if( mapKey ){
      self.spawnflags = self.spawnflags | IS_MAPKEY;
    }
    if( vipKey ){
      self.spawnflags = self.spawnflags | IS_VIP;
    }
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
  if( self.deadflag == DEAD_DYING && prevDeadflag == DEAD_NO){
    if( self.th_die ){
      self.th_die();
    }
    else{
      model_misc_building_die(); 
    }
  }
};

/*
  SendEntity - Projectile ====================================
*/
void() sendent_missile_think={

  if( self.deadflag == DEAD_NO ){
    if( vlen(self.origin - CLIENT_vis_org) < PARTICLE_HAZ_DISTANCE){
      if( self.traileffectnum ){
        trailparticles(world, self.traileffectnum, self.origin, self.origin1 );
      }
    }
  }
  
  self.think = sendent_missile_think;
  self.nextthink = time + 0.005 * frametime;
};

void( float isNew, float changeFlags ) sendent_handle_missile={
  local float ownerId;
  local float prevImpactType;
  
  prevImpactType = self.impactType;
  
  self.oldvelocity = self.velocity;
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    self.data_idx = ReadByte();
    self.damageValue = ReadByte();
    ownerId = ReadShort();
    self.owner = findfloat(world, entnum, ownerId);
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    self.data_idx = ReadByte();
    self.velocity_x = ReadFloat();
    self.velocity_y = ReadFloat();
    self.velocity_z = ReadFloat();
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
    self.alpha = 1.0;
    self.scale = 1.0;
    self.think = sendent_missile_think;
    self.nextthink = time + 0.005;
    self.data_postinit = FALSE;
    sendent_ini_interpolate();
    if( self.data_idx == UID_ITEM_debris ){
      data_sync_new_debris();
    }
    else{
      data_sync_new_projectile(self.data_idx);
      setmodel(self, self.model);
    }
    self.predraw = predraw_missile;
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, self.origin);
  }
  else{
    self.data_postinit = TRUE;
  }
  
  self.angles = vectoangles(self.velocity);
  //HANDLE EVENT - projectile hit.
  if( self.impactType > 0 && prevImpactType == FALSE ){
    self.deadflag = DEAD_DEAD;
    if( self.pcl_explode  && MENU_PROG_OFF){
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
  local float ownerEntId;
  
  prevIdx = self.data_idx;
  
  if( (changeFlags & SENDFLAG_MOVE) ){}
  
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    ownerEntId =  fabs(rint(ReadLong()));
    self.owner = findfloat(world, entnum, ownerEntId);
    
    self.data_idx = ReadByte();
    
    self.w_group = rint(ReadLong());
    self.partParentId = rint(ReadLong());
    self.compOffset_x = ReadCoord();
    self.compOffset_y = ReadCoord();
    self.compOffset_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_NEWUNIT) ){
    ownerEntId =  fabs(rint(ReadLong()));
    self.owner = findfloat(world, entnum, ownerEntId);

    self.data_idx = ReadByte();
  }
  //no-op because 
  if( (changeFlags & SENDFLAG_DEAD) ){}
  
  if(isNew){
    if(self.data_idx != 0){
      initialize_data_item_(self.data_idx);
      self.wepFireOffsetCache = self.wepFireOffset;
    }
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
    //self.predraw = predraw_weapon_ent;
    self.deadflag = DEAD_NO;
    self.classname = "UNIT_ITEM";
    if( (self.owner.flags & FL_CLIENT) && self.owner.isLocalPlayer ){
      CLIENT_weapon_state = CLIENT_weapon_state | self.w_group;
    }
    //self.drawmask = MASK_ENGINE;
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
  local entity unit;
  local float wepId;

  unit = self;

  particleDraw = vlen(CLIENT_vis_org - self.origin);
  
  wepId = 0;
  
  while( wepId < self.hardpoint_cnt){
    equip =  sendent_get_weapon( bitshift(1, wepId) );
    
    if( equip ){
      if( (self.attackFlag & equip.w_group) && equip.beamFlag == FALSE ){
        te_weapon_fire_handler(equip, self);
        self = equip;
          if(self.itemMuzzleFlash){
            self.itemMuzzleFlash();
          }
        self = unit;
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
  self.lerpfrac = (time - self.frame2time) /(self.frame2time-self.frame1time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);
};

vector( vector partOffset) predraw_unit_part={
  local vector offset;
  
  offset = self.rootOrigin + (v_right * partOffset_x) + (v_up * partOffset_y) + (v_forward * partOffset_z);
  
  self.renderflags = 0;
  if(self.isLocalPlayer ){
    if( self.chaseActive  == FALSE ){
      self.renderflags = 0 | RF_EXTERNALMODEL;
      offset = offset - (v_forward * self.cameraOffset_z);
    }
  }
  
  return offset;
};

vector( vector partOffset, .vector partAngles) predraw_unit_part_and_angle={
  local vector offset;
  
  offset = self.rootOrigin + (v_right * partOffset_x) + (v_up * partOffset_y) + (v_forward * partOffset_z);
  
  self.renderflags = 0;
  if( self.isLocalPlayer ){
    if( !self.chaseActive){
      self.renderflags = 0 | RF_EXTERNALMODEL;
    }
  }
  
  self.partAngles_y = self.rootAngle_y;
  self.partAngles_x = 0;
  
  return offset;
};



/*
  Player weapons (usually in the arms) inherit their pitch from their parent piece.
  therefore, the weapon offsets for CLIENT is based on the PARENT offset:
    wep.origin = parent.origin + wep.offset 
      where parent.origin has already been calculated.
*/
void(entity item, float isLoD) predraw_unit_weapon={
  local entity this;
  local vector pOfs;
  local vector drawAng;
  local vector offset;
  local vector adjPartOffset;
  local float clientFPSView;

  clientFPSView = FALSE;
  
  if( self.deadflag != DEAD_NO){
    return;
  }
  if( (self.criticalHits & item.partParentId) ){
    return;
  }
  if( item.model == "" ){
    return;
  }
  
  item.renderflags = 0;
  if( (self.flags & FL_CLIENT) && !self.chaseActive ){
    item.renderflags = 0 | RF_EXTERNALMODEL;
    clientFPSView = TRUE;
  }
  
  util_getPartFromName( item.partParentId, self);
  
  adjPartOffset = item.compOffset - T_PART_PARENT_OFFSET;
  
  offset = T_PART_PARENT_ORG;
  
  if( self.isLocalPlayer && CLIENT_player_state == PLAYER_POWERUP_BEGIN ){
    drawAng = item.owner.angles;
  }
  else{
    drawAng = T_PART_PARENT_ANGL;
  }
  
  drawAng_x = drawAng_x *-1;
  
  makevectors( drawAng);
  offset = offset + (v_up * adjPartOffset_y) + (v_right * adjPartOffset_x) + (v_forward * adjPartOffset_z);
  
  //we ignore FPV z offset because player muzzle flash for view-tracking in FPV should match actual game coords.
  
  setmodel(item, item.model);
  item.origin = offset;
  
  if( self.isLocalPlayer && CLIENT_player_state == PLAYER_POWERUP_BEGIN ){
    item.angles = item.owner.angles;
  }
  else{
    item.angles = T_PART_PARENT_ANGL;
  }
  if(isLoD){
    addentity(item);
  }
  
  item.wepFireOffset = offset + (v_up * item.wepFireOffsetCache_y) + (v_right * item.wepFireOffsetCache_x) + (v_forward * item.wepFireOffsetCache_z);
  if(clientFPSView){
    item.wepFireOffset = item.wepFireOffset - (v_forward * self.cameraOffset_z);
  }

  if(item.effect_beam){
    if(item.beamActive){  
      this = self;
      self = item;
      self.effect_beam();
        if(time > self.beamTime){
          self.beamActive = FALSE;
        }
      self = this;
    }
  }

};

void(entity item, float isLoD) predraw_unit_weapon_tank={
  local entity this;
  local vector pOfs;
  local vector drawAng;
  local vector offset;
  local vector adjPartOffset;
  
  if( self.deadflag != DEAD_NO){
    return;
  }
  if( (self.criticalHits & item.partParentId) ){
    return;
  }
  if( item.model == "" ){
    return;
  }
  
  item.renderflags = 0;
  
  util_getPartFromName( item.partParentId, self);
  
  adjPartOffset = item.compOffset - T_PART_PARENT_OFFSET;

  if( item.partParentId == M_UNIT || item.partParentId == M_LEGS){
    offset = self.cacheGroundPos;
    drawAng = self.cacheGroundAngle;
    item.angles = self.cacheGroundAngle;
  }
  else{
    offset = T_PART_PARENT_ORG;
    drawAng = T_PART_PARENT_ANGL;
    item.angles = T_PART_PARENT_ANGL;
  }
  drawAng_x = drawAng_x *-1;
  
  makevectors( drawAng);
  offset = offset + (v_up * adjPartOffset_y) + (v_right * adjPartOffset_x) + (v_forward * adjPartOffset_z);
  
  //we ignore FPV z offset because player muzzle flash for view-tracking in FPV should match actual game coords.
  if(isLoD){
    setmodel(item, item.model);
    item.origin = offset;
    addentity(item);
  }
  item.origin = offset;
  item.wepFireOffset = offset + (v_up * item.wepFireOffsetCache_y) + (v_right * item.wepFireOffsetCache_x) + (v_forward * item.wepFireOffsetCache_z);  
  
  if(item.effect_beam){
    if(item.beamActive){  
      this = self;
      self = item;
        self.effect_beam();
        if(time > self.beamTime){
          self.beamActive = FALSE;
        }
      self = this;
    }
  }
};

void() render_mech_effect_burning={

  
  local vector spark;
  local vector windVel;

  windVel = '0 0 10'; 
  //ideally you've makevectors before this....

  if( !(self.criticalHits & M_ARM_LEFT) && (self.unitModFlags & MOD_HAS_ARM_L) ){
    if( self.armL_hp < 67 ){
      spark = self.armL_org + (v_up * 10);
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), self.armL_org, normalize( spark - self.armL_org) * (windVel_z/2), 1.0);
    }
  }
  if( !(self.criticalHits & M_ARM_RIGHT) && (self.unitModFlags & MOD_HAS_ARM_R) ){
    if( self.armR_hp < 67 ){
      spark = self.armR_org + (v_up * 10);
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), self.armR_org, normalize( spark - self.armR_org) * (windVel_z/2), 1.0);
    }
  }
  if( !(self.criticalHits & M_TOR_LEFT) && (self.unitModFlags & MOD_HAS_TOR_L) ){
    if( self.armR_hp < 50 ){
      spark = self.torL_org + (v_up * 10);
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), self.torL_org, normalize( spark - self.torL_org) * (windVel_z/2), 1.0);
    }
  }
  if( !(self.criticalHits & M_TOR_RIGHT) && (self.unitModFlags & MOD_HAS_TOR_R) ){
    if( self.torR_hp < 50 ){
      spark = self.torR_org + (v_up * 10);
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), self.torR_org, normalize( spark - self.torR_org) * (windVel_z/2), 1.0);
    }
  }
  if( !(self.criticalHits & M_LEGS) ){
    if( self.legs_hp < 50 ){
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), self.legs_org, normalize( spark - self.legs_org) * (windVel_z/2), 1.0);
    }
  }
  if( self.torC_hp < 33 ){
    spark = self.torC_org + (v_up * 10);
    pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), self.torC_org, normalize( spark - self.torC_org) * (windVel_z/2), 1.0);
  }
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

void(float isnew, float ct, float lt, float rt, float la, float ra, float lg) handle_existing_hp={
  if(isnew){
    self.torC_hp = ct;
    self.torL_hp = lt;
    self.torR_hp = rt;
    self.armL_hp = la;
    self.armR_hp = ra;
    self.legs_hp = lg;
  }
};

void(float isnew, float existCrits) handle_existing_crits={
  if(existCrits != 0){
    self.criticalHits = self.criticalHits | existCrits;
  }
};


/*
  EVENT - CRITICAL =====================================
*/
void( float critical ) sendevent_mech_crit={
  if( vlen(self.rootOrigin - CLIENT_vis_org) < PARTICLE_HAZ_DISTANCE ){
     traceline( self.rootOrigin, CLIENT_vis_org, TRUE, self );
    
    if( trace_ent != world || trace_fraction == 1.0){
      if( ((self.unitModFlags & MOD_EXPLODE_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L)) && (self.critBits & M_TOR_LEFT) ){
        te_missile_explode( self.torL_org, self.vec_size, '0.9 0.75 0.45', 0.01 );
        PointSound_Dynamic( self.torL_org, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT );

        if( self.isLocalPlayer ){
          hud_event_enqueue(HUD_EVENT_CRITICAL_TORSO_LEFT, 1);
        }
      }
      if( ((self.unitModFlags & MOD_EXPLODE_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R)) && (self.critBits & M_TOR_RIGHT) ){
        te_missile_explode( self.torR_org, self.vec_size, '0.9 0.75 0.45', 0.01 );
        PointSound_Dynamic( self.torR_org, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT );
        if( self.isLocalPlayer ){
          hud_event_enqueue(HUD_EVENT_CRITICAL_TORSO_RIGHT, 1);
        }
      }
      if( (self.unitModFlags & MOD_EXPLODE_ARM_L) && (self.critBits & M_ARM_LEFT) ){
        te_missile_explode( self.armL_org, self.vec_size, '0.9 0.75 0.45', 0.01 );
        PointSound_Dynamic( self.armL_org, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT );
        if( self.isLocalPlayer ){
          hud_event_enqueue(HUD_EVENT_CRITICAL_ARM_LEFT, 1);
        }
      }
      if( (self.unitModFlags & MOD_EXPLODE_ARM_R) && (self.critBits & M_ARM_RIGHT) ){
        te_missile_explode( self.armR_org, self.vec_size, '0.9 0.75 0.45', 0.01 );
        PointSound_Dynamic( self.armR_org, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT );
        if( self.isLocalPlayer ){
          hud_event_enqueue(HUD_EVENT_CRITICAL_ARM_RIGHT, 1);
        }
      }
      if( (self.critBits & M_LEGS) && !(self.criticalHits & M_LEGS) ){
        te_missile_explode( self.legs_org, self.vec_size * 2, '0.9 0.75 0.45', 0.05 );
        PointSound_Dynamic( self.legs_org, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT );
        if( self.isLocalPlayer ){
          hud_event_enqueue(HUD_EVENT_CRITICAL_LEGS, 1);
        }
      }
    }
  }
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
  
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
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