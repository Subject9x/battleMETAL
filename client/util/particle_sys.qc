/*
  battleMETAL
  Date: 9/6/2018
  Author: Peter Roohr
  Overview: impl of the client particle system
*/

void() particle_sys_ini_globals={
  PTC_HIT_DIRT_SHOT_SML = particleeffectnum("TE_HIT_DIRT_SHOT_SML");
  PTC_HIT_DIRT_SHOT_MED = particleeffectnum("TE_HIT_DIRT_SHOT_MED");
  PTC_HIT_DIRT_SHOT_LRG = particleeffectnum("TE_HIT_DIRT_SHOT_LRG");

  PTC_HIT_DIRT_ENE_SML = particleeffectnum("TE_HIT_DIRT_ENE_SML");
  PTC_HIT_DIRT_ENE_MED = particleeffectnum("TE_HIT_DIRT_ENE_MED");
  PTC_HIT_DIRT_ENE_LRG = particleeffectnum("TE_HIT_DIRT_ENE_LRG");
  
  PTC_HIT_DIRT_EXP_SML = particleeffectnum("TE_HIT_DIRT_EXPL_SML");
  PTC_HIT_DIRT_EXP_MED = particleeffectnum("TE_HIT_DIRT_EXPL_MED");
  PTC_HIT_DIRT_EXP_LRG = particleeffectnum("TE_HIT_DIRT_EXPL_LRG");
  
  PTC_STOMP_ICE = particleeffectnum("TE_STOMP_ICE");
  PTC_STOMP_CITY = particleeffectnum("TE_STOMP_CITY");
  PTC_STOMP_BADLND = particleeffectnum("TE_STOMP_BADLANDS");
  PTC_STOMP_TUNDRA = particleeffectnum("TE_STOMP_TUNDRA");
  PTC_STOMP_SAND = particleeffectnum("TE_STOMP_SAND");
  
  PTC_DUST_ICE = particleeffectnum("TE_DUST_ICE");
  PTC_DUST_URBAN = particleeffectnum("TE_DUST_URBAN");
  PTC_DUST_BADLND = particleeffectnum("TE_DUST_BADLANDS");
  PTC_DUST_TUNDRA = particleeffectnum("TE_DUST_TUNDRA");
  PTC_DUST_DESERT = particleeffectnum("TE_DUST_DESERT");
  
  PTC_HIT_EXPL_SML = particleeffectnum("TE_HIT_EXPL_SML");
  PTC_HIT_EXPL_MED = particleeffectnum("TE_HIT_EXPL_MED");
  PTC_HIT_EXPL_LRG = particleeffectnum("TE_HIT_EXPL_LRG");
  
  PTC_WRECK_SMOKE = particleeffectnum("TE_WRECK_SMOKE");
};

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

vector (vector a, vector b ) crossProduct={

  local vector cross;
  cross_x = (a_y * b_z) - (a_z * b_y);
  cross_y = (a_z * b_x) - (a_x * b_z);
  cross_z = (a_x * b_y) - (a_y * b_x);

  return cross;
};

/**
  pulled from Xonotic for very nice beams.
*/
void (vector from, vector to, float thickness, string texture, float aspect, float shift, vector rgb, float theAlpha, float drawflag, vector vieworg) Draw_CylindricLine={
    // I want to draw a quad...
    // from and to are MIDPOINTS.
    local vector axis;
    local vector thickdir;
    local vector A;
    local vector B;
    local vector C;
    local vector D;

    local float length_tex;

    local float adjustThickness;

    axis = normalize(to - from);

    length_tex = aspect * vlen(to - from) / thickness;
    length_tex = max(length_tex, length_tex);

    // direction is perpendicular to the view normal, and perpendicular to the axis

    //Subject9x- somehow this is bugged in vanilla DP QC, or perhaps my code, but it doesn't auto-orient the way the func says it should.
    // as a lame hack I've just made the polygon double sided.
    thickdir = normalize( crossProduct(axis, vieworg - from) );

    adjustThickness = thickness / 2.0;
    A = from - thickdir * adjustThickness;
    B = from + thickdir * adjustThickness;
    C = to + thickdir * adjustThickness;
    D = to - thickdir * adjustThickness;

    R_BeginPolygon(texture, drawflag, FALSE);
      R_PolygonVertex(A, '0 0 0' + shift * '1 0 0', rgb, theAlpha);
      R_PolygonVertex(B, '0 1 0' + shift * '1 0 0', rgb, theAlpha);
      R_PolygonVertex(C, '0 1 0' + (shift + length_tex) * '1 0 0', rgb, theAlpha);
      R_PolygonVertex(D, '0 0 0' + (shift + length_tex) * '1 0 0', rgb, theAlpha);
      //reverse order for primitive double-sided effect.
      R_PolygonVertex(D, '0 0 0' + (shift + length_tex) * '1 0 0', rgb, theAlpha);
      R_PolygonVertex(C, '0 1 0' + (shift + length_tex) * '1 0 0', rgb, theAlpha);
      R_PolygonVertex(B, '0 1 0' + shift * '1 0 0', rgb, theAlpha);
      R_PolygonVertex(A, '0 0 0' + shift * '1 0 0', rgb, theAlpha);
    R_EndPolygon();
};

