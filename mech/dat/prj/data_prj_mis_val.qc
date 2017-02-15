/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//MIS CANNON SHOT=======================
float DAT_PRJ_MIS_IDX = ID_PRJ_MIS;
float DAT_PRJ_MIS_VELOCITY = 1200;
string DAT_PRJ_MIS_MODEL = "q3mdl/proj_mis.md3";
float DAT_PRJ_MIS_LIFETIME = 1;
float DAT_PRJ_MIS_DAMAGE = 20;
float DAT_PRJ_MIS_DMGTYPE = DMG_EXP;

float DAT_PRJ_MIS_EFFECTS = 0; //see data_prj_MIS
float DAT_PRJ_MIS_MODELFLAGS = MF_ROCKET;
float DAT_PRJ_MIS_ALPHA = 1;
vector DAT_PRJ_MIS_COLORMOD = '0 0 0';
float DAT_PRJ_MIS_GLOWCOLOR = 0;
float DAT_PRJ_MIS_GLOWSIZE = 0;
float DAT_PRJ_MIS_GLOWTRAIL= FALSE;

void() data_prj_mis;
void() data_prj_mis_ini;
void() data_prj_mis_touch;

void() data_prj_mis={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_MIS_IDX;
    self.unit_ini = data_prj_mis_ini;
  self = oself;
};

void() data_prj_mis_ini={
  self.classname = "spike";
  self.touch = data_prj_mis_touch;
  self.data_idx = DAT_PRJ_MIS_IDX;
  self.p_velocity = DAT_PRJ_MIS_VELOCITY;
  self.c_model = DAT_PRJ_MIS_MODEL;
  self.p_lifetime = DAT_PRJ_MIS_LIFETIME;
  self.p_damage = DAT_PRJ_MIS_DAMAGE;
  self.p_dmgtype = DMG_EXP;
  //cosmetics
  self.effects = EF_ADDITIVE + EF_NOSHADOW;
  self.modelflags = DAT_PRJ_MIS_MODELFLAGS;
  self.alpha = DAT_PRJ_MIS_ALPHA;
  self.colormod = DAT_PRJ_MIS_COLORMOD;
  self.glow_color = DAT_PRJ_MIS_GLOWCOLOR;
  self.glow_size = DAT_PRJ_MIS_GLOWSIZE;
  self.glow_trail = DAT_PRJ_MIS_GLOWTRAIL;
};

void() data_prj_mis_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    BecomeExplosion();
    //remove(self);
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

  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  BecomeExplosion();
  //remove(self);
};