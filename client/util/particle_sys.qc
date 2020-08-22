/*
  battleMETAL
  Date: 9/6/2018
  Author: Peter Roohr
  Overview: impl of the client particle system
*/


/*
  probably should be a utility.
  in context of Write_*'s
  this assumes the next 3 Read_*'s
  should be a vector
*/
vector() te_read_vector={
  local vector newv;
  newv_x = ReadCoord();
  newv_y = ReadCoord();
  newv_z = ReadCoord();
  return newv;
};

vector() te_read_angle={
  local vector newa;
  newa_x = ReadAngle();
  newa_y = ReadAngle();
  newa_z = ReadAngle();
  return newa;
};

/*
  Fog subsystem
*/
float( float fogColor, float fogColorTarg ) cl_particles_fogColorAdjust={
  local float result;
  
  result = fogColor;
  if( result > fogColorTarg ){
    result = result - 0.001;
  }
  if( result < fogColorTarg ){
    result = result + 0.001;
  }
  return result;
};

float( float fogDist, float fogDistTarg ) cl_particles_fogDistAdjust={
  local float result;
  
  result = fogDist;
  if( result > fogDistTarg ){
    result = result - 5;
  }
  if( result < fogDistTarg ){
    result = result + 5;
  }
  return result;
};

/*
  checks every frame to see if fog needs to transition
      localcmd(newFog);
      float VF_FOG_DENSITY  = 202; //(float)
      float VF_FOG_COLOR_R  = 204; //(float)
      float VF_FOG_COLOR_G  = 205; //(float)
      float VF_FOG_COLOR_B  = 206; //(float)
      float VF_FOG_ALPHA    = 207; //(float)
      float VF_FOG_START    = 208; //(float)
      float VF_FOG_END      = 209; //(float)
      float VF_FOG_HEIGHT   = 210; //(float)
      float VF_FOG_FADEDEPTH= 211; //(float)
*/
void() cl_particles_fogFrame={
  local string newFog;
    
  if( FOG_STATE == TRUE ){
    FOG_DENSITY = cl_particles_fogColorAdjust( FOG_DENSITY, FOG_TARG_DENSITY);
    
    FOG_RED = cl_particles_fogColorAdjust( FOG_RED, FOG_TARG_RED);
    FOG_GREEN = cl_particles_fogColorAdjust( FOG_GREEN, FOG_TARG_GREEN);
    FOG_BLUE = cl_particles_fogColorAdjust( FOG_BLUE, FOG_TARG_BLUE);
    
    FOG_ALPHA = cl_particles_fogColorAdjust( FOG_ALPHA, FOG_TARG_ALPHA);
    
    FOG_DIST_MIN = cl_particles_fogDistAdjust( FOG_DIST_MIN, FOG_TARG_DIST_MIN );
    FOG_DIST_MAX = cl_particles_fogDistAdjust( FOG_DIST_MAX, FOG_TARG_DIST_MAX );
    FOG_DIST_TOP = cl_particles_fogDistAdjust( FOG_DIST_TOP, FOG_TARG_DIST_TOP );
    FOG_FADE_DEPTH = cl_particles_fogDistAdjust( FOG_FADE_DEPTH, FOG_TARG_FADE_DEPTH );

    newFog = strcat("fog ", ftos(FOG_DENSITY)," ");
    newFog = strcat(newFog, ftos(FOG_RED)," ");
    newFog = strcat(newFog, ftos(FOG_GREEN)," ");
    newFog = strcat(newFog, ftos(FOG_BLUE)," ");
    newFog = strcat(newFog, ftos(FOG_ALPHA)," ");
    newFog = strcat(newFog, ftos(FOG_DIST_MIN)," ");
    newFog = strcat(newFog, ftos(FOG_DIST_MAX)," ");
    newFog = strcat(newFog, ftos(FOG_DIST_TOP)," ");
    newFog = strcat(newFog, ftos(FOG_FADE_DEPTH),"\n");
    //localcmd(newFog);
  }
};

void(entity item) te_weapon_fire_handler={
  local entity this;
  this = self;
  self = item;
    if( self.itemMuzzleFlash ){
      makevectors(self.angles);
      self.itemMuzzleFlash();    
    }
  self = this;
};

