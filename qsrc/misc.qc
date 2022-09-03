
/*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for spotlights, etc.
*/
void() info_null =
{
	remove(self);
};

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void() info_notnull =
{
};

//============================================================================

void() light_use =
{
	if (self.spawnflags & START_OFF)
	{
		lightstyle(self.style, "m");
		self.spawnflags = self.spawnflags - START_OFF;
	}
	else
	{
		lightstyle(self.style, "a");
		self.spawnflags = self.spawnflags + START_OFF;
	}
};

/*QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
*/
void() light =
{
	if (!self.targetname)
	{	// inert light
		remove(self);
		return;
	}
	
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
};

/*QUAKED realtimelights_light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
+ will be converted to rtlight file line on console command "cmd rtexport"

-------- KEYS --------
.rtlShadows = <bool> use real-time shadows or not.
.rtlLight = <float> radius of light.
.color = <vector>[0-1] used to denote color of light.
.style = <string> same as Light ent.
.vec_name = <string> becomes Light's Cubemap image path.
.rtlCorona = <float> intensity of Corona.
.angles = <vector> directional angles for Light, '0 0 0' is non-directional.
.rtlCoronaSize = <float> size of corona
.rtlAmbient = <float>[0-1] Ambient lighting effect.
.rtlDiffuse = <float>[0-1] Diffuse lighting intensity.
.rtlSpecular = <float>[01] Specular lighting intensity.
.rtlMode = <enum>
  0 = normalmode NO && realtimemode NO
  1 = normalmode YES && realtimemode NO
  2 = normalmode NO && realtimemode YES
  3 = normalmode YES && realtimemode YES
-------- SPAWNFLAGS --------
None
*/
void() realtimelights_light={
  if( !cvar("developer") ){
    remove(self);
    return;
  }
  self.classname = "realtimelights_light";
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.alpha = 1;
  setmodel(self, "models/testball.md3");
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  if( self.vec_name == "" || strlen(self.vec_name) == 0){
    self.vec_name = "";
  }
  
};

/*QUAKED realtimelights_sunlight (0 1 0) (-24 -24 -24) (24 24 24) START_OFF
+ will be converted to rtlight file line on console command "cmd mech rtexport"
This attempts to mimic sunlight in a volume using 2 realtimelights_light ents.

First realtimelights_light is ray-casted along angles to the boundary of the volume.
Second realtimelights_light stays on this origin, and only has AMBIENT light.

-------- KEYS --------
.angles = <vector> direction of sunlight
.rtlRadius = <float> radius of light.
.color = <vector>[0-1] used to denote color of light.
.style = <string> same as Light ent.
.vec_name = <string> becomes Light's Cubemap image path.
.rtlCorona = <float> intensity of Corona.
.angles = <vector> directional angles for Light, '0 0 0' is non-directional.
.rtlCoronaSize = <float> size of corona
.rtlAmbient = <float>[0-1] Ambient lighting effect.
.rtlDiffuse = <float>[0-1] Diffuse lighting intensity.
.rtlSpecular = <float>[01] Specular lighting intensity.
.rtlMode = <enum>
  0 = normalmode NO && realtimemode NO
  1 = normalmode YES && realtimemode NO
  2 = normalmode NO && realtimemode YES
  3 = normalmode YES && realtimemode YES
-------- SPAWNFLAGS --------
None
*/
void() realtimelights_sunlight={
  if( !cvar("developer") ){
    remove(self);
    return;
  }
  /*
    fixed algorithm
    1) this ent should be placed at the CENTER of the volume you want sunlight
    2) given the angles of the entity, shoot a ray out to the sky texture
    3) create rtlight at trace_endpos
      3A) this rtLight has all the props you filled out for the _sunlight entity
    4) create rtlight this origin, but with the following specific vals
      4A) Shadows = NO
      4B) Ambient = user-defined
      4C) Diffuse = 0
      4D) Specular = 0
    5) win (thanks EMR)
  */
  local vector traceEnd;
  local entity sunLight;
  local entity oldLight;

  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.alpha = 1;
  setmodel(self, "models/testball.md3");
  
  makevectors(self.angles);
  traceline( self.origin, self.origin + (v_forward * 640000), MOVE_WORLDONLY, self);
  traceEnd = trace_endpos;
  
  oldLight = self;
  
  sunLight = spawn();
  sunLight.angles = '0 0 0';
  sunLight.rtlShadows = 1;
  sunLight.rtlRadius = self.rtlRadius;
  sunLight.color = self.color;
  sunLight.style = self.style;
  sunLight.vec_name = self.vec_name;
  sunLight.rtlCorona = self.rtlCorona;
  sunLight.rtlCoronaSize = self.rtlCoronaSize;
  sunLight.rtlAmbient = 0;
  sunLight.rtlDiffuse = self.rtlDiffuse;
  sunLight.rtlSpecular = self.rtlSpecular;
  sunLight.rtlMode = self.rtlMode;
  setorigin( sunLight, traceEnd );
  self = sunLight;
    realtimelights_light();
  self = oldLight;
  
  //setup the 'ambient' light
  self.rtlRadius = self.rtlRadius * 1.25;
  self.rtlShadows = 0;
  self.rtlCorona = 0;
  self.rtlCoronaSize = 0;
  self.rtlSpecular = 0;
  self.rtlDiffuse = 0;
  self.angles = '0 0 0';
  self.vec_name = "";
  realtimelights_light();
};

