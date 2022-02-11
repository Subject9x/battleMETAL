/*
battleMETAL
Author: Peter Roohr
Date: 1/26/2018
mod: 07/23/2019
Overview: 
  all the miscellaneous shared values between client and server.
*/


//============================
//   FILE PATHS           
//============================
#ifdef CSQC
string MAP_NAME;  //strips mapname global of junk
float UNLOCKED_MECHS[256];
#endif

#define PATH_DATA_MAP "maps/"
#define PATH_DATA_ANIM "anim"
#define PATH_DATA_SAVE "saves"
#define PATH_DATA_UI "ui"
#define NEWLINE "\n"

#ifdef SSQC
float FLAG_NEWGAME;
#endif

//globals
#define SAVE_FILE_NAME "save_" //bake this in cause the name shouldnt change
#ifdef SSQC
string SAVE_MAP;
string SAVE_MECHS_LIST;
string SAVE_ITEMS_ALL;
#endif
#define SAVE_FILE_EXT ".sav"

//file tags
#define SAVE_FILE_MSN_NAME "mission"
#define SAVE_FILE_MECH_LIST "mechs"
#define SAVE_FILE_ITEMS "items"
#define SAVE_FILES_POINTS "points"
#define SAVE_FILE_NEWGAME "newgame"

//============================
//   GAME MODES
//============================
#define GAMEMODE_CAMPAIGN 1
#define GAMEMODE_COOP 2
#define GAMEMODE_DM 3
#define GAMEMODE_TEAMDM 4

#ifndef MENUQC
float TEAM_SURVEST_TOTAL;  //team deathmatch
float TEAM_MILITAR_TOTAL;
#endif 

//Server Mission Status
#define MISSION_STATUS_READY  1  //server ready to start when the first player connects
#define MISSION_STATUS_ACTIVE 2  //server is running as normal
#define MISSION_STATUS_OVER   3  //sv_checkrules() hit, triggering server end func
#define MISSION_STATUS_ENDING 4  //
#define MISSION_STATUS_DONE   5

//Server Mission Results
#define MISSION_RESULT_WIN 1
#define MISSION_RESULT_FAIL 2
#define MISSION_RESULT_WIN1 3
#define MISSION_RESULT_WIN2 4
#define MISSION_RESULT_STALEMATE 5

#define SERVER_RESPAWN_COOL_CAMP 5
#define SERVER_RESPAWN_COOL_DM 15
#define SERVER_RESPAWN_COOL_COOP 7
#define SERVER_SCORE_TIME_DM 30
#define SERVER_SCORE_TIME_COOP 30

//Multiplayer Server Flags
#define SVFLAG_SPAWNFAR 1  //  pawn player farthest from other players
#define SVFLAG_POWERUP  2  //  enforce powerup sequence
#define SVFLAG_CHEATS   4  //  cheaty cheat pants
#define SVFLAG_FIREON   8  //  friendly fire on
#define SVFLAG_NOLIVES  16 //  limited lives
#define SVFLAG_NOMAP    32 //  only see yourself on tac map
#define SVFLAG_NORADAR  64 //  no radar allowed
#define SVFLAG_NOSTATUS 128 // hide player status in menus
#define SVFLAG_ITEMOVER 256 //used when world.itemOverride = 1; tells game to load the override file
#define SVFLAG_NOSAVE   512 //used when world.ignoreSave = 1; tells game to NOT save any progress to save file, world.animaticOnly will also trigger this!
#define SVFLAG_FPSONLY  1024 //disables third person / chase_active commands.

//============================
//   GAME DIFFICULTY
//============================
#define SKILL_NOV 0
#define SKILL_REG 1
#define SKILL_VET 2
#define SKILL_ELT 3
//============================
//   WORLD TYPES
//============================
#define WORLD_DESERT 0
#define WORLD_BADLND 1
#define WORLD_URBAN 2
#define WORLD_TUNDRA 3
#define WORLD_ICE 4
#define WORLD_CAVE 5
//============================
//   PARTICLE CUBE DENSITY RATIO - .Maxs_x / _VALUE
//============================
#define SHIELD_SMALL 84
#define SHIELD_MEDIUM 200
#define SHIELD_LARGE 400