/*
  Player-mech has crits that are burning
*/
void( vector org, vector windVel ) te_mech_crit={
  local vector spark;
  //ideally you've makevectors before this....
  spark = org + (v_up * 10);
  pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), org, normalize( spark - org) * (windVel_z/2), 0.5);
};

void( vector org, float total ) te_unit_dust={
  local vector dir;
  local vector torg;
  
  makevectors(self.angles);
  torg = org + (v_up * (self.mins_z / 1.5) ) + (v_forward * (self.mins_x / 4));
  //dir = te_apply_wind( torg );
  dir = normalize( dir - org ) * 4;
    
  pointparticles( self.trail_effectnum, torg , dir * 2, total);
};

void() te_unit_dust_set={
  local float dbg;
  dbg = 1;
  switch( dbg ){
    case 1:
      self.trail_effectnum = particleeffectnum("TE_DUST_ICE");
      break;
    case 2: 
      self.trail_effectnum = particleeffectnum("TE_DUST_URBAN");
      break;
    case 3:
      self.trail_effectnum = particleeffectnum("TE_DUST_BADLANDS");
      break;
    case 4:
      self.trail_effectnum = particleeffectnum("TE_DUST_TUNDRA");
      break;
    default:
      self.trail_effectnum = particleeffectnum("TE_DUST_DESERT");
      break;
  }
};


void() te_building_fire_th={
  if( self.owner.deadflag > DEAD_NO ){
    remove(self);
    return;
  }
  self.compAltOffset = te_apply_wind( self.origin );
  pointparticles( self.damageValue, self.origin, normalize(self.compAltOffset - self.origin) * 2, self.count);
  
  
  self.think = te_building_fire_th;
  self.nextthink = time + 0.1 + random() * 0.75;
};

entity( entity targetBuilding ) te_building_fire_start={
  local entity fire;
  fire = spawn();
  setmodel(fire, "q3mdl/testball.md3");
  fire.alpha = 0;
  fire.origin = util_pointNearBoxEdge( targetBuilding.origin, targetBuilding.angles, targetBuilding.mins, targetBuilding.maxs );
  fire.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(targetBuilding.vec_size)));
  fire.think = te_building_fire_th;
  fire.nextthink = time + 0.1;
  fire.angles = targetBuilding.angles;
  fire.count = targetBuilding.vec_size + (1 / 3);
  targetBuilding.colormod = targetBuilding.colormod - '0.1 0.1 0.1';
  fire.owner = targetBuilding;
  return fire;
};


void( vector org, vector setVelocity, float total ) te_field_rad={
  pointparticles( particleeffectnum("TE_FIELD_RAD"), org, setVelocity,  total);
};

void( vector org, float total ) te_field_rad_light={
  pointparticles( particleeffectnum("TE_FIELD_RAD_LIGHT"), org, '0 0 0',  total);
};

void( vector org, vector setVelocity, float total ) te_field_mineral={
  pointparticles( particleeffectnum("TE_FIELD_MINERAL"), org, setVelocity,  total);
};

void( vector org, float total ) te_field_mineral_light={
  pointparticles( particleeffectnum("TE_FIELD_MINERAL_LIGHT"), org, '0 0 0',  total);
};

void( vector particleOrg, vector particleEnd ) te_field_quantum={
  pointparticles( particleeffectnum("TE_FIELD_QUANTUM"), particleOrg, normalize( particleEnd - particleOrg ), 1);
  pointparticles( particleeffectnum("TE_FIELD_QUANTUM"), particleOrg, normalize( particleEnd - particleOrg ) * 30, 1);
  trailparticles( world, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), particleOrg, particleEnd);
};

void( vector org, float total ) te_field_quantum_light={
  pointparticles( particleeffectnum("TE_FIELD_QUANTUM_LIGHT"), org, '0 0 0',  total);
};

