/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview: class file for hangar ui

*/

//hook for input events
void() menu_hangarListener={
  mechSelectListener();
  mechAcceptButtonListener();
  weaponSelectListener();
  hardpointListener();
  hardpointInfoListener();
  weaponGroupPanelListener();
};

void() hardpointListener={

  local entity dat;
  local float hpnt;
  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  hpnt = dat.menu_hardpointListener(MECHPANEL_CTR);
  if(hpnt > 0){
    PLAYER_HELPER.plr_sel_hrpnt = hpnt;
    PLAYER_HELPER.plr_sel_wep = HARDPOINTS[hpnt];
  }
};

void() mechSelectListener={
  local float found;
  if(menu_checkMouseInBounds(cursorpos, '32 40', '96 400')){
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT)){
      found = listListener(MECHLIST_ORG_LIGHT, cursorpos, MECHLIST_SIZE_LIGHT, '90 16', MECHLIST_CNT_LIGHT, 0);
      found = MECHLIST_LIGHT_ARR[found];
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_MEDIUM, MECHLIST_SIZE_MEDIUM)){
      found = listListener(MECHLIST_ORG_MEDIUM, cursorpos, MECHLIST_SIZE_MEDIUM, '90 16', MECHLIST_CNT_MEDIUM, 0);
      found = MECHLIST_MEDIUM_ARR[found];
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_HEAVY, MECHLIST_SIZE_HEAVY)){
      found = listListener(MECHLIST_ORG_HEAVY, cursorpos, MECHLIST_SIZE_HEAVY, '90 16', MECHLIST_CNT_HEAVY, 0);
      found = MECHLIST_HEAVY_ARR[found];
    }
    if((found > 0) && (found != PLAYER_HELPER.plr_sel_mech)){
      PLAYER_HELPER.plr_sel_mech = found;
      local entity dat;
      dat = m_findData(found, DATA_MECH);
      HARDPOINT_CNT = dat.hardpoint_cnt;
      cl_setmech(found);
    }
  }
};

void() weaponSelectListener={
  local float found;
  found = listListener(WEPNLIST_ORG, cursorpos, WEPNLIST_SIZE, '96 14', WEPNLIST_CNT, 0);
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_BAL, WEPNLIST_SIZE_BAL)){
    found = listListener(WEPNLIST_ORG_BAL, cursorpos, WEPNLIST_SIZE_BAL, '90 16', WEPNLIST_CNT_BAL, 0);
    found = WEPLIST_BAL_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_ENE, WEPNLIST_SIZE_ENE)){
    found = listListener(WEPNLIST_ORG_ENE, cursorpos, WEPNLIST_SIZE_ENE, '90 16', WEPNLIST_CNT_ENE, 0);
    found = WEPLIST_ENE_ARR[found];
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNLIST_ORG_EXP, WEPNLIST_SIZE_EXP)){
    found = listListener(WEPNLIST_ORG_EXP, cursorpos, WEPNLIST_SIZE_EXP, '90 16', WEPNLIST_CNT_EXP, 0);
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
  local vector ofs;
  ofs_x = VIEW_CTR_x - 26;
  ofs_y = VIEW_CTR_y + 24;
  if(menu_checkMouseInBounds(cursorpos, ofs, '128 128')){
    ofs = ofs + '3 20';
    if(menu_checkMouseInBounds(cursorpos, ofs+'54 0', '18 8')){
      getPrevWeaponGroup();
      //assignWeaponToGroup(getWeaponInHardpoint(PLAYER_HELPER.plr_sel_hrpnt),PLAYER_HELPER.plr_sel_grp);
    }
    if(menu_checkMouseInBounds(cursorpos, ofs+'78 0', '18 8')){
      getNextWeaponGroup();
//assignWeaponToGroup(getWeaponInHardpoint(PLAYER_HELPER.plr_sel_hrpnt),PLAYER_HELPER.plr_sel_grp);
    }
  }
};

void() mechAcceptButtonListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_MAX - '88 24', '64 16')){
    cl_setmech(PLAYER_HELPER.plr_sel_mech);
    local float lst_idx, bit;
    lst_idx = 1;
    bit = 1;
    while(lst_idx <= HARDPOINT_CNT){
      cl_setweapon(bit, HARDPOINTS[lst_idx]);
      bit = bit *2;
      lst_idx = lst_idx + 1;
    }
    cl_setweapongroup(1, PLAYER_HELPER.plr_nex_grp1);
    cl_setweapongroup(2, PLAYER_HELPER.plr_nex_grp2);
    cl_setweapongroup(3, PLAYER_HELPER.plr_nex_grp3);
    cl_spawnmech();
    MENU_ACTIVE = FALSE;
    setcursormode(0);
  }
};

void() weaponGroupPanelListener={
  local float found;
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_A, WEPNGRP_SIZE_A)){
    found = listListener(WEPNGRP_ORG_A, cursorpos, WEPNGRP_SIZE_A, '14 14', WEPNGRP_CNT_A, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp1 & found)){
      PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 - (PLAYER_HELPER.plr_nex_grp1 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 | found;
    }
  }
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_B, WEPNGRP_SIZE_B)){
    found = listListener(WEPNGRP_ORG_B, cursorpos, WEPNGRP_SIZE_B, '14 14', WEPNGRP_CNT_B, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp2 & found)){
      PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 - (PLAYER_HELPER.plr_nex_grp2 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 | found;
    }
  }  
  if(menu_checkMouseInBounds(cursorpos, WEPNGRP_ORG_C, WEPNGRP_SIZE_C)){
    found = listListener(WEPNGRP_ORG_C, cursorpos, WEPNGRP_SIZE_C, '14 14', WEPNGRP_CNT_C, 0);
    found = WEPBITS[found];
    if((PLAYER_HELPER.plr_nex_grp3 & found)){
      PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 - (PLAYER_HELPER.plr_nex_grp3 & found);
    }else{
      PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 | found;
    }
  }
};


//main hook for menu system
void() menu_hangarDrawFrame={
  
  local vector topleftroot;
  topleftroot = VIEW_ORG + '12 12';
  //drawfill(topleftroot, (VIEW_MAX - '24 24'), STATUS_DED, HUD_ALPHA, 0);
  //gui_DrawRect(topleftroot, (VIEW_MAX - '24 24'), '6 4', '1 1 1');
  
  drawpic(topleftroot, UI_DEF_BOX_512,(VIEW_MAX - '24 24'), '1 1 1', HUD_ALPHA, 0);
  
  menu_hangar_DrawNavBar(topleftroot);
  menu_hangar_MechDisplay(topleftroot);
  menu_hangar_MechList(topleftroot + '0 24');
  
  menu_hangar_MechInfo(topleftroot);
  menu_hangar_WeaponList(topleftroot + '0 24');
  menu_hangar_HardPointInfo(topleftroot);
  menu_hangar_WeaponGroupPanel(topleftroot);
};

