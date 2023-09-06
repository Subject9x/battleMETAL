/*
battleMETAL
Author: Peter Roohr
Date: 4/11/2018
Overview: utility functions for menu
*/

void() menu_write_new_save={
  local float flannel;
  local string file;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, ftos(cvar("saveslot")), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
    fputs(flannel, "// save file v2.0 for 5.0+ release, don't modify order of labels!\n");
    fputs(flannel, strcat("save=", cvar_string("saveslot"), "\n"));
    fputs(flannel, strcat("mission=", CAMP_SELECT_START, "\n"));
    fputs(flannel, strcat("points=", ftos(1), "\n"));
    fputs(flannel, strcat("skill=", ftos(cvar("skill")), "\n"));
    fputs(flannel, strcat("campaign=", CAMP_FILENAME, "\n"));
    
    if( GAME_SAVES_NEWG[cvar("saveslot")] ){
      fputs(flannel, "mechs=1,2,3,4,5\n");
    }
    else{    
      if(CAMP_SELECT_MECHS != "" || strlen(CAMP_SELECT_MECHS) > 0){
        fputs(flannel, strcat("mechs=", CAMP_SELECT_MECHS, "\n"));
      }
      else{
        fputs(flannel, "mechs=\n");
      }
    }
    if(CAMP_SELECT_ITEMS != "" || strlen(CAMP_SELECT_ITEMS) > 0){
      fputs(flannel, strcat("items=", CAMP_SELECT_ITEMS, "\n"));
    }
    else{
      fputs(flannel, "items=\n");
    }
    fputs(flannel, strcat("newgame+=", ftos(cvar("cl_newgameplus")), "\n"));
  fclose(flannel);
};


string TEMP_UNLOCK_MECH;
string TEMP_UNLOCK_ITEM;

//queries a msn file solely for its unlocks
string( string fileName ) parse_msn_file_unlocks={
  local float tobj, flannel, argc, line_tag, token;
  local string file, contents, line;
  
  local string returnMechs;
  local string returnItems;
  local string returnAll;
  
  file = strcat(PATH_DATA_MAP, fileName, "/", fileName, ".msn");
  flannel = fopen(file, FILE_READ);
  
  tobj = 0;
  if( flannel != -1){
    contents = fgets(flannel);
    argc = tokenizebyseparator(contents, "{",",","}");
    line = fgets(flannel);
    token = 4; //general pointer inside tokenized msn file value
    while( (line != "") ){
      if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
        line_tag = tokenizebyseparator(line, "'", "'", ": ","'","'");
        //objectives section
        tobj = msn_mapobjid(tobj, argv(1), argv(token));  //somehow reading this second works
        
        if(tobj > 0){
          if(argv(1) == MSN_FILE_OBJ_MECH){
            returnMechs = strcat(returnMechs, argv(token), " ");
          }
          if(argv(1) == MSN_FILE_OBJ_ITEM){
            returnItems= strcat(returnItems,  argv(token), " ");
          }
        }
      }
      //checks for end-of-objective struct
      if( (tobj > 0) && (line =="}")){
        tobj = 0;
      }
      line = fgets(flannel);
    }
    //always close a file :3
    fclose(flannel);
  }
  
  returnAll = strcat(returnMechs, "|", returnItems);
  return returnAll;
  
};

/*
  Now we go nuts, open the save file's target campaign
*/
void(string campFile, string mapName) patch_savefile_map_unlocks={
  local float flannel;
  local string contents, line;
  local float mapItr;
  local string mapFile;
  local string mapUnlocks;
  local string newMechs, newItems;
  local float markedMap;
  
  TEMP_UNLOCK_MECH = "";
  TEMP_UNLOCK_ITEM = "";
  
  //TODO - also grab campaign's starting equip stuff!
  campaign_loadMapList( campFile );
  
  markedMap = FALSE;
  mapItr = 0;
  while( CAMP_MAPS[mapItr] != "" ){
    tokenizebyseparator(CAMP_MAPS[mapItr], ":", "|");
    if( argv(0) == mapName ){
      markedMap = TRUE;
    }
    if( !markedMap ){
      mapUnlocks = parse_msn_file_unlocks( argv(0) ) ;
      tokenizebyseparator(mapUnlocks, "|");
      TEMP_UNLOCK_MECH = strcat(TEMP_UNLOCK_MECH, argv(0));
      TEMP_UNLOCK_ITEM = strcat(TEMP_UNLOCK_ITEM, argv(1));
    }
    mapItr = mapItr + 1;
  }
};

/*
  Patches a 1.0 file to 2.0
*/
void( float saveSlotId, string mapName, string campFile ) menu_write_patch_save={
  local float flannel;
  local string file;
  local string tmpMechs;
  local string tmpItems;
  local float itr;
  local float max;
  
  patch_savefile_map_unlocks(campFile, mapName);
  
  if( TEMP_UNLOCK_MECH != "" || strlen(TEMP_UNLOCK_MECH) > 0 ){
    tmpMechs = "";
    max = tokenizebyseparator(TEMP_UNLOCK_MECH, " ");
    itr = 0;
    while( itr < max ){
      tmpMechs = strcat(tmpMechs, ",", argv(itr) );
      itr = itr + 1;
    }
  }
  
  if( TEMP_UNLOCK_ITEM != "" || strlen(TEMP_UNLOCK_ITEM) > 0 ){
    tmpItems = "";
    max = tokenizebyseparator(TEMP_UNLOCK_ITEM, " ");
    itr = 0;
    while( itr < max ){
      tmpItems = strcat(tmpItems, ",", argv(itr) );
      itr = itr + 1;
    }
  }
  
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, ftos(saveSlotId), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
    fputs(flannel, "// save file v2.0 for 5.0+ release, don't modify order of labels!\n");
    fputs(flannel, strcat("save=", ftos(saveSlotId), "\n"));
    fputs(flannel, strcat("mission=", mapName, "\n"));
    fputs(flannel, strcat("points=", ftos(1), "\n"));
    fputs(flannel, strcat("skill=", ftos(cvar("skill")), "\n"));
    fputs(flannel, strcat("campaign=", campFile, "\n"));
    
    if( GAME_SAVES_NEWG[saveSlotId] ){
      fputs(flannel, "mechs=1,2,3,4,5\n");
    }
    
    else{    
      if(tmpMechs != "" || strlen(tmpMechs) > 0){
        fputs(flannel, strcat("mechs=", tmpMechs, "\n"));
      }
      else{
        fputs(flannel, "mechs=\n");
      }
    }
    
    if( GAME_SAVES_NEWG[saveSlotId] ){
      fputs(flannel, "items=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21\n");
    }
    else{
      if(tmpItems != "" || strlen(tmpItems) > 0){
        fputs(flannel, strcat("items=", tmpItems, "\n"));
      }
      else{
        fputs(flannel, "items=\n");
      }
    }
    fputs(flannel, strcat("newgame+=", ftos(cvar("cl_newgameplus")), "\n"));
  fclose(flannel);
};