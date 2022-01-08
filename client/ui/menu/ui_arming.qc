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
  menu_navbBar_listener();
  weaponSelectListener();
  hardpointListener();
  weaponGroupPanelListener();
  selectNextConfig();
  selectPrevConfig();
};

void() menu_armingListener_onDrag={
  weaponDragListener();
};

/*
  LISTENER - HOVER - when a player's cursor is over a 2D area.
*/
void() menu_armingListener_onHover={
  local entity hardpoint;
  local float hardpointItr;
  local float weaponBitFlag;
  
  //ToolTip - HARDPOINT Graph
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_HARDPOINT_GRAPH, '12 12', FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '132 56 0';
    toolTip.description = "Hover on Hardpoints to see weapon info.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  //ToolTip - Weapon Groups
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_WEAPON_GROUPS, '12 12', FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '200 48 0';
    toolTip.description = "[Groups] are collections of weapons that will fire at the same time when you select that group and press the 'Fire' button.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  //ToolTip - Energy Group Cost
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_ENERGY_GROUPS, '12 12', FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '156 48 0';
    toolTip.description = "This panel shows you how much <Energy> will be drained from your Reactor when you fire each Group.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  //ToolTip - Weapon In List
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_LIST_WEAPON, '12 12', FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '200 32 0';
    toolTip.description = "Click on a weapon to the >Right> to see its statistics in this window.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  //ToolTip - Weapon In HARDPOINT
  if( menu_checkMouseInBounds(cursorpos, ARMING_HELP_HARDPOINT_WEAPON, '12 12', FALSE) ){
    toolTip.data_idx = MENU_ARMING_ACTIVE;
    toolTip.mins = '200 40 0';
    toolTip.description = "Click on a HARDPOINT to the <Left< to see the stats for the weapon mounted there, in this window.";
    toolTip.angles = '0.9 0.9 0.9';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  
  //Weapon rollover
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL, FALSE)){
    UI_ARMING_weapon_rollover = TRUE;
    UI_ARMING_weapon_rolloverID = listListener(WEPNLIST_ORG_BAL, cursorpos, WEPNLIST_SIZE_BAL, '90 14', WEPNLIST_CNT_BAL, 0);
    UI_ARMING_weapon_rolloverID = WEPLIST_BAL_ARR[UI_ARMING_weapon_rolloverID];
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE, FALSE)){
    UI_ARMING_weapon_rollover = TRUE;
    UI_ARMING_weapon_rolloverID = listListener(WEPNLIST_ORG_ENE, cursorpos, WEPNLIST_SIZE_ENE, '90 14', WEPNLIST_CNT_ENE, 0);
    UI_ARMING_weapon_rolloverID = WEPLIST_ENE_ARR[UI_ARMING_weapon_rolloverID];
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP, FALSE)){
    UI_ARMING_weapon_rollover = TRUE;
    UI_ARMING_weapon_rolloverID = listListener(WEPNLIST_ORG_EXP, cursorpos, WEPNLIST_SIZE_EXP, '90 14', WEPNLIST_CNT_EXP, 0);
    UI_ARMING_weapon_rolloverID = WEPLIST_EXP_ARR[UI_ARMING_weapon_rolloverID];
    return;
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_MSC, WEPNLIST_SIZE_MSC, FALSE)){
    UI_ARMING_weapon_rollover = TRUE;
    UI_ARMING_weapon_rolloverID = listListener(WEPNLIST_ORG_MSC, cursorpos, WEPNLIST_SIZE_MSC, '90 14', WEPNLIST_CNT_MSC, 0);
    UI_ARMING_weapon_rolloverID = WEPLIST_MSC_ARR[UI_ARMING_weapon_rolloverID];
    return;
  }
  
  //Hardpoint rollover
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  hardpointItr = 1;
  weaponBitFlag = 1;
  while( hardpoint ){
    if(menu_checkMouseInBounds(cursorpos, hardpoint.ui_org, '28 28', FALSE)){
      UI_ARMING_hardpoint_type_roll = hardpoint.hardpointSize;
      
      CLIENT_MENU_sel_hrpnt_size = hardpoint.hardpointSize;
      CLIENT_MENU_sel_hrpnt_types = hardpoint.hardpointType;
      CLIENT_MENU_sel_hrpnt = hardpointItr;
      CLIENT_MENU_sel_wep = hardpoint.data_idx;
      UI_ARMING_hardpoint_click = FALSE;
      UI_ARMING_hardpoint = hardpoint;
      ui_date_load_item2(CLIENT_MENU_sel_wep); 
      
      return;
    }
    hardpoint = hardpoint.w_slot;
    
    hardpointItr = hardpointItr + 1;
    weaponBitFlag = weaponBitFlag * 2;
  }
  
  //cleared at the end to make sure no data is cached - hovering is fairly stateless
  UI_ARMING_weapon_rollover = FALSE;
  toolTip.data_idx = FALSE;
};

