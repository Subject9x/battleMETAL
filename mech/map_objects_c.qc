/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: storage for map ents, i guess.
I pulled these out of client.qc, what they were doing there I have 
no idea;
*/

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
  self.use = changelevel_use;
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