/*
  Ported from SSQC, ai_voice system now CSQC implemented, but
  driven by SendEnt events.
*/
void( float randomBool ) ai_voice_ini={
  local float randoVoice;
  if( randomBool ){
    randoVoice = random();
    if( randoVoice < 0.4 ){
      //VOICE  A
      self.ai_voice_group = AI_VOICE_GROUP_A;
    }
    else if( randoVoice < 0.7 ){
      //VOICE  B
      self.ai_voice_group = AI_VOICE_GROUP_B;
    }
    else{
      self.ai_voice_group = AI_VOICE_GROUP_C;
    }
  }
  //else{
    //VOICE DEBUG
    //self.ai_voice_group = AI_VOICE_GROUP_C;
 // }
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
  local float checkFlag;
  
  FOG_DENSITY = cl_particles_fogColorAdjust( FOG_DENSITY, FOG_TARG_DENSITY);
  
  FOG_RED = cl_particles_fogColorAdjust( FOG_RED, FOG_TARG_RED);
  FOG_GREEN = cl_particles_fogColorAdjust( FOG_GREEN, FOG_TARG_GREEN);
  FOG_BLUE = cl_particles_fogColorAdjust( FOG_BLUE, FOG_TARG_BLUE);
  
  FOG_ALPHA = cl_particles_fogColorAdjust( FOG_ALPHA, FOG_TARG_ALPHA);
  
  FOG_DIST_MIN = cl_particles_fogDistAdjust( FOG_DIST_MIN, FOG_TARG_DIST_MIN );
  FOG_DIST_MAX = cl_particles_fogDistAdjust( FOG_DIST_MAX, FOG_TARG_DIST_MAX );
  FOG_DIST_TOP = cl_particles_fogDistAdjust( FOG_DIST_TOP, FOG_TARG_DIST_TOP );
  FOG_FADE_DEPTH = cl_particles_fogDistAdjust( FOG_FADE_DEPTH, FOG_TARG_FADE_DEPTH );
  
  checkFlag = 0;
  if( FOG_DENSITY == FOG_TARG_DENSITY ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_RED == FOG_TARG_RED ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_GREEN == FOG_TARG_GREEN ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_BLUE == FOG_TARG_BLUE ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_ALPHA == FOG_TARG_ALPHA ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_DIST_MIN == FOG_TARG_DIST_MIN ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_DIST_MAX == FOG_TARG_DIST_MAX ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_DIST_TOP == FOG_TARG_DIST_TOP ){
    checkFlag = checkFlag + 1;
  }
  if( FOG_FADE_DEPTH == FOG_TARG_FADE_DEPTH ){
    checkFlag = checkFlag + 1;
  }
  
  if( checkFlag == 9){
    FOG_STATE = FALSE;
  }
  
  /*newFog = strcat("fog ", ftos(FOG_DENSITY)," ");
  newFog = strcat(newFog, ftos(FOG_RED)," ");
  newFog = strcat(newFog, ftos(FOG_GREEN)," ");
  newFog = strcat(newFog, ftos(FOG_BLUE)," ");
  newFog = strcat(newFog, ftos(FOG_ALPHA)," ");
  newFog = strcat(newFog, ftos(FOG_DIST_MIN)," ");
  newFog = strcat(newFog, ftos(FOG_DIST_MAX)," ");
  newFog = strcat(newFog, ftos(FOG_DIST_TOP)," ");
  newFog = strcat(newFog, ftos(FOG_FADE_DEPTH),"\n");
  localcmd(newFog);*/
};

void(entity item, entity parent) te_weapon_fire_handler={
  // local vector adjPartOffset;
  // local vector offset;
  // local vector drawAng;
  
  // util_getPartFromName( item.partParentId, parent);
  
  // adjPartOffset = item.compOffset - T_PART_PARENT_OFFSET;

  // if( item.partParentId == M_UNIT || item.partParentId == M_LEGS){
  //   offset = parent.cacheGroundPos;
  //   drawAng = parent.cacheGroundAngle;
  // }
  // else{
  //   offset = T_PART_PARENT_ORG;
  //   drawAng = T_PART_PARENT_ANGL;
  // }
  // drawAng_x = drawAng_x *-1;
  
  // makevectors(drawAng);
  // offset = offset + (v_up * adjPartOffset_y) + (v_right * adjPartOffset_x) + (v_forward * adjPartOffset_z);

  //we ignore FPV z offset because player muzzle flash for view-tracking in FPV should match actual game coords.
  
  //item.wepFireOffset = offset + (v_up * item.wepFireOffsetCache_y) + (v_right * item.wepFireOffsetCache_x) + (v_forward * item.wepFireOffsetCache_z);  
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
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    makevectors(self.angles);
    torg = org + (v_up * (self.mins_z / 1.5) ) + (v_forward * (self.mins_x / 4));
    dir = normalize( dir - org ) * 4;
      
    pointparticles( self.trail_effectnum, torg , dir * 2, total);
  }
};

