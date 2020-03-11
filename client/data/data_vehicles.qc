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

  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
  
};

void() data_vehicle_dunerunner = {
  
  data_ini_dunerunner_();
  
  setmodel(self, self.model);

  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
};

void() data_vehicle_onnek = {

  data_ini_onnek_();
      
  setmodel(self, self.model);
};

void() data_vehicle_sorcerer = {
  local vector offset;
  
  data_ini_sorcerer_();
      
  setmodel(self, self.model);

};

void() data_vehicle_trowel = {

  data_ini_trowel_();
  
  setmodel(self, self.model);

  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, "q3mdl/buildings/turret_heavy/mdl_turret_heavy_turret.obj");

  makevectors(self.angles);
  self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
};