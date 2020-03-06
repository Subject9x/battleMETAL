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
void(float val) cl_set_movespeedkey={
  cvar_set("cl_movespeedkey", ftos(val));
};

void(float totalWeps, string wepList) cl_setweapon={

  local string cmd;
  cmd = strcat("cmd mech setwep ", ftos(totalWeps), wepList, "\n");
  localcmd(cmd);
};

void(float sz, float id) cl_setmech={
  local string cmd;
  cmd = strcat("cmd mech setmech ", ftos(sz)," ", ftos(id), "\n");
  localcmd(cmd);
};

void() cl_spawnmech={
  local string cmd;
  cmd = "cmd mech spawn\n";
  localcmd(cmd);
};

void(float grp_id, float grp_val) cl_setweapongroup={
  local string cmd;
  cmd = strcat("cmd mech setgroup ", ftos(grp_id)," ",ftos(grp_val), "\n");
  localcmd(cmd);
};

void(float nav_id) cl_setspawnpoint={
  local string cmd;
  cmd = strcat("cmd mech setnav ", ftos(nav_id), "\n");
  localcmd(cmd);
};

void(float nextMissionBool) cl_set_mission={
  local string cmd;
  cmd = strcat("cmd mech nextmission ", ftos(nextMissionBool),"\n");
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
  if( ANM_FILE_STATUS == 1 ){
    //animation is playing;
    anm_cleanup();
    cmd = "cmd mech exitanim\n";
    localcmd(cmd);
  }
};

//Setup dependent UI arrays based on the master UNLOCKED_MECHS array.
void() cl_get_mechs_sort={
  local float itr, mechId;
  local entity mechListItem;
  
  mechListItem = spawn();
  itr = 0;
  
  while( itr < 24){
    mechId = UNLOCKED_MECHS[itr];
    if( mechId > 0 ){
      data_get_client_mech_( mechListItem, mechId );
      if( mechListItem.data_idx ){
        MECH_DATA_SIZES[mechId] = mechListItem.vec_size;
        MECH_DATA_NAMES[mechId] = mechListItem.vec_name;
        ui_data_cleanup_mechlist_entity( mechListItem );
      }
    }
    itr = itr + 1;
  }
  
  remove(mechListItem);
};

// all mech unlocks to same array
void(string mech_data) cl_get_mechs_all={
  local float itrTokens, tokens;
  local float mechId;
  local float total;
  
  tokens = tokenizebyseparator(mech_data, " ",",");
  itrTokens = 0;
  total = 1;
  //TODO - possible duplication error
  while(itrTokens <= tokens){
    if( argv(itrTokens) != "" ){
      mechId = stof( argv(itrTokens) );
      if(mechId > 0){
        UNLOCKED_MECHS[total] = mechId;
        total = total + 1;
      }
    }
    itrTokens = itrTokens + 1;
  }
  //we store the total for headache reduction later in UI code.
  UNLOCKED_MECHS_TOTAL = total;
};

void(string item_data) cl_get_items_all={
  local float itrTokens, tokens;
  local float itemId;
  local float total;

  tokens = tokenizebyseparator(item_data, " ",",");
  itrTokens = 0;
  total = 1;
  while(itrTokens < tokens + 1){
    if( argv(itrTokens) != "" ){
      itemId = stof( argv(itrTokens) );
      if(itemId > 0){
        //order of items doesn't really matter
        UNLOCKED_ITEMS[total] = itemId;
        total = total + 1;
      }
    }
    itrTokens = itrTokens + 1;
  }
  //we store the total for headache reduction later in UI code.
  UNLOCKED_ITEMS_TOTAL = total;
};

void(string unlockData) cl_unlock_stuff={
  local string item;
  local float tokens;
  local float tokenItr;
  local float itemCounter;
  
  tokenizebyseparator( unlockData, "[", "]");
  MENU_DEBRIEF_unlocks_mechs = strzone( argv(1) );
  MENU_DEBRIEF_unlocks_equip = strzone( argv(3) );
  
  tokenItr = 0;
  itemCounter = 0;
  //mech list is blank
  if( argv(1) != "" ){
    tokens = tokenizebyseparator( MENU_DEBRIEF_unlocks_mechs, " " );
    while( tokenItr < tokens ){
      item = strzone(argv(tokenItr));  
      itemCounter = stof(item);
      UNLOCKED_MECHS[itemCounter] = itemCounter;
      strunzone(item);
      tokenItr = tokenItr + 1;
    }
  }

  tokenItr = 0;
  itemCounter = 1;
  if( argv(3) != "" ){
    tokens = tokenizebyseparator( MENU_DEBRIEF_unlocks_equip, " " );
    while( tokenItr < tokens ){
      item = strzone(argv(tokenItr));
      itemCounter = stof(item);
      UNLOCKED_ITEMS[itemCounter] = itemCounter;
      strunzone(item);
      tokenItr = tokenItr + 1;
    }
  }
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