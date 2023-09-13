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
  local float flannel, line_tag;
  
  if( cvar("developer") ){
    dprint(sprintf("cl_load_savefile()->FILENAME = %s\n", fileName));  //debug
  }
  flannel = fopen(fileName, FILE_READ);
  if(flannel > -1){
    contents = fgets(flannel);
    line = fgets(flannel);
    while( (line != "") ){
      if( substring(line,0, 2) != "//" ){
        line_tag = tokenizebyseparator(line, "=");
        if( argv(0) == SAVE_FILE_MECH_LIST ){
          cacheGlobalString( UNLOCKED_MECHS_DATA, argv(1))
        }
        if( argv(0) == SAVE_FILE_ITEMS ){
          cacheGlobalString( UNLOCKED_ITEMS_DATA, argv(1))
        }
        if( argv(0) == CAMP_SAVE_TAG ){
          //5.0.0 - permanent save file format change
          cacheGlobalString( SAVEFILE_CAMPAIGN, argv(1))
        }
        if( argv(0) == SAVE_TAG_MISSION ){
          cacheGlobalString( SAVEFILE_CACHE_MAP, argv(1))
        }
        if( argv(0) == CAMP_TAG_NEWG){
          cvar_set("cl_newgameplus", argv(1));
        }
      }
      line = fgets(flannel);
    }
    fclose(flannel);
    
    SAVE_FILE_LOADED = TRUE;
  }
  else{
    if( cvar("developer") ){
      dprint(sprintf("cl_load_savefile()->FILENAME %s was not found\n", fileName));  //debug
    }
  }
  
  cl_load_mechs_all();
  cl_load_items_all();
};

/*
  Now we go nuts, open the save file's target campaign
*/
void() cl_load_savefile_singleMap={
  
  local string cleanMapName;
  local float flannel;
  local string contents, line;
  local float mapItr;
  local string mapFile;
  local string mapUnlocks;
  local string newMechs, newItems;
  local float markedMap;
  
  campaign_loadMapList( cvar_string("sv_campaign") );
  tokenizebyseparator(mapname, "/", ".");
  cleanMapName = argv(1);
  
  markedMap = FALSE;
  mapItr = 0;
  while( CAMP_MAPS[mapItr] != "" ){
    tokenizebyseparator(CAMP_MAPS[mapItr], ":", "|");
    if( argv(0) == cleanMapName ){
      markedMap = TRUE;
    }
    if( !markedMap ){
      mapUnlocks = msn_parsefile_get_unlocks( argv(0) ) ;
      tokenizebyseparator(mapUnlocks, "|");
      newMechs = strcat(newMechs, argv(0));
      newItems = strcat(newItems, argv(1));
    }
    mapItr = mapItr + 1;
  }

  cacheGlobalString( UNLOCKED_MECHS_DATA, newMechs )
  cacheGlobalString( UNLOCKED_ITEMS_DATA, newItems )
  cl_load_mechs_all();
  cl_load_items_all();
  SAVE_FILE_LOADED = TRUE;
};

/*
  Detect the end/last playable map of a campaign file so that the newgame+ flag can be set correctly.
  campaign map lists need to have a '+' at the start map and a '*' for the end map.

  example: o1m1:o1m2|none|+ //start
  example: o3m6:anim4|none|*  //end
*/
float() cl_campaign_check_end={
  
  local string cleanMapName;
  local float flannel;
  local string contents, line;
  local float mapItr;
  
  campaign_loadMapList( cvar_string("sv_campaign") );
  tokenizebyseparator(mapname, "/", ".");
  cleanMapName = argv(1);
  
  mapItr = 0;
  while( CAMP_MAPS[mapItr] != "" ){
    tokenizebyseparator(CAMP_MAPS[mapItr], ":", "|");
    if(argv(3) == "*"){
      cacheGlobalString(CAMP_END_MAP, argv(0))
    }
    if(argv(3) == "+"){
      cacheGlobalString(CAMP_START_MAP, argv(0))
    }
    mapItr = mapItr + 1;
  }

  if(CAMP_END_MAP == cleanMapName){
    return TRUE;
  }
  return FALSE;
};

