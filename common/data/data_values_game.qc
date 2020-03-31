/*
battleMETAL
Author: Peter Roohr
Date: 1/26/2018
mod: 07/23/2019
Overview: 
  all the miscellaneous shared values between client and server.
*/

void( ) FRIK_FILE_precaches =
{
	local float f;                                      // file handle, basically assigns a number to whatever file is open
	local string ln;                                    // ln = line of the file being read
	f = fopen("cache/precache_server.txt" , FILE_READ);        // opens "data/precache.txt" to be read
	if (f != -1){                                        // if f = -1 then the file could not be found
		ln = fgets(f);                              // this line sets ln to the string read from the file with the file handle of f
    
    while( ln != "EOF" ){                     // while there is still text to be read do the following
      dprint(strcat("line value (",ln,")\n"));  //DEBUG
      if( ln != "" && substring(ln,0, 2) != "//" ){
        dprint(strcat("loaded [",ln,"]\n"));  //DEBUG
        if(strstrofs(ln, ".wav",0) != -1)   // this checks if the file extension is .wav for a sound file
        {
          precache_sound(ln);         // if it is a sound, then it precaches said sound
        }
        else if(strstrofs(ln, ".ogg",0) != -1){
          precache_sound(ln);
        }
        else if(strstrofs(ln, ".md3",0) != -1){
          precache_model(ln);         // so precache the model
        }
        else if( strstrofs(ln, ".obj", 0) != -1){
          precache_model(ln);
        }
        else if( strstrofs(ln, ".bsp", 0) != -1){
          precache_file(ln);
        }
      }
			ln = fgets(f);                      // get a new line from the file
		}
    fclose(f);                                          // when the while loop is over (no lines left in file) close file with the handle f    
	} 
};
//============================
//   FILE PATHS           
//============================
#ifdef CSQC
string MAP_NAME;  //strips mapname global of junk
float UNLOCKED_MECHS[256];
#endif
string PATH_DATA_MAP = "map_scripts";
string PATH_DATA_ANIM = "anim";
string PATH_DATA_SAVE = "saves";
string PATH_DATA_UI = "ui";
string NEWLINE = "\n";
float FLAG_NEWGAME;
//============================
//   GAME MODES
//============================
float GAMEMODE_CAMPAIGN = 1;
float GAMEMODE_COOP = 2;
float GAMEMODE_DM = 3;
float GAMEMODE_TEAMDM = 4;
//============================
//   GAME DIFFICULTY
//============================
float SKILL_NOV = 0;
float SKILL_REG = 1;
float SKILL_VET = 2;
float SKILL_ELT = 3;
//============================
//   WORLD TYPES
//============================
float WORLD_DESERT = 0;
float WORLD_BADLND = 1;
float WORLD_URBAN = 2;
float WORLD_TUNDRA = 3;
float WORLD_ICE = 4;
float WORLD_CAVE = 5;
//============================
//   PARTICLE CUBE DENSITY RATIO - .Maxs_x / _VALUE
//============================
float SHIELD_SMALL = 84;
float SHIELD_MEDIUM = 200;
float SHIELD_LARGE = 400;

float RAD_SMALL = 64;
float RAD_MEDIUM = 128;
float RAD_LARGE = 256;

