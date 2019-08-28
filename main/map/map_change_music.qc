/*
battleMETAL
Author: Peter Roohr
Date: 11/12/2018
Overview: 
  Primarily a map wrapper for the SVC_CDTRACK message, but also a manager of  it as well. 
  This map ent provides map-level control of the music playback code and sound channel. 
  It runs exlcusively on the CD tracks using a track number, so it is unable to process arbitrary sounds.
  
Inputs
  .partTypeId = <float> [trackid] CD Track to play
  .targetname = <string> [targetname] - make triggerable
  .spawnflags 1 = <float> [flag] remove on first fire
  .spawnflags 2 = <float> [flag] loop
*/

void() map_changemusic_touch={
  if( (other.flags & FL_CLIENT) ){
    activator = other;
    self.use();
  }
};

void() map_changemusic_use={
  if( (activator.flags & FL_CLIENT) ){
    client_sendMusic( activator, self.partTypeId, self.spawnflags);
    if( (self.spawnflags & 1) ){
      self.think = SUB_Remove;
      self.nextthink = 0.001;
    }
  }
};

/*QUAKED
  
*/
void() map_change_music={
  local vector tempMin;
  local vector tempMax;
  
  if( !self.mins ){
    self.mins = VEC_ORIGIN;
  }
  if( !self.maxs ){
    self.mins = VEC_ORIGIN;
  }
  
  tempMax = self.maxs;
  tempMin = self.mins;
  
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.use = map_changemusic_use;
  self.touch = map_changemusic_touch;
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, tempMin, tempMax);
  setorigin(self, self.origin);

};
