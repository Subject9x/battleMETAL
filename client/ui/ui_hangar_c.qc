/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview: class file for hangar ui

*/
vector MECHPANEL_CTR;
vector MECHLIST_SIZE;
vector MECHLIST_ORG;
vector MECHLIST_SIZE;
vector WEPNLIST_ORG;
vector WEPNLIST_SIZE;
float MECHLIST_CNT;
float WEPNLIST_CNT;

//hook for input events
void() menu_hangarListener={
  mechSelectListener();
  mechAcceptButtonListener();
  weaponSelectListener();
  hardpointListener();
  hardpointInfoListener();
};

void() hardpointListener={

  local entity dat;
  local float hpnt;
  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  hpnt = dat.menu_hardpointListener(MECHPANEL_CTR);
  if(hpnt > 0){
    PLAYER_HELPER.plr_sel_hrpnt = hpnt;
    PLAYER_HELPER.plr_sel_wep = getWeaponInHardpoint(hpnt);
  }
};

void() mechSelectListener={
  local float found;
  if(menu_checkMouseInBounds(cursorpos, '32 40', '96 400')){
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG, MECHLIST_SIZE)){
      found = listListener(MECHLIST_ORG, cursorpos, MECHLIST_SIZE, '90 16', 3, 0);
    }
    if((found > 0) && (found != PLAYER_HELPER.plr_sel_mech)){
      PLAYER_HELPER.plr_sel_mech = found;
      cl_setmech(found);
    }
  }
};

void() weaponSelectListener={
  local float found;
  found = listListener(WEPNLIST_ORG, cursorpos, WEPNLIST_SIZE, '96 14', WEPNLIST_CNT, 0);
  if(found  > 0){
   PLAYER_HELPER.plr_sel_wep = found;
   if(PLAYER_HELPER.plr_sel_hrpnt > 0){
    local float cur_point;
    cur_point = PLAYER_HELPER.plr_sel_hrpnt;
    if(cur_point == 1){
      PLAYER_HELPER.plr_nex_wep1 = PLAYER_HELPER.plr_sel_wep;
    }
    else if(cur_point == 2){
      PLAYER_HELPER.plr_nex_wep2 = PLAYER_HELPER.plr_sel_wep; 
    }
    else if(cur_point == 3){
      PLAYER_HELPER.plr_nex_wep3 = PLAYER_HELPER.plr_sel_wep;
    }
    else if(cur_point == 4){
      PLAYER_HELPER.plr_nex_wep4 = PLAYER_HELPER.plr_sel_wep;
    }
    else if(cur_point == 5){
      PLAYER_HELPER.plr_nex_wep5 = PLAYER_HELPER.plr_sel_wep; 
    }
    else if(cur_point == 6){
       PLAYER_HELPER.plr_nex_wep6 = PLAYER_HELPER.plr_sel_wep;
    }
    else if(cur_point == 7){
      PLAYER_HELPER.plr_nex_wep7 = PLAYER_HELPER.plr_sel_wep;
    }
    else if(cur_point == 8){
       PLAYER_HELPER.plr_nex_wep8 = PLAYER_HELPER.plr_sel_wep;
    }
    else if(cur_point == 9){
      PLAYER_HELPER.plr_nex_wep9 = PLAYER_HELPER.plr_sel_wep;
    }
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
      assignWeaponToGroup(getWeaponInHardpoint(PLAYER_HELPER.plr_sel_hrpnt),PLAYER_HELPER.plr_sel_grp);
    }
    if(menu_checkMouseInBounds(cursorpos, ofs+'78 0', '18 8')){
      getNextWeaponGroup();
      assignWeaponToGroup(getWeaponInHardpoint(PLAYER_HELPER.plr_sel_hrpnt),PLAYER_HELPER.plr_sel_grp);
    }
  }
};

