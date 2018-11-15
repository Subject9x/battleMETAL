/*
battleMETAL
Author: Peter Roohr
Date: 3/13/2018
  mod: 11/13/2018
Overview: 
  Header for all client-related function calls. This covers
  client events like radar pings, player mech info, target info,
  as well as map object events for Nav Points etc.
*/

//Globals
//ported some vars over to CSQC
.float stat_trg_lg_hp;
.float stat_trg_ct_hp;
.float stat_trg_lt_hp;
.float stat_trg_rt_hp;
.float stat_trg_la_hp;
.float stat_trg_ra_hp;

//function headers
void() client_get_info;
void() client_get_contact;
void() client_get_hud_highlight;

void() client_event_navpoint;
void() client_event_deploypoint;
void() client_event_objective;

void() receive_ent_bindData;
