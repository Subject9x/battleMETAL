/*
battleMETAL
Author: Peter Roohr
Date: 3/3/2018
mod: 11/17/2018
Overview: 
  An 'Animatic' is a sequence of images and queued up sounds that are played back for players when the animatic is triggered.
  the script file for the Animatic is defined in /data/anim/<anim_name>.anim
  The script schema can be found there too.
  
  The Map_Animatic object 
*/

void() animatic_event_trigger={
  SUB_UseTargets();
  //Set to remove when complete
  if( (self.spawnflags & 4) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.05;
    return;
  }
  
  if( (self.spawnflags & 64) ){
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
      if( (self.spawnflags & 8) ){
        if(self.faction != client.faction){
          continue;
        }
      }
      self = client;
        self.count1 = self.playerState;
        if( (this.spawnflags & 32) ){
          self.playerState = PLAYER_ANIM_STOP;
          self.count2 = time + this.count1;
          self.count3 = self.movetype;
          self.movetype = MOVETYPE_NONE;
          self.velocity = '0 0 0';
          self.avelocity = '0 0 0';
        }
        client_sendAnimaticFileName(this.missionFile);
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
    if( (self.spawnflags & 4) ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.05;
      return;
    }
    
    if( (self.spawnflags & 64) ){
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
    if( (self.spawnflags & 2) ){
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
  if( (self.spawnflags & 2) ){
    self.solid = SOLID_TRIGGER;
    setsize(self, tempMin, tempMax );
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
  
  self.isActive = TRUE;
  //START_OFF
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
  }
  if( (self.spawnflags & 32) ){
    //set default freeze time
    if( !self.count1 ){
      self.count1 = 15;
    }
  }

  if( (self.spawnflags & 64) ){
    //no default for cooldown behavior;
    if( !self.wait ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 64);
    }
  }
  
  if( (self.spawnflags & 1) ){
    self.touch = animatic_event_touch;
  }
};