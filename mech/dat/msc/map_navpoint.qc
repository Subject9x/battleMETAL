/*
mech Mod
Author: Subject9x
Date: 03/25/2017
Overview: data file for map nav points
*/

.float obj_status;
.float controllingFaction;
.float isActive;
.float nav_name;

void() nav_point_th;
float(entity ent, float changed) send_navpoint;

float(entity ent, float changed) send_navpoint={
  WriteByte( MSG_ENTITY, E_NAV ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.nav_name);
  WriteByte( MSG_ENTITY, self.isActive);
  WriteCoord( MSG_ENTITY, self.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.origin_z ); // Position Z
  return TRUE;
};

/*QUAKED map_navpoint (0.2 0.8 0.2) (-10 -10 -10 ) (10 10 10)
isActive = 0 / 1
i_faction = only is if faction matching
nav_name = int, 1 - 12, MUST BE UNIQUE
isActive = allow player to spawn here
  0 = FALSE
  1 = TRUE
*/
void() map_navpoint={
  self.classname = "data";
  self.data_type = DATA_NAVP;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.data_idx = self.nav_name;
  self.SendEntity = send_navpoint;
  self.SendFlags = 1;
}

void() nav_point_th={
  

  self.think = nav_point_th;
  self.nextthink = time + 0.05;
};