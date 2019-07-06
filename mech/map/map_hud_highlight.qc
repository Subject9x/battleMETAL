/*
battleMETAL
Author: Peter Roohr
Date: 11/17/2018
Overview: 
  HUD Highlighting is a map event sent to chosen clients. This creates a colored box around a portion of the player's screen
  for a set amount of time. The use case is primarily for information and training purposes, but can be useful in other ways.
  

Inputs
  .movedir = <vector> [screen position] - X\Y coords on client screen to draw box, given in %'s 0.001 - 1.0
  .c_ofs = <vector> [box size] - X\Y size of box to be drawn, given in %'s 0.001 - 1.0
  .color = <vector> [red, green, blue] - color of the box
  .faction = <float> [faction] - OPTIONAL - use with .spawnflags[8]
  .data_lifetime = <float> [time to draw] - amount of time to draw box for
  
  .target = <string> [ent] - fire this trigger when done
  .wait = <float> [cooldown] - how long to wait before reactivating, spawnflags[64]
  
  .spawnflags = <float> [flag] 1 - START_OFF - will start as deactivated
  .spawnflags = <float> [flag] 2 - ON_TOUCH - will react to being touched by a players
  .spawnflags = <float> [flag] 4 - REMOVE_FINISH - will be removed when finished playing
  .spawnflags = <float> [flag] 8 - FACTION_ONLY - only reacts to this faction
  .spawnflags = <float> [flag] 16 - DROPTOFLOOR - object drops to floor for easier touch possibility
  .spawnflags = <float> [flag] 32 - FREEZE_PLAYER - any players that trigger the Animatic are frozen in place
  .spawnflags = <float> [flag] 64 - COOLDOWN - use .wait
  .spawnflags = <float> [flag] 128 - Call by trigger, must be used with START_OFF
*/

/*
  Only used if spawnflags[2] is used
*/
void() highlight_hud_touch={
  if( (other.flags & FL_CLIENT) ){
    if( (self.spawnflags & 8) ){
      if( other.faction != self.faction ){
        return;
      }
    }
    client_push_hud_highlight( other );
    
    if( (self.spawnflags & 4) ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.01;
    }
    
    self.isActive = FALSE;
    
    if( (self.spawnflags & 64) ){
      self.think = self.use;
      self.nextthink = time + self.wait;
    }
  }
};

/*
  the main function for map_hud_highlight
*/
void() map_hud_highlight_use={
  local entity client;
  local entity this;
  
  if( self.isActive ){
    this = self;
    client = findchainflags(flags, (FL_CLIENT));
    while(client){
      //FACTION_ONLY setting
      if( (self.spawnflags & 8) ){
        if(self.faction != client.faction){
          continue;
        }
      }
      client_push_hud_highlight( client );
      client = client.chain;
    }
    if( client ){
      //this use() call only counts if any clients were actually found
      if( (self.spawnflags & 4) ){
        self.think = SUB_Remove;
        self.nextthink = time + 0.01;
      }
      
      self.isActive = FALSE;
      
      if( (self.spawnflags & 64) ){
        self.think = self.use;
        self.nextthink = time + self.wait;
        return;
      }
    }
    return;
  }
  
  self.isActive = TRUE;
};

/*QUAKED map_hud_highlight (.5 .5 .5) ?
*/
void() map_hud_highlight={
  local vector tempMax;
  local vector tempMin;

  self.noise = "misc/talk.wav"; //TODO
  
  setmodel( self, "q3mdl/testball.md3" );
  
  //touchable check
  if( (self.spawnflags & 2) ){
    self.solid = SOLID_TRIGGER;
    setsize(self, tempMin, tempMax );
    self.touch = highlight_hud_touch;
  }
  else{
    self.solid = SOLID_NOT;
    setsize(self, self.mins, self.maxs);
  }
  
  //drop to floor check
  if( (self.spawnflags & 16) ){
    self.movetype = MOVETYPE_FLY;
    setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
    droptofloor();
    self.movetype = MOVETYPE_NONE;
  }
  else{
    setorigin( self, self.origin );
  }
  
  if (!self.wait){
		self.wait = 0.2;
  }
  self.use = map_hud_highlight_use;
  
  self.isActive = TRUE;
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
  }

  if (self.nextthink > time){
    return; // already been triggered
  }
};
