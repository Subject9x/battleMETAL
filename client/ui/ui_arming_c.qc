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
  assignToHardpointListener();
};

void() assignToHardpointListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_CTR + gui_percentToPixelRawVec('-34 -14'), gui_percentToPixelRawVec('195 24'))){
    local float found;
    found = 0;
    if(self.plr_sel_hrpnt > 0){
      if(self.plr_sel_list_wep > 0){
        local entity dat;
        dat = m_findData(self.plr_sel_list_wep, DATA_WEPN);
        if(dat){
          if((self.plr_sel_hrpnt_types & dat.dmg_type) && (self.plr_sel_hrpnt_size >= dat.i_size)){
            HARDPOINTS[self.plr_sel_hrpnt] = self.plr_sel_list_wep;
            self.plr_sel_wep = self.plr_sel_list_wep;
            GROUP_ENE_1 = calc_energy_draw(self.plr_nex_grp1);
            GROUP_ENE_2 = calc_energy_draw(self.plr_nex_grp2);
            GROUP_ENE_3 = calc_energy_draw(self.plr_nex_grp3);
            GROUP_ENE_4 = calc_energy_draw(self.plr_nex_grp4);
            GROUP_ENE_5 = calc_energy_draw(self.plr_nex_grp5);
          }
        }
      }
    }
   }
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
   self.plr_sel_list_wep = found;
  }
};

void() hardpointInfoListener={

};

void() weaponGroupPanelListener={
  local float found;
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_A, WEPNGRP_SIZE_A)){
    found = listListener(WEPNGRP_ORG_A, cursorpos, WEPNGRP_SIZE_A,  gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_A, 0);
    found = WEPBITS[found];
    if((self.plr_nex_grp1 & found)){
      self.plr_nex_grp1 = self.plr_nex_grp1 - (self.plr_nex_grp1 & found);
      
    }else{
      self.plr_nex_grp1 = self.plr_nex_grp1 | found;
    }
    GROUP_ENE_1 = calc_energy_draw(self.plr_nex_grp1);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_B, WEPNGRP_SIZE_B)){
    found = listListener(WEPNGRP_ORG_B, cursorpos, WEPNGRP_SIZE_B, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_B, 0);
    found = WEPBITS[found];
    if((self.plr_nex_grp2 & found)){
      self.plr_nex_grp2 = self.plr_nex_grp2 - (self.plr_nex_grp2 & found);
    }else{
      self.plr_nex_grp2 = self.plr_nex_grp2 | found;
    }
    GROUP_ENE_2 = calc_energy_draw(self.plr_nex_grp2);
  }  
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_C, WEPNGRP_SIZE_C)){
    found = listListener(WEPNGRP_ORG_C, cursorpos, WEPNGRP_SIZE_C, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_C, 0);
    found = WEPBITS[found];
    if((self.plr_nex_grp3 & found)){
      self.plr_nex_grp3 = self.plr_nex_grp3 - (self.plr_nex_grp3 & found);
    }else{
      self.plr_nex_grp3 = self.plr_nex_grp3 | found;
    }
    GROUP_ENE_3 = calc_energy_draw(self.plr_nex_grp3);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_D, WEPNGRP_SIZE_D)){
    found = listListener(WEPNGRP_ORG_D, cursorpos, WEPNGRP_SIZE_D, gui_percentToPixel(0.0109, 0.018), WEPNGRP_CNT_D, 0);
    found = WEPBITS[found];
    if((self.plr_nex_grp4 & found)){
      self.plr_nex_grp4 = self.plr_nex_grp4 - (self.plr_nex_grp4 & found);
    }else{
      self.plr_nex_grp4 = self.plr_nex_grp4 | found;
    }
    GROUP_ENE_4 = calc_energy_draw(self.plr_nex_grp4);
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_E, WEPNGRP_SIZE_E)){
    found = listListener(WEPNGRP_ORG_E, cursorpos, WEPNGRP_SIZE_E, gui_percentToPixel(0.0145, 0.018), WEPNGRP_CNT_E, 0);
    found = WEPBITS[found];
    if((self.plr_nex_grp5 & found)){
      self.plr_nex_grp5 = self.plr_nex_grp5 - (self.plr_nex_grp5 & found);
    }else{
      self.plr_nex_grp5 = self.plr_nex_grp5 | found;
    }
    GROUP_ENE_5 = calc_energy_draw(self.plr_nex_grp5);
  }
};

