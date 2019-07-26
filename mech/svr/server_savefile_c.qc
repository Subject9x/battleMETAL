/*
battleMETAL
Author: Peter Roohr
Date: 3/17/2018
Overview: 
  This code writes out the single player save file.
  The save file is mostly an inter-level intermediary file
    to track player unlocks.
*/


/*
  appends new save data from mission to single-player save file
*/
void() savefile_append={
  if(world.unlockMechs != ""){
    if(SAVE_MECHS_LIST != ""){
      SAVE_MECHS_LIST = savefile_insert(world.unlockMechs, SAVE_MECHS_LIST);
    }
    else{
      SAVE_MECHS_LIST = strzone(world.unlockMechs);
    }
  }
  
  if(world.unlockEquip != ""){
    if(SAVE_ITEMS_ALL != ""){
      SAVE_ITEMS_ALL = savefile_insert(world.unlockEquip, SAVE_ITEMS_ALL);
    }
    else{
      SAVE_ITEMS_ALL = strzone(world.unlockEquip);
    }
  }
};

void(string mapNext) savefile_changemap={
  SAVE_MAP = mapNext;
};

//checks to see if item is already on list
string(string item, string source) savefile_insert={
  local string update, line;
  local float com, tokens, itr;
  tokens = tokenizebyseparator(item, " ");
  update = "";
  line = strcat(" ", source);
  itr = 0;
  while( itr <= tokens){
    local string toke, chk;
    toke = argv(itr);
    if( (toke != "") && (toke != " ") ){
      chk = strcat(" ", toke);
      if( strstrofs(line, chk, 0) == -1){
        if( itr == 0){
          update = strcat(update, toke);
        }
        else{
          update = strcat(update, chk);
        }
      }
    }
    itr = itr + 1;
  }
  
  if(update != ""){
    update = strcat(source, " ", update);
    return strzone(update);
  }
  else{
    return strzone(source);
  }
};

//functions
void() savefile_load={
  local float flannel, argc, line_tag, line_val, line_array, line_cntr;
  local string file, contents, line;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_READ);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{", ",", "}");
  line = fgets(flannel);
  while( (line != "") ){
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "'","'",": ",",");
      if( argv(1) == SAVE_FILE_MSN_NAME) {
        SAVE_MAP = strzone(argv(3));
      }
	  if( argv(1) == SAVE_FILE_MECH_LIST ){
        SAVE_MECHS_LIST = strzone(argv(3));
	  }
      if( argv(1) == SAVE_FILE_ITEMS ){
        SAVE_ITEMS_ALL = strzone(argv(3));
      }
    }
    line = fgets(flannel);
  }
  fclose(flannel);
};

void() savefile_save={
  local float flannel;
  local string file, line;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
  fputs(flannel, strcat("  'mission' : ", SAVE_MAP, ",\n"));
  fputs(flannel, strcat("  'mechs' : ", SAVE_MECHS_LIST, ",\n"));
  fputs(flannel, strcat("  'items' : ", SAVE_ITEMS_ALL, ",\n"));
  fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
  fputs(flannel, "}");
  fclose(flannel);
}; 

void() savefile_default={
  local float flannel;
  local string file, line;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
  fputs(flannel, "  'mission' : start,\n");
  fputs(flannel, "  'mechs' : 1 2 3,\n");
  fputs(flannel, "  'items' : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21,\n");
  fputs(flannel, "  'points' : ,\n");
  fputs(flannel, "}");
  fclose(flannel);
};

//coop options
void() mapfile_coop_load={
  local string mapFileName, file, line, contents;
  local float flannel, line_tag, argc;
  
  file = mapname;
  mapFileName = mapname;
  
  if( world.mapFile ){
    mapFileName = world.mapFile;
  }
  
  file = strcat(PATH_DATA_MAP, "/", file, "/", mapFileName, SAVE_FILE_EXT);
  flannel = fopen(file, FILE_READ);
  if(flannel > -1){
    contents = fgets(flannel);
    argc = tokenizebyseparator(contents, "{", ",", "}");
    line = fgets(flannel);
    while( (line != "") ){
      if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
        line_tag = tokenizebyseparator(line, "'","'",": ",",");
        if( argv(1) == SAVE_FILE_MSN_NAME) {
          
        }
        if( argv(1) == SAVE_FILE_MECH_LIST ){
          client_sendAvailable_Mechs( argv(3) );
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          client_sendAvailableItems( argv(3) );
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
};  

//pvp options
//scope this for the client
void( float playerFaction ) mapfile_pvp_load={
  local string mapFileName, file, line, contents;
  local float flannel, line_tag, argc;
  
  file = mapname;
  mapFileName = mapname;
  
  if( world.mapFile ){
    mapFileName = world.mapFile;
  }
  
  file = strcat(PATH_DATA_MAP, "/", mapname, "/", mapFileName, "_", ftos(playerFaction), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_READ);
  if(flannel > -1){
    contents = fgets(flannel);
    argc = tokenizebyseparator(contents, "{", ",", "}");
    line = fgets(flannel);
    while( (line != "") ){
      if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
        line_tag = tokenizebyseparator(line, "'","'",": ",",");
        if( argv(1) == SAVE_FILE_MSN_NAME) {
          
        }
        if( argv(1) == SAVE_FILE_MECH_LIST ){
          client_sendAvailable_Mechs( argv(3) );
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          client_sendAvailableItems( argv(3) );
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
};  