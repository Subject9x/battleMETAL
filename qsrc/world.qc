
//void() InitBodyQue;

void() main =
{
	dprint ("main function\n");
	skill = cvar("skill");
  precache_sound2("sound/demon/dland2.wav");
};

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.

-------- KEYS --------
.mapFile(NOT USED) <string> found in data/map_scripts/<map_name>/<map_name>.sav
.missionFile(REQUIRED) <string> mission briefing file, found in data/map_scripts/<map_name>/<map_name>.dat

.light default light level
.message <string> - the in-game name of the level
.sounds <float> [CD track number] - play this track during gameplay

.wind <vector> initial wind direction

.fog_density <float> 0 
.fog_color <vector> [color] - RGB {0.001 - 1.0} colors of the fog
.fog_alpha <float> [alpha] - {0.001 - 1.0} alpha transparency of the fog
.fog_dist <vector> [min distance, max distance, height] - distances of the fog
.fade <float> [fade depth] - units of fade transition from low alpha to opacity

.worldtype <float> [enum]
    0: DESERT
    1: ICE
    2: CITY
    3: BADLANDS
    4: TUNDRA
  This affects things like environmental smoke puffs, possibly lighting, and fog?
-------- SPAWNFLAGS --------
(none)
-------- NOTES --------
*/
void() worldspawn =
{
	skill = cvar("skill");
  world.data_idx = -1;
	lastspawn = world;
	//InitBodyQue ();
  cvar_set("sv_maxspeed", "800"); //allows faster units
  
  CLIENTS = 0;
  
  //defaults worldtype to DESERT if var is missing.
  if( !world.worldtype ){
    world.worldtype = 0;
  }

// custom map attributes
	/*if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");
  */
    
  //setmodel(self, "maps/t_train0.bsp");
  // the area based ambient sounds MUST be the first precache_sounds
  
  //see q1/precache_world.q1_precache_sound();
  
  FRIK_FILE_precaches();
  
  world_metal_ini();  //
//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//
	// 0 normal
	lightstyle(0, "m");
	
	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	
	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	
	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");
	
	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");
	
	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");
	
	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");
};

/*
  Engine Entry point to new server frame
*/
void() StartFrame =
{
  teamplay = cvar("teamplay");
  skill = cvar("skill");
  framecount = framecount + 1;
  sv_checkRules(); //ported over here for fairness and synchronization
  
  if( time > NODEGRAPH_queue_timer ){
    NODEGRAPH_queue_timer = time + NODEGRAPH_queue_timeout;
    NODEGRAPH_queue_total = max(0, NODEGRAPH_MAX_REQUEST - 1);
  }
};

/*
  Engine Entry point for end of server frame, curiously enough the engine makes the call to the progs 
  but this is not defined anywhere else. I swear I remember reading about this years ago, and yeah, 
  it really should be here even if you DONT use it - its handy to have.
*/
void() EndFrame={
};