/*
  Client-side explosion shell

*/
void() te_missile_explode_th={
  self.alpha = self.alpha - 0.025;
  self.scale = self.scale + self.pcl_count;
  self.think = te_missile_explode_th;
  if( self.alpha < 0.01 ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 0.01;
};
void( vector org, float explodeSize, vector explodeColor, float bloom ) te_missile_explode={
  local entity explode;

  explode = spawn();
  explode.movetype = MOVETYPE_NONE;
  explode.solid = SOLID_NOT;
  explode.think = te_missile_explode_th;
  explode.nextthink = time + 0.05;
  explode.data_lifetime = 10;
  explode.scale = explodeSize;
  explode.alpha = 1;
  explode.effects = explode.effects | EF_NOSHADOW;
  explode.avelocity = randomvec() * 300;
  explode.angles = randomvec() * 30;
  explode.pcl_count = bloom;
  
  if( explodeColor != '0 0 0' ){
    explode.colormod = explodeColor;
  }
  
  setmodel( explode, "q3mdl/fx/explosions/te_missile_explode.md3");
  setorigin( explode, org);

  te_customflash( org, explodeSize * 50, 1, explodeColor); 
};

void() te_shield_explode_th={
  self.alpha = self.alpha - 0.012;
  self.scale = self.scale + 0.015;
  self.think = te_shield_explode_th;
  if( self.alpha < 0.01 ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 0.01;
};

void( vector org, float vecSize ) te_shield_explode={
  local entity explode;
 
  explode = spawn();
  explode.movetype = MOVETYPE_NONE;
  explode.solid = SOLID_NOT;
  explode.think = te_shield_explode_th;
  explode.nextthink = time + 0.05;
  explode.data_lifetime = 10;
  explode.scale = 0.1 + (vecSize / 3);
  explode.alpha = 0.75;
  explode.effects = explode.effects | (EF_NOSHADOW | EF_DOUBLESIDED);
  setmodel( explode, "q3mdl/fx/explosions/te_shield_explode.md3");
  setorigin( explode, org);
  te_customflash( org, vecSize * 50, 1, '0.003 0.87 0.22');
};

/*
  Missile Explosion Shell
*/
void() particle_missile_explode_th={
  self.alpha = self.alpha - 0.012;
  self.scale = self.scale + 0.005;
  self.think = particle_missile_explode_th;
  if( self.alpha < 0.01 ){
    remove(self);
    return;
  }
  self.nextthink = time + 0.01;
};

void( vector org, float explodeSize, vector explodeColor, float onShield  ) particle_missile_explode={
  local entity explode;

  pointsound(org, "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
 
  explode = spawn();
  explode.movetype = MOVETYPE_NONE;
  explode.solid = SOLID_NOT;
  explode.think = particle_missile_explode_th;
  explode.nextthink = time + 0.05;
  explode.pcl_lifetime = 10;
  explode.scale = explodeSize;
  explode.alpha = 1;
  explode.effects = explode.effects | EF_NOSHADOW;
  explode.avelocity = randomvec() * 300;
  if( onShield == TRUE ){
    explode.scale = explodeSize / 2;
    explode.alpha = 0.8;
    explode.colormod = '0.1 1 0.8';
  }
  else{
    explode.colormod = explodeColor;
  }
  
  setmodel( explode, "q3mdl/fx/explosions/te_missile_explode.md3");
  setorigin( explode, org);
  
  te_customflash( org, explodeSize * 50, 1.5, explodeColor); 
};


/*
  item is exploding, use its bbox size for area
*/
void( vector explodeColor ) te_object_explode={
  local vector exp;
  
  exp_x = crandom() * (self.maxs_x * 2);
  exp_y = crandom() * (self.maxs_y * 2);
  exp_z = crandom() * (self.maxs_z * 2);
  makevectors(self.angles);
  exp = self.origin + (v_up * exp_z) + ( v_forward * exp_y) + (v_right * exp_x);
  
  //TODO - Replace
  //te_missile_explode( exp, self.vec_size, explodeColor, self.vec_size * 1.5, self.vec_size );

};


/*
  Wreck event, ie a vehicle death
*/
void() particle_vehicle_wreck_th={
  if( time < self.pcl_fadeout ){
    pointparticles( self.pcl_effectnum, self.origin, self.pcl_velocity, self.pcl_count);
    self.think = particle_vehicle_wreck_th;
    self.nextthink = time + (0.1 + (random() * 0.2));
  }
};

void( float modelIndex, float skinNum, float lifetime, float vecSize, vector entOrg, vector entAngl ) particle_vehicle_wreck={
  local entity wreck;
  local entity this;
  local float sizeAdjust;
  
  pointsound( entOrg, "sound/fx_boom.ogg", 1, ATTN_NORM );
  
  this = self;
  wreck = spawn();
  self = wreck;
    self.angles = entAngl;
    makevectors(self.angles);
    self.origin = entOrg + (v_up * (0 - vecSize * 2));
    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_CORPSE;
    setmodelindex(self, modelIndex);
    self.skin = skinNum;
    self.colormod = '0.33 0.33 0.33';
    self.pcl_velocity = self.origin + (v_up * 5);
    self.pcl_velocity = normalize(self.pcl_velocity - self.origin) * 5;
    switch( vecSize ){
      case 2:
        self.pcl_effectnum = particleeffectnum("TE_FIRE_2");
        break;
      case 3:
        self.pcl_effectnum = particleeffectnum("TE_FIRE_3");
        break;
      default:
        self.pcl_effectnum = particleeffectnum("TE_FIRE_1");
        break;
    }
    sizeAdjust = vecSize / 2;
    sizeAdjust = sizeAdjust * lifetime;
    sizeAdjust = sizeAdjust * random();
    self.pcl_lifetime = time + (lifetime + sizeAdjust);
    self.pcl_fadeout = time + ( lifetime * 0.75);
    self.pcl_count = 1;
    self.nextthink = time + (random() * 1);
    self.think = particle_vehicle_wreck_th;
  self = this;
};

void( float flashId, float entityId, vector flashVel ) particle_weapon_flash={
  local entity this;
  local entity scan;
  local entity wep;
  local float weaponDataIdx;
  
  this = findfloat(world, entId, entityId);
  if( !this ){
    cons_logAFloat("entity with index not found",entityId);
    return;
  }
  scan = this.w_slot;
  while( scan != world ){
    if( flashId == scan.w_group ){
      weaponDataIdx = scan.data_idx;
      wep = scan;
    }
    scan = scan.w_slot;
  }
  
  switch(weaponDataIdx){
    case UID_ITEM_light_autocannon:
      particle_muzzleflash_latc( wep.origin, flashVel );
      break;
    case UID_ITEM_light_laser:
      particle_muzzleflash_las( wep.origin, flashVel );
      break;
    case UID_ITEM_particle_cannon:
      particle_muzzleflash_pac( wep.origin, flashVel );
      break;
    case UID_ITEM_electro_repeater:
      particle_muzzleflash_esr( wep.origin, flashVel ) ;
      break;
    case UID_ITEM_flak:
      particle_muzzleflash_flak( wep.origin, flashVel ) ;
      break;
    default:
      cons_logAFloat("weapon with flashId not found",flashId);
      break;
  }
};

//Light Autocannon ID 1
void( vector muzzleOrg, vector muzzleVel ) particle_muzzleflash_latc={
  local vector ang;
  local vector norm;
  local float impactStyle;
  
  norm = normalize(muzzleVel - muzzleOrg);
  ang = vectoangles(muzzleVel - muzzleOrg);
  makevectors(ang);
  
  switch(impactStyle){
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_SHIELD_HIT_HIGH"), muzzleVel, normalize(muzzleVel - muzzleOrg)* -2, random() * 2);
      pointsound( muzzleVel, "sound/fx_shieldhit.ogg", 0.55 + (random() * 0.45), ATTN_NORM );
      return;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_ATC_ARMOR"), muzzleVel + v_forward * -3, norm * 4, 3);
      break;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_ATC_DIRT"), muzzleVel + (v_up *1), normalize( (muzzleVel + (v_up *1)) - muzzleVel ) * 20, 1);
      break;
    default:
      return;
  }
};


//Light Laser ID 3
void( vector muzzleOrg, vector muzzleVel ) particle_muzzleflash_las={
  local float impactStyle;
  trailparticles( world, particleeffectnum("TE_LAS_RAIL"), muzzleOrg, muzzleVel );
  
  switch(impactStyle){
    default:
      return;
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_SHIELD_HIT_HIGH"), muzzleVel, normalize(muzzleVel - muzzleOrg)* -2, random() * 2);
      pointsound( muzzleVel, "sound/fx_shieldhit.ogg", 0.55 + (random() * 0.45), ATTN_NORM );
      return;
    case IMPACT_ARMOR:
      pointparticles(particleeffectnum("TE_LAS_HIT"), muzzleVel, normalize( muzzleOrg - muzzleVel ), 1);
      break;
    case IMPACT_DIRT:
      pointparticles(particleeffectnum("TE_LAS_DIRT"), muzzleVel , '0 0 0', 1);
      break;
  }
};

//Particle Cannon ID 7
void( vector muzzleOrg, vector muzzleVel ) particle_muzzleflash_pac={
  local vector norm;
  local float impactStyle;
  norm = normalize(muzzleVel - muzzleOrg);
  
  trailparticles( world, particleeffectnum("TE_PAC_RAIL"), muzzleOrg, muzzleVel );
  
  switch(impactStyle){
    default:
      return;
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_PAC_IMPACT_SHIELD"), muzzleVel, norm * -2, 1);
      pointparticles( particleeffectnum("TE_PAC_IMPACT_SHIELD_POINT"), muzzleVel, '0 0 0', 1);
      pointsound( muzzleVel, "sound/fx_shieldhit.ogg", 0.67 + (random() * 0.33), ATTN_NORM );
      break;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_PAC_IMPACT_ARMOR"), muzzleVel, norm * -6, 1);
      break;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_PAC_IMPACT_GROUND"), muzzleVel, norm * -4, 1);
      break;
  }
};

//Electro Static ID 8
void( vector muzzleOrg, vector muzzleVel ) particle_muzzleflash_esr={
  local vector norm;
  local float impactStyle;
  
  norm = normalize(muzzleVel - muzzleOrg);

  trailparticles( world, particleeffectnum("TE_ESR_RAIL"), muzzleOrg, muzzleVel );
  switch(impactStyle){
    default:
      return;
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), muzzleVel, norm * -2, 1);
      pointsound( muzzleVel, "sound/fx_shieldhit.ogg", 0.67 + (random() * 0.33), ATTN_NORM );
      break;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), muzzleVel, norm * -6, 1);
      break;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), muzzleVel, norm * -4, 1);
      break;
  }
};


