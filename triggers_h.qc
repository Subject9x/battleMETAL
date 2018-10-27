/*
mech Mod
Author: Peter Roohr
Date: 11/18/2017
Overview: time to parse trigger functions to their own header file.
*/
//TRIGGER CONST
entity stemp, otemp, s, old;

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

float	PLAYER_ONLY	= 1;
float	SILENT = 2;

float PUSH_ONCE = 1;

/*
  Trigger Event Harness
    each of these is like a tailored 'target' var that is fired
    at the appropriate time.
*/
.string onDeath;
.string onSpawn;
.string onDamage;
.string onPanic;
.string onAttack;

void( entity active, .string event ) trigger_event;

//TRIGGER UTILS
void() multi_wait;
void() multi_trigger;
void() multi_killed;
void() multi_use; 
void() multi_touch; 
void() counter_use;

void() play_teleport;
void(vector org) spawn_tfog;
void() tdeath_touch; 
void(vector org, entity death_owner) spawn_tdeath;
void() teleport_touch; 
void() teleport_use;

void() info_teleport_destination;

void() trigger_onlyregistered_touch;

void() hurt_on;
void() hurt_touch;

void() trigger_monsterjump_touch;

void() highlight_hud_touch;

//ACTUAL TRIGGERS
void() trigger_reactivate;
void() trigger_multiple; 
void() trigger_once;
void() trigger_relay;
void() trigger_secret;
void() trigger_counter;
void() trigger_teleport;
void() trigger_skill_touch;
void() trigger_setskill;
void() trigger_onlyregistered;
void() trigger_hurt;
void() trigger_push_touch;
void() trigger_push;
void() trigger_monsterjump;

void() trigger_highlighthud;
void() trigger_activate_node;