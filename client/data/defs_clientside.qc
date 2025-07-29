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
#define SVC_BAD 0 
#define SVC_NOP 1 
#define SVC_DISCONNECT 2 // (DP8) [string] null terminated parting message
#define SVC_UPDATESTAT 3 
#define SVC_VERSION 4 // [int] server version
#define SVC_SETVIEW 5 // [short] entity number
#define SVC_SOUND 6 // <see code>
#define SVC_TIME 7 // [float] server time
#define SVC_PRINT 8 // [string] null terminated string
#define SVC_STUFFTEXT 9 // [string] stuffed into client's console buffer
                                // the string should be \n terminated
#define SVC_SETANGLE 10  // [vec3] set the view angle to this absolute value

#define SVC_SERVERINFO 11 // [int] version
                            // [string] signon string
                            // [string]..[0]model cache [string]...[0]sounds cache
                            // [string]..[0]item cache
#define SVC_LIGHTSTYLE 12 // [byte] [string]
#define SVC_UPDATENAME 13 // [byte] [string]
#define SVC_UPDATEFRAGS 14 // [byte] [short]
#define SVC_CLIENTDATA 15 // <shortbits + data>
#define SVC_STOPSOUND 16 // <see code>
#define SVC_UPDATECOLORS  17 // [byte] [byte]
#define SVC_PARTICLE 18 // [vec3] <variable>
#define SVC_DAMAGE 19 // [byte] impact [byte] blood [vec3] from

#define SVC_SPAWNSTATIC 20
//#define OBSOLETE svc_spawnbinary    = 21;
#define SVC_SPAWNBASELINE 22

#define SVC_TEMP_ENTITY 23 // <variable>
#define SVC_SETPAUSE 24 
#define SVC_SIGNONNUM 25 
#define SVC_CENTERPRINT 26 
#define SVC_KILLEDMONSTER 27 
#define SVC_FOUNDSECRET 28 
#define SVC_SPAWNSTATICSOUND 29
#define SVC_INTERMISSION 30
#define SVC_FINALE 31 // [string] music [string] text
#define SVC_CDTRACK 32 // [byte] track [byte] looptrack
#define SVC_SELLSCREEN 33 
#define SVC_CUTSCENE 34 
#define SVC_SHOWLMP 35 // [string] iconlabel [string] lmpfile [short] x [short] y
#define SVC_HIDELMP 36 // [string] iconlabel
#define SVC_SKYBOX 37  // [string] skyname


//ported over from server
#define DEAD_NO 0
#define DEAD_DYING 1
#define DEAD_DEAD 2
#define DEAD_RESPAWNABLE 3
#define DEAD_RESPAWNING 4 // dead, waiting for buttons to be released
#define DEAD_RAMMED 5 // specifically for vehicles killed by ramming.

//input globals and constants
#define INPUT_EVENT_KEYDOWN 0
#define INPUT_EVENT_KEYUP 1
#define INPUT_EVENT_MOUSE_MOVE 2
#define INPUT_EVENT_MOUSE_POS 3

float INPUT_mouse_state;  //set by handle_input();
float INPUT_mouse_state_prev;
float MOUSE_IS_DOWN = TRUE; 
float MOUSE_UP = FALSE;
#define MOUSE_DRAG 2

float MOUSE_drag_timer;
#define MOUSE_drag_rate 0.1
#define MOUSE_drag_max 0.5

//WEAPON FIRE STATUS
#define READY 0
#define RELOADING 1
#define WAITING 2
#define RECOIL 4

//direction values
#define DIR_N  0
#define DIR_NE 1
#define DIR_E  2
#define DIR_SE 3
#define DIR_S  4
#define DIR_SW 5
#define DIR_W  6
#define DIR_NW 7

//fire modes
#define FIRE_SINGLE 1
#define FIRE_GROUP 2
#define FIRE_CHAIN 3