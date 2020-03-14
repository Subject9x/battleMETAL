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

void() deploy_point_remote_use={

};

void() deploy_point_remote_query={
  local entity trg;
  if( self.target != "" ){
    trg = find(world, classname, "map_deploy_point");
    if( trg ){
      self.view_ofs = trg.origin;
    }
    else{
      cons_logAString("Map Error: ", "Remote Deploy Point has .target value but cannot find entity!"); 
    }
  }
  
  self.think = deploy_point_th;
  self.nextthink = time + 0.5;
};

/*QUAKED map_deploy_point_remote (0.431 0.753 0.788) (-26 -26 -44) (26 26 28)
REMOTE: quirk in server code means not all ents are sent to the player on-connect IF
they're not in the same BSP volume. IF deploy points are not visible to [info_player_start]
when player joins, they WILL NOT be visible for use. This sub-entity fixes the issue.

USAGE: works exactly like [map_deploy_point] but with the following addition:
  + .view_ofs = <vector> the ACTUAL origin of the desired deploy point.
    - this will be sent to player's CSQC on-spawn.
  + .target = <string> only if you want 2 ents per deploy, the actual, and the remote.
    - this is checked FIRST and is EITHER/OR.

Deploy Points are like a subset of info_player_start. They're bespoke spawn points for players.
Deploy points can be tailored to specific factions, and can be activated/deactivated.

-------- KEYS -------- 
.faction = <float> - Deploy Point only appears for this faction
.data_idx = <float> - number used for id and choosing clientside, MUST HAVE and MUST be unique across the map.
.isActive = <float> [bool] - if active, allow players to spawn here.  
.trigOnSpawn = <string> [target] - map object to fire when this is created
*/
void() map_deploy_point_remote={
  map_deploy_point();
  
  self.use = deploy_point_remote_use;
  self.SendEntity = send_deploy_point_remote;
  self.think = deploy_point_remote_query;
  self.nextthink = time + 0.1;
}