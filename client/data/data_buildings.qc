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
  setsize(self, '-20 -20 0', '20 20 26');
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
  setsize(self,  '-48 -48 0', '48 48 32');
  self.max_health = 500;
  self.shield = 0;
  self.shieldMax = 500;
  self.shieldRate = 0.45;
  self.energy = 0;
  self.energyRate = 0;
  self.energyMax = 2000;
  self.deadflag = DEAD_NO;
  self.th_die = shield_gen_die1;
  self.th_walk = shield_gen_active;
  //local vfx
  self.compOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * self.mins_x) + (v_forward * self.mins_y);
  self.compAltOffset = self.origin + (v_up * self.maxs_z) + (v_right * (self.mins_x * 0.15)) + (v_forward * (self.mins_y * 0.15));
};

void() data_building_power={
  self.vec_name = "Power Generator";
  self.vec_size = 3;
  setmodel(self, "q3mdl/buildings/power_plant/mdl_bld_h_power.md3");
  setsize(self, '-80 -80 0', '80 80 58');
  self.max_health = 1200;
  self.shield = 0;
  self.shieldMax = 300;
  self.energy = 0;
  self.energyMax = 4000;
  self.deadflag = DEAD_NO; 
  self.th_die = power_plant_die1;
  self.th_walk = power_plant_active;
  //local vfx - green ball
  self.compOffset = self.origin + (v_up * (self.maxs_z * 0.8)) + (v_right * self.mins_x * 0.85) + (v_forward * (self.mins_y * 0.65));
  self.compAltOffset = self.origin + (v_up * (self.maxs_z * 0.85)) + (v_right * (self.mins_x * 0.67)) + (v_forward * (self.mins_y * 0.45));
  //local vfx - blue vent front
  self.wepFireOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * 0) + (v_forward * self.maxs_y * 0.9);
  self.wepFireOffsetCache = self.origin + (v_up * (self.maxs_z * 0.45)) + (v_right * (self.maxs_x * 0.25)) + (v_forward * self.maxs_y * 0.9);
  //local vfx - blue vent front
  self.cockpitOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * 0) + (v_forward * self.mins_y * 0.9);
  self.w_adj_ang = self.origin + (v_up * (self.maxs_z * 0.45)) + (v_right * (self.maxs_x * 0.25)) + (v_forward * self.mins_y * 0.9);
};

void() data_building_hangar_large={
  self.vec_name = "Large Hangar";
  self.vec_size = 3;
  setmodel(self, "q3mdl/buildings/hangar/mdl_bld_h_hangar_l.md3");
  setsize(self, '-68 -84 0', '68 84 88');
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
  setsize(self, '-40 -40 0', '40 40 64');
  self.max_health = 75;
  self.shield = 0;
  self.shieldMax = 150;
  self.shieldRate = 0.15;
  self.deadflag = DEAD_NO; 
  self.th_die = fuel_tank_die1;
};

void() data_building_repair={   
  self.vec_name = "Repair Bay";
  self.vec_size = 3;
  setmodel(self, "q3mdl/buildings/repair_bay/mdl_repair_bay.md3");
  setsize(self, '-53 -53 0', '53 53 80');
  self.max_health = 600;
  self.shieldMax = 250;
  self.shieldRate = 0.33;
  self.deadflag = DEAD_NO;
  self.th_walk = repair_bay_active;
  self.th_die = repair_bay_die1;
  self.render_dlights = repair_bay_dlights;
  self.w_firetime = 0;
  self.compOffset = self.origin + (v_up * 75) + (v_forward * -24);
  self.compAltOffset = self.origin;
};

void() data_building_hangar_med={
  self.vec_name = "Vehicle Hangar";
  self.vec_size = 2;
  setmodel(self, "q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3");
  setsize(self, '-72 -72 0', '72 72 48');
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
  setsize(self, '-22 -22 0', '22 22 40');
  self.max_health = 200;
  self.shield = 0;
  self.shieldMax = 50;
  self.shieldRate = 0.1;
  self.deadflag = DEAD_NO;
};

/*
  ANIMATION - Death
*/
void() data_building_death1={
  
  if( self.frame > 12 ){
    self.think = sendevent_building_die;
    self.nextthink = time + 0.1;
    return;
  }
  
  te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  
  self.frame = self.frame + 1;
  self.think = data_building_death2;
  self.nextthink = time + 0.1;
};

void() data_building_death2={ 
  if( self.frame > 12 ){
    self.think = sendevent_building_die;
    self.nextthink = time + 0.1;
    return;
  }

  self.frame = self.frame + 1;
  self.think = data_building_death1;
  self.nextthink = time + 0.1;
};

void() data_building_death_end={
};



