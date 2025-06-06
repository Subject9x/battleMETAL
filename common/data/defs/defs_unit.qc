/*
battleMETAL
Author: Peter Roohr
Date: 06/04/2019
Overview:
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Unit Entity Fields
		Unit is any mech, turret, or vehicle in the game
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/


.vector cache_mins;
.vector cache_maxs;

.float shieldHitDelay;  //when shield > 
.float shieldHitDelayStart;  //when shield > 
.float shieldHitRegen;  //cool down before shield recharge begins
.float shieldHitRegenStart;
.float shieldHitFlag;   //sent over network.

//saving this for future work: have ion damage accrue over time, and then an AI mech will get stun-locked for a certain amount of time.
.float stunTimeStart;
.float stunTimeTotal;

.float attackFlag;  //a bitflag set every frame that a unit has fired weapons, where it is weapon bits, WEAPON1 | WEAPON2 etc
                    //the csqc then processes the rest of the particle attacks.
.float burnBits;    //bitflags sent to client for fire/burning effects on ents.
.float evasionDrain;
.float data_idx;
.float vec_size;
.string vec_name;
.float hardpoint_cnt;

//reactor
.float energyMax;     //max amount
.float energy;        //current amount
.float energyRate;    //how much energy built per frame
.float shield;        //current amount of shields
.float shieldMax;     //max shields
.float cache_shieldMax; //stored for reference.
.float shieldRate;    //shield recharge rate
.float shieldRateMod; //field for modules, a bonus percentage
.float startupDelay; //time in game seconds for unit to activate after spawn.

//Weapon Spread Mechanics
.vector spreadDefault;

.float radar_range;
.float headlight; //toggle state

//Client-side data and cosmetics -> REFACTOR speedForward | speedStrafe | speedBackwards | speedAccel
.float data_speed_forward; //forward speed
.float data_speed_strafe; //side strafe speed
.float data_speed_backward; //backward speed
.float data_speed_accel;	//replaces cvar("sv_accel") rate in player_movement.qc
.float data_speed_decel;  //override sv_stopspeed for units.
.float data_speed_sprint; //cl_speedkey acceleration factor

//subcomponents decomposed to field vars, reduce entity management
.string torC_mdl;
.string torL_mdl;
.string torR_mdl;
.string armL_mdl;
.string armR_mdl;
.string legs_mdl;

.float torC_hpMax;
.float torL_hpMax;
.float torR_hpMax;
.float armL_hpMax;
.float armR_hpMax;
.float legs_hpMax;

.float torC_parentId;
.float torL_parentId;
.float torR_parentId;
.float armL_parentId;
.float armR_parentId;
.float legs_parentId;

.vector torC_compOffset;
.vector torL_compOffset;
.vector torR_compOffset;
.vector armL_compOffset;
.vector armR_compOffset;
.vector legs_compOffset;

.vector torC_compAltOffset;
.vector torL_compAltOffset;
.vector torR_compAltOffset;
.vector armL_compAltOffset;
.vector armR_compAltOffset;
.vector legs_compAltOffset;

.vector torC_org;
.vector torL_org;
.vector torR_org;
.vector armL_org;
.vector armR_org;
.vector legs_org;

.vector torC_angl;
.vector torL_angl;
.vector torR_angl;
.vector armL_angl;
.vector armR_angl;
.vector legs_angl;

.float torC_hp;
.float torL_hp;
.float torR_hp;
.float armL_hp;
.float armR_hp;
.float legs_hp;

.float critBits;      //  SV-> used to track critical hits over frames
.float criticalHits;  //  the actual value sent over the network

.float isActive;
.float ai_dir;          //chassis facing vs .angles
.float legDir;

.float shieldEffectTime;  //bumping this up to help reduce net traffic by preventing spamming at the server level.
                          //sure dropped packet do real, but its better than flooding 

.float accuracyMod;
.float accuracy;

.float groundEnt;   //used by buildings to tell their client-entry to generate a ground mesh.

.float angle;
.void() building_delay_think; //post-settling, if building has a think func, this caches it.


//building burn flags
#define BURN_EFFECT1  1
#define BURN_EFFECT2  2
#define BURN_EFFECT3  4
#define BURN_EFFECT4  8
#define BURN_EFFECT5  16

//SSQC only
#ifdef SSQC
//network frame stuff
.float energyRateCache;   //only for mods
.float reloadMaxCache;    //only for mods
.float energyRegenTimer;  //replaces .count4 in AI units

.vector last_velocity;
.vector last_angle;
.vector last_origin; //mostly AI move tracker
.float last_energy;
.float last_shield;
.float last_crit;
.float last_burn;
.float last_flags;

.float cache_speed_fwd;
.float cache_speed_sid;
.float cache_speed_back;
.float cache_speed_accel;


.float turret_yaw_speed;
.float ai_attack_chance;

.float radar_time;
.float was_hit; //used for hit direction calculation mostly
.float hitdir_buffer; //used for hit direction, is cleared every frame

.float unitColorCT;
.float unitColorLT;
.float unitColorRT;
.float unitColorLA;
.float unitColorRA;
.float unitColorLG;

.float damageBuffer;  //damage after calculation is pooled over a frame and then applied on the NEXT frame at the top.
                      //this should reduce the execution cost of t_damage() by every weapon all the time.
.float shieldBuffer;  

.float critBuffer;


.vector torC_hitOffset;
.vector torL_hitOffset;
.vector torR_hitOffset;
.vector armL_hitOffset;
.vector armR_hitOffset;
.vector legs_hitOffset;

.float legs_idealYaw;
.float legs_yawSpeed;
.float legs_attackState;
.float legs_speed_f;
.float legs_speed_s;
.float legs_speed_b;
.float legs_speed_acc;
.float legs_flags;

.float torC_yawSpeed;
.float torC_idealYaw;
.vector torC_anglLast;
.vector torC_vAngles;
.float torC_attackState;
.float torC_aiDir;

.vector tankChassisOrg; //  CSQC projects tank chassis to follow ground angles.

#endif

#ifdef CSQC
.float config_default_id;
.void() config_default_regular;
.void() config_default_missile;
.void() config_default_brawl;

.float ai_voice_group;
.float ai_voice_limit;
.float ai_muted;
.float pitchMin;
.float pitchMax;
.float legMoveRate;
.float legRunRate;

.vector cockpitOffset;

.float targetEntId; 
.vector uiOffset; //menu-specific hardpoint draw locations.
  //prevents hardpoint overlap in MENU_HANGAR but still allowing hardpoints to be close to the actual
  //weapon locations.

.float legs_frame2time;
.float legs_frame1time;
.float legs_frame2;
.float legs_frame1;
.float legs_frame;
.vector legs_origin1;
.vector legs_origin2;
.float legs_angle1;
.float legs_angle2;
.float legs_lerpfrac;
.float legs_movestate;
.float legs_nextthink;


.entity weaponEnt1;
.entity weaponEnt2;
.entity weaponEnt3;
.entity weaponEnt4;
.entity weaponEnt5;
.entity weaponEnt6;
.entity weaponEnt7;
.entity weaponEnt8;
.entity weaponEnt9;


.float cl_lod_weapon; //yes draw / no draw for player view range;
.float cl_lod_unit; //yes draw / no draw for player view range;
.vector cacheGroundAngle; //used by vehicles.
.vector cacheGroundPos; //used by vehicles.

#endif