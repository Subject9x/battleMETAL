/*
Quake 1**
author: iD Software

** - this has been modified to be incorporated into battleMETAL and is not compatible with
      other code bases.
*/

/*
  a poor man's interface. Entities can sign up for the even system
  by invoking trigger_event at the appropriate time (heh or any time really)
  and this handles the event.
  
  .string event is the target name where there are several choices now,
    .string onDeath;
    .string onSpawn;
    .string onDamage;
    .string onPanic;
    .string onAttack;
  and the correct string should be used accordingly.
  The function then slots that string into its .target value,
    fires the SUB_UseTargets() function (thus firing target triggers)
  then reloads the original .target value, and returns.
*/
void( entity active, string event) trigger_event={
  local string oldTarget;
  local string thisTarget;  //something something method arg stack
  
  if( event == string_null ){
    return;
  }
  if( !active ){
    activator = find(world, classname, "player");
  }
  else{
    activator = active;
  }
  
  if( self.target == string_null ){
    self.target = event;
    SUB_UseTargets();
  }
  else{
    if( self.target != event ){
      oldTarget = self.target;
      thisTarget = event;
      
      self.target = thisTarget;
        SUB_UseTargets();
      self.target = oldTarget;
    }
    else{
      SUB_UseTargets();
    }
  }
};

void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
  if (self.nextthink > time)
  {
    return; // already been triggered
  }

  if (self.classname == "trigger_secret")
  {
    if (self.enemy.classname != "player"){
      return;
    }
    found_secrets = found_secrets + 1;
    WriteByte (MSG_ALL, SVC_FOUNDSECRET);
  }

  if (self.noise){
    sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
  }
  // don't trigger again until reset
  self.takedamage = DAMAGE_NO;

  activator = self.enemy;
  
  SUB_UseTargets();

  if (self.wait > 0){
    self.think = multi_wait;
    self.nextthink = time + self.wait;
  }
  else{
    // we can't just remove (self) here, because this is a touch function
    // called wheil C code is looping through area links...
    self.touch = SUB_Null;
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
  }
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch =
{
	if (other.classname != "player")
		return;
  
// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	multi_trigger ();
};



