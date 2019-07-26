/*
battleMETAL
Author: Peter Roohr
Date: 06/04/2019
Overview:
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Player Entity Fields
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/

.float data_type;
.float max_armor; //why wasn't this ever included!?

.float currentWeaponGroup;

.string hud_bob;    //bob settings are important for dat immersion
.string hud_bob_cycle;
.string hud_bob_up;  
.string hud_rollangle;
.string hud_bob_model;
.string hud_bob_side;
.string hud_bob_speed;


.float was_hit; //used for hit direction calculation mostly
.float hitdir_buffer; //used for hit direction, is cleared every frame

.float	dmgtime; //pulled from client.qc
//.float playermovestate, playermovebegin; //pulled from dpqc player.qc

.float currentWeaponGroup;
.float nextVecChoice;

.float w_group1;
.float w_group2;
.float w_group3;
.float w_group4;
.float w_group5;
//.float w_firemode;

.float faction;   //which faction? consult table
.float techLevel; //what is the appropriate tech level of the unit? this is also used for levels 
.float i_reserve; //how many reserve points does the unit cost?
.float i_size;
.entity w_slot;     //use this for teh linked list goodness

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

.float next_wepn1;
.float next_wepn2;
.float next_wepn3;
.float next_wepn4;
.float next_wepn5;
.float next_wepn6;
.float next_wepn7;
.float next_wepn8;
.float next_wepn9;