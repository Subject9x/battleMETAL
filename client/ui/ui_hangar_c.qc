/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview: class file for hangar ui

*/
vector MECHPANEL_CTR;
vector MECHLIST_SIZE;
vector WEPNLIST_SIZE;

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
  found = listListener('24 36', cursorpos, MECHLIST_SIZE, '64 12', 3, 0);
  if(found  > 0){
    if(found != PLAYER_HELPER.plr_sel_mech){
        cl_setmech(found);
    }
    PLAYER_HELPER.plr_sel_mech = found;
  }
};

void() weaponSelectListener={
  local float found;
  local vector lofs;
  lofs_x = VIEW_CTR_x + 128;
  lofs_y = 24;
  gui_DrawRect(lofs, lofs + WEPNLIST_SIZE, '6 4', '1 1 1');
  found = listListener(lofs, cursorpos, WEPNLIST_SIZE, '96 12', 10, 0);
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
  drawfill(topleftroot, (VIEW_MAX - '24 24'), STATUS_DED, HUD_ALPHA, 0); 
  gui_DrawRect(topleftroot, (VIEW_MAX - '24 24'), '6 4', '1 1 1');

  menu_hangar_DrawNavBar(topleftroot);
  menu_hangar_MechDisplay(topleftroot);
  menu_hangar_MechList(topleftroot + '0 24');
  menu_hangar_MechInfo(topleftroot);
  menu_hangar_WeaponList(topleftroot);
  menu_hangar_HardPointInfo(topleftroot);
};

void(vector ofs) menu_hangar_DrawNavBar={

  gui_DrawRect(ofs, '48 16', '6 4', '1 1 1');
  drawstring(ofs + '0 4', "[HANGAR]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawRect(ofs+'48 0', '64 16', '6 4', '1 1 1');
  drawstring(ofs + '48 4', "[BRIEFING]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawRect(VIEW_MAX - '88 24', '64 16', '6 4', '1 1 1');
  drawstring(VIEW_MAX - '88 24', "[ACCEPT]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector nofs, hofs, mpos, i_sz, hpnts;
  nofs = ofs + '116 24';
  gui_DrawRect(nofs, (VIEW_MAX - '336 256'), '6 4', '1 1 1');
  local entity dat;
  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  i_sz = draw_getimagesize(dat.c_mdl);
  i_sz = gui_scaleSize(i_sz,VIEW_SCALE);
  i_sz_x = i_sz_x/1.5;
  i_sz_y = i_sz_y/1.5;
  hofs_x = (nofs_x + ((VIEW_MAX_x - 300)/2));
  hofs_y = nofs_y;
  hofs_x = hofs_x - i_sz_x/2;
  hpnts_x = hofs_x + i_sz_x/2;
  hpnts_y = hofs_y + i_sz_y/2;
  drawpic(hofs, dat.c_mdl, i_sz, '1 1 1', HUD_ALPHA, 0);
  dat.menu_renderHardpoints(hpnts);
  MECHPANEL_CTR = hpnts;
};

void(vector ofs) menu_hangar_MechList={
  local vector nofs,sz;
  local float lst_idx, found;
  nofs = sz = ofs;
  drawstring(ofs + '24 0', "[MECHS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  lst_idx = 1;
  while(lst_idx <= 3){
    local entity dat;
    local vector lofs;
    dat = m_findData(lst_idx, DATA_MECH);
    lofs_x = ofs_x + 12;
    lofs_y = ofs_y + (lst_idx * 12);
    drawstring(lofs, dat.vec_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(dat.data_idx == PLAYER_HELPER.plr_sel_mech){
      gui_DrawRect(lofs, '64 12', '4 4', '1 1 1');
    }
    sz_x = sz_x + lofs_x;
    sz_y = sz_y + lofs_y;
    lst_idx = lst_idx + 1;
  }
  MECHLIST_SIZE_x = 64;
  MECHLIST_SIZE_y = (lst_idx * 12)+12;
  
};


void(vector ofs) menu_hangar_MechInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + 116;
  nofs_y = VIEW_CTR_y + 24;
  gui_DrawRect(nofs, (nofs + '32 8'), '6 4', '1 1 1');

  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  drawstring(nofs + '6 6', "[INFO]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '6 12', strcat("[NAME] ", dat.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
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
  drawstring(nofs + '6 18', "[TYPE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '48 18',  type, '6 6 0', t_color, HUD_ALPHA, 0);
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
  drawstring(nofs + '6 24', "[SPEED] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + '56 24', type, '6 6 0', t_color, HUD_ALPHA, 0);
};

void(vector offset) menu_hangar_WeaponList={
  local vector ofs, mx;
  local entity dat;
  local float lst_idx;
  ofs_x = VIEW_CTR_x + 128;
  ofs_y = 24;
  mx_x = 128;
  mx_y = VIEW_MAX_y - 64;
  //gui_DrawRect(ofs, mx, '6 4', '1 1 1');
  lst_idx = 1;
  while(lst_idx <= 10){
    local entity dat;
    local vector lofs;
    dat = m_findData(lst_idx, DATA_WEPN);
    lofs_x = ofs_x + 12;
    lofs_y = ofs_y + (lst_idx * 12);
    drawstring(lofs, strcat(ftos(lst_idx),": ",dat.w_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(dat.data_idx == PLAYER_HELPER.plr_sel_wep){
      gui_DrawRect(lofs, '96 12', '4 4', '1 1 1');
    }
    lst_idx = lst_idx + 1;
  }
  WEPNLIST_SIZE_x = 96;
  WEPNLIST_SIZE_y = (lst_idx * 12) + 12;
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