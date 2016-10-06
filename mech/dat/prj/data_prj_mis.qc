/*
mech mod
Author: Subject9x
Date: 10/04/2016
  weapo definition file
  WEAPON: prototype missile launcher
  ROLE: AoE
  DESC: still feeling out what we need for missiles, so for now, this
  is just a stock missile option.
*/

void() prj_mis_touch={
	
  if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    BecomeExplosion();
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
  
  BecomeExplosion ();
};


void() prj_mis_ini={
  local entity oself, prj;
  
  oself = self;
  prj = spawn();
  self = prj;
  self.classname = "data";
  self.data_type = DATA_PROJ;
  self.data_idx = 2;
  self.p_velocity = 900;
  self.c_model = "q3mdl/proj_mis.md3";
  self.p_lifetime = 4;
  self.p_damage = 0;
  self.p_dmgtype = 0;
  self.touch = prj_mis_touch;
  
  //cosmetics
  self.effects = 0;
  self.modelflags = MF_ROCKET;
  self.alpha = 1;
  self.colormod = '0 0 0';
  self.glow_color = 0;
  self.glow_size = 0;
  self.glow_trail = FALSE;
  
  self = oself;
};