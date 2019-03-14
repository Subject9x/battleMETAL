/*
mech Mod
Author: Peter Roohr
Date: 1/26/2018
Overview: all the miscellaneous shared values between client and server
*/


void( ) FRIK_FILE_precaches =
{
	local float f;                                      // file handle, basically assigns a number to whatever file is open
	local string ln;                                    // ln = line of the file being read
	f = fopen("data/cache/precache_server.txt" , FILE_READ);        // opens "system/precache.txt" to be read
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
string MAP_NAME;  //strips mapname global of junk
string PATH_DATA_MAP = "map_scripts";
string PATH_DATA_ANIM = "anim";
string PATH_DATA_SAVE = "saves";
string PATH_DATA_UI = "ui";
string NEWLINE = "\n";
//============================
//   GAME MODES
//============================
float GAMEMODE_CAMPAIGN = 1;
float GAMEMODE_COOP = 2;
float GAMEMODE_DM = 3;
float GAMEMODE_TEAMDM = 4;
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
//   PLAYER STATE ID's           
//============================
float PLAYER_DEAD = -1;
float PLAYER_CONNECT = 0;
float PLAYER_SPAWN = 1;
float PLAYER_IN_MENU = 2;
float PLAYER_POWERUP_BEGIN = 3;
float PLAYER_POWERUP_END = 4;
float PLAYER_ACTIVE = 5;
float PLAYER_ANIM_STOP = 6;
float PLAYER_SPRINT_ON = 7;
float PLAYER_SPRINT_OFF = 8;
//============================
//         DATA_TYPE           
//============================
float GAME_TOTAL_MECHS = 256; //how many distinct mechs the game should assume might exist for UI / unit data purposes
float GAME_TOTAL_ITEMS = 64; //how many distinct mechs the game should assume might exist for UI / unit data purposes
float MECHLIST_TOTAL[256];
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
float DATA_PLR = 12;
float DATA_WEAPON = 13;
float DATA_INFO_START = 14; //used to send clientdata entity to csqc
float DATA_INFO_COOP = 15;  //used as ID for info_start_coop
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
float FALL_THRESHOLD = -400;  //quake has this set to 300
float FALL_DMG_MULTIPLIER = 2.5;  //fall threshold * multiplier = if legs are damaged in fall
float FALL_CT_MULTIPLIER = 3;  //fall threshold * multiplier = if center torso is damaged in fall
float FALL_KILL_MULTIPLIER = 3.5;  //fall threshold * multiplier = player killed by fall
float SHIELD_DELAY = 5;
float SHIELD_SOAK = 4;
//============================
//     WEAPON FLAGS
//============================
float DMG_BAL = 1;  //ballstic damage
float DMG_ENE = 2;  //energy damage
float DMG_EXP = 4;  //explosive damage
float EFF_PRC = 8;  //piercing damage
float EFF_RAM = 16; //dmg is doubled
float EFF_STX = 32; //dmg only affects shields
float EFF_ENG = 64; //dmg only affects energy
float DMG_MSC = 128; //designates weapon as 'equipment'
float EFF_ENE = 256; //weapon draws energy (client-side flag, really)
float EFF_ARC = 512;  //weapon has an arcing projectile, used by AI
//============================
//     SHARED STATS         
//============================
float RADAR_SWEEP = 2.5;

.float radar_time;
.float radar_range;
.float hardpoint_cnt;
.float currentWeaponGroup;
.float stat_plr_camx;
.float stat_plr_camy;
.float stat_plr_camz;
.float stat_cofs_x;
.float stat_cofs_y;
.float stat_cofs_z;
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
.float stat_rdr_mode;
.float stat_rdr_rng;
.float stat_wep_state;
.float stat_trg_dist;
.float stat_trg_face;
.float stat_wep_rel;
.float stat_spr_x;
.float stat_spr_y;
.float stat_plr_fir;
.float stat_lck_stt;
.float stat_trg_ddflg;
.float stat_ret_dist;

.float stat_plr_ang_x;
.float stat_plr_ang_y;
.float stat_plr_ang_z;
.float stat_plr_rep;
//============================
//     STAT CHANNELS         
//============================
//float STAT_OBS_FACTION = 32;

float STAT_ACCURACY = 33;
//float STAT_SPREADY = 34;

float STAT_TARG_EID = 35;
float STAT_VID = 36;

float STAT_CAM_ORG_X = 37;
float STAT_CAM_ORG_Y = 38;
float STAT_CAM_ORG_Z = 39;

float STAT_PLR_ORG_X = 40;
float STAT_PLR_ORG_Y = 41;
float STAT_PLR_ORG_Z = 42;
float STAT_PLR_STT = 43;  //keep
float STAT_PLR_DTYPE = 44;
float STAT_PLR_DIDX = 46;
float STAT_PLR_RADMOD = 47;
float STAT_PLR_HITDIR = 48;
float STAT_PLR_RETDIST = 49;

float STAT_TRG_ENT_ID = 50;
float STAT_TRG_DATATYPE = 53;
float STAT_TRG_DATAIDX = 54;
float STAT_TRG_DIST = 55;
float STAT_TRG_FACE = 56;
float STAT_TRG_FACTION = 57;

float STAT_TRG_LG_HP = 61;
float STAT_TRG_CT_HP = 62;
float STAT_TRG_LT_HP = 63;
float STAT_TRG_RT_HP = 64;
float STAT_TRG_LA_HP = 65;
float STAT_TRG_RA_HP = 66;

float TRG_VEC_SIZ = 67;
float TRG_P_CLASS = 68;

float STAT_WEP1_ID = 69;
float STAT_WEP2_ID = 70;
float STAT_WEP3_ID = 71;
float STAT_WEP4_ID = 72;
float STAT_WEP5_ID = 73;
float STAT_WEP6_ID = 74;
float STAT_WEP7_ID = 75;
float STAT_WEP8_ID = 76;
float STAT_WEP9_ID = 77;

float STAT_WEP_STT = 78;
float STAT_WEP_GRP = 79;
float STAT_WEP_REL = 80;
float STAT_NAV_DIR = 81;
//float STAT_SPREAD = 82;
float STAT_PLR_FIR = 83;
float STAT_LCK_STT = 84;
float STAT_PLR_PTC = 85;
float STAT_PLR_ANG = 86;
float STAT_TRG_DDFLG = 87;
float STAT_TRG_ORGX = 88;
float STAT_TRG_ORGY = 89;
float STAT_TRG_ORGZ = 90;

float STAT_RAD_SWEEP = 91;
float STAT_PLR_ANG_X = 100;
float STAT_PLR_ANG_Y = 101;
float STAT_PLR_ANG_Z = 102;

float STAT_PLR_REP = 103; //remaining repair delta

float STAT_PLR_NAME = 104;

//============================
//     LOCK STATES   
//============================
float LOCK_NONE = 1;
float LOCK_TARG_START = 2;
float LOCK_TARG_HAS = 4;
float LOCK_PLYR = 8;

//============================
//     PLAYER POWER UP TIME  
//============================
float POWERUP_DEFAULT = 7;
float POWERUP_DEBUG   = 0.01;
float POWERUP_LIGHT   = 3;
float POWERUP_MEDIUM  = 5;
float POWERUP_HEAVY   = 7;

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