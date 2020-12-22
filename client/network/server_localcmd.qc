/*
battleMETAL
Author: Peter Roohr
Date: 3/8/2017
mod: 07/25/2019
Overview: class file for the client -> server command layer

*/

/*
  Setter functions, pipes client data up to server.
*/
void(float totalWeps, string wepList) cl_setweapon={

  local string cmd;
  cmd = strcat("cmd m sw ", ftos(totalWeps), wepList, "\n");
  localcmd(cmd);
};

void(float id) cl_setmech={
  local string cmd;
  local string factionColors;
  
  switch( CLIENT_faction ){
    case 2:
      factionColors = PLAYER_COLOR_SRV;
      break;
      
    case 3:
      factionColors = PLAYER_COLOR_MIL;
      break;
      
    default:
      factionColors = PLAYER_COLOR_PSC;
      break;
  }
  
  cmd = strcat("cmd m sm ", ftos(id), " ");
  cmd = strcat(cmd, factionColors,"\n");
  localcmd(cmd);
};

void() cl_spawnmech={
  local string cmd;
  cmd = "cmd m sp\n";
  localcmd(cmd);
};

void( float newFaction ) cl_set_faction={
  local string cmd;
  cmd = strcat("cmd m fac ", ftos(newFaction),"\n");
  localcmd(cmd);
};

void(float group1, float group2, float group3, float group4 ) cl_setweapongroup={

  local string cmd;
  cmd = strcat("cmd m sg ",ftos(group1), " ", ftos(group2), " ");
  cmd = strcat(cmd,  ftos(group3), " ", ftos(group4), "\n");
  localcmd(cmd);
  
};

void(float nav_id) cl_setspawnpoint={
  local string cmd;
  cmd = strcat("cmd m sn ", ftos(nav_id), "\n");
  localcmd(cmd);
};

void(float nextMissionBool) cl_set_mission={
  local string cmd;
  cmd = strcat("cmd m nxm ", ftos(nextMissionBool),"\n");
  localcmd(cmd);
};

/*
  Getter functions, receives stuffcmd()'s from server.
*/
void(string fileName) cl_get_msnfile={
  MSN_FILENAME = strzone(fileName);
  msn_getfile();
};

void(string fileName) cl_get_animfile={
  if(ANM_FILE_STATUS == 0){
    anm_parseFile(fileName);
  }
};

void() cl_exit_animatic={
  local string cmd;    
  if( ANM_FILE_STATUS == TRUE ){
    //animation is playing;
    anm_cleanup();
    cmd = "cmd m exan\n";
    localcmd(cmd);
  }
};

/*
  Player Mech Spawn - set CL_ vars
*/

void( entity mech, float turboMod ) cl_set_hud_vars={
  cvar_set("cl_forwardspeed", ftos(mech.data_speed_forward));
  cvar_set("cl_sidespeed", ftos(mech.data_speed_strafe));
  cvar_set("cl_backspeed", ftos(mech.data_speed_backward));
  cvar_set("cl_movespeedkey", ftos(mech.data_speed_accel + turboMod));
  cvar_set("cl_rollangle",  ftos(mech.hud_rollangle));
  cvar_set("cl_bob", ftos(mech.hud_bob));
  cvar_set("cl_bobcycle", ftos(mech.hud_bob_cycle));
  cvar_set("cl_bobup", ftos(mech.hud_bob_up));
  cvar_set("cl_bobmodel", ftos(mech.hud_bob_model));
  cvar_set("cl_bobmodel_side", ftos(mech.hud_bob_side));
  cvar_set("cl_bobmodel_speed", ftos(mech.hud_bob_speed));
  cvar_set("cl_bobmodel_up", ftos(mech.hud_bob_model_up));
  cvar_set("in_pitch_max", ftos(mech.pitchMax));
  cvar_set("in_pitch_min", ftos(mech.pitchMin));
  
  HUD_PITCH_MAX = mech.pitchMax;
  HUD_PITCH_MIN = mech.pitchMin;
};

void() cl_set_hud_vars_obs={
  cvar_set("cl_forwardspeed", "500");
  cvar_set("cl_sidespeed", "500");
  cvar_set("cl_backspeed", "500");
  cvar_set("cl_movespeedkey", "1.5");
  cvar_set("in_pitch_max", "90");
  cvar_set("in_pitch_min", "-90");
};

/*
  Receive new fog transition info
*/
void( string fogSettings ) cl_get_new_fog={
  
  tokenizebyseparator( fogSettings, " " );

  FOG_STATE = 1;
  FOG_TARG_DENSITY = stof(argv(1));
  FOG_TARG_RED = stof(argv(2));
  FOG_TARG_GREEN = stof(argv(3));
  FOG_TARG_BLUE = stof(argv(4));
  FOG_TARG_ALPHA = stof(argv(5));
  FOG_TARG_DIST_MIN = stof(argv(6));
  FOG_TARG_DIST_MAX = stof(argv(7));
  FOG_TARG_DIST_TOP = stof(argv(8));
  FOG_TARG_FADE_DEPTH = stof(argv(9));
};

/*
  Receive new music track to jam
*/
void( string musicSet ) cl_get_new_music={
  local float music;
  
  tokenizebyseparator( musicSet, " ");
  
  music = stof( argv(2) );
  
  if( music != MUSICID){
    MUSICID = music;
    localcmd( musicSet );
  }
};

//one-off, don't use normally.
//use normal keybinds and cvars to track chase_active, this is here for when
// the player specfically spawns into their mech.
void() cl_set_chase={
  local string cmd;
  if(cvar("chase_active") == TRUE ){
    cmd = "impulse 30\n";
    localcmd(cmd);
  }
}; 