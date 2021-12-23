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

float( entity t, float hpMax ) util_getPieceHpForAverage={
  local float sendBack;
  sendBack = 0;
  if( t != world ){
    if( hpMax ){
      sendBack = t.max_health;
    }
    else{
      sendBack = t.health;
    }
  }
  return sendBack;
};

float(entity t) util_getMechHpAverage={
  local float total, cur;
  
  if(t != world){
    if( t.data_type == DATA_MECH ){
      total = t.max_health;
      total = total + util_getPieceHpForAverage( t.armLeft, TRUE );
      total = total + util_getPieceHpForAverage( t.armRight, TRUE  );
      total = total + util_getPieceHpForAverage( t.torsoLeft, TRUE  );
      total = total + util_getPieceHpForAverage( t.torsoRight, TRUE  );
      total = total + util_getPieceHpForAverage( t.legs, TRUE );
      cur = t.health;
      cur = cur + util_getPieceHpForAverage( t.armLeft, FALSE );
      cur = cur + util_getPieceHpForAverage( t.armRight, FALSE  );
      cur = cur + util_getPieceHpForAverage( t.torsoLeft, FALSE  );
      cur = cur + util_getPieceHpForAverage( t.torsoRight, FALSE  );
      cur = cur + util_getPieceHpForAverage( t.legs, FALSE  );
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

entity(entity t) util_findMechCrit={
  local entity part;
  local float final, perc;
  
  final = t.health / t.max_health;
  
  if( t.armLeft.deadflag == DEAD_NO ){
    perc = t.armLeft.health / t.armLeft.max_health;
    if( perc < final ){
      final = perc;
      part = t.armLeft;
    }
  }
  if( t.armRight.deadflag == DEAD_NO ){
    perc = t.armRight.health / t.armRight.max_health;
    if( perc < final ){
      final = perc;
      part = t.armRight;
    }
  }
  if( t.torsoLeft.deadflag == DEAD_NO ){
    perc = t.torsoLeft.health / t.torsoLeft.max_health;
    if( perc < final ){
      final = perc;
      part = t.torsoLeft;
    }
  }
  if( t.torsoRight.deadflag == DEAD_NO ){
    perc = t.torsoRight.health / t.torsoRight.max_health;
    if( perc < final ){
      final = perc;
      part = t.torsoRight;
    }
  }
  if( t.legs.deadflag == DEAD_NO ){
    perc = t.legs.health / t.legs.max_health;
    if( perc < final ){
      final = perc;
      part = t.legs;
    }
  }
  if( !part ){
    part = t;
  }
  return part;
};

float(entity t) util_getMechHpTotal={
  local float total;
  if(t != world){
    total = t.max_health + (t.armLeft.max_health * 2) + (t.torsoLeft.max_health * 2) + t.legs.max_health;
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
vector( vector viewAngle, float idealRange, vector weaponSpread, float playerAcc ) util_applySpreadToTrace={
  //local vector direction; //shot dispersion disabled
  //local vector acc;
  local vector wepAim;
  local vector src;
  local vector adj;
  local vector targVel;
  
  targVel = '0 0 0';
  if( (self.owner.enemy.flags & FL_CLIENT) ){
    targVel = self.owner.enemy.velocity;
  }
  //weaponSpread
  if( (self.owner.flags & FL_MONSTER) ){
    if( self.w_isburst ){
      wepAim = (self.owner.enemy.origin + '0 0 10') - (targVel * self.owner.ai_leading);
    }
    else{
      if( self.owner.enemy.data_type == DATA_BLD ){
        wepAim = self.owner.enemy.hitOffset - (targVel * self.owner.ai_leading);
      }
      else{
        wepAim = (self.owner.enemy.origin + '0 0 10') - (targVel * self.owner.ai_leading);
      }
    }
    wepAim = normalize(wepAim - self.origin);
  }
  else{
    wepAim = normalize( self.owner.laser_sight_org - self.origin ); 
  }
 
  makevectors( viewAngle );
  
  adj = self.compOffset + self.wepFireOffset;
  src = self.owner.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);  
  
  //08-2020: shot dispersion has been disabled because I can't find a clean/lightweight
  //means of sending this information over the network
  
  //acc = weaponSpread;
  //acc_x = acc_x * playerAcc;
  //acc_y = acc_y * playerAcc;
  
  //acc_x = acc_x * crandom();
  //acc_y = acc_y * crandom();
  //direction = wepAim + (acc_x * v_right) + (acc_y * v_up);
  
  traceline (src, src + wepAim*idealRange, FALSE, self);
  
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

void(entity ent, vector pnt) util_chekPointToHitDir={
  local float hitAngle, sideAngle;
  local vector normVec;

  
  makevectors(ent.v_angle);
  normVec = normalize(pnt - ent.origin);
  hitAngle = normVec * v_forward;
  sideAngle = normVec * v_right;

  /*
    Direction Table
    normVec * v_forward
      Front = 1.0
      Back = -1.0
      
    normVec * v_right;
      Left = -1.0
      Right = 1.0
  */
  //check for side hits
  if( (hitAngle <= 0.7) && (hitAngle > -0.7) ){
    if( sideAngle < 0 ){
      ent.hitdir_buffer = ent.hitdir_buffer | STAT_HIT_LF; 
    }
    else{
      ent.hitdir_buffer = ent.hitdir_buffer | STAT_HIT_RT;
    }
  }
  else if( hitAngle < -0.75 ){
    ent.hitdir_buffer = ent.hitdir_buffer | STAT_HIT_BK;
  }
 
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
  call stack scope = self;
*/
void(float dmgMode, float solid_type, float move_type) util_setCollider={
  self.takedamage = dmgMode;
  self.solid = solid_type;
  self.movetype = move_type;
};

/*
  call stack scope = self;
*/
void(float hp, float max_hp, float arm_type, float arm_val) util_setHealthArmor={
  self.health = hp;
  self.max_health = max_hp;
  self.armortype = arm_type;
  self.armorvalue = arm_val;
  self.max_armor = arm_val;
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
        util_setModel("q3mdl/map/plats/plat_small.obj", 0, 0) ;
        break;
      case 2:
        util_setModel("q3mdl/map/plats/plat_medium.obj", 0, 0) ;
        break;
      case 3:
        util_setModel("q3mdl/map/plats/plat_large.obj", 0, 0);
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
  bprint(strcat(msg,":", ftos(val)," \n"));
};
void(string msg, vector v1) cons_logAVector={
  bprint(strcat(msg,":", vtos(v1),"\n"));
};
void(string msg, string s1) cons_logAString={
  bprint(strcat(msg,":", s1,"\n"));
};

void(string msg, float val, string split, float val2) cons_log2Float={
  bprint(strcat(msg,":", ftos(val),"| ", split,":", ftos(val2),"\n"));
};
void(string msg, vector v1, string split, vector v2) cons_log2Vectors={
  bprint(strcat(msg,":", vtos(v1),"| ", split,":", vtos(v2),"\n"));
};
void(string msg, string s1, string split, string s2) cons_log2Strings={
  bprint(strcat(msg," : ",s1," | ", split," : ",s2,"\n"));
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
  setmodel(self, "q3mdl/testball.md3");
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
