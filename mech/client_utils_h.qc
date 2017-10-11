/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: client utility methods, pulled from client.qc
this is the header.
*/
/*
  ENGINE CONSTANTS
*/
void() SetChangeParms;
void() SetNewParms;
void() DecodeLevelParms;
void() respawn;
entity() SelectSpawnPoint;
//==========================


//legacy wrappers
void() legacy_PlayerDie;

//spawn spot wrappers
void() spawnpoint_Random;

//client command layer
void(string cmd, float tokens) client_ParseMechCommand;
void(string cmd, float tokens) client_setWeapon;
void(string cmd, float tokens) client_setWeaponGroup;
void() client_sendMissionFileName;
void(string cmd, float tokens) client_setNavPoint;
void() client_updateWeaponReloads;
float(float val, float rel, float wpn_rel, float rdy, float bit)client_incrementReload;
//void(float w_id, float wslotid) client_updateWeaponIdStat;
void() client_sendAvailableLightMechs;
void() client_sendAvailableMediumMechs;
void() client_sendAvailableHeavyMechs;
void(vector pos, vector sz, vector clr, float life) client_highlightUI;