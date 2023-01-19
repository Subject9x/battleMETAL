/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced vehicles.
*/

void( float dataID ) data_sync_new_vehicle={
  local vector minc,maxc;
  
  self.think = sendent_ai_think;
  self.nextthink = time + 0.01;
      
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(dataID){
    case UID_VEHICLE_foslager:
      data_ini_foslager_();
      break;
    case UID_VEHICLE_trowel:
      data_ini_trowel_();
      break;
    case UID_VEHICLE_onnek:
      data_ini_onnek_();
      break;
    case UID_VEHICLE_sorcerer:
      data_ini_sorcerer_();
      break;
    case UID_VEHICLE_dunerunner:
      data_ini_dunerunner_();
      break;
  }
  
  self.skin =  self.faction - 1;
  self.data_type = DATA_VEHC;
  self.deadflag = DEAD_NO;
  self.critBits = 0;
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;
  setmodel(self, self.legs_mdl);
  setsize(self, self.cache_mins, self.cache_maxs);
  self.origin = self.origin;
  
  self.takedamage = DAMAGE_AIM;
  sendent_ini_interpolate();
  self.interpolate_entity = interpolate_tank;
};

void() data_vehicle_wreck_predraw={

  self.colormod = '0.45 0.45 0.45';
  setmodel(self, self.legs_mdl);
  setsize(self, self.cache_mins, self.cache_maxs);
  self.origin = self.cacheGroundPos;
  self.angles = self.cacheGroundAngle;
  addentity(self);
  
};

/*
  Vehicle wrecks now client-side to optimize server traffic.
*/
void() data_vehicle_wreck={  
  self.colormod = '0.45 0.45 0.45';
  self.predraw = data_vehicle_wreck_predraw;
  
  switch(self.vec_size){
    default:
      self.pcl_effectnum = particleeffectnum("TE_FIRE_1");
      self.data_lifetime = servertime + 60;
      break;
    case 2:
      self.pcl_effectnum = particleeffectnum("TE_FIRE_2");
      self.data_lifetime = servertime + 90;
      break;
    case 3:
      self.pcl_effectnum = particleeffectnum("TE_FIRE_3");
      self.data_lifetime = servertime + 120;
      break;
  }
  self.think = data_vehicle_wreck_th;
  self.nextthink = time + 0.01;
};


void() data_vehicle_wreck_th={
  if( self.pcl_effectnum > 0 && servertime < self.health && vlen(self.origin - CLIENT_vis_org) < PARTICLE_HAZ_DISTANCE / 2 ){
    makevectors(self.angles);
    pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
  }
  self.think = data_vehicle_wreck_th;
  self.nextthink = time + random() * 0.5;
};
