/*
battleMETAL
Author: Peter Roohr
Date: 6/4/2019

Overview
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Item Entity Fields
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/

.float reloadMax;
.float reloadValue;
.float reloadRate;
.string fire_sound;
.float burstRate; //percentage of reloadRate to use for burst-fire intervals.

.float state_1;
.float state_2;
.void() w_attack;     //actual attack func
.void() w_think;     //implementable update function
.vector w_fire_ofs;     //offset for proj. origin
.vector w_adj_ang;      //rotate weapon model face correctly
.string w_name;       //label for weapon, need to keep 'classname' reserved for actual class
.float w_proj;       //pointer to projectile entity data
.float w_firerate;
.float w_firemod;     //used for modifying fire rate;
.float w_firemoddur;  //duration of effect;
.float w_firetime;
.float w_currentammo;
.float w_clipsize;
.float w_isready;
.float w_group;     //weapon group, only 1-3 - SET BY PARENT
.vector fx_origin;
.float w_range;
.float w_isburst;   //ugh
.float w_state;   //double ugh
.float damageValue;
.float damageType;  //  Enumerated Float, see defs_game.qc\
.string icon;       //client-side
.string description;//client-side
.string abbrev;

.float ai_weaponEnergy; //current max energy cost.
.float ai_attackPreviousEnergy; //cached every attack call, compared when new attack is made.
.float ai_nextFireTime; //last time this WEAPON was fired.