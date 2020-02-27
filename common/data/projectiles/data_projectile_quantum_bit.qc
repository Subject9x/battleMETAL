/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rocket Launcher projetile 
    Explodes on touch
*/

void() data_projectile_ini_quantum_bit_touch_;

void() data_projectile_ini_quantum_bit_={
  self.classname = "missile";
  self.touch = data_projectile_ini_quantum_bit_touch_;
  self.data_idx = 0;
  self.data_velocity = 275;
  self.model = "q3mdl/proj/mdl_proj_qrfl.md3";
  self.data_lifetime = 4;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_QRFL_QBIT_TRAIL");
  self.think = SUB_Remove;
  self.damageType = self.damageType | EFF_SHD;
};

void() data_projectile_ini_quantum_bit_touch_={
	if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID){
    self.traileffectnum = 0;
    remove(self);
		return;
	}
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      pointparticles( particleeffectnum("TE_QRFL_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    }
    self.traileffectnum = 0;
    remove(self);
    return;
  }  
  
  pointparticles( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, self.velocity, 1);
    self.traileffectnum = 0;
  remove(self);
};