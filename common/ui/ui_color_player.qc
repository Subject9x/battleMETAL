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

vector CLR_PLAYER_LIST[32];
//make sure to call this at game start wherever you need it.
void() ui_colors_set_player_list={

  //#ff0000
  CLR_PLAYER_LIST[0] = '1.0 0 0';
  
  //#ff8000
  CLR_PLAYER_LIST[1] = '1.0 0.25 0';
  
  //#ffbf00
  CLR_PLAYER_LIST[2] = '1.0 0.74 0';
  
  //#ffff00
  CLR_PLAYER_LIST[3] = '1.0 1.0 0';
  
  //#bfff00
  CLR_PLAYER_LIST[4] = '0.74 1.0 0';
  
  //#80ff00
  CLR_PLAYER_LIST[5] = '0.5 1.0 0';
  
  //#40ff00
  CLR_PLAYER_LIST[6] = '0.25 1.0 0';
  
  //#00ff40
  CLR_PLAYER_LIST[7] = '0 1.0 0.25';
  
  //#00ff80
  CLR_PLAYER_LIST[8] = '0 1.0 0.5';
  
  //#00ffbf
  CLR_PLAYER_LIST[9] = '0 1.0 0.75';
  
  //#00ffff
  CLR_PLAYER_LIST[10] = '0 1.0 1.0';
  
  //#00bfff
  CLR_PLAYER_LIST[11] = '0 0.75 1.0';
  
  //#0080ff
  CLR_PLAYER_LIST[12] = '0 0.5 1.0';
  
  //#0040ff
  CLR_PLAYER_LIST[13] = '0 0.25 1.0';
  
  //#0000ff
  CLR_PLAYER_LIST[14] = '0 0.0 1.0';
  
  //#4000ff
  CLR_PLAYER_LIST[15] = '0.25 0.0 1.0';
  
  //#8000ff
  CLR_PLAYER_LIST[16] = '0.5 0.0 1.0';
  
  //#bf00ff
  CLR_PLAYER_LIST[17] = '0.74 0.0 1.0';
  
  //#ff00ff
  CLR_PLAYER_LIST[18] = '1.0 0.0 1.0';
  
  //#ff00bf
  CLR_PLAYER_LIST[19] = '1.0 0.0 0.74';
  
  //#ff0080
  CLR_PLAYER_LIST[20] = '1.0 0.0 0.5';
  
  //#FFFFFF - NONE
  CLR_PLAYER_LIST[21] = '1.0 1.0 1.0';
};