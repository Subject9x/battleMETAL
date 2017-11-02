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

//SendEnt
float(entity ent, float changed) send_vehicle;
float(entity ent, float changed) send_building;
float(entity ent, float changed) send_ai_mech;

//client command layer
void(string cmd, float tokens) client_ParseMechCommand;
void(string cmd, float tokens) client_setWeapon;
void(string cmd, float tokens) client_setWeaponGroup;
void() client_sendMissionFileName;
void(string cmd, float tokens) client_setNavPoint;
void() client_updateWeaponReloads;
float(float val, float rel, float wpn_rel, float rdy, float bit)client_incrementReload;
void() client_sendAvailableLightMechs;
void() client_sendAvailableMediumMechs;
void() client_sendAvailableHeavyMechs;