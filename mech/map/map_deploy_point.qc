/*
mech Mod
Author: Peter Roohr
Date: 01/04/2018
Overview: 
  Deploy Points are like a subset of info_player_start. They're bespoke spawn points for players.
  Deploy points can be tailored to specific i_factions, and can be activated/deactivated.

Inputs
  .i_faction = <float> - Deploy Point only appears for this faction
  .data_idx = <float> - number used for id and choosing clientside, MUST HAVE and MUST be unique across the map.
  .isActive = <float> [bool] - if active, allow players to spawn here.
  
  .trigOnSpawn = <string> [target] - map object to fire when this is created
*/

void() deploy_point_use={
  //simple light switch
  if( self.isActive ){
    self.isActive = FALSE;
    return;
  }
  self.isActive = TRUE;
};

void() th_deploy={
  self.think = th_deploy;
  self.nextthink = time + 0.5;
};

/*QUAKED map_deploy_point (0.2 0.8 0.2) (-10 -10 -10) (10 10 10)
*/
void() map_deploy_point={
  self.data_type = DATA_DEPL;
  self.flags = self.flags | FL_NODE;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = deploy_point_use;
  self.think = th_deploy;
  self.nextthink = time + 0.1;
  
  trigger_event( world, trigOnSpawn );
}