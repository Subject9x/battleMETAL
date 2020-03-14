/*
battleMETAL
Author: Peter Roohr
Date: 01/04/2018
Overview: 
  Deploy Points are like a subset of info_player_start. They're bespoke spawn points for players.
  Deploy points can be tailored to specific i_factions, and can be activated/deactivated.

*/


void() deploy_point_use={
  if( self.isActive ){
    self.isActive = FALSE;
    return;
  }
  self.isActive = TRUE;
};


void() deploy_point_th={
  self.think = deploy_point_th;
  self.nextthink = time + 0.5;
};

void() deploy_point_ini={
  self.think = deploy_point_th;
  self.nextthink = time + 0.1;
};


/*QUAKED map_deploy_point (0.753 0.788 0.431) (-26 -26 -44) (26 26 28)
Deploy Points are like a subset of info_player_start. They're bespoke spawn points for players.
Deploy points can be tailored to specific factions, and can be activated/deactivated.

-------- KEYS -------- 
.faction = <float> - Deploy Point only appears for this faction
.data_idx = <float> - number used for id and choosing clientside, MUST HAVE and MUST be unique across the map.
.isActive = <float> [bool] - if active, allow players to spawn here.  
.trigOnSpawn = <string> [target] - map object to fire when this is created
*/
void() map_deploy_point={
  self.data_type = DATA_DEPL;
  self.flags = self.flags | FL_NODE;
  
  util_MapDeveloperMarker();
  setorigin( self, self.origin );
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = deploy_point_use;
  
  if( !(self.isActive) ){
    self.isActive = TRUE;
  }

  self.SendEntity = send_deploy_point;
  self.pflags = self.pflags | PFLAGS_FULLDYNAMIC;
  
  trigger_event( self, self.trigOnSpawn );
  self.think = deploy_point_ini;
  self.nextthink = time + 0.1;
}