void() te_unit_dust_set={
  switch( SV_WORLDTYPE ){
    case 1:
      self.trail_effectnum = PTC_DUST_ICE;
      break;
    case 2: 
      self.trail_effectnum = PTC_DUST_URBAN;
      break;
    case 3:
      self.trail_effectnum = PTC_DUST_BADLND;
      break;
    case 4:
      self.trail_effectnum = PTC_DUST_TUNDRA;
      break;
    default:
      self.trail_effectnum = PTC_DUST_DESERT;
      break;
  }
};


void() te_building_fire_th={
  if( self.owner.deadflag != DEAD_NO ){
    remove(self);
    return;
  }
    
  self.compAltOffset = te_apply_wind( self.origin );
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    pointparticles( self.damageValue, self.origin, normalize(self.compAltOffset - self.origin) * 2, self.count);
  }
  
  self.think = te_building_fire_th;
  self.nextthink = time + 0.1 + random() * 0.75;
};

entity( entity targetBuilding ) te_building_fire_start={
  local entity fire;
  fire = spawn();
  if( fire ){
    setmodel(fire, "models/testball.md3");
    fire.alpha = 0;
    fire.origin = util_pointNearBoxEdge( targetBuilding.origin, targetBuilding.angles, targetBuilding.mins, targetBuilding.maxs );
    fire.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(targetBuilding.vec_size)));
    fire.think = te_building_fire_th;
    fire.nextthink = time + 0.1;
    fire.angles = targetBuilding.angles;
    fire.count = targetBuilding.vec_size + (1 / 3);
    targetBuilding.colormod = targetBuilding.colormod - '0.1 0.1 0.1';
    fire.owner = targetBuilding;
  }
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
    remove(self);
    return;
  }
  self.nextthink = time + 0.01;
};
//NOTE - calling function must provide desired sound effect (or no sound)
void( vector org, float explodeSize, vector explodeColor, float bloom ) te_missile_explode={
  local entity explode;
  local float debris;
  local vector back;
  local vector launch;

  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    explode = spawn();
    if( explode ){
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
      explode.drawmask = MASK_NORMAL;
      
      if( explodeColor != '0 0 0' ){
        explode.colormod = explodeColor;
      }
      
      setmodel( explode, "models/fx/explosions/te_missile_explode.md3");
      setorigin( explode, org);
    }
  
    te_customflash( org, explodeSize * 50, 1, explodeColor);

    makevectors(vectoangles(self.velocity));
    back = org + (v_forward * -10);
    back = normalize(back - org);
    
    debris = explodeSize / 2;
    debris = debris + (random() * debris);
    debris = rint(ceil(debris));
    while( debris > 0 ){
      launch_x = (back_x * 100) + (random() * 50);
      launch_y = (back_y * 100) + (random() * 50);
      launch_z = (back_z + 50) + (random() * 50);
      trailparticles(world, particleeffectnum("TE_DEBRIS_TRAIL_SMALL"), back, launch);
      debris = debris - 1;
    }
    
    if(explodeSize < 2 ){
      pointparticles( PTC_HIT_EXPL_SML, org, back, 1);
    }
    if(explodeSize == 2){
      pointparticles( PTC_HIT_EXPL_MED, org, back, 1);
    }
    else{
      pointparticles( PTC_HIT_EXPL_LRG, org, back, 1);
    }
  }
};

/*
  Unit's shields have been struck but still holding
*/
void() te_shield_hit_predraw={
  local float lerpDiff;
  local float lerp;
  
  if( time > self.data_lifetime || servertime > self.data_lifetime ){
    self.owner.shieldHitFlag = FALSE;
    self.owner.shieldEffectTime = time;
    remove(self);
    return;
  }
  
  self.colormod = self.compOffset;
  if (self.nextthink != self.frame1time){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    
    self.frame2 = self.frame1;
    self.frame1 = self.alpha;
    
    self.angle2 = self.angle1;
    self.angle1 = self.angles_y;
    
    self.origin2 = self.origin1;
    self.origin1 = self.origin;
  }
  lerpDiff = (time - self.frame2time) /(self.frame1time-self.frame2time);
  lerp = 1 - bound(0, lerpDiff, 1);
  self.lerpfrac = lerp;
  
  if( self.owner.entnum != player_localentnum ){
    traceline(self.owner.origin, CLIENT_vis_org, FALSE, self);
    
    if( (trace_fraction != 1.0 && trace_ent == world) || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
      return;
    }
  }
  
  
  self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
  self.alpha = self.frame1 + (self.frame2-self.frame1)*self.lerpfrac;
	setmodel(self, self.model);
  addentity(self);
};

