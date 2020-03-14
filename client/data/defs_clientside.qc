/*
battleMETAL
Author: Peter Roohr
Date: 10/11/2016
mod:  05/16/2019
Overview:
  CSQC definition extensions for battleMETAL.
  Extensions are for the CS part of CSQC, and less about
  {entity} stuff vs defs_entity.qc
*/

// protocol bytes
float SVC_SETVIEWPORT   = 5;
float SVC_SETANGLES     = 10;
float	SVC_TEMPENTITY		= 23;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			  = 31;
float	SVC_CDTRACK			  = 32;
float	SVC_SELLSCREEN		= 33;

//ported over from server
float	DEAD_NO				    = 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				  = 2;
float	DEAD_RESPAWNABLE	= 3;
float	DEAD_RESPAWNING		= 4; // dead, waiting for buttons to be released

.float player_state;

//input globals and constants
float INPUT_EVENT_KEYDOWN = 0;
float INPUT_EVENT_KEYUP = 1;
float INPUT_EVENT_MOUSE_MOVE = 2;
float INPUT_EVENT_MOUSE_POS = 3;

float INPUT_mouse_state;  //set by handle_input();
float INPUT_mouse_state_prev;
float MOUSE_DOWN = TRUE; 
float MOUSE_UP = FALSE;
float MOUSE_DRAG = 2;

float MOUSE_drag_timer;
float MOUSE_drag_rate = 0.1;
float MOUSE_drag_max = 0.5;

//WEAPON FIRE STATUS
float READY = 0;
float RELOADING = 1;
float WAITING = 2;
float RECOIL = 4;

//direction values
float DIR_N   = 0;
float DIR_NE  = 1;
float DIR_E   = 2;
float DIR_SE  = 3;
float DIR_S   = 4;
float DIR_SW  = 5;
float DIR_W   = 6;
float DIR_NW  = 7;

//fire modes
float FIRE_SINGLE = 1;
float FIRE_GROUP = 2;
float FIRE_CHAIN = 3;