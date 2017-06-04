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
void(entity ent, float changed) send_building;

void(entity ent, float changed) send_building={
  WriteByte(MSG_ENTITY, 4);
  WriteByte( MSG_ENTITY, self.data_idx);
  WriteByte( MSG_ENTITY, self.p_class);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteCoord( MSG_ENTITY, self.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.origin_z ); // Position Z
  WriteAngle( MSG_ENTITY, self.angles_x);
  WriteAngle( MSG_ENTITY, self.angles_y);
  WriteAngle( MSG_ENTITY, self.angles_z);
  return TRUE;
};

void() building_think={

  self.think = building_think;
  self.nextthink = time + 1;
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