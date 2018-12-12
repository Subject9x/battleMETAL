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

float( entity t, float hpMax ) util_getPieceHpForAverage{
  if( t ){
    if( hpMax ){
      return t.max_health;
    }
    return t.health;
  }
  return 0;
};

float(entity t) util_getMechHpAverage={
  if(t != world){
    local float total, cur;
    total = t.max_health;
    total = total + util_getPieceHpForAverage( t.e_arm_l, TRUE );
    total = total + util_getPieceHpForAverage( t.e_arm_r, TRUE  );
    total = total + util_getPieceHpForAverage( t.e_tor_l, TRUE  );
    total = total + util_getPieceHpForAverage( t.e_tor_r, TRUE  );
    total = total + util_getPieceHpForAverage( t.e_legs, TRUE  );
    cur = t.health;
    cur = cur + util_getPieceHpForAverage( t.e_arm_l, FALSE );
    cur = cur + util_getPieceHpForAverage( t.e_arm_r, FALSE  );
    cur = cur + util_getPieceHpForAverage( t.e_tor_l, FALSE  );
    cur = cur + util_getPieceHpForAverage( t.e_tor_r, FALSE  );
    cur = cur + util_getPieceHpForAverage( t.e_legs, FALSE  );
    total = cur / total;
    return total;
  }
  return FALSE;
};

float(entity t) util_getMechHpTotal={
  if(t != world){
    local float total, cur;
    total = t.max_health + (t.e_arm_l.max_health * 2) + (t.e_tor_l.max_health * 2) + t.e_legs.max_health;
    return total;
  }
  return FALSE;
};


float( float yee, float targAng, float buffer ) util_checkAngNotIdeal={
  local float trg_low, trg_high;
  trg_low = anglemod( targAng - buffer );
  trg_high = anglemod( targAng + buffer );
  
  if( yee < trg_low || yee > trg_high ){
    return TRUE;
  }
  return FALSE;
};

vector(vector facing, vector centerpoint, vector sz_max) util_findOpenSpawnArea={
  local vector locus, probe, destin;
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
  return  trace_endpos;
};

//scope is self = weapon making the call
vector(entity own, float range) util_traceForPlayer={
  local entity cam;
  local vector vcr;
  cam = own.e_cam;
  makevectors(own.v_angle);
  vcr = own.origin + (v_right * cam.c_ofs_x) + (v_up*cam.c_ofs_y) + (v_forward*cam.c_ofs_z);
  traceline(vcr, vcr + (v_forward * 10000), FALSE, own);
  return trace_endpos;
};

//applies 'spread' to the endpos of a previous trace
//spread values are taken as cumulatives - add all spread maximums together
vector( vector viewAngle, float idealRange, vector weaponSpread, float playerAcc ) util_applySpreadToTrace={
  local vector wepAim;
  local vector direction;
  local vector src;
  local vector acc;
  //weaponSpread
  wepAim = aim(self.owner, 100000);
  
  makevectors( viewAngle );
  
  src = self.origin + (v_forward * 4);
  src_z = self.owner.absmin_z + self.owner.size_z * 0.7;
  
  acc_x = (weaponSpread_x * playerAcc);
  acc_y = (weaponSpread_y * playerAcc);
  
  acc_x = acc_x * crandom();
  acc_y = acc_y * crandom();
  direction = wepAim + (acc_x * v_right) + (crandom()*acc_y * v_up);
    
  traceline (src, src + direction*idealRange, FALSE, self);
  
  return trace_endpos;
};

//simply returns a vector offset from an origin along a given angle
vector( vector start, vector offsets, vector viewAngle) util_getOffsetOfVector={
  local vector v;
  makevectors( viewAngle );
  v = start + (v_forward * offsets_z) + (v_up * offsets_y) +(v_right * offsets_x);
  return v;
};

vector( vector startOrigin, vector viewAngle, float wepRange, entity parent) util_traceForAI={
  local vector viewLine;
  
  makevectors( viewAngle );
  viewLine = startOrigin + (v_forward * wepRange);
  traceline( startOrigin, viewLine, FALSE, parent);
  
  return trace_endpos;
}

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
	
	makevectors (self.angles);
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
  local entity this;
  local float hit_ang;
  
  this = self;
  self = ent;
  hit_ang = util_checkPointAngleImpl(pnt);
  
  if(hit_ang == 0){
    if( (self.hitdir_buffer & STAT_HIT_LF) == FALSE ){
      self.hitdir_buffer = self.hitdir_buffer | STAT_HIT_LF;
    }
  }
  else if(hit_ang == 1){
    if( (self.hitdir_buffer & STAT_HIT_RT) == FALSE ){
      self.hitdir_buffer = self.hitdir_buffer | STAT_HIT_RT;
    }
  }
  else if(hit_ang == 2){
    if( (self.hitdir_buffer & STAT_HIT_RT) == FALSE ){
      self.hitdir_buffer = self.hitdir_buffer | STAT_HIT_RT;
    }
    if( (self.hitdir_buffer & STAT_HIT_LF) == FALSE  ){
      self.hitdir_buffer = self.hitdir_buffer | STAT_HIT_LF;
    }
  }
  self = this;
};


