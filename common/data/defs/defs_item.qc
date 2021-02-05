/*
battleMETAL
Author: Peter Roohr
Date: 6/4/2019

Overview
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Item Entity Fields
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/

//SSQC only
#ifdef SSQC
.void() w_attack;     //actual attack func
.void() w_think;     //implementable update function
.float w_proj;       //pointer to projectile entity data
.float w_firerate;
.float ai_weaponEnergy; //current max energy cost.
.float ai_attackPreviousEnergy; //cached every attack call, compared when new attack is made.
.float ai_nextFireTime; //last time this WEAPON was fired.
.vector spreadCache;
.float damageCache;
#endif

#ifdef CSQC
.string fire_sound;
.string w_name;       //label for weapon, need to keep 'classname' reserved for actual class
.string icon;       //client-side
.void() itemMuzzleFlash;
#endif

.float w_isburst;   //ugh
.float w_currentammo;
.float burstRate; //percentage of reloadRate to use for burst-fire intervals.
.float wepReloadState;   //double ugh
.float reloadValue;
.float aState;
.vector wepFireOffset;     //offset for proj. origin
.vector wepFireOffsetCache; //cached offset for constant reference
.float reloadMax;
.float reloadRate;
.vector w_adj_ang;      //rotate weapon model face correctly
.float w_firetime;
.float w_clipsize;
.float w_group;     //Weapon bitflag value indicator UID for hardpoint, 1,2,4,8 etc
.float w_range;
.float damageValue;
.float damageType;  //  Enumerated Float, see defs_game.qc\
.string description;//client-side
.string abbrev;

