/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/

void(string gibname, float dm) ThrowGib ;
vector(float dm) VelocityForDamage;

vector( vector startOrg ) te_apply_wind;

void(vector org, float total) te_smoke_test;

void( vector org, vector angl, vector vel, float total, float debrType) te_debris;

void( vector org, vector angl, vector vel, float total) te_unit_dust;

void( vector org, vector angl, float total, float lifetime, float ticrate) te_small_flame_start;
void( vector org, vector angl, float total, float lifetime, float ticrate) te_med_flame_start;
void( vector org, vector angl, float total, float lifetime, float ticrate) te_big_flame_start;

void( vector org, vector angl, float hitDmg, float total) te_shield_hit_high;
void( vector org, float vecSize ) te_shield_explode;
void( vector org, float explodeSize, vector explodeColor, float debrisCount, float debrType) te_missile_explode;
void( vector explodeColor ) te_object_explode;

void( vector org, vector angl, float vecSize, vector unitMins, float left) te_foot_stomp;

void( entity source, vector org, vector angl, vector vel, string modl, float skinNum ) te_mech_piece_explode;

entity( entity targetBuilding ) te_building_fire_start;

//SFX
void() te_nav_reach;
void( float type ) te_objective_complete;
void() te_objective_failed;
void() te_mission_win;
void() te_mission_lose;
void() te_msn_boundary;
void() te_targ_kill;