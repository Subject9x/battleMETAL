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

.string c_model;
.float partParentId;
.float partTypeId;    //component_name,
.vector c_ofs;
.vector c_alt_ofs;    //useful alt offset
.entity partNext;
.float hardpointSize;
.float hardpointType;