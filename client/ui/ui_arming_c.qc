/*
mech Mod
Author: Peter Roohr
Date: 1/6/2018
Overview: part of splitting the hangar into more understandable chunks
  'arming' is where the player can select weapons, compare them, 
  set weapon groups.
*/

//hook for inputs
void() menu_arming_listener={
  weaponSelectListener();
  hardpointListener();
  hardpointInfoListener();
  weaponGroupPanelListener();
};

void() weaponSelectListener={
  local float found;
  found = listListener(WEPNLIST_ORG, cursorpos, WEPNLIST_SIZE, gui_percentToPixel(0.075, 0.0145), WEPNLIST_CNT, 0);
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL)){
    found = listListener(WEPNLIST_ORG_BAL, cursorpos, WEPNLIST_SIZE_BAL, gui_percentToPixel(0.0703, 0.0166), WEPNLIST_CNT_BAL, 0);
    found = WEPLIST_BAL_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE)){
    found = listListener(WEPNLIST_ORG_ENE, cursorpos, WEPNLIST_SIZE_ENE, gui_percentToPixel(0.0703, 0.0166), WEPNLIST_CNT_ENE, 0);
    found = WEPLIST_ENE_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP)){
    found = listListener(WEPNLIST_ORG_EXP, cursorpos, WEPNLIST_SIZE_EXP, gui_percentToPixel(0.0703, 0.0166), WEPNLIST_CNT_EXP, 0);
    found = WEPLIST_EXP_ARR[found];
  }
  if(found  > 0){
   PLAYER_HELPER.plr_sel_wep = found;
   if(PLAYER_HELPER.plr_sel_hrpnt > 0){
    local entity dat;
    dat = m_findData(found, DATA_WEPN);
    if(dat){
      if((PLAYER_HELPER.plr_sel_hrpnt_types & dat.dmg_type) && (PLAYER_HELPER.plr_sel_hrpnt_size >= dat.i_size)){
        HARDPOINTS[PLAYER_HELPER.plr_sel_hrpnt] = found;
      } 
    }
   }
  }
};

void() hardpointInfoListener={

};

void() weaponGroupPanelListener={
  local float found;
  local entity dat;
  dat = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_A, WEPNGRP_SIZE_A)){
    found = listListener(WEPNGRP_ORG_A, cursorpos, WEPNGRP_SIZE_A,  gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_A, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp1 & found)){
      PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 - (PLAYER_HELPER.plr_nex_grp1 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 | found;
    }
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_B, WEPNGRP_SIZE_B)){
    found = listListener(WEPNGRP_ORG_B, cursorpos, WEPNGRP_SIZE_B, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_B, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp2 & found)){
      PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 - (PLAYER_HELPER.plr_nex_grp2 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 | found;
    }
  }  
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_C, WEPNGRP_SIZE_C)){
    found = listListener(WEPNGRP_ORG_C, cursorpos, WEPNGRP_SIZE_C, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_C, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp3 & found)){
      PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 - (PLAYER_HELPER.plr_nex_grp3 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 | found;
    }
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_D, WEPNGRP_SIZE_D)){
    found = listListener(WEPNGRP_ORG_D, cursorpos, WEPNGRP_SIZE_D, gui_percentToPixel(0.0109, 0.018), WEPNGRP_CNT_D, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp4 & found)){
      PLAYER_HELPER.plr_nex_grp4 = PLAYER_HELPER.plr_nex_grp4 - (PLAYER_HELPER.plr_nex_grp4 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp4 = PLAYER_HELPER.plr_nex_grp4 | found;
    }
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_E, WEPNGRP_SIZE_E)){
    found = listListener(WEPNGRP_ORG_E, cursorpos, WEPNGRP_SIZE_E, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_E, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp5 & found)){
      PLAYER_HELPER.plr_nex_grp5 = PLAYER_HELPER.plr_nex_grp5 - (PLAYER_HELPER.plr_nex_grp5 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp5 = PLAYER_HELPER.plr_nex_grp5 | found;
    }
  }
};

