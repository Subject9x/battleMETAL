/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  breaks the nav bar down into components, so that they can placed in more locations.
  
*/

/*
  BUTTON - Briefing Menu
*/
void( vector ofs ) ui_navbutton_brief_draw={
  local vector textPos;
  local float strWidth;
  
  UI_NAVBAR_BRIEF_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderTintImage((CLIENT_MENU_menu_choice == MENU_BRIEF_ACTIVE), UI_NAVBAR_BRIEF_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_BRIEF_SIZE, CLR_DEF_WEP_INRANGE, 1, 0) ;
  
  textPos = UI_NAVBAR_BRIEF_ORG;
  strWidth = stringwidth("BRIEFING", 0 , UI_NAVBAR_font_unselect) / 2;
  textPos_x = (UI_NAVBAR_BRIEF_ORG_x + (UI_NAVBAR_BRIEF_SIZE_x/2)) - strWidth;
  textPos_y = UI_NAVBAR_BRIEF_ORG_y + 6;
  gui_renderHighlightString("BRIEFING", textPos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', (CLIENT_MENU_menu_choice == MENU_BRIEF_ACTIVE), UI_NAVBAR_font_unselect, 1, 0) ;
  drawfont = drawfont_prev;
};
//BRIEFING - onClick
void() ui_navbutton_brief_click={
  INFO_SWITCH = 1;
  //if previous menu was ARMING, save config
  if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
    data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
  }
  CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
};

/*
  BUTTON - Hangar Menu
*/
void( vector ofs ) ui_navbutton_hangar_draw={
  local vector textPos;
  local float strWidth;
  
  UI_NAVBAR_HANGAR_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderTintImage((CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE), UI_NAVBAR_HANGAR_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_HANGAR_SIZE, CLR_DEF_WEP_INRANGE, 1, 0) ;
  textPos = UI_NAVBAR_HANGAR_ORG;
  if( CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE ){
  }
  else{
  }
  strWidth = stringwidth("HANGAR", 0 , UI_NAVBAR_font_unselect)/2;
  textPos_x = (textPos_x + (UI_NAVBAR_HANGAR_SIZE_x/2)) - strWidth;
  textPos_y = textPos_y + 6;
  gui_renderHighlightString("HANGAR", textPos, CLR_DEF_WEP_INRANGE, '0.75 0.75 0.75', (CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE), UI_NAVBAR_font_unselect, 1, 0) ;
  drawfont = drawfont_prev;
};
void() ui_navbutton_hangar_click={
  if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
    data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
  }
  if( SELECT_MECH == 0 || CLIENT_MENU_sel_mech == 0 ){
    SELECT_MECH = CLIENT_MENU_sel_mech = UNLOCKED_MECHS[0];
  }
  CLIENT_MENU_menu_choice = MENU_HANGAR_ACTIVE;
  cl_get_mechs_sort();
};

