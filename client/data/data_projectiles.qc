/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced projectiles and chunks
*/

void( float dataID ) data_sync_new_projectile={
  switch(dataID){
    case UID_ITEM_emp:
      data_projectile_ini_emp_();
      break;
      
    case UID_ITEM_rocket_launcher:
      data_projectile_ini_rocket_();
      break;
      
    case UID_ITEM_rotary_plasma:
      data_projectile_ini_plasma_();
      break;
      
    case UID_ITEM_missile_laserguide:
      data_projectile_ini_missile_laserguide_();
      break;
      
    case UID_ITEM_missile_activeradar:
      data_projectile_ini_missile_active_radar_();
      break;
      
    case UID_ITEM_snub_artillery:
      data_projectile_ini_snub_artillery_();
      break;
      
    case UID_ITEM_ion_coil:
      data_projectile_ini_ion_();
      break;
      
    case UID_ITEM_missile_swarm:
      data_projectile_ini_missile_swarm_();
      break;
      
    case UID_ITEM_quantum_rifle:
      data_projectile_ini_quantum_bit_();
      break;
  }
};

float() predraw_missile={
  if( self.nextthink != self.frame1time ){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
  }
  self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);

  if( self.traileffectnum && self.origin2 != self.origin ){
    trailparticles(self, self.traileffectnum, self.origin2, self.origin);
    self.origin2 = self.origin;
  }  
  if( self.predraw_projectile ){
    self.predraw_projectile();
  }
  return TRUE;
};

float() predraw_plasma={
  if( self.impactType == IMPACT_ARMOR ){
    self.alpha = 0.33;
    self.scale = 0.33;
  }
  else{
    self.scale = self.scale + 0.075;
    self.alpha = self.alpha - 0.025;
  }
  return TRUE;
};


float() predraw_qbit={
  self.alpha = self.alpha - 0.005;
  if( self.alpha <= 0 ){
    self.alpha = 0;
    self.traileffectnum = 0;
  }
  return TRUE;
};



