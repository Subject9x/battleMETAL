/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//Rocket Launcher rocket=======================
void() data_prj_mis_touch;

void() data_prj_mis_ini={
  self.classname = "missile";
  self.touch = data_prj_mis_touch;
  self.data_idx = ID_PRJ_MIS;
  self.p_velocity = DAT_PRJ_MIS_VELOCITY;
  self.c_model = DAT_PRJ_MIS_MODEL;
  self.p_lifetime = DAT_PRJ_MIS_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | EF_ADDITIVE | EF_NOSHADOW;
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
    return;
  }

  if(other == self.owner){
    BecomeExplosion();
    return;
  }
  
  if(other.owner == self.owner){
    BecomeExplosion();
    return;
  }
  
  if(other.classname == "missile"){
    return;
  }

  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  BecomeExplosion();
};