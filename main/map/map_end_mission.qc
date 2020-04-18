/*
battleMETAL
Author: Peter Roohr
Date: 03/15/2020
Overview: 
  Ends the mission, either Successful or Failure
  this is to decouple overloading the map_objective entity.
  
  Trying to make it easy for mappers to quickly know how and when missions end and for which factions.
  QuakeC lacks a critical 'trigger messaging' system that, ironically, would look something like SendEntity.
  
*/

float MISSION_LOSE = 4;
float TOUCH_ACTIVE = 16;
float TOUCH_FACTION = 32;

void() map_end_mission_over={
  local entity objective;
  local entity playerStart;
  local entity player;
  
  if( self.missionStatus == -1 ){
    self.missionStatus = 0; //client compatability zero-out.
  }
  nextmap = self.map;
  
  /*objective = self;
  playerStart = find(world, classname, "info_player_start");
  for( player = nextent(world); player.classname == "player"; player = nextent(player) ){
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
    //client_sendEndMission(player, player.missionStatus);
    client_push_player_info();
    if(player.data_type == DATA_MECH){
      self = player;
      ctrl_unit_clean_wgroups();
      ctrl_unit_cleanup_player();
      player_unmakeMech();
      player_makeObserver();
    }
    setorigin (player, playerStart.origin);
  }
  self = objective;*/
	//WriteByte (MSG_ALL, SVC_INTERMISSION);
  self.think = SUB_Remove;
  self.nextthink = time + 2;
};


void() map_end_mission_event={
  //intermission_running = 1;
  //intermission_exittime = time + 2;
  self.think = map_end_mission_over;
  self.nextthink = time + 3;
};

/*
Only if MISSION_LOSE or MISSION_WIN.

  Change - MISSION_STATUS? 1:-1.

  set objective states to client.

  change clients to observers.
  
  CAMPAIGN---------
    if MISSION_WIN
      nextmap -> .map
      send unlocks to client.

    if MISSION_LOSE
      nextmap -> .map
*/
void() map_end_mission_conclude={
  local entity player;
  local entity objective;
  
  //mission can only end if its active.
  if( MISSION_STATUS == MISSION_STATUS_ACTIVE ){
    MISSION_STATUS = MISSION_STATUS_OVER;
    if( self.missionStatus == TRUE ){
      MISSION_RESULT = MISSION_RESULT_WIN;
    }
    else{
      MISSION_RESULT = MISSION_RESULT_FAIL;
    }
    self.think = map_end_mission_event;
    self.nextthink = time + 4;
  }
  /*objective = self;
  for( player = nextent(world); player.classname == "player"; player = nextent(player) ){
    self = player;
    if( self.faction == objective.faction ){
      if( objective.missionStatus == TRUE ){
        self.missionStatus = TRUE;
        //client_sendMissionUnlocks(); TODO - figure out unlocks
        if( !world.ignoreSave ){
          savefile_append();    
        }
        //te_mission_win();
      }
      else{
        //te_mission_lose();
        self.missionStatus = FALSE;
      }
    }
    else{
      if( objective.missionStatus == TRUE ){
        //te_mission_lose();
        self.missionStatus = FALSE;
      }
      else{
        self.missionStatus = TRUE;
        //client_sendMissionUnlocks(); TODO - figure out unlocks
        if( !world.ignoreSave ){
          savefile_append();    
        }
        //te_mission_win();
      }
    }
  }
  self = objective;*/
    

};


void() map_end_mission_use={
  if( self.isActive == OBJECTIVE_ACTIVE ){
    if( self.count > 0 ){
      self.count = self.count - 1;
      return;
    }
    self.missionStatus = 1;
    if( (self.spawnflags & MISSION_LOSE) ){
      self.missionStatus = -1;
    }
    self.think = map_end_mission_conclude;
    self.nextthink = time + 1;
  }
  else{
    self.isActive = OBJECTIVE_ACTIVE;
    return;
  }
};

void() map_end_mission_touch={
  if( self.isActive == OBJECTIVE_ACTIVE ){
    if( (self.spawnflags & TOUCH_FACTION) ){
      if( other.faction != self.faction ){
        return;
      }
    }
  }
  map_end_mission_use();
};

/*QUAKED map_mission_end(0.431 0.788 0.753) (-16 -16 -16) (16 16 16) START_OFF - MISSION_LOSE - TOUCH_ACTIVE TOUCH_FACTION
End_Mission ends the entire mission for EVERY player / faction.
Default is play "mission successful" message for faction-matching players.
Odds are there'll be 2 of these per single player map, 1 success, 1 fail.

CAMPAIGN ONLY and COOP ONLY!

-------- KEYS -------- 
.isActive = <float> enum
            0 = Inactive
            1 = active
.faction = <float> faction for this objective
.count = <float> only complete objective when count is hit;
.map = <string> "<mapname>.bsp" - map to play next.

-------- SPAWNFLAGS --------
START_OFF 1: starts disabled, and will need at least 1 trigger call to activate before being usable!
MISSION_LOSE 4: play "mission failed" message for faction-matching players.
TOUCH_ACTIVE 16: allows player to touch, set mins and maxs.
TOUCH_FACTION 32: only register touch events when other is same faction.
*/
void() map_mission_end={
  local vector tempMin;
  local vector tempMax;
  
  //touchable
  if( (self.spawnflags & TOUCH_ACTIVE) ){
    self.solid = SOLID_TRIGGER;
    tempMax = self.maxs;
    tempMin = self.mins;
    self.touch = map_end_mission_touch;
    setsize(self, tempMin, tempMax);
  }
  else{
    util_MapDeveloperMarker();
    self.solid = SOLID_NOT;
    setsize(self, '-10 -10 -10', '10 10 10');
  }
  setorigin(self, self.origin);
  
  self.use = map_end_mission_use;
  
  self.isActive = OBJECTIVE_ACTIVE;
  
  //start off
  if( (self.spawnflags & 1) ){
    self.isActive = OBJECTIVE_DISABLE;
    return;
  }
}
