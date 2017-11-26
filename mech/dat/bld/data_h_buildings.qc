/*
mech Mod
Author: Subject9x
Date: 01/26/2017
Overview: ini funcs for human building data;
*/

void() data_h_power;
void() data_h_radar;
void() data_h_shield;
void() data_h_hangar_l;
void() data_h_fuel;

void() building_think={
  

  self.think = building_think;
  self.nextthink = time + 0.05;
};

void() data_h_power={
  local entity oself, bld;
  bld = spawn();
  oself = self;
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_POWER;
    self.data_type = DATA_BLD;
    self.vec_name = "Shield Generator";
  self = oself;
};

void() data_h_radar={
  local entity oself, bld;
  bld = spawn();
  oself = self;
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_RADAR;
    self.data_type = DATA_BLD;
    self.vec_name = "Listening Post";
  self = oself;
};
void() data_h_shield={
  local entity oself, bld;
  bld = spawn();
  oself = self;
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_SHIELD;
    self.data_type = DATA_BLD;
    self.vec_name = "Shield Generator";
  self = oself;
};

void() data_h_hangar_l={
  local entity oself, bld;
  bld = spawn();
  oself = self;
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_FUEL;
    self.data_type = DATA_BLD;
    self.vec_name = "Fuel Tank";
  self = oself;
};

void() data_h_fuel={
  local entity oself, bld;
  bld = spawn();
  oself = self;
  self = bld;
    self.classname = "data";
    self.data_idx = ID_BLD_H_FUEL;
    self.data_type = DATA_BLD;
    self.vec_name = "Fuel Tank";
  self = oself;
};

void() building_die={
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  multi_trigger();
  self.nextthink = time + 0.01;
  self.think =  SUB_Remove;
};