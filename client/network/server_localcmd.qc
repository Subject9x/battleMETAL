/*
battleMETAL
Author: Peter Roohr
Date: 3/8/2017
mod: 07/25/2019
Overview: class file for the client -> server command layer

*/
void() cl_ini_infostring={
  local string infoset;
  
  infoset = "";
  infoset = infoadd(infoset, KEY_DEPLOY, ftos(0));
  infoset = infoadd(infoset, KEY_FACTION,ftos(0));
  infoset = infoadd(infoset, KEY_COLOR1, ftos(0));
  infoset = infoadd(infoset, KEY_COLOR2, ftos(0));
  infoset = infoadd(infoset, KEY_COLOR3, ftos(0));
  infoset = infoadd(infoset, KEY_COLOR4, ftos(0));
  infoset = infoadd(infoset, KEY_COLOR5, ftos(0));
  infoset = infoadd(infoset, KEY_COLOR6, ftos(0));
  infoset = infoadd(infoset, KEY_MECH,   ftos(0));
  infoset = infoadd(infoset, KEY_GROUP1, ftos(0));
  infoset = infoadd(infoset, KEY_GROUP2, ftos(0));
  infoset = infoadd(infoset, KEY_GROUP3, ftos(0));
  infoset = infoadd(infoset, KEY_GROUP4, ftos(0));
  infoset = infoadd(infoset, KEY_WEPN1,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN2,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN3,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN4,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN5,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN6,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN7,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN8,  ftos(0));
  infoset = infoadd(infoset, KEY_WEPN9,  ftos(0));
  
  cacheGlobalString(CLIENT_INFO_STRING, infoset)
};

/*
  Sends to SV_ParseClientCommand()
    only sends delta of CLIENT_INFO_STRING changes via flag valeues
*/
void(float changeFlags) cl_send_infostring={
  local string serverCmd;
  local string updateInfoString;
  local float keyFlags;
  
  updateInfoString = "";
  
  if( (changeFlags & INFO_FLAG_FACTION) ){
    updateInfoString = infoadd(updateInfoString, KEY_FACTION, infoget(CLIENT_INFO_STRING, KEY_FACTION));
  }
  if( (changeFlags & INFO_FLAG_MECH) ){
    updateInfoString = infoadd(updateInfoString, KEY_MECH, infoget(CLIENT_INFO_STRING, KEY_MECH));
  }
  if( (changeFlags & INFO_FLAG_DEPLOY) ){
    updateInfoString = infoadd(updateInfoString, KEY_DEPLOY, infoget(CLIENT_INFO_STRING, KEY_DEPLOY));
  }
  if( (changeFlags & INFO_FLAG_COLOR) ){
    updateInfoString = infoadd(updateInfoString, KEY_COLOR1, infoget(CLIENT_INFO_STRING, KEY_COLOR1));
    updateInfoString = infoadd(updateInfoString, KEY_COLOR2, infoget(CLIENT_INFO_STRING, KEY_COLOR2));
    updateInfoString = infoadd(updateInfoString, KEY_COLOR3, infoget(CLIENT_INFO_STRING, KEY_COLOR3));
    updateInfoString = infoadd(updateInfoString, KEY_COLOR4, infoget(CLIENT_INFO_STRING, KEY_COLOR4));
    updateInfoString = infoadd(updateInfoString, KEY_COLOR5, infoget(CLIENT_INFO_STRING, KEY_COLOR5));
    updateInfoString = infoadd(updateInfoString, KEY_COLOR6, infoget(CLIENT_INFO_STRING, KEY_COLOR6));
  }
  
  if( (changeFlags & INFO_FLAG_GROUPS) ){
    updateInfoString = infoadd(updateInfoString, KEY_GROUP1, infoget(CLIENT_INFO_STRING, KEY_GROUP1));
    updateInfoString = infoadd(updateInfoString, KEY_GROUP2, infoget(CLIENT_INFO_STRING, KEY_GROUP2));
    updateInfoString = infoadd(updateInfoString, KEY_GROUP3, infoget(CLIENT_INFO_STRING, KEY_GROUP3));
    updateInfoString = infoadd(updateInfoString, KEY_GROUP4, infoget(CLIENT_INFO_STRING, KEY_GROUP4));
  }
  if( (changeFlags & WEAPON1) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN1, infoget(CLIENT_INFO_STRING, KEY_WEPN1));
  }
  if( (changeFlags & WEAPON2) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN2, infoget(CLIENT_INFO_STRING, KEY_WEPN2));
  }
  if( (changeFlags & WEAPON3) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN3, infoget(CLIENT_INFO_STRING, KEY_WEPN3));
  }
  if( (changeFlags & WEAPON4) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN4, infoget(CLIENT_INFO_STRING, KEY_WEPN4));
  }
  if( (changeFlags & WEAPON5) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN5, infoget(CLIENT_INFO_STRING, KEY_WEPN5));
  }
  if( (changeFlags & WEAPON6) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN6, infoget(CLIENT_INFO_STRING, KEY_WEPN6));
  }
  if( (changeFlags & WEAPON7) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN7, infoget(CLIENT_INFO_STRING, KEY_WEPN7));
  }
  if( (changeFlags & WEAPON8) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN8, infoget(CLIENT_INFO_STRING, KEY_WEPN8));
  }
  if( (changeFlags & WEAPON9) ){
    updateInfoString = infoadd(updateInfoString, KEY_WEPN9, infoget(CLIENT_INFO_STRING, KEY_WEPN9));
  }
  if( (changeFlags & INFO_FLAG_SPAWN) ){
    //updateInfoString = infoadd(updateInfoString, KEY_DEPLOY, infoget(CLIENT_INFO_STRING, KEY_DEPLOY));
  }
  else{
    //updateInfoString = infoadd(updateInfoString, KEY_DEPLOY, infoget(CLIENT_INFO_STRING, KEY_DEPLOY));
  }
  
  keyFlags = keyFlags | changeFlags;
  updateInfoString = infoadd(updateInfoString, KEY_FLAGS, ftos(keyFlags));
  
  serverCmd = strcat("cmd ", CMD_CLIENT_INFO, " ", updateInfoString, "\n");
  
  localcmd(serverCmd);
};


