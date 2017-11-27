/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: function extensions to world.qc
*/

.string msn_file;

void() mh_world_ini;
void() mh_world_iniData;

void(float wep_id) data_iniWep;
void(float build_id) data_iniBuilding;
void(float mech_id) data_iniMech;
void(float prj_id) data_iniProjectile;

entity(float id, float dat_type) mh_world_findData;
entity(float sz, float id) m_findMechData;
void(float fwd, float side, float bck, string accel, string roll) mh_world_updateClientSpeed;
void(string bob, string cycle, string up) mh_world_updateClientViewBob;
void(string bobmodel, string side, string bmod_speed) mh_world_updateClientModelBob;
void(string p_max, string p_min) mh_world_updateClientViewPitch;