float QUAN_SMALL = 256;
float QUAN_MEDIUM = 512;
float QUAN_LARGE = 1024;
//============================
//   OBJECTIVE STATE
//============================
float OBJECTIVE_DISABLE = 0;
float OBJECTIVE_ACTIVE = 1;
float OBJECTIVE_WIN = 2;
float OBJECTIVE_COMPLETE = 3;
float OBJECTIVE_FAIL = 4;
//============================
//   PLAYER STATE ID's           
//============================
float PLAYER_DEAD = -1;         // 
float PLAYER_CONNECT = 0;       // Client just connected to server.
float PLAYER_SPAWN = 1;         // Client has been initialized, and spawned in as observer.
float PLAYER_IN_MENU = 2;       // Client is in the CSQC menu system.
float PLAYER_POWERUP_BEGIN = 3; // Client has spawned into their mech, and the mech is powering up.
float PLAYER_POWERUP_END = 4;   // Client mech has completed powerup sequence.
float PLAYER_ACTIVE = 5;        // Client is controlling mech, and may move/fire freely.
float PLAYER_ANIM_STOP = 6;     // Client told to stop playing animatic.
float PLAYER_SPRINT_ON = 7;     // Client has engaged the 'sprint' button.
float PLAYER_INTERMSN = 8;      // Client has entered an intermission event.
//============================
//         DATA_TYPE           
//============================
float GAME_TOTAL_MECHS = 256; //how many distinct mechs the game should assume might exist for UI / unit data purposes
float GAME_TOTAL_ITEMS = 64; //how many distinct mechs the game should assume might exist for UI / unit data purposes
  //don't mess with this really unless...no just don't mess with it.
string DATA = "data";
float DATA_POBS = 1; //player observer mode
float DATA_MECH = 2;
float DATA_VEHC = 3;
float DATA_WEPN = 4;
float DATA_PROJ = 5;
float DATA_HUD = 6;
float DATA_BLD = 7;
float DATA_NAVP = 8;
float DATA_OBJT = 9;
float DATA_NODE = 10;
float DATA_DEPL = 11;
float DATA_WEAPON = 12;
float DATA_INFO_START = 13;//used to send clientdata entity to csqc
float DATA_INFO_COOP = 14;  //used as ID for info_start_coop
float DATA_MAP_OBJ = 15; //meh, mostly for map objects (mapKeys :/ )
float DATA_MAP_DMG = 16;

//============================
//     UNIT PART BITS          
//============================
//These should have been floats from the start
//these are component id's (compid) for model pieces
string MECH_PIECE    = "mech_piece";
float M_UNIT        = 1;
float M_TOR_CENTER  = 2;
float M_TOR_RIGHT   = 4;
float M_TOR_LEFT    = 8;
float M_ARM_LEFT    = 16;
float M_ARM_RIGHT   = 32;
float M_LEGS        = 64;
float M_CAMERA      = 128;
float M_LEG_L       = 256;
float M_LEG_R       = 512;
float M_ITEM        = 1024;
//============================
//     WEAPON SLOT BITS           
//============================
float WEAPON1 = 1;
float WEAPON2 = 2;
float WEAPON3 = 4;
float WEAPON4 = 8;
float WEAPON5 = 16;
float WEAPON6 = 32;
float WEAPON7 = 64;
float WEAPON8 = 128;
float WEAPON9 = 256;
//============================
//     COMBAT STATS
//============================
float MAX_VEHICLE_SIZE = 4;
float FALL_THRESHOLD = 200;
float FALL_DMG_MULTIPLIER = 2;
float FALL_CT_MULTIPLIER = 3;
float FALL_KILL_MULTIPLIER = 3; 
float FALL_DAMAGE_FRACTION = 0.2;
float SHIELD_DELAY = 5; //game timer to pause before shields are brought backonline
float EVADE_DRAIN_PERCENT = 0.33;  //reduce energyRate by this % when unit is Evading
float CHAIN_FIRE_INTERVAL = 0.15; 
//============================
//     WEAPON FLAGS
//============================
//Primary Damage Types
  float DMG_BAL = 1;  //ballstic damage
  float DMG_ENE = 2;  //energy damage
  float DMG_EXP = 4;  //explosive damage
  float DMG_MSC = 8;  //used for equipment modules
