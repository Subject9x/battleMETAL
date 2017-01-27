/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_LATC_IDX = ID_PRJ_LATC;
float DAT_PRJ_LATC_VELOCITY = 2000;
string DAT_PRJ_LATC_MODEL = "progs/casing.mdl";
float DAT_PRJ_LATC_LIFETIME = 6;
float DAT_PRJ_LATC_DAMAGE = 5;
float DAT_PRJ_LATC_DMGTYPE = DMG_BAL;

float DAT_PRJ_LATC_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_LATC_MODELFLAGS = 0;
float DAT_PRJ_LATC_ALPHA = 1;
vector DAT_PRJ_LATC_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_LATC_GLOWCOLOR = 240;
float DAT_PRJ_LATC_GLOWSIZE = 0.005;
float DAT_PRJ_LATC_GLOWTRAIL= FALSE;

void() data_prj_latc;
void() data_prj_latc_ini;
void() data_prj_latc_touch;

void() data_prj_latc={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_LATC_IDX;
    self.unit_ini = data_prj_latc_ini;
  self = oself;
};

void() data_prj_latc_ini={
  self.classname = "spike";
  self.touch = data_prj_latc_touch;
  self.data_idx = DAT_PRJ_LATC_IDX;
  self.p_velocity = DAT_PRJ_LATC_VELOCITY;
  self.c_model = DAT_PRJ_LATC_MODEL;
  self.p_lifetime = DAT_PRJ_LATC_LIFETIME;
  self.p_damage = DAT_PRJ_LATC_DAMAGE;
  self.p_dmgtype = DMG_BAL;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_LATC_EFFECTS;
  self.modelflags = DAT_PRJ_LATC_MODELFLAGS;
  self.alpha = DAT_PRJ_LATC_ALPHA;
  self.colormod = DAT_PRJ_LATC_COLORMOD;
  self.glow_color = DAT_PRJ_LATC_GLOWCOLOR;
  self.glow_size = DAT_PRJ_LATC_GLOWSIZE;
  self.glow_trail = DAT_PRJ_LATC_GLOWTRAIL;
};

void() data_prj_latc_touch={
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