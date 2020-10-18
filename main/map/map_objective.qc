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
void() map_objective_th_use={
  SUB_UseTargets(); //allows pass-through trigger call to other triggers.
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
};

/*
  called by other entities during trigger call.
  
*/
void() map_objective_use={
  if( self.isActive == OBJECTIVE_ACTIVE){
    if( OBJECTIVE_FAILED == TRUE){
      //objective was failed
      self.isActive = OBJECTIVE_FAIL;
      trigger_event( self.enemy, self.trigOnDeath );
    }
    else{
      self.think = map_objective_th_use;
      self.nextthink = time + 0.1;
      if( self.count ){
        //Objective counter adjust
        self.count1 = self.count1 + 1;
        if( self.count1 >= self.count ){
          self.isActive = OBJECTIVE_WIN;
        }
      }
      //no counter, regular Objective 'complete'
      self.isActive = OBJECTIVE_WIN;
    }
  }
  else{
    //objective wasn't activated, and now it will be
    if( self.isActive != OBJECTIVE_FAIL ){
      //don't reactivate failed objectives
      self.isActive = OBJECTIVE_ACTIVE;
    }
  }
  self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
  self.enemy = activator;
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
  self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
  //objective achieved
  if(self.isActive == OBJECTIVE_WIN){
    return;
  }
  
  //objective failed.
  if( self.isActive == OBJECTIVE_FAIL ){
    return;
  }
  self.think = map_objective_th;
  self.nextthink = time + 1;
};

void() map_objective_ini={
  self.SendFlags = self.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
};

/*QUAKED map_objective (0.431 0.788 0.753) (-16 -16 -16) (16 16 16) START_OFF ACTIVE_ONTOUCH
  An Objective a specific map object.
  Map Objectives are named triggers that are sent to the client for interaction.
  Map Objectives MUST map to an Objective ID in the Map's MSN File.
  In order to sync these with clients; they should be placed in the same 'holding box' as 
  [info_player_starts] to make sure the player PVS picks them up asap.
  
-------- KEYS -------- 
.data_idx = must match a number in the msn_file
.isActive = 0 = hidden/inactive 
            1 = active
            2 = won
            3 = complete
            4 = failed
.faction = faction for this objective
.target = fire THIS trigger when Objective is COMPLETE, isActive == 2
.aState = determines which SFX to play when 'completed'
                  1 = primary 
                  2 = secondary
                  3 = tertiary
.count = only complete objective when count is hit;
.target = <string> fire this trigger when object is 'won;, isActive == 2;
.trigOnDeath = <string> fire this event when Objective is 'failed', isActive == -1;
-------- SPAWNFLAGS --------
START_OFF 1: 
ACTIVE_ONTOUCH 2: allows player to touch, set mins and maxs
*/
void() map_objective={
  local vector tempMin;
  local vector tempMax;
  
  //touchable
  if( (self.spawnflags & 2) ){
    self.solid = SOLID_TRIGGER;
    tempMax = self.maxs;
    tempMin = self.mins;
    self.touch = map_end_mission_touch;
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
  
  //wild-  EF_NODEPTHTEST allows SendEnt to blast this through to all clients!
  self.effects = self.effects | (EF_LOWPRECISION | EF_NODEPTHTEST | EF_NOSHADOW);
  self.alpha = 0.01;
  self.scale = 0.01;
  
  self.use = map_objective_use;
  self.think = map_objective_th;
  
  //start off
  if( (self.spawnflags & 1) ){
    self.isActive = OBJECTIVE_DISABLE;
  }
  else{
    self.isActive = OBJECTIVE_ACTIVE;
  }
  if( (self.spawnflags & 4) ){
    self.aState = 254;
  }
  if( (self.spawnflags & 8) ){
    self.aState = 255;
  }
  self.SendEntity = send_objective;
  self.nextthink = time + 0.1;
}