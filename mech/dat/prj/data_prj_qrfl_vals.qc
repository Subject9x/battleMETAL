/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for the Rotary Plasma Cannon
this guy will bounce off up to two non-targets.
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_QRFL_IDX = ID_PRJ_QRFL;

float DAT_PRJ_QRFL_DAMAGE = 35;
float DAT_PRJ_QRFL_DMGTYPE = DMG_BAL;



void() data_prj_qrfl_touch;

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