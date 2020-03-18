/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced buildings.
*/

/*
  client_main.CSQC_ent_update()->Ent Type == building, SENDFLAG_NEWENT
  scope = self
  self is building
*/
void( float dataID ) data_sync_new_building={
  switch(dataID){
    case UI_BUILDING_radar:
      data_building_radar();
      break;
      
    case UI_BUILDING_shield_generator:
      data_building_shield();
      break;
      
    case UI_BUILDING_power_plant:
      data_building_power();
      break;
      
    case UI_BUILDING_hangar_large:
      data_building_hangar_large();
      break;
      
    case UI_BUILDING_fuel_tank:
      data_building_fuel();
      break;
      
    case UI_BUILDING_repair_bay:
      data_building_repair();
      break;
      
    case UI_BUILDING_hangar_med:
      data_building_hangar_med();
      break;
      
    case UI_BUILDING_guard_tower:
      data_building_guard();
      break;
  }
};

void() data_building_radar={
  self.vec_name = "Listening Post";
  self.vec_size = 1;
  setmodel(self, "q3mdl/buildings/radar/mdl_bld_h_radar.md3");
  self.max_health = 100;
  self.shield = 0;
  self.shieldMax = 150;
  self.shieldRate = 0.15;
  self.radar_range = 2000;
  self.deadflag = DEAD_NO;  
};

void() data_building_shield={
  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  setmodel(self, "q3mdl/buildings/shield_gen/mdl_bld_h_shield.md3");
  self.max_health = 500;
  self.shield = 0;
  self.shieldMax = 500;
  self.shieldRate = 0.45;
  self.energy = 0;
  self.energyRate = 0;
  self.energyMax = 2000;
  self.deadflag = DEAD_NO;  
};

void() data_building_power={
  self.vec_name = "Power Generator";
  self.vec_size = 3;
  setmodel(self, "q3mdl/buildings/power_plant/mdl_bld_h_power.md3");
  self.max_health = 1200;
  self.shield = 0;
  self.shieldMax = 300;
  self.shieldRate = 0.67;
  self.energy = 0;
  self.energyMax= 4000;
  self.energyRate= 4;
  self.deadflag = DEAD_NO;  
};

void() data_building_hangar_large={
  self.vec_name = "Large Hangar";
  self.vec_size = 3;
  setmodel(self, "q3mdl/buildings/hangar/mdl_bld_h_hangar_l.md3");
  self.max_health = 800;
  self.shield = 0;
  self.shieldMax = 300;
  self.shieldRate = 0.2;
  self.deadflag = DEAD_NO; 
};

void() data_building_fuel={
  self.vec_name = "Fuel Tank";
  self.vec_size = 2;
  setmodel(self, "q3mdl/buildings/fueltank/mdl_bld_h_fuel.md3");
  self.max_health = 75;
  self.shield = 0;
  self.shieldMax = 150;
  self.shieldRate = 0.15;
  self.deadflag = DEAD_NO; 
};

void() data_building_repair={   
  self.vec_name = "Repair Bay";
  self.vec_size = 3;
  setmodel(self, "q3mdl/buildings/repair_bay/mdl_repair_bay.md3");
  self.max_health = 600;
  self.shield = 0;
  self.shieldMax = 250;
  self.shieldRate = 0.33;
  if( cvar("skill") > SKILL_REG ){
    self.reloadValue = 750;
    self.reloadMax = 750;
    self.reloadRate = 0.4;
  }
  else{
    self.reloadValue = 1250;
    self.reloadMax = 1250;
    self.reloadRate = 0.75;
  }
  self.deadflag = DEAD_NO;
};

void() data_building_hangar_med={
  self.vec_name = "Vehicle Hangar";
  self.vec_size = 2;
  setmodel(self, "q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3");
  self.max_health = 500;
  self.shield = 0;
  self.shieldMax = 250;
  self.shieldRate = 0.2;
  self.deadflag = DEAD_NO;
};

void() data_building_guard={
  self.vec_name = "Guard Tower";
  self.vec_size = 1;
  setmodel(self, "q3mdl/buildings/towersmall/guardtower.obj");
  self.max_health = 200;
  self.shield = 0;
  self.shieldMax = 50;
  self.shieldRate = 0.1;
  self.deadflag = DEAD_NO;
};
