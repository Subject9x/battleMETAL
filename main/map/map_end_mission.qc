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
  
  if( self.missionStatus == -1 ){
    self.missionStatus = 0; //client compatability zero-out.
  }
  
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
      sv_nextmap -> .map
      send unlocks to client.

    if MISSION_LOSE
      sv_nextmap -> .map
*/
void() map_end_mission_conclude={
  //mission can only end if its active.
  if( ENT_SERVER_INFO.missionStatus == MISSION_STATUS_ACTIVE ){
    ENT_SERVER_INFO.missionStatus = MISSION_STATUS_OVER;
    if( self.missionStatus == TRUE ){
      ENT_SERVER_INFO.missionResult = MISSION_RESULT_WIN;
    }
    else{
      ENT_SERVER_INFO.missionResult = MISSION_RESULT_FAIL;
    }
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MISSION_RESULT | SENDFLAG_MISSION_STATUS;
    sv_nextmap = self.map;
    
    if( strlen(ENT_SERVER_INFO.nextMap) > 0 ){
      strunzone(ENT_SERVER_INFO.nextMap);
    }
    ENT_SERVER_INFO.nextMap = strzone(sv_nextmap);
    ENT_SERVER_INFO.SendFlags = ENT_SERVER_INFO.SendFlags | SENDFLAG_MAP_NEXT;
    self.think = map_end_mission_event;
    self.nextthink = time + 4;
  }
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
Odds are there'll be 2 of these per single player map, 1 success, 1 fail.

CAMPAIGN ONLY and COOP ONLY!

-------- KEYS -------- 
.isActive = <float> enum
            0 = Inactive
            1 = active
.faction = <float> faction for this objective
.count = <float> only complete objective when count is hit;
.map = <string> "<mapname>.bsp" - map to play on WIN
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
  util_DeveloperNodeMark();
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
