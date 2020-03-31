/*
battleMETAL
Author: Peter Roohr
Date: 06/04/2019
Overview:
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Projectile Entity Fields
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/

.float data_lifetime;	//  game seconds the projectile lives for unless it hits something.
.float data_velocity;	//  initialized velocity value (convert at function level )
.float impactType;    // used for server communication