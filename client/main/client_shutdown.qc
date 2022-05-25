/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/

/*
  Called when CSQC is unloaded / shutdown before map-change.
  Used for garbage colleting strings mostly.
*/
void() CSQC_Shutdown =
{
  //Clean up ents
  hud_armor_model_target_cleanup();
  remove(toolTip);
  remove(UI_HANGAR_DATA_mech);
  remove(UI_ARMING_DATA_item_a);
  remove(UI_ARMING_DATA_item_b);
  remove(UI_ARMING_DATA_item_list);
  remove(UI_ARMING_item_drag);
  remove(HUD_DATA_weapon);
  remove(UI_HANGAR_DATA_mech_list);
  
  //server string cleanup
  freeGlobalString(CLIENT_INFO_STRING)
  
  freeGlobalString(UNLOCKED_MECHS_DATA)
  freeGlobalString(UNLOCKED_ITEMS_DATA)
  freeGlobalString(MENU_DEBRIEF_unlocks_mechs)
  freeGlobalString(MENU_DEBRIEF_unlocks_equip)
  freeGlobalString(SV_NEXTMAP)
  freeGlobalString(ENT_SERVER_INFO.svAbout)
  freeGlobalString(ENT_SERVER_INFO.nextMap)
  
  freeGlobalString(PLAYER_COLOR_PSC)
  freeGlobalString(PLAYER_COLOR_SRV)
  freeGlobalString(PLAYER_COLOR_MIL)
  
  freeGlobalString(MAP_NAME);
  
  //config file cleanup
  freeGlobalString(DATA_CONFIG_BUFFER_NAME)
  
  freeGlobalString(UNLOCKED_MECHS_DATA)
  freeGlobalString(UNLOCKED_ITEMS_DATA)
  
  //4.0.0 - WARN : campaign file system upgraded, this patches older save files.
  if( strcmp( SAVEFILE_CAMPAIGN, "aa1.dat") ){
    SAVEFILE_CAMPAIGN = "";
  }
  else if( strcmp(SAVEFILE_CAMPAIGN, "aa2.dat") ){
    SAVEFILE_CAMPAIGN = "";
  }
  else{
    freeGlobalString(SAVEFILE_CAMPAIGN)
  }
  
  
  
  freeGlobalString(SAVEFILE_CACHE_MAP)
  
  freeGlobalString(MENU_DEBRIEF_unlocks_mechs)
  freeGlobalString(MENU_DEBRIEF_unlocks_equip)
  
  freeGlobalString(DATA_CONFIG_BUFFER_NAME)
  
  //mission file cleanup
  msn_free_strings();
  
  //Entities
  freeGlobalString(CLIENT_netname)
  freeGlobalString(MISSION_NAME)
  freeGlobalString(HUD_INFO_MSG)
  
  localcmd("cd stop\n");
  
  menu_chat_cleanup();
  
  gui_set_screen_size(VIEW_ACT_x, VIEW_ACT_y);
};