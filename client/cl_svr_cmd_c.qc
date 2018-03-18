/*
mech Mod
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
  if(self.ANM_FILE_STATUS == 0){
    anm_parseFile(fileName);
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
        MECHLIST_LIGHT_ARR[item] = 1;
      }
      else{
        MECHLIST_LIGHT_ARR[item] = 0;
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
        MECHLIST_MEDIUM_ARR[item] = 1;
      }
      else{
        MECHLIST_MEDIUM_ARR[item] = 0;
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
        MECHLIST_HEAVY_ARR[item] = 1;
      }
      else{
        MECHLIST_HEAVY_ARR[item] = 0;
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