/*
  BUTTON - Arming Menu
*/
void( vector ofs ) ui_navbutton_arming_draw={
  local vector textPos;
  local float strWidth;
  
  local vector arming_clr;
  local float arming_flt;
  
  UI_NAVBAR_ARMING_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if(SELECT_MECH != 0){
    arming_clr = '0.75 0.75 0.75';
    arming_flt = (CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE);
    if(arming_flt){
      arming_clr = CLR_DEF_WEP_INRANGE;
    }
  }
  else{
    arming_clr = '0.25 0.25 0.25';
    arming_flt =  TRUE;
  }
  gui_renderTintImage(arming_flt, UI_NAVBAR_ARMING_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_ARMING_SIZE, arming_clr, 1, 0) ;
  textPos = UI_NAVBAR_ARMING_ORG;
  if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
  }
  else{
  }
  strWidth = stringwidth("ARMING", 0 , UI_NAVBAR_font_unselect )/2;
  textPos_x = (textPos_x + (UI_NAVBAR_ARMING_SIZE_x/2)) - strWidth;
  textPos_y = textPos_y + 6;
  drawstring(textPos, "ARMING", UI_NAVBAR_font_unselect, arming_clr, 1, 0);
  drawfont = drawfont_prev;
};
void() ui_navbutton_arming_click={
  local float itemUnlockCounter;
  local float itemId;
  if(SELECT_MECH != 0){
    if( CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE ){
      cl_setmech( SELECT_MECH );
      cl_send_infostring( INFO_FLAG_MECH );
    }
    CLIENT_MENU_menu_choice = MENU_ARMING_ACTIVE;
    itemUnlockCounter = 0;
    while( itemUnlockCounter <= UNLOCKED_ITEMS_TOTAL ){
      if( UNLOCKED_ITEMS[itemUnlockCounter] != 0 ){
        itemId = UNLOCKED_ITEMS[itemUnlockCounter];
        //UI_ARMING_DATA_item_list is used as a sort-of pointer for list-style operations
        data_get_client_item_( UI_ARMING_DATA_item_list, itemId );
    
        //lists are stateful, so we offload the data we care about to clunky arrays.
        data_WeaponNames[itemId] = UI_ARMING_DATA_item_list.w_name;
        data_WeaponSize[itemId] = UI_ARMING_DATA_item_list.equipSize;
        data_WeaponType[itemId] = UI_ARMING_DATA_item_list.damageType;
      }
      itemUnlockCounter = itemUnlockCounter + 1;
    }
  }
};


/*
  BUTTON - Deployment Menu
*/
void( vector ofs ) ui_navbutton_deploy_draw={
  local vector textPos;
  local float strWidth;
  
  local vector deploy_clr;
  local float deploy_flt;
  
  UI_NAVBAR_DEPLOY_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if( (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS) ) ){
    deploy_clr = CLR_DEF_WEP_INRANGE;
    deploy_flt = (CLIENT_MENU_menu_choice == MENU_DEPLOY_ACTIVE);
  }
  else{
    deploy_clr =  '0.25 0.25 0.25';
    deploy_flt = TRUE;
  }
  gui_renderTintImage(deploy_flt, UI_NAVBAR_DEPLOY_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_DEPLOY_SIZE, deploy_clr, 1, 0) ;
  textPos = UI_NAVBAR_DEPLOY_ORG;
  
  strWidth = stringwidth("DEPLOYMENT", 0 , UI_NAVBAR_font_unselect)/2;
  textPos_x = (textPos_x +  (UI_NAVBAR_DEPLOY_SIZE_x/2)) - strWidth;
  textPos_y = textPos_y + 6;
  gui_renderHighlightString("DEPLOYMENT", textPos, deploy_clr, '0.75 0.75 0.75', deploy_flt, UI_NAVBAR_font_unselect, 1, 0) ;
  
  drawfont = drawfont_prev;
};
void() ui_navbutton_deploy_click={
  local entity deploy;
  local entity previous;
  
  if( CLIENT_MENU_menu_choice == MENU_ARMING_ACTIVE ){
    if( CLIENT_MENU_nex_grp1 == 0 && time > UI_ARMING_GROUP_WARN_TIMER){
      UI_ARMING_GROUP_WARN_TIMER = time + UI_ARMING_GROUP_WARN_DECAY;
      return;
    }
    data_mech_config_save( SELECT_MECH, CFG_INDEX ); //save current config to the player's chosen config slot
    
    cl_setweapongroup( CLIENT_MENU_nex_grp1, CLIENT_MENU_nex_grp2, CLIENT_MENU_nex_grp3, CLIENT_MENU_nex_grp4 );
    cl_send_infostring( INFO_FLAG_GROUPS );
  }
  
  if( CLIENT_MENU_menu_choice == MENU_HANGAR_ACTIVE ){
    cl_setweapongroup( CLIENT_MENU_nex_grp1, CLIENT_MENU_nex_grp2, CLIENT_MENU_nex_grp3, CLIENT_MENU_nex_grp4 );
    cl_send_infostring( INFO_FLAG_GROUPS );
  }
  
  if( CLIENT_MENU_deploy == world ){
    //build list of faction-only deply points
    for( deploy = DEPLOYPOINT; deploy != world; deploy = deploy.partNext ){
      if( deploy.faction == CLIENT_faction || deploy.faction == FACTION_ALL ){
        if( !previous.data_idx ){
          FACTION_DEPLOY = deploy; // first point
          previous = deploy;
        }
        else{
          previous.nextPoint = deploy;
          deploy.prevPoint = previous;
          previous = deploy;
        }
      }
    }
    if( FACTION_DEPLOY.data_idx ){
      CLIENT_MENU_deploy = FACTION_DEPLOY;
      CLIENT_MENU_nav_pnt = CLIENT_MENU_deploy.data_idx;
      if( !(LAUNCH_VALIDATION & VALID_NODE) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
      }
    }
    
    if( !(ENT_SERVER_INFO.serverFlags & SVFLAG_SPAWNFAR) ){
      cl_setspawnpoint( CLIENT_MENU_nav_pnt );
      cl_send_infostring( INFO_FLAG_DEPLOY );
    }
  }
  
  SPRITE_deploy_point_FRAME = 1;
  CLIENT_MENU_menu_choice = MENU_DEPLOY_ACTIVE;
  
  if( CLIENT_MENU_nav_pnt != -1 ){
    LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_NODE;
  }
  else{
    LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_NODE);
  }
};

