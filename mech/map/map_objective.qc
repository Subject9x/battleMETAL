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
  
Inputs
  .data_idx =  <float> [objective id] - must match a number in the missionFile
  .isActive = <float> [enum]  0 = hidden/inactive 
                              1 = active
                              2 = complete
                              -1 = failed
  .faction = <float> faction for this objective
  .target = <string> [targetname] - fire THIS trigger when Objective is COMPLETE, isActive == 2
  .trigOnDeath = <string> fire this event when Objective is 'failed', isActive == -1;
  .state_1 = <float> [enum] - determines which SFX to play when 'completed'
                    1 = primary 
                    2 = secondary
                    3 = tertiary
   .count = <float> [sum] - only complete objective when count is hit;
   
   .map = map to go to if MISSION_WIN.
   .mapFile = map to go to if MISSION_LOSE
   
   .spawnflags = <float> [flag] 1 - START_OFF
   .spawnflags = <float> [flag] 2 - ALLOW TRIGGER TOUCH
   .spawnflags = <float> [flag] 4 - MISSION_LOSE
   .spawnflags = <float> [flag] 8 - MISSION_WIN
*/

void() map_objective_th;

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
  local string toMap;
  
  if( MISSION_STATUS ){
    if( !self.map || (self.map == "")){
      objerror( "map_objective missing .map field.");
      return;
    }
    successCheck = TRUE;
    nextmap = self.map;
  }
  else{
    if( !self.mapFile || (self.mapFile == "")){
      objerror( "map_objective missing .mapFile field.");
      return;
    }
    successCheck = FALSE;
    nextmap = self.mapFile;
  }
  
  objective = self;
  player = find (world, classname, "player");
  while( player != world ){
      player.stat_plr_stt = PLAYER_INTERMSN;  //TEST
      if(player.data_type == DATA_MECH){
        player_unmakeMech();
        player_makeObserver();
      }
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
      setorigin (player, self.origin);
      coredump();
      //------------------------------
      
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
      client_sendEndMission(player, successCheck);
    player = find (player, classname, "player");
  }
  self = objective;
	WriteByte (MSG_ALL, SVC_INTERMISSION);
  self.think = map_objective_th;
  self.nextthink = time + 2;
};

/*
  called by other entities during trigger call.
*/
void() map_objective_use={
  self.enemy = activator;
  if( self.isActive ){
    if( self.count ){
      //Objective counter adjust
      self.count1 = self.count1 + 1;
      if( self.count1 >= self.count ){
        //Objective counter hit, send to 'complete' status
        self.isActive = 2;
      }
      return;
    }
    //no counter, regular Objective 'complete'
    self.isActive = 2;
    return;
  }
  //objective wasn't activated, and now it will be
  if( self.isActive > -1 ){
    //don't reactivate failed objectives
    self.isActive = 1;
  }
};

void() map_objective_touch={
  if( self.isActive > 0 ){
    if( (other.flags & FL_CLIENT) ){
      if( other.faction == self.faction ){
        activator = other;
        map_objective_use();  //DEBUG - complete on-touch
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
  oldThis = self;
  if(self.isActive == 2){
    multi_trigger();
    player = find (world, classname, "player");
    while( player != world){
      if( player.faction == self.faction ){
        self = player;
          client_send_objective( oldThis );
        self = oldThis;
      }
      player = find (player, classname, "player");
    }
    self.isActive = 0;
    if( (self.spawnflags & 8) ){
      MISSION_STATUS = TRUE;
      intermission_running = 1;
      intermission_exittime = time + 2;
      self.think = map_objective_mission_conclude_th;
      self.nextthink = time + 4;
      return;
    }
    return;
  }
  
  //objective failed.
  if( self.isActive == -1 ){
    //objective failed!
    trigger_event( self.enemy, trigOnDeath );
    player = find (world, classname, "player");
    while( player != world ){
      if( player.faction == self.faction ){
        self = player;
          client_send_objective( oldThis );
        self = oldThis;
      }
      player = find (player, classname, "player");
    }
    self.isActive = 0;
    if( (self.spawnflags & 4) ){
      MISSION_STATUS = FALSE;
      intermission_running = 1;
      intermission_exittime = time + 2;
      self.think = map_objective_mission_conclude_th;
      self.nextthink = time + 4;
      return;
    }
    return;
  }
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
};


/*QUAKED map_objective (0.99 0.8 0) (-10 -10 -10) (10 10 10)
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
  
  setmodel(self, "q3mdl/testball.md3");
  
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
  
  self.isActive = 1;
  //start off
  if( (self.spawnflags & 1) ){
    self.isActive = 0;
    return;
  }
  
  self.nextthink = time + 0.1;
}