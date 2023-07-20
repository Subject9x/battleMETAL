/*
battleMETAL
Author: Peter Roohr
Date: 3/23/2018
Overview: sv_saveentfile console command does print out all the entities in a map to a text file, and 
changes to that text file can be loaded back into the map. Unfortunately the function prints out brush-based
trigger ents with a "model" reference that's too tightly couple to compiled maps. Therefore to decouple triggers
from brushes, this function set exists to make triggers / map logic ents via the text file, using the builtin
vector vars .mins and .maxs 
*/

//from InitTrigger
void() map_initTrigger={
// trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (self.movedir == '0 0 0')
	  if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.movetype = MOVETYPE_NONE;
  self.modelindex = 0;
  self.model = "";
};


void() map_trigger_changelevel={
  map_initTrigger ();
  
  if( !(self.spawnflags & 4) ){
		if (!self.map)
			objerror ("changelevel trigger doesn't have map");
  }
  
  if(self.isActive){
    self.touch = changelevel_touch;
  }
  else{
    self.use = changelevel_use;
  }
};

/*
  self.fx_origin = screen position (in percent)
  self.compAltOffset = screen size (in percent );
  self.compOffset = color
  self.dmgtime = time to show up
*/
void() map_trigger_highlighthud={
	map_initTrigger ();
	self.noise = "misc/talk.wav";
	self.solid = SOLID_TRIGGER;
	if (!self.wait)
		self.wait = 0.2;
	
	self.use = multi_use;
	self.touch = highlight_hud_touch;
	if (self.nextthink > time)
		return;		// allready been triggered
	
};

void() map_trigger_multiple={
  map_initTrigger ();
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}
	
	if (!self.wait){
		self.wait = 0.2;
  }
	self.use = multi_use;

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) )
		{
			self.touch = multi_touch;
		}
	}
}; 

void() map_trigger_once={
	self.wait = -1;
	map_trigger_multiple();
};

void() map_trigger_relay={
  map_initTrigger();
	self.use = SUB_UseTargets;
}; 

void() map_trigger_secret={
	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "You found a secret area!";
    
	if (!self.sounds)
		self.sounds = 1;
	
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	map_trigger_multiple ();
};

void() map_trigger_counter={
  map_initTrigger();
	
  self.wait = -1;
	if ( !self.count )
		self.count = 2;  

	self.use = counter_use;
};

void() map_trigger_teleport={
	local vector o;

	map_initTrigger ();
	self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o, "ambience/hum1.wav",0.5 , ATTN_STATIC);
	}
};

void() map_trigger_setskill={
	map_initTrigger ();
	self.touch = trigger_skill_touch;
};

