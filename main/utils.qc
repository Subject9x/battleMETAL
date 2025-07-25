/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
      mod 3/16/2017
      mod 5/17/2017 - normalize time as percent
      mod 2/18/2018
      mod 10/05/2018
Overview: utility functions
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
    //enEntity.cacheGroundAngle = enEntity.angles;
	}
}

/*
  Drop to floor makes too many nice assumptions about how
  far off ground the entity is. _dropToGround is a more refined
  algo for standing an entity on the ground regardless of starting
  Z coord.
*/
vector(vector angl, vector org, float zAdjust) util_dropToGround={
  local vector spot;
  makevectors(angl);
  traceline(org, org + (v_up * -3000), FALSE, self);
  spot = trace_endpos;
  spot_z = spot_z - zAdjust;
  return spot;
};

/*
  A bit on-the-nose, but, this is a dice roller
  for semi-random whole numbers.
  numOfSides = number of sides to the die,
  results have to be interepreted by whatever is calling this function
*/
float(float numOfSides) util_roll_dice={
  local float roll;
  roll = ( (1 + crandom()) * numOfSides);
  roll = ceil(roll);
  
  if(roll < 0){
    roll = roll * -1;
  }
  if(roll == 0){
    roll = 1;
  }
  return roll;
};

float(entity t) util_getMechHpAverage={
  local float total, cur;
  
  if(t != world){
    if( t.data_type == DATA_MECH ){
      total = t.max_health;
      total = total + t.armL_hpMax;
      total = total + t.armR_hpMax;
      total = total + t.torL_hpMax;
      total = total + t.torR_hpMax;
      total = total + t.legs_hpMax;
      cur = t.health;
      cur = cur + t.armL_hp;
      cur = cur + t.armR_hp;
      cur = cur + t.torL_hp;
      cur = cur + t.torR_hp;
      cur = cur + t.legs_hp;
    }
    else{
      total = t.max_health;
      cur = t.health;
    }
    total = cur / total;
    return total;
  }
  return FALSE;
};

float(entity t) util_getMechHpTotal={
  local float total;
  if(t != world){
    total = t.max_health + (t.armL_hpMax * 2) + (t.torL_hpMax * 2) + t.legs_hpMax;
    return total;
  }
  return FALSE;
};

vector(vector facing, vector centerpoint, vector sz_max) util_findOpenSpawnArea={
  local vector locus;
  local float dist, side, dir, box;
  
  box = sz_max_x * 2;
  dist = box * util_roll_dice(4);
  side = util_roll_dice(2);
  dir = util_roll_dice(2);
  
  if(side == 1){
    side = -1;
  }
  if(dir == 1){
    dir = -1;
  }
  makevectors(facing);
  locus = centerpoint + (v_forward * (dir * dist) ) + (v_right * (side * dist) );
  traceline(centerpoint, locus, FALSE, self);
  return trace_endpos;
};

//applies 'spread' to the endpos of a previous trace
//spread values are taken as cumulatives - add all spread maximums together
vector( vector fireOrg, float idealRange ) util_applySpreadToTrace={
  local vector direction;
  local vector acc;
  local vector wepAim;
  local vector targVel;
  
  
  //weaponSpread
  if( (self.owner.flags & FL_MONSTER) ){
    targVel = '0 0 0';
    if( (self.owner.enemy.flags & FL_CLIENT) ){
      targVel = self.owner.enemy.velocity;
    }
    //AI aiming
    if( self.beamFlag ){
      if( self.owner.enemy.data_type == DATA_BLD ){
        direction = self.owner.enemy.hitOffset;
      }
      else{
        direction = self.owner.enemy.origin;
      }
    }
    else{
      if( self.owner.enemy.data_type == DATA_BLD ){
        direction = self.owner.enemy.hitOffset - (targVel * self.owner.ai_leading);
      }
      else{
        direction = (self.owner.enemy.origin + '0 0 10') - (targVel * self.owner.ai_leading);
      }
    }
  }
  else{
    direction = self.owner.laser_sight_org;
  }

  acc = vectoangles(direction - fireOrg);
  acc_x = acc_x * -1;
  makevectors(acc);
  if( vlen(self.owner.laser_sight_org - fireOrg) > idealRange){
    acc = vectoangles((self.owner.origin + (v_forward * idealRange)) - fireOrg);
    acc_x = acc_x * -1;
    makevectors(acc);
    direction = fireOrg + (v_forward * idealRange);
  }
    
  if((self.owner.flags & FL_MONSTER)){
    direction = direction + ((crandom() * self.owner.accuracy) * v_right) + ((crandom() * self.owner.accuracy) * v_up);
  }
  direction = direction + ((crandom() * self.spreadDefault_x) * v_right) + ((crandom() * self.spreadDefault_y) * v_up);

  wepAim = normalize( direction - fireOrg ); 

  self.owner.dphitcontentsmask =  (DPCONTENTS_OPAQUE | Q3SURFACEFLAG_SKY | DPCONTENTS_SOLID | DPCONTENTS_BODY) ;
    traceline (fireOrg, fireOrg + (wepAim * idealRange), MOVE_MISSILE, self.owner);
  self.owner.dphitcontentsmask = 0;

  return trace_endpos;
};

