/*
mech Mod
Author: Subject9x
Date: 8/27/2016
      mod 3/16/2017
Overview: utility functions for mod, header
*/

void(float mod, float targ_val) util_zeroStat={

  targ_val = targ_val - mod;
  if(targ_val < 0){
    targ_val = 0;
  }
 
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
  self.c_model = mdl_name;
  self.effects = self.effects | fx;
  setmodel(self, self.c_model);
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

  if((p_x > pmin_x-1) && (p_x < pmax_x+1)){
    ok_x = 1;
  }
  if((p_y > pmin_y-1) && (p_y < pmax_y+1)){
    ok_y = 1;
  } 
  if((p_z > pmin_z-1) && (p_z < pmax_z+1)){
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
  if((bits & b)){
    bits = bits - (bits & b);
  }
  if((bits & bb)){
    bits = bits - (bits & bb);
  }
  if((bits & bbb)){
    bits = bits - (bits & bbb);
  }
};