void() te_shield_hit_th={

  self.origin = self.owner.origin;
  
  if( self.alpha < 0.01 ){
    self.owner.shieldHitFlag = FALSE;
    self.owner.shieldEffectTime = time;
    remove(self);
    return;
  }
  self.think = te_shield_hit_th;
  self.nextthink = time + 0.025;
};

void() te_shield_hit={
  local entity explode;
  local float hitTime;
  local vector flashCol;
  local float shieldSize;
  local float sizeMod;
  
  if( self.entnum != player_localentnum ){
    traceline(self.origin, CLIENT_vis_org, TRUE, self);
    
    if( (trace_ent == world && trace_fraction < 1.0) || trace_ent.data_type == DATA_BLD){
      return;
    } 
    
    if( vlen(self.origin - CLIENT_vis_org) > PARTICLE_HAZ_DISTANCE * 2){
      return;
    }
  }
  
  hitTime = 0.4;
  
  self.shieldEffectTime = time + hitTime;
  
  explode = spawn();
  if( explode ){
    sizeMod = self.shield / self.shieldMax;
    shieldSize = max(0.8, (self.cache_maxs_x / 64) * sizeMod);
    explode.data_lifetime = self.shieldEffectTime;
    explode.scale = 1.0;
    explode.effects = explode.effects | EF_NOSHADOW | EF_FULLBRIGHT;
    explode.predraw = te_shield_hit_predraw;
    explode.owner = self;
    explode.solid = SOLID_NOT;
    explode.think = te_shield_hit_th;
    explode.nextthink = time + 0.01;
    precache_model("models/fx/explosions/te_shield.md3");
    setmodel( explode, "models/fx/explosions/te_shield.md3");
    setsize(explode, explode.mins, explode.maxs);
    setorigin( explode, self.origin);
    explode.alpha = 0.4;
    explode.skin = 0;
    
    if(self.shieldHitFlag == SHIELD_HIT_EMP){
      flashCol = '1.0 0.4 1.0';
      explode.colormod = '1.2 0.6 1.2';
      explode.alpha = 0.55;
    }
    else {
      //SHIELD_HIT_REG
      explode.colormod = '0 1 0';
      flashCol = '0.003 0.87 0.22';
    }
    explode.compOffset = explode.colormod;
  }
  
  te_customflash( self.origin, self.shield * 1.5, 0.33, flashCol);
  Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_shieldhit%s.ogg", 1, ATTN_NORM, (0.67 + (random() * 0.33)) * 100, SOUNDFLAG_DYNAMIC_INT);
};


/*
  Unit's shields have broken (reduced to 0), play an expanding explosion shell effect.
*/

void() predraw_shield_explode={
  local float lerpDiff;
  local float lerp;
  
  self.colormod = self.compOffset;
  if (self.nextthink != self.frame1time){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    
    self.frame2 = self.frame1;
    self.frame1 = self.alpha;
    
    self.angle2 = self.angle1;
    self.angle1 = self.angles_y;
    
    self.origin2 = self.origin1;
    self.origin1 = self.origin;
  }
  lerpDiff = (time - self.frame2time) /(self.frame1time-self.frame2time);
  lerp = 1 - bound(0, lerpDiff, 1);
  self.lerpfrac = lerp;
  
  if( self.owner.entnum != player_localentnum ){
    traceline(self.owner.origin, CLIENT_vis_org, FALSE, self);
    
    if( (trace_fraction != 1.0 && trace_ent == world) || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
      return;
    }
  }
  
  self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
  self.alpha = self.frame1 + (self.frame2-self.frame1)*self.lerpfrac;
	setmodel(self, self.model);
  addentity(self);
};

void() te_shield_explode_th={
  self.alpha = self.alpha - (1.67 * frametime);
  self.scale = self.scale + (2 * frametime);
  
  if(self.owner.isLocalPlayer){
    self.origin = CLIENT_vis_org;
  }
  else{
    self.origin = self.owner.origin;
  }
  
  if( self.alpha < 0.01 ){
    self.owner.shieldHitFlag = FALSE;
    self.owner.shieldEffectTime = time;
    remove(self);
    return;
  }
  self.think = te_shield_explode_th;
  self.nextthink = time + 0.01;
};