//simply returns a vector offset from an origin along a given angle
vector( vector start, vector offsets, vector viewAngle) util_getOffsetOfVector={
  local vector v;
  makevectors( viewAngle );
  v = start + (v_forward * offsets_z) + (v_up * offsets_y) +(v_right * offsets_x);
  return v;
};

//inspired by original inFront function
float(entity trg) util_checkPointAngle={
  local float toSender;
  toSender = util_checkPointAngleImpl(trg.origin);
  return toSender;
};

//inspired by original inFront function
float(vector orig) util_checkPointAngleImpl ={
  
	local vector	vec;
	local float		f_dot, s_dot;
	
	makevectors (self.v_angle);
	vec = normalize (orig - self.origin);
	f_dot = vec * v_forward;
  s_dot = vec * v_right;
	if ( f_dot > 0.6 ){
		return -1;
	}
  else{
    if(f_dot < -0.9 && s_dot <= 0.1){
      return 2;
    }
    else{
      if(s_dot > 0.1){
        return 1;
      }
      else {
        return 0;
      }
    }
  }
};

/*
  just a tightened up util_checkPointAngleImpl for lock on mechanics
*/
float(vector orig) util_lockOnChoke={
  
	local vector	vec, vew;
  
	makevectors (self.angles);
	vec = normalize (orig - self.origin);
	vew_x = vec * v_forward;
  vew_y = vec * v_right;
  
  makevectors(self.v_angle);
	vec = normalize (orig - self.origin);
  vew_z = vec * v_up;
  
  if( vew_x > 0.9){
    if( (vew_y < 0.4) && (vew_y > -0.4)){
      if( (vew_z < 0.4) && (vew_z > -0.4) ){
        return TRUE;
      }
    }
  }
  return FALSE;
};

void(entity targetEnt, vector hitOrigin) util_checkPointToHitDir={
  local vector normal;
  local float fwd;
  local float side;
  local float entViewYaw;
  local float checkYaw = 0;

  makevectors(targetEnt.v_angle);
  normal = normalize(hitOrigin - targetEnt.origin);
  fwd = normal * v_forward;
  side = normal * v_right;
  
  if(fwd < 0.5){
    //right side hit
    if(side > 0.0){
      if(fwd < 0.5 && fwd >= 0.0){
        targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs | STAT_HIT_DIR1;
      }
      else if(fwd < 0.0 && fwd >= -0.5){
        targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs | STAT_HIT_DIR2;
      }
      else if(fwd < -0.5){
        targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs | STAT_HIT_DIR3;
      }
    }
    else{
      //left side
      if(fwd < 0.5 && fwd >= 0.0){
        targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs | STAT_HIT_DIR6;
      }
      else if(fwd < 0.0 && fwd >= -0.5){
        targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs | STAT_HIT_DIR5;
      }
      else if(fwd < -0.5){
        targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs | STAT_HIT_DIR4;
      }
    }
  }
  targetEnt.stat_hit_dirs = targetEnt.stat_hit_dirs;
};


