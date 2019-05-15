/*
battleMETAL
Author: Peter Roohr
Date: 10/11/2016
Overview: csqc defs for the mod
*/

float PLAYER_ENTITYNUM;

float CON_W;
float CON_H;
float CON_CW;
float CON_CH;

//client parms ported from server
.float parm1;
.float parm2;
.float parm3;
.float parm4;
.float parm5;
.float parm6;
.float parm7; // bitflags for light mechs
.float parm8; // bitflags for medium mechs
.float parm9; // bitflags for heavy mechs


//
.float() t_remove; // called by CSQC_Ent_Remove to clean up this entity, return TRUE if remove(self) should be performed afterward
// protocol bytes
float SVC_SETVIEWPORT = 5;
float SVC_SETANGLES = 10;
float	SVC_TEMPENTITY		= 23;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			= 31;
float	SVC_CDTRACK			= 32;
float	SVC_SELLSCREEN		= 33;

//ported over from server
float	DEAD_NO					= 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				= 2;
float	DEAD_RESPAWNABLE		= 3;
float	DEAD_RESPAWNING			= 4; // dead, waiting for buttons to be released


//satus colors
vector STATUS_AOK = '0.13 0.6 0.329';
vector STATUS_DMG = '0.952 0.611 0.07';
vector STATUS_DED = '0.2 0.286 0.368'; //change to this soon 95, 106, 106
vector STATUS_REL = '0.18 0.525 0.756';
vector STATUS_RNG = '0.513 0.568 0.572';

//COMP_TYPE
float m_tor_c = 0;
float m_tor_l = 1;
float m_tor_r = 2;
float m_legs = 3;
float m_arm_r = 4;
float m_arm_l = 5;
float m_wep = 6;

.float vec_size;
.string c_model;
.string w_name;       //label for weapon, need to keep 'classname' reserved for actual class    
.float w_firerate;
.float w_firemod;     //used for modifying fire rate;
.float w_firemoddur;  //duration of effect;
.float w_reloadtime;
.float w_clipsize;
.float w_ammotype;
.float w_spread;
.float en_max;
.float i_techlvl;
.float data_type;
.float faction;   //which faction? consult table
.float i_techlvl; //what is the appropriate tech level of the unit? this is also used for levels 
.float i_reserve; //how many reserve points does the unit cost?
.float en_max;   //max amount
.float en_cur;  //current amount
.float en_rate; //how much energy built per frame
.float sh_max;    //max shields
.float sh_cur;    //current amount of shields
.float sh_rate;   //shield recharge rate
.float sh_hit;
.float m_fspeed; //forward speed
.float m_sspeed; //side strafe speed
.float m_bspeed; //backward speed
.float m_maccel;
.float m_pitch_min;
.float m_pitch_max;
.vector maxs;
.vector mins;
.string w_abbr;
.float player_state;

.float stat_hit_dirs;
.float target_entid;
.vector target_origin;

//These should have been floats from the start
//these are component id's (compid) for model pieces
string MECH_PIECE    = "mech_piece";
float M_TOR_CENTER  = 2;
float M_TOR_RIGHT   = 3;
float M_TOR_LEFT    = 4;
float M_LEGS        = 5;
float M_LEG_L       = 6;
float M_LEG_R       = 7;
float M_ARM_LEFT    = 8;
float M_ARM_RIGHT   = 9;

//hit direction bit flags
float STAT_HIT_CL = 1;
float STAT_HIT_LF = 2;
float STAT_HIT_RT = 4;
float STAT_HIT_BK = 8;
float STAT_HIT_TRG = 16;

//status floats specific components
float COMP_OK = 5;
float COMP_DMG = 6;
float COMP_DYN = 7;
float COMP_REL = 8;
float COMP_RDY = 9;

//weapon status all-in-one for bitflags
float WEAPON1_OK = 1;
float WEAPON1_DD = 2;
float WEAPON2_OK = 4;
float WEAPON2_DD = 8;
float WEAPON3_OK = 16;
float WEAPON3_DD = 32;
float WEAPON4_OK = 64;
float WEAPON4_DD = 128;
float WEAPON5_OK = 256;
float WEAPON5_DD = 512;
float WEAPON6_OK = 1024;
float WEAPON6_DD = 2048;
float WEAPON7_OK = 4096;
float WEAPON7_DD = 8192;
float WEAPON8_OK = 16384;
float WEAPON8_DD = 32768;
float WEAPON9_OK = 65536;
float WEAPON9_DD = 131072;

//weapon reload states
float WEAPON1_REL = 1;
float WEAPON2_REL = 2;
float WEAPON3_REL = 4;
float WEAPON4_REL = 8;
float WEAPON5_REL = 16;
float WEAPON6_REL = 32;
float WEAPON7_REL = 64;
float WEAPON8_REL = 128;
float WEAPON9_REL = 256;