/*
mech Mod
Author: Subject9x
Date: 03/25/2017
Overview: data file for map objectives
*/

float(entity ent, float changed) send_objective={
  WriteByte( MSG_ENTITY, E_OBJ ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.nav_name);
  return TRUE;
};

/*QUAKED map_objective (0.99 0.8 0) (-10 -10 -10) (10 10 10)
"nav_name" : float, must match a number in the msn_file
"isActive" : float, does this start active?
"target"   : string, target another ent, usually a counter
*/
void() map_objective={
  //self.obj_status = 1;
  //self.controllingFaction = 0;
  //self.isActive = TRUE;
  //self.navId = 1;
  //self.nav_name = "Alpha";
  //self.classname = "map_navpoint";
  self.classname = "data";
  self.data_type = DATA_OBJT;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.data_idx = self.nav_name;
  self.SendEntity = send_objective;
  self.SendFlags = 1;
}