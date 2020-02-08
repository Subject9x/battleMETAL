/*
battleMETAL
Author: Peter Roohr
Date: 1/6/2018
mod: 6/10/2019
Overview: 
  Part of splitting the hangar into more understandable chunks.
  'arming' is where the player can select weapons, compare them, 
  set weapon groups.
*/

//hook for inputs
void() menu_armingListener_onClick={
  weaponSelectListener();
  hardpointListener();
  weaponGroupPanelListener();
  selectNextConfig();
  selectPrevConfig();
};

void() menu_armingListener_onDrag={
  weaponDragListener();
};

void() menu_armingListener_onHover={
  //toolTips
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_HARDPOINT_GRAPH, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '132 56 0';
    toolTip.description = "Click on [Hardpoints] to see the stats for the Weapon mounted in the hardpoint.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_WEAPON_GROUPS, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '200 48 0';
    toolTip.description = "[Groups] are collections of weapons that will fire at the same time when you select that group and press the 'Fire' button.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_ENERGY_GROUPS, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '156 48 0';
    toolTip.description = "This panel shows you how much <Energy> will be drained from your Reactor when you fire each Group.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_LIST_WEAPON, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '200 32 0';
    toolTip.description = "Click on a weapon to the >Right> to see its statistics in this window.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_HARDPOINT_WEAPON, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '200 40 0';
    toolTip.description = "Click on a HARDPOINT to the <Left< to see the stats for the weapon mounted there, in this window.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  toolTip.data_idx = FALSE;
};

void() menu_armingListener_onKeyUp={
  local entity hardpoint;
  local float weaponType;
  UI_ARMING_weaponclick = FALSE;
  UI_ARMING_hardpoint_click = FALSE;
  
  if( (INPUT_mouse_state == MOUSE_UP) && (INPUT_mouse_state_prev != MOUSE_DOWN) ){
    if( UI_ARMING_item_drag.data_idx > 0 ){
      hardpoint = UI_HANGAR_DATA_mech.w_slot;
      
      while( hardpoint ){
        if(menu_checkMouseInBounds(cursorpos, hardpoint.ui_org, gui_percentToPixelRawVec('28 28'), FALSE)){
          weaponType = UI_ARMING_item_drag.damageType;
          if( (UI_ARMING_item_drag.equipSize <= hardpoint.hardpointSize) ){
            if( (weaponType & hardpoint.hardpointType) ){
              data_get_client_item_( hardpoint, UI_ARMING_item_drag.data_idx );
              ui_date_load_item1(UI_ARMING_item_drag.data_idx);
              GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
              GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
              GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
              GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
              GROUP_ENE_5 = calc_energy_draw(CLIENT_MENU_nex_grp5);
            }
          }
          else{
            //TODO - play 'no' sound
            if( cvar("developer") ){
              cons_logAString("[WARN]", "Weapon invalid for hardpoint"); //INFO
            }
          }
        }
        hardpoint = hardpoint.w_slot;
      }
      
      UI_ARMING_item_drag.data_idx = 0;
      UI_ARMING_item_drag.icon = "";
    }
  }
};

void() weaponDragListener={
  if( INPUT_mouse_state == MOUSE_DRAG ){
    if( UI_ARMING_weaponclick == TRUE ){
      UI_ARMING_item_drag.damageType = 0;
      data_get_client_item_( UI_ARMING_item_drag, CLIENT_MENU_sel_list_wep);
    }
    if( UI_ARMING_hardpoint_click == TRUE ){
      if( UI_ARMING_hardpoint.data_idx != 0 ){
        data_get_client_item_( UI_ARMING_hardpoint, 0);
      }
      UI_ARMING_item_drag.damageType = 0;
      data_get_client_item_( UI_ARMING_item_drag, CLIENT_MENU_sel_wep);
    }
  }
};

//DEPRECATED for now but leaving for reference
/*void() assignToHardpointListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_CTR + gui_percentToPixelRawVec('-34 -14'), gui_percentToPixelRawVec('195 24'))){
    local float found;
    found = 0;
    if( CFG_INDEX > 0 ){
      if(CLIENT_MENU_sel_hrpnt > 0){
        if(CLIENT_MENU_sel_list_wep > 0){
          if((CLIENT_MENU_sel_hrpnt_types & data_WeaponType[CLIENT_MENU_sel_list_wep]) && (CLIENT_MENU_sel_hrpnt_size >= data_WeaponSize[CLIENT_MENU_sel_list_wep])){
            HARDPOINTS[CLIENT_MENU_sel_hrpnt] = CLIENT_MENU_sel_list_wep;
            CLIENT_MENU_sel_wep = CLIENT_MENU_sel_list_wep;
            GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
            GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
            GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
            GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
            GROUP_ENE_5 = calc_energy_draw(CLIENT_MENU_nex_grp5);
          }
        }
      }
    }
  }
};*/

void() weaponSelectListener={
  local float found;
  found = listListener(WEPNLIST_ORG, cursorpos, WEPNLIST_SIZE, gui_percentToPixelRawVec('96 13.92'), WEPNLIST_CNT, 0);
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_BAL, cursorpos, WEPNLIST_SIZE_BAL, gui_percentToPixelRawVec('90 14'), WEPNLIST_CNT_BAL, 0);
    found = WEPLIST_BAL_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_ENE, cursorpos, WEPNLIST_SIZE_ENE, gui_percentToPixelRawVec('90 14'), WEPNLIST_CNT_ENE, 0);
    found = WEPLIST_ENE_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_EXP, cursorpos, WEPNLIST_SIZE_EXP, gui_percentToPixelRawVec('90 14'), WEPNLIST_CNT_EXP, 0);
    found = WEPLIST_EXP_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_MSC, WEPNLIST_SIZE_MSC, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_MSC, cursorpos, WEPNLIST_SIZE_MSC, gui_percentToPixelRawVec('90 14'), WEPNLIST_CNT_MSC, 0);
    found = WEPLIST_MSC_ARR[found];
  }
  if(found > 0){
    CLIENT_MENU_sel_list_wep = found;
    ui_date_load_item1(CLIENT_MENU_sel_list_wep);
  }
};

