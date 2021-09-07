/*
battleMETAL
Author: Peter Roohr
Date: 12/07/2020

  Player Mech Color constants.
    Players can choose different tints for their mechs
  
*/
.string unitColorData;  // comma-separated value CT LT RT LA RA LG, each an index number mapping to the color array.
.float unitColorCT;
.float unitColorLT;
.float unitColorRT;
.float unitColorLA;
.float unitColorRA;
.float unitColorLG;

vector CLR_PLAYER_LIST[128];
float CLR_PLAYER_MAX;
//make sure to call this at game start wherever you need it.
void() ui_colors_set_player_list={

  local float file;
  local string line;
  local float i;
  
  file = fopen("cache/player_colors.txt", FILE_READ);
  if( file != -1) {
    line = fgets(file);
    while( line != "" ){
      if( strstrofs(line, "#", 0) == -1){
        if( i < 128 ){
          tokenizebyseparator(line, ",");
          CLR_PLAYER_LIST[i] = Vector3(stof(argv(0))/255.0,stof(argv(1))/255.0,stof(argv(2))/255.0);
          i = i + 1;
        }
      }
      line = fgets(file);
    }
    fclose(file);
    CLR_PLAYER_MAX = i;
  }
};