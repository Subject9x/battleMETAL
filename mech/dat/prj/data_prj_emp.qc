/*
mech mod
Author: Subject9x
Date: 9/3/2016
  weapo definition file
  WEAPON: EMP Cannon
  ROLE: Indirect effect
  DESC: low rof, inhibits movement
*/

void() prj_emp_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    remove(self);
    return;
  }
  
  if(other == self.owner){
    return;
  }
  
  if(other.owner == self.owner){
    return;
  }
  
  if(other.classname == "spike"){
    return;
  }
  
  t_damage(other, self, self.owner, 5, 0, self.origin, '0 0 0');
  remove(self);
};


void() prj_emp_ini={
  local entity oself, prj;
  
  oself = self;
  prj = spawn();
  self = prj;
  self.classname = "data";
  self.data_type = DATA_PROJ;
  self.data_idx = 1;
  self.p_velocity = 800;
  self.c_model = "q3mdl/proj_emp.md3";
  self.p_lifetime = 6;
  self.p_damage = 0;
  self.p_dmgtype = 0;
  self.touch = prj_emp_touch;
  self = oself;
};