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


void( entity e ) data_sync_new_debris={
  
  e.effects = e.effects | EF_NOSHADOW;
  switch( e.vec_size ){
    case 2:
      setmodel(e, "q3mdl/fx/debris2/mdl_debris_2.md3");
      e.traileffectnum  = particleeffectnum("TE_DEBRIS_TRAIL_MED");
      break;
    case 3:
      setmodel(e, "q3mdl/fx/debris3/mdl_debris_3.md3");
      e.traileffectnum  = particleeffectnum("TE_DEBRIS_TRAIL_BIG");
      break;
    default:
      setmodel(e, "q3mdl/fx/debris1/mdl_debris_1.md3");
      e.traileffectnum  = particleeffectnum("TE_DEBRIS_TRAIL_SMALL");
      break;
  }
  self.angles = vectoangles(self.velocity);
  self.avelocity_x = random()*525;
  self.avelocity_y = random()*525;
  self.avelocity_z = random()*525;
  self.predraw_projectile = predraw_debris;
  
};
void() predraw_missile={

  interpolate_origin();
  interpolate_angle();
  
  traceline(self.origin, client_vis_org, FALSE, self);
  
  if(trace_fraction != 1.0 ){
    return;
  }
  
  if( vlen(self.origin - client_vis_org) > PARTICLE_HAZ_DISTANCE){
    return;
  }
  
  if( self.deadflag == DEAD_DEAD){
    return;
  }
  
  if( self.predraw_projectile ){
    self.predraw_projectile();
  }
  
  setmodel(self, self.model);
  addentity(self);
};

void() predraw_plasma={
  //local float tScale;
  if( self.impactType == IMPACT_ARMOR ){
    self.alpha = 0.33;
    self.scale = 0.33;
  }
  else{
    self.scale = 1.75;
    //tScale = self.scale;
    //self.scale = tScale + ((tScale + 0.005) - tScale)*self.lerpfrac;
    //self.alpha = self.alpha + ((self.alpha - 0.005) - self.alpha)*self.lerpfrac;
  }
};


void() predraw_quantum={
  self.scale = max(0.5, random() * 1.25);
  self.alpha = max(0.33, random() * 1);
  self.colormod_x = max(0.1, random() * 1);
  self.colormod_y = max(0.1, random() * 1);
  self.colormod_z = max(0.1, random() * 1);
};

void() predraw_debris={
  self.angles_x = self.angles_x + ( (random() * 0.5) * self.lerpfrac);
  self.angles_y = self.angles_y + ( (random() * 0.5) * self.lerpfrac);
  self.angles_z = self.angles_z + ( (random() * 0.5) * self.lerpfrac);
};