/*
  LISTENER - KEYUP - dropping drag-item
*/
void() menu_armingListener_onKeyUp={
  local entity hardpoint;
  local float hardpointId;
  
  UI_ARMING_weaponclick = FALSE;
  UI_ARMING_hardpoint_click = FALSE;
  
  if( (INPUT_mouse_state == MOUSE_UP) && (INPUT_mouse_state_prev != MOUSE_DOWN) ){
    if( UI_ARMING_item_drag.data_idx > 0 ){
      hardpoint = UI_HANGAR_DATA_mech.w_slot;
      hardpointId = 1;
      while( hardpoint ){
        //run collision check with all hardpoints on the mech entity.
        if(menu_checkMouseInBounds(cursorpos, hardpoint.ui_org, '28 28', FALSE)){
          if( (UI_ARMING_item_drag.equipSize & hardpoint.hardpointSize) ){
              data_get_client_item_( hardpoint, UI_ARMING_item_drag.data_idx );
              ui_date_load_item1(UI_ARMING_item_drag.data_idx);
              
              //update weapon groups for launch-validation
              //DMG_MSC don't count as weapons for OR against groups, we don't want them to allow a player to bypass group-validation
              //where the hardpoint was previously grouped because of a valid weapon which is then swapped for a module.
              if( (UI_ARMING_item_drag.equipSize >= MSC1) ){
                if( (CLIENT_MENU_nex_grp1 & hardpointId) ){
                  CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 - (CLIENT_MENU_nex_grp1 & hardpointId);
                }
                if( (CLIENT_MENU_nex_grp2 & hardpointId) ){
                  CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 - (CLIENT_MENU_nex_grp2 & hardpointId);
                }
                if( (CLIENT_MENU_nex_grp3 & hardpointId) ){
                  CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 - (CLIENT_MENU_nex_grp3 & hardpointId);
                }
                if( (CLIENT_MENU_nex_grp4 & hardpointId) ){
                  CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 - (CLIENT_MENU_nex_grp4 & hardpointId);
                }
              }
              //update ENERGY GROUP cost meters
              GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
              GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
              GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
              GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
          }
          else{
            //TODO - play 'no' sound
            if( cvar("developer") ){
              cons_logAString("[WARN]", "Weapon invalid for hardpoint"); //INFO
            }
          }
        }
        hardpointId = bitshift(hardpointId, 1);
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
      data_get_client_item_( UI_ARMING_item_drag, CLIENT_MENU_sel_list_wep);
    }
    if( UI_ARMING_hardpoint_click == TRUE ){
      if( UI_ARMING_hardpoint.data_idx != 0 ){
        data_get_client_item_( UI_ARMING_hardpoint, 0);
      }
      data_get_client_item_( UI_ARMING_item_drag, CLIENT_MENU_sel_wep);
    }
  }
};

//DEPRECATED for now but leaving for reference
/*void() assignToHardpointListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_CTR + '-34 -14', '195 24')){
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
          }
        }
      }
    }
  }
};*/

void() weaponSelectListener={
  local float found;
  found = listListener(WEPNLIST_ORG, cursorpos, WEPNLIST_SIZE, '96 13.92', WEPNLIST_CNT, 0);
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_BAL, cursorpos, WEPNLIST_SIZE_BAL, '90 14', WEPNLIST_CNT_BAL, 0);
    found = WEPLIST_BAL_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_ENE, cursorpos, WEPNLIST_SIZE_ENE, '90 14', WEPNLIST_CNT_ENE, 0);
    found = WEPLIST_ENE_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_EXP, cursorpos, WEPNLIST_SIZE_EXP, '90 14', WEPNLIST_CNT_EXP, 0);
    found = WEPLIST_EXP_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_MSC, WEPNLIST_SIZE_MSC, TRUE)){
    UI_ARMING_weaponclick = TRUE;
    found = listListener(WEPNLIST_ORG_MSC, cursorpos, WEPNLIST_SIZE_MSC, '90 14', WEPNLIST_CNT_MSC, 0);
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
        if(menu_checkMouseInBounds(cursorpos, hardpoint.ui_org, '28 28', TRUE)){
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
    found = listListener(WEPNGRP_ORG_A, cursorpos, WEPNGRP_SIZE_A, '18.56 20', WEPNGRP_CNT_A, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp1 & found) ){
      CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 - (CLIENT_MENU_nex_grp1 & found);
    }else{
      CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 | found;
    }
    GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_B, WEPNGRP_SIZE_B, TRUE)){
    found = listListener(WEPNGRP_ORG_B, cursorpos, WEPNGRP_SIZE_B, '18.56 20', WEPNGRP_CNT_B, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp2 & found)){
      CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 - (CLIENT_MENU_nex_grp2 & found);
    }else{
      CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 | found;
    }
    GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
  }  
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_C, WEPNGRP_SIZE_C, TRUE)){
    found = listListener(WEPNGRP_ORG_C, cursorpos, WEPNGRP_SIZE_C, '18.56 20', WEPNGRP_CNT_C, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp3 & found)){
      CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 - (CLIENT_MENU_nex_grp3 & found);
    }else{
      CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 | found;
    }
    GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_D, WEPNGRP_SIZE_D, TRUE)){
    found = listListener(WEPNGRP_ORG_D, cursorpos, WEPNGRP_SIZE_D, '18.56 20', WEPNGRP_CNT_D, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp4 & found)){
      CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 - (CLIENT_MENU_nex_grp4 & found);
    }else{
      CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 | found;
    }
    GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
  }
  
  //LAUNCH_VALIDATION - make sure player is deploying with at least ONE assigned group.
  if( !CLIENT_MENU_nex_grp1 && !CLIENT_MENU_nex_grp2 && !CLIENT_MENU_nex_grp3 && !CLIENT_MENU_nex_grp4){
    LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_GRPS);
  }
  else{
    LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_GRPS;
  }
};