#define RAD_SMALL 64
#define RAD_MEDIUM 128
#define RAD_LARGE 256

#define QUAN_SMALL 256
#define QUAN_MEDIUM 512
#define QUAN_LARGE 1024
//============================
//   OBJECTIVE STATE
//============================
#define OBJECTIVE_DISABLE 0
#define OBJECTIVE_ACTIVE 1
#define OBJECTIVE_WIN 2
#define OBJECTIVE_COMPLETE 3
#define OBJECTIVE_FAIL 4
//============================
//   PLAYER STATE ID's           
//============================
//used for client-state syncing between server and client
#define PLAYER_CONNECT  0  // Client just connected to server.
#define PLAYER_SPAWN    1  // Client has been initialized, and spawned in as observer.
#define PLAYER_BRIEF    2  // Client entered the main CSQC menu system.
#define PLAYER_DEAD     3  // player has been killed in combat.
#define PLAYER_REDEPLOY 4  // player use ClientKill().
#define PLAYER_RESPAWN  5  // player is ready to respawn from being dead.
#define PLAYER_DEBRIEF  6  // player has finished a campaign mission.
#define PLAYER_INTERMSN 7 // Client has entered an intermission event.
#define PLAYER_MENU     8  //dear galaxy, why is it so hard to summon the main menu via code? >:(

#define PLAYER_ANIM_STOP     9  // Client told to stop playing animatic.
#define PLAYER_POWERUP_BEGIN 10  // Client has spawned into their mech, and the mech is powering up.
#define PLAYER_POWERUP_END   11  // Client mech has completed powerup sequence.
#define PLAYER_ACTIVE        12  // Client is controlling mech, and may move/fire freely.
#define PLAYER_SPRINT_ON     13

#define MOVE_STAND      0
#define MOVE_DEAD       1  //
#define MOVE_NORM       2  //normal walking without +button8
#define MOVE_SPRINT     3  // Client has engaged the 'sprint' 
#define MOVE_RAM_ON     4
#define MOVE_RAM_CHARGE 5
#define MOVE_RAM_COOL   6

//MOVE / UNIT DATA MODALS as bitflags
//float MOVE_STAND            = 0;  //  declared in AI API
#define MV_DEAD 1
#define MV_NORM 2
#define MV_SPRINT 4
#define MV_RAM_ON 8
#define MV_RAM_CHARGE 16
#define MV_RAM_COOL 32
#define MV_CHASE_ON 64
#define MV_RADAR_ACTIVE 128
//float MOVE_DEAD = 256;
//============================
//         DATA_TYPE           
//============================
#define GAME_TOTAL_MECHS 256  //how many distinct mechs the game should assume might exist for UI / unit data purposes
#define GAME_TOTAL_ITEMS 64 //how many distinct mechs the game should assume might exist for UI / unit data purposes
  //don't mess with this really unless...no just don't mess with it.
#define DATA "data"
#define DATA_POBS       1 //player observer mode
#define DATA_MECH       2
#define DATA_VEHC       3
#define DATA_WEPN       4
#define DATA_PROJ       5
#define DATA_HUD        6
#define DATA_BLD        7
#define DATA_NAVP       8
#define DATA_OBJT       9
#define DATA_NODE       10
#define DATA_DEPL       11
#define DATA_PCL_CUBE   12
#define DATA_INFO_START 13  //used to send clientdata entity to csqc
#define DATA_INFO_COOP  14  //used as ID for info_start_coop
#define DATA_MAP_DMG    15
#define DATA_MAP_RULES  16

//============================
//     UNIT PART BITS          
//============================
//These should have been floats from the start
//these are component id's (compid) for model pieces
#define MECH_PIECE "mech_piece"
#define M_UNIT       1
#define M_TOR_CENTER 2

