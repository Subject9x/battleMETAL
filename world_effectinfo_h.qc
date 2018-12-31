/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/

.float traileffectnum;  //seriously?

void(vector org, vector vel, float cnt) te_smoke_test;
void(vector org, vector angl) te_shield_test;
void(vector org, float total) te_heat_small;

//SFX
void() te_nav_reach;
void( float type ) te_objective_complete;
void() te_objective_failed;
void() te_mission_win;
void() te_mission_lose;
void() te_msn_boundary;