/*
battleMETAL
Author: Peter Roohr
Date: 03/25/2017
mod: 11/15/2018
Overview: 
  Nav Points are points of interest marked on Player maps. Players interact with them by visiting them, 
  which can then fire triggers to additional game logic. 

Inputs
  .i_faction = <float> - defines which factions this Nav Point belongs to
  .data_idx = <float> [enum] - 1 to 21, each must be unique because this determines the 'name' of the nav point client-side
  .isActive = <float> [enum] - 1 = active unvisit - active, faction hasn't visited that nav yet
                               2 = active visit -  active, faction has been here
                               0 = hidden - this means 'hidden from OTHER factions'
                               -1 = inactive - hidden from EVERYONE
  .target   = <string> [ent] - fire this map object when VISITED
  .trigOnSpawn = <string> [ent] - fire this map object when ACTIVATED  
  .spawnflags = <float> [flag] 2 - only updates 'visited' state per-client
  .spawnflags = <float> [flag] 4 - deactivate after use
*/

/*
  Nav points only apply to Clients, therefore only Clients
  can affect the state of a navpoint.
*/
void() nav_point_touch={
  if(self.isActive == TRUE){
    if( !(other.flags & FL_CLIENT) ){
      return;
    }
    if( other.i_faction == self.i_faction ){
      self.enemy = other;
      self.isActive = 2;
      stemp = self;
      self = other;
        client_send_navpoint( stemp );
      self = stemp;
      
      //TODO - test hack, figure out objectives, ya turkey
      local entity targ;
      targ = find( world, targetname, self.target );
      if( targ.data_type == DATA_OBJT ){
        targ.isActive = 2;
        targ.count = 1;
      }
      
      //multi_trigger();
      if( (self.spawnflags & 2) ){
        self.isActive = 1;
      }
      if( (self.spawnflags & 4) ){
        self.isActive = -1;
      }
    }
  }
};

/*
  nav is being called by another trigger.
  all this really does is short-circuit the 'trigger on visit' 
  to be fired on-demand right now by another trigger.
*/
void() nav_point_use={
  if(self.isActive > FALSE){
    self.isActive = -1;
    multi_trigger();
  }else{
    self.isActive = TRUE;
    local string temptarg;
    temptarg = self.target;
    self.target = self.vec_name;
    multi_trigger();
    self.target = temptarg;
  }
};

/*QUAKED map_navpoint (0.2 0.8 0.2) (-10 -10 -10) (10 10 10)
"i_faction"   : bitflags for faction, only visible to that faction
"data_idx"    : number, 1 - 21, MUST BE UNIQUE
"isActive"    : 1 = active unvisit, 2 = active visit, 0 = hidden, -1 = inactive.
"target"      : fire trigger when visited once
"vec_name"    : a trigger to fire when activated
"spawnflags 2": only updates 'visited' state per-client
"spawnflags 4": deactivate after use
*/
void() map_nav_point={
  self.classname = "data";
  self.flags = self.flags | FL_NODE;
  self.data_type = DATA_NAVP;
  setmodel(self, "q3mdl/testball.md3");
  setsize( self, '-150 -150 -100', '150 150 100' ); 
  setorigin( self, self.origin );
  self.movetype = MOVETYPE_FLY;
  droptofloor();
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_TRIGGER;
  self.use = nav_point_use;
  self.touch = nav_point_touch;
};