//main hook for the menu system
void() menu_arming_drawFrame={
  if(self.plr_sel_mech <= 0){
    cleanHardPoints();
  }
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '1 1 1', HUD_ALPHA, 0);
  
  menu_arming_HardpointGraph(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_WeaponList(topleftroot + gui_percentToPixel(0, 0.025));
  menu_arming_HardPointInfo(topleftroot + gui_percentToPixelRawVec('0 32'));
  menu_arming_WeaponGroupPanel(topleftroot + gui_percentToPixelRawVec('0 32'));
  menu_arming_energydraw('160 276');
  menu_arming_WeaponInfo(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_WeapoinInHardpoint(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_arming_AssignToHardpoint_btn(VIEW_CTR);
};

void(vector ofs) menu_arming_HardpointGraph={
  local vector nofs, hofs, hpnts;
  nofs = ofs + gui_percentToPixelRawVec('10 64');
  drawpic(nofs , UI_DEF_BOX_512, gui_percentToPixelRawVec('225 188'), '1 1 1', HUD_ALPHA, 0);
  if( SELECTED_MECH != world){
    hofs = nofs + gui_percentToPixelRawVec('4 4');
    hpnts_x = hofs_x + gui_percentXRaw(110.5);
    hpnts_y = hofs_y + gui_percentYRaw(90);
    drawpic(hofs , SELECTED_MECH.c_ui_hf, gui_percentToPixelRawVec('221 180'), '1 1 1', HUD_ALPHA, 0);
    MECHPANEL_CTR = hpnts;
    SELECTED_MECH.menu_renderHardpoints(hpnts);
  }
};

void(vector ofs) menu_arming_WeaponList={
  local vector nofs;
  
  nofs = ofs;
  nofs_x = VIEW_CTR_x + gui_percentXRaw(150);
  nofs = nofs + gui_percentToPixelRawVec('12 10');
  drawpic(nofs, UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('148 439'), '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixelRawVec('8 8'), "[AVAILABLE WEAPONS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
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
  while(lst_idx <= UI_TOTAL_WEAPONS){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if(WEPLIST_ALL[lst_idx] != 0){
        if((dat.dmg_type & DMG_BAL)){
          lofs_x = nofs_x;
          lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
          if(dat.data_idx == self.plr_sel_list_wep){
            clr = CLR_DEF_TXT_HIGHLIGHT;
            gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
          }
          else{
            clr = CLR_DEF_TXT_NONSELECT;
          }
          if(!(self.plr_sel_hrpnt_types & DMG_BAL) || (dat.i_size > self.plr_sel_hrpnt_size)){
            clr = CLR_DEF_BLACK;
          }
          drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
          WEPLIST_BAL_ARR[act_idx] = dat.data_idx;
          act_idx = act_idx + 1;
        }
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
  while(lst_idx <= UI_TOTAL_WEAPONS){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if(WEPLIST_ALL[lst_idx] != 0){
        if((dat.dmg_type & DMG_ENE)){
          lofs_x = nofs_x;
          lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
          if(dat.data_idx == self.plr_sel_list_wep){
            clr = CLR_DEF_TXT_HIGHLIGHT;
            gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
          }
          else{
            clr = CLR_DEF_TXT_NONSELECT;
          }
          if(!(self.plr_sel_hrpnt_types & DMG_ENE) || (dat.i_size > self.plr_sel_hrpnt_size)){
            clr = CLR_DEF_BLACK;
          }
          drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
          WEPLIST_ENE_ARR[act_idx] = dat.data_idx;
          act_idx = act_idx + 1;
        }
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
  while(lst_idx <= UI_TOTAL_WEAPONS){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if(WEPLIST_ALL[lst_idx] != 0){
        if((dat.dmg_type & DMG_EXP)){
          lofs_x = nofs_x;
          lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
          if(dat.data_idx == self.plr_sel_list_wep){
            clr = CLR_DEF_TXT_HIGHLIGHT;
            gui_renderTintImage(TRUE, lofs + gui_percentToPixel(0.008, -0.0015), UI_BOX_SELECT, gui_percentToPixel(0.11, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
          }
          else{
            clr = CLR_DEF_TXT_NONSELECT;
          }
          if(!(self.plr_sel_hrpnt_types & DMG_EXP) || (dat.i_size > self.plr_sel_hrpnt_size)){
            clr = CLR_DEF_BLACK;
          }
          drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.w_name, '5 5 0', clr, HUD_ALPHA, 0);
          WEPLIST_EXP_ARR[act_idx] = dat.data_idx;
          act_idx = act_idx + 1;
        }
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
      if(WEPLIST_ALL[lst_idx] != 0){
        if((dat.dmg_type & DMG_MSC)){
          lofs_x = nofs_x;
          lofs_y = nofs_y + gui_percentY(act_idx * 0.0166);
          if(dat.data_idx == self.plr_sel_list_wep){
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
  nofs_x = ofs_x + gui_percentXRaw(10);
  nofs_y = ofs_y + gui_percentYRaw(325);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('150 198'), '1 1 1', HUD_ALPHA,0);
  drawstring(nofs + gui_percentToPixelRawVec('24 6'), "[WEAPON GROUPINGS]", '6 6 0', CLR_DEF_RET_GETLOCK, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('45 14'), "[1][2][3][4][5]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  nofs = nofs + gui_percentToPixelRawVec('0 10');
  col_a = nofs + gui_percentToPixelRawVec('46 14');
  col_b = nofs + gui_percentToPixelRawVec('66  14');
  col_c = nofs + gui_percentToPixelRawVec('86 14');
  col_d = nofs + gui_percentToPixelRawVec('106 14');
  col_e = nofs + gui_percentToPixelRawVec('126 14');
  
  lst_idx = 1;
  bit = 1;
  while(lst_idx <= self.hardpoint_cnt){
    local vector lofs;
    local entity dat;
    lofs_x = nofs_x + gui_percentXRaw(6);
    lofs_y = nofs_y + gui_percentYRaw(lst_idx * 24);
    dat = m_findData(HARDPOINTS[lst_idx], DATA_WEPN);
    drawstring(lofs, strcat("[",ftos(lst_idx),"]"), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(dat.w_icon != ""){
      drawpic(lofs + gui_percentToPixelRawVec('16 -5'), dat.w_icon, gui_percentToPixelRawVec('22 24'), '1 1 1', HUD_ALPHA,0);
    }
    gui_renderTintImage((self.plr_nex_grp1 & bit),  lofs + gui_percentToPixelRawVec('40 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((self.plr_nex_grp2 & bit),  lofs + gui_percentToPixelRawVec('60 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((self.plr_nex_grp3 & bit),  lofs + gui_percentToPixelRawVec('80 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((self.plr_nex_grp4 & bit),  lofs + gui_percentToPixelRawVec('100 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((self.plr_nex_grp5 & bit),  lofs + gui_percentToPixelRawVec('120 -3'), UI_DEF_BOX_256, gui_percentToPixelRawVec('14 14'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
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
  drawpic(ofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('126 197'), '1 1 1', HUD_ALPHA,0);
  
  drawstring(ofs + gui_percentToPixelRawVec('3 6'), "Energy Draw total ", '7 9 0', CLR_DEF_ENE_FRT, HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixelRawVec('4 18'), "by [Weapon Group]", '7 8 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixelRawVec('4 28'), "X Energy / 10sec", '7 8 0', '1 1 1', HUD_ALPHA, 0);
  
  local float enmax;
  enmax = SELECTED_MECH.en_max * 1.5;
  
  drawstring(ofs + gui_percentToPixelRawVec('4 45'), "Group 1", '8 8 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter((GROUP_ENE_1 / enmax)*100, ofs + gui_percentToPixelRawVec('60 45'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0, AXIS_H, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('4 72'), "Group 2", '8 8 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter((GROUP_ENE_2 / enmax)*100, ofs + gui_percentToPixelRawVec('60 72'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0, AXIS_H, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('4 99'), "Group 3", '8 8 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter((GROUP_ENE_3 / enmax)*100, ofs + gui_percentToPixelRawVec('60 99'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0, AXIS_H, 0);
  
  drawstring(ofs + gui_percentToPixelRawVec('4 126'), "Group 4", '8 8 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter((GROUP_ENE_4 / enmax)*100, ofs + gui_percentToPixelRawVec('60 126'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0, AXIS_H, 0);
    
  drawstring(ofs + gui_percentToPixelRawVec('4 153'), "Group 5", '8 8 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderMeter((GROUP_ENE_5 / enmax)*100, ofs + gui_percentToPixelRawVec('60 153'), gui_percentToPixelRawVec('32 10'), CLR_DEF_ARM_DED, CLR_DEF_ARM_ONEQ, HUD_ALPHA, 0, AXIS_H, 0);
};

void(vector ofs) menu_arming_HardPointInfo={
  local vector nofs;
  nofs_x = ofs_x + gui_percentXRaw(10);
  nofs_y = ofs_y;
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('156 56'), '1 1 1', HUD_ALPHA, 0);
  local string title;
  local float tlen;
  local vector tpos;
  title = "[HARDPOINT INFO]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixelRawVec('32 3');
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector idrpos;
  idrpos = nofs + gui_percentToPixelRawVec('4 12');
  drawstring(idrpos, strcat("[NUMBER]: ", ftos(self.plr_sel_hrpnt)) , '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector typpos;
  typpos = idrpos + gui_percentToPixelRawVec('0 6');
  drawstring(typpos, "[ALLOWED TYPES]:", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector hptsizepos;
  hptsizepos = idrpos + gui_percentToPixelRawVec('0 32');
  drawstring(hptsizepos, "[MAX WEAPON SIZE]:", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_arming_WeaponInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentXRaw(34);
  nofs_y = ofs_y + gui_percentYRaw(12);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 193'), CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  local string title;
  local float tlen;
  local vector tpos;
  title = "[WEAPON INFO FROM LIST]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixelRawVec('0 6');
  tpos_x= (nofs_x + gui_percentXRaw(108)) - gui_percentXRaw((tlen/2));
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector nmpos;
  local string name;
  local entity dat;
  local float nlen;
  dat = m_findData(self.plr_sel_list_wep, DATA_WEPN);
  if(dat.w_icon != ""){
    drawpic((nofs + gui_percentToPixelRawVec('6 6')), dat.w_icon, gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, HUD_ALPHA, 0); 
  }
  name = dat.w_name;
  nlen = stringwidth(name, 0, '7 8 0');
  nmpos = nofs + gui_percentToPixelRawVec('0 38');
  nmpos_x = (nmpos_x + gui_percentXRaw(97)) - gui_percentXRaw((nlen/2)); 
  drawstring(nmpos, name, '7 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixelRawVec('4 50');
  
  //damage
  drawstring(icol, "[DAMAGE/SHOT]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.dmg_amt / 350)*100, icol + gui_percentToPixelRawVec('112 -2'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  //type
  drawstring(icol + gui_percentToPixelRawVec('0 8'), strcat("[TYPE]:         ",getNameOfWepType(dat.dmg_type)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //en cost
  drawstring(icol + gui_percentToPixelRawVec('0 16'), "[ENERGY/SEC]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.en_rate / 20)*100, icol + gui_percentToPixelRawVec('112 16'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('0 24'), strcat("[RANGE]:        ",ftos(dat.w_range)),'7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('0 32'), strcat("[CLIPSIZE]:     ",ftos(dat.w_clipsize)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('0 40'),strcat("[SIZE]:         ",ftos(dat.i_size)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('0 48'), strcat("[TECH LEVEL]:   ",ftos(dat.i_techlvl)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //desc
  drawstring(icol + gui_percentToPixelRawVec('0 56'), "[NOTES]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  if(dat.note1){ 
    gui_wrapText(icol + gui_percentToPixelRawVec('-6 58'), '187 130', dat.note1, '6 7 0', '1 1 1', 1);
  }
};

void(vector ofs) menu_arming_AssignToHardpoint_btn={
  local vector nofs;
  nofs = ofs + gui_percentToPixelRawVec('-34 -14');
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 24'), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  drawpic(nofs + gui_percentToPixelRawVec('8 9'), HUD_TRG_PIP_B, gui_percentToPixelRawVec('16 8'), CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  drawpic(nofs + gui_percentToPixelRawVec('172 9'), HUD_TRG_PIP_B, gui_percentToPixelRawVec('16 8'), CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  drawstring(nofs+gui_percentToPixelRawVec('28 2'), "[ASSIGN TO HARDPOINT]", '7 8 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_arming_WeapoinInHardpoint={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentXRaw(34);
  nofs_y = VIEW_CTR_y + gui_percentYRaw(12);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('195 193'), CLR_DEF_ARM_THREEQ, HUD_ALPHA, 0);
  
  local string title;
  local float tlen;
  local vector tpos;
  title = "[WEAPON ON HARDPOINT]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + gui_percentToPixelRawVec('0 6');
  tpos_x= (nofs_x + gui_percentXRaw(108)) - gui_percentXRaw((tlen/2));
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local vector nmpos;
  local string name;
  local float nlen;
  dat = m_findData(self.plr_sel_wep, DATA_WEPN);
  if(dat.w_icon != ""){
    drawpic((nofs + gui_percentToPixelRawVec('6 6')), dat.w_icon, gui_percentToPixelRawVec('32 32'), CLR_DEF_WHITE, HUD_ALPHA, 0); 
  }
  name = dat.w_name;
  nlen = stringwidth(name, 0, '7 8 0');
  nmpos = nofs + gui_percentToPixelRawVec('0 38');
  nmpos_x = (nmpos_x + gui_percentXRaw(97)) - gui_percentXRaw((nlen/2)); 
  drawstring(nmpos, name, '7 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //type
  local vector icol;
  icol = nofs + gui_percentToPixelRawVec('4 57');
  
  //damage
  drawstring(icol, "[DAMAGE/SHOT]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.dmg_amt / 350)*100, icol + gui_percentToPixelRawVec('112 -2'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  //type
  drawstring(icol + gui_percentToPixelRawVec('0 8'), strcat("[TYPE]:         ",getNameOfWepType(dat.dmg_type)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //en cost
  drawstring(icol + gui_percentToPixelRawVec('0 16'), "[ENERGY/SEC]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.en_rate / 20)*100, icol + gui_percentToPixelRawVec('112 16'), gui_percentToPixelRawVec('64 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  //range
  drawstring(icol + gui_percentToPixelRawVec('0 24'), strcat("[RANGE]:        ",ftos(dat.w_range)),'7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //clip
  drawstring(icol + gui_percentToPixelRawVec('0 32'), strcat("[CLIPSIZE]:     ",ftos(dat.w_clipsize)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //reload
  drawstring(icol + gui_percentToPixelRawVec('0 40'),strcat("[SIZE]:         ",ftos(dat.i_size)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //tech
  drawstring(icol + gui_percentToPixelRawVec('0 48'), strcat("[TECH LEVEL]:   ",ftos(dat.i_techlvl)), '7 7 0', '1 1 1', HUD_ALPHA, 0);
  
  //desc
  drawstring(icol + gui_percentToPixelRawVec('0 56'), "[NOTES]:", '7 7 0', '1 1 1', HUD_ALPHA, 0);
  if(dat.note1){ 
    gui_wrapText(icol + gui_percentToPixelRawVec('-6 60'), '187 130', dat.note1, '6 7 0', '1 1 1', 1);
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
  while(lst_idx <= self.hardpoint_cnt){
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
  
  prev = m_findMechData(self.plr_sel_size, self.plr_sel_mech);
  prev.plr_nex_grp1 = self.plr_nex_grp1;
  prev.plr_nex_grp2 = self.plr_nex_grp2;
  prev.plr_nex_grp3 = self.plr_nex_grp3;
  prev.plr_nex_grp4 = self.plr_nex_grp4;
  prev.plr_nex_grp5 = self.plr_nex_grp5;
  
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
  self.plr_nex_grp1 = next.plr_nex_grp1;
  self.plr_nex_grp2 = next.plr_nex_grp2;
  self.plr_nex_grp3 = next.plr_nex_grp3;
  self.plr_nex_grp4 = next.plr_nex_grp4;
  self.plr_nex_grp5 = next.plr_nex_grp5;
  self.hardpoint_cnt = next.hardpoint_cnt;
  HARDPOINTS[1] = next.plr_nex_wep1;
  HARDPOINTS[2] = next.plr_nex_wep2;
  HARDPOINTS[3] = next.plr_nex_wep3;
  HARDPOINTS[4] = next.plr_nex_wep4;
  HARDPOINTS[5] = next.plr_nex_wep5;
  HARDPOINTS[6] = next.plr_nex_wep6;
  HARDPOINTS[7] = next.plr_nex_wep7;
  HARDPOINTS[8] = next.plr_nex_wep8;
  HARDPOINTS[9] = next.plr_nex_wep9;
  GROUP_ENE_1 = calc_energy_draw(self.plr_nex_grp1);
  GROUP_ENE_2 = calc_energy_draw(self.plr_nex_grp2);
  GROUP_ENE_3 = calc_energy_draw(self.plr_nex_grp3);
  GROUP_ENE_4 = calc_energy_draw(self.plr_nex_grp4);
  GROUP_ENE_5 = calc_energy_draw(self.plr_nex_grp5);
};

float(float grp) calc_energy_draw={
  local float sub, bit, lst_idx;
  local entity dat;
  bit = 1;
  lst_idx = 1;
  sub = 0;
  while(lst_idx <= self.hardpoint_cnt){
    if( (grp & bit) ){
      dat = m_findData(HARDPOINTS[lst_idx], DATA_WEPN);
      sub = sub + dat.en_rate;
    }
    bit = bit * 2;
    lst_idx = lst_idx + 1;
  }
  sub = sub - SELECTED_MECH.en_rate;
  if( sub < 0){
    sub = 0;
  }
  sub = sub * 10 * 10;
  return sub;
};