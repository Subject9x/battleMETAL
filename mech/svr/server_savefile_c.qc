/*
mech Mod
Author: Peter Roohr
Date: 3/17/2018
Overview: This code writes out the single player save file.
The save file is mostly an inter-level intermediary file
to track player unlocks
*/

//functions
void() savefile_load={
  local float flannel, argc, line_tag, line_val, line_array, line_cntr;
  local string file, contents, line;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME);
  flannel = fopen(file, FILE_READ);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{", ",", "}");
  line = fgets(flannel);
  while( (line != "") ){
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "'","'",": ",",");
      if( argv(1) == SAVE_FILE_MSN_NAME) {
        
      }
      if( argv(1) == SAVE_FILE_MECHS_LIGHT ){
        SAVE_MECHS_LIGHT = strzone(argv(3));
      }
      if( argv(1) == SAVE_FILE_MECHS_MEDIUM ){
        SAVE_MECHS_MEDIM = strzone(argv(3));
      }
      if( argv(1) == SAVE_FILE_MECHS_HEAVY ){
        SAVE_MECHS_HEAVY = strzone(argv(3));
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
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'mission' : ",self.msn_file,",\n"));
  fputs(flannel, strcat("  'light' : ", SAVE_MECHS_LIGHT,",\n"));
  fputs(flannel, strcat("  'medium' : ", SAVE_MECHS_MEDIM,",\n"));
  fputs(flannel, strcat("  'heavy' : ", SAVE_MECHS_HEAVY,",\n"));
  fputs(flannel, strcat("  'items' : ", SAVE_ITEMS_ALL,",\n"));
  fputs(flannel, strcat("  'points' : ", ftos(1),",\n"));
  fputs(flannel, "}");
  fclose(flannel);
}; 

void() savefile_default={
  local float flannel;
  local string file, line;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'mission' : start,\n"));
  fputs(flannel, strcat("  'light' : 1,\n"));
  fputs(flannel, strcat("  'medium' : ,\n"));
  fputs(flannel, strcat("  'heavy' : ,\n"));
  fputs(flannel, strcat("  'items' : 1 3 17 4,\n"));
  fputs(flannel, strcat("  'points' : ,\n"));
  fputs(flannel, "}");
  fclose(flannel);
};

//coop options
void() mapfile_coop_load={
  local string file, line, contents;
  local float flannel, line_tag, argc;
  
  file = strcat(PATH_DATA_MAP, "/", mapname, "/", world.map_file, SAVE_FILE_EXT);
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
        if( argv(1) == SAVE_FILE_MECHS_LIGHT ){
          client_sendAvailableLightMechs( argv(3) );
        }
        if( argv(1) == SAVE_FILE_MECHS_MEDIUM ){
          client_sendAvailableMediumMechs( argv(3) );
        }
        if( argv(1) == SAVE_FILE_MECHS_HEAVY ){
          client_sendAvailableHeavyMechs( argv(3) );
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
void(float faction) mapfile_pvp_load={
  local string file, line, contents;
  local float flannel, line_tag, argc;
  
  file = strcat(PATH_DATA_MAP, "/", mapname, "/", world.map_file, "_", ftos(faction), SAVE_FILE_EXT);
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
        if( argv(1) == SAVE_FILE_MECHS_LIGHT ){
          client_sendAvailableLightMechs( argv(3) );
        }
        if( argv(1) == SAVE_FILE_MECHS_MEDIUM ){
          client_sendAvailableMediumMechs( argv(3) );
        }
        if( argv(1) == SAVE_FILE_MECHS_HEAVY ){
          client_sendAvailableHeavyMechs( argv(3) );
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