/*
  Set the right weapon value in the CLIENT_INFO_STRING
*/
void( float weaponBits ) cl_setweapon={
  local string infoString;
  
  infoString = CLIENT_INFO_STRING;
  
  if( (weaponBits | WEAPON1) ){
   infoString = infoadd(infoString, KEY_WEPN1, ftos(CLIENT_stat_w1_id));
  }
  if( (weaponBits | WEAPON2) ){
   infoString = infoadd(infoString, KEY_WEPN2, ftos(CLIENT_stat_w2_id));
  }
  if( (weaponBits | WEAPON3) ){
   infoString = infoadd(infoString, KEY_WEPN3, ftos(CLIENT_stat_w3_id));
  }
  if( (weaponBits | WEAPON4) ){
   infoString = infoadd(infoString, KEY_WEPN4, ftos(CLIENT_stat_w4_id));
  }
  if( (weaponBits | WEAPON5) ){
   infoString = infoadd(infoString, KEY_WEPN5, ftos(CLIENT_stat_w5_id));
  }
  if( (weaponBits | WEAPON6) ){
   infoString = infoadd(infoString, KEY_WEPN6, ftos(CLIENT_stat_w6_id));
  }
  if( (weaponBits | WEAPON7) ){
   infoString = infoadd(infoString, KEY_WEPN7, ftos(CLIENT_stat_w7_id));
  }
  if( (weaponBits | WEAPON8) ){
   infoString = infoadd(infoString, KEY_WEPN8, ftos(CLIENT_stat_w8_id));
  }
  if( (weaponBits | WEAPON9) ){
   infoString = infoadd(infoString, KEY_WEPN9, ftos(CLIENT_stat_w9_id));
  }
  
  cacheGlobalString(CLIENT_INFO_STRING, infoString)
  
};

