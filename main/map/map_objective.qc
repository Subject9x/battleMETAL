/*
battleMETAL
Author: Peter Roohr
Date: 03/25/2017
mod: 11/16/2017
mod: 07/25/2019
Overview: 
  An Objective a specific map object.
  Map Objectives are named triggers that are sent to the client for interaction.
  Map Objectives MUST map to an Objective ID in the Map's MSN File.
  These objects don't have to be anywhere specifically, they mostly just help hold game
  state
*/

void() map_objective_th;
void() map_objective_mission_end_th={
local entity player;
  local entity objective;
  local entity playerStart;
  local float successCheck;
  
  if( MISSION_STATUS ){
    successCheck = TRUE;
    nextmap = strzone(self.map);
  }
  else{
    successCheck = FALSE;
    nextmap = strzone(self.mapFile);
  }

  objective = self;
  playerStart = find(world, classname, "info_player_start");
  player = find (world, classname, "player");
  while( player != world ){
    self = player;
      //taken from execute_changelevel()
      player.view_ofs = '0 0 0';
      player.angles = player.v_angle = player.angles;
      player.fixangle = TRUE;		// turn this way immediately
      player.think = SUB_Null;  //I guess this was an animation thing originall? (q1)
      player.nextthink = time + 0.5;
      player.takedamage = DAMAGE_NO;
      player.solid = SOLID_NOT;
      player.movetype = MOVETYPE_NONE;
      player.modelindex = 0;
      //------------------------------
      client_sendEndMission(player, successCheck);
      if(player.data_type == DATA_MECH){
        player_unmakeMech();
        player_makeObserver();
      }
      setorigin (player, playerStart.origin);
    player = find (player, classname, "player");
  }
  self = objective;
	WriteByte (MSG_ALL, SVC_INTERMISSION);
  self.think = SUB_Remove;
  self.nextthink = time + 2;
};
/*
  Only if MISSION_LOSE or MISSION_WIN.
  
    Change - MISSION_STATUS? 1:0.
  
    put clients into INTERMISSION.
  
    set objective states to client.
  
    change clients to observers.
    
    if MISSION_WIN
      nextmap -> .map
      send unlocks to client.
  
    if MISSION_LOSE
      nextmap -> .mapFile
*/
void() map_objective_mission_conclude_th={
  local entity player;
  local entity objective;
  local float successCheck;
  
  if( MISSION_STATUS ){
    successCheck = TRUE;
  }
  else{
    successCheck = FALSE;
  }
  
  objective = self;
  player = find (world, classname, "player");
  while( player != world ){
      self = player;      
      client_push_mapobjects();
      if( successCheck ){
        //only send unlocks if player won mission
        client_sendMissionUnlocks();
        te_mission_win();
      }
      else{
        te_mission_lose();
      }
    player = find (player, classname, "player");
  }
  self = objective;
  
  self.think = map_objective_mission_end_th;
  self.nextthink = time + 4;
};


/*
  called by other entities during trigger call.
*/
void() map_objective_use={
  self.enemy = activator;
  if( self.isActive == OBJECTIVE_ACTIVE){
    SUB_UseTargets();
    if( self.count ){
      //Objective counter adjust
      self.count1 = self.count1 + 1;
      if( self.count1 >= self.count ){
        //Objective counter hit, send to 'complete' status
        if( (self.spawnflags & 4) ){
          self.isActive = OBJECTIVE_FAIL;
          return;
        }
        self.isActive = OBJECTIVE_WIN;
      }
      return;
    }
    //no counter, regular Objective 'complete'
    if( (self.spawnflags & 4) ){
      self.isActive = OBJECTIVE_FAIL;
      return;
    }
    self.isActive = OBJECTIVE_WIN;
    return;
  }
  //objective wasn't activated, and now it will be
  if( self.isActive != OBJECTIVE_FAIL ){
    //don't reactivate failed objectives
    self.isActive = OBJECTIVE_ACTIVE;
  }
};

void() map_objective_touch={
  if( self.isActive > OBJECTIVE_DISABLE ){
    if( (other.flags & FL_CLIENT) ){
      if( other.faction == self.faction ){
        activator = other;
        map_objective_use();
        self.touch = SUB_Null;
      }
    }
  }
};

