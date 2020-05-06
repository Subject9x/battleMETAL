/*
battleMETAL
Author: Peter Roohr
Date: 04/02/2020
Overview:
  Local save file handling.
  Network games will validate player selection data on-submit.
  Campaign games will load data locally.
*/

void( string fileName ) cl_load_savefile={
  local string line, contents;
  local float flannel, line_tag, argc;
  
  local string mechData, itemData;

  flannel = fopen(fileName, FILE_READ);
  if(flannel > -1){
    contents = fgets(flannel);
    line = fgets(flannel);
    while( (line != "") ){
      if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
        line_tag = tokenizebyseparator(line, "'","'",": ",",");
        if( argv(1) == SAVE_FILE_MECH_LIST ){
          UNLOCKED_MECHS_DATA = strzone(argv(3));
        }
        if( argv(1) == SAVE_FILE_ITEMS ){
          UNLOCKED_ITEMS_DATA = strzone(argv(3));
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
  }
  else{
    if( cvar("developer") ){
      error(strcat("cl_load_savefile()->: ", fileName, " was not found"));
    }
  }
  
  cl_load_mechs_all();
  cl_load_items_all();
};

void( float gameType ) cl_set_savepath={
  local string filePath;
  
  switch( gameType ){
    case GAMEMODE_CAMPAIGN:
      filePath = strcat(PATH_DATA_SAVE,"/",SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
      break;
    
    case GAMEMODE_COOP:
      filePath = strcat(PATH_DATA_MAP, MAP_NAME, "/coop", SAVE_FILE_EXT);
      break;
      
    case GAMEMODE_DM:
       filePath = strcat(PATH_DATA_MAP, MAP_NAME, "/dm", SAVE_FILE_EXT);
      break;
     
    case GAMEMODE_TEAMDM:
      //TODO - teams
       filePath = strcat(PATH_DATA_MAP, MAP_NAME, "/dm", SAVE_FILE_EXT);
      break;
  }
  cl_load_savefile( filePath );
};

// all mech unlocks to same array
void() cl_load_mechs_all={
  local float itrTokens, tokens;
  local float mechId;
  local float total;
  
  tokens = tokenizebyseparator(UNLOCKED_MECHS_DATA, " ",",");
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

void() cl_load_items_all={
  local float itrTokens, tokens;
  local float itemId;
  local float total;

  tokens = tokenizebyseparator(UNLOCKED_ITEMS_DATA, " ",",");
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

/*
  appends new save data from mission to single-player save file
*/
void() cl_savefile_append={
  if(MENU_DEBRIEF_unlocks_mechs != ""){
    if(UNLOCKED_MECHS_DATA != ""){
      UNLOCKED_MECHS_DATA = strzone(cl_savefile_insert(MENU_DEBRIEF_unlocks_mechs, UNLOCKED_MECHS_DATA));
    }
    else{
      UNLOCKED_MECHS_DATA = strzone(MENU_DEBRIEF_unlocks_mechs);
    }
  }
  
  if(MENU_DEBRIEF_unlocks_equip != ""){
    if(UNLOCKED_ITEMS_DATA != ""){
      UNLOCKED_ITEMS_DATA = strzone(cl_savefile_insert(MENU_DEBRIEF_unlocks_equip, UNLOCKED_ITEMS_DATA));
    }
    else{
      UNLOCKED_ITEMS_DATA = strzone(MENU_DEBRIEF_unlocks_equip);
    }
  }
};

//checks to see if item is already on list
string(string item, string source) cl_savefile_insert={
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
    return update;
  }
  else{
    return source;
  }
};

void() cl_savefile_save={
  local float flannel;
  local string file;
  //if( strstrofs(sv_nextmap, "anim", 0) != -1 ){
  //  return;
  //}
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
  fputs(flannel, strcat("  'mission' : ", SV_NEXTMAP, ",\n"));
  fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
  fputs(flannel, strcat("  'skill' : ", ftos(cvar("skill")), ",\n"));
  if( strstrofs(MAP_NAME, "o1m3", 0) != -1 ){
    //TODO - pipe next map to client
    if( strstrofs("", "anim", 0) != -1){
      fputs(flannel, strcat("  'newgame' : ", ftos(0), ",\n"));
      fputs(flannel, "  'mechs' : 1 2 3,\n");
      fputs(flannel, "  'items' : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21,\n");
    }
  }
  else{
    fputs(flannel, strcat("  'mechs' : ", UNLOCKED_MECHS_DATA, ",\n"));
    fputs(flannel, strcat("  'items' : ", UNLOCKED_ITEMS_DATA, ",\n"));
  }
  fputs(flannel, "}");
  fclose(flannel);
}; 

/*
  Default Save File, set when player finishes campaign training.
*/
void() cl_savefile_default={
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
  fputs(flannel, strcat("  'skill' : ", ftos(cvar("skill")), ",\n"));
  fputs(flannel, "  'newgame': 1,\n");
  fputs(flannel, "}");
  fclose(flannel);
  
};