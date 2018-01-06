/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview: class file for hangar ui

*/

//hook for input events
void() menu_hangarListener={
  mechSelectListener();
  /*weaponSelectListener();
  hardpointListener();
  hardpointInfoListener();
  weaponGroupPanelListener();*/
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