void( vector org, float vecSize ) te_shield_explode={
  local entity explode;
  local vector flashCol;
  
  if( self.entnum != player_localentnum ){
    traceline(self.origin, CLIENT_vis_org, TRUE, self);
    
    if( (trace_ent == world && trace_fraction < 1.0) || trace_ent.data_type == DATA_BLD){
      return;
    } 
    
    if( vlen(self.origin - CLIENT_vis_org) > PARTICLE_HAZ_DISTANCE * 2){
      return;
    }
  }
  
  explode = spawn();
  if( explode ){
    explode.movetype = MOVETYPE_NONE;
    explode.solid = SOLID_NOT;
    explode.think = te_shield_explode_th;
    explode.nextthink = time + 0.01;
    explode.data_lifetime = 10;
    explode.scale = 0.1 + (vecSize / 3);
    explode.alpha = 0.75;
    if( self.isLocalPlayer ){
      explode.effects = explode.effects | EF_NOSHADOW | EF_FULLBRIGHT | EF_DOUBLESIDED;
    }
    else{
      explode.effects = explode.effects | EF_NOSHADOW | EF_FULLBRIGHT;
    }
    
    explode.predraw = predraw_shield_explode;
    precache_model("models/fx/explosions/te_shield.md3");
    setmodel( explode, "models/fx/explosions/te_shield.md3");
    setorigin( explode, org);
    explode.owner = self;
    explode.skin = 1;
    
    if(self.shieldHitFlag == SHIELD_HIT_IXP){
      flashCol = '1.0 0.0 0.4';
      explode.colormod = '1.2 0.2 0.6';
    }
    else {
      //SHIELD_HIT_EXP
      explode.colormod = '1 1 0.1';
      flashCol = '0.003 0.87 0.22';
    }
    explode.compOffset = explode.colormod;
    te_customflash( org, vecSize * 450, 2, flashCol);
  }
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
 
  traceline(self.origin, CLIENT_vis_org, TRUE, self);
  
  if( trace_ent == world && trace_fraction < 1.0){
    return;
  } 
  
  if( vlen(self.origin - CLIENT_vis_org) > PARTICLE_HAZ_DISTANCE * 2){
    return;
  }
  
  explode = spawn();
  if( explode ){
    explode.movetype = MOVETYPE_NONE;
    explode.solid = SOLID_NOT;
    explode.think = particle_missile_explode_th;
    explode.nextthink = time + 0.05;
    explode.pcl_lifetime = 10;
    explode.scale = explodeSize;
    explode.alpha = 1;
    explode.effects = explode.effects | EF_NOSHADOW;
    explode.avelocity = randomvec() * 300;
    explode.drawmask = MASK_NORMAL;
    if( onShield == TRUE ){
      explode.scale = explodeSize / 2;
      explode.alpha = 0.8;
      explode.colormod = '0.1 1 0.8';
    }
    else{
      explode.colormod = explodeColor;
    }
    
    setmodel( explode, "models/fx/explosions/te_missile_explode.md3");
    setorigin( explode, org);

    Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, (0.67 + (random() * 0.33)) * 110, SOUNDFLAG_DYNAMIC_INT);

    te_customflash( org, explodeSize * 50, 1.5, explodeColor); 
  }
};

/*
  Wreck event, ie a vehicle death
*/

void() particle_vehicle_wreck_cleanup={
  PARTICLE_WRECK_TANK = PARTICLE_WRECK_TANK - 1;
  
  remove(self);
};

void() particle_vehicle_wreck_th={
  if( time < self.pcl_fadeout ){
    particleDraw = vlen(CLIENT_vis_org - self.origin);
    if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
      pointparticles( self.pcl_effectnum, self.origin, self.pcl_velocity, self.pcl_count);
    }
    self.think = particle_vehicle_wreck_th;
    self.nextthink = servertime + (0.1 + (random() * 0.2));
  }
  self.pcl_fadeout = servertime + 30;
  self.think = particle_vehicle_wreck_cleanup;
  self.nextthink = servertime + 150 + (random() * 150);
};

void( float modelIndex, float skinNum, float lifetime, float vecSize, vector entOrg, vector entAngl ) particle_vehicle_wreck={
  local entity wreck;
  local entity this;
  local float sizeAdjust;
  
  Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM,  90 - (self.vec_size * 10), SOUNDFLAG_DYNAMIC_INT);
  
  if( PARTICLE_WRECK_TANK > PARTICLE_MAX_WRECK_TANK ){
    PARTICLE_WRECK_TANK = PARTICLE_WRECK_TANK - 1;
    wreck = find(world, classname, "wreck_tank");
    remove(wreck);
    return;
  }
  
  this = self;
  wreck = spawn();
  if( wreck ) {
    PARTICLE_WRECK_TANK = PARTICLE_WRECK_TANK + 1;
    self = wreck;
      self.classname = "wreck_tank";
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
      self.pcl_lifetime = servertime + (lifetime + sizeAdjust);
      self.pcl_fadeout = servertime + ( lifetime * 0.75);
      self.pcl_count = 1;
      self.nextthink = servertime + (random() * 1);
      self.think = particle_vehicle_wreck_th;
      self.drawmask = MASK_NORMAL;
    self = this;
  }
};

