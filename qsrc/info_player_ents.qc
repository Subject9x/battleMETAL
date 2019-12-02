/*
Quake 1**
Author: iD software
Overview: 
  storage for map ents, i guess.
  I pulled these out of client.qc, what they were doing there I have 
    no idea;
    
** - this has been modified to be incorporated into battleMETAL and is not compatible with
      other code bases.
*/

/*QUAKED info_player_observer_start (1 0 0) (-16 -16 -24) (16 16 24)
  the system looks for this first, to spawn in observers
*/
void() info_player_observer_start={
  
};

//if intermission has a target, look at it.
void() info_intermission_check={
  local entity targ;
  targ = find(world, targetname, self.target);
  if( targ ){
    self.mangle = vectoangles(targ.origin - self.origin);
    self.mangle_x = self.mangle_x * -1;
  }
};

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
  if( self.target ){
    self.think = info_intermission_check;
    self.nextthink = time + 0.05;
  }
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
  "isActive" : 1 == activate by touch, 0 = activate by remote
  "count" : <float> count in game seconds till intermission is over;
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");
	
	InitTrigger ();
	
  if(self.isActive){
    self.touch = changelevel_touch;
  }
  else{
    self.use = changelevel_use;
  }
};

void() info_player_deathmatch_activate =
{
	self.classname = self.mdl;
	self.mdl = "";
	self.use = SUB_Null;
};

void() info_player_deathmatch_setup =
{
	if (self.targetname)
	{
		self.use = info_player_deathmatch_activate;
		self.mdl = self.classname;
		self.classname = ""; // restored when triggered
	}
};

/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
  setsize(self, '-16 -16 -24', '16 16 24');
  setorigin(self, self.origin);
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};


/*
saved out by quaked in region mode
*/
void() testplayerstart =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
  setsize(self, '-16 -16 -24', '16 16 24');
  setorigin(self, self.origin);
};

/*QUAKED info_player_team1 (.7 0 0) (-16 -16 -24) (16 16 24)
potential spawning position for teamplay games
team #1 - red

new in Dark Places:
"targetname"
 inactive (skipped) until triggered.
 (for use in combination with
  trigger_playercount)
*/
void() info_player_team1 =
{
	info_player_deathmatch_setup();
};

/*QUAKED info_player_team2 (0 0 .7) (-16 -16 -24) (16 16 24)
potential spawning position for teamplay games
team #2 - blue

new in Dark Places:
"targetname"
 inactive (skipped) until triggered.
 (for use in combination with
  trigger_playercount)
*/
void() info_player_team2 =
{
	info_player_deathmatch_setup();
};

/*QUAKED info_player_team3 (.7 .7 .7) (-16 -16 -24) (16 16 24)
potential spawning position for teamplay games
team #3 - grey

new in Dark Places:
"targetname"
 inactive (skipped) until triggered.
 (for use in combination with
  trigger_playercount)
*/
void() info_player_team3 =
{
	info_player_deathmatch_setup();
};