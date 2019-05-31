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
  self.classname = "prj_qrfl";
  self.touch = data_projectile_ini_quantum_bit_touch_;
  self.data_idx = 0;
  self.p_velocity = 200;
  self.model = "q3mdl/proj/mdl_proj_qrfl.md3";
  self.p_lifetime = 4;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_QRFL_QBIT_TRAIL");
  self.think = SUB_Remove;
};

void() data_projectile_ini_quantum_bit_touch_={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.sh_cur > 0 ){
      pointparticles( particleeffectnum("TE_QRFL_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    }
    remove(self);
    return;
  }  
  
  pointparticles( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, self.velocity, 1);
  remove(self);
};