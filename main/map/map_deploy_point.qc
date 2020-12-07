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
    self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
    return;
  }
  self.isActive = TRUE;
  self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
};


void() deploy_point_th={
  self.think = deploy_point_th;
  self.nextthink = time + 0.5;
};

void() deploy_point_ini={

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  trigger_event( self, self.trigOnSpawn );
  self.SendFlags = self.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
  self.think = deploy_point_th;
  self.nextthink = time + 0.1;
};


/*QUAKED map_deploy_point (0.753 0.788 0.431) (-26 -26 -44) (26 26 28) NO_CAMPAIGN NO_COOP NO_DM NO_TDM CAN_TARGET ? ? ? DO_NOT_USE DO_NOT_USE DO_NOT_USE DO_NOT_USE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE
Deploy Points are like a subset of info_player_start. They're bespoke spawn points for players.
Deploy points can be tailored to specific factions, and can be activated/deactivated.

-------- KEYS -------- 
.faction = <float> - Deploy Point only appears for this faction
.isActive = <float> [bool] - if active, allow players to spawn here.  
.trigOnSpawn = <string> [target] - map object to fire when this is created
-------SPAWNFLAGS-----
NO_CAMPAIGN 1 : removed from singleplayer
NO_COOP 2 : removed from co-operative games
NO_DM 4 : removed from deathmatch games
NO_TDM 8 : removed from deathmatch 1 / teamplay 1 games.


*/
void() map_deploy_point={
  DEPLOY_ID_COUNT = DEPLOY_ID_COUNT + 1;
  self.data_idx = DEPLOY_ID_COUNT;
  
  self.data_type = DATA_DEPL;
  self.flags = self.flags | FL_NODE;
  
  util_MapDeveloperMarker();
  setorigin( self, self.origin );
  
  //wild-  EF_NODEPTHTEST allows SendEnt to blast this through to all clients!
  self.effects = self.effects | (EF_LOWPRECISION | EF_NODEPTHTEST);
  self.alpha = 0.01;
  self.scale = 0.01;
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = deploy_point_use;
  
  if( !self.faction ){
    self.faction = FACTION_ALL;
  }
  if( !self.isActive ){
    self.isActive = TRUE;
  }
  
  self.nextVecChoice = 1; //(satisfies ai_can_spawn() call)
  
  self.SendEntity = send_deploy_point;
  self.think = deploy_point_ini;
  self.nextthink = time + 0.1;
}

void() deploy_point_remote_use={
  local entity trg;
  if( self.target != "" ){
    trg = find(world, targetname, self.target);
    if( trg ){
      if( trg.isActive ){
        trg.isActive = FALSE;
        return;
      }
      trg.isActive = TRUE;
    }
    else{
      cons_logAString("Map Error: ", "Remote Deploy Point has .target value but cannot find entity!"); 
    }
  }
  else{
    if( self.isActive ){
      self.isActive = FALSE;
      return;
    }
    self.isActive = TRUE;
  }
};

void() deploy_point_remote_send={
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};

void() deploy_point_remote_query={
  local entity remoteDeploy;
  if( self.data_idx != 0 ){
    for( remoteDeploy = findchainfloat(data_type, DATA_DEPL); remoteDeploy != world; remoteDeploy = remoteDeploy.chain ){
      if( remoteDeploy.data_idx != self.data_idx ){
        continue;
      }
      self.view_ofs = remoteDeploy.origin;
      self.angles = remoteDeploy.angles;
      self.isActive = remoteDeploy.isActive;
      self.faction = remoteDeploy.faction;
      self.think = deploy_point_remote_send;
      self.nextthink = time + 0.1;
    }
  }
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
  setmodel(self, "q3mdl/testball.md3");
  setsize( self, '-10 -10 -10', '10 10 10' ); 
  setorigin( self, self.origin );
  
  self.SendEntity = send_deploy_point;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  self.use = deploy_point_remote_use;
  self.think = deploy_point_remote_query;
  self.nextthink = time + 0.1;
}