//Secondary Effect Types
  float EFF_PRC = 16; //dmg is doubled
  float EFF_RAM = 32; //DMG_ENE + RAM = feedback damage onto target.
  float EFF_STX = 64; //damage only affects shields.
  float EFF_ENE = 128; //weapon draws energy (client-side flag, really)
  
  float EFF_ARC = 256;  //AI-ONLY: weapon has an arcing projectile
  float EFF_LOK = 512;  //AI-ONLY: weapon requires a target lock
  float EFF_PTR = 1024; //AI-ONLY: weapon follow's unit's laser-dot, so it ignores accuracy mechanics
  float EFF_SHD = 2048; //for when you want Shield crits but not just shield-only damage of EFF_STX (see light_laser)
//============================
//     GETSTAT() TYPES
//============================
float AS_STRING = 1;
float AS_INT = 2;
float AS_FLOAT_TRUNCATED = 2;
float AS_FLOAT = 8;
//============================
//     SEND ENTITY SHARED
//============================
//SendTypes-------------------
float SENDTYPE_PLAYER = 1;
float SENDTYPE_MECH_AI = 2;
float SENDTYPE_TANK = 3;
float SENDTYPE_SPG = 4;
float SENDTYPE_GEV = 5;
float SENDTYPE_MECH = 6;
float SENDTYPE_TURRET = 7;
float SENDTYPE_BUILD = 8;
float SENDTYPE_CHUNK = 9; //Vehicle / Turret / Mech debris
float SENDTYPE_PROJ = 10;  //projectiles - missiles, etc
float SENDTYPE_MAP = 11;
//SendFlags-------------------
float SENDFLAG_MOVE = 1;  //update .origin and .angles of main piece 
float SENDFLAG_TURRET = 2; //unit's turret entity has rotated angle.
float SENDFLAG_VELOCITY = 4; //unit is stood up by server
float SENDFLAG_DEAD = 8; //marks as dead, run death anim.
float SENDFLAG_CRIT = 16; //what component(s) blew off.
float SENDFLAG_BURN = 32; //what is starting to burn.
float SENDFLAG_IMPACT = 64; //specifically missile strike on something.
float SENDFLAG_NEWENT = 128;
  //128 is hardcoded as isNew, dont change
  //.modelindex
  //.faction
  //.data_type
  //.data_idx


//============================
//     SHARED STATS         
//============================
float RADAR_SWEEP = 2.5;

.float stat_rdr_mode;
#ifndef CSQC
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

.float stat_w1_id;
.float stat_w2_id;
.float stat_w3_id;
.float stat_w4_id;
.float stat_w5_id;
.float stat_w6_id;
.float stat_w7_id;
.float stat_w8_id;
.float stat_w9_id;

.float stat_w1_rel;
.float stat_w2_rel;
.float stat_w3_rel;
.float stat_w4_rel;
.float stat_w5_rel;
.float stat_w6_rel;
.float stat_w7_rel;
.float stat_w8_rel;
.float stat_w9_rel;

.float stat_trg_ent_id;
.float stat_trg_dataidx;
.float stat_trg_dat;
.float stat_trg_faction;

.float stat_hit_dirs;
.float stat_rdr_rng;
.float stat_trg_dist;
.float stat_trg_face;

.float stat_plr_fir;
.float stat_lck_stt;
.float stat_trg_ddflg;
.float stat_ret_dist;

.float addStat_targetSize_x;
.float addStat_targetSize_y;
.float addStat_targetSize_z;
.float stat_plr_rep;
.float stat_player_weapons_state;
.string stat_target_name;

.float stat_target_orgx;
.float stat_target_orgy;
.float stat_target_orgz;
.float stat_target_size;
#endif
//============================
//     ADDSTAT SLOT NUMBERS        
//============================
float STAT_PLAYER_DEADFLAG = 32;
float STAT_ACCURACY = 33;
float STAT_RAM = 34;
float STAT_CLIENT_ENERGY = 35;
float STAT_CLIENT_SHIELD = 36;
float STAT_RAM_MAX = 37;
//38;
float STAT_PLAYER_WEAPONS_STATE = 39;