/*
  BUTTON - Launch!
*/
void( vector ofs ) ui_navbutton_launch_draw={
  local vector textPos;
  local float strWidth;
  local string text;
  local float t;
  local float sec;
  
  UI_NAVBAR_LAUNCH_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  gui_renderTintImage2((LAUNCH_VALIDATION & VALID_NODE), UI_NAVBAR_LAUNCH_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_LAUNCH_SIZE, CLR_DEF_WEP_INRANGE * 0.85, '0.25 0.25 0.25', 1, 0);

  if( servertime < MENU_respawn_cool ){
    t = 15 - (servertime - MENU_respawn_cool_start); 
    sec = t - floor( t / 60 ) * 60 ;
    sec = rint(sec);
    text = sprintf("%02d", sec);
    gui_renderMeter( ( (15 - sec) / 15) * 100, UI_NAVBAR_CONNECT_ORG, UI_NAVBAR_CONNECT_SIZE, CLR_DEF_GRAY_H, CLR_DEF_IIF_FRIEND_BLD, 0.367, 0, AXIS_H, FALSE);
  }
  else{
    text = ">>LAUNCH>>";
  }
  strWidth = stringwidth(text, 0 , UI_NAVBAR_font_select);
  textPos = UI_NAVBAR_LAUNCH_ORG;
  textPos_x = (textPos_x + (UI_NAVBAR_LAUNCH_SIZE_x/2)) - (strWidth / 2);
  textPos_y = (textPos_y + 4.32);
  
  gui_renderHighlightString(text, textPos, CLR_DEF_GREEN * 2, CLR_DEF_TXT_NONSELECT, (LAUNCH_VALIDATION & VALID_NODE), UI_NAVBAR_font_select, 1, 0) ;
  drawfont = drawfont_prev;
};
void() ui_navbutton_launch_click={
  local entity hardpoint;
  local float bit;
  local string weaponsList;
  local float totalHardpoints;
  local float turboTotalPerc;
  if( MECH_DATA_ID == 0 ){
    return;
  }
  if( servertime > MENU_respawn_cool ){
    if( (LAUNCH_VALIDATION & VALID_NODE) && (LAUNCH_VALIDATION & VALID_GRPS) && (LAUNCH_VALIDATION & VALID_MECH) ){
      CLIENT_MENU_sel_hrpnt = 0;
      
      LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_LAUNCH;
      
      HUD_LOCK_FLAG = FALSE;
      
      bit = 1;
      totalHardpoints = 1;
      weaponsList = " ";
      hardpoint = UI_HANGAR_DATA_mech.w_slot;
      CLIENT_weapon_state = 0;
      while( hardpoint ){
        weaponsList = strcat(weaponsList, ftos(hardpoint.data_idx), " ");
        
        //turbocharger upgrade...
        if( hardpoint.data_idx == UID_ITEM_turbo_charger ){
          turboTotalPerc = turboTotalPerc + (0.4 - (UI_HANGAR_DATA_mech.vec_size/10));
        }
        
        if( (hardpoint.damageType & EFF_LOK) ){
          HUD_LOCK_FLAG = TRUE;
        }
        
        //bind weapon data, reduce server traffic
        switch(bit){
          case WEAPON1:
            CLIENT_stat_w1_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON2:
            CLIENT_stat_w2_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON3:
            CLIENT_stat_w3_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON4:
            CLIENT_stat_w4_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON5:
            CLIENT_stat_w5_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON6:
            CLIENT_stat_w6_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON7:
            CLIENT_stat_w7_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON8:
            CLIENT_stat_w8_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
          case WEAPON9:
            CLIENT_stat_w9_id = hardpoint.data_idx;
            CLIENT_weapon_state = CLIENT_weapon_state | bit;
            break;
        }
        bit = floor(bit * 2);
        hardpoint = hardpoint.w_slot;
        totalHardpoints = totalHardpoints + 1;  
      }
      
      CLIENT_hardpoint_cnt = totalHardpoints;
      CLIENT_stat_rdr_mode = CLIENT_stat_rdr_mode_prev = 1; //go active radar on spawn;      
      CLIENT_radar_range = MECH_DATA_RAD * 2; //go active on spawn
      
      CLIENT_health_center_prev = CLIENT_health_center = MECH_DATA_HPCT;
      CLIENT_health_legs_prev = CLIENT_health_legs = MECH_DATA_HPLG;
      CLIENT_health_torso_left_prev = CLIENT_health_torso_left = MECH_DATA_HPST;
      CLIENT_health_torso_right_prev = CLIENT_health_torso_right = MECH_DATA_HPST;
      CLIENT_health_arm_left_prev = CLIENT_health_arm_left = MECH_DATA_HPAR;
      CLIENT_health_arm_right_prev = CLIENT_health_arm_right = MECH_DATA_HPAR; 
      
      cl_set_hud_vars(UI_HANGAR_DATA_mech, turboTotalPerc);
      
      //info string update
      cl_setmech(MECH_DATA_ID);
      cl_setweapon(CLIENT_weapon_state);
      cl_setspawnpoint( CLIENT_MENU_nav_pnt );
      //send to server
      cl_send_infostring( (INFO_FLAG_MECH | CLIENT_weapon_state | INFO_FLAG_SPAWN | INFO_FLAG_DEPLOY | INFO_FLAG_SPAWN | INFO_FLAG_COLOR) );
      
      cl_set_chase();
      
      if( HUD_EXTERNAL_CAM_ACTIVE ){
        ui_data_load_hud( HUD_EXTERNAL_CAM_DATA );
      }
      else{
        ui_data_load_hud( MECH_DATA_ID );
      }
      
      //super smaht weapon group testing
      if( CLIENT_MENU_nex_grp1 == 0 ){
        CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 | bit;
      }
      
      client_event_mission_name( MSN_DISP );
      CLIENT_spawn_time = servertime; //mark for when player dies.
      CLIENT_ram_max = UI_HANGAR_DATA_mech.ramUpMax;
      menu_exit();
      
      menu_chat_config(TRUE);
    }
  }
};


