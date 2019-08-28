/*
battleMETAL
Author: Peter Roohr
Date: 5/10/2017
Overview: definitions for terrains and their effects
*/

//search terrain name for this guy
string TERRAIN_TAG_CONCRETE = "tc";
string TERRAIN_TAG_METAL = "tm";
string TERRAIN_TAG_SAND = "ts";
string TERRAIN_TAG_SNOW = "to";
string TERRAIN_TAG_MUD = "tu";
string TERRAIN_TAG_WATER = "ta";
string TERRAIN_TAG_ICE = "ti";


//bits for constructing terrain modifiers
float TERRAIN_MOD_SLIDE = 1;  //unit will slide to a certain degree
float TERRAIN_MOD_SLOW = 2;   //unit's top speed hampered by a percentage
float TERRAIN_MOD_DRAIN = 4;  //unit's energy is drained at a specified rate
float TERRAIN_MOD_DAMAGE = 8; //unit will receive damage from this
float TERRAIN_MOD_MELT = 16;  //unit will take catastrophic damage
float TERRAIN_MOD_STATIC = 24;//unit's shields inhibited

//mod rates
float TERRAIN_SNOW_SLIDE = 0.04;
float TERRAIN_SNOW_SLOW = 0.04;
