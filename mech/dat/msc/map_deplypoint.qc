/*
mech Mod
Author: Peter Roohr
Date: 01/04/2018
Overview: data file for map deployment spots (spawn points)
*/

float(entity ent, float changed) send_deploypoint={
  WriteByte( MSG_ENTITY, E_DEP ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.data_type);
  WriteByte( MSG_ENTITY, self.data_idx);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteByte( MSG_ENTITY, self.isActive);
  WriteCoord( MSG_ENTITY, self.origin_x); // Position X
  WriteCoord( MSG_ENTITY, self.origin_y); // Position Y
  WriteCoord( MSG_ENTITY, self.origin_z); // Position Z
  return TRUE;
};

void() th_deploy={

  self.think = th_deploy;
  self.nextthink = time + 0.5;
};

/*QUAKED map_deploy_point (0.2 0.8 0.2) (-10 -10 -10) (10 10 10)
use these as the player-choosable spawn points if you desire
player-choosable
"i_faction" : bitflags for faction, only visible to that faction
"data_idx" : number, 1 - 12, MUST BE UNIQUE
"isActive" : number, allow player to spawn here
  0 = FALSE
  1 = TRUE
*/
void() map_deploy_point={
  self.classname = "data";
  self.data_type = DATA_DEPL;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.SendEntity = send_deploypoint;
  self.SendFlags = 1;
  self.think = th_deploy;
  self.nextthink = time + 0.5;
}