string(float msnWin) cl_campaign_next_map={
  
  local float flannel;
  local float mapItr;
  
  local string line;
  local string cleanMapName;
  local string theMap
  
  campaign_loadMapList( cvar_string("sv_campaign") );
  tokenizebyseparator(mapname, "/", ".");
  cleanMapName = argv(1);
  
  mapItr = 0;
  while( CAMP_MAPS[mapItr] != "" ){
    tokenizebyseparator(CAMP_MAPS[mapItr], ":", "|");
    if(argv(0) == cleanMapName){
      if( msnWin == TRUE){
          theMap = argv(1);
      }
      else{
        theMap = argv(2);
      }
    }
    mapItr = mapItr + 1;
  }
  return theMap;
};


void( float serverMode, float svFlags ) cl_set_savepath={
  local string filePath;
  
  if( cvar("sv_singlemap") && (cvar_string("sv_campaign") != "" && strlen(cvar_string("sv_campaign")) > 0) ){
    cl_load_savefile_singleMap();
  }
  else{
    if( (svFlags & SVFLAG_ITEMOVER) ){
      if( cvar_string("sv_campaign") == "arcade" ){
        filePath = strcat(PATH_DATA_MAP, MAP_NAME, "/instant", SAVE_FILE_EXT);
      }
      else{
        filePath = strcat(PATH_DATA_MAP, MAP_NAME, "/", MAP_NAME, SAVE_FILE_EXT);          
      }
    }
    else{
      switch( serverMode ){
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
          //TODO - figure out team dm lists
          filePath = strcat(PATH_DATA_MAP, MAP_NAME, "/dm", SAVE_FILE_EXT);
          break;
      }
    }
    
    cl_load_savefile( filePath );
  }
  //Sort and initialize the mech_names and mech_sizes arrays here
  //so that any UI can access this info.
  cl_get_mechs_sort();
  // if( serverMode == GAMEMODE_CAMPAIGN ){
  //   if( !(svFlags & SVFLAG_NOSAVE) ){
  //     cl_savefile_save_mission(); //single-player caching of map-they-just-connected to.
  //                               //this is to save player progress on entering a new map, lame hack.
  //   }
  // }
};

// all mech unlocks to same array
void() cl_load_mechs_all={
  local float itrTokens, tokens;
  local float mechId;
  local float total;
  
  tokens = tokenizebyseparator(UNLOCKED_MECHS_DATA,",");
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

  tokens = tokenizebyseparator(UNLOCKED_ITEMS_DATA,",");
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
  mechListItem.classname = "UI_ITEM";
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
  local string s;
  
  if(MENU_DEBRIEF_unlocks_mechs != "" && strlen(MENU_DEBRIEF_unlocks_mechs) > 0){
    if(UNLOCKED_MECHS_DATA != ""){
      s = cl_savefile_insert(MENU_DEBRIEF_unlocks_mechs, UNLOCKED_MECHS_DATA);
      cacheGlobalString( UNLOCKED_MECHS_DATA, s )
    }
    else{
      cacheGlobalString( UNLOCKED_MECHS_DATA, MENU_DEBRIEF_unlocks_mechs )
    }
  }
  
  if(MENU_DEBRIEF_unlocks_equip != "" && strlen(MENU_DEBRIEF_unlocks_equip) > 0){
    if(UNLOCKED_ITEMS_DATA != ""){
      s = cl_savefile_insert(MENU_DEBRIEF_unlocks_equip, UNLOCKED_ITEMS_DATA);
      cacheGlobalString( UNLOCKED_ITEMS_DATA, s )
    }
    else{
      cacheGlobalString( UNLOCKED_ITEMS_DATA, MENU_DEBRIEF_unlocks_equip )
    }
  }
};


/*
  Checks to see if unlocks are new to player save data.
  if they are, merge them into existing string, otherwise return new string

*/
string(string newItems, string source) cl_savefile_insert={

  local float newItemTotal;
  local float newItemItr;
  
  local string newToken;
  
  local string append;
  
  local float invItr;
  local float invTotal;
  
  local float unique;
  
  //prep the compare array
    //clear it first just in case previous item set was longer.
  invItr = 0;
  invTotal = 128;
  while( invItr < invTotal ){
    SAVE_COMPARE[invItr] = 0;
    invItr = invItr + 1;
  }
  
  //copy inv items to the array.
  invItr = 0;
  invTotal = tokenizebyseparator(source, ",");
  while( invItr < invTotal ){
    SAVE_COMPARE[invItr] = rint(stof(argv(invItr)));
    invItr = invItr + 1;
  }
  
  append = "";
  //slice up the unlocks
  newItemTotal = tokenizebyseparator(newItems, " ");
  newItemItr = 0;
  
  //append only unique new ids.
  while( newItemItr < newItemTotal ){
    newToken = argv(newItemItr);
    
    unique = TRUE;
    invItr = 0;
    while( invItr < invTotal ){
      if( rint(stof(newToken)) == SAVE_COMPARE[invItr]){
        unique = FALSE;
      }
      invItr = invItr + 1;
    }
    
    if( unique ){
      if( append == "" ){
        append = newToken;
      }
      else{
        append = strcat(append, ",", newToken);
      }
    }
    newItemItr = newItemItr + 1;
  }
  
  if( append == "" ){
    return strcat(source);
  }
  else{
    return strcat(append, ",", source);
  }
};

