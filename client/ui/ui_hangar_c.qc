/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview: class file for hangar ui

*/

//hook for input events
void() menu_hangarListener={
  mechSelectListener();
  weaponSelectListener();
  hardpointListener();
  hardpointInfoListener();
  weaponGroupPanelListener();
};

void() hardpointListener={
  local entity dat;
  local float hpnt;
  dat = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
  if(dat != world){
    hpnt = dat.menu_hardpointListener(MECHPANEL_CTR);
    if(hpnt > 0){
      PLAYER_HELPER.plr_sel_hrpnt = hpnt;
      PLAYER_HELPER.plr_sel_wep = HARDPOINTS[hpnt];
    }
  }

};

void() mechSelectListener={
  local float found, vsiz;
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.025, 0.0416), gui_percentToPixel(0.075, 0.4166))){
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT)){
      found = listListener(MECHLIST_ORG_LIGHT, cursorpos, MECHLIST_SIZE_LIGHT, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_LIGHT, 0);
      found = MECHLIST_LIGHT_ARR[found];
      vsiz = 1;
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_MEDIUM, MECHLIST_SIZE_MEDIUM)){
      found = listListener(MECHLIST_ORG_MEDIUM, cursorpos, MECHLIST_SIZE_MEDIUM, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_MEDIUM, 0);
      found = MECHLIST_MEDIUM_ARR[found];
      vsiz = 2;
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_HEAVY, MECHLIST_SIZE_HEAVY)){
      found = listListener(MECHLIST_ORG_HEAVY, cursorpos, MECHLIST_SIZE_HEAVY, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_HEAVY, 0);
      found = MECHLIST_HEAVY_ARR[found];
      vsiz = 3;
    }
    if(found > 0){
      local float change;
      change = FALSE;
      if((PLAYER_HELPER.vec_size == vsiz) && (found != PLAYER_HELPER.plr_sel_mech)){
        change = TRUE;
      }
      if((PLAYER_HELPER.vec_size != vsiz)){
        change = TRUE;
      }
      if(change){
        stashMechConfig();
        PLAYER_HELPER.plr_sel_mech = found;
        PLAYER_HELPER.vec_size = vsiz;
        local entity nxt;
        nxt = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
        cleanHardPoints();
        grabMechConfig(nxt);
        cl_setmech(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
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
   PLAYER_HELPER.plr_sel_wep = found;
   if(PLAYER_HELPER.plr_sel_hrpnt > 0){
    HARDPOINTS[PLAYER_HELPER.plr_sel_hrpnt] = found;
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


//main hook for menu system
void() menu_hangarDrawFrame={
  
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
  menu_hangar_MechDisplay(topleftroot);
  menu_hangar_MechList(topleftroot + gui_percentToPixel(0, 0.025));
  menu_hangar_MechInfo(topleftroot);
  menu_hangar_WeaponList(topleftroot + gui_percentToPixel(0, 0.025));
  menu_hangar_HardPointInfo(topleftroot);
  menu_hangar_WeaponGroupPanel(topleftroot);
  menu_hangar_WeaponInfo(topleftroot + gui_percentToPixel(0, 0.025));
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector nofs, hofs, mpos, i_sz, hpnts;
  nofs = ofs + gui_percentToPixel(0.0828, 0.0437);
  drawpic(nofs, UI_DEF_BOX_512, gui_percentToPixel(0.1367, 0.2604), '1 1 1', HUD_ALPHA, 0);
  drawpic(nofs + gui_percentToPixel(0.0025, 0.005), UI_HANGAR_BOX, gui_percentToPixel(0.132, 0.25), '1 1 1', HUD_ALPHA, 0);
  if(PLAYER_HELPER.plr_sel_mech > 0){
    local entity dat;
    dat = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
    i_sz = draw_getimagesize(dat.c_mdl);
    i_sz = gui_scaleSize(i_sz,VIEW_SCALE);
    i_sz_x = i_sz_x/1.35;
    i_sz_y = i_sz_y/1.35;
    hofs = nofs + gui_percentToPixel(0.0156, 0.025);
    hpnts_x = hofs_x + i_sz_x/2;
    hpnts_y = hofs_y + i_sz_y/2;
    drawpic(hofs, dat.c_mdl, i_sz, '1 1 1', HUD_ALPHA, 0);
    dat.menu_renderHardpoints(hpnts);
    MECHPANEL_CTR = hpnts;
  }
};

void(vector ofs) menu_hangar_MechList={
  drawpic(ofs + gui_percentToPixel(0.0078, 0.0187), UI_DEF_BOX_256_TALL, gui_percentToPixel(0.075, 0.4166), '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixel(0.0062, 0.008), "[AVAILABLE METAL]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  menu_hangar_MechListLight(ofs);
  menu_hangar_MechListMedium(ofs);
  menu_hangar_MechListHeavy(ofs);
};

void(vector ofs) menu_hangar_MechListLight={
  local vector nofs, clr;
  local float ui_lst_cnt, dat_id,ui_lst_act;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(0.0093, 0.025);
  drawstring(nofs + gui_percentToPixel(0.014, 0.002), "==LIGHT==", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  dat_id = 1;
  while(ui_lst_cnt <= 24){
    local entity dat;
    local vector lofs, clr;
    dat = m_findMechData(1, dat_id);
    if(dat && (PLAYER_HELPER.parm7 & dat.data_idx)){
      lofs_x = nofs_x;
      lofs_y = nofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(dat.vec_size == PLAYER_HELPER.vec_size && dat.data_idx == PLAYER_HELPER.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
        gui_renderTintImage(TRUE, lofs - gui_percentToPixel(0.0015, 0.0015), UI_BOX_SELECT, gui_percentToPixel(0.075, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
      MECHLIST_LIGHT_ARR[ui_lst_act] = dat.data_idx;
      ui_lst_act = ui_lst_act + 1;
    }
    dat_id = dat_id * 2;
    ui_lst_cnt = ui_lst_cnt + 1;
  }
  MECHLIST_CNT_LIGHT = ui_lst_act;
  MECHLIST_ORG_LIGHT = nofs;
  MECHLIST_SIZE_LIGHT_x = gui_percentX(0.0687);
  MECHLIST_SIZE_LIGHT_y = gui_percentYRaw(ui_lst_act * 16);
};

void(vector ofs) menu_hangar_MechListMedium={
  local vector nofs, clr;
  local float ui_lst_cnt, dat_id,ui_lst_act;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(0.0093, 0.1562);
  drawstring(nofs + gui_percentToPixel(0.0062, 0.002), "==MEDIUM==", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  dat_id = 1;
  while(ui_lst_cnt <= 24){
    local entity dat;
    local vector lofs, clr;
    dat = m_findMechData(2, dat_id);
    if(dat && (PLAYER_HELPER.parm8 & dat.data_idx)){
      lofs_x = nofs_x;
      lofs_y = nofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(dat.vec_size == PLAYER_HELPER.vec_size && dat.data_idx == PLAYER_HELPER.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
        gui_renderTintImage(TRUE, lofs - gui_percentToPixel(0.0015, 0.0015), UI_BOX_SELECT, gui_percentToPixel(0.075, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
      MECHLIST_MEDIUM_ARR[ui_lst_act] = dat.data_idx;
      ui_lst_act = ui_lst_act + 1;
    }
    dat_id = dat_id * 2;
    ui_lst_cnt = ui_lst_cnt + 1;
  }
  MECHLIST_CNT_MEDIUM = ui_lst_act;
  MECHLIST_ORG_MEDIUM = nofs;
  MECHLIST_SIZE_MEDIUM_x = gui_percentX(0.0687);
  MECHLIST_SIZE_MEDIUM_y = gui_percentYRaw(ui_lst_act * 16);

};
void(vector ofs) menu_hangar_MechListHeavy={
  local vector nofs, clr;
  local float ui_lst_cnt, dat_id,ui_lst_act;
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(0.0093, 0.2864);
  drawstring(nofs + gui_percentToPixel(0.0078, 0.002), "==HEAVY==", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  dat_id = 1;
  while(ui_lst_cnt <= 24){
    local entity dat;
    local vector lofs, clr;
    dat = m_findMechData(3, dat_id);
    if(dat && (PLAYER_HELPER.parm8 & dat.data_idx)){
      lofs_x = nofs_x;
      lofs_y = nofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(dat.vec_size == PLAYER_HELPER.vec_size && dat.data_idx == PLAYER_HELPER.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
        gui_renderTintImage(TRUE, lofs - gui_percentToPixel(0.0015, 0.0015), UI_BOX_SELECT, gui_percentToPixel(0.075, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + gui_percentToPixel(0.0093, 0), dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
      MECHLIST_HEAVY_ARR[ui_lst_act] = dat.data_idx;
      ui_lst_act = ui_lst_act + 1;
    }
    dat_id = dat_id * 2;
    ui_lst_cnt = ui_lst_cnt + 1;
  }
  MECHLIST_CNT_HEAVY = ui_lst_act;
  MECHLIST_ORG_HEAVY = nofs;
  MECHLIST_ORG_HEAVY_y = nofs_y + gui_percentYRaw(10);
  MECHLIST_SIZE_HEAVY_x = gui_percentX(0.0687);
  MECHLIST_SIZE_HEAVY_y = gui_percentYRaw(ui_lst_act * 16);
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + gui_percentX(0.0828);
  nofs_y = VIEW_CTR_y + gui_percentY(0.0666);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixel(0.1367, 0.1562), '1 1 1', HUD_ALPHA, 0);
  
  dat = m_findMechData(PLAYER_HELPER.vec_size, PLAYER_HELPER.plr_sel_mech);
  drawstring(nofs + gui_percentToPixel(0.0281, -0.0083), "[METAL INFO]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0062), strcat("[Name] ", dat.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  local string type;
  local vector t_color;
  // MECH SIZE
  if(dat.vec_size == 1){
    type = "Light";
    t_color = STATUS_AOK;
  }
  else if(dat.vec_size == 2){
    type = "Medium";
    t_color = STATUS_DMG;
  }
  else if(dat.vec_size == 3){
    type = "Heavy";
    t_color = STATUS_REL;
  }
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0166), "[Type] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.1, 0.0166),  type, '6 6 0', t_color, HUD_ALPHA, 0);
  //MECH SPEED
  if(dat.m_fspeed <= 85){
    type = "Slow";
    t_color = STATUS_REL;
  }
  else if(dat.m_fspeed <= 100){
    type = "Normal";
    t_color = STATUS_DMG;
  }
  else  if(dat.m_fspeed <= 200){
    type = "Fast";
    t_color = STATUS_AOK;
  }
  drawstring(nofs + gui_percentToPixel(0.0046, 0.027), "[Speed] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.1, 0.027), type, '6 6 0', t_color, HUD_ALPHA, 0);
  
  //Energy
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0375), "[Max Energy] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.1, 0.0375), ftos(dat.en_max), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0479), "[Energy Recharge] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.1, 0.0479), strcat(ftos(rint(dat.en_rate * 10)),"/sec"), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  //Shield
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0583), "[Max Shield] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.1, 0.0583), ftos(dat.sh_max), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0687), "[Shield Recharge] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.1, 0.0687), strcat(ftos(rint(dat.sh_rate * 10)),"/sec"), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  //Armor rates
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0787), "[Armor] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.01, 0.09), "[Center] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_ctor/1200)*100, nofs + gui_percentToPixel(0.05, 0.0887), gui_percentToPixel(0.08, 0.01), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  drawstring(nofs + gui_percentToPixel(0.01, 0.102), "[Sides] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_stor/1200)*100, nofs + gui_percentToPixel(0.05, 0.102), gui_percentToPixel(0.08, 0.01), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
  drawstring(nofs + gui_percentToPixel(0.01, 0.114), "[Arms] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_arm/1200)*100, nofs + gui_percentToPixel(0.05, 0.114), gui_percentToPixel(0.08, 0.01), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
  drawstring(nofs + gui_percentToPixel(0.01, 0.126), "[Legs] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_ctor/1500)*100, nofs + gui_percentToPixel(0.05, 0.126), gui_percentToPixel(0.08, 0.01), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
};

void(vector ofs) menu_hangar_WeaponList={
  local vector nofs;
  ofs_x = VIEW_CTR_x + gui_percentX(0.1171);
  nofs = ofs;
  nofs = nofs + gui_percentToPixel(0.0093, 0.0125);
  drawpic(ofs + gui_percentToPixel(0.0078, 0.0187), UI_DEF_BOX_256_TALL, gui_percentToPixel(0.1156, 0.4166), '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixel(0.0062, 0.0083), "[AVAILABLE WEAPONS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  menu_hangar_WeaponList_BAL(nofs);
  menu_hangar_WeaponList_ENE(nofs);
  menu_hangar_WeaponList_EXP(nofs);
  menu_hangar_WeaponList_MSC(nofs);
};

void(vector ofs) menu_hangar_WeaponList_BAL={
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

void(vector ofs) menu_hangar_WeaponList_ENE={
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

void(vector ofs) menu_hangar_WeaponList_EXP={
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

void(vector ofs) menu_hangar_WeaponList_MSC={
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

void(vector ofs) menu_hangar_WeaponGroupPanel={
  local vector nofs, col_a, col_b, col_c, col_d, col_e;
  local float lst_idx, bit;
  nofs_x = ofs_x + VIEW_CTR_x - gui_percentX(0.0296);
  nofs_y = ofs_y + VIEW_CTR_y + gui_percentY(0.0541);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixel(0.1531, 0.189), '1 1 1', HUD_ALPHA,0);
  drawstring(nofs + gui_percentToPixel(0.0046, 0.0062), "[GROUPINGS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixel(0.06, 0.0062), "[A] [B] [C] [D] [E]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
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

void(vector ofs) menu_hangar_HardPointInfo={
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

void(vector ofs) menu_hangar_WeaponInfo={
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