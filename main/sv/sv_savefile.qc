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
  if(MAP_UNLOCK_MECHS != ""){
    if(SAVE_MECHS_LIST != ""){
      SAVE_MECHS_LIST = savefile_insert(MAP_UNLOCK_MECHS, SAVE_MECHS_LIST);
    }
    else{
      SAVE_MECHS_LIST = strzone(MAP_UNLOCK_MECHS);
    }
  }
  
  if(MAP_UNLOCK_EQUIP != ""){
    if(SAVE_ITEMS_ALL != ""){
      SAVE_ITEMS_ALL = savefile_insert(MAP_UNLOCK_EQUIP, SAVE_ITEMS_ALL);
    }
    else{
      SAVE_ITEMS_ALL = strzone(MAP_UNLOCK_EQUIP);
    }
  }
};

void(string mapNext) savefile_changemap={
  SAVE_MAP = mapNext;
};

//checks to see if item is already on list
string(string item, string source) savefile_insert={
  local string update, line;
  local float tokens, itr;
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
void(float override) savefile_load={
  local float flannel, argc, line_tag;
  local string file, contents, line, map_name;
  local float hasExt;
  
  if( override ){
    hasExt = strstrofs(mapname, ".bsp",0);
    if( hasExt != -1 ){
      map_name = substring(mapname,0, hasExt);
    }
    else{
      map_name = mapname;
    }
    file = strcat(PATH_DATA_MAP, "/", map_name, "/", world.itemOverrideFile, SAVE_FILE_EXT);
  }
  else{
    file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  }
  
  flannel = fopen(file, FILE_READ);
  if( flannel == -1 ){
    FLAG_NEWGAME = 1;
    return;
  }
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
      if( argv(1) == SAVE_FILE_NEWGAME ){
        FLAG_NEWGAME = stof(argv(3));
      }
    }
    line = fgets(flannel);
  }
  fclose(flannel);
};

void() savefile_save={
  local float flannel;
  local string file;
  if( strstrofs(nextmap, "anim", 0) != -1 ){
    return;
  }
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
  fputs(flannel, strcat("  'mission' : ", SAVE_MAP, ",\n"));
  fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
  fputs(flannel, strcat("  'skill' : ", ftos(skill), ",\n"));
  if( strstrofs(mapname, "o1m3", 0) != -1 ){
    if( strstrofs(nextmap, "anim", 0) != -1){
      fputs(flannel, strcat("  'newgame' : ", ftos(0), ",\n"));
      fputs(flannel, "  'mechs' : 1 2 3,\n");
      fputs(flannel, "  'items' : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21,\n");
    }
  }
  else{
    fputs(flannel, strcat("  'mechs' : ", SAVE_MECHS_LIST, ",\n"));
    fputs(flannel, strcat("  'items' : ", SAVE_ITEMS_ALL, ",\n"));
  }
  fputs(flannel, "}");
  fclose(flannel);
}; 

void() savefile_default={
  local float flannel;
  local string file;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
  fputs(flannel, "  'mission' : o1m1,\n");
  if( cvar("developer") ){
    fputs(flannel, "  'mechs' : 1 2 3,\n");
    fputs(flannel, "  'items' : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21,\n");
  }
  else{
    fputs(flannel, "  'mechs' : 1,\n");
    fputs(flannel, "  'items' : 1 3 4 8 12 16 18 21,\n");
  }
  
  fputs(flannel, "  'points' : ,\n");
  fputs(flannel, strcat("  'skill' : ", ftos(skill), ",\n"));
  fputs(flannel, "  'newgame': 1,\n");
  fputs(flannel, "}");
  fclose(flannel);
  
};

/*
  Loads the co-op save file for GAMETYPE == GAMEMODE_COOP games.
    + this file should be /data/map_scripts/<map>/coop.sav
    + unlocks are handled via nextmap's coop.sav file.
*/
void() mapfile_coop_load={
  local string file, line, contents;
  local float flannel, line_tag, argc;
  
  local string mechData, itemData;
  
  file = strcat(PATH_DATA_MAP, mapname, "/coop", SAVE_FILE_EXT);
  flannel = fopen(file, FILE_READ);
  if(flannel > -1){
    contents = fgets(flannel);
    argc = tokenizebyseparator(contents, "{", ",", "}");
    line = fgets(flannel);
    while( (line != "") ){
      if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
        line_tag = tokenizebyseparator(line, "'","'",": ",",");
        if( argv(1) == SAVE_FILE_MECH_LIST ){
          mechData = argv(3);
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          itemData = argv(3);
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
  
  mapfile_setData_team1( mechData ,itemData );
};  


/*
  Loads the 2 team deathmatch save files for GAMETYPE == GAMEMODE_TEAMDM games.
    + this file should be /data/map_scripts/<map>/team1.sav
    + this file should be /data/map_scripts/<map>/team2.sav
*/
void() mapfile_team_load={
  local string file, line, contents;
  local float flannel, line_tag, argc;
  
  local string mechData, itemData;

  file = strcat(PATH_DATA_MAP, mapname, "/team1", SAVE_FILE_EXT);
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
          mechData = argv(3);
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          itemData = argv(3);
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
  
  mapfile_setData_team1( mechData, itemData );
  
  file = strcat(PATH_DATA_MAP, mapname, "/team2", SAVE_FILE_EXT);
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
          mechData = argv(3);
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          itemData = argv(3);
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
  
  mapfile_setData_team2( mechData, itemData );
}; 

/*
  Loads the deathmatch save file for GAMETYPE == GAMEMODE_DM games.
    + this file should be /data/map_scripts/<map>/dm.sav
*/
void() mapfile_dm_load={
  local string file, line, contents;
  local float flannel, line_tag, argc;
  
  local string mechData, itemData;
  
  file = strcat(PATH_DATA_MAP, mapname, "/dm", SAVE_FILE_EXT);
  flannel = fopen(file, FILE_READ);
  if(flannel > -1){
    contents = fgets(flannel);
    argc = tokenizebyseparator(contents, "{", ",", "}");
    line = fgets(flannel);
    while( (line != "") ){
      if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
        line_tag = tokenizebyseparator(line, "'","'",": ",",");
        if( argv(1) == SAVE_FILE_MECH_LIST ){
          mechData = argv(3);
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          itemData = argv(3);
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
  
  mapfile_setData_team1( mechData ,itemData );
};  

void( string theseMechs, string theseItems ) mapfile_setData_team1={
  local float itr;
  local float max;
  local float point;
  itr = 0;
  max = tokenizebyseparator( theseMechs, " ");
  for( itr = 0; itr < max; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_MECHS_SURVEST[itr] = point;
  }
  itr = 0;
  max = tokenizebyseparator( theseItems, " ");
  for( itr = 0; itr < max; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_ITEMS_SURVEST[itr] = point;
  }
}; 

void( string theseMechs, string theseItems ) mapfile_setData_team2={
  local float itr;
  local float max;
  local float point;
  itr = 0;
  max = tokenizebyseparator( theseMechs, " ");
  for( itr = 0; itr < max; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_MECHS_MILITAR[itr] = point;
  }
  itr = 0;
  max = tokenizebyseparator( theseItems, " ");
  for( itr = 0; itr < max; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_ITEMS_MILITAR[itr] = point;
  }
}; 