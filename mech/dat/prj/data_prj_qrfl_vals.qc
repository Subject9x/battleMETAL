/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: data def file for the Rotary Plasma Cannon
this guy will bounce off up to two non-targets.
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_QRFL_IDX = ID_PRJ_QRFL;
float DAT_PRJ_QRFL_VELOCITY = 200;//v0.0.3
string DAT_PRJ_QRFL_MODEL = "progs/casing.mdl";
float DAT_PRJ_QRFL_LIFETIME = 4;
float DAT_PRJ_QRFL_DAMAGE = 35;  //v0.0.3
float DAT_PRJ_QRFL_DMGTYPE = DMG_BAL;

float DAT_PRJ_QRFL_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_QRFL_MODELFLAGS = MF_TRACER3;
float DAT_PRJ_QRFL_ALPHA = 0.75;
vector DAT_PRJ_QRFL_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_QRFL_GLOWCOLOR = 255;
float DAT_PRJ_QRFL_GLOWSIZE = 0.0005;
float DAT_PRJ_QRFL_GLOWTRAIL= FALSE;

void() data_prj_qrfl;
void() data_prj_qrfl_ini;
void() data_prj_qrfl_touch;

void() data_prj_qrfl={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_QRFL_IDX;
    self.unit_ini = data_prj_qrfl_ini;
    self.p_damage = DAT_PRJ_QRFL_DAMAGE;
  self = oself;
};

void() data_prj_qrfl_ini={
  self.classname = "missile";
  self.touch = data_prj_qrfl_touch;
  self.data_idx = DAT_PRJ_QRFL_IDX;
  self.p_velocity = DAT_PRJ_QRFL_VELOCITY;
  self.c_model = DAT_PRJ_QRFL_MODEL;
  self.p_lifetime = DAT_PRJ_QRFL_LIFETIME;
  self.p_damage = DAT_PRJ_QRFL_DAMAGE;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL | EFF_STX;
  
  //cosmetics
  self.effects = self.effects + DAT_PRJ_QRFL_EFFECTS;
  self.modelflags = DAT_PRJ_QRFL_MODELFLAGS;
  self.alpha = DAT_PRJ_QRFL_ALPHA;
  self.colormod = DAT_PRJ_QRFL_COLORMOD;
  self.glow_color = DAT_PRJ_QRFL_GLOWCOLOR;
  self.glow_size = DAT_PRJ_QRFL_GLOWSIZE;
  self.glow_trail = DAT_PRJ_QRFL_GLOWTRAIL;
};

void() data_prj_qrfl_touch={
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
  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  remove(self);
};