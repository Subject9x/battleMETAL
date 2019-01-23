/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/

void(string gibname, float dm) ThrowGib ;
vector(float dm) VelocityForDamage;

.float traileffectnum;  //seriously?

void(vector org, vector vel, float total) te_smoke_test;

void( vector org, vector angl, vector vel, float total, float debrType) te_debris;

void( vector org, vector angl, vector vel, float total) te_unit_dust;

void( vector org, vector angl, vector vel, float total, float lifetime, float ticrate) te_small_flame_start;
void( vector org, vector angl, vector vel, float total, float lifetime, float ticrate) te_med_flame_start;
void( vector org, vector angl, vector vel, float total, float lifetime, float ticrate) te_big_flame_start;

void( vector org, vector angl, float hitDmg, float total) te_shield_hit_high;
void( vector org, float vecSize ) te_shield_explode;

//SFX
void() te_nav_reach;
void( float type ) te_objective_complete;
void() te_objective_failed;
void() te_mission_win;
void() te_mission_lose;
void() te_msn_boundary;