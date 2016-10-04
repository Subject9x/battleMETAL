/*
mech mod
Author: Subject9x
Date: 9/1/2016
  weapo definition file
  WEAPON: Light Autocannon
  ROLE: Harassing fire
  DESC: low DPS, High RoF
*/

void() prj_latc_touch={
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
  
  
  te_superspike(self.origin);
  //t_filter(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');

  
  remove(self);
};

void() prj_latc_ini={
  local entity oself, prj;
  
  oself = self;
  prj = spawn();
  self = prj;
  self.classname = "data";
  self.touch = prj_latc_touch;
  self.data_type = DATA_PROJ;
  self.data_idx = 0;
  self.p_velocity = 2000;
  self.c_model = "progs/casing.mdl";
  self.p_lifetime = 6;
  self.p_damage = 5;
  self.p_dmgtype = 0;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.alpha = 1;
  self.colormod = '0.85 0.45 0.45';
  self.glow_color = 240;
  self.glow_size = 0.005;
  self.glow_trail = FALSE;
  
  self = oself;
};