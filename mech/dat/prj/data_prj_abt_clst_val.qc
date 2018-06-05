/*
mech Mod
Author: Peter Roohr
Date: 05/06/2018
Overview: Air-burst Torpedo cluster bomb
*/

//Air-burst Torpedo Cluster bomb=======================
void() data_prj_abt_clst_touch;

void() data_prj_abt_clst_ini={
  self.classname = "prj_rck";
  self.touch = data_prj_abt_clst_touch;
  self.data_idx = ID_PRJ_ABT_CLST;
  self.p_velocity = DAT_PRJ_ABT_CLST_VELOCITY;
  self.c_model = DAT_PRJ_ABT_CLST_MODEL;
  self.p_lifetime = DAT_PRJ_ABT_CLST_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | EF_ADDITIVE | EF_NOSHADOW;
  self.modelflags = DAT_PRJ_ABT_CLST_MODELFLAGS;
  self.alpha = DAT_PRJ_ABT_CLST_ALPHA;
  self.colormod = DAT_PRJ_ABT_CLST_COLORMOD;
  self.glow_color = DAT_PRJ_ABT_CLST_GLOWCOLOR;
  self.glow_size = DAT_PRJ_ABT_CLST_GLOWSIZE;
  self.glow_trail = DAT_PRJ_ABT_CLST_GLOWTRAIL;
};

void() data_prj_abt_clst_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

  if(other == self.owner){
    return;
  }
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  }
  BecomeExplosion();
};