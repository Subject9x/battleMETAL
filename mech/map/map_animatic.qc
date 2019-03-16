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

Inputs
  .msn_file = <string> [file] - the .anim file to be loaded from /data/anim/
  .i_faction = <float> [faction] - OPTIONAL - use with .spawnflags[8]
  .count1 = <float> [freeze time] - defaults to 15 sec if not defined, use with spawnflags[32]
  .target = <string> [ent] - fire this trigger when done
  .wait = <float> [cooldown] - how long to wait before reactivating, spawnflags[64]
  
  .spawnflags = <float> [flag] 1 - START_OFF - will start as deactivated
  .spawnflags = <float> [flag] 2 - ON_TOUCH - will react to being touched by a players
  .spawnflags = <float> [flag] 4 - REMOVE_FINISH - will be removed when finished playing
  .spawnflags = <float> [flag] 8 - FACTION_ONLY - only reacts to this i_faction
  .spawnflags = <float> [flag] 16 - DROPTOFLOOR - object drops to floor for easier touch possibility
  .spawnflags = <float> [flag] 32 - FREEZE_PLAYER - any players that trigger the Animatic are frozen in place
  .spawnflags = <float> [flag] 64 - COOLDOWN - use .wait
*/

void() animatic_event_execute={
  local entity client;
  local entity this;
  
  if( self.isActive ){
    this = self;
    client = findchainflags(flags, (FL_CLIENT));
    while(client){
      //FACTION_ONLY setting
      if( (self.spawnflags & 8) ){
        if(self.i_faction != client.i_faction){
          continue;
        }
      }
      self = client;
        self.count1 = self.stat_plr_stt;
        self.stat_plr_stt = PLAYER_ANIM_STOP;
        self.count2 = time + this.count1;
        self.count3 = self.movetype;
        self.movetype = MOVETYPE_NONE;
        self.velocity = '0 0 0';
        self.avelocity = '0 0 0';
        client_sendAnimaticFileName(this.msn_file);
      self = this;
      client = client.chain;
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
    
    if( (self.spawnflags & 2) ){
      //wait for touch event
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

/*QUAKED animatic_event (.7 .5 .3) (-5 -5 -5) (5 5 5) TOUCH FINISH_REMOVE FACTION_ONLY DROPTOFLOOR
*/
void() animatic_event={
  local vector tempMin;
  local vector tempMax;
  tempMin = self.mins;
  tempMax = self.maxs;
  
  self.dmgtime = time; 
  self.movetype = MOVETYPE_NONE;
  self.use = animatic_event_use;
  
  setmodel(self, "q3mdl/testball.md3"); //DEBUG
  
  if( !cvar("developer") ){
    self.effects = self.effects | EF_NODRAW;
  }
  
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
  if( (self.spawnflags & 1) ){
    //START_OFF
    self.isActive = FALSE;
  }
  
  if( (self.spawnflags & 32) ){
    if( !self.count) {
      //set default freeze time
      self.count = 15;
    }
  }

  if( (self.spawnflags & 64) ){
    if( !self.wait ){
      //no default for cooldown behavior;
      self.spawnflags = self.spawnflags - (self.spawnflags & 64);
    }
  }
  
  if( (self.spawnflags & 1) ){
    self.touch = animatic_event_touch;
  }
};