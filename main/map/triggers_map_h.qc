/*
battleMETAL
Author: Peter Roohr
Date: 3/23/2018
Overview: 

sv_saveentfile console command does print out all the entities in a map to a text file, and 
changes to that text file can be loaded back into the map. Unfortunately the function prints out brush-based
trigger ents with a "model" reference that's too tightly coupled to compiled maps. Therefore to decouple triggers
from brushes, this function set exists to make triggers / map logic ents via the text file, using the builtin
vector vars .mins and .maxs 
*/

//from InitTrigger
void() map_initTrigger;

void() map_trigger_highlighthud;
void() map_trigger_multiple; 
void() map_trigger_once;
void() map_trigger_relay; 
void() map_trigger_secret;
void() map_trigger_counter;
void() map_trigger_teleport;
void() map_trigger_setskill;
void() map_trigger_hurt;
void() map_trigger_push;
void() map_trigger_changelevel;