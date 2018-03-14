/*
mech Mod
Author: Peter Roohr
Date: 3/8/2017
Overview: class file for hangar ui

*/

//hook for input events
void() menu_hangarListener={
  mechSelectListener();
};

void() hardpointListener={
  local entity dat;
  local float hpnt;
  dat = m_findMechData(self.plr_sel_size, self.plr_sel_mech);
  if(dat != world){
    hpnt = dat.menu_hardpointListener(MECHPANEL_CTR);
    if(hpnt > 0){
      self.plr_sel_hrpnt = hpnt;
      self.plr_sel_wep = HARDPOINTS[hpnt];
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
      if((self.plr_sel_size == vsiz) && (found != self.plr_sel_mech)){
        change = TRUE;
      }
      if((self.plr_sel_size != vsiz)){
        change = TRUE;
      }
      if(change){
        stashMechConfig();
        self.plr_sel_mech = found;
        self.plr_sel_size = vsiz;
        local entity nxt;
        nxt = m_findMechData(self.plr_sel_size, self.plr_sel_mech);
        cleanHardPoints();
        grabMechConfig(nxt);
        cl_setmech(self.plr_sel_size, self.plr_sel_mech);
      }
    }
  }
};

//main hook for menu system
void() menu_hangarDrawFrame={
  
  if(self.plr_sel_mech <= 0){
    self.plr_sel_mech = 1;
    self.plr_sel_size = 1;
    local entity dat;
    cleanHardPoints();
    dat = m_findMechData(1,1);
    grabMechConfig(dat);
    cl_setmech(1, 1); 
  }
  
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '1 1 1', HUD_ALPHA, 0);
  menu_hangar_MechDisplay(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_hangar_MechList(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_hangar_MechInfo(topleftroot);
  menu_hangar_MechFluff(topleftroot);
  menu_hangar_MechHPoints(topleftroot);
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector nofs, hofs, mpos, i_sz, hpnts;
  nofs = ofs + gui_percentToPixelRawVec('420 8');
  drawpic(nofs, UI_DEF_BOX_512, gui_percentToPixelRawVec('175 250'), '1 1 1', HUD_ALPHA, 0);
  drawpic(nofs + gui_percentToPixelRawVec('3 5'), UI_HANGAR_BOX, gui_percentToPixelRawVec('168 240'), '1 1 1', HUD_ALPHA, 0);
  if(self.plr_sel_mech > 0){
    local entity dat;
    dat = m_findMechData(self.plr_sel_size, self.plr_sel_mech);
    i_sz = draw_getimagesize(dat.c_mdl);
    i_sz = gui_scaleSize(i_sz,VIEW_SCALE);
    i_sz_x = i_sz_x/1.2;
    i_sz_y = i_sz_y/1.2;
    hofs_x = nofs_x + (gui_percentXRaw(171) -  gui_percentXRaw(i_sz_x)) / 2;
    hofs_y = nofs_y + gui_percentYRaw(240) - gui_percentYRaw(i_sz_y);
    drawpic(hofs, dat.c_mdl, i_sz, '1 1 1', HUD_ALPHA, 0);
    hpnts_x = hofs_x + gui_percentXRaw(i_sz_x/2);
    hpnts_y = hofs_y + gui_percentYRaw(i_sz_y/2);
    MECHPANEL_CTR = hpnts;
    dat.menu_renderHardpoints(hpnts);
  }
};

void(vector ofs) menu_hangar_MechHPoints={
  local vector nofs, tofs;
  local float tlen;
  local entity dat;
  nofs = ofs + gui_percentToPixelRawVec('365 272');
  drawpic(nofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('255 192'), '1 1 1', HUD_ALPHA, 0);
  
  tlen = strlen("[HARDPOINTS]");
  tofs = nofs;
  tofs_x = tofs_x + gui_percentXRaw((255/2) - (tlen/2));
  tofs_y = tofs_y + gui_percentYRaw(16);
  drawstring(tofs, "[HARDPOINTS]", '6 6 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('16 24'), "[hardpoint]", '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
  drawstring(nofs + gui_percentToPixelRawVec('125 24'), "[types]", '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
  drawstring(nofs + gui_percentToPixelRawVec('222 24'), "[size]", '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
  if(self.plr_sel_mech > 0){
    dat = m_findMechData(self.plr_sel_size, self.plr_sel_mech);
    dat.menu_hardpointRows(nofs + gui_percentToPixelRawVec('16 24'));
  }
};


void(vector ofs) menu_hangar_MechList={
  drawpic(ofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('116 440'), '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + gui_percentToPixelRawVec('16 16'), "[AVAILABLE METAL]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  menu_hangar_MechListLight(ofs);
  menu_hangar_MechListMedium(ofs);
  menu_hangar_MechListHeavy(ofs);
};

void(vector ofs) menu_hangar_MechListLight={
  local vector nofs, clr, sofs;
  local float ui_lst_cnt, dat_id,ui_lst_act;
  nofs = ofs;
  nofs = nofs + gui_percentToPixelRawVec('16 24');
  drawstring(nofs + gui_percentToPixelRawVec('0 1'), "======LIGHT======", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  dat_id = 1;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= 24){
    local entity dat;
    local vector lofs, clr;
    dat = m_findMechData(1, dat_id);
    if(dat && (self.parm7 & dat.data_idx)){
      lofs_x = sofs_x;
      lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(dat.vec_size == self.plr_sel_size && dat.data_idx == self.plr_sel_mech){
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
  MECHLIST_ORG_LIGHT = sofs;
  MECHLIST_ORG_LIGHT_y = nofs_y + gui_percentYRaw(10);
  MECHLIST_SIZE_LIGHT_x = gui_percentX(0.0687);
  MECHLIST_SIZE_LIGHT_y = gui_percentYRaw(ui_lst_act * 16);
};
void(vector ofs) menu_hangar_MechListMedium={
  local vector nofs, clr, sofs;
  local float ui_lst_cnt, dat_id,ui_lst_act;
  nofs = ofs;
  nofs = nofs + gui_percentToPixelRawVec('16 150');
  drawstring(nofs + gui_percentToPixelRawVec('0 2'), "======MEDIUM======", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  dat_id = 1;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= 24){
    local entity dat;
    local vector lofs, clr;
    dat = m_findMechData(2, dat_id);
    if(dat && (self.parm8 & dat.data_idx)){
      lofs_x = sofs_x;
      lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(dat.vec_size == self.plr_sel_size && dat.data_idx == self.plr_sel_mech){
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
  MECHLIST_ORG_MEDIUM = sofs;
  MECHLIST_ORG_MEDIUM_y = nofs_y + gui_percentYRaw(10);
  MECHLIST_SIZE_MEDIUM_x = gui_percentX(0.0687);
  MECHLIST_SIZE_MEDIUM_y = gui_percentYRaw(ui_lst_act * 16);
};
void(vector ofs) menu_hangar_MechListHeavy={
  local vector nofs, clr, sofs;
  local float ui_lst_cnt, dat_id,ui_lst_act;
  nofs = ofs;
  nofs = nofs + gui_percentToPixelRawVec('16 275');
  drawstring(nofs + gui_percentToPixelRawVec('0 2'), "======HEAVY======", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  dat_id = 1;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= 24){
    local entity dat;
    local vector lofs, clr;
    dat = m_findMechData(3, dat_id);
    if(dat && (self.parm8 & dat.data_idx)){
      lofs_x = sofs_x;
      lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(dat.vec_size == self.plr_sel_size && dat.data_idx == self.plr_sel_mech){
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
  MECHLIST_ORG_HEAVY = sofs;
  MECHLIST_ORG_HEAVY_y = nofs_y + gui_percentYRaw(10);
  MECHLIST_SIZE_HEAVY_x = gui_percentX(0.0687);
  MECHLIST_SIZE_HEAVY_y = gui_percentYRaw(ui_lst_act * 16);
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs;
  local entity dat;
  nofs_x = ofs_x + gui_percentXRaw(125);
  nofs_y = ofs_y + gui_percentYRaw(43);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('250 180'), CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  dat = m_findMechData(self.plr_sel_size, self.plr_sel_mech);
  local float slen;
  slen = strlen("[METAL INFO]");
  local vector sofs;
  sofs = nofs;
  sofs_x = sofs_x + gui_percentXRaw(125 - slen);
  sofs_y = sofs_y + gui_percentYRaw(8);
  drawstring(nofs + gui_percentToPixelRawVec('80 8'), "[METAL INFO]", '8 8 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 23'), "[Name] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('115 23'), dat.vec_name, '6 6 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  local string type;
  local vector t_color;
  // MECH SIZE
  if(dat.vec_size == 1){
    type = "Light";
  }
  else if(dat.vec_size == 2){
    type = "Medium";
  }
  else if(dat.vec_size == 3){
    type = "Heavy";
  }
  
  //float  = 5;
  //float  = 5;
  
  drawstring(nofs + gui_percentToPixelRawVec('8 33'), "[Type] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('115 33'),  type, '6 6 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  //MECH SPEED
  //Forward Speed
  drawstring(nofs + gui_percentToPixelRawVec('8 43'), "[Speed:Forward] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.m_fspeed/DISP_MAX_FSPEED)*100, nofs + gui_percentToPixelRawVec('115 42'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  //Side Speed
  drawstring(nofs + gui_percentToPixelRawVec('8 53'), "[Speed:Strafe] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.m_sspeed/DISP_MAX_SSPEED)*100, nofs + gui_percentToPixelRawVec('115 52'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  //Reverse
  drawstring(nofs + gui_percentToPixelRawVec('8 63'), "[Speed:Reverse] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.m_bspeed/DISP_MAX_BSPEED)*100, nofs + gui_percentToPixelRawVec('115 62'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  //Energy
  drawstring(nofs + gui_percentToPixelRawVec('8 75'), "[Max Energy] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.en_max/DISP_MAX_ENE)*100, nofs + gui_percentToPixelRawVec('115 75'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, HUD_ALPHA, 0, AXIS_H, 0);
  
  drawstring(nofs + gui_percentToPixelRawVec('8 85'), "[Energy Recharge] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.en_rate/DISP_MAX_ENE_RATE)*100, nofs + gui_percentToPixelRawVec('115 85'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, HUD_ALPHA, 0, AXIS_H, 0);
  
  //Shield
  drawstring(nofs + gui_percentToPixelRawVec('8 97'), "[Max Shield] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.sh_max/DISP_MAX_SHIELD)*100, nofs + gui_percentToPixelRawVec('115 97'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);

  drawstring(nofs + gui_percentToPixelRawVec('8 107'), "[Shield Recharge] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.sh_rate/DISP_MAX_SHIELD_RATE)*100, nofs + gui_percentToPixelRawVec('115 107'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);

  //Armor rates
  drawstring(nofs + gui_percentToPixelRawVec('8 119'), "[Armor:Center] ", '6 6 0',CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_ctor/DISP_MAX_ARM_CT)*100, nofs + gui_percentToPixelRawVec('115 119'),gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
  
  drawstring(nofs + gui_percentToPixelRawVec('8 129'), "[Armor:Sides] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_stor/DISP_MAX_ARM_ST)*100, nofs + gui_percentToPixelRawVec('115 129'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
  drawstring(nofs + gui_percentToPixelRawVec('8 139'), "[Armor:Arms] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_arm/DISP_MAX_ARM_AR)*100, nofs + gui_percentToPixelRawVec('115 139'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
  drawstring(nofs + gui_percentToPixelRawVec('8 149'), "[Armor:Legs] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.hp_ctor/DISP_MAX_ARM_LG)*100, nofs + gui_percentToPixelRawVec('115 149'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);

  //Radar Range
  drawstring(nofs + gui_percentToPixelRawVec('8 161'), "[Radar Range] ", '6 6 0',CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  gui_renderMeter((dat.radar_range/DISP_MAX_RAD_RANGE)*100, nofs + gui_percentToPixelRawVec('115 161'),gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_HALF, HUD_ALPHA, 0, AXIS_H, 0);
};

//Displays the fluff text that describes this unit, mostly helpful to give the overall idea of the unit.
void(vector ofs) menu_hangar_MechFluff={
  local vector nofs;
  nofs = ofs + gui_percentToPixelRawVec('115 203');
  drawpic(nofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('250 261'), '1 1 1', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('16 16'), "[DESCRIPTION]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};