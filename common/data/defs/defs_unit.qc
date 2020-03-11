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
.float shieldHitDelay;//cool down before shield recharge begins

.float accuracyMod;
.float accuracy; 

.float turret_yaw_speed;
.float evasionDrain;
.float ai_attack_chance;
#endif

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
.float shieldRateMod; //field for modules.
.float startupDelay; //time in game seconds for unit to activate after spawn.


//Weapon Spread Mechanics
.vector spreadDefault;

.float radar_time;
.float radar_range;

//Client-side data and cosmetics -> REFACTOR speedForward | speedStrafe | speedBackwards | speedAccel
.float data_speed_forward; //forward speed
.float data_speed_strafe; //side strafe speed
.float data_speed_backward; //backward speed
.float data_speed_accel;	//cl_speedkey acceleration factor

.float pitchMin;
.float pitchMax;

//Unit subcomponents
.entity legs;
.entity cockpit;
.entity torsoCenter;
.entity torsoLeft;
.entity armLeft;  //arms can be optional
.entity torsoRight;
.entity armRight;  //arms can be optional

//Server-side 'thin' unit data
#ifndef CSQC
.vector cockpitOffset;

.vector torsoCenterOffset;
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
.float torsoCenterHealth;

.vector legAngles;

#endif

.float isActive;

.float was_hit; //used for hit direction calculation mostly
.float hitdir_buffer; //used for hit direction, is cleared every frame
