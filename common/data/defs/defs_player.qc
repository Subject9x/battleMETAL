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
.entity clientData;

#ifdef CSQC
float input_sequence;
.float clientLocalId;   //Client Only - player_localentnum but calculated for all players on every client.
.float clientLocalNum;  //Client Only - player_localnum but calculated for all players on every client.
.float sequence;
.float hud_bob;    //bob settings are important for dat immersion
.float hud_bob_cycle;
.float hud_bob_up;  
.float hud_rollangle;
.float hud_bob_model;
.float hud_bob_side;
.float hud_bob_model_up;
.float hud_bob_speed;
.string hud_model;  //where .viewweapon is the cockpit struts model, hud_model is the computer boxes
.vector hud_StrutsOffset; //  origin offset of struts model
.vector laser_sight_org1;
.vector laser_sight_org2;
#endif

.float getTarget;   //switch for sendEnt
.float canTarget; //everything ends up a field value eventually... - sage words.
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

.float chaseActive; //tracks player chase cam status on the server.

.float ramUpMax;
.float ramCooldown;
.float moveState;  //0 = no sprint, 1 = sprint, 2 = ram charge, 3 = ram charged up
.vector laser_sight_org;

#ifdef SSQC
.float posFadeTimer;  //breadcrumbs for the AI....
.vector position1;
.vector position2;
.vector position3;

.float new_color;
.float last_color;

.float targetValid;
.float targetDist;
.vector prevMovement; //the .movement of last frame
.float missionStatus; //moved to player level for network
.float hud_mode;  //sway mode
.string hud_model;  //where .viewweapon is the cockpit struts model, hud_model is the computer boxes

.float missionLosses; //mostly campaign related.
.float botKills;      //campaign/coop tracking of bot kills.
.float playerDeaths;      //tracked in TDM / DM for personal score.
.float playerDMdamage;    //fun tracker for total damage output over a match.

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

.vector ramAngle;
.float ramCharge;
.float ramCool;
.vector ramPower;
.vector ramVelocity;
.float ramUp;



#endif