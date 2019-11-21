/*
battleMETAL
Author: Peter Roohr
Date: 06/04/2019
Overview:
	'defs' because 'defs.qc' is the original Quake defs file.
	
	define: Unit Sub-Piece Entity Fields
		Arms, torsos, weapons, anything attached to something else.
	
	(yes, entity fields are on all entities, but this is for cleanliness and bookkeeping);
*/

#ifndef CSQC
.string c_model;
.vector compAltOffset;    //useful alt offset
.entity partNext;     //chain entity of next part in unit's part list
#endif

.float partParentId;  //component id of PARENT
.float partTypeId;    //component id
.vector compOffset;
.vector hitOffset;    //used for t_damage calcs, its compOffset without the 'depth' (Z) field.
.float hardpointSize;
.float hardpointType;