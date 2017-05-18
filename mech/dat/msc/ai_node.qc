/*
mech Mod
Author: Subject9x
Date:05/17/2017
Overview: ai node used by the AI system
*/

/*QUAKED ai_node (.1 .1 .1) (-5 -5 -5 ) (5 5 5) 
*/
void() ai_node={
  //self.obj_status = 1;
  //self.controllingFaction = 0;
  //self.isActive = TRUE;
  //self.navId = 1;
  //self.nav_name = "Alpha";
  self.classname = "data";
  self.data_type = DATA_NODE;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
}