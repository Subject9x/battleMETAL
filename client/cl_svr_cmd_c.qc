/*
battleMETAL
Author: Peter Roohr
Date: 3/8/2017
Overview: class file for the client -> server command layer

*/

void(float val) cl_set_movespeedkey={
  cvar_set("cl_movespeedkey", ftos(val));
};

void(float slot, float w_bit) cl_setweapon={

  local string cmd;
  cmd = strcat("cmd mech setwep ", ftos(slot), " ", ftos(w_bit), "\n");
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


void(string fileName) cl_get_msnfile={
  MSN_FILENAME = strzone(fileName);
  msn_getfile();
};

void(string fileName) cl_get_animfile={
  if(ANM_FILE_STATUS == 0){
    anm_parseFile(fileName);
  }
};

//sorts master mech array into UI arrays
void() cl_get_mechs_sort={
  local float itr;
  itr = 1;
  while( itr <= GAME_TOTAL_MECHS){
    if( MECHLIST_TOTAL[itr] == TRUE ){
      local float siz;
      siz = MECH_DATA_SIZES[itr];
      switch(siz){
        case 1:
          MECHLIST_LIGHT_ARR[itr] = 1;
          break;
        case 2:
          MECHLIST_MEDIUM_ARR[itr] = 1; 
          break;
        case 3:
          MECHLIST_HEAVY_ARR[itr] = 1;
          break;
      } 
    }
    itr = itr + 1;
  }
};

void(string mech_data) cl_get_mechs_light={
  local string val;
  local float itr, tokens;
  tokens = tokenizebyseparator(mech_data, " ");
  itr = 0;
  while(itr <= tokens){
    local float item;
    if( argv(itr) != "" ){
      item = stof( argv(itr) );
      if(item > 0){
        MECHLIST_TOTAL[item] = 1;
      }
      else{
        MECHLIST_TOTAL[item] = 0;
      }
    }
    itr = itr + 1;
  }
};

void(string mech_data) cl_get_mechs_medium={
  local string val;
  local float itr, tokens;
  tokens = tokenizebyseparator(mech_data, " ",",");
  itr = 0;
  while(itr <= tokens){
    local float item;
    if( argv(itr) != "" ){
      item = stof( argv(itr) );
      if(item > 0){
        MECHLIST_TOTAL[item] = 1;
      }
      else{
        MECHLIST_TOTAL[item] = 0;
      }
    }
    itr = itr + 1;
  }
};

void(string mech_data) cl_get_mechs_heavy={
  local string val;
  local float itr, tokens;
  tokens = tokenizebyseparator(mech_data, " ");
  itr = 0;
  while(itr <= tokens){
    local float item;
    if( argv(itr) != "" ){
      item = stof( argv(itr) );
      if(item > 0){
        MECHLIST_TOTAL[item] = 1;
      }
      else{
        MECHLIST_TOTAL[item] = 0;
      }
    }
    itr = itr + 1;
  }
};

void(string item_data) cl_get_items_all={
    local string val;
  local float itr, tokens;
  tokens = tokenizebyseparator(item_data, " ",",");
  itr = 0;
  while(itr <= tokens){
    local float item;
    if( argv(itr) != "" ){
      item = stof( argv(itr) );
      if(item > 0){
        WEPLIST_ALL[item] = 1;
      }
      else{
        WEPLIST_ALL[item] = 0;
      }
    }
    itr = itr + 1;
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