void(vector entOrg, vector entAngl, float entSize, vector entMins, float leftBool) te_foot_stomp={
  local vector fx, vel;
  local float leftMin;
  local float effType;
  local float sizeMod;
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE / 2 ){
    
    makevectors( entAngl );
    fx = entOrg ;
    leftMin = entMins_x * 0.8;
    if( leftBool ){
       fx = fx + (v_right * leftMin);
    }
    else{
       fx = fx - (v_right * leftMin);
    }
    
    fx = fx + (v_up * (entMins_z + 8));
    vel = fx + (v_up * 16);
    
    sizeMod = self.vec_size / 10;
    sizeMod = 1.0 - (1.0 - sizeMod) / 2;
    sound7(self, CHAN_AUTO, "sound/mech_stomp.ogg", 1.0, ATTN_NORM, (sizeMod + (random() * sizeMod)) * 90, 0 );
    
    switch( ENT_SERVER_INFO.worldtype ){
      case 1:
        effType = PTC_STOMP_ICE;
        break;
      case 2:
        effType = PTC_STOMP_CITY;
        break;
      case 3:
        effType = PTC_STOMP_BADLND;
        break;
      case 4:
        effType = PTC_STOMP_TUNDRA;
        break;
      default:
        effType = PTC_STOMP_SAND;
        break;
    }
    pointparticles( effType, fx, normalize(vel - fx) * 3,  entSize * 2);
    traceline(fx, fx + (v_up * -10), MOVE_WORLDONLY, self);
    pointparticles( particleeffectnum("TE_FOOT_STOMP"), trace_endpos, trace_plane_normal * -1,  1);
  }
};

/*
  Particle Determinant for impact types of weapon fire
*/
float(vector endPos, entity endEnt, float contentFlags) te_impact_type={
  if( (contentFlags & DPCONTENTS_SKY) || (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) ){
    return IMPACT_SKY;
  }
  if(endEnt){
    if(endEnt.takedamage == DAMAGE_AIM){
      if(endEnt.shield > 0 && endEnt.shield <= 100.0){
        return IMPACT_SHIELD;
      }
      return IMPACT_ARMOR;
    }
    return IMPACT_DIRT;
  }
  else{
    if( (contentFlags & DPCONTENTS_SOLID) ){
      return IMPACT_DIRT;
    }
    if(pointcontents(endPos) == CONTENT_SOLID){
      return IMPACT_DIRT;
    }
  }
  return IMPACT_SKY;
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

/*
  burning mech legs
*/
void() te_mech_dead_legs_burn={
  local vector fireOrg;
  
  if( time > self.data_lifetime ){
    self.think = te_mech_dead_legs_smoke;
    self.nextthink = servertime + frametime*0.1;
    self.data_lifetime = servertime + 500 + (random() * 300);
    return;
  }
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    makevectors(self.angles);
    fireOrg = self.origin + (v_up * self.maxs_z);
  
    pointparticles( particleeffectnum("TE_FIRE_3"), fireOrg , normalize(fireOrg - self.origin) * 2, self.vec_size + (random() * 4));
  }
  
  self.think = te_mech_dead_legs_burn;
  self.nextthink = servertime + frametime*0.5;
};

void() te_mech_dead_legs_smoke={
  local vector fireOrg;
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    makevectors(self.angles);
    fireOrg = self.origin + (v_up * self.maxs_z);
    pointparticles( particleeffectnum("TE_FIRE_3"), fireOrg , normalize(fireOrg - self.origin) * 2, self.vec_size + (random() * 4));
  }
  if( servertime > self.data_lifetime ){
    self.think = SUB_Remove;
    self.nextthink = servertime + frametime*0.1;
    return;
  }

};

//Particle box
void() particle_box_ini={
  PTC_CUBE_ON = TRUE;
  
  PTC_CUBE_TYPE = ReadByte();
  
  PTC_CUBE_MIN_x = ReadLong();
  PTC_CUBE_MIN_y = ReadLong();
  PTC_CUBE_MIN_z = ReadLong();
  
  PTC_CUBE_MAX_x = ReadLong();
  PTC_CUBE_MAX_y = ReadLong();
  PTC_CUBE_MAX_z = ReadLong();
  
  PTC_CUBE_VEL_x = ReadLong();
  PTC_CUBE_VEL_y = ReadLong();
  PTC_CUBE_VEL_z = ReadLong();
  
  PTC_CUBE_COUNT = ReadShort();
  PTC_CUBE_COLOR = ReadShort();
  PTC_CUBE_GRAV = ReadShort();
  PTC_CUBE_VEL_JITTER = ReadShort();
  PTC_CUBE_LIFETIME = ReadShort();
  
  PTC_CUBE_FLAGS = ReadLong();
  
  PTC_CUBE_ORG = CLIENT_vis_org;
};

