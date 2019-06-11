/*
battleMETAL
Author: Peter Roohr
Date: 1/6/2018
mod: 6/10/2019
Overview: part of splitting the hangar into more understandable chunks
  'arming' is where the player can select weapons, compare them, 
  set weapon groups.
*/

//hook for inputs
void() menu_arming_listener={
  cons_logAFloat("mouse state", INPUT_mouse_state); //DEBUG
  weaponDragListener();
  weaponSelectListener();
  hardpointListener();
  weaponGroupPanelListener();
  assignToHardpointListener();
  selectNextConfig();
  selectPrevConfig();
};

void() weaponDragListener={
  if( (INPUT_mouse_state == MOUSE_DRAG) && (INPUT_mouse_state_prev == MOUSE_DOWN) ){
    if( CLIENT_MENU_sel_list_wep > 0 ){
      if( !UI_ARMING_item_drag ){
        UI_ARMING_item_drag = spawn();
      }
      UI_ARMING_item_drag.data_idx = CLIENT_MENU_sel_list_wep;
      data_get_client_item_( UI_ARMING_item_drag, CLIENT_MENU_sel_list_wep);
    }
  }
  if( (INPUT_mouse_state == INPUT_EVENT_KEYUP) && (INPUT_mouse_state_prev == MOUSE_DOWN) ){
    if( UI_ARMING_item_drag || UI_ARMING_item_drag != world ){
      //TODO check hardpoint bounds
      //if yes, install info into hardpoint, remove drag item
      remove(UI_ARMING_item_drag);
    }
  }
};

void() assignToHardpointListener={
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
};

void() weaponSelectListener={
  local float found;
  found = listListener(WEPNLIST_ORG, cursorpos, WEPNLIST_SIZE, gui_percentToPixelRawVec('96 13.92'), WEPNLIST_CNT, 0);
  cons_logAFloat("WEPNLIST_CNT_BAL", WEPNLIST_CNT_BAL); //DEBUG
  cons_logAFloat("WEPNLIST_CNT_ENE", WEPNLIST_CNT_ENE); //DEBUG
  cons_logAFloat("WEPNLIST_CNT_EXP", WEPNLIST_CNT_EXP); //DEBUG
  cons_logAFloat("WEPNLIST_CNT_MSC", WEPNLIST_CNT_MSC); //DEBUG

  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL)){
    found = listListener(WEPNLIST_ORG_BAL, cursorpos, WEPNLIST_SIZE_BAL, gui_percentToPixelRawVec('90 13'), WEPNLIST_CNT_BAL, 0);
    found = WEPLIST_BAL_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE)){
    found = listListener(WEPNLIST_ORG_ENE, cursorpos, WEPNLIST_SIZE_ENE, gui_percentToPixelRawVec('90 13'), WEPNLIST_CNT_ENE, 0);
    found = WEPLIST_ENE_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP)){
    found = listListener(WEPNLIST_ORG_EXP, cursorpos, WEPNLIST_SIZE_EXP, gui_percentToPixelRawVec('90 13'), WEPNLIST_CNT_EXP, 0);
    found = WEPLIST_EXP_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_MSC, WEPNLIST_SIZE_MSC)){
    found = listListener(WEPNLIST_ORG_MSC, cursorpos, WEPNLIST_SIZE_MSC, gui_percentToPixelRawVec('90 13'), WEPNLIST_CNT_MSC, 0);
    found = WEPLIST_MSC_ARR[found];
  }
  if(found  > 0){
    CLIENT_MENU_sel_list_wep = found;
    ui_date_load_item1(CLIENT_MENU_sel_list_wep);

  }
};