#define M_TOR_RIGHT  4
#define M_TOR_LEFT   8
#define M_ARM_LEFT   16
#define M_ARM_RIGHT  32
#define M_LEGS       64

#define M_REPAIR     128  //sends repair flag over network to repair pieces
#define M_ITEM       256
//============================
//     WEAPON SLOT BITS           
//============================
#define WEAPON1 1
#define WEAPON2 2
#define WEAPON3 4
#define WEAPON4 8
#define WEAPON5 16
#define WEAPON6 32
#define WEAPON7 64
#define WEAPON8 128
#define WEAPON9 256
//============================
//     COMBAT STATS
//============================
#define POSITION_FADE_TIME 1
#define MAX_VEHICLE_SIZE 4
#define FALL_THRESHOLD 200
#define FALL_DMG_MULTIPLIER 2
#define FALL_CT_MULTIPLIER 3
#define FALL_KILL_MULTIPLIER 3 
#define FALL_DAMAGE_FRACTION 0.2
#define SHIELD_DELAY 5 //game timer to pause before shields are brought backonline
#define CHAIN_FIRE_INTERVAL 0.15

#define DMG_TORSO_CRIT_MULTI 1.5 // t_damage() - line 124, damage multiplier when mechs have torsos destroyed.
#define DMG_FRIENDLY_FIRE_REDUCE 0.67  // t_damage() - line 35, damage reduction for friendly fire when the flag is on.
#define DMG_FRIENDLY_FIRE_REDUCE_SKILL 0.33

#define MOVE_RAM_SCALAR_UP 0.004
#define MOVE_RAM_SCALAR_DN 0.01
//============================
//     WEAPON FLAGS
//============================
//Primary Damage Types
  #define DMG_BAL 1  //ballstic damage
  #define DMG_ENE 2  //energy damage
  #define DMG_EXP 4  //explosive damage
  #define DMG_MSC 8  //used for equipment modules
//Secondary Effect Types
  #define EFF_PRC 16 //
  #define EFF_RAM 32 //
  #define EFF_STX 64 //damage only affects shields.
  #define EFF_ENE 128 //weapon draws energy (client-side flag, really)
  
  #define EFF_ARC 256  //AI-ONLY: weapon has an arcing projectile
  #define EFF_LOK 512  //AI-ONLY: weapon requires a target lock
  #define EFF_PTR 1024 //AI-ONLY: weapon follow's unit's laser-dot, so it ignores accuracy mechanics
  #define EFF_SHD 2048 //for when you want Shield crits but not just shield-only damage of EFF_STX (see light_laser)
//Weapon Sizes
  #define BAL1 1
  #define BAL2 2
  #define BAL3 4
  #define BAL4 8
  
  #define ENE1 16
  #define ENE2 32
  #define ENE3 64
  #define ENE4 128
  
  #define MIS1 256
  #define MIS2 512
  #define MIS3 1024
  #define MIS4 2048
  
  #define MSC1 4096
  #define MSC2 8192
  #define MSC3 16384
  #define MSC4 32768
  
  //primarily for non-player units
  #define EQP_ALL 65535
