/*
battleMETAL
Author: Peter Roohr
Date: 11/12/2018
Overview: 
  Primarily a map wrapper for the SVC_CDTRACK message, but also a manager of  it as well. 
  This map ent provides map-level control of the music playback code and sound channel. 
  It runs exlcusively on the CD tracks using a track number, so it is unable to process arbitrary sounds.
  
Inputs
  <float> [trackid] CD Track to play
  <float> [number] of repeats
  <string> [targetname] - make triggerable
  <float> [flag]   Repeat this track
  <float> [flag]   Restore _previous_ track 
  <float> [flag]  crossfade the two tracks.
  <float> [flag]  START_OFF
*/

void() map_changemusic_use={
  

};

/*QUAKED
  
*/
void() map_changemusic={
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  
  

};
