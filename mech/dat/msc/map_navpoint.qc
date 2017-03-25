/*
mech Mod
Author: Subject9x
Date: 03/25/2017
Overview: data file for map nav points
*/

.float obj_status;
.float controllingFaction;
.float isActive;
.float navId;
.string nav_name;


void() nav_point_th;

/*QUAKED map_navpoint (.1 .1 .1) (-1 -1 -1 ) (1 1 1) 
*/
void() map_navpoint={

  //self.obj_status = 1;
  //self.controllingFaction = 0;
  //self.isActive = TRUE;
  //self.navId = 1;
  //self.nav_name = "Alpha";
  //self.classname = "map_navpoint";
  setorigin(self, '0 0 0');
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
}

void() nav_point_th={
  

  self.think = nav_point_th;
  self.nextthink = time + 0.05;
};