/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_multiple =
{
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
	
	if (!self.wait)
		self.wait = 0.2;
  
	self.use = multi_use;

	InitTrigger ();

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


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void() trigger_secret =
{
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

	trigger_multiple ();
};

//=============================================================================


void() counter_use =
{
	self.count = self.count - 1;
	if (self.count > 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
      if( self.vec_size && self.vec_size > 0) {
        if( self.count >= self.vec_size ){
          if( self.deathmsg != "" ){
            centerprint (activator, self.deathmsg );
          }
          else{
            centerprint (activator, "There are more to go...");
          }
        }
        else{
          if( self.description != "" && self.abbrev != "" ){
            centerprint (activator, strcat( self.description, " ", ftos(self.count), " ", self.abbrev ));
          }
          else{
            centerprint( activator, sprintf("Only %u more to go...", self.count));
          }
        }
      }
      else{
        //legacy / default logic
        if (self.count >= 4){
          if( self.deathmsg != "" ){
            centerprint (activator, self.deathmsg );
          }
          else{
            centerprint (activator, "There are more to go...");
          }
        }
        else{
          centerprint( activator, sprintf("Only %u more to go...", self.count));
        }
      }
		}
		return;
	}
	
	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0){
  	if( self.message != "" && self.message ){
      centerprint(activator, self.message);
    }
    else{
      centerprint(activator, "Sequence completed!");
    }
  }
  self.enemy = activator;
  multi_trigger ();
  if( !(self.flags & 32) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage NO_EASY NO_NORM NO_HARD NO_NIGHT
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.

-------- KEYS --------
message = <string> played when 'sequence complete'
description = <string> text to write before the <.count> value.
abbrev = <string> text to write AFTER <.count> value.
deathmsg = <string> text to write instead of "more to go"
vec_size = <float> threshold to determine between "more to go" and "x to go"
-------- SPAWNFLAGS --------
nomessage 1
NO_EASY 2 : remove when skill = 0
NO_NORM 4 : remove when skill = 1
NO_HARD 8 : remove when skill = 2
NO_NIGHT 16 : remove when skill = 3
NO_REMOVE 32 : don't remove when sequence complete.
*/
void() trigger_counter =
{
  //remove based on skill
  //I use this for wave-based maps to 'dynamically' change wave kill counts.
  switch(skill){
    default:
      if( (self.spawnflags & 2) ){
        remove(self);
        return;
      }
      break;
    case 1:
      if( (self.spawnflags & 4) ){
        remove(self);
        return;
      }
      break;
    case 2:
      if( (self.spawnflags & 8) ){
        remove(self);
        return;
      }
      break;
    case 3:
      if( (self.spawnflags & 16) ){
        remove(self);
        return;
      }
      break;
  }

	self.wait = -1;
	if (!self.count){
		self.count = 2;
  }
	self.use = counter_use;
};


/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/



void() play_teleport =
{
	local	float v;
	local	string tmpstr;

	v = random() * 5;
	if (v < 1)
	{
        precache_sound ("misc/r_tele1.wav");
		tmpstr = "misc/r_tele1.wav";
	}
	else if (v < 2)
	{
        precache_sound ("misc/r_tele2.wav");
		tmpstr = "misc/r_tele2.wav";
	}
	else if (v < 3)
	{
        precache_sound ("misc/r_tele3.wav");
		tmpstr = "misc/r_tele3.wav";
	}
	else if (v < 4)
	{
        precache_sound ("misc/r_tele4.wav");
		tmpstr = "misc/r_tele4.wav";
	}
	else
	{
        precache_sound ("misc/r_tele5.wav");
		tmpstr = "misc/r_tele5.wav";
	}

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	s = spawn ();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void() tdeath_touch =
{
	if (other == self.owner)
		return;

// frag anyone who teleports in on top of an invincible player
	//if (other.classname == "player")
	//{
		//if (other.invincible_finished > time)
			//self.classname = "teledeath2";
		//if (self.owner.classname != "player")
		//{	// other monsters explode themselves
			//T_Damage (self.owner, self, self, 50000);
			//return;
		//}
		
	//}

	if (other.health)
	{
		T_Damage (other, self, self, 50000);
	}
};


void(vector org, entity death_owner) spawn_tdeath =
{
local entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	
	force_retouch = 2;		// make sure even still objects get hit
};

void() teleport_touch =
{
local entity	t;
local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets ();

// put a tfog where the player was
	spawn_tfog (other.origin);

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
		
// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath(t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
		objerror ("no targetname");
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/
void() trigger_teleport =
{
	local vector o;

	InitTrigger ();
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

/*
==============================================================================

trigger_setskill

==============================================================================
*/

void() trigger_skill_touch =
{
	if (other.classname != "player")
		return;
		
	cvar_set ("skill", self.message);
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void() trigger_setskill =
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
};

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = time + 1;
	}

	return;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void() trigger_hurt =
{
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

//============================================================================

void() trigger_push_touch =
{
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void() trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void() trigger_monsterjump_touch =
{
	if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	
	if ( !(other.flags & FL_ONGROUND) )
		return;
	
	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
*/
void() trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

void() toggleweapons_touch={
  if( (other.flags & FL_CLIENT) ){
    if( (self.spawnflags & 16) ){
      //DISABLE_ONLY
      if( !(other.flags & FL_NOSHOOT) ){
        other.flags = other.flags | FL_NOSHOOT;
        if( other.clientData != world ){
          other.clientData.SendFlags = other.clientData.SendFlags | SENDFLAG_EFLAGS;
        }
      }
      return;
    }
    if( (self.spawnflags & 32) ){
      //ENABLY_ONLY
      if( (other.flags & FL_NOSHOOT) ){
        other.flags = other.flags - (other.flags & FL_NOSHOOT);
        if( other.clientData != world ){
          other.clientData.SendFlags = other.clientData.SendFlags | SENDFLAG_EFLAGS;
        }
      }
      return;
    }
  
    if( time > self.delay ){
      self.enemy = world;
    }
    if( self.enemy != other ){
      self.delay = time + self.wait;
      self.enemy = other;
      if( (other.flags & FL_NOSHOOT) ){
        other.flags = other.flags - (other.flags & FL_NOSHOOT);
      }
      else{
        other.flags = other.flags | FL_NOSHOOT;
      }
      if( other.clientData != world ){
        other.clientData.SendFlags = other.clientData.SendFlags | SENDFLAG_EFLAGS;
      }
      if( (self.spawnflags & 8) ){
        self.think = SUB_Remove;
        self.nextthink = time + 0.01;
      }
    }
  }
};

/*QUAKED trigger_toggleweapons (.5 .5 .5) ? START_OFF LIFETIME REACTIVATE REMOVE DISABLE_ONLY ENABLY_ONLY
  Toggles Player's ability to shoot stuff (or turns it on if it was off.)
  FL_NOSHOOT
  
-------- KEYS -------- 
  .wait = time between reactivations
-------- SPAWNFLAGS --------
START_OFF 1: <UNUSED>
LIFETIME 2: <UNUSED>
REACTIVATE 4: <UNUSED>
REMOVE 8: remove on first-touch.
DISABLE_ONLY 16: only disables player, adds FL_NOSHOOT
ENABLY_ONLY 32: only re-enables player, removes FL_NOSHOOT
*/
void() trigger_toggleweapons={
  InitTrigger ();
  
  self.touch = toggleweapons_touch;
  
  if( (self.spawnflags & 2) ){
    self.think = SUB_Remove;
    self.nextthink = time + self.data_lifetime;
  }
};


void() trigger_stuffcmd_think={
  stuffcmd( activator, self.message);
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

/*QUAKED trigger_stuffcmd (.5 .5 .5) (-8 -8 -8) (8 8 8)
Stuffs the supplied commands into the client's console.
Note: not touchable, must be targetted.
fields:
"targetname"
 must be set
"wait"
 seconds between triggerings (.5 default)
"message"
 commands (such as "bf", use ; to separate commands)
*/
void() trigger_stuffcmd={
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  if( self.targetname && self.message ){
    self.use = trigger_stuffcmd_think;
  }
  else{
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};


void() trigger_timer_activate={
	if (activator.classname == "player" && !(self.spawnflags & SPAWNFLAG_NOMESSAGE)){
    if( self.message ){
      centerprint(activator, self.message);
    }
  }
	self.enemy = activator;
	multi_trigger();
};
void() trigger_timer_use={
  if( self.isActive < 0 ){
    //prevent multiple calls
    return;
  }
  
  self.isActive = -1;
  self.think = trigger_timer_activate;
  self.nextthink = time + self.count;
};
/*QUAKED trigger_timer (.5 .5 .5) ? nomessage NO_EASY NO_NORM NO_HARD NO_NIGHT
Waits for .count game seconds before firing .target

After the timer expires, it will fire all of it's targets and remove itself.
-------- KEYS -------- 
.count = <float> game seconds to count before firing.
.message = <string> message to display on end of countdown.

-------- SPAWNFLAGS --------
nomessage 1
NO_EASY 2 : 
NO_NORM 4 :
NO_HARD 8 :
NO_NIGHT 16 :
START_ON 32 : starts when map starts.
*/
void() trigger_timer =
{
  //remove based on skill
  //I use this for wave-based maps to 'dynamically' change wave kill counts.
  switch(skill){
    default:
      if( (self.spawnflags & 2) ){
        remove(self);
        return;
      }
      break;
    case 1:
      if( (self.spawnflags & 4) ){
        remove(self);
        return;
      }
      break;
    case 2:
      if( (self.spawnflags & 8) ){
        remove(self);
        return;
      }
      break;
    case 3:
      if( (self.spawnflags & 16) ){
        remove(self);
        return;
      }
      break;
  }

  if( !self.count ){
   dprint("trigger_timer missing count value\n");
   remove(self);
   return;
  }
  self.delay = 0; // multi_trigger issue.
  if( (self.spawnflags & 32) ){
    self.isActive = -1;
    self.think = trigger_timer_activate;
    self.nextthink = time + self.count;
    return;
  }
  
  self.isActive = 1;
	self.use = trigger_timer_use;
};