/*
  The heart of the Map Objective object.
  this is run every time + 0.1, checking isActive every time.
*/
void() map_objective_th={
  local entity player;
  local entity oldThis;
  
  //objective achieved
  if(self.isActive == OBJECTIVE_WIN){
    oldThis = self;
    player = find (world, classname, "player");
    while( player != world){
      if( player.faction == self.faction ){
        self = player;
          client_send_objective( oldThis );
        self = oldThis;
      }
      player = find (player, classname, "player");
    }
    if( (self.spawnflags & 8) ){
      MISSION_STATUS = TRUE;
      intermission_running = 1;
      intermission_exittime = time + 2;
      self.think = map_objective_mission_conclude_th;
      self.nextthink = time + 3;
      return;
    }
    return;
  }
  
  //objective failed.
  if( self.isActive == OBJECTIVE_FAIL ){
    //objective failed!
    player = findchain(classname, "player");
    trigger_event( player, self.trigOnDeath );
    oldThis = self;
    while( player != world ){
      if( player.faction == self.faction ){
        self = player;
          client_send_objective( oldThis );
        self = oldThis;
      }
      player = player.chain;
    }
    if( (self.spawnflags & 4) ){
      MISSION_STATUS = FALSE;
      intermission_running = 1;
      intermission_exittime = time + 2;
      self.think = map_objective_mission_conclude_th;
      self.nextthink = time + 3;
      return;
    }
    return;
  }
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
};


/*QUAKED map_objective (0.431 0.788 0.753) (-16 -16 -16) (16 16 16) START_OFF ACTIVE_ONTOUCH MISSION_LOSE MISSION_WIN
  An Objective a specific map object.
  Map Objectives are named triggers that are sent to the client for interaction.
  Map Objectives MUST map to an Objective ID in the Map's MSN File.
  These objects don't have to be anywhere specifically, they mostly just help hold game
  state
  
-------- KEYS -------- 
.data_idx = must match a number in the msn_file
.isActive = 0 = hidden/inactive 
            1 = active
            2 = complete
           -1 = failed
.faction = faction for this objective
.target = fire THIS trigger when Objective is COMPLETE, isActive == 2
.aState = determines which SFX to play when 'completed'
                  1 = primary 
                  2 = secondary
                  3 = tertiary
.count = only complete objective when count is hit;
.trigOnDeath = fire this event when Objective is 'failed', isActive == -1;
.map = next map if MISSION_WIN
.mapFile = next map if MISSION_LOSE
-------- SPAWNFLAGS --------
START_OFF 1: 
ACTIVE_ONTOUCH 2: allows player to touch, set mins and maxs
MISSION_LOSE 4: when 'failed', fire-off end-mission logic
MISSION_WIN 8: when 'complete' fire-off end-mission logic
*/
void() map_objective={
  local vector tempMin;
  local vector tempMax;
  
  //touchable
  if( (self.spawnflags & 2) ){
    self.solid = SOLID_TRIGGER;
    tempMax = self.maxs;
    tempMin = self.mins;
    self.touch = map_objective_touch;
  }
  else{
    self.solid = SOLID_NOT;
  }
  self.flags = self.flags | FL_NODE;
  
  self.data_type = DATA_OBJT;
  self.movetype = MOVETYPE_NONE;
  
  util_MapDeveloperMarker();
  
  //touchable
  if( (self.spawnflags & 2) ){
    setsize(self, tempMin, tempMax);
  }
  else{
    setsize(self, VEC_ORIGIN, VEC_ORIGIN);
  }
  setorigin(self, self.origin);
  
  self.use = map_objective_use;
  self.think = map_objective_th;
  
  self.isActive = OBJECTIVE_ACTIVE;
  //start off
  if( (self.spawnflags & 1) ){
    self.isActive = OBJECTIVE_DISABLE;
    return;
  }
  if( (self.spawnflags & 4) ){
    self.aState = 254;
  }
  if( (self.spawnflags & 8) ){
    self.aState = 255;
  }
  self.nextthink = time + 0.1;
}