void() map_trigger_hurt={
	map_initTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

void() map_trigger_push={
	map_initTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};

/*QUAKED func_rain (0 .8 1) (-8 -8 -64) (8 8 64) START_OFF LIFETIME DELAY INTERVAL USE_WIND VARIABLE_COUNT REMOVE
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
void() map_func_rain={
  local vector tempMin, tempMax, velocityAdj;
  tempMin = self.mins;
  tempMax = self.maxs;
  
  self.angles = '0 0 0';
  setmodel(self, "");
  setsize(self, tempMin, tempMax);
  setorigin(self, self.origin);
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  makevectors(self.angles);
  velocityAdj = (v_up * 0) + (v_right * 48) + (v_forward * 32);
  velocityAdj = normalize( velocityAdj - self.origin );
  self.velocity = self.velocity * 50;
  self.velocity = '0 0 -100';
  
  self.w_think = func_snow_think;
  self.use = func_particle_cube_use;
  
  trigger_ext_check();
  if( self.trigOnSpawn ){
    trigger_event( self, self.trigOnSpawn );
  }
  if( (self.spawnflags & 1) ){
    return;
  }
  self.think = self.use;
  self.nextthink = time + 0.1;
};


/*void() func_destruct_die_explode={
  
};

void() func_destruct_die_collapse={


};*/

void() func_destruct_die_dbg={
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};


/*QUAKED func_destructible (0 .8 1) ? 
  Brush-based shootable whose death will send triggers
  health : int = starting health
  
  shield : int = shielded or not
  
  
*/
void() func_destructible={
  self.mangle = self.angles;
  self.angles = '0 0 0';

  self.classname = "destruct";
  self.solid = SOLID_BSP;
  self.movetype = MOVETYPE_NONE;
  setorigin (self, self.origin);
  setmodel (self, self.model);
  setsize (self, self.mins , self.maxs);

  self.takedamage = DAMAGE_YES;
  
  if(!self.health){
    self.health = 100;
    self.max_health = self.health;
  }
  
  if(!self.shield){
    self.shield = 0;
    self.shieldMax = 0;
  }
  
  self.th_die = func_destruct_die_dbg;
};


#define SPAWNFLAG_TRIG_SHIELD 2
#define SPAWNFLAG_TRIG_ENRGY 4
#define SPAWNFLAG_TRIG_RADAR 8
#define SPAWNFLAG_VAL_LESS 16
#define SPAWNFLAG_VAL_MORE 32
#define SPAWNFLAG_VAL_EQL 64
#define SPAWNFLAG_DEAL_FEEDBACK 128


void() trigger_stat_touch=
{
	local float fire;
	local float perc;

	if(!(other.flags & FL_CLIENT)){
		return;
	}
	
	fire = FALSE;

	if((self.spawnflags & SPAWNFLAG_TRIG_SHIELD)){
		perc = other.shield / other.shieldMax;

		if((self.spawnflags & SPAWNFLAG_VAL_LESS)){
			if(perc < self.shield){
				fire = TRUE;
			}
		}
		else if((self.spawnflags & SPAWNFLAG_VAL_MORE)){
			if(perc > self.shield){
				fire = TRUE;
			}
		}
		else if((self.spawnflags & SPAWNFLAG_VAL_EQL)){
			if(perc >= self.shield - 0.05 && perc <= self.shield + 0.05){
				fire = TRUE;
			}
		}
	}

	if((self.spawnflags & SPAWNFLAG_TRIG_ENRGY)){
		perc = other.energy / other.energyMax;
		if((self.spawnflags & SPAWNFLAG_VAL_LESS)){
			if(perc < self.energy){
				fire = TRUE;
			}
		}
		else if((self.spawnflags & SPAWNFLAG_VAL_MORE)){
			if(perc > self.energy){
				fire = TRUE;
			}
		}
		else if((self.spawnflags & SPAWNFLAG_VAL_EQL)){
			if(perc >= self.energy - 0.05 && perc <= self.energy + 0.05){
				fire = TRUE;
			}
		}
	}
	
	if((self.spawnflags & SPAWNFLAG_TRIG_RADAR)){	
		if((self.spawnflags & SPAWNFLAG_VAL_EQL)){
			if(self.stat_rdr_mode == other.stat_rdr_mode){
				fire = TRUE;
			}
		}
		else{
			if(self.stat_rdr_mode != other.stat_rdr_mode){
				fire = TRUE;
			}
		}
	}

	if(fire){
		if((self.spawnflags & SPAWNFLAG_DEAL_FEEDBACK)){
			if((self.spawnflags & SPAWNFLAG_TRIG_ENRGY)){
				other.energy = max(0, other.energy - (self.energy * other.energyMax));
			}
			if((self.spawnflags & SPAWNFLAG_TRIG_SHIELD)){
				t_damage_shield(other, world, world, self.shield * other.shieldMax, other.origin, FALSE); 
			}
		}

		self.solid = SOLID_NOT;
		SUB_UseTargets();
		remove(self);
		return;
	}
	centerprint(other, strcat(self.abbrev, "\n"));
};

/*

*/
void() trigger_on_stat=
{
	InitTrigger();

	self.touch = trigger_stat_touch;
	
	if(!self.target || strlen(self.target) <= 0){
		if(!self.killtarget || strlen(self.killtarget) <= 0){
			objerror("missing target for trigger.\n");
			remove(self);
			return;
		}
	}

	if((self.spawnflags & SPAWNFLAG_TRIG_SHIELD)){
		if(!self.shield){
			self.shield = 1.0;
		}
		else{
			self.shield = self.shield / 100;
		}
	}

	if((self.spawnflags & SPAWNFLAG_TRIG_ENRGY)){
		if(!self.energy){
			self.energy = 1.0;
		}
		else{
			self.energy = self.energy / 100;
		}
	}
};