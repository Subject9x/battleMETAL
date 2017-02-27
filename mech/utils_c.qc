/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: utility functions for mod, header
*/

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
  self.effects = fx;
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
  if(
    ((p_x >= pmin_x) &&
    (p_y >= pmin_y) &&
    (p_z >= pmin_z))
    &&
    ((p_x <= pmax_x) &&
    (p_y <= pmax_y) &&
    (p_z <= pmax_z))
  ){
    return TRUE;
  }
  else{
    return FALSE;
  }
};