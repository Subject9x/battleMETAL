/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
      mod 3/16/2017
      mod 5/17/2017 - normalize time as percent
      mod 2/18/2018
Overview: utility functions for mod
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

float(entity t) util_getMechHpAverage={
  local float total, cur;
  total = t.max_health + (t.e_arm_l.max_health * 2) + (t.e_tor_l.max_health * 2) + t.e_legs.max_health;
  cur = t.health + t.e_arm_r.health + t.e_arm_l.health + t.e_tor_r.health + t.e_tor_l.health + t.e_legs.health;
  total = floor(cur / total);
  return total;
};

vector(vector rgb) util_rgbToFloat={
  local vector nu;
  nu_x = rgb_x/255;
  nu_y = rgb_y/255;
  nu_z = rgb_z/255;
  return nu;
};

float(float t, float e) util_normalizeTimeAsPercent={
  return t / e;
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
  traceline(vcr, vcr + (v_forward* self.w_range), FALSE, own);
  return trace_endpos;
};

//scope is self = weapon making the call
vector(entity own, entity ofsent, vector prev_tracend, float spreadx, float spready) util_traceForOffset={
  local vector adj, org, end;
  adj = ofsent.c_ofs + ofsent.w_fire_ofs + ofsent.c_alt_ofs;
  makevectors(own.v_angle);
  org = own.origin + ( v_up * adj_y ) + ( v_right * adj_x ) + ( v_forward * own.e_cam.c_ofs_z );
  ofsent.fx_origin = org;
  end = prev_tracend + ((crandom() * spreadx) * v_right) + (v_up * (crandom() * spready)) + (v_forward*2);
  makevectors(self.angles);
  traceline(org, end, FALSE, own);
  return (trace_endpos + ( v_forward* 1 ) );
}; 

float(float mod, float targ_val) util_zeroStat={
  targ_val = targ_val - mod;
  if(targ_val < 0){
    targ_val = 0;
  }
  return targ_val;
};

//inspired by original inFront function
float(entity trg) util_checkPointAngle={
  
	local vector	vec;
	local float		f_dot, s_dot;
	
	makevectors (self.angles);
	vec = normalize (trg.origin - self.origin);
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

void(entity targ, entity src, vector ofs) util_setOffsetOrigin={
  local vector next;
  makevectors(src.angles);
  next = src.origin + ((v_up*ofs_y)+(v_right*ofs_x)+(v_forward*ofs_z));
  setorigin(targ, next);
};


void(string mdl_name, float fx) util_setModel={
  self.model = mdl_name;
  self.effects = self.effects | fx;
  setmodel(self, self.model);
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
  call stack scope = self;
*/
void(vector bbx_min, vector bbx_max) util_setBoundBox={
  self.c_bbx_n = bbx_min;
  self.c_bbx_x = bbx_max;
  setsize(self, bbx_min, bbx_max);
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
 
entity(string part, entity unit) util_getPartFromName={
  if(part == M_TOR_RIGHT){
    return unit.e_tor_r;
  }
  else if(part == M_TOR_LEFT){
    return unit.e_tor_l;
  }
  else if(part == M_LEGS){
    return unit.e_legs;
  }
  else if(part == M_ARM_LEFT){
    return unit.e_arm_l;
  }
  else if(part == M_ARM_RIGHT){
    return unit.e_arm_r;
  }
  else{
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
  bprint(strcat(msg,":",s1,"| ", split,":",s2,"\n"));
};