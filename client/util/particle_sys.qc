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
    localcmd(newFog);
  }
};

void() te_building_fire_th={
  if( self.owner.deadflag > DEAD_NO ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.5;
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
  fire.origin = util_pointNearBoxEdge( targetBuilding.origin, targetBuilding.angles, targetBuilding.mins, targetBuilding.maxs );
  fire.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(targetBuilding.vec_size)));
  fire.think = te_building_fire_th;
  fire.nextthink = time + 0.1;
  fire.angles = targetBuilding.angles;
  fire.count = targetBuilding.vec_size + (1 / 3);
  targetBuilding.colormod = targetBuilding.colormod - '0.1 0.1 0.1';
  fire.owner = targetBuilding;
  fire.drawmask = MASK_NORMAL;
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
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE"), particleOrg, normalize( particleEnd - particleOrg ), 1);
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), particleOrg, normalize( particleEnd - particleOrg ) * 30, 1);
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
  local float itr;
  local vector vel;
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
  explode.drawmask = MASK_NORMAL;
  explode.pcl_count = bloom;
  addentity(explode);
  
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
  explode.drawmask = MASK_NORMAL;
  //pointparticles?
};

/*
  Shifted particle events to the client as much as possible.
*/

/*
  Missile Explosion Shell
*/
void() particle_missile_explode_th={
  self.alpha = self.alpha - 0.012;
  self.scale = self.scale + 0.005;
  self.think = particle_missile_explode_th;
  if( self.alpha < 0.01 ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 0.01;
};

void( vector org, float explodeSize, vector explodeColor, float onShield  ) particle_missile_explode={
  local entity explode;
  local float chunks;
  local vector chunkVel;
 
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
  explode.drawmask = MASK_NORMAL;
  
  te_customflash( org, explodeSize * 50, 1.5, explodeColor); 
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
  local float chunks;
  local vector chunkVel;
  
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
    self.drawmask = MASK_NORMAL;
  self = this;
};

void( float flashId, vector flashOrg, vector flashVel, float impactStyle ) particle_muzzle_flash={
  switch(flashId){
    case UID_ITEM_light_autocannon:
      particle_muzzleflash_latc( flashOrg, flashVel, impactStyle );
      break;
    case UID_ITEM_emp:
      particle_muzzleflash_emp( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_light_laser:
      particle_muzzleflash_las( flashOrg, flashVel, impactStyle );
      break;
    case UID_ITEM_rocket_launcher:
      particle_muzzleflash_mis( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_quantum_rifle:
      particle_muzzleflash_qrfl( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_rotary_plasma:
      particle_muzzleflash_rpc( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_particle_cannon:
      particle_muzzleflash_pac( flashOrg, flashVel, impactStyle );
      break;
    case UID_ITEM_electro_repeater:
      particle_muzzleflash_esr( flashOrg, flashVel, impactStyle ) ;
      break;
    case UID_ITEM_missile_laserguide:
      particle_muzzleflash_mlg( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_missile_activeradar:
      particle_muzzleflash_marh( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_snub_artillery:
      particle_muzzleflash_sfa( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_flak:
      particle_muzzleflash_flak( flashOrg, flashVel, impactStyle ) ;
      break;
    case UID_ITEM_ion_coil:
      particle_muzzleflash_ion( flashOrg, flashVel, 0 ) ;
      break;
    case UID_ITEM_missile_swarm:
      particle_muzzleflash_swarm( flashOrg, flashVel, 0 ) ;
      break;
  }
};

//Light Autocannon ID 1
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_latc={
  local vector ang;
  local vector norm;
  norm = normalize(muzzleVel - muzzleOrg);
  ang = vectoangles(muzzleVel - muzzleOrg);
  makevectors(ang);
  pointsound( muzzleOrg, "sound/weapons/atc_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ATC_MUZZLE"), muzzleOrg, norm * 4, 1);
  pointparticles( particleeffectnum("TE_ATC_TRACER"), muzzleOrg, norm * 1400, 1);
    switch(impactStyle){
    default:
      return;
    case 1:
      return;
    case 2:
      pointparticles( particleeffectnum("TE_ATC_ARMOR"), muzzleVel + v_forward * -3, norm * 4, 3);
      break;
    case 3:
      pointparticles( particleeffectnum("TE_ATC_DIRT"), muzzleVel + (v_up *1), normalize( (muzzleVel + (v_up *1)) - muzzleVel ) * 20, 1);
      break;
  }
};

//EMP ID 2
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_emp={
  pointsound( muzzleOrg, "sound/weapons/emp_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_EMP_MUZZLE"), muzzleOrg, normalize( muzzleVel - muzzleOrg ) * 4, 1);
}

//Light Laser ID 3
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_las={
  pointsound( muzzleOrg, "sound/weapons/laser_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LAS_MUZZLE"), muzzleOrg, normalize(muzzleVel - muzzleVel) * 2, 1);
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

//Rocket Launcher ID 4
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_mis={
  pointsound( muzzleOrg, "sound/weapons/mis_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_MIS_MUZZLE"), muzzleOrg, normalize(muzzleVel - muzzleVel), 1);
};

//Quantum Rifle ID 5
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_qrfl={
  local vector ang;
  local vector prtclRail_org;
  local vector prtclRail_end;
  local vector prtclSpark_org;
  
  ang = vectoangles(muzzleVel - muzzleOrg);
  makevectors(ang);
  prtclRail_org = muzzleOrg + (v_forward * 2);
  prtclRail_end = muzzleOrg + (v_forward * 48);
  prtclSpark_org = muzzleOrg + (v_forward * 22);
  pointsound( muzzleOrg, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE"), prtclRail_org, normalize( muzzleVel - muzzleOrg ), 1 ) ;
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org + (v_right * 0.5), normalize( muzzleVel - muzzleOrg ) * 30, 1) ;
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org - (v_right * 0.5), normalize( muzzleVel - muzzleOrg ) * 30, 1) ;
  
  trailparticles( world, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org + (v_right * 0.5), prtclRail_end + (v_right * 0.5) );
  trailparticles( world, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org - (v_right * 0.5), prtclRail_end - (v_right * 0.5) );
};

//Rotary Plasma ID 6
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_rpc={
  pointsound( muzzleOrg, "sound/weapons/rpls_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_RPC_MUZZLE"), muzzleOrg, normalize(muzzleVel - muzzleOrg) * 2, 1);
};

//Particle Cannon ID 7
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_pac={
  local vector norm;
  norm = normalize(muzzleVel - muzzleOrg);
  pointsound( muzzleOrg, "sound/weapons/pac_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_PAC_MUZZLE"), muzzleOrg, norm * 4, 1);
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
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_esr={
  local vector norm;
  norm = normalize(muzzleVel - muzzleOrg);

  pointsound( muzzleOrg, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ESR_MUZZLE"), muzzleOrg, norm * 1, 1);
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

//Missile Laser Guide ID 9
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_mlg={
  local vector ang;
  ang = vectoangles(muzzleVel - muzzleOrg);
  makevectors(ang);
  pointsound( muzzleOrg, "sound/weapons/mis_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), muzzleOrg + (v_forward * 2) + (v_right * -0.65), normalize((muzzleOrg + v_up * 2) - muzzleOrg), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), muzzleOrg + (v_forward * 2) + (v_right * 0.65), normalize((muzzleOrg + v_up * 2) - muzzleOrg), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), muzzleOrg + (v_forward * 2) + (v_up * 1), normalize((muzzleOrg + v_up * 2) - muzzleOrg), 1);
  
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), muzzleVel + (v_right * 0.5), muzzleVel + (v_forward * 16) + (v_right * 0.5) );
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), muzzleVel + (v_right * -0.5), muzzleVel + (v_forward * 16) + (v_right * -0.5) );
};

//Missile Active Radar ID 10
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_marh={
  pointsound( muzzleOrg, "sound/weapons/mis_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ARH_MUZZLE"), muzzleOrg, vectoangles(muzzleVel - muzzleVel) * 1, 1);
};

//Snub Artillery ID 11
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_sfa={
  pointsound( muzzleOrg, "sound/fx_boom.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_SFGA_MUZZLE"), muzzleOrg, normalize(muzzleVel - muzzleOrg) * 2, 1);
};

//Flak Cannon ID 12
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_flak={  
  local vector ang;
  local vector norm;
  
  norm = normalize(muzzleVel - muzzleOrg);
  ang = vectoangles(muzzleVel - muzzleOrg);
  makevectors(ang);
  pointsound( muzzleOrg, "sound/weapons/flak_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_FLK_MUZZLE"), muzzleOrg, norm * 4, 1);
  pointparticles( particleeffectnum("TE_FLK_TRACER"), muzzleOrg, norm * 1600, 1);
  
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

//Ion Cannon ID 13
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_ion={
  pointsound( muzzleOrg, "sound/weapons/emp_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ION_MUZZLE"), muzzleOrg, normalize( muzzleVel - muzzleOrg ) * 4, 1);
}

//Missile Swarm ID 14
void( vector muzzleOrg, vector muzzleVel, float impactStyle ) particle_muzzleflash_swarm={
  pointsound( muzzleOrg, "sound/weapons/mis_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_SWRM_MUZZLE"), muzzleOrg, normalize( muzzleVel - muzzleOrg ) * 3, 1);
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