/*
  BUTTON - Connect Menu
*/
void( vector ofs ) ui_navbutton_connect_draw={
  local vector fontSize;
  local vector textPos;
  local float strWidth;
  local vector disColor;
  
  UI_NAVBAR_CONNECT_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if( UI_NAVBAR_CONNECT_HOVER ){
    disColor = CLR_DEF_IIF_FRIEND_BLD * 1.55;
    fontSize = UI_NAVBAR_font_select;
  }
  else{
    disColor = CLR_DEF_IIF_FRIEND_BLD;
    fontSize = UI_NAVBAR_font_unselect;
  }
  drawpic(UI_NAVBAR_CONNECT_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_CONNECT_SIZE, disColor, 1, 0) ;
  textPos = UI_NAVBAR_CONNECT_ORG;
  strWidth = stringwidth("Enter Server", 0 , fontSize)/2;
  textPos_x = (textPos_x +  64) - strWidth;
  textPos_y = textPos_y + 6;
  drawstring(textPos, "Enter Server", fontSize, disColor, 1, 0) ;
  
  drawfont = drawfont_prev;
};
void() ui_navbutton_connect_click={
  if( servertime > MENU_button_delay ){
    CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
  }
};

/*
  BUTTON - Server Info Menu
*/
void( vector ofs ) ui_navbutton_info_draw={

};
void() ui_navbutton_info_click={

};

