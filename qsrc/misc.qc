
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
+ will be converted to rtlight file line on console command "cmd mech rtexport"

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
  setmodel(self, "q3mdl/testball.md3");
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
  setmodel(self, "q3mdl/testball.md3");
  
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
	precache_model ("progs/s_light.spr");
	setmodel (self, "progs/s_light.spr");
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
	precache_model ("progs/flame.mdl");
	setmodel (self, "progs/flame.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame ball
*/
void() light_flame_large_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	self.frame = 1;
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame ball
*/
void() light_flame_small_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
Small white flame ball
*/
void() light_flame_small_white =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

//============================================================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
Lava Balls
*/

void() fire_fly;
void() fire_touch;
void() misc_fireball =
{
	
	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";
	self.nextthink = time + (random() * 5);
	self.think = fire_fly;
	if (!self.speed)
		self.speed = 1000;
};

void() fire_fly =
{
local entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	fireball.nextthink = time + 5;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	
	self.nextthink = time + (random() * 5) + 3;
	self.think = fire_fly;
};


void() fire_touch =
{
	T_Damage (other, self, self, 20);
	remove(self);
};

//============================================================================


void() barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	// did say self.owner
	//T_RadiusDamage (self, self, 160, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	particle (self.origin, '0 0 0', 75, 255);

	self.origin_z = self.origin_z + 32;
	BecomeExplosion ();
};



/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void() misc_explobox =
{
	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("maps/b_explob.bsp");
	setmodel (self, "maps/b_explob.bsp");
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void() misc_explobox2 =
{
	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model2 ("maps/b_exbox2.bsp");
	setmodel (self, "maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

//============================================================================

float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;

//void(vector org, vector vec) LaunchLaser;

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		//LaunchLaser (self.origin, self.movedir);
	}
	else
	{
		sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		//launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE){
			//newmis.touch = superspike_touch;
    }
	}
};

void() shooter_think =
{
	spikeshooter_use ();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

void() trap_spikeshooter =
{
	SetMovedir ();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2 ("progs/laser.mdl");
		
		precache_sound2 ("enforcer/enfire.wav");
		precache_sound2 ("enforcer/enfstop.wav");
	}
	else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();
	
	if (self.wait == 0)
		self.wait = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};



/*
===============================================================================


===============================================================================
*/


void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)

testing air bubbles
*/

void() air_bubbles =

{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles =
{
local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
local entity	bubble;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = 10;
	if (self.waterlevel != 3)
		remove (self);
};

void() bubble_remove =
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void() bubble_bob =
{
  local float		rnd1, rnd2, rnd3;

	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;
		
	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;
		
	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
		
	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/

void() viewthing =

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
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
/*QUAKED ambient_suck_wind (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_suck_wind =
{
	precache_sound ("ambience/suck1.wav");
	ambientsound (self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drone =
{
	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_flouro_buzz =
{
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drip =
{
	precache_sound ("ambience/drip1.wav");
	ambientsound (self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_comp_hum =
{
	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_light_buzz =
{
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp1 =
{
	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp2 =
{
	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
};

//============================================================================

void() noise_think =
{
	self.nextthink = time + 0.5;
	sound (self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound (self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound (self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound (self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound (self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound (self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
};

/*QUAKED misc_noisemaker (1 0.5 0) (-10 -10 -10) (10 10 10)

For optimzation testing, starts a lot of sounds.
*/

void() misc_noisemaker =

{
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/idle1.wav");

	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};

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
  
  if( self.trigOnSpawn )
    trigger_event( self, self.trigOnSpawn );
  
  if( (self.spawnflags & 1) )
    return;
  
  
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
  
  if( self.trigOnSpawn )
    trigger_event( self, self.trigOnSpawn );
  
  if( (self.spawnflags & 1) )
    return;
  
  self.use();
};