void() particle_box_think={
  
  local vector amin, amax;
  local vector playerMove, playerOrgOffset;
  local float cubeLen;
  local entity meta;
  
  
  playerMove = vectoangles(pmove_vel);
  makevectors([playerMove_x, playerMove_y, 0]);
  
  playerOrgOffset = CLIENT_server_ent.rootOrigin + (v_forward * (PTC_CUBE_MAX_x * 0.5) );
  
  cubeLen = vlen( playerOrgOffset - PTC_CUBE_ORG);
  if( cubeLen > PTC_CUBE_MAX_x ){
    PTC_CUBE_ORG = CLIENT_server_ent.rootOrigin + (v_forward * (PTC_CUBE_MAX_x * 0.9)); 
  }
  
  traceline(playerOrgOffset, playerOrgOffset + (v_up * PTC_CUBE_MAX_z), TRUE, world);
  PTC_CUBE_MAX_z = vlen(trace_endpos - PTC_CUBE_ORG) * 0.5;
  
  amin = PTC_CUBE_ORG + PTC_CUBE_MIN;
  amax = PTC_CUBE_ORG + PTC_CUBE_MAX;
  
  for(meta = particleCubeMetaDataList; meta != world; meta = meta.w_slot){
    if( BoxesOverlap(CLIENT_server_ent.rootOrigin - '2 2 2', CLIENT_server_ent.rootOrigin + '2 2 2', meta.absmin, meta.absmax ) ){
      amin = meta.absmin;
      amax = meta.absmax;
      break;
    }
  }
  
  switch( PTC_CUBE_TYPE ){
    case PTC_CUBE_TYPE_BASIC:
      te_particlecube(amin, amax, PTC_CUBE_VEL, PTC_CUBE_COUNT, PTC_CUBE_COLOR, PTC_CUBE_GRAV, PTC_CUBE_VEL_JITTER);
      break;
    case PTC_CUBE_TYPE_RAIN:
      //te_particlerain(amin, amax, PTC_CUBE_VEL, PTC_CUBE_COUNT, PTC_CUBE_COLOR);
      CL_ParticleRain(PTC_CUBE_VEL, PTC_CUBE_COUNT);
      break;
    case PTC_CUBE_TYPE_SNOW:
      te_particlesnow(amin, amax, PTC_CUBE_VEL, PTC_CUBE_COUNT, PTC_CUBE_COLOR);
      break;
  }

  PTC_CUBE_UPDATE = time + (20 * frametime);
};


/**
  Chopped-down copy of engine-side call of CL_ParticleRain, removes costly impact tests
*/
void(vector dir, float count) CL_ParticleRain={
  local float k;
  local float minz, maxz, lifetime;
  local vector org;
  local float total;
  local vector v;

  total = PTC_CUBE_COUNT;

  pointparticles( particleeffectnum("TE_RAIN_DROP"), org, normalize(dir) * 10, count);
  while(total > 0){
    v = randomvec2();
    org_x = CLIENT_server_ent.rootOrigin_x + (v_x * PTC_CUBE_MAX_x);
    org_y = CLIENT_server_ent.rootOrigin_y + (v_y * PTC_CUBE_MAX_y);
    org_z = CLIENT_server_ent.rootOrigin_z + PTC_CUBE_MAX_z;

    pointparticles( particleeffectnum("TE_RAIN_DROP"), org, normalize(dir) * 50, 1);
    total = total - 1;
  }
};


void() particle_beam_th={

  if(time > self.beamTime){
    self.beamActive = FALSE;
    remove(self);
  }
}