/*QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
Makes steady fluorescent humming sound
*/
void() light_fluoro =
{
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
	
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8)
Non-displayed light.
Default light value is 300
Default style is 10
Makes sparking, broken fluorescent sound
*/
void() light_fluorospark =
{
	if (!self.style)
		self.style = 10;

	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
Sphere globe light.
Default light value is 300
Default style is 0
*/
void() light_globe =
{
  precache_model ("models/testball.md3");
	setmodel (self, "models/testball.md3");
	makestatic (self);
};

void() FireAmbient =
{
	precache_sound ("ambience/fire1.wav");
// attenuate fast
	ambientsound (self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
Short wall torch
Default light value is 200
Default style is 0
*/
void() light_torch_small_walltorch =
{
  precache_model ("models/testball.md3");
	setmodel (self, "models/testball.md3");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame ball
*/
void() light_flame_large_yellow =
{
precache_model ("models/testball.md3");
	setmodel (self, "models/testball.md3");
	self.frame = 1;
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame ball
*/
void() light_flame_small_yellow =
{
  precache_model ("models/testball.md3");
	setmodel (self, "models/testball.md3");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
Small white flame ball
*/
void() light_flame_small_white =
{
	precache_model ("models/testball.md3");
	setmodel (self, "models/testball.md3");
	FireAmbient ();
	makestatic (self);
};

/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};


/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =

{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic (self);
};

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void() func_episodegate =

{
	if (!(serverflags & self.spawnflags))
		return;			// can still enter episode

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*QUAKED func_bossgate (0 .5 .8) ?
This bmodel appears unless players have all of the episode sigils.
*/
void() func_bossgate =

{
	if ( (serverflags & 15) == 15)
		return;		// all episodes completed
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

//============================================================================
/*QUAKED ambient_sound (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_sound =
{
  //stub example for reference.
	precache_sound ("");
	ambientsound (self.origin, "", 1, ATTN_STATIC);
};

//============================================================================

void() func_particle_cube_use={
  self.think = self.w_think;
  self.nextthink = time + 0.1;
  if( (self.spawnflags & 2) ){
	self.data_lifetime = time + self.data_lifetime;
  }
 
  if( (self.spawnflags & 4) ){
	self.nextthink = time + self.delay;
  }
};

void() func_rain_think={
	local float variedCount;
	local float randomizer;
	
	variedCount = self.count;
	if( (self.spawnflags & 32) ){
		randomizer = (0.5 * random());
		variedCount = variedCount * (0.25 + randomizer);
	}
	
	te_particlerain(self.absmin, self.absmax, self.velocity, variedCount, self.skin);
	self.think = self.w_think;
	
	if( (self.spawnflags & 2) ){
		if( time > self.data_lifetime ){
		  if( self.trigOnDeath != string_null ){
        trigger_event( self, self.trigOnDeath );
		  }
		  if( (self.spawnflags & 64) ){
        remove(self);
      }
		  return;
		}
	}
	self.nextthink = time + 0.1;
};

/*QUAKED func_rain (0 .8 1) ? START_OFF LIFETIME DELAY INTERVAL USE_WIND VARIABLE_COUNT REMOVE
 Using te_particlerain, this slightly overwrites a DP original ent.
 Creates a particle cube of rain based on a brush defined in the bsp.
 
 .velocity = <vector> the directional value of the rain.
 .skin = <float> 8bit color value of particle.
 .count = <float> amount of particulate.
 
 .targetname = <string> allow this entity to be activated by trigger system.
 .onSpawn = <string> fire entity when this spawns.
 .onDeath = <string> fire entity when lifetime runs out.
 
 .delay = <float> delay before starting when triggered.
 .data_lifetime = <float> game time before effect shuts off.
 
 1 START_OFF = Requires targetname and a trigger call.
 2 LIFETIME = Func is turned off after .data_lifetime game seconds.
 4 DELAY = wait .delay game seconds after being activated to begin.
 8 INTERVAL = fluctuate between on-and-off.
 16 USE_WIND = rain will be affected by map's WIND values.
 32 VARIABLE_COUNT = .count will be subject to slight randomization.
 64 REMOVE = remove this after lifetime expires, or when turned off.
*/
void() func_rain={
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.w_think = func_rain_think;
  self.use = func_particle_cube_use;
  
  trigger_ext_check();
  
  if( self.trigOnSpawn ){
    trigger_event( self, self.trigOnSpawn );
  }
  if( (self.spawnflags & 1) ){
    return;
  }
  
  self.use();
};

void() func_snow_think={
	local float variedCount;
	local float randomizer;
	
	variedCount = self.count;
	if( (self.spawnflags & 32) ){
		randomizer = (0.5 * random());
		variedCount = variedCount * (0.25 + randomizer);
	}
	
	te_particlesnow(self.absmin, self.absmax, self.velocity, variedCount, self.skin);
	self.think = self.w_think;
	
	if( (self.spawnflags & 2) ){
		if( time > self.data_lifetime ){
		  if( self.trigOnDeath )
        trigger_event( self, self.trigOnDeath );
      
		  if( (self.spawnflags & 64) )
        remove(self);
		  
		  return;
		}
	}
	self.nextthink = time + 0.1;
};

/*QUAKED func_snow (0 .8 1) ? START_OFF LIFETIME DELAY INTERVAL USE_WIND VARIABLE_COUNT REMOVE
 Using te_particlerain, this slightly overwrites a DP original ent.
 Creates a particle cube of rain based on a brush defined in the bsp.
 
 .velocity = <vector> the directional value of the rain.
 .skin = <float> 8bit color value of particle.
 .count = <float> amount of particulate.
 
 .targetname = <string> allow this entity to be activated by trigger system.
 .onSpawn = <string> fire entity when this spawns.
 .onDeath = <string> fire entity when lifetime runs out.
 
 .delay = <float> delay before starting when triggered.
 .data_lifetime = <float> game time before effect shuts off.
 
 1 START_OFF = Requires targetname and a trigger call.
 2 LIFETIME = Func is turned off after .data_lifetime game seconds.
 4 DELAY = wait .delay game seconds after being activated to begin.
 8 INTERVAL = fluctuate between on-and-off.
 16 USE_WIND = rain will be affected by map's WIND values.
 32 VARIABLE_COUNT = .count will be subject to slight randomization.
 64 REMOVE = remove this after lifetime expires, or when turned off.
*/
void() func_snow={
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.w_think = func_snow_think;
  self.use = func_particle_cube_use;
  
  trigger_ext_check();
  if( self.trigOnSpawn ){
    trigger_event( self, self.trigOnSpawn );
  }
  if( (self.spawnflags & 1) ){
    return;
  }
  self.use();
};
