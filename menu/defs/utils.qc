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
    fputs(flannel, "{\n");
    fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
    fputs(flannel, strcat("  'mission' : ", CAMP_SELECT_START, ",\n"));
    fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
    fputs(flannel, strcat("  'skill' : ", ftos(cvar("skill")), ",\n"));
    fputs(flannel, strcat("  'campaign' : ", CAMP_SELECT_NAME, ",\n"));
    
    if( GAME_SAVES_NEWG[cvar("saveslot")] ){
      fputs(flannel, "  'mechs' : 1 2 3 4 5,\n");
    }
    else{    
      if(CAMP_SELECT_MECHS != "" || strlen(CAMP_SELECT_MECHS) > 0){
        fputs(flannel, strcat("  'mechs' : ", CAMP_SELECT_MECHS, ",\n"));
      }
      else{
        fputs(flannel, "  'mechs' : ,\n");
      }
    }
    if(CAMP_SELECT_ITEMS != "" || strlen(CAMP_SELECT_ITEMS) > 0){
      fputs(flannel, strcat("  'items' : ", CAMP_SELECT_ITEMS, ",\n"));
    }
    else{
      fputs(flannel, "  'items' : ,\n");
    }
    fputs(flannel, strcat("  'newgame+' : ", ftos(cvar("cl_newgameplus")), ",\n"));
    fputs(flannel, "}");
  fclose(flannel);
};