//main hook for the menu system
void() menu_arming_drawFrame={
  if(PLAYER_HELPER.plr_sel_mech <= 0){
    PLAYER_HELPER.plr_sel_mech = 1;
    PLAYER_HELPER.vec_size = 1;
    local entity dat;
    cleanHardPoints();
    dat = m_findMechData(1,1);
    grabMechConfig(dat);
    cl_setmech(1, 1); 
  }
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '1 1 1', HUD_ALPHA, 0);
  
  menu_arming_WeaponList(topleftroot + gui_percentToPixel(0, 0.025));
  menu_arming_HardPointInfo(topleftroot);
  menu_arming_WeaponGroupPanel(topleftroot);
  menu_arming_WeaponInfo(topleftroot + gui_percentToPixel(0, 0.025));
};

void(vector ofs) menu_arming_WeaponList={
  local vector nofs;
  ofs_x = VIEW_CTR_x + gui_percentX(0.1171);
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(0.0093, 0.0125);
  drawpic(ofs + gui_percentToPixel(0.0078, 0.0187), UI_DEF_BOX_256_TALL, gui_percentToPixel(0.1156, 0.4166), '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixel(0.0062, 0.0083), "[AVAILABLE WEAPONS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  menu_arming_WeaponList_BAL(nofs);
  menu_arming_WeaponList_ENE(nofs);
  menu_arming_WeaponList_EXP(nofs);
  menu_arming_WeaponList_MSC(nofs);
};

void(vector ofs) menu_arming_WeaponList_BAL={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(-0.0062, 0.0125);
  drawstring(nofs + gui_percentToPixel(0.0312, 0.002), "==BALLISTIC==", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 15){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_BAL)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        if(!(PLAYER_HELPER.plr_sel_hrpnt_types & DMG_BAL) || (dat.i_size > PLAYER_HELPER.plr_sel_hrpnt_size)){
          clr = CLR_DEF_BLACK;
        }
        drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
        WEPLIST_BAL_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_BAL = act_idx;
  WEPNLIST_ORG_BAL = nofs;
  WEPNLIST_SIZE_BAL_x = gui_percentX(0.0687);
  WEPNLIST_SIZE_BAL_y = gui_percentY(act_idx * 0.0166);
};

void(vector ofs) menu_arming_WeaponList_ENE={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(-0.0062, 0.1041);
  drawstring(nofs + gui_percentToPixel(0.0375, 0.002), "==ENERGY==", '6 6 0', CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2', HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_ENE)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        if(!(PLAYER_HELPER.plr_sel_hrpnt_types & DMG_ENE) || (dat.i_size > PLAYER_HELPER.plr_sel_hrpnt_size)){
          clr = CLR_DEF_BLACK;
        }
        drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
        WEPLIST_ENE_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_ENE = act_idx;
  WEPNLIST_ORG_ENE = nofs;
  WEPNLIST_SIZE_ENE_x = gui_percentX(0.0687);
  WEPNLIST_SIZE_ENE_y = gui_percentY(act_idx * 0.0166);
};

void(vector ofs) menu_arming_WeaponList_EXP={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(-0.0062, 0.1979);
  drawstring(nofs + gui_percentToPixel(0.0375, 0.002), "==MISSILE==", '6 6 0', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_EXP)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        if(!(PLAYER_HELPER.plr_sel_hrpnt_types & DMG_EXP) || (dat.i_size > PLAYER_HELPER.plr_sel_hrpnt_size)){
          clr = CLR_DEF_BLACK;
        }
        drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
        WEPLIST_EXP_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_EXP = act_idx;
  WEPNLIST_ORG_EXP = nofs;
  WEPNLIST_SIZE_EXP_x = gui_percentX(0.0687);
  WEPNLIST_SIZE_EXP_y = gui_percentY(act_idx * 0.0166);
};

void(vector ofs) menu_arming_WeaponList_MSC={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(0.0093, 0.2864);
  drawstring(nofs + gui_percentToPixel(0.0031, 0.002), "==MISCELLANEOUS==", '6 6 0', CLR_DEF_RET_GETLOCK, HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_MSC)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
        WEPLIST_MSC_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_MSC = act_idx;
  WEPNLIST_ORG_MSC = nofs;
  WEPNLIST_SIZE_MSC_x = gui_percentX(0.0687);
  WEPNLIST_SIZE_MSC_y = gui_percentY(act_idx * 0.0166);
};

void(vector ofs) menu_arming_WeaponGroupPanel={
  local vector nofs, col_a, col_b, col_c, col_d, col_e;
  local float lst_idx, bit;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentX(0.0296);
  nofs_y = ofs_y + VIEW_CTR_y + gui_percentY(0.0541);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixel(0.1531, 0.189), '1 1 1', HUD_ALPHA,0);
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0062), "[GROUPINGS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.06, 0.0062), "[1] [2] [3] [4] [5]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  nofs = nofs + gui_percentToPixel(0, 0.0062);
  col_a = nofs + gui_percentToPixel(0.062, 0.012);
  col_b = nofs + gui_percentToPixel(0.081, 0.012);
  col_c = nofs + gui_percentToPixel(0.1, 0.012);
  col_d = nofs + gui_percentToPixel(0.119, 0.012);
  col_e = nofs + gui_percentToPixel(0.138, 0.012);
  lst_idx = 1;
  bit = 1;
  while(lst_idx <= PLAYER_HELPER.hardpoint_cnt){
    local vector lofs;
    local entity dat;
    lofs_x = nofs_x + gui_percentX(0.0046);
    lofs_y = nofs_y + gui_percentY(lst_idx * 0.018);
    dat = m_findData(HARDPOINTS[lst_idx], DATA_WEPN);
    drawstring(lofs, ftos(lst_idx), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(dat.w_icon != ""){
      drawpic(lofs + gui_percentToPixel(0.005, -0.005), dat.w_icon, gui_percentToPixel(0.017, 0.02), '1 1 1', HUD_ALPHA,0);
    }
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp1 & bit),  lofs + gui_percentToPixel(0.057, -0.0041), UI_DEF_BOX_256, gui_percentToPixel(0.0109, 0.0145), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp2 & bit),  lofs + gui_percentToPixel(0.076, -0.0041), UI_DEF_BOX_256, gui_percentToPixel(0.0109, 0.0145), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp3 & bit),  lofs + gui_percentToPixel(0.095, -0.0041), UI_DEF_BOX_256, gui_percentToPixel(0.0109, 0.0145), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp4 & bit),  lofs + gui_percentToPixel(0.114, -0.0041), UI_DEF_BOX_256, gui_percentToPixel(0.0109, 0.0145), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp5 & bit),  lofs + gui_percentToPixel(0.133, -0.0041), UI_DEF_BOX_256, gui_percentToPixel(0.0109, 0.0145), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
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
  WEPNGRP_SIZE_A_x = WEPNGRP_SIZE_B_x = WEPNGRP_SIZE_C_x = gui_percentX(0.0109);
  WEPNGRP_SIZE_D_x = WEPNGRP_SIZE_E_x = gui_percentX(0.0109);
  WEPNGRP_SIZE_A_y = WEPNGRP_SIZE_B_y = WEPNGRP_SIZE_C_y = gui_percentY(lst_idx * 0.018);
  WEPNGRP_SIZE_D_y = WEPNGRP_SIZE_E_y = gui_percentY(lst_idx * 0.018);
};

