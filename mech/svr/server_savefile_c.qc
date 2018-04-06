/*
mech Mod
Author: Peter Roohr
Date: 3/17/2018
Overview: This code writes out the single player save file.
The save file is mostly an inter-level intermediary file
to track player unlocks
*/


/*
  appends new save data from mission to single-player save file
*/
void() savefile_append={
  if(world.inv_m_light != ""){
    if(SAVE_MECHS_LIGHT != ""){
      SAVE_MECHS_LIGHT = savefile_insert(world.inv_m_light, SAVE_MECHS_LIGHT);
    }
    else{
      SAVE_MECHS_LIGHT = strzone(world.inv_m_light);
    }
  }
  
  if(world.inv_m_medim != ""){
    if(SAVE_MECHS_MEDIM != ""){
      SAVE_MECHS_MEDIM = savefile_insert(world.inv_m_medim, SAVE_MECHS_MEDIM);
    }
    else{
      SAVE_MECHS_MEDIM = strzone(world.inv_m_medim);
    }
  }
  
  if(world.inv_m_heavy != ""){
    if(SAVE_MECHS_HEAVY != ""){
      SAVE_MECHS_HEAVY = savefile_insert(world.inv_m_heavy, SAVE_MECHS_HEAVY);
    }
    else{
      SAVE_MECHS_HEAVY = strzone(world.inv_m_heavy);
    }
  }
  
  if(world.inv_items != ""){
    if(SAVE_ITEMS_ALL != ""){
      SAVE_ITEMS_ALL = savefile_insert(world.inv_items, SAVE_ITEMS_ALL);
    }
    else{
      SAVE_ITEMS_ALL = strzone(world.inv_items);
    }
  }
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
  fputs(flannel, strcat("  'mission' : ", self.msn_file, ",\n"));
  fputs(flannel, strcat("  'light' : ", SAVE_MECHS_LIGHT, ",\n"));
  fputs(flannel, strcat("  'medium' : ", SAVE_MECHS_MEDIM, ",\n"));
  fputs(flannel, strcat("  'heavy' : ", SAVE_MECHS_HEAVY, ",\n"));
  fputs(flannel, strcat("  'items' : ", SAVE_ITEMS_ALL, ",\n"));
  fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
  fputs(flannel, "}");
  fclose(flannel);
}; 

void() savefile_default={
  local float flannel;
  local string file, line;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, "  'mission' : start,\n");
  fputs(flannel, "  'light' : 1,\n");
  fputs(flannel, "  'medium' : ,\n");
  fputs(flannel, "  'heavy' : ,\n");
  fputs(flannel, "  'items' : 1 3 17 4,\n");
  fputs(flannel, "  'points' : ,\n");
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