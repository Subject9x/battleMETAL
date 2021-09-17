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

// protocol bytes - the full salvo
float SVC_BAD           = 0;
float SVC_NOP           = 1;
float SVC_DISCONNECT    = 2;// (DP8) [string] null terminated parting message
float SVC_UPDATESTAT    = 3;
float SVC_VERSION       = 4;// [int] server version
float SVC_SETVIEW       = 5;// [short] entity number
float SVC_SOUND         = 6;// <see code>
float SVC_TIME          = 7;// [float] server time
float SVC_PRINT         = 8;// [string] null terminated string
float SVC_STUFFTEXT     = 9;// [string] stuffed into client's console buffer
                                // the string should be \n terminated
float SVC_SETANGLE      = 10;// [vec3] set the view angle to this absolute value

float SVC_SERVERINFO    = 11;// [int] version
                            // [string] signon string
                            // [string]..[0]model cache [string]...[0]sounds cache
                            // [string]..[0]item cache
float SVC_LIGHTSTYLE    = 12;// [byte] [string]
float SVC_UPDATENAME    = 13;// [byte] [string]
float SVC_UPDATEFRAGS   = 14;// [byte] [short]
float SVC_CLIENTDATA    = 15;// <shortbits + data>
float SVC_STOPSOUND     = 16;// <see code>
float SVC_UPDATECOLORS  = 17;// [byte] [byte]
float SVC_PARTICLE      = 18;// [vec3] <variable>
float SVC_DAMAGE        = 19;// [byte] impact [byte] blood [vec3] from

float SVC_SPAWNSTATIC   = 20;
//float OBSOLETE svc_spawnbinary    = 21;
float SVC_SPAWNBASELINE = 22;

float SVC_TEMP_ENTITY   = 23;// <variable>
float SVC_SETPAUSE      = 24;
float SVC_SIGNONNUM     = 25;
float SVC_CENTERPRINT   = 26;
float SVC_KILLEDMONSTER = 27;
float SVC_FOUNDSECRET   = 28;
float SVC_SPAWNSTATICSOUND = 29;
float SVC_INTERMISSION  = 30;
float SVC_FINALE        = 31;// [string] music [string] text
float SVC_CDTRACK       = 32;// [byte] track [byte] looptrack
float SVC_SELLSCREEN    = 33;
float SVC_CUTSCENE      = 34;
float SVC_SHOWLMP       = 35;// [string] iconlabel [string] lmpfile [short] x [short] y
float SVC_HIDELMP       = 36;// [string] iconlabel
float SVC_SKYBOX        = 37; // [string] skyname


//ported over from server
float	DEAD_NO				    = 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				  = 2;
float	DEAD_RESPAWNABLE	= 3;
float	DEAD_RESPAWNING		= 4; // dead, waiting for buttons to be released

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