//============================
//     GETSTAT() TYPES
//============================
float AS_STRING = 1;
float AS_FLOAT = 2;
float AS_INT = 8;
//============================
//     SEND ENTITY SHARED
//============================
//SendTypes-------------------
#define SENDTYPE_PLAYER 1
#define SENDTYPE_MECH_AI 2
#define SENDTYPE_TANK 3
#define SENDTYPE_SPG 4
#define SENDTYPE_GEV 5
#define SENDTYPE_MECH 6
#define SENDTYPE_TURRET 7
#define SENDTYPE_BUILD 8
#define SENDTYPE_CHUNK 9 //Vehicle / Turret / Mech debris
#define SENDTYPE_PROJ 10  //projectiles - missiles, etc
#define SENDTYPE_MAP 11
#define SENDTYPE_TERRAIN 12
#define SENDTYPE_MISC 13
#define SENDTYPE_MISC_BLD 14
//SendFlags-------------------
//note: sendEnt is capped to 7 bitflags + NEWENT 
//      and uses WriteByte, to add more flags, try switching
//      to WriteShort for ChangeFlags if you want to increase total SENDFLAG size.
#define SENDFLAG_MOVE 1  //update .origin and .angles of main piece 
#define SENDFLAG_TURRET 2 //unit's turret entity has rotated angle.
#define SENDFLAG_VELOCITY 4 //unit is stood up by server
#define SENDFLAG_DEAD 8 //marks as dead, run death anim.
#define SENDFLAG_CRIT  16 //what component(s) blew off.
#define SENDFLAG_BURN  32 //what is starting to burn.
#define SENDFLAG_IMPACT  64 //specifically missile strike on something.
#define SENDFLAG_NEWENT  128  //engine-set value, do not modify
  //128 is hardcoded as isNew, dont change
  //.modelindex
  //.faction
  //.data_type
  //.data_idx
//expanded flags, WriteByte upped to WriteLong?
#define SENDFLAG_CAMERA  256    //third person delta
#define SENDFLAG_RADAR   512    //radar mode delta
#define SENDFLAG_ATTACK  1024  //attack trigger
#define SENDFLAG_SHIELD  2048  //shield change delta
#define SENDFLAG_ENERGY  4096  //energy change delta.
#define SENDFLAG_TARGET  8192  //target change delta.
#define SENDFLAG_EFLAGS  16384  //client .flags delta.
#define SENDFLAG_COLORS  32768  //player changed colors
#define SENDFLAG_NEWUNIT 65536 //players go from non-mech to mech
#define SENDFLAG_EXDATA  131072 //any additional info an ent wants to send (usually custom per class)
#define SENDFLAG_FACTION 262144 //this should have been its own long ago.
#define SENDFLAG_ANGLE   524288 //specifically .angles / .v_angle 
#define SENDFLAG_VOICE   1048576 //when an AI wants to emit a radio sound;
//============================
//     COMMON SPAWNFLAGS
//============================
#define START_OFF 1        //only activated by trigger
#define LIFETIME 2         //lifetime
#define REACTIVATE 4       //reactivate after countdown
#define REMOVE_FIRSTUSE 8  //remove after first countdown
#define REMOVE_ONTOUCH 16  //remove on first touch

#define BUILDING_TARGET_FLAG 16 //used by building and misc_building for allowing self to be targeted

#define ACTIVE_ONTOUCH 32  //activate on-touch
#define MUTE_ME 1048576    //ai ignores sending voice effects / radio sounds.
#define NO_DROP 262144 //don't drop bot/buildingto the floor onspawn
#define IS_MAPKEY 4194304  //mark's this entity on player's briefing map.
#define IS_VIP 8388608     //faction-allied player will be notified of this entity's state
//============================
//     SHARED STATS         
//============================
#define RADAR_SWEEP 2.5

.float stat_rdr_mode;
#ifdef SSQC
.float playerState;
.float stat_client_energy;
.float stat_client_shield;

.float stat_target_shield;

.float stat_target_hp_torsoCenter;
.float stat_target_hp_torsoLeft;
.float stat_target_hp_torsoRight;
.float stat_target_hp_armLeft;
.float stat_target_hp_armRight;
.float stat_target_hp_legs;

.float stat_client_hp_torsoCenter;
.float stat_client_hp_torsoLeft;
.float stat_client_hp_torsoRight;
.float stat_client_hp_armLeft;
.float stat_client_hp_armRight;
.float stat_client_hp_legs;

.float targetEntId;
.float targetEntIdPrev;
.float stat_trg_dataidx;

.float stat_trg_dataType;

.float stat_trg_faction;

.float stat_hit_dirs;
.float stat_rdr_rng;
.float stat_trg_dist;
.float stat_trg_face;

.float stat_plr_fir;
.float targLockState;
.float stat_trg_ddflg;
.float stat_ret_dist;