void(entity targ, entity src, vector ofs) util_setOffsetOrigin={
  local vector next;
  makevectors(src.angles);
  next = src.origin + (v_up * ofs_y) + (v_right * ofs_x) + (v_forward * ofs_z);
  setorigin(targ, next);
};


void(string mdl_name, float skinNum, float ef_flags) util_setModel={
  local string path;
  self.effects = self.effects | ef_flags;
  self.skin = skinNum;
  path = precache_model2( mdl_name );
  setmodel(self, path);
};


/*
  Runs a traceline from all 4 bottom corners of the entity.
  if normal of any of the points is less than the tolerance, 
    adjust the origin of the entity to slightly above the slope.
*/
float(entity t, float tolerance) util_cornerSlopeCheck={
  local vector start, c1,c2,c3,c4, check;
  local vector down;
  local float distanceCheck, comparator, hold;
  
  makevectors(t.angles);
  start = t.origin + (v_up * self.mins_z);
  c1 = start + (v_right * self.maxs_x) + (v_forward * self.maxs_y);
  c2 = start + (v_right * self.mins_x) + (v_forward * self.maxs_y);
  c3 = start + (v_right * self.mins_x) + (v_forward * self.mins_y);
  c4 = start + (v_right * self.maxs_x) + (v_forward * self.mins_y);
  distanceCheck = 0;
  
  /*
  corner check
    if distance under the corner is greater than 5 units, mark the corner
    
  */
  down = v_up * -4000;
  traceline(c1, c1 + down, FALSE, t);
  if( vlen(trace_endpos - c1) > tolerance ){
    distanceCheck = distanceCheck + 1;
    comparator = vlen(trace_endpos - c1);
  }
  
  traceline(c2, c2 + down, FALSE, t);
  if( vlen(trace_endpos - c2) > tolerance ){
    distanceCheck = distanceCheck + 1;
    hold = vlen(trace_endpos - c2);
    if( hold < comparator ){
      comparator = hold;
    }
  }
  
  traceline(c3, c3 + down, FALSE, t);
  if( vlen(trace_endpos - c3) > tolerance ){
    distanceCheck = distanceCheck + 1;
    hold = vlen(trace_endpos - c3);
    if( hold < comparator ){
      comparator = hold;
    }
  }
  
  traceline(c4, c4 + down, FALSE, t);
  if( vlen(trace_endpos - c4) > tolerance ){
    distanceCheck = distanceCheck + 1;
    hold = vlen(trace_endpos - c4);
    if( hold < comparator ){
      comparator = hold;
    }
  }
  
  if( distanceCheck > 0 ){
    traceline(self.origin, self.origin + (v_up * (comparator * -1)), FALSE, self);
    check = trace_endpos;
    check = check + (v_up * (self.mins_z *-1) );
    setorigin( self, check );
    return TRUE;
  }
  
  return FALSE;
};


void() dropToFloorCorners={
  local vector c1,c2,c3,c4, check;
  local vector down;
  local float distanceCheck, comparator, hold;
  
  makevectors(self.angles);
  c1 = self.origin + (v_up * (self.mins_z - 8)) + (v_right * self.maxs_x) + (v_forward * self.maxs_y);
  c2 = self.origin + (v_up * (self.mins_z - 8)) + (v_right * self.mins_x) + (v_forward * self.maxs_y);
  c3 = self.origin + (v_up * (self.mins_z - 8)) + (v_right * self.mins_x) + (v_forward * self.mins_y);
  c4 = self.origin + (v_up * (self.mins_z - 8)) + (v_right * self.maxs_x) + (v_forward * self.mins_y);
  distanceCheck = 0;
  
  /*
  corner check
    if distance under the corner is greater than 5 units, mark the corner
    
  */
  down = v_up * -4000;
  traceline(c1, c1 + down, MOVE_HITMODEL, self);
  if( vlen(trace_endpos - c1) > 0 ){
    distanceCheck = distanceCheck + 1;
    comparator = vlen(trace_endpos - c1);
  }
  
  traceline(c2, c2 + down, MOVE_HITMODEL, self);
  if( vlen(trace_endpos - c2) > 0 ){
    distanceCheck = distanceCheck + 1;
    hold = vlen(trace_endpos - c2);
    if( hold < comparator ){
      comparator = hold;
    }
  }
  
  traceline(c3, c3 + down, MOVE_HITMODEL, self);
  if( vlen(trace_endpos - c3) > 0 ){
    distanceCheck = distanceCheck + 1;
    hold = vlen(trace_endpos - c3);
    if( hold < comparator ){
      comparator = hold;
    }
  }
  
  traceline(c4, c4 + down, MOVE_HITMODEL,  self);
  if( vlen(trace_endpos - c4) > 0 ){
    distanceCheck = distanceCheck + 1;
    hold = vlen(trace_endpos - c4);
    if( hold < comparator ){
      comparator = hold;
    }
  }
  
  if( distanceCheck > 0 ){
    traceline(self.origin, self.origin + (v_up * (comparator * -1)), MOVE_HITMODEL, self);
    check = trace_endpos;
    check = check + (v_up * (self.mins_z *-1) );
    setorigin( self, check );
  }
};