void() cl_savefile_save={
  local float flannel;
  local string file;
  
  local float newGame;
  
  newGame = cl_campaign_check_end();

  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, ftos(cvar("saveslot")), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  if(flannel > -1){
    fputs(flannel, "// save file v2.0 for 5.0+ release, don't modify order of labels!\n");
    fputs(flannel, strcat("save=", ftos(cvar("saveslot")), "\n"));
    
    if(newGame){
      fputs(flannel, strcat("mission=", CAMP_START_MAP, "\n"));
    }
    else{
      fputs(flannel, strcat("mission=", cl_campaign_next_map((ENT_SERVER_INFO.missionResult == MISSION_RESULT_WIN)), "\n"));
    }
    
    fputs(flannel, strcat("points=", ftos(1), "\n"));
    fputs(flannel, strcat("skill=", ftos(cvar("skill")), "\n"));
    fputs(flannel, strcat("campaign=", SAVEFILE_CAMPAIGN, "\n"));
    fputs(flannel, strcat("mechs=", UNLOCKED_MECHS_DATA, "\n"));
    fputs(flannel, strcat("items=", UNLOCKED_ITEMS_DATA, "\n"));
    if(newGame){
      fputs(flannel, strcat("newgame+=","1", "\n"));
    }
    else{
      fputs(flannel, strcat("newgame+=", "0", "\n"));
    }
    fclose(flannel);
  }
  freeGlobalString(CAMP_START_MAP)
  freeGlobalString(CAMP_END_MAP)
}; 

/*
  dumb work around to make sure the player save file is always updated to the map they're on.
  This is fired as soon as the player connects to a single-player server,
  AND has loaded their local save.
    why? because we can't just inject
  
*/
void() cl_savefile_save_mission={
  local float flannel;
  local string file;

  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  
  if(flannel > -1){
    fputs(flannel, "// save file v2.0 for 5.0+ release, don't modify order of labels!\n");
    fputs(flannel, strcat("save=", ftos(cvar("saveslot")), "\n"));
    fputs(flannel, strcat("mission=", cvar_string("sv_worldbasename"), "\n"));
    fputs(flannel, strcat("points=", ftos(1), "\n"));
    fputs(flannel, strcat("skill=", ftos(cvar("skill")), "\n"));
    fputs(flannel, strcat("campaign=", SAVEFILE_CAMPAIGN, "\n"));
    fputs(flannel, strcat("mechs=", UNLOCKED_MECHS_DATA, "\n"));
    fputs(flannel, strcat("items=", UNLOCKED_ITEMS_DATA, "\n"));
    fputs(flannel, strcat("newgame+=", ftos(cvar("cl_newgameplus")), "\n"));
  }
  fclose(flannel);
}; 


/*
  Default Save File, set when player finishes campaign training.
  *DEPRECATED*
*/
void() cl_savefile_default={
  local float flannel;
  local string file;
  
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "// save file v2.0 for 5.0+ release, don't modify order of labels!\n");
  fputs(flannel, strcat("save=", cvar_string("saveslot"), "\n"));
  fputs(flannel, "mission=o1m1\n");
  if( cvar("developer") ){
    fputs(flannel, "mechs=1,2,3,4,5,\n");
    fputs(flannel, "items=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21\n");
  }
  else{
    fputs(flannel, "mechs=1,\n");
    fputs(flannel, "items=1,3,4,8,12,16,18,21\n");
  }
  
  fputs(flannel, "points=0\n");
  fputs(flannel, strcat("skill=", ftos(cvar("skill")), "\n"));
  fputs(flannel, "newgame': 1\n");
  fputs(flannel, strcat("campaign' : ", SAVEFILE_CAMPAIGN, "\n"));
  fclose(flannel);
};