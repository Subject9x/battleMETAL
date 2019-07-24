/*
battleMETAL
Author: Peter Roohr
Date: 03/25/2017
mod: 11/16/2017
Overview: 
  An Objective a specific map object.
  Map Objectives are named triggers that are sent to the client for interaction.
  Map Objectives MUST map to an Objective ID in the Map's MSN File.
  These objects don't have to be anywhere specifically, they mostly just help hold game
  state
  
Inputs
  .data_idx =  <float> [objective id] - must match a number in the msn_file
  .isActive = <float> [enum]  0 = hidden/inactive 
                              1 = active
                              2 = complete
                              -1 = failed
  .faction = <float> faction for this objective
  .target = <string> [targetname] - fire THIS trigger when Objective is COMPLETE, isActive == 2
  .state_1 = <float> [enum] - determines which SFX to play when 'completed'
                    1 = primary 
                    2 = secondary
                    3 = tertiary
   .count = <float> [sum] - only complete objective when count is hit;
   .trigOnDeath = <string> fire this event when Objective is 'failed', isActive == -1;
   
   .spawnflags = <float> [flag] 1 - START_OFF
   .spawnflags = <float> [flag] 2 - ALLOW TRIGGER TOUCH
*/

/*
  
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
  
  if(self.isActive == 2){
    multi_trigger();
    player = findchainflags( flags, FL_CLIENT );
    while( player ){
      if( player.faction == self.faction ){
        oldThis = self;
        self = player;
          client_send_objective( oldThis );
        self = oldThis;
      }
      player = player.chain;
    }
    self.isActive = 0;
    return;
  }
  if( self.isActive == -1 ){
    //objective failed!
    player = findchainflags( flags, FL_CLIENT );
    while( player ){
      if( player.faction == self.faction ){
        oldThis = self;
        self = player;
          client_send_objective( oldThis );
        self = oldThis;
      }
      player = player.chain;
    }
    self.isActive = 0;
    trigger_event( self.enemy, trigOnDeath ) ;
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
  if( (self.spawnflags & 1) ){
    self.isActive = 0;
    return;
  }
  
  self.nextthink = time + 0.1;
}