void(entity t) util_generateBuildingFoundation={
  local vector v;
  local entity notSelf, n;
  
  self.SendFlags = self.SendFlags | SENDFLAG_CAMERA;
  self.groundEnt = TRUE;
 
  makevectors(t.angles);
  v = t.origin + (v_up * t.mins_z);
  n = spawn();
  notSelf = self;
  self = n;
    self.classname = "map_terrain";
    switch( t.vec_size ){
      case 1:
        util_setModel("models/map/plats/plat_small.obj", 0, 0) ;
        break;
      case 2:
        util_setModel("models/map/plats/plat_medium.obj", 0, 0) ;
        break;
      case 3:
        util_setModel("models/map/plats/plat_large.obj", 0, 0);
        break;
    }
    self.takedamage = DAMAGE_NO;
    self.solid = SOLID_NOT; //just for placement
    self.movetype = MOVETYPE_NONE;
    setsize(self, self.mins, self.maxs);
    setorigin(self, v);
    self.solid = SOLID_BSP; //lock it in.
    self.effects = self.effects | EF_NODRAW;
  self = notSelf;
  
};
 
float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

vector( vector entOrg, vector entAng, vector entMins, vector entMaxs ) util_pointNearBoxEdge={
  local vector angl;
  local vector newpos;
  local float len;
  local float hight;
  
  angl = entAng;
  angl_y = anglemod(angl_y +  45 + random() * 270);

  len = entMaxs_x * 0.75;
  
  hight = entMaxs_z * 0.65;
  hight = hight + (random() * (entMaxs_z * 0.25));
  
  newpos = entOrg;
  makevectors( angl );
  newpos = newpos + (v_forward * len);
  newpos = newpos + (v_up *  hight);
  return newpos;
};

void(string msg, float val) cons_logAFloat={
  #ifdef SSQC
    dprint(sprintf("[SV] %s : %0.2f \n", msg, val));
  #endif
  #ifdef CSQC
    dprint(sprintf("[CS] %s : %0.2f \n", msg, val));
  #endif
  #ifdef MENUQC
    dprint(sprintf("[MN] %s : %0.2f \n", msg, val));
  #endif
};
void(string msg, vector v1) cons_logAVector={
  #ifdef SSQC
    dprint(sprintf("[SV] %s : %0.2f %0.2f %0.2f \n",msg, v1_x, v1_y, v1_z));
  #endif
  #ifdef CSQC
    dprint(sprintf("[CS] %s : %0.2f %0.2f %0.2f \n",msg, v1_x, v1_y, v1_z));
  #endif
  #ifdef MENUQC
    dprint(sprintf("[MN] %s : %0.2f %0.2f %0.2f \n",msg, v1_x, v1_y, v1_z));
  #endif
};
void(string msg, string s1) cons_logAString={
  #ifdef SSQC
    dprint(sprintf("[SV] %s : %s \n", msg, s1));
  #endif
  #ifdef CSQC
    dprint(sprintf("[CS] %s : %s \n", msg, s1));
  #endif
  #ifdef MENUQC
    dprint(sprintf("[MC] %s : %s1 \n", msg, s1));
  #endif
};

