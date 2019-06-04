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
.float vec_size;
.string vec_name;
.float hardpoint_cnt;

//reactor
REFACTOR -> energyMax, energyRate, energy, shieldMax, shieldRate, shield
.float en_max;   //max amount
.float en_cur;  //current amount
.float en_rate; //how much energy built per frame
.float sh_max;    //max shields
.float sh_cur;    //current amount of shields
.float sh_rate;   //shield recharge rate
.float sh_hit;

//Weapon Spread Mechanics
.vector spreadDefault;
.float accuracyMod;
.float accuracyAdj;
.float accuracy; 
.float radar_time;
.float radar_range;
.float currentWeaponGroup;

//Client-side data and cosmetics -> REFACTOR speedForward | speedStrafe | speedBackwards | speedAccel
.float m_fspeed; //forward speed
.float m_sspeed; //side strafe speed
.float m_bspeed; //backward speed
.float m_maccel;	//cl_speedkey acceleration factor

.float turret_yaw_speed;
.float m_pitch_min;
.float m_pitch_max;

//Unit subcomponents -> REFACTOR to .legs | .torso | torsoLeft | torsoRight | camera | armLeft | armRight
.entity e_legs;
.entity e_cam;
.entity e_tor_c;
.entity e_tor_l;
.entity e_arm_l;  //arms can be optional
.entity e_tor_r;
.entity e_arm_r;  //arms can be optional


.string m_bob;    //bob settings are important for dat immersion
.string m_bcycle;
.string m_bup;  
.string m_rollangle;
.string m_bmodel;
.string m_bside;
.string m_bobspd;