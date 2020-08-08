/*
battleMETAL
Author: Peter Roohr
Date: 11/17/2018
Overview: 
  HUD Highlighting is a map event sent to chosen clients. This creates a colored box around a portion of the player's screen
  for a set amount of time. The use case is primarily for information and training purposes, but can be useful in other ways.
  HUD Highlighting is a map event sent to chosen clients. This creates a colored box around a portion of the player's screen
  for a set amount of time. The use case is primarily for information and training purposes, but can be useful in other ways.
  
  MESSAGE_ONLY will just send a special event to show an info box;
  
-------- KEYS -------- 
.movedir = <vector> [screen position] - X\Y coords on client screen to draw box, given in %'s 0.001 - 1.0
.compOffset = <vector> [box size] - X\Y size of box to be drawn, given in %'s 0.001 - 1.0
.color = <vector> [red, green, blue] - color of the box
.faction = <float> [faction] - OPTIONAL - use with .spawnflags[8]
.data_lifetime = <float> [time to draw] - amount of time to draw box for

.target = <string> [ent] - fire this trigger when done
.wait = <float> [cooldown] - how long to wait before reactivating, spawnflags[64]

-------- SPAWNFLAGS --------
START_OFF 1: will start as deactivated
ON_TOUCH 2: will react to being touched by a players
REMOVE_FINISH 4: will be removed when finished playing
FACTION_ONLY 8: only reacts to this faction
DROPTOFLOOR 16: object drops to floor for easier touch possibility
FREEZE_PLAYER 32: any players that trigger the Animatic are frozen in place
COOLDOWN 64: use .wait
CALL_BY_TRIGGER 128: must be used with START_OFF
MESSAGE_ONLY 256: only sends message as INFO box
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
    if( (self.spawnflags & 256) ){
      if( self.message != "" ){
        client_send_info_message( other, self.message, self.data_lifetime);
      }
    }
    else{
      client_push_hud_highlight( other );
      if( self.message != "" ){
        client_send_info_message( other, self.message, self.data_lifetime);
      }
    }
    
    
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
    client = findchainflags(flags, FL_CLIENT);
    while(client){
      //FACTION_ONLY setting
      if( (self.spawnflags & 8) ){
        if(self.faction != client.faction){
          continue;
        }
      }
      if( (self.spawnflags & 256) ){
        if( self.message != "" ){
          client_send_info_message( client, self.message, self.data_lifetime);
        }
      }
      else{
        client_push_hud_highlight( client );
        if( self.message != "" ){
          client_send_info_message( client, self.message, self.data_lifetime);
        }
      }
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

/*QUAKED map_hud_highlight (0.431 0.788 0.753) (-16 -16 -16) (16 16 16) START_OFF ON_TOUCH REMOVE_FINISH FACTION_ONLY DROPTOFLOOR FREEZE_PLAYER COOLDOWN CALL_BY_TRIGGER MESSAGE_ONLY
  HUD Highlighting is a map event sent to chosen clients. This creates a colored box around a portion of the player's screen
  for a set amount of time. The use case is primarily for information and training purposes, but can be useful in other ways.
  
  MESSAGE_ONLY will just send a special event to show an info box;
  
-------- KEYS -------- 
.partTypeId = <float> [HUD element ID] - if you want to highlight a specific hud element
.movedir = <vector> [screen position] - X\Y coords on client screen to draw box, given in %'s 0.001 - 1.0
.compOffset = <vector> [box size] - X\Y size of box to be drawn, given in %'s 0.001 - 1.0
.color = <vector> [red, green, blue] - color of the box
.faction = <float> [faction] - OPTIONAL - use with .spawnflags[8]
.data_lifetime = <float> [time to draw] - amount of time to draw box for

.target = <string> [ent] - fire this trigger when done
.wait = <float> [cooldown] - how long to wait before reactivating, spawnflags[64]
-------- SPAWNFLAGS --------
START_OFF 1: will start as deactivated
ON_TOUCH 2: will react to being touched by a players
REMOVE_FINISH 4: will be removed when finished playing
FACTION_ONLY 8: only reacts to this faction
DROPTOFLOOR 16: object drops to floor for easier touch possibility
FREEZE_PLAYER 32: any players that trigger the Animatic are frozen in place
COOLDOWN 64: use .wait
CALL_BY_TRIGGER 128: must be used with START_OFF
MESSAGE_ONLY 256: only sends message as INFO box
*/
void() map_hud_highlight={
  local vector tempMax;
  local vector tempMin;

  self.noise = "misc/talk.wav"; //TODO
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
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