void() hardpointListener={
  local float wepbit;
  local entity hardpoint;
  local float hardpointItr;
  local float weaponBitFlag;
  
  if( SELECT_MECH > FALSE){
    if( INPUT_mouse_state == MOUSE_DOWN ){
      hardpoint = UI_HANGAR_DATA_mech.w_slot;
      hardpointItr = 1;
      weaponBitFlag = 1;
      
      while( hardpoint ){
        if(menu_checkMouseInBounds(cursorpos, hardpoint.ui_org, gui_percentToPixelRawVec('28 28'), TRUE)){
          CLIENT_MENU_sel_wid = wepbit;
          CLIENT_MENU_sel_hrpnt_size = hardpoint.hardpointSize;
          CLIENT_MENU_sel_hrpnt_types = hardpoint.hardpointType;
          CLIENT_MENU_sel_hrpnt = hardpointItr;
          CLIENT_MENU_sel_wep = hardpoint.data_idx;
          UI_ARMING_hardpoint_click = TRUE;
          UI_ARMING_hardpoint = hardpoint;
          ui_date_load_item2(CLIENT_MENU_sel_wep); 
        }
        
        hardpointItr = hardpointItr + 1;
        weaponBitFlag = weaponBitFlag * 2;
        hardpoint = hardpoint.w_slot;
      }
    }
  }
};

void() weaponGroupPanelListener={
  local float found;
  found = 0;
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_A, WEPNGRP_SIZE_A, TRUE)){
    found = listListener(WEPNGRP_ORG_A, cursorpos, WEPNGRP_SIZE_A, gui_percentToPixelRawVec('18.56 20'), WEPNGRP_CNT_A, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp1 & found)){
      CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 - (CLIENT_MENU_nex_grp1 & found);
      
    }else{
      CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 | found;
    }
    GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_B, WEPNGRP_SIZE_B, TRUE)){
    found = listListener(WEPNGRP_ORG_B, cursorpos, WEPNGRP_SIZE_B, gui_percentToPixelRawVec('18.56 20'), WEPNGRP_CNT_B, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp2 & found)){
      CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 - (CLIENT_MENU_nex_grp2 & found);
    }else{
      CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 | found;
    }
    GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
  }  
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_C, WEPNGRP_SIZE_C, TRUE)){
    found = listListener(WEPNGRP_ORG_C, cursorpos, WEPNGRP_SIZE_C, gui_percentToPixelRawVec('18.56 20'), WEPNGRP_CNT_C, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp3 & found)){
      CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 - (CLIENT_MENU_nex_grp3 & found);
    }else{
      CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 | found;
    }
    GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_D, WEPNGRP_SIZE_D, TRUE)){
    found = listListener(WEPNGRP_ORG_D, cursorpos, WEPNGRP_SIZE_D, gui_percentToPixelRawVec('18.56 20'), WEPNGRP_CNT_D, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp4 & found)){
      CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 - (CLIENT_MENU_nex_grp4 & found);
    }else{
      CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 | found;
    }
    GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_E, WEPNGRP_SIZE_E, TRUE)){
    found = listListener(WEPNGRP_ORG_E, cursorpos, WEPNGRP_SIZE_E, gui_percentToPixelRawVec('18.56 20'), WEPNGRP_CNT_E, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp5 & found)){
      CLIENT_MENU_nex_grp5 = CLIENT_MENU_nex_grp5 - (CLIENT_MENU_nex_grp5 & found);
    }else{
      CLIENT_MENU_nex_grp5 = CLIENT_MENU_nex_grp5 | found;
    }
    GROUP_ENE_5 = calc_energy_draw(CLIENT_MENU_nex_grp5);
  }
};

void() selectNextConfig={
  if(menu_checkMouseInBounds(cursorpos, BTN_CFG_N, gui_percentToPixelRawVec('20 38'), TRUE )){
    CFG_INDEX_PREV = CFG_INDEX;
    CFG_INDEX = CFG_INDEX + 1;
    if( CFG_INDEX > 6 ){
      CFG_INDEX = 1;
    }
    if( !ui_mech_config_switch( MECH_DATA_ID, CFG_INDEX ) ){
      if( DATA_CONFIG_BUFFER_NAME != "" ){
        strunzone( DATA_CONFIG_BUFFER_NAME );
      }
      DATA_CONFIG_BUFFER_NAME = strzone(ftos(CFG_INDEX));
    }
  }
};

void() selectPrevConfig={
  if(menu_checkMouseInBounds(cursorpos, BTN_CFG_P, gui_percentToPixelRawVec('20 38'), TRUE )){
    CFG_INDEX_PREV = CFG_INDEX;
    CFG_INDEX = CFG_INDEX - 1;
    if( CFG_INDEX < 1 ){
      CFG_INDEX = 6;
    }
    if( !ui_mech_config_switch( MECH_DATA_ID, CFG_INDEX ) ){
      if( DATA_CONFIG_BUFFER_NAME != "" ){
        strunzone( DATA_CONFIG_BUFFER_NAME );
      }
      DATA_CONFIG_BUFFER_NAME = strzone(ftos(CFG_INDEX));
    }
  }
};