void(entity targ, entity src, vector ofs) util_setOffsetOrigin={
  local vector next;
  makevectors(src.angles);
  next = src.origin + (v_up * ofs_y) + (v_right * ofs_x) + (v_forward * ofs_z);
  setorigin(targ, next);
};


void(string mdl_name, float skinNum, float ef_flags) util_setModel={
  //self.model = mdl_name;
  self.effects = self.effects | ef_flags;
  setmodel(self, mdl_name);
  self.skin = skinNum;
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
  checks the normal under all 4 points of a model, if normal within 
  tolerance, return true
*/
float(entity t, float tolerance) util_cornerSlopeCheck={
  local vector start, c1,c2,c3,c4;
  local float val;
  
  val = FALSE;
  start = t.origin + (v_up * self.mins_z);
  
  makevectors(t.angles);
  c1 = start + (v_forward * self.maxs_x) + (v_right * self.maxs_y);
  c2 = start + (v_forward * self.mins_x) + (v_right * self.maxs_y);
  c3 = start + (v_forward * self.mins_x) + (v_right * self.mins_y);
  c4 = start + (v_forward * self.maxs_x) + (v_right * self.mins_y);
  
  traceline(c1, c1 + (v_up * -128), FALSE, t);
  //te_beam_laser(c1, c1 + (v_up * -128)); //DEBUG
    //cons_logAFloat("trace_plane_normal_z", trace_plane_normal_z); //DEBUG
  if( trace_plane_normal_z < tolerance){
    val = TRUE;
  }
  traceline(c2, c2 + (v_up * -128), FALSE, t);
  //te_beam_laser(c2, c2 + (v_up * -128)); //DEBUG
    //cons_logAFloat("trace_plane_normal_z", trace_plane_normal_z); //DEBUG
  if( trace_plane_normal_z < tolerance){
    val = TRUE;
  }
  traceline(c3, c3 + (v_up * -128), FALSE, t);
  //te_beam_laser(c3, c3 + (v_up * -128)); //DEBUG
    //cons_logAFloat("trace_plane_normal_z", trace_plane_normal_z); //DEBUG
  if( trace_plane_normal_z < tolerance){
    val = TRUE;
  }
  traceline(c4, c4 + (v_up * -128), FALSE, t);
  //te_beam_laser(c4, c4 + (v_up * -128)); //DEBUG
    //cons_logAFloat("trace_plane_normal_z", trace_plane_normal_z); //DEBUG
  if( trace_plane_normal_z < tolerance){
    val = TRUE;
  }
  return val;
};

void(entity t) util_generateBuildingFoundation={
  makevectors(t.angles);
  local vector v;
  local entity this, n;
  v = t.origin + (v_up * t.mins_z);
  n = spawn();
  this = self;
  self = n;
    self.classname = "map_terrain";
    if( t.vec_size == 1){
      util_setModel("q3mdl/base_small.obj", 0, 0) ;
    }
    else if( t.vec_size == 2){
      util_setModel("q3mdl/base_med.obj", 0, 0) ;
    }
    else if( t.vec_size == 3){
      util_setModel("q3mdl/base_large.obj", 0, 0);
    }
    util_setCollider(DAMAGE_NO, SOLID_BSP, MOVETYPE_NONE);
    setsize(self, self.mins, self.maxs);
    self.angles = t.angles;
    setorigin(self, v);
  self = this;
};

/*
  checks to see if a point is within bounds
*/
float(vector p, vector pmin, vector pmax) util_checkInBounds={

  local vector ok;
  ok = '0 0 0';

  if((p_x > (pmin_x - 1)) && (p_x < (pmax_x + 1))){
    ok_x = 1;
  }
  if((p_y > pmin_y - 1) && (p_y < pmax_y+1)){
    ok_y = 1;
  } 
  if((p_z > pmin_z - 1) && (p_z < pmax_z+1)){
    ok_z = 1;
  }
  
  if((ok_x==1) && (ok_y==1) &&(ok_z==1)){
    return TRUE;
  }
  else{
    return FALSE;
  }
  
};

//dont ask
void(float bits, float b, float bb, float bbb) util_subThreeBits={
  bits = bits - (bits & (b | bb | bbb) );
};
 
entity(float part, entity unit) util_getPartFromName={
  
  switch( part ){
    case M_TOR_CENTER:
      if( (unit.flags & FL_TURRET) ){
        return unit.e_tor_c;
      }
      return unit;
    case M_TOR_RIGHT:
      return unit.e_tor_r;
    case M_TOR_LEFT:
      return unit.e_tor_l;
    case M_LEGS:
      return unit.e_legs;
    case M_ARM_LEFT:
      return unit.e_arm_l;
    case M_ARM_RIGHT:
      return unit.e_arm_r;
    default:
      return unit;
  }
};

float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
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