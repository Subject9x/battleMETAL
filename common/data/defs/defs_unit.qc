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
.float energyMax;   //max amount
.float energy;  //current amount
.float energyRate; //how much energy built per frame
.float shieldMax;    //max shields
.float shield;    //current amount of shields
.float shieldRate;   //shield recharge rate
.float sh_hit;

//Weapon Spread Mechanics
.vector spreadDefault;
.float accuracyMod;
.float accuracyAdj;
.float accuracy; 
.float radar_time;
.float radar_range;

//Client-side data and cosmetics -> REFACTOR speedForward | speedStrafe | speedBackwards | speedAccel
.float m_fspeed; //forward speed
.float m_sspeed; //side strafe speed
.float m_bspeed; //backward speed
.float m_maccel;	//cl_speedkey acceleration factor

.float turret_yaw_speed;
.float m_pitch_min;
.float m_pitch_max;

//Unit subcomponents
.entity legs;
.entity e_cam;
.entity torsoCenter;
.entity torsoLeft;
.entity armLeft;  //arms can be optional
.entity torsoRight;
.entity armRight;  //arms can be optional
