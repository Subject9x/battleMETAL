/*
mech Mod
Author: Peter Roohr
Date: 01/04/2018
Overview: data file for map deployment spots (spawn points)
*/

void() deploy_point_use={
  if(self.isActive){
    self.isActive = FALSE;
  }
  else{
    self.isActive = TRUE;
  }
};

void() th_deploy={
  self.think = th_deploy;
  self.nextthink = time + 0.5;
};

/*QUAKED map_deploy_point (0.2 0.8 0.2) (-10 -10 -10) (10 10 10)
use these as the player-choosable spawn points if you desire
player-choosable
"i_faction" : bitflags for faction, only visible to that faction
"data_idx" : number used for id and choosing clientside, MUST HAVE!
"isActive" : number, allow player to spawn here
  0 = FALSE
  1 = TRUE
"targetname" : hook up to triggers, use() will flip isActive
*/
void() map_deploy_point={
  self.classname = "data";
  self.data_type = DATA_DEPL;
  self.flags = self.flags | FL_NODE;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = deploy_point_use;
  self.think = th_deploy;
  self.nextthink = time + 0.5;
}