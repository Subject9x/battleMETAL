/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rocket Launcher projetile 
    Explodes on touch
*/

#ifndef CSQC
void() data_projectile_ini_quantum_bit_touch_;

#endif CSQC
void() data_projectile_ini_quantum_bit_={
  self.classname = "missile";
  self.data_velocity = 275;
  self.data_lifetime = 4;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_qrfl.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_QRFL_QBIT_TRAIL");
    self.damageType = self.damageType | EFF_SHD;      
  #endif
  
  #ifndef CSQC
    self.touch = data_projectile_ini_quantum_bit_touch_;
    self.think = SUB_Remove;
  #endif
};
#ifndef CSQC
void() data_projectile_ini_quantum_bit_touch_={
	if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID){
    self.traileffectnum = 0;
    remove(self);
		return;
	}
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      client_send_particle( particleeffectnum("TE_QRFL_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    }
    self.traileffectnum = 0;
    remove(self);
    return;
  }  
  
  client_send_particle( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, self.velocity, 1);
    self.traileffectnum = 0;
  remove(self);
};
#endif CSQC