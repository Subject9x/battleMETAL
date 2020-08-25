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

//SSQC only
#ifndef CSQC
.vector lastorigin; //mostly AI move tracker

.float shieldHitDelay;  //when shield > 
.float shieldHitDelayStart;  //when shield > 
.float shieldHitRegen;  //cool down before shield recharge begins
.float shieldHitRegenStart;
.float accuracyMod;
.float accuracy; 

.float turret_yaw_speed;
.float ai_attack_chance;

.float shieldRateMod; //field for modules.
.float radar_time;
.float was_hit; //used for hit direction calculation mostly
.float hitdir_buffer; //used for hit direction, is cleared every frame
#endif
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
.float shieldRate;    //shield recharge rate
.float startupDelay; //time in game seconds for unit to activate after spawn.

//Weapon Spread Mechanics
.vector spreadDefault;

.float radar_range;

//Client-side data and cosmetics -> REFACTOR speedForward | speedStrafe | speedBackwards | speedAccel
.float data_speed_forward; //forward speed
.float data_speed_strafe; //side strafe speed
.float data_speed_backward; //backward speed
.float data_speed_accel;	//cl_speedkey acceleration factor

//Unit subcomponents
.entity legs;
.entity cockpit;
.entity torsoCenter;
.entity torsoLeft;
.entity armLeft;  //arms can be optional
.entity torsoRight;
.entity armRight;  //arms can be optional

.float critBits;

.float isActive;


#ifdef CSQC
.float pitchMin;
.float pitchMax;
.float legDir;

/*.vector torsoCenterOffset;
.vector torsoCenterAngles;
.float torsoCenterHealth;

.vector torsoLeftOffset;
.float torsoLeftHealth;

.vector torsoRightOffset;
.float torsoRightHealth;

.vector armLeftOffset;
.float armLeftHealth;

.vector armRightOffset;
.float armRightHealth;

.vector legsOffset;
.float torsoCenterHealth;*/

.vector cockpitOffset;

.float targetEntId;
.float entId; 
.vector uiOffset; //menu-specific hardpoint draw locations.
  //prevents hardpoint overlap in MENU_HANGAR but still allowing hardpoints to be close to the actual
  //weapon locations.
#endif