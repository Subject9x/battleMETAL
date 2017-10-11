/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: function extensions to world.qc
*/

string SFX_MUSIC_TRACK_ONE;
.string msn_file;

void() mh_world_ini;
void() mh_world_iniData;
entity(float id, float dat_type) mh_world_findData;
entity(float sz, float id) m_findMechData;
void(float fwd, float side, float bck, string accel, string roll) mh_world_updateClientSpeed;
void(string bob, string cycle, string up) mh_world_updateClientViewBob;
void(string bobmodel, string side, string bmod_speed) mh_world_updateClientModelBob;
void(string p_max, string p_min) mh_world_updateClientViewPitch;