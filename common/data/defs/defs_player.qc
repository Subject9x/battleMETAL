/*
battleMETAL
Author: Peter Roohr
Date: 06/04/2019
Overview:
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Player Entity Fields
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/

.entity w_slot;     //use this for teh linked list goodness
.float data_type;

.float hud_bob;    //bob settings are important for dat immersion
.float hud_bob_cycle;
.float hud_bob_up;  
.float hud_rollangle;
.float hud_bob_model;
.float hud_bob_side;
.float hud_bob_model_up;
.float hud_bob_speed;
.string hud_model;  //where .viewweapon is the cockpit struts model, hud_model is the computer boxes
.float hud_mode;  //sway mode
.entity hud_ent;  //fixes sway mode set bug

.entity hudTorsoCenter;
.entity hudTorsoLeft;
.entity hudTorsoRight;
.entity hudArmLeft;
.entity hudArmRight;

.entity hudWeapon;  //used as list-id for hud weapon ents.

.float faction;   //which faction? consult table
.float techLevel; //what is the appropriate tech level of the unit? this is also used for levels 
.float equipSize;

.float next_wepn1;
.float next_wepn2;
.float next_wepn3;
.float next_wepn4;
.float next_wepn5;
.float next_wepn6;
.float next_wepn7;
.float next_wepn8;
.float next_wepn9;

.float missionStatus; //moved to player level for network


.float ramUpMax;

#ifdef CSQC
.float particleCubeFlag;
#endif

#ifndef CSQC
.float nextVecChoice;
.float i_reserve; //how many reserve points does the unit cost?

.float max_armor; //why wasn't this ever included!?

.float	dmgtime; //pulled from client.qc
//.float playermovestate, playermovebegin; //pulled from dpqc player.qc

.float ramTracker;

.entity animId; //entity id of animation sent to the player, used for skip event->fire trigger case.

.float currentWeaponGroup;
.float w_group1;
.float w_group2;
.float w_group3;
.float w_group4;
//.float w_firemode;

.float fall_dist; //distance fallen to trigger 'stumble'
.float fall_slam; //distance fallen to trigger leg damage
.float fall_dmg;  //damage increments when falling

.float power_timer; //used for power up
.float power_timer_segment; //used for power up | radar lock progress
.float lock_timer;
.float chain_timer;

.float repair_request;

.float laser_sight_timer;
.vector laser_sight_org;

.vector ramAngle;
.float ramCharge;
.float ramCool;
.vector ramPower;
.vector ramVelocity;
.float ramUp;
.float ramUpMax;

.entity clientData;
#endif