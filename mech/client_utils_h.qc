/*
mech Mod
Author: Peter Roohr
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
void() spawnpoint_select;
void() spawnpoint_Random;
entity() spawnpoint_coop;
entity() spawnpoint_single;

//SendEnt
void() client_push_player_info;
void( entity targetClient) server_push_player_info; //simply wraps client_push_player_info()
void( entity radarPing ) client_push_radar_ping;
void( entity targetClient ) client_push_hud_highlight;

//client command layer
void( float track, float loop) client_playTrack;
void(string cmd, float tokens) client_ParseMechCommand;
void(string cmd, float tokens) client_setWeapon;
void(string cmd, float tokens) client_setWeaponGroup;
void() client_sendMissionFileName;
void(string fileName) client_sendAnimaticFileName;
void(string cmd, float tokens) client_setNavPoint;
void() client_updateWeaponReloads;
void(string mechs) client_sendAvailableLightMechs;
void(string mechs) client_sendAvailableMediumMechs;
void(string mechs) client_sendAvailableHeavyMechs;
void(string itms) client_sendAvailableItems;
void(float mode) client_sendGameMode;