/*
  BUTTON - Disconnect From Server
*/
void( vector ofs ) ui_navbutton_disconnect_draw={
  local vector fontSize;
  local vector textPos;
  local float strWidth;
  local vector disColor;
  
  UI_NAVBAR_DISCONNECT_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  disColor = CLR_DEF_ARM_THREEQ;
  if( UI_NAVBAR_DISCONNECT_HOVER ){
    fontSize = UI_NAVBAR_font_select;
  }
  else{
    fontSize = UI_NAVBAR_font_unselect;
  }
  drawpic(UI_NAVBAR_DISCONNECT_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_DISCONNECT_SIZE, disColor, 1, 0) ;
  
  textPos = UI_NAVBAR_DISCONNECT_ORG;
  strWidth = stringwidth("Disconnect", 0 , fontSize)/2;
  textPos_x = (textPos_x +  64) - strWidth;
  textPos_y = textPos_y + 6;
  drawstring(textPos, "Disconnect", fontSize, disColor, 1, 0) ;
  drawfont = drawfont_prev;
};
void() ui_navbutton_disconnect_click={
  cvar_set("sv_public", "-2");
  cvar_set("deathmatch", "0");
  cvar_set("teamplay", "0");
  cvar_set("coop", "0");
  localcmd("disconnect;\n");
  localcmd("togglemenu;\n");
};

/*
  BUTTON - Change Team
*/
void( vector ofs ) ui_navbutton_team_draw={
  local vector fontSize;
  local vector textPos;
  local float strWidth;
  local vector disColor;
  
  UI_NAVBAR_TEAM_ORG = ofs;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if( UI_NAVBAR_TEAM_HOVER ){
    disColor = CLR_DEF_WEP_LOWENG * 4;
    fontSize = UI_NAVBAR_font_select;
  }
  else{
    disColor = CLR_DEF_WEP_LOWENG * 3;
    fontSize = UI_NAVBAR_font_unselect;
  }
  if( CLIENT_faction == FACTION_SURVEST ){
    if( TEAM_MILITAR_TOTAL > 7 ){
      disColor = CLR_DEF_TXT_NONSELECT;
    }
  }
  if( CLIENT_faction == FACTION_MILITAR ){
    if( TEAM_SURVEST_TOTAL > 7 ){
      disColor = CLR_DEF_TXT_NONSELECT;
    }
  }
  
  drawpic(UI_NAVBAR_TEAM_ORG, UI_DEF_BOX_256_BTN, UI_NAVBAR_TEAM_SIZE, disColor, 1, 0) ;
  textPos = UI_NAVBAR_TEAM_ORG;
  strWidth = stringwidth("Switch Team", 0 , fontSize)/2;
  textPos_x = (textPos_x +  64) - strWidth;
  textPos_y = textPos_y + 6;
  drawstring(textPos, "Switch Team", fontSize, disColor, 1, 0) ;
  
  drawfont = drawfont_prev;
};
void() ui_navbutton_team_click={
  local float nextFaction;
  if( CLIENT_faction == FACTION_SURVEST ){
    nextFaction = FACTION_MILITAR;
  }
  else if(CLIENT_faction == FACTION_MILITAR){
    nextFaction = FACTION_SURVEST;
  }
  if( nextFaction > 0 ){
    cl_set_faction( nextFaction );
    cl_send_infostring( INFO_FLAG_FACTION );
  }
};