void() mechAcceptButtonListener={
  if(menu_checkMouseInBounds(cursorpos, VIEW_MAX - '88 24', '64 16')){
    cl_setmech(PLAYER_HELPER.plr_sel_mech);
    cl_setweapon(WEAPON1, PLAYER_HELPER.plr_nex_wep1);
    cl_setweapon(WEAPON2, PLAYER_HELPER.plr_nex_wep2); 
    cl_setweapon(WEAPON3, PLAYER_HELPER.plr_nex_wep3);
    cl_setweapon(WEAPON4, PLAYER_HELPER.plr_nex_wep4);
    cl_setweapon(WEAPON5, PLAYER_HELPER.plr_nex_wep5);
    cl_setweapon(WEAPON6, PLAYER_HELPER.plr_nex_wep6); 
    cl_setweapon(WEAPON7, PLAYER_HELPER.plr_nex_wep7);
    cl_setweapon(WEAPON8, PLAYER_HELPER.plr_nex_wep8);      
    cl_setweapon(WEAPON9, PLAYER_HELPER.plr_nex_wep9);
    cl_setweapongroup(1, PLAYER_HELPER.plr_nex_grp1);
    cl_setweapongroup(2, PLAYER_HELPER.plr_nex_grp2);
    cl_setweapongroup(3, PLAYER_HELPER.plr_nex_grp3);
    cl_spawnmech();
    MENU_ACTIVE = FALSE;
    setcursormode(0);
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
  MECHLIST_SIZE_x = 96;
  MECHLIST_SIZE_y = 400;
  menu_hangar_MechListLight(ofs);
};

void(vector ofs) menu_hangar_MechListLight={
  local vector nofs, clr;
  local float lst_idx;
  nofs = ofs;
  nofs = nofs + '12 12';
  lst_idx = 1;
  while(lst_idx <= 3){
    local entity dat;
    local vector lofs, clr;
    dat = m_findData(lst_idx, DATA_MECH);
    if(dat){
      lofs_x = nofs_x;
      lofs_y = nofs_y + (lst_idx * 16);
      if(dat.data_idx == PLAYER_HELPER.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + '12 0', dat.vec_name, '6 6 0', clr, HUD_ALPHA, 0);
    }
    lst_idx = lst_idx + 1;
  }
  MECHLIST_CNT = lst_idx;
  MECHLIST_ORG = nofs;
  MECHLIST_SIZE_x = 88;
  MECHLIST_SIZE_y = (lst_idx * 16) ;
  //gui_DrawRect(MECHLIST_ORG,MECHLIST_SIZE, '4 4', '1 1 1'); //debug
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + 106;
  nofs_y = VIEW_CTR_y + 64;
  drawpic(nofs, UI_DEF_BOX_256, '175 150', '1 1 1', HUD_ALPHA, 0);
  gui_DrawRect(nofs, '150 150', '6 4', '1 1 1');

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
  local vector nofs, clr;
  local float lst_idx;
  ofs_x = VIEW_CTR_x + 160;
  nofs = ofs;
  nofs = nofs + '12 12';
  drawpic(ofs + '10 18', UI_DEF_BOX_256_TALL, '128 400', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '8 8', "[AVAILABLE WEAPONS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs;
    local vector clr;
    dat = m_findData(lst_idx, DATA_WEPN);
    if(dat){
      lofs_x = nofs_x;
      lofs_y = nofs_y + (lst_idx * 14);
      if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
        clr = CLR_DEF_TXT_HIGHLIGHT;
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + '12 0', dat.w_name, '6 6 0', clr, HUD_ALPHA, 0);
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_CNT = lst_idx;
  WEPNLIST_ORG = nofs;
  WEPNLIST_SIZE_x = 96;
  WEPNLIST_SIZE_y = (lst_idx * 14);
  //gui_DrawRect(MECHLIST_ORG,MECHLIST_SIZE, '4 4', '1 1 1'); //debug
};

void(vector ofs) menu_hangar_HardPointInfo={
  local vector nofs, max;
  local entity dat;
  nofs_x = ofs_x + VIEW_CTR_x - 38;
  nofs_y = ofs_y + VIEW_CTR_y + 12;
  gui_DrawRect(nofs, '128 128', '6 4', '1 1 1');
  
  local string title;
  local float tlen;
  local vector tpos;
  title = "[HARDPOINT]";
  tlen = stringwidth(title, 0, '6 6 0');
  tpos = nofs + '64 3';
  tpos_x = tpos_x - tlen/2;
  drawstring(tpos, title, '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  dat = m_findData(getWeaponInHardpoint(PLAYER_HELPER.plr_sel_hrpnt), DATA_WEPN);
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

void(float wep_id, float grp_id) assignWeaponToGroup={
  if(grp_id == 1){
    PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 | wep_id;
    PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 - (PLAYER_HELPER.plr_nex_grp2 & wep_id);
    PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 - (PLAYER_HELPER.plr_nex_grp3 & wep_id);
  }
  else if(grp_id == 2){
    PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 | wep_id;
    PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 - (PLAYER_HELPER.plr_nex_grp1 & wep_id);
    PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 - (PLAYER_HELPER.plr_nex_grp3 & wep_id);
  }
  else if(grp_id == 3){
    PLAYER_HELPER.plr_nex_grp3 = PLAYER_HELPER.plr_nex_grp3 | wep_id;
    PLAYER_HELPER.plr_nex_grp2 = PLAYER_HELPER.plr_nex_grp2 - (PLAYER_HELPER.plr_nex_grp2 & wep_id);
    PLAYER_HELPER.plr_nex_grp1 = PLAYER_HELPER.plr_nex_grp1 - (PLAYER_HELPER.plr_nex_grp1 & wep_id);
  }
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

float(float slotid) getWeaponInHardpoint={
  if(slotid == 1){
    return PLAYER_HELPER.plr_nex_wep1;
  }
  else if(slotid == 2){
    return PLAYER_HELPER.plr_nex_wep2;    
  }
  else if(slotid == 3){
    return PLAYER_HELPER.plr_nex_wep3;    
  }
  else if(slotid == 4){
    return PLAYER_HELPER.plr_nex_wep4;    
  }
  else if(slotid == 5){
    return PLAYER_HELPER.plr_nex_wep5;    
  }
  else if(slotid == 6){
    return PLAYER_HELPER.plr_nex_wep6;   
  }
  else if(slotid == 7){
    return PLAYER_HELPER.plr_nex_wep7;    
  }
  else if(slotid == 8){
    return PLAYER_HELPER.plr_nex_wep8;   
  }
  else if(slotid == 9){
    return PLAYER_HELPER.plr_nex_wep9;    
  }
  else{
    return 0;
  }
};