//Flak Cannon ID 12
void( vector muzzleOrg, vector muzzleVel ) particle_muzzleflash_flak={  
  local vector ang;
  local vector norm;
  local float impactStyle;
  
  norm = normalize(muzzleVel - muzzleOrg);
  ang = vectoangles(muzzleVel - muzzleOrg);
  makevectors(ang);
  
  switch(impactStyle){
    default:
      return;
    case IMPACT_SHIELD:  
      pointparticles( particleeffectnum("TE_SHIELD_HIT_HIGH"), muzzleVel, norm * 2, random() * 2);
      pointsound( muzzleVel, "sound/fx_shieldhit.ogg", 0.67 + (random() * 0.33), ATTN_NORM );
      return;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_FLK_IMPACT"), muzzleVel + (v_forward * -32), norm * 4, 1);
      break;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_FLK_DIRT"), muzzleVel + (v_up * 3) + (v_forward * -7), norm * 20, 1);
      break;
  }
};

vector( vector startOrg ) te_apply_wind={
  local vector windVel;
  
  makevectors(world.wind);
  windVel = startOrg + (v_up * 2) + (v_forward * (-1 * (2/2)) );
  return windVel;
};

vector( vector entOrg, vector entAng, vector entMins, vector entMaxs ) util_pointNearBoxEdge={
  local vector angl;
  local vector newpos;
  local float len;
  local float hight;
  
  angl = entAng;
  angl_y = anglemod(angl_y + 45 + random() * 270);

  len = entMaxs_x * 0.67;
  
  hight = entMaxs_z * 0.65;
  hight = hight + (random() * (entMaxs_z * 0.25));
  
  newpos = entOrg;
  makevectors( angl );
  newpos = newpos + (v_forward * len);
  newpos = newpos + (v_up *  hight);
  return newpos;
};
