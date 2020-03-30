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
void() data_projectile_quantum_bit_th;
#endif CSQC

#ifdef CSQC
void() projectile_qbit_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  local float hitDebris;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_QRFL_IMPACT_SHIELD"), self.origin, normalize(self.origin - self.origin1) * 2, 1);
    pointsound( self.origin, "sound/fx_shieldhit.ogg", 0.6, ATTN_NORM );
  }
  else if( self.impactType == IMPACT_ARMOR ){
    pointparticles( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, normalize(self.origin - self.origin1) * 2, 1);
  }
};
#endif

void() data_projectile_ini_quantum_bit_={
  self.classname = "missile";
  self.data_velocity = 275;
  self.data_lifetime = 3;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_qrfl.md3";
    self.effects = EF_NOSHADOW;
    self.traileffectnum = particleeffectnum("TE_QRFL_QBIT_TRAIL");
    self.damageType = self.damageType | EFF_SHD;
    self.pcl_explode = projectile_qbit_expl;
    self.predraw_projectile = predraw_qbit;
  #endif
  
  #ifndef CSQC
    self.touch = data_projectile_ini_quantum_bit_touch_;
    self.think = data_projectile_quantum_bit_th;
  #endif
};

#ifndef CSQC
void() data_projectile_quantum_bit_th={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.think = SUB_Remove;
  if( time < self.data_lifetime ){
    self.think = data_projectile_quantum_bit_th;
  }
  self.nextthink = time + 0.05;
}

void() data_projectile_ini_quantum_bit_touch_={
  local float damage, hit;
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE | SENDFLAG_IMPACT;
  self.impactType = IMPACT_DIRT;
	if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID){
    self.impactType = IMPACT_SKY;
	}
  
  if(other.takedamage){
    damage = self.damageValue;
    if(other.shield > 0){
      if( other.shield  > (other.shieldMax * 0.75) ){
        damage = damage * 0.33;
        hit = self.damageValue - damage;
      }
      if( other.shield  > (other.shieldMax * 0.5) ){
        damage = damage * 0.67;
        hit = self.damageValue - damage;
      }
      else{
        hit = 0;
      }
      t_damage_shield(other, self, self.owner, damage, self.origin, '0 0 0');
      t_damage(other, self, self.owner, hit, self.origin, '0 0 0');
      self.impactType = IMPACT_SHIELD;
    }
    else{
      damage = damage * 0.67;
      t_damage(other, self, self.owner, damage, self.origin, '0 0 0');
      self.impactType = IMPACT_ARMOR;
    }
  }  
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};
#endif CSQC