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
  self.nextthink = time + 0.001;
      
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
  
  if( self.torsoCenter ){
    makevectors(self.angles);
    data_mech_setup_part(self.torsoCenter);
  }
  
  self.skin =  self.faction - 1;
  self.data_type = DATA_VEHC;
  self.deadflag = DEAD_NO;
  self.critBits = 0;
  minc = self.mins;
  maxc = self.maxs;
  setmodel(self, self.model);
  self.takedamage = DAMAGE_AIM;
  setsize(self, minc, maxc);
  setorigin(self, self.origin);
  sendent_ini_interpolate();
  sendent_setup_weapons();
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  self.interpolate_entity = interpolate_tank;
  self.drawmask = MASK_ENGINE;
};

void() data_vehicle_wreck_predraw={
  setorigin(self, self.origin);
};

/*
  Vehicle wrecks now client-side to optimize server traffic.
*/
void() data_vehicle_wreck={
  local entity shell;
  
  makevectors(self.angles);
  shell = spawn();
  shell.angles = self.angles;
  setmodel(shell, self.model);
  setsize(shell, self.mins, self.maxs);
  setorigin(shell,  self.origin + (v_up * -2));
  shell.skin = self.skin;
  shell.solid = SOLID_CORPSE;
  shell.colormod = '0.45 0.45 0.45';
  shell.vec_size = self.vec_size;
  shell.drawmask = MASK_NORMAL;
  shell.predraw = data_vehicle_wreck_predraw;
  
  self.alpha = 0;
  self.effects = self.effects | EF_NODRAW;
  self.deadflag = DEAD_DEAD;
  if(shell.vec_size == 1){
    shell.pcl_effectnum = particleeffectnum("TE_FIRE_1");
    shell.health = servertime + 60;
  }
  else if( shell.vec_size == 2){
    shell.pcl_effectnum = particleeffectnum("TE_FIRE_2");
    shell.health = servertime + 90;
  }
  else{
    shell.pcl_effectnum = particleeffectnum("TE_FIRE_3");
    shell.health = servertime + 120;
  }
  shell.think = data_vehicle_wreck_th;
  shell.nextthink = time + (random() * 1);
};


void() data_vehicle_wreck_th={
  if( self.pcl_effectnum > 0 && servertime < self.health ){
    makevectors(self.angles);
    pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
  }
  self.think = data_vehicle_wreck_th;
  self.nextthink = time + (random() * 0.25);
};