.float stat_plr_rep;
.string stat_target_name;

.float statWeaponReload1;
.float statWeaponReload2;
.float statWeaponReload3;
.float statWeaponReload4;
.float statWeaponReload5;
.float statWeaponReload6;
.float statWeaponReload7;
.float statWeaponReload8;
.float statWeaponReload9;

.float statTargetHitParts;

#endif
//============================
//     ADDSTAT SLOT NUMBERS        
//============================
//float    = 32;
//float    = 33;
float STAT_RAM = 34;
float STAT_TARGET_HIT_PARTS = 35;
//float    = 36;
//float    = 37;
float STAT_PLAYER_STATE = 38;
//float    = 39;
//float    = 40;
//float    = 41;
//float    = 42;
//float    = 43;
//float    = 44;
//float    = 46;
//float    = 47;
float STAT_PLR_HITDIR = 48;
float STAT_PLR_RETDIST = 49;
//float    = 50;
//float    = 53;
//float    = 54;
//float    = 55;
//float     = 56;
//float    = 57;
float STAT_TARGET_HP_TORSOCENTER = 61;
float STAT_TARGET_HP_TORSOLEFT = 62;
float STAT_TARGET_HP_TORSORIGHT = 63;
float STAT_TARGET_HP_ARMLEFT = 64;
float STAT_TARGET_HP_ARMRIGHT = 65;
float STAT_TARGET_HP_LEGS = 66;

float STAT_CLIENT_HP_TORSOCENTER = 67;
float STAT_CLIENT_HP_TORSOLEFT = 68;
float STAT_CLIENT_HP_TORSORIGHT = 69;
float STAT_CLIENT_HP_ARMLEFT = 70;
float STAT_CLIENT_HP_ARMRIGHT = 71;
float STAT_CLIENT_HP_LEGS = 72;
//float   = 73;
//float   = 74;
//float   = 75;
//float   = 76;
//float    = 77;
//float    = 78;
float STAT_RAM_VALUE = 79;
//float STAT_LCK_STT = 80;  //2.0.0: lock-on not timer-based anymore

float STAT_WEAPON_RELOAD_1 = 81;
float STAT_WEAPON_RELOAD_2 = 82;
float STAT_WEAPON_RELOAD_3 = 83;
float STAT_WEAPON_RELOAD_4 = 84;
float STAT_WEAPON_RELOAD_5 = 85;
float STAT_WEAPON_RELOAD_6 = 86;
float STAT_WEAPON_RELOAD_7 = 87;
float STAT_WEAPON_RELOAD_8 = 88;
float STAT_WEAPON_RELOAD_9 = 89;
//float    = 90;

//float    = 91;
//float    = 100;
//float    = 101;
//float    = 102;
float STAT_PLR_REP = 103; //remaining repair delta
//104;

//============================
//  Server<->Client string message layer
//    use agreed upon common 
//============================
//Response Schema
#define RSP_SRC "src"
#define RSP_TYPE "type"
#define RSP_CID "client"
#define RSP_BODY "body"
//Response SOURCE   
#define SV_PRINT "svpr"
#define CS_PRINT "cspr"
//Response TYPES    
#define SAY_MSG1 "msg1"
#define SAY_MSG2 "msg2"
#define SV_CL_CONN "signon"
#define SV_CL_KSELF "lame"
#define SV_CL_DSCON "signoff"

//============================
//     LOCK STATES   
//============================
#define LOCK_NONE 1
#define LOCK_TARG_START 2
#define LOCK_TARG_HAS 4
#define LOCK_PLAYER 8

//============================
//     HIT DIRECTION FLAGS 
//============================
#define STAT_HIT_CL 1
#define STAT_HIT_LF 2
#define STAT_HIT_RT 4
#define STAT_HIT_BK 8
#define STAT_HIT_TRG 16

//============================
//     PLAYER POWER UP TIME  
//============================
#define POWERUP_DEFAULT 7
#define POWERUP_DEBUG 0.01