void() hardpointListener={
  local float hpnt, hlist, wepbit;
  local entity hardpoint;
  local vector hardpointOffset;
  local float hardpointItr;
  local float weaponBitFlag;
  
  if( SELECT_MECH > FALSE){
	
    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    weaponBitFlag = 1;
    while( hardpoint ){
      hardpointOffset = hardpoint.c_ofs;

      hardpointOffset_x = gui_percentXRaw( hardpointOffset_x * 4 );
      hardpointOffset_y = gui_percentYRaw( hardpointOffset_y * 4 );
      
      hardpointOffset_z = 0;
      if(menu_checkMouseInBounds(cursorpos, (MECHPANEL_CTR + hardpointOffset), gui_percentToPixelRawVec('28 28'))){
        CLIENT_MENU_sel_wid = wepbit;
        CLIENT_MENU_sel_hrpnt_size = hardpoint.hardpointSize;
        CLIENT_MENU_sel_hrpnt_types = hardpoint.hardpointType;
        CLIENT_MENU_sel_hrpnt = hardpointItr;
        CLIENT_MENU_sel_wep = hardpoint.data_idx;
        ui_date_load_item2(CLIENT_MENU_sel_wep);
      }
      hardpointItr = hardpointItr + 1;
      weaponBitFlag = weaponBitFlag * 2;
      hardpoint = hardpoint.w_slot;
    }
  }
};