void() selectNextConfig={
  if(menu_checkMouseInBounds(cursorpos, BTN_CFG_N, '32 32', TRUE )){
    CFG_INDEX_PREV = CFG_INDEX;
    CFG_INDEX = CFG_INDEX + 1;
    if( CFG_INDEX > 6 ){
      CFG_INDEX = 1;
    }
    if( !ui_mech_config_switch( MECH_DATA_ID, CFG_INDEX ) ){
      cacheGlobalString(DATA_CONFIG_BUFFER_NAME, ftos(CFG_INDEX) )
    }
  }
};

void() selectPrevConfig={
  if(menu_checkMouseInBounds(cursorpos, BTN_CFG_P, '32 32', TRUE )){
    CFG_INDEX_PREV = CFG_INDEX;
    CFG_INDEX = CFG_INDEX - 1;
    if( CFG_INDEX < 1 ){
      CFG_INDEX = 6;
    }
    if( !ui_mech_config_switch( MECH_DATA_ID, CFG_INDEX ) ){
      cacheGlobalString(DATA_CONFIG_BUFFER_NAME, ftos(CFG_INDEX) )
    }
  }
};

//main hook for the menu system
void() menu_arming_drawFrame={
  local vector topleftroot;
  if(CLIENT_MENU_sel_mech <= 0){
    cleanHardPoints();
  }
  topleftroot = UI_ORG;
  drawfill(VIEW_ORG, VIEW_MAX, CLR_DEF_UI_ARMING * 0.25, 1, 0 );
  
  menu_navBar_drawFrame(UI_ORG);
  
  menu_arming_HardpointGraph(topleftroot + '0 32');
  menu_arming_WeaponList(topleftroot + '495 32');
  
  menu_arming_WeaponGroupPanel(topleftroot + '0 272');
  menu_arming_energydraw(topleftroot + '145 272');
  
  menu_arming_WeaponInHardpoint(topleftroot + '288 32');
  menu_arming_WeaponInfo(topleftroot + '288 242');
  menu_arming_DrawItemDragIcon();
  
  //menu_arming_AssignToHardpoint_btn(VIEW_CTR);
};