//============================
//     UNIT ACCURACY PROFILES
//============================
vector ACCURACY_SNIPER      = '0.05 0.33 0.002';
vector ACCURACY_MARKSMAN    = '0.15 0.48 0.005';
vector ACCURACY_SKIRMISH    = '0.25 0.63 0.01';
vector ACCURACY_LOWTECH     = '0.35 0.78 0.0075';
vector ACCURACY_PRIMITVE    = '0.45 0.93 0.001';

//============================
//     FACTIONS
//============================
#define FACTION_PSC 1
#define FACTION_SURVEST 2
#define FACTION_MILITAR 3
#define FACTION_ALL 255 //buildings don't show up on radar, deploy and nav points are rendered to everyone.

//============================
//     SHIELD HIT FLAGS
//============================
//directs the client to choose the correct color / and shield state for an entity.
#define SHIELD_HIT_REG 1  //tells client that entity's shields are hit, but currently up
#define SHIELD_HIT_EMP 2  //entity hit with EMP round, color differently for readability.
#define SHIELD_HIT_EXP 4  //entity shields have just gone down, cue explosion.
#define SHIELD_HIT_IXP 5  //EMP-based shield explosion.

//============================
//     AI VOICE SYSTEM
//============================
//Voice group IDs
#define AI_VOICE_GROUP_A 2
#define AI_VOICE_GROUP_B 3
#define AI_VOICE_GROUP_C 1
#define AI_VOICE_DEAD       0
#define AI_VOICE_DYING      1
#define AI_VOICE_HELP       2
#define AI_VOICE_HUNT_END   3
#define AI_VOICE_HUNT_START 4
#define AI_VOICE_KILL       5
#define AI_VOICE_NOSPOT     6
#define AI_VOICE_ROGER      7
#define AI_VOICE_SPOTTED    8
#define AI_VOICE_WARN       9


//============================
//     CLIENT INFO STRING
//      sent by player when choosing items.
//============================
/*
  info string management bitflag
  entire invoke is 
    cmd client <changeflags> <infostring>
    
*/
#define INFO_FLAG_FACTION 512
#define INFO_FLAG_MECH   1024
#define INFO_FLAG_SPAWN  2048
#define INFO_FLAG_COLOR  4096
#define INFO_FLAG_GROUPS 8192
#define INFO_FLAG_DEPLOY 16384
// WEAPON flags inherit / interoperable with WEAPON1-9 enums above.
/*
  Info string arch - this is sent to the server
  key     | value
  -----------
  spawn   | float
  fac | float
  col1  | float
  col2  | float
  col3  | float
  col4  | float
  col5  | float
  col6  | float
  mech    | float
  grp1   | float
  grp2   | float
  grp3  | float
  grp4   | float
  w1    | float
  w2    | float
  w3    | float
  w4    | float
  w5    | float
  w6    | float
  w7    | float
  w8    | float
  w9    | float
*/
#define CMD_CLIENT_INFO "client"
#define KEY_FLAGS "flags"
#define KEY_DEPLOY "deploy"
#define KEY_FACTION "fac"
#define KEY_COLOR1 "col1"
#define KEY_COLOR2 "col2"
#define KEY_COLOR3 "col3"
#define KEY_COLOR4 "col4"
#define KEY_COLOR5 "col5"
#define KEY_COLOR6 "col6"
#define KEY_MECH   "mech"
#define KEY_GROUP1 "grp1"
#define KEY_GROUP2 "grp2"
#define KEY_GROUP3 "grp3"
#define KEY_GROUP4 "grp4"
#define KEY_WEPN1 "w1"
#define KEY_WEPN2 "w2"
#define KEY_WEPN3 "w3"
#define KEY_WEPN4 "w4"
#define KEY_WEPN5 "w5"
#define KEY_WEPN6 "w6"
#define KEY_WEPN7 "w7"
#define KEY_WEPN8 "w8"
#define KEY_WEPN9 "w9"
#define KEY_SPAWN "spawn"