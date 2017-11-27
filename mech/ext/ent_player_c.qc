/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: extends the player's entity.
*/

.float was_hit; //used for hit direction calculation mostly
.float hitdir_buffer; //used for hit direction, is cleared every frame

//.float	dmgtime; //pulled from client.qc
//.float playermovestate, playermovebegin; //pulled from dpqc player.qc

.float p_class;      //type of player, maps to GLOBAL P_TYPES
.float p_class_next;  // previous player class, needed for cleanup checks
.float currentWeaponGroup;
.float nextVecChoice;
.float data_idx;

.float w_group1;
.float w_group2;
.float w_group3;
.float w_group4;
.float w_group5;
//.float w_firemode;

.float i_faction;   //which faction? consult table
.float i_techlvl; //what is the appropriate tech level of the unit? this is also used for levels 
.float i_reserve; //how many reserve points does the unit cost?
.float i_size;
.entity w_slot;     //use this for teh linked list goodness

.float power_timer; //used for power up
.float lock_timer;
.float chain_timer;

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

.vector ui_box_pos;
.vector ui_box_sz;
.vector ui_box_clr;
.float ui_box_time;