//main hook for the menu system
void() menu_arming_drawFrame={
  if(CLIENT_MENU_sel_mech <= 0){
    cleanHardPoints();
  }
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_ARMING, 1, 0);
  
  menu_arming_HardpointGraph(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_WeaponList(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_WeaponGroupPanel(topleftroot + gui_percentToPixelRawVec('0 276'));
  menu_arming_energydraw(gui_percentToPixelRawVec('160 276'));
  menu_arming_WeaponInfo(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_WeaponInHardpoint(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_DrawItemDragIcon();
  
  //menu_arming_AssignToHardpoint_btn(VIEW_CTR);
};

void(vector ofs) menu_arming_HardpointGraph={
  local vector nofs, panelOffset, hardpointCenter, panelImageSize;
  local entity hardpoint;
  local float hardpointItr;
  
  local vector mechSize, iconSize;
  local vector mechMins, iconMins;
  local vector mechIconOrg;
  local vector mechIconSize;
  local vector mechIconTopOffset;
  
  local vector hardpointCoord;
  
  local float allowed;
  
  nofs = ofs + gui_percentToPixelRawVec('10 8');
  panelOffset = nofs + gui_percentToPixelRawVec('4 4');
  panelImageSize = gui_percentToPixelRawVec('270 236');
  drawpic(panelOffset, UI_HANGAR_BOX, panelImageSize, '0.25 0.25 0.25', 1, 0);
  
  if( SELECT_MECH > FALSE ){
    mechSize_x = (UI_HANGAR_DATA_mech.mins_x * -1) + UI_HANGAR_DATA_mech.maxs_x;
    mechSize_y = UI_HANGAR_DATA_mech.maxs_y;
    mechSize_y = (mechSize_y * 0.75) + UI_HANGAR_DATA_mech.maxs_y;
    
    mechMins_x = UI_HANGAR_DATA_mech.mins_x;
    mechMins_y = (UI_HANGAR_DATA_mech.maxs_y * 0.75) * -1;
    
    //pieces
    iconSize = mechSize;
    iconSize_y = iconSize_y + (UI_HANGAR_DATA_mech.maxs_y * 0.25);
    iconMins = mechMins;
    iconMins_y = UI_HANGAR_DATA_mech.mins_y;
    
    mechIconSize_x = panelImageSize_x;
    mechIconSize_y = panelImageSize_y * 2;
    
    mechIconTopOffset_x = mechMins_x;
    mechIconTopOffset_y = UI_HANGAR_DATA_mech.maxs_y * 0.87;
    mechIconOrg = gui_mapCoordToImgCoord( iconMins, iconSize, mechIconTopOffset, panelOffset, mechIconSize );
    mechIconOrg_x = (panelOffset_x + (panelImageSize_x / 2)) - (gui_percentXRaw(360 / 2)  ); //'360' is not a typo, just a lazy screen adjustment.
    
    drawpic(mechIconOrg, MECH_DATA_ICON, gui_percentToPixelRawVec('350 375'), CLR_DEF_WHITE - '0.1 0.1 0.1' , 1, 0);
    drawpic(nofs, UI_DEF_BOX_256_BOX, gui_percentToPixelRawVec('278 244'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
    
    MECHPANEL_CTR = hardpointCenter;

    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){
      allowed = TRUE;
      hardpointCoord = gui_mapCoordToImgCoord( mechMins,  mechSize, hardpoint.compOffset * 0.75, panelOffset, panelImageSize );
      hardpoint.ui_org = hardpointCoord - gui_percentToPixelRawVec('17 17');
     
      if( INPUT_mouse_state == MOUSE_DRAG ){
        if( UI_ARMING_item_drag.data_idx > 0 ){      
          if( hardpoint.hardpointSize < UI_ARMING_item_drag.equipSize || !(UI_ARMING_item_drag.damageType & hardpoint.hardpointType) ){
            allowed = FALSE;
          }
        }
      }
     
      ui_renderHardPointGraphic( hardpoint.icon, hardpoint.ui_org, (CLIENT_MENU_sel_hrpnt == hardpointItr), allowed );

      if( !allowed ){
        drawpic( hardpoint.ui_org, HUD_RAD_PIP_BLD, gui_percentToPixelRawVec('28 28'), CLR_DEF_RED, 0.85, 0);
      }
      
      if( INPUT_mouse_state == MOUSE_DRAG ){
        if( UI_ARMING_item_drag.data_idx > 0 ){  
          ui_renderHardPointNumber( hardpointItr, hardpointCoord );
        }
      }
      hardpointItr = hardpointItr + 1;
      hardpoint = hardpoint.w_slot;
    }
  }
  
  local vector nbtn, pbtn, pctr, lctr;
  pctr_x = panelImageSize_x / 2;
  pctr_y = panelImageSize_y / 2;
  nbtn = pbtn = nofs;
  pbtn_y = pbtn_y + (pctr_y + pctr_y);
  nbtn_x = nbtn_x + panelImageSize_x - gui_percentXRaw(24);
  nbtn_y = nbtn_y + (pctr_y + pctr_y);
  
  drawpic( pbtn + gui_percentToPixelRawVec('7 -44') , UI_DEF_BOX_512, gui_percentToPixelRawVec('265 48'), CLR_DEF_UI_ARMING + '0.15 0.15 0.15', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  BTN_CFG_P = pbtn + gui_percentToPixelRawVec('8 -32');
  drawstring(pbtn + gui_percentToPixelRawVec('8 -44'), "PREV", '10 10 0', CLR_DEF_ARM_HALF, 1, 0);
  drawpic(BTN_CFG_P, UI_BTN_ARR_LEFT, gui_percentToPixelRawVec('24 32'), CLR_DEF_ARM_THREEQ, 1, 0);      
  
  BTN_CFG_N = nbtn + gui_percentToPixelRawVec('-2 -32');
  drawstring(nbtn + gui_percentToPixelRawVec('-4 -44'), "NEXT", '10 10 0', CLR_DEF_ARM_HALF, 1, 0);
  drawpic(BTN_CFG_N, UI_BTN_ARR_RIGHT, gui_percentToPixelRawVec('24 32'), CLR_DEF_ARM_THREEQ, 1, 0);
  
  lctr = nofs + pctr;
  lctr_y = lctr_y + pctr_y - gui_percentYRaw(42);
  
  local string cfg, warn;
  local float len;
  local vector colr;
  local vector warnOrg;
  
  //this is quite hilarious
  cfg = NAVNAMES[CFG_INDEX];
  warnOrg = lctr;
  colr = CLR_DEF_ARM_OK;
  warn = "[Click-and-hold Weapons to Modify]";
  len = stringwidth(warn, 0, '12 12 0');
  warnOrg_x = warnOrg_x - gui_percentXRaw( len / 2 );
  warnOrg_y = warnOrg_y - gui_percentYRaw( -16 );
  drawstring(warnOrg, warn, '12 12 0', colr , 1, 0);
  
  cfg = strcat("Loadout: ", cfg);
  len = stringwidth(cfg, 0, '18 16 0');
  lctr_x = lctr_x - gui_percentXRaw( len / 2 );
  drawstring(lctr, cfg, '18 16 0', colr, 1, 0);
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg = nofs;
  helpOrg_x = nofs_x + gui_percentXRaw(276) - gui_percentXRaw(12);
  ARMING_HELP_HARDPOINT_GRAPH = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_arming_WeaponList={
  local vector menuOffset;
  
  menuOffset = ofs;
  menuOffset_x = VIEW_CTR_x + gui_percentXRaw(150);
  menuOffset = menuOffset + gui_percentToPixelRawVec('12 8');
  drawpic(menuOffset, UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('148 439'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('2 6'), DMG_BAL, "==BALLISTIC==", CLR_DEF_ARM_HALF );
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('2 100'), DMG_ENE, "==ENERGY==", CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2' );
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('2 200'), DMG_EXP, "==MISSILE==", CLR_DEF_ARM_OK );
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('2 290'), DMG_MSC, "==UPGRADES==", CLR_HUD_PURPLE + '0.15 0.15 0.15' );
};

void(vector parentOffset, vector offsetAdjust, float weaponType, string listName, vector listNameColor) menu_arming_WeaponList_draw={
  local vector nofs, labelOrg;
  local float labelLen;
  local float lst_idx, act_idx;
  local float itemId;
  local float drawFontLocal;
  
  nofs = parentOffset;
  nofs = nofs + offsetAdjust;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
    labelLen = stringwidth( listName, 0, '12 12');
    labelLen = labelLen / 2;
    labelLen = (gui_percentXRaw(138) / 2) - gui_percentXRaw(labelLen);
    labelOrg = nofs + gui_percentToPixelRawVec('0 2');
    labelOrg_x = labelOrg_x + labelLen;
    drawstring(labelOrg , listName, '12 12 0', listNameColor, 1, 0);
  drawfont = drawfont_prev;
  
  act_idx = 0;
  lst_idx = 0;
 
  while(lst_idx <= UNLOCKED_ITEMS_TOTAL){
    local vector listItemOffset, listItemColor, listItemLabelOrg;
    local float listItemLabelLen;
    
    itemId = UNLOCKED_ITEMS[lst_idx];
    if( itemId != 0){
      data_get_client_item_( UI_ARMING_DATA_item_list, itemId );
      if( (UI_ARMING_DATA_item_list.damageType & weaponType) ){
        listItemOffset_x = nofs_x;
        listItemOffset_y = nofs_y + gui_percentYRaw( (act_idx + 1) * 14);
        listItemColor = CLR_DEF_TXT_NONSELECT;
        if( itemId == CLIENT_MENU_sel_list_wep){
          listItemColor = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, listItemOffset + gui_percentToPixelRawVec('0 -1.44'), UI_BOX_SELECT, gui_percentToPixelRawVec('140.8 12'), CLR_DEF_ARM_OK, 1, 0);
        }
        if(!(CLIENT_MENU_sel_hrpnt_types & weaponType) || (UI_ARMING_DATA_item_list.equipSize > CLIENT_MENU_sel_hrpnt_size)){
          listItemColor = CLR_DEF_TXT_CANTSELECT;
        }
        listItemLabelLen = stringwidth( UI_ARMING_DATA_item_list.w_name, 0, '12 10');
        listItemLabelLen = listItemLabelLen / 2;
        listItemLabelOrg = listItemOffset;
        listItemLabelOrg_x = listItemLabelOrg_x + gui_percentXRaw(70.4) - gui_percentXRaw( listItemLabelLen );
        
        drawFontLocal = drawfont;
        drawfont = FONT_NUM_ROBOT_REGULAR;
          drawstring(listItemLabelOrg, UI_ARMING_DATA_item_list.w_name, '12 10 0', listItemColor, 1, 0);
        drawfont = drawFontLocal;
        
        //can't pass arrays to functions :|
        if( (weaponType & DMG_BAL) ){
          WEPLIST_BAL_ARR[act_idx] = itemId;
        }
        else if( (weaponType & DMG_ENE) ){
          WEPLIST_ENE_ARR[act_idx] = itemId;
        }
        else if( (weaponType & DMG_EXP) ){
          WEPLIST_EXP_ARR[act_idx] = itemId;
        }
        else if( (weaponType & DMG_MSC) ){
          WEPLIST_MSC_ARR[act_idx] = itemId;
        }
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  //can't pass arrays to functions :| srsly :(
  act_idx = act_idx + 1;  //corrects display / input box error
  if( (weaponType & DMG_BAL) ){
    WEPNLIST_CNT_BAL = act_idx;
    WEPNLIST_ORG_BAL = nofs + gui_percentToPixelRawVec('0 10');
    WEPNLIST_SIZE_BAL_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_BAL_y = gui_percentYRaw(act_idx * 14);
  }
  else if( (weaponType & DMG_ENE) ){
    WEPNLIST_CNT_ENE = act_idx;
    WEPNLIST_ORG_ENE = nofs + gui_percentToPixelRawVec('0 12');
    WEPNLIST_SIZE_ENE_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_ENE_y = gui_percentYRaw(act_idx * 14);
  }
  else if( (weaponType & DMG_EXP) ){
    WEPNLIST_CNT_EXP = act_idx;
    WEPNLIST_ORG_EXP = nofs + gui_percentToPixelRawVec('0 12');
    WEPNLIST_SIZE_EXP_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_EXP_y = gui_percentYRaw(act_idx * 14);
  }
  else if( (weaponType & DMG_MSC) ){
    WEPNLIST_CNT_MSC = act_idx;
    WEPNLIST_ORG_MSC = nofs + gui_percentToPixelRawVec('0 12');
    WEPNLIST_SIZE_MSC_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_MSC_y = gui_percentYRaw(act_idx * 14);
  }  
};

void(vector ofs) menu_arming_WeaponGroupPanel={
  local vector nofs, col_a, col_b, col_c, col_d, col_e;
  local float lst_idx, bit;
  local entity hardpoint;
  local vector groupButtonSize;
  
  local float groupLabelLen;
  local vector groupLabelOrg;
  
  nofs = ofs + gui_percentToPixelRawVec('10 0');
  groupButtonSize = gui_percentToPixelRawVec('12 12');
  
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('150 198'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1,0);
  
  //Panel label
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    groupLabelLen = stringwidth(  "-Weapon Groups-", 0, '10 10 0');
    groupLabelLen = groupLabelLen / 2;
    groupLabelOrg = nofs;
    groupLabelOrg_x = groupLabelOrg_x + gui_percentXRaw(75) - gui_percentXRaw(groupLabelLen);
    drawstring(groupLabelOrg, "-Weapon Groups-", '10 10 0', CLR_DEF_RET_GETLOCK, 1, 0);
  drawfont = drawfont_prev;
  
  nofs = nofs + gui_percentToPixelRawVec('0 3');
  col_a = nofs + gui_percentToPixelRawVec('46 20');
  col_b = nofs + gui_percentToPixelRawVec('66 20');
  col_c = nofs + gui_percentToPixelRawVec('86 20');
  col_d = nofs + gui_percentToPixelRawVec('106 20');
  col_e = nofs + gui_percentToPixelRawVec('126 20');
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;  
    drawstring(col_a - gui_percentToPixelRawVec('-4 12'), "1", '10 10 0', '1 1 1', 1, 0);
    drawstring(col_b - gui_percentToPixelRawVec('-4 12'), "2", '10 10 0', '1 1 1', 1, 0);
    drawstring(col_c - gui_percentToPixelRawVec('-4 12'), "3", '10 10 0', '1 1 1', 1, 0);
    drawstring(col_d - gui_percentToPixelRawVec('-4 12'), "4", '10 10 0', '1 1 1', 1, 0);
    drawstring(col_e - gui_percentToPixelRawVec('-4 12'), "5", '10 10 0', '1 1 1', 1, 0);
  drawfont = drawfont_prev;
  
  lst_idx = 1;
  bit = 1;
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while( hardpoint ){
    local vector lofs;
    lofs_x = nofs_x + gui_percentXRaw(6);
    lofs_y = nofs_y + gui_percentYRaw(lst_idx * 20);
    
    if( CLIENT_MENU_sel_hrpnt == lst_idx){
      drawpic(lofs + gui_percentToPixelRawVec('-2 -8'), UI_DEF_BOX_256, gui_percentToPixelRawVec('143 20'), '0.85 0.85 0', 1,0);
    }
    
    drawstring(lofs +  gui_percentToPixelRawVec('0 -4'), strcat("{",ftos(lst_idx),"}"), '12 12 0', CLR_DEF_RET_HASLOCK, 1, 0);
    if( hardpoint.icon != "" ){
      drawpic(lofs + gui_percentToPixelRawVec('16 -8'), hardpoint.icon, gui_percentToPixelRawVec('20 20'), '1 1 1', 1,0);
    }
    gui_renderTintImage((CLIENT_MENU_nex_grp1 & bit),  lofs + gui_percentToPixelRawVec('40 -3'), UI_DEF_BOX_256, groupButtonSize, CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp2 & bit),  lofs + gui_percentToPixelRawVec('60 -3'), UI_DEF_BOX_256, groupButtonSize, CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp3 & bit),  lofs + gui_percentToPixelRawVec('80 -3'), UI_DEF_BOX_256, groupButtonSize, CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp4 & bit),  lofs + gui_percentToPixelRawVec('100 -3'), UI_DEF_BOX_256, groupButtonSize, CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp5 & bit),  lofs + gui_percentToPixelRawVec('120 -3'), UI_DEF_BOX_256, groupButtonSize, CLR_DEF_ARM_OK, 1, 0);
    bit = bit * 2;
    lst_idx = lst_idx + 1;
    hardpoint = hardpoint.w_slot;
  }
  
  WEPNGRP_CNT_A = lst_idx;
  WEPNGRP_CNT_B = lst_idx;
  WEPNGRP_CNT_C = lst_idx;
  WEPNGRP_CNT_D = lst_idx;
  WEPNGRP_CNT_E = lst_idx;
  
  WEPNGRP_ORG_A = col_a;
  WEPNGRP_ORG_B = col_b;
  WEPNGRP_ORG_C = col_c;
  WEPNGRP_ORG_D = col_d;
  WEPNGRP_ORG_E = col_e;
  
  WEPNGRP_SIZE_A_x = WEPNGRP_SIZE_B_x = WEPNGRP_SIZE_C_x = WEPNGRP_SIZE_D_x = WEPNGRP_SIZE_E_x = groupButtonSize_x;
  WEPNGRP_SIZE_A_y = WEPNGRP_SIZE_B_y = WEPNGRP_SIZE_C_y = WEPNGRP_SIZE_D_y = WEPNGRP_SIZE_E_y = gui_percentYRaw((lst_idx - 1) * 20);
  
  local vector helpOrg;
  helpOrg = nofs;
  helpOrg_x = nofs_x + gui_percentXRaw(150) - gui_percentXRaw(12);
  ARMING_HELP_WEAPON_GROUPS = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_arming_energydraw={
  local float enmax, g1, g2, g3, g4, g5;
  
  local float energyLabelLen;
  local vector energyLabelOrg;
  
  drawpic(ofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('126 197'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1,0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  energyLabelLen = stringwidth( "-Group Energy Cost-", 0, '10 10');
  energyLabelLen = energyLabelLen / 2;
  energyLabelOrg = ofs;
  energyLabelOrg_x = energyLabelOrg_x + gui_percentXRaw(63) - gui_percentXRaw(energyLabelLen);
  energyLabelOrg_y = energyLabelOrg_y + gui_percentYRaw(6);
  drawstring(energyLabelOrg, "-Group Energy Cost-", '10 10 0', CLR_DEF_ENE_FRT, 1, 0);
  
  enmax = UI_HANGAR_DATA_mech.energyMax;

  drawfont_prev = drawfont;
  drawstring(ofs + gui_percentToPixelRawVec('6 30'), "Group 1", '12 12 0', '1 1 1', 1, 0);
    g1 = (GROUP_ENE_1 / enmax) * 100;
    gui_renderMeter(g1, ofs + gui_percentToPixelRawVec('47 30'), gui_percentToPixelRawVec('32 11'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g1), 1, 0, AXIS_H, 0);
    drawstring(ofs + gui_percentToPixelRawVec('86 30'), sprintf("%0.2f", GROUP_ENE_1), '12 12', gui_getColorForArmor(100 - g1), 1, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('6 57'), "Group 2", '12 12 0', '1 1 1', 1, 0);
    g2 = (GROUP_ENE_2 / enmax) * 100;
    gui_renderMeter(g2, ofs + gui_percentToPixelRawVec('47 57'), gui_percentToPixelRawVec('32 11'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g2), 1, 0, AXIS_H, 0);
    drawstring(ofs + gui_percentToPixelRawVec('86 57'), sprintf("%0.2f", GROUP_ENE_2), '12 12', gui_getColorForArmor(100 - g2), 1, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('6 84'), "Group 3", '12 12 0', '1 1 1', 1, 0);
    g3 = (GROUP_ENE_3 / enmax) * 100;
    gui_renderMeter(g3, ofs + gui_percentToPixelRawVec('47 84'), gui_percentToPixelRawVec('32 11'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g3), 1, 0, AXIS_H, 0);
    drawstring(ofs + gui_percentToPixelRawVec('86 84'), sprintf("%0.2f", GROUP_ENE_3), '12 12', gui_getColorForArmor(100 - g3), 1, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('6 111'), "Group 4", '12 12 0', '1 1 1', 1, 0);
    g4 = (GROUP_ENE_4 / enmax) * 100;
    gui_renderMeter(g4, ofs + gui_percentToPixelRawVec('47 111'), gui_percentToPixelRawVec('32 11'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g4), 1, 0, AXIS_H, 0);
    drawstring(ofs + gui_percentToPixelRawVec('86 111'), sprintf("%0.2f", GROUP_ENE_4), '12 12', gui_getColorForArmor(100 - g4), 1, 0);
    
  drawstring(ofs + gui_percentToPixelRawVec('6 138'), "Group 5", '12 12 0', '1 1 1', 1, 0);
    g5 = (GROUP_ENE_5 / enmax) * 100;
    gui_renderMeter(g5, ofs + gui_percentToPixelRawVec('47 138'), gui_percentToPixelRawVec('32 11'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g5), 1, 0, AXIS_H, 0);
    drawstring(ofs + gui_percentToPixelRawVec('86 138'), sprintf("%0.2f", GROUP_ENE_5), '12 12', gui_getColorForArmor(100 - g5), 1, 0);
    
  drawfont = drawfont_prev;
    
  local vector helpOrg;
  helpOrg = ofs;
  helpOrg_x = ofs_x + gui_percentXRaw(126) - gui_percentXRaw(12);
  ARMING_HELP_ENERGY_GROUPS = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_arming_WeaponInfo={
  local vector nofs;

  nofs_x = ofs_x + VIEW_CTR_x - gui_percentXRaw(34);
  nofs_y = VIEW_CTR_y + gui_percentYRaw(12);
  
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 193'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  local string panelLabel;
  local float panelLabelLen;
  local vector labelOrg;
  panelLabel = "-Weapon from List-";
  panelLabelLen = stringwidth(panelLabel, 0, '10 10 0');
  labelOrg = nofs + gui_percentToPixelRawVec('0 6');
  labelOrg_x = nofs_x + gui_percentXRaw(97.5) - gui_percentXRaw( panelLabelLen / 2 );
  drawstring(labelOrg, panelLabel, '10 10 0', '1 1 1', 1, 0);
  
  local vector weaponNameOrg;
  local float weaponNameLen;
  if( ITEM1_DATA_ICON != ""){
    drawpic((nofs + gui_percentToPixelRawVec('6 6')), ITEM1_DATA_ICON, gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, 1, 0); 
  }
  weaponNameLen = stringwidth(ITEM1_DATA_NAME, 0, '14 14 0');
  weaponNameOrg = nofs + gui_percentToPixelRawVec('0 20');
  weaponNameOrg_x = (weaponNameOrg_x + gui_percentXRaw(108)) - gui_percentXRaw( weaponNameLen / 2 ); 
  drawstring(weaponNameOrg, ITEM1_DATA_NAME, '14 14 0', '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixelRawVec('8 42');
  
  //LABELS---------
  //damage
  drawstring(icol, "Total Damage:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);

  //en cost
  drawstring(icol + gui_percentToPixelRawVec('0 12'), "Energy Cost:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('0 26'), "Max Range:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('0 40'), "Clip size:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('0 54'),"Hardpoint Size:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('0 68'), "Tech Level:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //desc
  drawstring(icol + gui_percentToPixelRawVec('0 82'), "Info:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //VALUES-----------
  //damage
  gui_renderMeter(((ITEM1_DATA_DMG * ITEM1_DATA_CLIP) / 600)*100, icol + gui_percentToPixelRawVec('75 -2'), gui_percentToPixelRawVec('32 12'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
  drawstring(icol + gui_percentToPixelRawVec('112 -2'), sprintf("%0.2f", ITEM1_DATA_DMG * ITEM1_DATA_CLIP), '14 14', '1 1 1', 1, 0);
  
  //en cost
  gui_renderMeter((ITEM1_DATA_EN / 500)*100, icol + gui_percentToPixelRawVec('75 11'), gui_percentToPixelRawVec('32 12'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - (ITEM1_DATA_EN / 500)*100), 1, 0, AXIS_H, 0);
  drawstring(icol + gui_percentToPixelRawVec('112 11'), sprintf("%0.2f", ITEM1_DATA_EN), '14 14', '1 1 1', 1, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('112 25'), ftos(ITEM1_DATA_RANGE), '14 14', '1 1 1', 1, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('112 39'), ftos(ITEM1_DATA_CLIP), '14 14', '1 1 1', 1, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('112 53'), ftos(ITEM1_DATA_SIZE), '14 14', '1 1 1', 1, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('112 67'), ftos(ITEM1_DATA_TECH), '14 14', '1 1 1', 1, 0);
  
  //desc
  if( ITEM1_DATA_DESC != "" ){ 
    gui_wrapText(icol + gui_percentToPixelRawVec('0 81'), '187 130', ITEM1_DATA_DESC, '12 10 0', '1 1 1', 1);
  }
  
  local vector helpOrg;
  helpOrg = nofs;
  helpOrg_x = nofs_x + gui_percentXRaw(195) - gui_percentXRaw(12);
  ARMING_HELP_LIST_WEAPON = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

/* DEPRECATED for now
void(vector ofs) menu_arming_AssignToHardpoint_btn={
  local vector nofs, colr1, colr2, colr3;
  colr1 = CLR_DEF_ARM_OK;
  colr2 = CLR_DEF_ARM_THREEQ;
  colr3 = CLR_DEF_WHITE;
  if( CFG_INDEX == 0 ){
    colr1 = colr1 - '0.4 0.4 0.4';
    colr2 = colr2 - '0.4 0.4 0.4';
    colr3 = colr3 - '0.4 0.4 0.4';
  }
  nofs = ofs + gui_percentToPixelRawVec('-34 -14');
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 24'), colr1, 1, 0);
  drawpic(nofs + gui_percentToPixelRawVec('8 9'), HUD_TRG_PIP_B, gui_percentToPixelRawVec('16 8'), colr2, 1, 0);
  drawpic(nofs + gui_percentToPixelRawVec('172 9'), HUD_TRG_PIP_B, gui_percentToPixelRawVec('16 8'), colr2, 1, 0);
  drawstring(nofs+gui_percentToPixelRawVec('28 2'), "[ASSIGN TO HARDPOINT]", '7 8 0', colr3, 1, 0);
};*/

void(vector ofs) menu_arming_WeaponInHardpoint={
  local vector nofs;
  
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentXRaw(34);
  nofs_y = ofs_y + gui_percentYRaw(8);
  
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 193'), CLR_DEF_ARM_THREEQ, 1, 0);

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  local string panelLabel;
  local float panelLabelLen;
  local vector labelOrg;
  panelLabel = "-Weapon In Hardpoint-";
  panelLabelLen = stringwidth(panelLabel, 0, '10 10 0');
  labelOrg = nofs + gui_percentToPixelRawVec('0 6');
  labelOrg_x = nofs_x + gui_percentXRaw(97.5) - gui_percentXRaw( panelLabelLen / 2 );
  drawstring(labelOrg, panelLabel, '10 10 0', '1 1 1', 1, 0);
  
  local vector weaponNameOrg;
  local float weaponNameLen;
  if( ITEM2_DATA_ICON != ""){
    drawpic((nofs + gui_percentToPixelRawVec('6 6')), ITEM2_DATA_ICON, gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, 1, 0); 
  }
  weaponNameLen = stringwidth(ITEM2_DATA_NAME, 0, '14 14 0');
  weaponNameOrg = nofs + gui_percentToPixelRawVec('0 20');
  weaponNameOrg_x = (weaponNameOrg_x + gui_percentXRaw(108)) - gui_percentXRaw( weaponNameLen / 2 ); 
  drawstring(weaponNameOrg, ITEM2_DATA_NAME, '14 14 0', '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixelRawVec('8 42');
  
  //LABELS---------
  //damage
  drawstring(icol, "Total Damage:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);

  //en cost
  drawstring(icol + gui_percentToPixelRawVec('0 12'), "Energy Cost:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('0 26'), "Max Range:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('0 40'), "Clip size:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('0 54'),"Hardpoint Size:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('0 68'), "Tech Level:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //desc
  drawstring(icol + gui_percentToPixelRawVec('0 82'), "Info:", '10 8 0', CLR_DEF_GRAY_H, 1, 0);
  
  //VALUES-----------
  //damage
  gui_renderMeter(((ITEM2_DATA_DMG * ITEM2_DATA_CLIP) / 600)*100, icol + gui_percentToPixelRawVec('75 -2'), gui_percentToPixelRawVec('32 12'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
  drawstring(icol + gui_percentToPixelRawVec('112 -2'), sprintf("%0.2f", ITEM2_DATA_DMG * ITEM2_DATA_CLIP), '14 14', '1 1 1', 1, 0);
  
  //en cost
  gui_renderMeter((ITEM2_DATA_EN / 500)*100, icol + gui_percentToPixelRawVec('75 11'), gui_percentToPixelRawVec('32 12'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - (ITEM2_DATA_EN / 500)*100), 1, 0, AXIS_H, 0);
  drawstring(icol + gui_percentToPixelRawVec('112 11'), sprintf("%0.2f", ITEM2_DATA_EN), '14 14', '1 1 1', 1, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('112 25'), ftos(ITEM2_DATA_RANGE), '14 14', '1 1 1', 1, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('112 39'), ftos(ITEM2_DATA_CLIP), '14 14', '1 1 1', 1, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('112 53'), ftos(ITEM2_DATA_SIZE), '14 14', '1 1 1', 1, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('112 67'), ftos(ITEM2_DATA_TECH), '14 14', '1 1 1', 1, 0);
  
  //desc
  if( ITEM2_DATA_DESC != "" ){ 
    gui_wrapText(icol + gui_percentToPixelRawVec('0 81'), '187 130', ITEM2_DATA_DESC, '12 10 0', '1 1 1', 1);
  }
  
  local vector helpOrg;
  helpOrg = nofs;
  helpOrg_x = nofs_x + gui_percentXRaw(195) - gui_percentXRaw(12);
  ARMING_HELP_HARDPOINT_WEAPON = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void() menu_arming_DrawItemDragIcon={
  local vector iconOffset;
  if( INPUT_mouse_state == MOUSE_DRAG ){
    if( (UI_ARMING_item_drag.data_idx > 0) && (UI_ARMING_item_drag.icon != "") ){
      iconOffset_x = cursorpos_x - gui_percentXRaw(16);
      iconOffset_y = cursorpos_y - gui_percentYRaw(16);
      drawpic(iconOffset, UI_ARMING_item_drag.icon, gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, 1, 0); 
    }
  }
};

//UTILITY FUNCS
void() cleanHardPoints={
  local entity hardpoint;
  
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while( hardpoint ){
    hardpoint.data_idx = 0;
    hardpoint.icon = "";
    hardpoint = hardpoint.w_slot;
  }
};

string(float bit) getNameOfWepType={
  if((bit & DMG_BAL)){
    return "BALLISTIC";
  }
  else if((bit & DMG_ENE)){
    return "ENERGY";
  }
  else if((bit & DMG_EXP)){
    return "MISSILE";
  }
  else if((bit & DMG_MSC)){
    return "EQUIPMENT";
  }
  return "unknown"; 
};

float(float grp) calc_energy_draw={
  local float energySubTotal, weaponGroupBit;
  local entity hardpoint;
  
  weaponGroupBit = 1;
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  energySubTotal = 0;
  
  while( hardpoint ){
    if( (grp & weaponGroupBit) ){
      if( hardpoint.energyRate ){
        energySubTotal = energySubTotal + hardpoint.energyRate;
      }
    }
    weaponGroupBit = weaponGroupBit * 2;
    hardpoint = hardpoint.w_slot;
  }
  
  if( energySubTotal < 0){
    energySubTotal = 0;
  }

  return energySubTotal;
};