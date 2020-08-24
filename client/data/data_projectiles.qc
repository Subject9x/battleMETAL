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
  if( wasfreed(self) ){
    return FALSE;
  }
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
  return FALSE;
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
  return FALSE;
};

float() predraw_marh={
  local entity cluster;
  cluster = self.w_slot;
  makevectors(self.angles);
  while( cluster != world ){
    cluster.origin = self.origin + (v_forward * cluster.compOffset_z) + (v_right * cluster.compOffset_x) + (v_up * cluster.compOffset_y);
    if(cluster.traileffectnum != 0 && cluster.origin2 ){
      trailparticles(cluster, self.traileffectnum, cluster.origin2, cluster.origin);
    }
    cluster.origin2 = cluster.origin;
    cluster.scale = 0.9;
    cluster = cluster.w_slot;
  }
  return FALSE;
};


float() predraw_quantum={
  self.scale = max(0.5, random() * 1.25);
  self.alpha = max(0.33, random() * 1);
  self.colormod_x = max(0.1, random() * 1);
  self.colormod_y = max(0.1, random() * 1);
  self.colormod_z = max(0.1, random() * 1);
  return TRUE;
};