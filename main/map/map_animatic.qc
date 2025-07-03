/*
battleMETAL
Author: Peter Roohr
Date: 3/3/2018
mod: 11/17/2018
mod: 07/02/2025
Overview: 
  An 'Animatic' is a sequence of images and queued up sounds that are played back for players when the animatic is triggered.
  the script file for the Animatic is defined in /data/anim/<anim_name>.anim
  The script schema can be found there too.
  
  The Map_Animatic object 


  SPAWNFLAGS
    1 : "Start Off" : 0
    2 : "On touch" : 0
    4 : "Remove done" : 0
    8 : "Faction Only" : 0
    16 : "Drop to floor" : 0
    32 : "Freeze players" : 0
    64 : "cooldown" : 0
	128 : "hideWorld"

*/
//SPAWNFLAGS
//#define START_OFF 1 - already defined
#define ON_TOUCH 2  
#define REMOVE_DONE 4  
#define FACTION_ONLY 8 
#define DROP_TO_FLOOR 16
#define FREEZE_PLAYERS 32
#define COOLDOWN 64
#define HIDEWORLD 128

void() animatic_event_trigger={
  SUB_UseTargets();
  //Set to remove when complete
  if( (self.spawnflags & REMOVE_DONE) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.05;
    return;
  }
  
  if( (self.spawnflags & COOLDOWN) ){
    self.think = self.use;
    self.nextthink = time + self.wait;
    return;
  }
};

void() animatic_event_execute={
  local entity client;
  local entity this;
  
  if( self.isActive ){
    this = self;
    //client = findchainflags(flags, (FL_CLIENT));
    for(client = findchainflags(flags, (FL_CLIENT)); client != world; client = client.chain){
      //FACTION_ONLY setting
      if( (self.spawnflags & FACTION_ONLY) ){
        if(self.faction != client.faction){
          continue;
        }
      }
      self = client;
        self.count1 = self.playerState;
        if( (this.spawnflags & FREEZE_PLAYERS) ){
          self.playerState = PLAYER_ANIM_STOP;
          self.count2 = time + this.count1;
          self.count3 = self.movetype;
          self.movetype = MOVETYPE_NONE;
          self.velocity = '0 0 0';
          self.avelocity = '0 0 0';
        }
        client_sendAnimaticFileName(this.missionFile, (this.spawnflags & HIDEWORLD) ? FALSE : TRUE);
        self.animId = this;
      self = this;
      client = client.chain;
    }
    
    if( self.count2 > 0 ){
      self.think = animatic_event_trigger;
      self.nextthink = time + self.count2;
      return;
    }
    
    //Set to remove when complete
    if( (self.spawnflags & REMOVE_DONE) ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.05;
      return;
    }
    
    if( (self.spawnflags & COOLDOWN) ){
      self.think = self.use;
      self.nextthink = time + self.wait;
      return;
    }
  }
};

/*
  Used by other objects making the trigger call.
*/
void() animatic_event_use={

  if( self.isActive ){
    animatic_event_execute();
  }
  else{
    self.isActive = TRUE;
    
    //wait for touch event
    if( (self.spawnflags & ON_TOUCH) ){
      return;
    }
    self.think = animatic_event_execute;
    self.nextthink = time + 0.01;
  }
};

/*
  only used with spawnflags[2]
*/
void() animatic_event_touch={
  if( (other.flags & FL_CLIENT) ){
    if( time > self.dmgtime){
      self.dmgtime = time + 120; //2 minute cool down on refiring anims
      if(self.isActive){
        animatic_event_execute();
      }
    }
  }
};


/*QUAKED map_animatic (0.7 0.5 0.3) (-10 -10 -16) (10 10 16) START_OFF ON_TOUCH REMOVE_FINISH FACTION_ONLY DROPTOFLOOR FREEZE_PLAYER COOLDOWN
An 'Animatic' is a sequence of images and queued up sounds that are played back for players when the animatic is triggered.
the script file for the Animatic is defined in /data/anim/<anim_name>.anim
The script schema can be found there too.  
The Map_Animatic object 

-------- KEYS --------
.missionFile = <string> [file] - the .anim file to be loaded from /data/anim/
.faction = <float> [faction] - OPTIONAL - use with .spawnflags[8]
.count1 = <float> [freeze time] - defaults to 15 sec if not defined, use with spawnflags[32]
.count2 = <float> fire trigger after X seconds.
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
*/
void() map_animatic={
  local vector tempMin;
  local vector tempMax;
  tempMin = self.mins;
  tempMax = self.maxs;
  
  self.dmgtime = time; 
  self.movetype = MOVETYPE_NONE;
  self.use = animatic_event_use;
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
  //touchable check
  if( (self.spawnflags & ON_TOUCH) ){
    self.solid = SOLID_TRIGGER;
    setsize(self, tempMin, tempMax );
  }
  else{
    self.solid = SOLID_NOT;
    setsize(self, self.mins, self.maxs);
  }
  
  //drop to floor check
  if( (self.spawnflags & DROP_TO_FLOOR) ){
    self.movetype = MOVETYPE_FLY;
    setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
    droptofloor();
    self.movetype = MOVETYPE_NONE;
  }
  else{
    setorigin( self, self.origin );
  }
  
  self.isActive = TRUE;
  //START_OFF
  if( (self.spawnflags & START_OFF) ){
    self.isActive = FALSE;
  }
  if( (self.spawnflags & FREEZE_PLAYERS) ){
    //set default freeze time
    if( !self.count1 ){
      self.count1 = 15;
    }
  }

  if( (self.spawnflags & COOLDOWN) ){
    //no default for cooldown behavior;
    if( !self.wait ){
      self.spawnflags = self.spawnflags - (self.spawnflags & COOLDOWN);
    }
  }
  
  if( (self.spawnflags & START_OFF) ){
    self.touch = animatic_event_touch;
  }
};