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

/*
  Shifted particle events to the client as much as possible.
*/
/*
  Debris - Generic call
*/
void() particle_debris_th={
  remove(self);
};
void( vector org, vector vel, float chunkSize ) particle_debris={
  local string debrisMdl;
  local float trailNum;
  local entity chunk;
  switch( chunkSize ){
    case 2:
      debrisMdl = "q3mdl/fx/debris2/mdl_debris_2.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_MED");
      break;
    case 3:
      debrisMdl = "q3mdl/fx/debris3/mdl_debris_3.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_BIG");
      break;
    default:
      debrisMdl = "q3mdl/fx/debris1/mdl_debris_1.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_SMALL");
      break;
  }

  chunk = spawn();
  setmodel (chunk, debrisMdl);
  setsize (chunk, '0 0 0', '0 0 0');
  setorigin(chunk, org);
  chunk.velocity_x = 100 * crandom();
  chunk.velocity_y = 100 * crandom();
  chunk.velocity_z = 50 + 100 * random();
  chunk.effects = chunk.effects | EF_NOSHADOW;
  chunk.movetype = MOVETYPE_BOUNCE;
  chunk.solid = SOLID_NOT;
  chunk.avelocity_x = random()*450;
  chunk.avelocity_y = random()*450;
  chunk.avelocity_z = random()*450;
  chunk.think = particle_debris_th;
  chunk.nextthink = time + random() * 5;
  chunk.frame = 0;
  chunk.flags = 0;
  chunk.gravity = 0.15;
  chunk.traileffectnum = trailNum;
  chunk.drawmask = MASK_NORMAL;
};

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

void( vector org, float explodeSize, vector explodeColor, float debrisCount, float debrType, float onShield  ) particle_missile_explode={
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
  
  if( debrisCount > 0  && onShield == TRUE){
    for(chunks = rint( random() * (1 + explodeSize * 2)); chunks > 0; chunks = chunks - 1){
      chunkVel_x = 100 * crandom();
      chunkVel_y = 100 * crandom();
      chunkVel_z = 50 + 100 * random();
      particle_debris( org, chunkVel, 1 );
    }
  }
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
  
  //shoot out debris
  for(chunks = rint( random() * (vecSize * 2)); chunks > 0; chunks = chunks - 1){
    chunkVel_x = 100 * crandom();
    chunkVel_y = 100 * crandom();
    chunkVel_z = 50 + 100 * random();
    particle_debris( wreck.origin, chunkVel, rint(random() * wreck.vec_size) );
  }
};

/*
  When a part is blown off a mech
*/
void() particle_mech_chunk_th={
  if( self.traileffectnum != -1 && time > self.pcl_fadeout ){
    self.traileffectnum = -1;
  }   
  if( time < self.pcl_lifetime ){
    self.think = particle_mech_chunk_th;
    self.nextthink = time + (0.1 + (random() * 0.25));
    return;
  }
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

void( float modelIndex, float skinNum, float vecSize, vector entOrg, vector entAngl ) particle_mech_chunk={
  local entity piece;
  
  piece = spawn();
  piece.drawmask = MASK_NORMAL;
  setmodelindex(piece, modelIndex);
  setsize (piece, '0 0 0', '0 0 0');
  setorigin(piece, entOrg);
  piece.angles = entAngl;
  piece.skin = skinNum;
  piece.effects = piece.effects | EF_NOSHADOW;
  piece.movetype = MOVETYPE_TOSS;
  piece.solid = SOLID_NOT;
  piece.frame = 0;
  piece.flags = 0;
  piece.colormod = '0.33 0.33 0.33';
  piece.traileffectnum = particleeffectnum("TE_MECHPIECE_DEAD_BURN");
  piece.pcl_lifetime = time + 180;
  piece.pcl_fadeout = time + (30 + random() * 60);
  piece.velocity_x = 100 * crandom();
  piece.velocity_y = 100 * crandom();
  piece.velocity_z = 200 + 100 * random();
  piece.avelocity_x = random()*100;
  piece.avelocity_y = random()*100;
  piece.avelocity_z = random()*150;
  piece.gravity = 0.67;
  piece.think = particle_mech_chunk_th;
  piece.nextthink = time + 0.1;
  
  particle_missile_explode( entOrg, vecSize, '0.33 0.67 0.99', random() * (vecSize * 1.5), 1, 0 );
};