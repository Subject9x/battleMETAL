/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: extends the player's entity.
*/

.float was_hit; //used for hit direction calculation mostly
.float hitdir_buffer; //used for hit direction, is cleared every frame

.float	dmgtime; //pulled from client.qc
.float playermovestate, playermovebegin; //pulled from dpqc player.qc

.float p_class;      //type of player, maps to GLOBAL P_TYPES
.float p_class_next;  // previous player class, needed for cleanup checks
.float currentWeaponGroup;
.float nextVecChoice;
.float data_idx;

.float w_group1;
.float w_group2;
.float w_group3;

.float faction;   //which faction? consult table
.float i_techlvl; //what is the appropriate tech level of the unit? this is also used for levels 
.float i_reserve; //how many reserve points does the unit cost?

.entity w_slot;     //use this for teh linked list goodness

.float power_timer; //used for power up