void(float id) cl_setmech={
  local string factionColors;
  local string infoString;
  local float color1, color2, color3, color4, color5, color6;
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
  
  infoString = CLIENT_INFO_STRING;
  tokenize(factionColors);
  
  color1 = stof(argv(0));
  color2 = stof(argv(1));
  color3 = stof(argv(2));
  color4 = stof(argv(3));
  color5 = stof(argv(4));
  color6 = stof(argv(5));
  
  infoString = infoadd(infoString, KEY_MECH, ftos(id));
  
  infoString = infoadd(infoString, KEY_COLOR1, ftos(color1));
  infoString = infoadd(infoString, KEY_COLOR2, ftos(color2));
  infoString = infoadd(infoString, KEY_COLOR3, ftos(color3));
  infoString = infoadd(infoString, KEY_COLOR4, ftos(color4));
  infoString = infoadd(infoString, KEY_COLOR5, ftos(color5));
  infoString = infoadd(infoString, KEY_COLOR6, ftos(color6));
  
  cacheGlobalString(CLIENT_INFO_STRING, infoString)
};

void( float newFaction ) cl_set_faction={
  local string infoString;
  
  infoString = CLIENT_INFO_STRING;
  infoString = infoadd(infoString, KEY_FACTION, ftos(newFaction));
  cacheGlobalString(CLIENT_INFO_STRING, infoString)
};

void(float group1, float group2, float group3, float group4 ) cl_setweapongroup={
  local string infoString;
  
  infoString = CLIENT_INFO_STRING;
  infoString = infoadd(infoString, KEY_GROUP1, ftos(group1));
  infoString = infoadd(infoString, KEY_GROUP2, ftos(group2));
  infoString = infoadd(infoString, KEY_GROUP3, ftos(group3));
  infoString = infoadd(infoString, KEY_GROUP4, ftos(group4));
  cacheGlobalString(CLIENT_INFO_STRING, infoString)
};

void(float nav_id) cl_setspawnpoint={
  local string infoString;
  
  infoString = CLIENT_INFO_STRING;
  infoString = infoadd(infoString, KEY_DEPLOY, ftos(nav_id));
  cacheGlobalString(CLIENT_INFO_STRING, infoString)
};

void(float nextMissionBool) cl_set_mission={
  local string cmd;
  cmd = strcat("cmd nextmission ", ftos(nextMissionBool),"\n");
  localcmd(cmd);
};

/*
  Getter functions, receives stuffcmd()'s from server.
*/
void(string fileName) cl_get_msnfile={
  cacheGlobalString(MSN_FILENAME, fileName )
  msn_getfile();
};

void(string fileName) cl_get_animfile={
  if(ANM_FILE_STATUS == 0){
    anm_parseFile(fileName);
  }
};


void(string iniCmd) cl_ini_event={
  local entity hardpoint;
  local float bit;
  local float hptId;
  
  //populate tac map if exists
  if(MSN_FILEFOUND){
    if(MSN_LOADED == FALSE){
      msn_parsefile();
      MSN_LOADED = TRUE;
    }
  }
  
/*
"m ini ", world.iniConfig, "\n"
*/
  tokenize(iniCmd);
  
  //argv0 = m
  //argv1 = ini
  //argv2 = mech id
  
  //argv3 = wgrp1
  //argv4 = wgrp2
  //argv5 = wgrp3
  //argv6 = wgrp4
  
  //argv7 = wep1
  //argv8 = wep2
  //argv9 = wep3
  //argv10 = wep4
  //argv11 = wep5
  //argv12 = wep6
  //argv13 = wep7
  //argv14 = wep8
  //argv15 = wep9
  
  MECH_DATA_ID = stof(argv(2));
  ui_data_load_mech_info(MECH_DATA_ID, UI_HANGAR_DATA_mech);
  //MECH_DATA_RADAR -^ set.
  CLIENT_MENU_nex_grp1 = stof(argv(3));
  CLIENT_MENU_nex_grp2 = stof(argv(4));
  CLIENT_MENU_nex_grp3 = stof(argv(5));
  CLIENT_MENU_nex_grp4 = stof(argv(6));
  
  bit = 1;
  hptId = 7;
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while( hardpoint ){
    hardpoint.data_idx = stof(argv(hptId));
    data_get_client_item_( hardpoint, hardpoint.data_idx );
    hptId = hptId + 1;
    bit = floor(bit * 2);
    CLIENT_weapon_state = CLIENT_weapon_state | bit;
    hardpoint = hardpoint.w_slot;
  }
  
  CLIENT_stat_w1_id = stof(argv(7));
  CLIENT_stat_w2_id = stof(argv(8));
  CLIENT_stat_w3_id = stof(argv(9));
  CLIENT_stat_w4_id = stof(argv(10));
  CLIENT_stat_w5_id = stof(argv(11));
  CLIENT_stat_w6_id = stof(argv(12));
  CLIENT_stat_w7_id = stof(argv(13));
  CLIENT_stat_w8_id = stof(argv(14));
  CLIENT_stat_w9_id = stof(argv(15));
  
  cl_setweapongroup( CLIENT_MENU_nex_grp1, CLIENT_MENU_nex_grp2, CLIENT_MENU_nex_grp3, CLIENT_MENU_nex_grp4 );
  cl_send_infostring( INFO_FLAG_GROUPS );
  
  MENU_respawn_cool = servertime - 1;
  LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE | VALID_GRPS | VALID_MECH;
  
  //sizeable hack
  ui_navbutton_launch_click();
};


