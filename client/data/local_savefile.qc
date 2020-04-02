/*
battleMETAL
Author: Peter Roohr
Date: 04/02/2020
Overview:
  Local save file handling.
  Network games will validate player selection data on-submit.
  Campaign games will load data locally.
*/

/*

      cl_get_mechs_all( argv(1) );
    }
    else if(argv(1) == "lis"){
      tokenizebyseparator(s, "[", "]");
      cl_get_items_all( argv(1) )
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
  else{
    if( cvar("developer") ){
      error(strcat("cl_load_savefile()->: ", fileName, " was not found"));
    }
  }
  
  cl_get_mechs_all( mechData );
  cl_get_items_all( itemData );
};

void( float gameType ) cl_set_savepath={
  local string filePath;
  
  switch( gameType ){
    case GAMEMODE_CAMPAIGN:
      filePath = strcat(PATH_DATA_SAVE,SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
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