void(vector ofs) menu_arming_HardpointGraph={
  local vector nofs, panelOffset, panelImageSize;
  local entity hardpoint;
  local float hardpointItr;
  
  local vector mechIconOrg;
  local vector mechIconSize;
  
  local vector hardpointCoord;
  
  local float allowed;
  
  local vector nbtn, pbtn, pctr, lctr;
  local string cfg, warn;
  local float len;
  local vector colr;
  local vector warnOrg;
  local vector helpOrg;
  
  nofs = ofs;
  panelOffset = nofs + '4 4';
  panelImageSize = '278 236';
  
  gui_renderPatch9_1_32(nofs, panelImageSize, '0.25 0.25 0.25', 1, DRAWFLAG_NORMAL);
  
  if( SELECT_MECH > FALSE ){
    
    local vector imgSize;
    imgSize = draw_getimagesize(MECH_DATA_ICON);
    
    local float w;  
    w = 236 * imgSize_x / imgSize_y;
    
    mechIconSize = Vector2( w * 1.5, 200);
    
    mechIconOrg = Vector2(nofs_x + (panelImageSize_x/2) - (mechIconSize_x*0.5), nofs_y);
    
    drawsubpic( mechIconOrg, mechIconSize, MECH_DATA_ICON, '0 0', Vector2(1, 0.45), CLR_DEF_ARM_OK * 2, 0.5, DRAWFLAG_NORMAL);
    
    gui_renderBorder9_1_32(nofs, '278 244', CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
    
    MECHPANEL_CTR = Vector2(nofs_x + (panelImageSize_x * 0.5), nofs_y + (panelImageSize_y * 0.35));
    
    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){
      allowed = TRUE;
      hardpoint.ui_org = MECHPANEL_CTR + hardpoint.uiOffset - '17 17';
     
      if( INPUT_mouse_state == MOUSE_DRAG ){
        if( UI_ARMING_item_drag.data_idx > 0 ){      
          if( !(hardpoint.hardpointSize & UI_ARMING_item_drag.equipSize)){
            allowed = FALSE;
          }
        }
      }
     
      ui_renderHardPointGraphic( hardpoint.icon, hardpoint.ui_org, (CLIENT_MENU_sel_hrpnt == hardpointItr), allowed );
      
      if( !allowed ){
        drawpic( hardpoint.ui_org, HUD_RAD_PIP_BLD, '28 28', CLR_DEF_RED, 0.85, 0);
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
  
  pctr = panelImageSize * 0.5;
  
  nbtn = pbtn = nofs;
  pbtn_y = pbtn_y + panelImageSize_y;
  
  nbtn_x = nbtn_x + panelImageSize_x - 24;
  nbtn_y = nbtn_y + panelImageSize_y;
  
  gui_renderPatch9_1_32(nofs + Vector2(0, pbtn_y - 78), '280 57', CLR_DEF_UI_ARMING + '0.15 0.15 0.15', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  BTN_CFG_P = pbtn + '4 -44';
  drawpic(BTN_CFG_P, UI_BTN_ARR_LEFT, '32 32', CLR_DEF_ARM_THREEQ, 1, 0);
  drawstring(pbtn + '10 -12', "PREV", '10 10', CLR_DEF_ARM_HALF, 1, 0);
  
  BTN_CFG_N = nbtn + '-2 -44';
  drawpic(BTN_CFG_N, UI_BTN_ARR_RIGHT, '32 32', CLR_DEF_ARM_THREEQ, 1, 0);
  drawstring(nbtn + '-2 -12', "NEXT", '10 10', CLR_DEF_ARM_HALF, 1, 0);
  
  lctr = nofs + pctr;
  lctr_y = lctr_y + pctr_y - 42;
  
  //this is quite hilarious
  cfg = NAVNAMES[CFG_INDEX];
  warnOrg = lctr;
  colr = CLR_DEF_ARM_OK;
  warn = "[Drag-and-Drop Weapons to Modify]";
  len = stringwidth(warn, 0, '12 12 0');
  warnOrg_x = warnOrg_x - ( len / 2 );
  warnOrg_y = warnOrg_y -  -16 ;
  drawstring(warnOrg, warn, '12 12 0', colr , 1, 0);
  
  cfg = strcat("Loadout: ", cfg);
  len = stringwidth(cfg, 0, '18 16 0');
  lctr_x = lctr_x - ( len / 2 );
  drawstring(lctr, cfg, '18 16 0', colr, 1, 0);
  
  drawfont = drawfont_prev;
  
  helpOrg = nofs;
  helpOrg_x = nofs_x + 276 - 12;
  ARMING_HELP_HARDPOINT_GRAPH = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_arming_WeaponList={
  local vector menuOffset;
  
  menuOffset = ofs;
  
  //drawpic(menuOffset, UI_DEF_BOX_256_TALL, '148 439', CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
  
  menu_arming_WeaponList_draw(menuOffset, '2 0', DMG_BAL, "BALLISTIC", CLR_DEF_ARM_HALF );
  menu_arming_WeaponList_draw(menuOffset, '2 113', DMG_ENE, "ENERGY", CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2' );
  menu_arming_WeaponList_draw(menuOffset, '2 225', DMG_EXP, "MISSILE", CLR_DEF_ARM_OK );
  menu_arming_WeaponList_draw(menuOffset, '2 337', DMG_MSC, "UPGRADES", CLR_HUD_PURPLE + '0.15 0.15 0.15' );
};

void(vector parentOffset, vector offsetAdjust, float weaponType, string listName, vector listNameColor) menu_arming_WeaponList_draw={
  local vector nofs, labelOrg;
  local float lst_idx, act_idx;
  local float itemId;
  local float drawFontLocal;
  
  local vector listItemOffset, listItemColor, listItemLabelOrg;
  local float listItemLabelLen;
    
  nofs = parentOffset;
  nofs = nofs + offsetAdjust;
  
  gui_renderPatch9_1_32(nofs, '130 112', CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    labelOrg = nofs + '8 2';
    drawstring(labelOrg , listName, '12 12 0', listNameColor, 1, 0);
  drawfont = drawfont_prev;
  
  act_idx = 0;
  lst_idx = 0;
 
  while(lst_idx <= UNLOCKED_ITEMS_TOTAL){
    
    itemId = UNLOCKED_ITEMS[lst_idx];
    if( itemId != 0){
      data_get_client_item_( UI_ARMING_DATA_item_list, itemId );
      if( (UI_ARMING_DATA_item_list.damageType & weaponType) ){
        listItemOffset = Vector2(nofs_x, nofs_y + (act_idx + 1) * 14);
        
        listItemColor = CLR_DEF_TXT_NONSELECT;
        if( itemId == CLIENT_MENU_sel_list_wep){
          listItemColor = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, listItemOffset + '0 -1.44', UI_BOX_SELECT, '140.8 12', CLR_DEF_ARM_OK, 1, 0);
        }
        else{
          if( UI_ARMING_weapon_rollover && UI_ARMING_weapon_rolloverID == itemId){
            gui_renderTintImage(TRUE, listItemOffset + '0 -1.44', UI_BOX_SELECT, '140.8 12', CLR_DEF_IIF_FRIEND_BLD * 1.15, 1, 0);
          }
        }
        
        listItemLabelLen = stringwidth( UI_ARMING_DATA_item_list.w_name, 0, '12 12');
        listItemLabelLen = listItemLabelLen / 2;
        listItemLabelOrg = listItemOffset;
        listItemLabelOrg_x = listItemLabelOrg_x + 70.4 -  listItemLabelLen ;
        
        drawFontLocal = drawfont;
        drawfont = FONT_NUM_ROBOT_REGULAR;
        
        if( UI_ARMING_hardpoint_type_roll != 0 && (UI_ARMING_hardpoint_type_roll & UI_ARMING_DATA_item_list.equipSize)){
          drawstring(listItemLabelOrg + '-12 0', "<-", '14 14 0', CLR_DEF_ARM_OK, 1, 0);
          drawstring(listItemLabelOrg, UI_ARMING_DATA_item_list.w_name, '12 12 0', listItemColor, 1, 0);
        }
        else{
          drawstring(listItemLabelOrg, UI_ARMING_DATA_item_list.w_name, '12 12 0', CLR_DEF_TXT_CANTSELECT * 0.85, 1, 0);
        }
          
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
    WEPNLIST_ORG_BAL = nofs + '0 10';
    WEPNLIST_SIZE_BAL_x = 138;
    WEPNLIST_SIZE_BAL_y = act_idx * 14;
  }
  else if( (weaponType & DMG_ENE) ){
    WEPNLIST_CNT_ENE = act_idx;
    WEPNLIST_ORG_ENE = nofs + '0 12';
    WEPNLIST_SIZE_ENE_x = 138;
    WEPNLIST_SIZE_ENE_y = act_idx * 14;
  }
  else if( (weaponType & DMG_EXP) ){
    WEPNLIST_CNT_EXP = act_idx;
    WEPNLIST_ORG_EXP = nofs + '0 12';
    WEPNLIST_SIZE_EXP_x = 138;
    WEPNLIST_SIZE_EXP_y = act_idx * 14;
  }
  else if( (weaponType & DMG_MSC) ){
    WEPNLIST_CNT_MSC = act_idx;
    WEPNLIST_ORG_MSC = nofs + '0 12';
    WEPNLIST_SIZE_MSC_x = 138;
    WEPNLIST_SIZE_MSC_y = act_idx * 14;
  }  
};

void(vector ofs) menu_arming_WeaponGroupPanel={
  local vector nofs, col_a, col_b, col_c, col_d;
  local float lst_idx, bit;
  local entity hardpoint;
  local vector groupButtonSize;
  
  local vector groupLabelOrg;
  
  local vector lofs;
    
  local vector helpOrg;
  
  local vector colorSel, colorCold;
  
  colorSel = CLR_DEF_ARM_OK * 2;
  colorCold = CLR_DEF_TXT_CANTSELECT * 2;
  
  nofs = ofs;
  groupButtonSize = '12 12';
  
  gui_renderPatch9_1_32(nofs, '130 210', CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  //Panel label
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    groupLabelOrg = Vector2(nofs_x + 32, nofs_y + 2);
    drawstring(groupLabelOrg, "Weapon Groups", '12 12 0', CLR_DEF_RET_GETLOCK * 1.15, 1, 0);
  drawfont = drawfont_prev;
  
  nofs = nofs + '0 10';
  col_a = nofs + '46 2';
  col_b = nofs + '66 2';
  col_c = nofs + '86 2';
  col_d = nofs + '106 2';
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
    drawstring(col_a + '4 1', "1", '12 12 0', '1 1 1', 1, 0);
    drawstring(col_b + '4 1', "2", '12 12 0', '1 1 1', 1, 0);
    drawstring(col_c + '4 1', "3", '12 12 0', '1 1 1', 1, 0);
    drawstring(col_d + '4 1', "4", '12 12 0', '1 1 1', 1, 0);
  drawfont = drawfont_prev;
  
  lst_idx = 1;
  bit = 1;
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while( hardpoint ){
    lofs_x = nofs_x + 6;
    lofs_y = nofs_y + (lst_idx * 20);
    
    if( CLIENT_MENU_sel_hrpnt == lst_idx){
      drawfill( lofs + '-2 -8', '130 20', '0.85 0.85 0', 0.67, 0 );
    }
    
    drawstring(lofs +  '0 -4', strcat(ftos(lst_idx),"}"), '12 12 0', CLR_DEF_RET_HASLOCK, 1, 0);
    if( hardpoint.icon != "" ){
      drawpic(lofs + '16 -8', hardpoint.icon, '20 20', '1 1 1', 1,0);
    }
    
    if( hardpoint.damageType != DMG_MSC && hardpoint.data_idx > 0){
      if( (CLIENT_MENU_nex_grp1 & bit) ){
        drawpic( lofs + '40 -3', HUD_RAD_PIP_BLD, groupButtonSize, colorSel, 1.5, 0);
      }
      else{
        drawpic( lofs + '40 -3', UI_DEF_BOX_64, groupButtonSize, colorCold, 1, 0);
      }
      
      if( (CLIENT_MENU_nex_grp2 & bit) ){
        drawpic( lofs + '60 -3', HUD_RAD_PIP_BLD, groupButtonSize, colorSel, 1.5, 0);
      }
      else{
        drawpic( lofs + '60 -3', UI_DEF_BOX_64, groupButtonSize, colorCold, 1, 0);
      }
    
      if( (CLIENT_MENU_nex_grp3 & bit) ){
        drawpic( lofs + '80 -3', HUD_RAD_PIP_BLD, groupButtonSize, colorSel, 1.5, 0);
      }
      else{
        drawpic( lofs + '80 -3', UI_DEF_BOX_64, groupButtonSize, colorCold, 1, 0);
      }
    
      if( (CLIENT_MENU_nex_grp4 & bit) ){
        drawpic(lofs + '100 -3', HUD_RAD_PIP_BLD, groupButtonSize, colorSel, 1.5, 0);
      }
      else{
        drawpic( lofs + '100 -3', UI_DEF_BOX_64, groupButtonSize, colorCold, 1, 0);
      }
    }
    else{
      drawstring( lofs + '40 -3', "N/A", '10 10', CLR_DEF_TXT_CANTSELECT, 1, 0);
    }
    
    bit = bit * 2;
    lst_idx = lst_idx + 1;
    hardpoint = hardpoint.w_slot;
  }
  
  WEPNGRP_CNT_A = lst_idx;
  WEPNGRP_CNT_B = lst_idx;
  WEPNGRP_CNT_C = lst_idx;
  WEPNGRP_CNT_D = lst_idx;
  
  WEPNGRP_ORG_A = col_a + '0 12';
  WEPNGRP_ORG_B = col_b + '0 12';
  WEPNGRP_ORG_C = col_c + '0 12';
  WEPNGRP_ORG_D = col_d + '0 12';
  
  WEPNGRP_SIZE_A_x = WEPNGRP_SIZE_B_x = WEPNGRP_SIZE_C_x = WEPNGRP_SIZE_D_x = groupButtonSize_x;
  WEPNGRP_SIZE_A_y = WEPNGRP_SIZE_B_y = WEPNGRP_SIZE_C_y = WEPNGRP_SIZE_D_y = (lst_idx - 1) * 20;
  
  if( time < UI_ARMING_GROUP_WARN_TIMER ) {
    drawfill( nofs, '150 198', '1 0 0', 0.75, 0);
  }
  
  helpOrg = Vector2(nofs_x + 130 - 6, nofs_y);
  ARMING_HELP_WEAPON_GROUPS = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_arming_energydraw={
  local float enmax, g1, g2, g3, g4;
  
  local float energyLabelLen;
  local vector energyLabelOrg;
  
  local vector helpOrg;
  
  gui_renderPatch9_1_32(ofs, '130 210', CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  energyLabelLen = stringwidth( "-Group Energy Cost-", 0, '10 10');
  energyLabelLen = energyLabelLen / 2;
  energyLabelOrg = ofs;
  energyLabelOrg_x = energyLabelOrg_x + 63 - energyLabelLen;
  energyLabelOrg_y = energyLabelOrg_y + 6;
  drawstring(energyLabelOrg, "-Group Energy Cost-", '10 10 0', CLR_DEF_ENE_FRT, 1, 0);
  
  enmax = UI_HANGAR_DATA_mech.energyMax;

  drawfont_prev = drawfont;
  drawstring(ofs + '6 30', "Group 1", '12 12 0', '1 1 1', 1, 0);
    g1 = (GROUP_ENE_1 / enmax) * 100;
    gui_renderMeter(g1, ofs + '47 30', '32 11', CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g1), 1, 0, AXIS_H, 0);
    drawstring(ofs + '86 30', sprintf("%0.2f", GROUP_ENE_1), '12 12', gui_getColorForArmor(100 - g1), 1, 0);
  
  drawstring(ofs + '6 57', "Group 2", '12 12 0', '1 1 1', 1, 0);
    g2 = (GROUP_ENE_2 / enmax) * 100;
    gui_renderMeter(g2, ofs + '47 57', '32 11', CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g2), 1, 0, AXIS_H, 0);
    drawstring(ofs + '86 57', sprintf("%0.2f", GROUP_ENE_2), '12 12', gui_getColorForArmor(100 - g2), 1, 0);
  
  drawstring(ofs + '6 84', "Group 3", '12 12 0', '1 1 1', 1, 0);
    g3 = (GROUP_ENE_3 / enmax) * 100;
    gui_renderMeter(g3, ofs + '47 84', '32 11', CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g3), 1, 0, AXIS_H, 0);
    drawstring(ofs + '86 84', sprintf("%0.2f", GROUP_ENE_3), '12 12', gui_getColorForArmor(100 - g3), 1, 0);
  
  drawstring(ofs + '6 111', "Group 4", '12 12 0', '1 1 1', 1, 0);
    g4 = (GROUP_ENE_4 / enmax) * 100;
    gui_renderMeter(g4, ofs + '47 111', '32 11', CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g4), 1, 0, AXIS_H, 0);
    drawstring(ofs + '86 111', sprintf("%0.2f", GROUP_ENE_4), '12 12', gui_getColorForArmor(100 - g4), 1, 0);
    
  drawfont = drawfont_prev;
    
  helpOrg = ofs;
  helpOrg_x = ofs_x + 126 - 12;
  ARMING_HELP_ENERGY_GROUPS = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_arming_WeaponInfo={
  local vector nofs;
  local string panelLabel;
  local float panelLabelLen;
  local vector labelOrg;
  local vector weaponNameOrg;
  local float weaponNameLen;
  local vector icol;
  local vector smallFont;
  local vector helpOrg;
  
  nofs = ofs;
  
  gui_renderPatch9_1_32(nofs, '195 220', CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  panelLabel = "LIST";
  panelLabelLen = stringwidth(panelLabel, 0, '12 12 0');
  labelOrg = Vector2(nofs_x + 97.5 - ( panelLabelLen / 2 ), nofs_y + 6);
  drawstring(labelOrg, panelLabel, '12 12 0', '1 1 1', 1, 0);
  
  if( ITEM1_DATA_ICON != ""){
    drawpic((nofs + '6 6'), ITEM1_DATA_ICON, '32 32', CLR_DEF_WHITE, 1, 0); 
  }
  weaponNameLen = stringwidth(ITEM1_DATA_NAME, 0, '14 14 0');
  weaponNameOrg = nofs + '0 20';
  weaponNameOrg_x = (weaponNameOrg_x + 108) - ( weaponNameLen / 2 ); 
  
  local vector clr;
  clr = colorForWepType(ITEM1_DATA_TYPE);
  drawstring(weaponNameOrg, ITEM1_DATA_NAME, '14 14 0', clr, 1, 0);
  
  drawfont = drawfont_prev;
  
  //type
  icol = nofs + '8 42';
  
  smallFont = '10 10';
  
  if( ITEM1_DATA_DMG > -1 ){
    //damage
    drawstring(icol, "Total Damage:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    gui_renderMeter(((ITEM1_DATA_DMG * ITEM1_DATA_CLIP) / 600)*100, icol + '75 -2', '32 12', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(icol + '112 -2', sprintf("%0.2f", ITEM1_DATA_DMG * ITEM1_DATA_CLIP), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM1_DATA_EN > -1 ){
    //en cost
    drawstring(icol, "Energy Cost:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    if( ITEM1_DATA_EN > 0 ){
      gui_renderMeter((ITEM1_DATA_EN / 500)*100, icol + '75 0', '32 12', CLR_DEF_ARM_DED, gui_getColorForArmor(100 - (ITEM1_DATA_EN / 500)*100), 1, 0, AXIS_H, 0);
      drawstring(icol + '112 0', sprintf("%0.2f", ITEM1_DATA_EN), '14 14', '1 1 1', 1, 0);
    }
    else{
      drawstring(icol + '112 0', "NONE", '14 14', CLR_DEF_ARM_OK, 1, 0);
    }
    icol = icol + '0 12';
  }
  
  if(ITEM1_DATA_RANGE > -1 ){
    //range
    drawstring(icol, "Max Range:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    drawstring(icol + '112 0', ftos(ITEM1_DATA_RANGE), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM1_DATA_CLIP > -1 ){
    //clip
    drawstring(icol, "Clip size:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    drawstring(icol + '112 0', ftos(ITEM1_DATA_CLIP), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM1_DATA_SIZE > -1 ){
    drawstring(icol,"Hardpoint Size:",smallFont, CLR_DEF_GRAY_H, 1, 0);
    ui_renderHardpoint_class_pair( icol + '112 0', '14 14', ITEM1_DATA_SIZE, '1 1 1' );
    icol = icol + '0 12';
  }

  if(ITEM1_DATA_TECH > -1 ){
    //tech
    drawstring(icol, "Tech Level:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    drawstring(icol + '112 0', ftos(ITEM1_DATA_TECH), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM1_DATA_DESC != "" ){
    //desc
    drawstring(icol, "Info:", smallFont, CLR_DEF_GRAY_H, 1, 0); 
    gui_wrapText(icol, '187 130', ITEM1_DATA_DESC, '12 12 0', '1 1 1', 1);
  }
  
  helpOrg = nofs;
  helpOrg_x = nofs_x + 195 - 12;
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
  nofs = ofs + '-34 -14';
  drawpic(nofs, UI_DEF_BOX_256, '195 24', colr1, 1, 0);
  drawpic(nofs + '8 9', HUD_TRG_PIP_B, '16 8', colr2, 1, 0);
  drawpic(nofs + '172 9', HUD_TRG_PIP_B, '16 8', colr2, 1, 0);
  drawstring(nofs+'28 2', "[ASSIGN TO HARDPOINT]", '7 8 0', colr3, 1, 0);
};*/

void(vector ofs) menu_arming_WeaponInHardpoint={
  local vector nofs;
  local string panelLabel;
  local float panelLabelLen;
  local vector labelOrg;
  local vector weaponNameOrg;
  local float weaponNameLen;
  local vector icol;
  local vector smallFont;
  local vector helpOrg;
  
  nofs = ofs;
  
  gui_renderPatch9_1_32(nofs, '195 220', CLR_DEF_ARM_THREEQ, 1, DRAWFLAG_NORMAL);

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  panelLabel = "HARDPOINT";
  panelLabelLen = stringwidth(panelLabel, 0, '12 12 0');
  labelOrg = Vector2(nofs_x + 97.5 - ( panelLabelLen / 2 ), nofs_y + 6);
  drawstring(labelOrg, panelLabel, '12 12 0', '1 1 1', 1, 0);
  
  if( ITEM2_DATA_ICON != ""){
    drawpic(nofs + '6 6', ITEM2_DATA_ICON, '32 32', CLR_DEF_WHITE, 1, 0); 
  }
  weaponNameLen = stringwidth(ITEM2_DATA_NAME, 0, '14 14 0');
  weaponNameOrg = nofs + '0 20';
  weaponNameOrg_x = (weaponNameOrg_x + 108) - ( weaponNameLen / 2 ); 
  
  local vector clr;
  clr = colorForWepType(ITEM2_DATA_TYPE);
  drawstring(weaponNameOrg, ITEM2_DATA_NAME, '14 14 0', clr, 1, 0);
  
  drawfont = drawfont_prev;
  
  //type
  icol = nofs + '8 42';
  smallFont = '10 10';
  
  if( ITEM2_DATA_DMG > -1 ){
    //damage
    drawstring(icol, "Total Damage:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    gui_renderMeter(((ITEM2_DATA_DMG * ITEM1_DATA_CLIP) / 600)*100, icol + '75 -2', '32 12', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(icol + '112 -2', sprintf("%0.2f", ITEM2_DATA_DMG * ITEM2_DATA_CLIP), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM2_DATA_EN > -1 ){
    //en cost
    drawstring(icol, "Energy Cost:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    if( ITEM1_DATA_EN > 0 ){
      gui_renderMeter((ITEM2_DATA_EN / 500)*100, icol + '75 0', '32 12', CLR_DEF_ARM_DED, gui_getColorForArmor(100 - (ITEM2_DATA_EN / 500)*100), 1, 0, AXIS_H, 0);
      drawstring(icol + '112 0', sprintf("%0.2f", ITEM2_DATA_EN), '14 14', '1 1 1', 1, 0);
    }
    else{
      drawstring(icol + '112 0', "NONE", '14 14', CLR_DEF_ARM_OK, 1, 0);
    }
    icol = icol + '0 12';
  }
  
  if(ITEM2_DATA_RANGE > -1 ){
    //range
    drawstring(icol, "Max Range:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    drawstring(icol + '112 0', ftos(ITEM2_DATA_RANGE), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM2_DATA_CLIP > -1 ){
    //clip
    drawstring(icol, "Clip size:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    drawstring(icol + '112 0', ftos(ITEM2_DATA_CLIP), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM2_DATA_SIZE > -1 ){
    drawstring(icol,"Hardpoint Size:",smallFont, CLR_DEF_GRAY_H, 1, 0);
    ui_renderHardpoint_class_pair( icol + '112 0', '14 14', ITEM2_DATA_SIZE, '1 1 1' );
    icol = icol + '0 12';
  }

  if(ITEM2_DATA_TECH > -1 ){
    //tech
    drawstring(icol, "Tech Level:", smallFont, CLR_DEF_GRAY_H, 1, 0);
    drawstring(icol + '112 0', ftos(ITEM2_DATA_TECH), '14 14', '1 1 1', 1, 0);
    icol = icol + '0 12';
  }
  
  if(ITEM2_DATA_DESC != "" ){
    //desc
    drawstring(icol, "Info:", smallFont, CLR_DEF_GRAY_H, 1, 0); 
    gui_wrapText(icol, '187 130', ITEM2_DATA_DESC, '12 12 0', '1 1 1', 1);
  }

  helpOrg = nofs;
  helpOrg_x = nofs_x + 195 - 12;
  ARMING_HELP_HARDPOINT_WEAPON = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void() menu_arming_DrawItemDragIcon={
  local vector iconOffset;
  if( INPUT_mouse_state == MOUSE_DRAG ){
    if( (UI_ARMING_item_drag.data_idx > 0) && (UI_ARMING_item_drag.icon != "") ){
      iconOffset_x = cursorpos_x - 16;
      iconOffset_y = cursorpos_y - 16;
      drawpic(iconOffset, UI_ARMING_item_drag.icon, '32 32', CLR_DEF_WHITE, 1, 0); 
    }
  }
};

//UTILITY FUNCS
vector(float bit) colorForWepType={
  if((bit & DMG_BAL)){
    return CLR_DEF_ARM_HALF;
  }
  else if((bit & DMG_ENE)){
    return CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2';
  }
  else if((bit & DMG_EXP)){
    return CLR_DEF_ARM_OK;
  }
  else if((bit & DMG_MSC)){
    return CLR_HUD_PURPLE + '0.15 0.15 0.15' ;
  }
  return CLR_DEF_TXT_NONSELECT; 
};

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