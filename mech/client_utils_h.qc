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
//void(float w_id, float wslotid) client_updateWeaponIdStat;
