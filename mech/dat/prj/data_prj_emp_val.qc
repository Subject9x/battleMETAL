/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//EMP CANNON SHOT=======================
float DAT_PRJ_EMP_IDX = ID_PRJ_EMP;
float DAT_PRJ_EMP_VELOCITY = 750;
string DAT_PRJ_EMP_MODEL = "q3mdl/proj_emp.md3";
float DAT_PRJ_EMP_LIFETIME = 6;
float DAT_PRJ_EMP_DAMAGE = 25;
float DAT_PRJ_EMP_DMGTYPE = 0;  //see data_prj_emp

float DAT_PRJ_EMP_EFFECTS = 0; //see data_prj_emp
float DAT_PRJ_EMP_MODELFLAGS = MF_TRACER3;
float DAT_PRJ_EMP_ALPHA = 0.75;
vector DAT_PRJ_EMP_COLORMOD = '0.45 0.45 0.80';
float DAT_PRJ_EMP_GLOWCOLOR = 150;
float DAT_PRJ_EMP_GLOWSIZE = 0.05;
float DAT_PRJ_EMP_GLOWTRAIL= TRUE;

void() data_prj_emp;
void() data_prj_emp_ini;
void() data_prj_emp_touch;

void() data_prj_emp={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_EMP_IDX;
    self.unit_ini = data_prj_emp_ini;
  self = oself;
};

void() data_prj_emp_ini={
  self.classname = "spike";
  self.touch = data_prj_emp_touch;
  self.data_idx = DAT_PRJ_EMP_IDX;
  self.p_velocity = DAT_PRJ_EMP_VELOCITY;
  self.c_model = DAT_PRJ_EMP_MODEL;
  self.p_lifetime = DAT_PRJ_EMP_LIFETIME;
  self.p_damage = DMG_ENE | EFF_RAM;
  self.p_dmgtype = DAT_PRJ_EMP_DMGTYPE;
  
  //cosmetics
  self.effects = EF_ADDITIVE | EF_NOSHADOW;
  self.modelflags = DAT_PRJ_EMP_MODELFLAGS;
  self.alpha = DAT_PRJ_EMP_ALPHA;
  self.colormod = DAT_PRJ_EMP_COLORMOD;
  self.glow_color = DAT_PRJ_EMP_GLOWCOLOR;
  self.glow_size = DAT_PRJ_EMP_GLOWSIZE;
  self.glow_trail = DAT_PRJ_EMP_GLOWTRAIL;
};

void() data_prj_emp_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    te_superspike(self.origin);
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
  //te_superspike(self.origin);
  //t_filter(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  
  remove(self);
};