//40;
//41;
//42;
//43;
float STAT_PLAYER_DATA_TYPE = 44;
float STAT_PLR_DATA_IDX = 46;
float STAT_PLR_RADMOD = 47;
float STAT_PLR_HITDIR = 48;
float STAT_PLR_RETDIST = 49;

float STAT_TRG_ENT_ID = 50;
float STAT_TRG_DATATYPE = 53;
float STAT_TRG_DATAIDX = 54;
float STAT_TRG_DIST = 55;
float STAT_TRG_FACE = 56;
float STAT_TRG_FACTION = 57;

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

float STAT_TARGET_SHIELDS = 73;
float STAT_TARGET_NAME = 74;
float STAT_TARGET_ORIGINX = 75;
float STAT_TARGET_ORIGINY = 76;
float STAT_TARGET_ORIGINZ = 77;
float STAT_TARGET_SIZE = 78;

float STAT_RAM_VALUE = 79;
float STAT_LCK_STT = 80;
float STAT_TRG_DDFLG = 81;

float STAT_CLIENT_WEAPON1_RELOAD = 82;
float STAT_CLIENT_WEAPON2_RELOAD = 83;
float STAT_CLIENT_WEAPON3_RELOAD = 84;
float STAT_CLIENT_WEAPON4_RELOAD = 85;
float STAT_CLIENT_WEAPON5_RELOAD = 86;
float STAT_CLIENT_WEAPON6_RELOAD = 87;
float STAT_CLIENT_WEAPON7_RELOAD = 88;
float STAT_CLIENT_WEAPON8_RELOAD = 89;
float STAT_CLIENT_WEAPON9_RELOAD = 90;

float STAT_RAD_SWEEP = 91;
float ADDSTAT_TARGETSIZE_X = 100;
float ADDSTAT_TARGETSIZE_Y = 101;
float ADDSTAT_TARGETSIZE_Z = 102;
float STAT_PLR_REP = 103; //remaining repair delta
//104;

//============================
//     LOCK STATES   
//============================
float LOCK_NONE = 1;
float LOCK_TARG_START = 2;
float LOCK_TARG_HAS = 4;
float LOCK_PLAYER = 8;

//============================
//     HIT DIRECTION FLAGS 
//============================
float STAT_HIT_CL = 1;
float STAT_HIT_LF = 2;
float STAT_HIT_RT = 4;
float STAT_HIT_BK = 8;
float STAT_HIT_TRG = 16;

//============================
//     PLAYER POWER UP TIME  
//============================
float POWERUP_DEFAULT = 7;
float POWERUP_DEBUG   = 0.01;

//============================
//     UNIT ACCURACY PROFILES
//============================
vector ACCURACY_SKIRMISH    = '0.4 0.85 0.01';
vector ACCURACY_SNIPER      = '0.1 0.5 0.002';
vector ACCURACY_MARKSMAN    = '0.35 0.75 0.005';
vector ACCURACY_LOWTECH     = '0.5 0.9 0.0075';
vector ACCURACY_PRIMITVE    = '0.6 1 0.001';

//============================
//     FACTIONS
//============================
float FACTION_PSC = 1;
float FACTION_SURVEST = 2;
float FACTION_MILITAR = 3;
float FACTION_ALL = 255;  //buildings don't show up on radar, deploy and nav points are rendered to everyone.

//============================
//     AI VOICE SYSTEM
//============================
//Voice group IDs
float AI_VOICE_GROUP_A = 2;
float AI_VOICE_GROUP_B = 3;
float AI_VOICE_GROUP_C = 1;

float AI_VOICE_DEAD       = 0;
float AI_VOICE_DYING      = 1;
float AI_VOICE_HELP       = 2;
float AI_VOICE_HUNT_END   = 3;
float AI_VOICE_HUNT_START = 4;
float AI_VOICE_KILL       = 5;
float AI_VOICE_NOSPOT     = 6;
float AI_VOICE_ROGER      = 7;
float AI_VOICE_SPOTTED    = 8;
float AI_VOICE_WARN       = 9;