void() cl_exit_animatic={
  if( ANM_FILE_STATUS == TRUE ){
    //animation is playing;
    localcmd("cmd exitanim\n");
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
    TE_FOG_SET
*/
void() cl_get_new_fog={
  FOG_STATE = TRUE;
  
  FOG_WORLD_VAL = ReadByte();
  
  FOG_TARG_RED = ReadCoord();
  FOG_TARG_GREEN = ReadCoord();
  FOG_TARG_BLUE = ReadCoord();
  
  FOG_TARG_DIST_MIN = ReadCoord();
  FOG_TARG_DIST_MAX = ReadCoord();
  FOG_TARG_DIST_TOP = ReadCoord();
  
  FOG_TARG_ALPHA = ReadCoord();
  FOG_TARG_DENSITY = ReadCoord();
  FOG_TARG_FADE_DEPTH = ReadCoord();
  
  
  /*cons_logAFloat("FOG_TARG_RED", FOG_TARG_RED); //debug
  cons_logAFloat("FOG_TARG_GREEN", FOG_TARG_GREEN); //debug
  cons_logAFloat("FOG_TARG_BLUE", FOG_TARG_BLUE); //debug
  cons_logAFloat("FOG_TARG_DIST_MIN", FOG_TARG_DIST_MIN); //debug
  cons_logAFloat("FOG_TARG_DIST_MAX", FOG_TARG_DIST_MAX); //debug
  cons_logAFloat("FOG_TARG_DIST_TOP", FOG_TARG_DIST_TOP); //debug
  cons_logAFloat("FOG_TARG_ALPHA", FOG_TARG_ALPHA); //debug
  cons_logAFloat("FOG_TARG_DENSITY", FOG_TARG_DENSITY); //debug
  cons_logAFloat("FOG_TARG_FADE_DEPTH", FOG_TARG_FADE_DEPTH); //debug
  */
  
  //we cache world's fog values as fall-back
  if( FOG_WORLD_VAL ){
    FOG_WORLD_DENSITY = FOG_TARG_DENSITY; 
    FOG_WORLD_RED = FOG_TARG_RED;
    FOG_WORLD_GREEN = FOG_TARG_GREEN;
    FOG_WORLD_BLUE = FOG_TARG_BLUE;
    FOG_WORLD_ALPHA = FOG_TARG_ALPHA;
    FOG_WORLD_DIST_MIN = FOG_TARG_DIST_MIN;
    FOG_WORLD_DIST_MAX = FOG_TARG_DIST_MAX;
    FOG_WORLD_DIST_TOP = FOG_TARG_DIST_TOP;
    FOG_WORLD_FADE_DEPTH = FOG_TARG_FADE_DEPTH;
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
  HUD_EXTERNAL_CAM_ACTIVE = cvar("chase_active");
};

/*
  Replaces the stuffcmd() thing
*/
void() cl_set_menu={
  local float menuFlag;
   
  menuFlag = ReadByte();
  if( menuFlag ){
    setcursormode(0);
    localcmd("togglemenu\n");
  }
};