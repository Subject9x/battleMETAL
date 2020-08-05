/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced vehicles.
*/


void( float dataID ) data_sync_new_vehicle={
  switch(dataID){
    case UID_VEHICLE_foslager:
      data_vehicle_foslager();
      break;
      
    case UID_VEHICLE_trowel:
      data_vehicle_trowel();
      break;
      
    case UID_VEHICLE_onnek:
      data_vehicle_onnek();
      break;
      
    case UID_VEHICLE_sorcerer:
      data_vehicle_sorcerer();
      break;
      
    case UID_VEHICLE_dunerunner:
      data_vehicle_dunerunner();
      break;
  }
};

void() data_vehicle_foslager = {
  
  data_ini_foslager_();
  setmodel(self, self.model);
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
  
};

void() data_vehicle_dunerunner = {
  
  data_ini_dunerunner_();
  
  setmodel(self, self.model);
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
};

void() data_vehicle_onnek = {

  data_ini_onnek_();
      
  setmodel(self, self.model);
};

void() data_vehicle_sorcerer = {
  
  data_ini_sorcerer_();
      
  setmodel(self, self.model);

};

void() data_vehicle_trowel = {

  data_ini_trowel_();
  
  setmodel(self, self.model);
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
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
  shell.colormod = '0.33 0.33 0.33';
  shell.vec_size = self.vec_size;
  
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
