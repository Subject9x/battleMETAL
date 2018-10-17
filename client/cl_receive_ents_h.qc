/*
mech Mod
Author: Peter Roohr
Date: 3/13/2018
Overview: header for all reception of SendEntity calls made by
server.
*/

//ported some vars over to CSQC
.float stat_trg_lg_hp;
.float stat_trg_ct_hp;
.float stat_trg_lt_hp;
.float stat_trg_rt_hp;
.float stat_trg_la_hp;
.float stat_trg_ra_hp;

void() client_get_info;
void() client_get_contact;
void() client_get_hud_highlight;

void() client_event_navpoint;
void() client_event_deploypoint;
void() client_event_objective;

void() receive_ent_bindData;