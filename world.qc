
//void() InitBodyQue;


void() main =
{
	dprint ("main function\n");
	//q1_precache_world();
  //see q1/precache_word.q1_precache_world()
};


//entity	lastspawn;

//=======================

/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.

"worldtype"
  <float> [enum]
    0: DESERT
    1: ICE
    2: CITY
    3: BADLANDS
    4: TUNDRA
  This affects things like environmental smoke puffs, possibly lighting, and fog?

[map scripts]
  "map_file"
    <string> mission briefing file, found in data/map_scripts/<map_name>/<map_name>.sav
  "msn_file"
    <string> mission briefing file, found in data/map_scripts/<map_name>/<map_name>.dat

//COSMETICS
[lighting]
  "light"
   default light level
[level name]
  "message"
    <string> - the in-game name of the level
    
[level music]
  "sounds"
    <float> [CD track number] - play this track during gameplay

[wind]
  "c_ofs"
    <vector> initial wind direction
  "m_fspeed"
    <float> initial wind speed

[fog]
  "fog_density" "1"
    <float> 
  "fog_color"
    <vector> [color] - RGB {0.001 - 1.0} colors of the fog
  "fog_alpha"
    <float> [alpha] - {0.001 - 1.0} alpha transparency of the fog
  "fog_dist"
    <vector> [min distance, max distance, height] - distances of the fog
  "fade"
    <float> [fade depth] - units of fade transition from low alpha to opacity
*/

//=======================
void() worldspawn =
{
  world.data_idx = -1;
	lastspawn = world;
	InitBodyQue ();
  cvar_set("sv_maxspeed", "800"); //allows faster units
  
  CLIENTS = 0;
  
  //setup wind settings
  WINDDIR = world.c_ofs;
  WINDSPEED = world.m_fspeed;
  
  dprint( strcat("c_ofs", vtos(world.c_ofs),"\n")); //DEBUG
// custom map attributes
	if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");

    
  //setmodel(self, "maps/t_train0.bsp");
// the area based ambient sounds MUST be the first precache_sounds
  
  //see q1/precache_world.q1_precache_sound();
  q1_precache_sound();
  q1_precache_models();
  
  mh_precache_sound();
  mh_precache_models();
  mh_world_ini();
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

void() StartFrame =
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;
};

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

void() bodyque =
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};

void() InitBodyQue =
{
	local entity	e;
	
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
  bodyque_head.effects = ent.effects;
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};


