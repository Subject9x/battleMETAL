/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_SFGA_IDX = ID_PRJ_SFGA;
float DAT_PRJ_SFGA_VELOCITY = 2000;
string DAT_PRJ_SFGA_MODEL = "progs/casing.mdl";
float DAT_PRJ_SFGA_LIFETIME = 4;
float DAT_PRJ_SFGA_DAMAGE = 5;
float DAT_PRJ_SFGA_DMGTYPE = DMG_BAL;

float DAT_PRJ_SFGA_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_SFGA_MODELFLAGS = 0;
float DAT_PRJ_SFGA_ALPHA = 1;
vector DAT_PRJ_SFGA_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_SFGA_GLOWCOLOR = 240;
float DAT_PRJ_SFGA_GLOWSIZE = 0.005;
float DAT_PRJ_SFGA_GLOWTRAIL= FALSE;

void() data_prj_sfga;
void() data_prj_sfga_ini;
void() data_prj_sfga_touch;

void() data_prj_sfga={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_SFGA_IDX;
    self.unit_ini = data_prj_sfga_ini;
    self.p_damage = DAT_PRJ_SFGA_DAMAGE;
  self = oself;
};

void() data_prj_sfga_ini={
  self.classname = "missile";
  self.touch = data_prj_sfga_touch;
  self.data_idx = DAT_PRJ_SFGA_IDX;
  self.p_velocity = DAT_PRJ_SFGA_VELOCITY;
  self.c_model = DAT_PRJ_SFGA_MODEL;
  self.p_lifetime = DAT_PRJ_SFGA_LIFETIME;
  self.p_damage = DAT_PRJ_SFGA_DAMAGE;
  self.p_dmgtype = DMG_BAL;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_SFGA_EFFECTS;
  self.modelflags = DAT_PRJ_SFGA_MODELFLAGS;
  self.alpha = DAT_PRJ_SFGA_ALPHA;
  self.colormod = DAT_PRJ_SFGA_COLORMOD;
  self.glow_color = DAT_PRJ_SFGA_GLOWCOLOR;
  self.glow_size = DAT_PRJ_SFGA_GLOWSIZE;
  self.glow_trail = DAT_PRJ_SFGA_GLOWTRAIL;
};

void() data_prj_sfga_touch={
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
  
  if(other.classname == "missile"){
    return;
  }
  //te_superspike(self.origin);
  //t_filter(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  
  remove(self);
};