void(vector ofs) menu_arming_HardPointInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentX(0.0296);
  nofs_y = ofs_y + gui_percentY(0.0437);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixel(0.1531, 0.0583), '1 1 1', HUD_ALPHA, 0);
  local string title;
  local float tlen;
  local vector tpos;
  title = "[HARDPOINT INFO]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixel(0.05, 0.0031);
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector idrpos;
  idrpos = nofs + gui_percentToPixel(0.0031, 0.0125);
  drawstring(idrpos, strcat("[ID]: ", ftos(PLAYER_HELPER.plr_sel_hrpnt)) , '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  dat = m_findData(HARDPOINTS[PLAYER_HELPER.plr_sel_hrpnt], DATA_WEPN);
  local string wepname_row;
  local vector wnpos;
  wepname_row = strcat("[WEAPON]:", dat.w_abbr);
  wnpos = idrpos + gui_percentToPixel(0, 0.0083);
  drawstring(wnpos, wepname_row, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local string wepgrp_row;
  local vector wgpos;
  local string groups;
  wgpos = idrpos + gui_percentToPixel(0, 0.0166);
  drawstring(wgpos, "[GROUPS]:", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderHighlightString("[A]",wgpos+gui_percentToPixel(0.05, 0), CLR_DEF_ARM_OK, CLR_DEF_TXT_NONSELECT,checkIfWeaponInGroup(PLAYER_HELPER.plr_sel_wid, PLAYER_HELPER.plr_nex_grp1),'6 6 0', HUD_ALPHA,0);  
  gui_renderHighlightString("[B]",wgpos+gui_percentToPixel(0.075, 0), CLR_DEF_ARM_OK, CLR_DEF_TXT_NONSELECT,checkIfWeaponInGroup(PLAYER_HELPER.plr_sel_wid, PLAYER_HELPER.plr_nex_grp2),'6 6 0', HUD_ALPHA,0);  
  gui_renderHighlightString("[C]",wgpos+gui_percentToPixel(0.1, 0), CLR_DEF_ARM_OK, CLR_DEF_TXT_NONSELECT,checkIfWeaponInGroup(PLAYER_HELPER.plr_sel_wid, PLAYER_HELPER.plr_nex_grp3),'6 6 0', HUD_ALPHA,0);  
  
  local vector typpos;
  typpos = idrpos + gui_percentToPixel(0, 0.025);
  drawstring(typpos, "[ALLOWED TYPES]:", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector hptsizepos;
  hptsizepos = idrpos + gui_percentToPixel(0, 0.034);
  drawstring(hptsizepos, "[MAX WEAPON SIZE]:", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_arming_WeaponInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentX(0.0296);
  nofs_y = ofs_y + gui_percentY(0.077);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixel(0.1531, 0.202), CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  local string title;
  local float tlen;
  local vector tpos;
  title = "[WEAPON INFO]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixel(0, 0.0062);
  tpos_x= (nofs_x + gui_percentX(0.0765)) - gui_percentXRaw((tlen/2));
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector nmpos;
  local string name;
  local entity dat;
  local float nlen;
  dat = m_findData(PLAYER_HELPER.plr_sel_wep, DATA_WEPN);
  if(dat.w_icon != ""){
    drawpic((nofs + gui_percentToPixel(0.005, 0.005)), dat.w_icon, gui_percentToPixel(0.03, 0.03), CLR_DEF_WHITE, HUD_ALPHA, 0); 
  }
  name = dat.w_name;
  nlen = stringwidth(name, 0, '7 8 0');
  nmpos = nofs + gui_percentToPixel(0, 0.04);
  nmpos_x = (nmpos_x + gui_percentX(0.0765)) - gui_percentXRaw((nlen/2)); 
  drawstring(nmpos, name, '7 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixel(0.003, 0.06);
  
  //damage
  drawstring(icol, strcat("[DAMAGE]:         ", ftos(dat.dmg_amt)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //type
  drawstring(icol + gui_percentToPixel(0, 0.0083), strcat("[TYPE]:         ",getNameOfWepType(dat.dmg_type)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //en cost
  drawstring(icol + gui_percentToPixel(0, 0.0166), strcat("[ENERGY COST]:  ",ftos(dat.en_max)," per second"), '7 7 0', '1 1 1', HUD_ALPHA, 0);
    
  //range
  drawstring(icol + gui_percentToPixel(0, 0.025), strcat("[RANGE]:        ",ftos(dat.w_range)),'7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //size
  drawstring(icol + gui_percentToPixel(0, 0.0333), strcat("[RATE OF FIRE]: ",ftos(dat.w_firerate),"s"), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //clip
  drawstring(icol + gui_percentToPixel(0, 0.0416), strcat("[CLIPSIZE]:     ",ftos(dat.w_clipsize)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //rof
  drawstring(icol + gui_percentToPixel(0, 0.05), strcat("[RELOAD TIME]:  ",ftos(dat.w_reloadtime),"s"), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //reload
  drawstring(icol + gui_percentToPixel(0, 0.0583),strcat("[SIZE]:         ",ftos(dat.i_size)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //tech
  drawstring(icol + gui_percentToPixel(0, 0.0666), strcat("[TECH LEVEL]:   ",ftos(dat.i_techlvl)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //desc
  drawstring(icol + gui_percentToPixel(0, 0.075), "[NOTES]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  if(dat.note1){
    drawstring(icol+gui_percentToPixel(0.0015, 0.0854), dat.note1, '5 6 0', '1 1 1', HUD_ALPHA, 0);
  }
  if(dat.note2){
    drawstring(icol+gui_percentToPixel(0.0015, 0.958), dat.note2, '5 6 0', '1 1 1', HUD_ALPHA, 0);
  }
  if(dat.note3){
    drawstring(icol+gui_percentToPixel(0.0015, 0.1062), dat.note3, '5 6 0', '1 1 1', HUD_ALPHA, 0);
  }
  if(dat.note4){
    drawstring(icol+gui_percentToPixel(0.0015, 0.1166), dat.note4, '5 6 0', '1 1 1', HUD_ALPHA, 0);
  }
};

//UTILITY FUNCS
float(float comp, float bits) checkIfWeaponInGroup={
  if((bits & comp)){
    return TRUE;
  }
  else{
    return FALSE;
  }
};

void() cleanHardPoints={
  local float lst_idx;
  lst_idx = 1;
  while(lst_idx <= PLAYER_HELPER.hardpoint_cnt){
    HARDPOINTS[lst_idx] = 0;
    lst_idx = lst_idx + 1;
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
  else{
    return "unknown";
  } 
};

void() stashMechConfig={
  local entity prev;
  
  prev = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
  prev.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1;
  prev.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2;
  prev.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3;
  prev.plr_nex_grp4 = PLAYER_HELPER.plr_nex_grp4;
  prev.plr_nex_grp5 = PLAYER_HELPER.plr_nex_grp5;
  
  prev.plr_nex_wep1 = HARDPOINTS[1];
  prev.plr_nex_wep2 = HARDPOINTS[2];
  prev.plr_nex_wep3 = HARDPOINTS[3];
  prev.plr_nex_wep4 = HARDPOINTS[4];
  prev.plr_nex_wep5 = HARDPOINTS[5];
  prev.plr_nex_wep6 = HARDPOINTS[6];
  prev.plr_nex_wep7 = HARDPOINTS[7];
  prev.plr_nex_wep8 = HARDPOINTS[8];
  prev.plr_nex_wep9 = HARDPOINTS[9];
};

void(entity next) grabMechConfig={
  PLAYER_HELPER.plr_nex_grp1 = next.plr_nex_grp1;
  PLAYER_HELPER.plr_nex_grp2 = next.plr_nex_grp2;
  PLAYER_HELPER.plr_nex_grp3 = next.plr_nex_grp3;
  PLAYER_HELPER.plr_nex_grp4 = next.plr_nex_grp4;
  PLAYER_HELPER.plr_nex_grp5 = next.plr_nex_grp5;
  PLAYER_HELPER.hardpoint_cnt = next.hardpoint_cnt;
  HARDPOINTS[1] = next.plr_nex_wep1;
  HARDPOINTS[2] = next.plr_nex_wep2;
  HARDPOINTS[3] = next.plr_nex_wep3;
  HARDPOINTS[4] = next.plr_nex_wep4;
  HARDPOINTS[5] = next.plr_nex_wep5;
  HARDPOINTS[6] = next.plr_nex_wep6;
  HARDPOINTS[7] = next.plr_nex_wep7;
  HARDPOINTS[8] = next.plr_nex_wep8;
  HARDPOINTS[9] = next.plr_nex_wep9;
};