void(string msg, float val, string split, float val2) cons_log2Float={
  #ifdef SSQC
    dprint(sprintf("[SV] %s : %0.2f | %s : %0.2f \n", msg, val, split, val2));
  #endif
  #ifdef CSQC
    dprint(sprintf("[CS] %s : %0.2f | %s : %0.2f \n", msg, val, split, val2));
  #endif
  #ifdef MENUQC
    dprint(sprintf("[MC] %s : %0.2f | %s : %0.2f \n", msg, val, split, val2));
  #endif
};
void(string msg, vector v1, string split, vector v2) cons_log2Vectors={
  #ifdef SSQC
    dprint(sprintf("[SV] %s : %s | %s : %s \n", msg, vtos(v1), split, vtos(v2)));
  #endif
  #ifdef CSQC
    dprint(sprintf("[CS] %s : %s | %s : %s \n", msg, vtos(v1), split, vtos(v2)));
  #endif
  #ifdef MENUQC
    dprint(sprintf("[MC] %s : %s | %s : %s \n", msg, vtos(v1), split, vtos(v2)));
  #endif
};
void(string msg, string s1, string split, string s2) cons_log2Strings={
  #ifdef SSQC
    dprint(sprintf("[SV] %s : %s | %s : %s\n", msg, s1, split, s2));
  #endif
  #ifdef CSQC
    dprint(sprintf("[CS] %s : %s | %s : %s \n", msg, s1, split, s2));
  #endif
  #ifdef MENUQC
    dprint(sprintf("[MQ] %s : %s | %s : %s \n", msg, s1, split, s2));
  #endif
  
};

void() BecomeExplosion={
  makevectors( self.angles );
  //TODO - replace
  //te_missile_explode( self.origin + (v_up * -5),  1, '0.663 0.886 0.953', self.damageValue / 5, 1);
  precache_sound("sound/fx_boom.ogg");
  sound(self, CHAN_VOICE, "sound/fx_boom.ogg", 1 , ATTN_NORM);
  self.deadflag = DEAD_DEAD;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "");
	self.solid = SOLID_NOT;
  self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

/*
  Used for map dev, marks out map objects when cvar("developer") = TRUE,
*/
void() util_MapDeveloperMarker={
  if( cvar("developer") == TRUE ){
    self.alpha = 1;
    self.scale = 1;
  }
  else{
    self.alpha = 0.01;
    self.scale = 0.01;
    self.effects = self.effects | EF_NOSHADOW;
  }
  setmodel(self, "models/testball.md3");
};

void() util_DeveloperNodeMark={
  if( !cvar("developer") ){
    self.effects = self.effects | EF_NODRAW;
  }
};

/*
  Cast out 6 rays to find random furthest point from an origin
*/
vector(vector org, entity filter, float len, float useHeight) util_find_random_farpoint={
  local float itr;
  local vector ang;
  local vector landing;
  
  ang = self.angles;
  //quantize rays into semi-random 60deg increments, then correct for 0==360
  itr = rint(random()*10);
  itr = itr * (random() * 18);
  itr = itr + 18;
  itr = itr - 90;
  ang_y = anglemod(ang_y + itr);
  makevectors(ang);
  traceline(org, org + (v_forward * len), MOVE_NORMAL, filter);

  landing = trace_endpos + (v_up * useHeight);
  if( trace_fraction < 1 ){
    landing = landing - (v_forward * (trace_fraction * len)) ;
  }

  return landing;
};

/*
  Converts trace_plane_normal into useable angles, 
  sourced: moddb tutorial.
*/
vector() util_trace_norm_angle={
  local vector norm;
  local vector normAng;
  norm = trace_plane_normal;
  norm_x = 0 - norm_x;
  norm_y = 0 - norm_y;
  normAng = vectoangles(norm);
  return normAng;
};


/*
  mostly for bots, tracks the last frame's movement
*/
float( vector last, vector now, float len ) util_movedelta={
  if( vlen(now - last) >= len ){
    return TRUE;
  }
  return FALSE;
};
/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};
