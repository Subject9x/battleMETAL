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

.float data_idx;
.float vec_size;
.string vec_name;
.float hardpoint_cnt;

//reactor
.float energyMax;     //max amount
.float energy;        //current amount
.float energyRate;    //how much energy built per frame
.float shieldMax;     //max shields
.float shield;        //current amount of shields
.float shieldRate;    //shield recharge rate
.float shieldHitDelay;//cool down before shield recharge begins

//Weapon Spread Mechanics
.vector spreadDefault;
.float accuracyMod;
.float accuracyAdj;
.float accuracy; 
.float radar_time;
.float radar_range;

//Client-side data and cosmetics -> REFACTOR speedForward | speedStrafe | speedBackwards | speedAccel
.float data_speed_forward; //forward speed
.float data_speed_strafe; //side strafe speed
.float data_speed_backward; //backward speed
.float data_speed_accel;	//cl_speedkey acceleration factor

.float turret_yaw_speed;
.float pitchMin;
.float pitchMax;
.float evasionDrain;

//Unit subcomponents
.entity legs;
.entity cockpit;
.entity torsoCenter;
.entity torsoLeft;
.entity armLeft;  //arms can be optional
.entity torsoRight;
.entity armRight;  //arms can be optional

.string ui_hud_image;	//client-side, display this as the background hud image
.string ui_menu_icon;	//client-side, display this image in the hangar

.float isActive;
.float nav_name;