void() particle_beam_las_draw={
  if(vlen(self.beamOrg - CLIENT_vis_org) > PARTICLE_HAZ_DISTANCE * 2){
   return;
  }
  if(self.beamActive == FALSE){
    return;
  }
  Draw_CylindricLine(self.beamOrg, self.beamEnd, self.beamWidth, "particles/laserbeam", 0.5, time * (random() * -6), self.drawcolor1, 0.75, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
};

void() particle_beam_pac_draw={
  if(vlen(self.beamOrg - CLIENT_vis_org) > PARTICLE_HAZ_DISTANCE * 2){
   return;
  }
  if(self.beamActive == FALSE){
    return;
  }
  Draw_CylindricLine(self.beamOrg, self.beamEnd, self.beamWidth, "particles/laserbeam", 0.5, time * (random() * -6), self.drawcolor1, 0.75, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
};

void() particle_beam_lightning_draw={
  local float segCount;
  local vector bAngl;
  local float segment;
  local vector segOrg;
  local vector nexOrg;
  local float itr;
  local float width;

  if(vlen(self.beamOrg - CLIENT_vis_org)  > PARTICLE_HAZ_DISTANCE * 2){
   return;
  }

  if(self.beamActive == FALSE){
    return;
  }
  segCount = 6;
  width = self.beamWidth;
  segment = rint(vlen(self.beamEnd - self.beamOrg) / segCount);
  segOrg = self.beamOrg;

  bAngl = vectoangles(self.beamEnd - self.beamOrg);
  bAngl_x = bAngl_x * -1;
  makevectors(bAngl);

  nexOrg = self.beamOrg + (v_forward * segment) + (v_right * crandom() * 4) + (v_up * crandom() * 6);
  Draw_CylindricLine(self.beamOrg, nexOrg, width, "particles/electro_beam", 0.1, time * 0.1, '0.17 0.33 1.0', 1.0, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
  segOrg = nexOrg;
  segCount = segCount - 1;

  for( itr = segCount; itr < (segment-2); itr = itr + 1){
    nexOrg = self.beamOrg + (v_forward * segment * itr) + (v_right * crandom() * 2) + (v_up * crandom() * 4);

    Draw_CylindricLine(segOrg, nexOrg, width, "particles/electro_beam", 0.1, time * 0.1, '0.17 0.33 1.0', 1.0, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
    
    width = max(1, width - 1);

    segOrg = nexOrg;
  }
  Draw_CylindricLine(segOrg, self.beamEnd, width, "particles/electro_beam", 0.1, time * 0.1, '0.17 0.33 1.0', 1.0, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);

};

//float beamType, vector particleOrg, vector particleEnd, float width, float aspect, float shift, vector colr, float alph
void(float beamType, float entId, vector particleOrg, vector particleEnd, float width, float impactType) particle_spawn_beam={

  local entity ent;
  local entity this;

  //'WORLD' beam effects, not bound to weapons
  if(entId == 0){
    ent = spawn();
    if(!ent){
      return;
    }
    if(beamType == BEAM_LAS){
      ent.predraw = particle_beam_las_draw;
      ent.nextthink = time + 0.2;
    }
    else if(beamType == BEAM_ESR){
      ent.predraw = particle_beam_lightning_draw;
      ent.nextthink = time + 0.075;
    }
    else if( beamType == BEAM_PAC){
      ent.predraw = particle_beam_pac_draw;
      ent.nextthink = 0.5;
    }
    else{
      //no-op, bad beam type
      return;
    }
    ent.drawmask = MASK_NORMAL;
    ent.origin = particleOrg;
    ent.solid = SOLID_NOT;
    ent.movetype = MOVETYPE_NONE;
    setsize(ent, '-1 -1 -1', '1 1 1');
    setorigin(ent, ent.origin);
    ent.beamOrg = particleOrg;
    ent.beamEnd = particleEnd;
    ent.beamWidth = width;
    ent.beamActive = TRUE;
    ent.think = particle_beam_th;
    return;
  }

  //WEAPON beam effects
  ent = findfloat(world, entnum, fabs(rint(entId)));
  if(!ent){
    cons_logAFloat("BEAM CHECK ent null", num_for_edict(ent)); //debug
    return;
  }
  if(!ent.owner){
    cons_logAFloat("BEAM CHECK ent owner null", num_for_edict(ent)); //debug
    return;
  }
  if(ent.beamActive){
    cons_logAFloat("BEAM CHECK beam already active", num_for_edict(ent)); //debug
    return;
  }

  ent.beamEnd = particleEnd;
  ent.pcl_count = impactType;

  this = self;
  self = ent.owner;
    te_weapon_fire_handler(ent, ent.owner);
  self = ent;
    if(self.itemMuzzleFlash){
      self.itemMuzzleFlash();
    }
  self = this;
};

//maybe at some point someone can figure out MOVETYPE_BOUNCE for csqc.
/*
void() te_explode_mech_piece_predraw={
  local float lerpDiff;
  local float lerp;
  
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
  lerpDiff = (time - self.frame2time) /(self.frame1time-self.frame2time);
  lerp = bound(0, self.lerpfrac, 1);
  self.lerpfrac = lerp;

  self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
};


void() te_explode_mech_piece_th={
  self.think = te_explode_mech_piece_th;
  self.nextthink = time + 0.05;
};

void(entity piece) te_explode_mech_piece={
  local entity t;
  makevectors(piece.angles);
  t = spawn();
  if( t ){
    t.drawmask = MASK_NORMAL;
    setmodel(t, piece.model);
    setsize(t, '0 0 0', '0 0 0');
    setorigin(t, piece.origin);
    t.colormod = piece.colormod;
    t.movetype = MOVETYPE_BOUNCE;
    t.solid = SOLID_BBOX;
    t.velocity = normalize((piece.origin + v_up * 10) - piece.origin);
    t.velocity = t.velocity * 300;
    t.velocity_z = 400;
    t.avelocity = '100 100 100';
    t.angles = piece.angles;
    t.think = te_explode_mech_piece_th;
    t.nextthink = time + 0.05;
    t.data_lifetime = servertime + 400 + (random() * 250);
    t.predraw = te_explode_mech_piece_predraw;
  }
};*/