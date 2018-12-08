/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: client utility methods, pulled from client.qc
this is the header.
*/
float MSG_ENTITY = 5;
.float(entity ent, float changedflags) SendEntity;
.float SendFlags;

/*
  ENGINE CONSTANTS
*/
void() SetChangeParms;
void() SetNewParms;
void() DecodeLevelParms;
void() respawn;
entity() SelectSpawnPoint;
//==========================
float(entity piece) csqc_updateCompStat;
//legacy wrappers
void() legacy_PlayerDie;

//spawn spot wrappers
void() spawnpoint_select;
void() spawnpoint_Random;
entity() spawnpoint_coop;
entity() spawnpoint_single;

//SendEnt
void() client_push_player_info;
void( entity targetClient ) server_push_player_info; //simply wraps client_push_player_info()
void( entity radarPing ) client_push_radar_ping;
void( entity targetClient ) client_push_hud_highlight;
void( entity targetClient ) client_send_boundary_warning;

void() client_push_mapobjects;
void( entity navpoint ) client_send_navpoint;
void( entity objective ) client_send_objective;
void( entity deploy ) client_send_deploypoint;

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
void(entity client, float fogDense, vector fogColor, float fogAlpha, vector fogDist, float fogFade) client_sendFog;
void(entity client, float trackNum, float entFlags) client_sendMusic;


void(float fwd, float side, float bck, string accel, string roll) client_update_moveSpeed;
void(string bob, string cycle, string up) client_update_viewBob;
void(string bobmodel, string side, string bmod_speed) client_update_modelBob;
void(string p_max, string p_min) client_update_viewPitch;