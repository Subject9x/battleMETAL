/*
battleMETAL
Author: Peter Roohr
Date: 11/12/2018
Overview: 
  Primarily a map wrapper for the SVC_CDTRACK message, but also a manager of  it as well. 
  This map ent provides map-level control of the music playback code and sound channel. 
  It runs exclusively on the CD tracks using a track number, so it is unable to process arbitrary sounds.

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

/*QUAKED map_change_music (0.431 0.788 0.753) (-12 -12 -12) (12 12 12) REMOVE_FIRSTUSE LOOP
Primarily a map wrapper for the SVC_CDTRACK message, but also a manager of  it as well. 
This map ent provides map-level control of the music playback code and sound channel. 
It runs exlcusively on the CD tracks using a track number, so it is unable to process arbitrary sounds.
  
-------- KEYS -------- 
.comp_id = <float> [trackid] CD Track to play
.targetname = <string> [targetname] - make triggerable

-------- SPAWNFLAGS -------- 
REMOVE_FIRSTUSE 1: remove on first fire
LOOP 1: loop track
*/
void() map_change_music={
  local vector tempMin;
  local vector tempMax;
  
  if( !self.mins )
    self.mins = VEC_ORIGIN;
  
  if( !self.maxs )
    self.mins = VEC_ORIGIN;
  
  tempMax = self.maxs;
  tempMin = self.mins;
  
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.use = map_changemusic_use;
  self.touch = map_changemusic_touch;
  
  util_MapDeveloperMarker();
  
  setsize(self, tempMin, tempMax);
  setorigin(self, self.origin);
};