void() weaponGroupPanelListener={
  local float found;
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_A, WEPNGRP_SIZE_A)){
    found = listListener(WEPNGRP_ORG_A, cursorpos, WEPNGRP_SIZE_A,  gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_A, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp1 & found)){
      CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 - (CLIENT_MENU_nex_grp1 & found);
      
    }else{
      CLIENT_MENU_nex_grp1 = CLIENT_MENU_nex_grp1 | found;
    }
    GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_B, WEPNGRP_SIZE_B)){
    found = listListener(WEPNGRP_ORG_B, cursorpos, WEPNGRP_SIZE_B, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_B, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp2 & found)){
      CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 - (CLIENT_MENU_nex_grp2 & found);
    }else{
      CLIENT_MENU_nex_grp2 = CLIENT_MENU_nex_grp2 | found;
    }
    GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
  }  
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_C, WEPNGRP_SIZE_C)){
    found = listListener(WEPNGRP_ORG_C, cursorpos, WEPNGRP_SIZE_C, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_C, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp3 & found)){
      CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 - (CLIENT_MENU_nex_grp3 & found);
    }else{
      CLIENT_MENU_nex_grp3 = CLIENT_MENU_nex_grp3 | found;
    }
    GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_D, WEPNGRP_SIZE_D)){
    found = listListener(WEPNGRP_ORG_D, cursorpos, WEPNGRP_SIZE_D, gui_percentToPixel(0.0109, 0.018), WEPNGRP_CNT_D, 0);
    found = WEPBITS[found];
    if((CLIENT_MENU_nex_grp4 & found)){
      CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 - (CLIENT_MENU_nex_grp4 & found);
    }else{
      CLIENT_MENU_nex_grp4 = CLIENT_MENU_nex_grp4 | found;
    }
    GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_E, WEPNGRP_SIZE_E)){
    found = listListener(WEPNGRP_ORG_E, cursorpos, WEPNGRP_SIZE_E, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_E, 0);
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
  if(menu_checkMouseInBounds(cursorpos, BTN_CFG_N, gui_percentToPixelRawVec('20 38') )){
    CFG_INDEX_PREV = CFG_INDEX;
    CFG_INDEX = CFG_INDEX + 1;
    if( CFG_INDEX > 6 ){
      CFG_INDEX = 0;
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
  if(menu_checkMouseInBounds(cursorpos, BTN_CFG_P, gui_percentToPixelRawVec('20 38') )){
    CFG_INDEX_PREV = CFG_INDEX;
    CFG_INDEX = CFG_INDEX - 1;
    if( CFG_INDEX < 0 ){
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
  menu_arming_WeaponList(topleftroot + gui_percentToPixel(0, 0.025));
  menu_arming_WeaponGroupPanel(topleftroot + gui_percentToPixelRawVec('0 32'));
  menu_arming_energydraw(gui_percentToPixelRawVec('160 276'));
  menu_arming_WeaponInfo(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_WeaponInHardpoint(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_AssignToHardpoint_btn(VIEW_CTR);
  menu_arming_DrawItemDragIcon();
};

void(vector ofs) menu_arming_HardpointGraph={
  local vector nofs, hofs, hardpointCenter, panelImageSize;
  local entity hardpoint;
  local vector hardpointOffset;
  local float hardpointItr;
  
  nofs = ofs + gui_percentToPixelRawVec('10 8');
  panelImageSize = gui_percentToPixelRawVec('270 236');
  drawpic(nofs , UI_DEF_BOX_512, gui_percentToPixelRawVec('278 244'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
  drawpic(nofs + gui_percentToPixelRawVec('4 4'), UI_HANGAR_BOX, panelImageSize, '0.25 0.25 0.25', 1, 0);
  
  if( SELECT_MECH > FALSE){
    drawpic(nofs , MECH_DATA_ICON, gui_percentToPixelRawVec('278 244'), CLR_DEF_GRAY_H - '0.25 0.25 0.25' , 1, 0);
   
    hardpointCenter_x = nofs_x + gui_percentXRaw(139);
    hardpointCenter_y = nofs_y + gui_percentYRaw(118);
    hardpointCenter = nofs + gui_percentToPixelRawVec('139 122');
    MECHPANEL_CTR = hardpointCenter;
    
    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){	
      hardpointOffset = hardpoint.c_ofs;

      hardpointOffset_x = gui_percentXRaw( hardpointOffset_x * 4 );
      hardpointOffset_y = gui_percentYRaw( hardpointOffset_y * 4 );
      
      hardpointOffset_z = 0;
      hardpointOffset = hardpointCenter - hardpointOffset;
	  
      ui_renderHardPointGraphic( hardpoint.data_idx, hardpointOffset, (CLIENT_MENU_sel_hrpnt == hardpointItr) );
      ui_renderHardPointNumber(hardpointItr, hardpointOffset);
	  
      hardpointItr = hardpointItr + 1;
      hardpoint = hardpoint.w_slot;
    }
  }
  
  local vector nbtn, pbtn, pctr, lctr;
  pctr_x = panelImageSize_x / 2;
  pctr_y = panelImageSize_y / 2;
  nbtn = pbtn = nofs;
  pbtn_y = pbtn_y + pctr_y;
  nbtn_x = nbtn_x + panelImageSize_x - gui_percentXRaw(14);
  nbtn_y = nbtn_y + pctr_y;
  
  BTN_CFG_P = pbtn;
  drawstring(pbtn + gui_percentToPixelRawVec('0 -19'), "PREV", '6 6 0', CLR_DEF_ARM_HALF, 1, 0);
  drawstring(pbtn + gui_percentToPixelRawVec('0 -13'), "CONFIG", '6 6 0', CLR_DEF_ARM_HALF, 1, 0);
  drawpic(pbtn, HUD_TRG_PIP_L, gui_percentToPixelRawVec('20 38'), CLR_DEF_ARM_THREEQ, 1, 0);
  
  BTN_CFG_N = nbtn;
  drawstring(nbtn + gui_percentToPixelRawVec('-9 -19'), "NEXT", '6 6 0', CLR_DEF_ARM_HALF, 1, 0);
  drawstring(nbtn + gui_percentToPixelRawVec('-9 -13'), "CONFIG", '6 6 0', CLR_DEF_ARM_HALF, 1, 0);
  drawpic(nbtn, HUD_TRG_PIP_R, gui_percentToPixelRawVec('20 38'), CLR_DEF_ARM_THREEQ, 1, 0);
  
  lctr = nofs + pctr;
  lctr_y = lctr_y + pctr_y - gui_percentYRaw(8);
  local string cfg;
  local float len;
  local vector colr;
  //this is quite hilarious
  cfg = NAVNAMES[CFG_INDEX];
  colr = CLR_DEF_ARM_OK;
  if( CFG_INDEX == 0 ){
    cfg = "DEFAULT";
    colr = CLR_DEF_ARM_HALF;
  }
  cfg = strcat("CONFIG: ", cfg);
  len = stringwidth(cfg, 0, '8 9 0');
  lctr_x = lctr_x - gui_percentXRaw( len / 2 );
  drawstring(lctr, cfg, '8 9 0', colr, 1, 0);
  
};

void(vector ofs) menu_arming_WeaponList={
  local vector menuOffset;
  
  menuOffset = ofs;
  menuOffset_x = VIEW_CTR_x + gui_percentXRaw(150);
  menuOffset = menuOffset + gui_percentToPixelRawVec('12 10');
  drawpic(menuOffset, UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('148 439'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('5 12'), DMG_BAL, "==BALLISTIC==", CLR_DEF_ARM_HALF );
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('5 89.93'), DMG_ENE, "==ENERGY==", CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2' );
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('5 199.98'), DMG_EXP, "==MISSILE==", CLR_DEF_ARM_OK );
  menu_arming_WeaponList_draw(menuOffset, gui_percentToPixelRawVec('5 284.94'), DMG_MSC, "==MISCELLANEOUS==", CLR_DEF_RET_GETLOCK );
};

void(vector parentOffset, vector offsetAdjust, float weaponType, string listName, vector listNameColor) menu_arming_WeaponList_draw={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  local float itemId;
  
  nofs = parentOffset;
  nofs = nofs + offsetAdjust;
  //TODO - center the text
  drawstring(nofs + gui_percentToPixelRawVec('39.93 1.92'), listName, '6 6 0', listNameColor, 1, 0);
  act_idx = 0;
  lst_idx = 0;
 
  while(lst_idx <= UNLOCKED_ITEMS_TOTAL){
    local vector lofs, clr;
    itemId = UNLOCKED_ITEMS[lst_idx];
    
    if( itemId != 0){
      data_get_client_item_( UI_ARMING_DATA_item_list, itemId );
      if( (UI_ARMING_DATA_item_list.damageType & weaponType) ){
        lofs_x = nofs_x;
        lofs_y = nofs_y + gui_percentYRaw( (act_idx + 1) * 16);
        clr = CLR_DEF_TXT_NONSELECT;
        if( itemId == CLIENT_MENU_sel_list_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs + gui_percentToPixelRawVec('0 -1.44'), UI_BOX_SELECT, gui_percentToPixelRawVec('140.8 9.6'), CLR_DEF_ARM_OK, 1, 0);
        }
        if(!(CLIENT_MENU_sel_hrpnt_types & weaponType) || (UI_ARMING_DATA_item_list.i_size > CLIENT_MENU_sel_hrpnt_size)){
          clr = CLR_DEF_TXT_CANTSELET;
        }
        drawstring(lofs + gui_percentToPixelRawVec('12 0'), UI_ARMING_DATA_item_list.w_name, '5 5 0', clr, 1, 0);
        
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
    gui_DrawRect(WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL, '2 2 0', listNameColor);  //DEBUG
    drawline(4, WEPNLIST_ORG_BAL, WEPNLIST_ORG_BAL + WEPNLIST_SIZE_BAL, '0 1 1', 1, 0); //DEBUG
  }
  else if( (weaponType & DMG_ENE) ){
    WEPNLIST_CNT_ENE = act_idx;
    WEPNLIST_ORG_ENE = nofs + gui_percentToPixelRawVec('0 12');
    WEPNLIST_SIZE_ENE_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_ENE_y = gui_percentYRaw(act_idx * 14);
    gui_DrawRect(WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE, '2 2 0', listNameColor);  //DEBUG
  }
  else if( (weaponType & DMG_EXP) ){
    WEPNLIST_CNT_EXP = act_idx;
    WEPNLIST_ORG_EXP = nofs + gui_percentToPixelRawVec('0 12');
    WEPNLIST_SIZE_EXP_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_EXP_y = gui_percentYRaw(act_idx * 14);
    gui_DrawRect(WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP, '2 2 0', listNameColor);  //DEBUG
  }
  else if( (weaponType & DMG_MSC) ){
    WEPNLIST_CNT_MSC = act_idx;
    WEPNLIST_ORG_MSC = nofs + gui_percentToPixelRawVec('0 12');
    WEPNLIST_SIZE_MSC_x = gui_percentXRaw(138);
    WEPNLIST_SIZE_MSC_y = gui_percentYRaw(act_idx * 14);
    gui_DrawRect(WEPNLIST_ORG_MSC, WEPNLIST_SIZE_MSC, '2 2 0', listNameColor);  //DEBUG
  }  
};

void(vector ofs) menu_arming_WeaponGroupPanel={
  local vector nofs, col_a, col_b, col_c, col_d, col_e;
  local float lst_idx, bit;
  nofs_x = ofs_x + gui_percentXRaw(10);
  nofs_y = ofs_y + gui_percentYRaw(325);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('150 198'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1,0);
  drawstring(nofs + gui_percentToPixelRawVec('24 6'), "[WEAPON GROUPINGS]", '6 6 0', CLR_DEF_RET_GETLOCK, 1, 0);
  drawstring(nofs + gui_percentToPixelRawVec('45 14'), "[1][2][3][4][5]", '6 6 0', '1 1 1', 1, 0);
  
  nofs = nofs + gui_percentToPixelRawVec('0 10');
  col_a = nofs + gui_percentToPixelRawVec('46 14');
  col_b = nofs + gui_percentToPixelRawVec('66  14');
  col_c = nofs + gui_percentToPixelRawVec('86 14');
  col_d = nofs + gui_percentToPixelRawVec('106 14');
  col_e = nofs + gui_percentToPixelRawVec('126 14');
  
  lst_idx = 1;
  bit = 1;
  while(lst_idx <= MECH_DATA_HPOINTS){
    local vector lofs;
    lofs_x = nofs_x + gui_percentXRaw(6);
    lofs_y = nofs_y + gui_percentYRaw(lst_idx * 24);
    drawstring(lofs, strcat("[",ftos(lst_idx),"]"), '6 6 0', '1 1 1', 1, 0);
    if( ITEM_DATA_ICONS[HARDPOINTS[lst_idx]] != "" ){
      //ok that's funny and cool ^
      drawpic(lofs + gui_percentToPixelRawVec('16 -5'), ITEM_DATA_ICONS[HARDPOINTS[lst_idx]], gui_percentToPixelRawVec('22 24'), '1 1 1', 1,0);
    }
    gui_renderTintImage((CLIENT_MENU_nex_grp1 & bit),  lofs + gui_percentToPixelRawVec('40 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp2 & bit),  lofs + gui_percentToPixelRawVec('60 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp3 & bit),  lofs + gui_percentToPixelRawVec('80 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp4 & bit),  lofs + gui_percentToPixelRawVec('100 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, 1, 0);
    gui_renderTintImage((CLIENT_MENU_nex_grp5 & bit),  lofs + gui_percentToPixelRawVec('120 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, 1, 0);
    bit = bit * 2;
    lst_idx = lst_idx + 1;
  }
  //lst_idx = lst_idx;
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
  WEPNGRP_SIZE_A_x = WEPNGRP_SIZE_B_x = WEPNGRP_SIZE_C_x = gui_percentXRaw(14);
  WEPNGRP_SIZE_D_x = WEPNGRP_SIZE_E_x = gui_percentXRaw(14);
  WEPNGRP_SIZE_A_y = WEPNGRP_SIZE_B_y = WEPNGRP_SIZE_C_y = gui_percentYRaw(lst_idx * 24);
  WEPNGRP_SIZE_D_y = WEPNGRP_SIZE_E_y = gui_percentYRaw(lst_idx * 24);
};

void(vector ofs) menu_arming_energydraw={
  drawpic(ofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('126 197'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1,0);
  
  drawstring(ofs + gui_percentToPixelRawVec('3 6'), "Energy Draw total ", '7 9 0', CLR_DEF_ENE_FRT, 1, 0);
  drawstring(ofs + gui_percentToPixelRawVec('4 18'), "by [Weapon Group]", '7 8 0', '1 1 1', 1, 0);
  
  local float enmax, g1, g2, g3, g4, g5;
  enmax = MECH_DATA_ENMAX;

  drawstring(ofs + gui_percentToPixelRawVec('4 45'), "Group 1", '8 8 0', '1 1 1', 1, 0);
    g1 = (GROUP_ENE_1 / enmax)*100;
    gui_renderMeter(g1, ofs + gui_percentToPixelRawVec('60 45'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g1), 1, 0, AXIS_H, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('4 72'), "Group 2", '8 8 0', '1 1 1', 1, 0);
    g2 = (GROUP_ENE_2 / enmax)*100;
    gui_renderMeter(g2, ofs + gui_percentToPixelRawVec('60 72'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g2), 1, 0, AXIS_H, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('4 99'), "Group 3", '8 8 0', '1 1 1', 1, 0);
    g3 = (GROUP_ENE_3 / enmax)*100;
    gui_renderMeter(g3, ofs + gui_percentToPixelRawVec('60 99'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g3), 1, 0, AXIS_H, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('4 126'), "Group 4", '8 8 0', '1 1 1', 1, 0);
    g4 = (GROUP_ENE_4 / enmax)*100;
    gui_renderMeter(g4, ofs + gui_percentToPixelRawVec('60 126'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g4), 1, 0, AXIS_H, 0);
    
  drawstring(ofs + gui_percentToPixelRawVec('4 153'), "Group 5", '8 8 0', '1 1 1', 1, 0);
    g5 = (GROUP_ENE_5 / enmax)*100;
    gui_renderMeter(g5, ofs + gui_percentToPixelRawVec('60 153'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - g5), 1, 0, AXIS_H, 0);
};

void(vector ofs) menu_arming_WeaponInfo={
  local vector nofs;

  nofs_x = ofs_x + VIEW_CTR_x - gui_percentXRaw(34);
  nofs_y = ofs_y + gui_percentYRaw(12);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 193'), CLR_DEF_UI_ARMING + '0.3 0.3 0.3', 1, 0);
  
  local string title;
  local float tlen;
  local vector tpos;
  title = "[WEAPON INFO FROM LIST]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixelRawVec('0 6');
  tpos_x= (nofs_x + gui_percentXRaw(108)) - gui_percentXRaw((tlen/2));
  drawstring(tpos, title, '6 6 0', '1 1 1', 1, 0);
  
  local vector nmpos;
  local string name;
  local float nlen;
  if(ITEM_DATA_ICONS[CLIENT_MENU_sel_list_wep] != ""){
    drawpic((nofs + gui_percentToPixelRawVec('6 6')), ITEM_DATA_ICONS[CLIENT_MENU_sel_list_wep], gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, 1, 0); 
  }
  name = ITEM1_DATA_NAME;
  nlen = stringwidth(name, 0, '7 8 0');
  nmpos = nofs + gui_percentToPixelRawVec('0 38');
  nmpos_x = (nmpos_x + gui_percentXRaw(97)) - gui_percentXRaw((nlen/2)); 
  drawstring(nmpos, name, '7 8 0', '1 1 1', 1, 0);
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixelRawVec('4 50');
  
  //damage
  drawstring(icol, "[DAMAGE/SHOT]:", '7 7 0', '1 1 1', 1, 0);
  gui_renderMeter((ITEM1_DATA_DMG / 600)*100, icol + gui_percentToPixelRawVec('112 -2'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
  
  //type
  drawstring(icol + gui_percentToPixelRawVec('0 8'), strcat("[TYPE]:         ",getNameOfWepType(ITEM1_DATA_TYPE)), '7 7 0', '1 1 1', 1, 0);
  
  //en cost
  drawstring(icol + gui_percentToPixelRawVec('0 16'), "[ENERGY]:", '7 7 0', '1 1 1', 1, 0);
  gui_renderMeter((ITEM1_DATA_EN / 500)*100, icol + gui_percentToPixelRawVec('112 16'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - (ITEM1_DATA_EN / 500)*100), 1, 0, AXIS_H, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('0 24'), strcat("[RANGE]:        ",ftos(ITEM1_DATA_RANGE)),'7 7 0', '1 1 1', 1, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('0 32'), strcat("[CLIPSIZE]:     ",ftos(ITEM1_DATA_CLIP)), '7 7 0', '1 1 1', 1, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('0 40'),strcat("[SIZE]:         ",ftos(ITEM1_DATA_SIZE)), '7 7 0', '1 1 1', 1, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('0 48'), strcat("[TECH LEVEL]:   ",ftos(ITEM1_DATA_TECH)), '7 7 0', '1 1 1', 1, 0);
  
  //desc
  drawstring(icol + gui_percentToPixelRawVec('0 56'), "[NOTES]:", '7 7 0', '1 1 1', 1, 0);
  
  if( ITEM1_DATA_DESC != "" ){ 
    gui_wrapText(icol + gui_percentToPixelRawVec('-6 58'), '187 130', ITEM1_DATA_DESC, '6 7 0', '1 1 1', 1);
  }
};

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
};

void(vector ofs) menu_arming_WeaponInHardpoint={
  local vector nofs;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentXRaw(34);
  nofs_y = VIEW_CTR_y + gui_percentYRaw(12);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 193'), CLR_DEF_ARM_THREEQ, 1, 0);
  
  local string title;
  local float tlen;
  local vector tpos;
  title = "[WEAPON ON HARDPOINT]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixelRawVec('0 6');
  tpos_x= (nofs_x + gui_percentXRaw(108)) - gui_percentXRaw((tlen/2));
  drawstring(tpos, title, '6 6 0', '1 1 1', 1, 0);
  
  local vector nmpos;
  local string name;
  local float nlen;
  if( ITEM_DATA_ICONS[CLIENT_MENU_sel_wep] != "" ){
    drawpic((nofs + gui_percentToPixelRawVec('6 6')), ITEM_DATA_ICONS[CLIENT_MENU_sel_wep], gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, 1, 0); 
  }
  name = ITEM2_DATA_NAME;
  nlen = stringwidth(name, 0, '7 8 0');
  nmpos = nofs + gui_percentToPixelRawVec('0 38');
  nmpos_x = (nmpos_x + gui_percentXRaw(97)) - gui_percentXRaw((nlen/2)); 
  drawstring(nmpos, name, '7 8 0', '1 1 1', 1, 0);
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixelRawVec('4 57');
  
  //damage
  drawstring(icol, "[DAMAGE/SHOT]:", '7 7 0', '1 1 1', 1, 0);
  gui_renderMeter((ITEM2_DATA_DMG / 600)*100, icol + gui_percentToPixelRawVec('112 -2'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
  
  //type
  drawstring(icol + gui_percentToPixelRawVec('0 8'), strcat("[TYPE]:         ",getNameOfWepType(ITEM2_DATA_TYPE)), '7 7 0', '1 1 1', 1, 0);
  
  //en cost
  drawstring(icol + gui_percentToPixelRawVec('0 16'), "[ENERGY]:", '7 7 0', '1 1 1', 1, 0);
  gui_renderMeter((ITEM2_DATA_EN / 500)*100, icol + gui_percentToPixelRawVec('112 16'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, gui_getColorForArmor(100 - (ITEM2_DATA_EN / 500)*100), 1, 0, AXIS_H, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('0 24'), strcat("[RANGE]:        ", ftos(ITEM2_DATA_RANGE)),'7 7 0', '1 1 1', 1, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('0 32'), strcat("[CLIPSIZE]:     ",ftos(ITEM2_DATA_CLIP)), '7 7 0', '1 1 1', 1, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('0 40'),strcat("[SIZE]:         ",ftos(ITEM2_DATA_SIZE)), '7 7 0', '1 1 1', 1, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('0 48'), strcat("[TECH LEVEL]:   ",ftos(ITEM2_DATA_TECH)), '7 7 0', '1 1 1', 1, 0);
  
  //desc
  drawstring(icol + gui_percentToPixelRawVec('0 56'), "[NOTES]:", '7 7 0', '1 1 1', 1, 0);
  if( ITEM2_DATA_DESC != "" ){ 
    gui_wrapText(icol + gui_percentToPixelRawVec('-6 60'), '187 130', ITEM2_DATA_DESC, '6 7 0', '1 1 1', 1);
  }
};

void() menu_arming_DrawItemDragIcon={
  //todo
  local vector iconOffset;
  if( UI_ARMING_item_drag && (UI_ARMING_item_drag.icon != "") ){
    iconOffset_x = cursorpos_x - gui_percentXRaw(14);
    iconOffset_y = cursorpos_y - gui_percentYRaw(14);
    drawpic(iconOffset, UI_ARMING_item_drag.icon, gui_percentToPixelRawVec('28 28'), CLR_DEF_WHITE, 1, 0); 
  }
};

//UTILITY FUNCS
float(float comp, float bits) checkIfWeaponInGroup={
  if((bits & comp)){
    return TRUE;
  }
  return FALSE;
};

void() cleanHardPoints={
  local entity hardpoint;
  
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while( hardpoint ){
	hardpoint.data_idx = 0;
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
  local float sub, bit, lst_idx, en, wid;
  local entity dat;
  bit = 1;
  lst_idx = 1;
  sub = 0;
  while(lst_idx <= MECH_DATA_HPOINTS){
    if( (grp & bit) ){
      wid = HARDPOINTS[lst_idx];
      en = data_WeaponEne[wid];
      sub = sub + en;
    }
    bit = bit * 2;
    lst_idx = lst_idx + 1;
  }
  sub = sub - MECH_DATA_ENRATE;
  if( sub < 0){
    sub = 0;
  }
  return sub;
};