void(vector ofs) menu_hangar_DrawNavBar={
  local vector nvpos;
  nvpos = ofs + '8 6';
  
  gui_DrawRect(nvpos, '48 16', '6 4', '1 1 1');
  drawstring(nvpos + '0 4', "[HANGAR]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawRect(nvpos+'48 0', '64 16', '6 4', '1 1 1');
  drawstring(nvpos + '48 4', "[BRIEFING]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawRect(VIEW_MAX - '88 24', '64 16', '6 4', '1 1 1');
  drawstring(VIEW_MAX - '88 24', "[ACCEPT]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector nofs, hofs, mpos, i_sz, hpnts;
  nofs = ofs + '106 42';
  drawpic(nofs, UI_DEF_BOX_512, '175 250', '1 1 1', HUD_ALPHA, 0);
  local entity dat;
  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  i_sz = draw_getimagesize(dat.c_mdl);
  i_sz = gui_scaleSize(i_sz,VIEW_SCALE);
  i_sz_x = i_sz_x/1.35;
  i_sz_y = i_sz_y/1.35;
  hofs = nofs + '20 24';
  hpnts_x = hofs_x + i_sz_x/2;
  hpnts_y = hofs_y + i_sz_y/2;
  drawpic(hofs, dat.c_mdl, i_sz, '1 1 1', HUD_ALPHA, 0);
  dat.menu_renderHardpoints(hpnts);
  MECHPANEL_CTR = hpnts;
};

void(vector ofs) menu_hangar_MechList={
  drawpic(ofs + '10 18', UI_DEF_BOX_256_TALL, '96 400', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '8 8', "[AVAILABLE METAL]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  menu_hangar_MechListLight(ofs);
  menu_hangar_MechListMedium(ofs);
  menu_hangar_MechListHeavy(ofs);
};

void(vector ofs) menu_hangar_MechListLight={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 24';
  drawstring(nofs + '18 2', "==LIGHT==", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 3){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_MECH);
    if(dat){
      if(dat.vec_size == 1){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 16);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_mech){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
        MECHLIST_LIGHT_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  MECHLIST_CNT_LIGHT = act_idx;
  MECHLIST_ORG_LIGHT = nofs;
  MECHLIST_SIZE_LIGHT_x = 88;
  MECHLIST_SIZE_LIGHT_y = (act_idx * 16);
};

void(vector ofs) menu_hangar_MechListMedium={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 150';
  drawstring(nofs + '8 2', "==MEDIUM==", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 3){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_MECH);
    if(dat){
      if(dat.vec_size == 2){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 16);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_mech){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
        MECHLIST_MEDIUM_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  MECHLIST_CNT_MEDIUM = act_idx;
  MECHLIST_ORG_MEDIUM = nofs;
  MECHLIST_SIZE_MEDIUM_x = 88;
  MECHLIST_SIZE_MEDIUM_y = (act_idx * 16);

};
void(vector ofs) menu_hangar_MechListHeavy={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 275';
  drawstring(nofs + '10 2', "==HEAVY==", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 3){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_MECH);
    if(dat){
      if(dat.vec_size == 3){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 16);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_mech){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
        MECHLIST_HEAVY_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  MECHLIST_CNT_HEAVY = act_idx;
  MECHLIST_ORG_HEAVY = nofs;
  MECHLIST_SIZE_HEAVY_x = 88;
  MECHLIST_SIZE_HEAVY_y = (act_idx * 16);
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + 106;
  nofs_y = VIEW_CTR_y + 64;
  drawpic(nofs, UI_DEF_BOX_256, '175 150', '1 1 1', HUD_ALPHA, 0);
  
  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  drawstring(nofs + '36 -8', "[METAL INFO]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '6 6', strcat("[NAME] ", dat.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
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
  drawstring(nofs + '6 16', "[TYPE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '48 16',  type, '6 6 0', t_color, HUD_ALPHA, 0);
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
  drawstring(nofs + '6 26', "[SPEED] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '56 26', type, '6 6 0', t_color, HUD_ALPHA, 0);
  
  //Energy
  drawstring(nofs + '6 36', "[MAX ENERGY] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '78 36', ftos(dat.en_max), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  drawstring(nofs + '6 46', "[ENERGY RECHARGE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '112 46', strcat(ftos(rint(dat.en_rate * 10)),"/sec"), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  //Shield
  drawstring(nofs + '6 56', "[MAX SHIELD] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '78 56', ftos(dat.sh_max), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
  drawstring(nofs + '6 66', "[SHIELD RECHARGE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '112 66', strcat(ftos(rint(dat.sh_rate * 10)),"/sec"), '6 6 0', STATUS_REL, HUD_ALPHA, 0);
};

void(vector ofs) menu_hangar_WeaponList={
  local vector nofs;
  ofs_x = VIEW_CTR_x + 160;
  nofs = ofs;
  nofs = nofs + '12 12';
  drawpic(ofs + '10 18', UI_DEF_BOX_256_TALL, '128 400', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '8 8', "[AVAILABLE WEAPONS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  menu_hangar_WeaponList_BAL(nofs);
  menu_hangar_WeaponList_ENE(nofs);
  menu_hangar_WeaponList_EXP(nofs);
  menu_hangar_WeaponList_MSC(nofs);
};

void(vector ofs) menu_hangar_WeaponList_BAL={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 12';
  drawstring(nofs + '10 2', "==BALLISTIC==", '6 6 0', CLR_DEF_ARM_HALF, HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_BAL)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 16);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.w_name, '6 6 0', clr, HUD_ALPHA, 0);
        WEPLIST_BAL_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_BAL = act_idx;
  WEPNLIST_ORG_BAL = nofs;
  WEPNLIST_SIZE_BAL_x = 88;
  WEPNLIST_SIZE_BAL_y = (act_idx * 16);
};

void(vector ofs) menu_hangar_WeaponList_ENE={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 100';
  drawstring(nofs + '10 2', "==ENERGY==", '6 6 0', CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2', HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_ENE)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 16);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.w_name, '6 6 0', clr, HUD_ALPHA, 0);
        WEPLIST_ENE_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_ENE = act_idx;
  WEPNLIST_ORG_ENE = nofs;
  WEPNLIST_SIZE_ENE_x = 88;
  WEPNLIST_SIZE_ENE_y = (act_idx * 16);
};

void(vector ofs) menu_hangar_WeaponList_EXP={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 190';
  drawstring(nofs + '10 2', "==MISSILE==", '6 6 0', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_EXP)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 16);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.w_name, '6 6 0', clr, HUD_ALPHA, 0);
        WEPLIST_EXP_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_EXP = act_idx;
  WEPNLIST_ORG_EXP = nofs;
  WEPNLIST_SIZE_EXP_x = 88;
  WEPNLIST_SIZE_EXP_y = (act_idx * 16);
};

void(vector ofs) menu_hangar_WeaponList_MSC={
  local vector nofs, clr;
  local float lst_idx, act_idx;
  nofs = ofs;
  nofs = nofs + '12 275';
  drawstring(nofs + '4 2', "==MISCELLANEOUS==", '6 6 0', CLR_DEF_RET_GETLOCK, HUD_ALPHA, 0);
  act_idx = 1;
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      if((dat.dmg_type & DMG_MSC)){
        lofs_x = nofs_x;
        lofs_y = nofs_y + (act_idx * 14);
        if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
          clr = CLR_DEF_TXT_HIGHLIGHT;
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        drawstring(lofs + '12 0', dat.w_name, '6 6 0', clr, HUD_ALPHA, 0);
        WEPLIST_MSC_ARR[act_idx] = dat.data_idx;
        act_idx = act_idx + 1;
      }
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT_MSC = act_idx;
  WEPNLIST_ORG_MSC = nofs;
  WEPNLIST_SIZE_MSC_x = 88;
  WEPNLIST_SIZE_MSC_y = (act_idx * 14);
};

void(vector ofs) menu_hangar_WeaponGroupPanel={
  local vector nofs, col_a, col_b, col_c;
  local float lst_idx, bit;
  nofs_x = ofs_x + VIEW_CTR_x - 38;
  nofs_y = ofs_y + VIEW_CTR_y + 52;
  drawpic(nofs, UI_DEF_BOX_256, '196 150', '1 1 1', HUD_ALPHA,0);
  drawstring(nofs + '48 6', "[WEAPON GROUPINGS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '124 16', "[A] [B] [C]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  nofs = nofs + '0 12';
  col_a = nofs + '126 12';
  col_b = nofs + '150 12';
  col_c = nofs + '172 12';
  lst_idx = 1;
  bit = 1;
  while((lst_idx <= HARDPOINT_CNT)){
    local vector lofs;
    local string line;
    local entity dat;
    lofs_x = nofs_x + 6 ;
    lofs_y = nofs_y + (lst_idx * 14);
    line = strcat("[",ftos(lst_idx),"]");
    dat = m_findData(HARDPOINTS[lst_idx], DATA_WEPN);
    line = strcat(line, " ", dat.w_name);
    drawstring(lofs, line, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp1 & bit),  lofs + '120 -2', UI_DEF_BOX_256, '14 14', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp2 & bit),  lofs + '144 -2', UI_DEF_BOX_256, '14 14', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    gui_renderTintImage((PLAYER_HELPER.plr_nex_grp3 & bit),  lofs + '166 -2', UI_DEF_BOX_256, '14 14', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    bit = bit * 2;
    lst_idx = lst_idx + 1;
  }
  lst_idx = lst_idx - 1;
  WEPNGRP_CNT_A = lst_idx;
  WEPNGRP_CNT_B = lst_idx;
  WEPNGRP_CNT_C = lst_idx;
  WEPNGRP_ORG_A = col_a;
  WEPNGRP_ORG_B = col_b;
  WEPNGRP_ORG_C = col_c;
  WEPNGRP_SIZE_A_x = WEPNGRP_SIZE_B_x = WEPNGRP_SIZE_C_x = 14;
  WEPNGRP_SIZE_A_y = WEPNGRP_SIZE_B_y = WEPNGRP_SIZE_C_y = ((lst_idx) * 14);
  gui_DrawRect(WEPNGRP_ORG_A, WEPNGRP_SIZE_A, '6 4', '1 1 1');
  gui_DrawRect(WEPNGRP_ORG_B, WEPNGRP_SIZE_B, '6 4', '1 1 1');
  gui_DrawRect(WEPNGRP_ORG_C, WEPNGRP_SIZE_C, '6 4', '1 1 1');
};

void(vector ofs) menu_hangar_HardPointInfo={
  local vector nofs, max;
  local entity dat;
  nofs_x = ofs_x + VIEW_CTR_x - 38;
  nofs_y = ofs_y + 42;
  //gui_DrawRect(nofs, '196 128', '6 4', '1 1 1');
  drawpic(nofs, UI_DEF_BOX_256, '196 128', '1 1 1', HUD_ALPHA, 0);
  local string title;
  local float tlen;
  local vector tpos;
  title = "[HARDPOINT]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + '64 3';
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  dat = m_findData(HARDPOINTS[PLAYER_HELPER.plr_sel_hrpnt], DATA_WEPN);
  local string wepname_row;
  local vector wnpos;
  wepname_row = strcat("[WEAPON]: ", dat.w_name);
  wnpos = nofs + '3 12';
  drawstring(wnpos, wepname_row, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  local string wepgrp_row;
  local vector wgpos;
  wepgrp_row = strcat("[GROUP]:    ", ftos(checkIfWeaponInGroup(PLAYER_HELPER.plr_sel_wid)));
  wgpos = nofs + '3 20';
  drawstring(wgpos, wepgrp_row, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(wgpos+'54 0', "[<]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(wgpos+'78 0', "[>]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};


void() getNextWeaponGroup={
  PLAYER_HELPER.plr_sel_grp = PLAYER_HELPER.plr_sel_grp + 1;
  if(PLAYER_HELPER.plr_sel_grp > 3){
    PLAYER_HELPER.plr_sel_grp = 1;
  }
};

void() getPrevWeaponGroup={
  PLAYER_HELPER.plr_sel_grp = PLAYER_HELPER.plr_sel_grp - 1;
  if(PLAYER_HELPER.plr_sel_grp <= 0){
    PLAYER_HELPER.plr_sel_grp = 3;
  }
};

void(float wep_id, float group) assignWeaponToGroup={
};

float(float comp) checkIfWeaponInGroup={
  if((PLAYER_HELPER.plr_nex_grp1 & comp)){
    return 1;
  }
  else if((PLAYER_HELPER.plr_nex_grp2 & comp)){
    return 2;
  }  
  else if((PLAYER_HELPER.plr_nex_grp3 & comp)){
    return 3;
  }
  else{
    return 0;
  }
};
