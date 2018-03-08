/*
mech Mod
Author: Peter Roohr
Date: 3/3/2018
Overview: the map object to trigger an 'Animatic' event on the client side
*/


void() animatic_event_use={
  if(self.isActive){
    animatic_event_execute();
  }
  else{
    self.isActive = TRUE;
    self.think = animatic_event_execute;
    self.nextthink = time + 0.01;
  }
};

void() animatic_event_execute={
  local entity client, this;
  if( self.isActive){
    this = self;
    client = findchainflags(flags, FL_CLIENT);
    while(client){
      //FACTION_ONLY setting
      if( (self.spawnflags & 4) ){
        if(self.i_faction == client.i_faction){
          self = client;
            self.count1 = self.stat_plr_stt;
            self.stat_plr_stt = PLAYER_ANIM_STOP;
            self.count2 = time + this.count1;
            self.count3 = self.movetype;
            self.movetype = MOVETYPE_NONE;
            self.velocity = '0 0 0';
            client_sendAnimaticFileName(this.msn_file);
          self = this;
        }
      }
      else{
        self = client;
          self.count1 = self.stat_plr_stt;
          self.stat_plr_stt = PLAYER_ANIM_STOP;
          self.count2 = time + this.count1;
          self.count3 = self.movetype;
          self.movetype = MOVETYPE_NONE;
          self.velocity = '0 0 0';
          client_sendAnimaticFileName(this.msn_file);
        self = this;
      }
      client = client.chain;
    }
    //Set to remove when complete
    if( (self.spawnflags & 2) ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.05;
    }
  }
};

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
triggers an animatic event that is sent to players
'isActive' - start on or off, use() will turn on the event and execute the animatic
'targetname' - linked from other map objects
'msn_file' - the .anim file to load, in /data/<file>
'i_faction' - use with FACTION_ONLY
If anim file has 'nomove' set to '1', provide a 'freeze time'
to freeze players here!
 'count1' - freeze time
TOUCH(1) - triggered by ontouch
FINISH_REMOVE(2) - remove post-activation
FACTION_ONLY(4) - only use the specified 'i_faction'
DROPTOFLOOR(8) - drops trigger to floor
*/
void() animatic_event={
  self.dmgtime = time;
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  setmodel(self, "q3mdl/testball.md3"); //DEBUG
  if( (self.spawnflags & 8) ){
    setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
    droptofloor();
  }
  self.use = animatic_event_use;
  if( (self.spawnflags & 1) ){
    self.touch = animatic_event_touch;
  }
};