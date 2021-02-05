/*
battleMETAL
Author: Peter Roohr
Date: 3/17/2018
Overview: 
  This code writes out the single player save file.
  The save file is mostly an inter-level intermediary file
    to track player unlocks.
*/

void(string mapNext) savefile_changemap={
  SAVE_MAP = mapNext;
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
    file = strcat(PATH_DATA_MAP, map_name, "/", map_name, SAVE_FILE_EXT);
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

/*
  Loads the co-op save file for ENT_SERVER_INFO.gameType == GAMEMODE_COOP games.
    + this file should be /data/map_scripts/<map>/coop.sav
    + unlocks are handled via sv_nextmap's coop.sav file.
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
  Loads the 2 team deathmatch save files for ENT_SERVER_INFO.gameType == GAMEMODE_TEAMDM games.
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
  Loads the deathmatch save file for ENT_SERVER_INFO.gameType == GAMEMODE_DM games.
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
  local float maxItems;
  local float point;
  itr = 0;
  maxItems = tokenizebyseparator( theseMechs, " ");
  for( itr = 0; itr < maxItems; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_MECHS_SURVEST[itr] = point;
  }
  itr = 0;
  maxItems = tokenizebyseparator( theseItems, " ");
  for( itr = 0; itr < maxItems; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_ITEMS_SURVEST[itr] = point;
  }
}; 

void( string theseMechs, string theseItems ) mapfile_setData_team2={
  local float itr;
  local float maxItems;
  local float point;
  itr = 0;
  maxItems = tokenizebyseparator( theseMechs, " ");
  for( itr = 0; itr < maxItems; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_MECHS_MILITAR[itr] = point;
  }
  itr = 0;
  maxItems = tokenizebyseparator( theseItems, " ");
  for( itr = 0; itr < maxItems; itr = itr + 1){
    point = stof(argv(itr));
    WORLD_DATA_ITEMS_MILITAR[itr] = point;
  }
}; 