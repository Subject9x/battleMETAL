/*
battleMETAL
Author: Peter Roohr
Date: 06/05/2019
Overview: 
	A variation on the data_system.qc found in the server code.
	This uses the same function calls and setup, but changes the implementation
	to only copy data into the target entity and that's it.
*/

/*
  These are wrapper functions, allowing the UI to send an entity over as a shallow copy.
  Entity is initialized with the target data, and returned.
*/

void( entity item, float id ) data_get_client_item_={
  local entity this;
  this = self;
  self = item;
    initialize_data_item_(id);
  self = this;
};

void( entity mech, float id ) data_get_client_mech_={
  local entity this;
  this = self;
  self = mech;
    initialize_data_mech_(id);
  self = this;
};

void( entity vehicle, float id ) data_get_client_vehicle_={
  local entity this;
  this = self;
  vehicle = spawn();
  self = vehicle;
    initialize_data_vehicle_(id);
  self = this;
};

void( entity turret, float id ) data_get_client_turret_={
  local entity this;
  this = self;
  turret = spawn();
  self = turret;
    initialize_data_turret_(id);
  self = this;
	
};

void( entity building, float id ) data_get_client_building_={
  local entity this;
  this = self;
  self = building;
	//initialize_data_build_(id);
  self = this;
};