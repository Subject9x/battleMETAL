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

void() mechSelectListener={
  local float found, vsiz;
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.025, 0.0416), gui_percentToPixel(0.075, 0.4166))){
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT)){
      found = listListener(MECHLIST_ORG_LIGHT, cursorpos, MECHLIST_SIZE_LIGHT, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_LIGHT, 0);
      found = MECHLIST_LIGHT_VAL[found];
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_MEDIUM, MECHLIST_SIZE_MEDIUM)){
      found = listListener(MECHLIST_ORG_MEDIUM, cursorpos, MECHLIST_SIZE_MEDIUM, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_MEDIUM, 0);
      found = MECHLIST_MEDIUM_VAL[found];
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_HEAVY, MECHLIST_SIZE_HEAVY)){
      found = listListener(MECHLIST_ORG_HEAVY, cursorpos, MECHLIST_SIZE_HEAVY, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_HEAVY, 0);
      found = MECHLIST_HEAVY_VAL[found];
    }
    
    if(found > FALSE){

      if( (LAUNCH_VALIDATION & VALID_MECH) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION - ( LAUNCH_VALIDATION & VALID_MECH) ;
      }
      if(found != self.plr_sel_mech){
        ui_mech_config_switch( found, 0 );
      }

      if( !(LAUNCH_VALIDATION & VALID_MECH) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_MECH;
      }
    }
  }
};

//main hook for menu system
void() menu_hangarDrawFrame={
  
  if(self.plr_sel_mech <= 0){
    cleanHardPoints();
  }
  
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_HANGAR, HUD_ALPHA, 0);
  menu_hangar_MechDisplay(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_hangar_MechList(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_hangar_MechInfo(topleftroot);
  menu_hangar_MechFluff(topleftroot);
  menu_hangar_MechHPoints(topleftroot);
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector nofs, hofs, mpos, i_sz, hpnts;
  nofs = ofs + gui_percentToPixelRawVec('377 8'); //420 8
  drawpic(nofs, UI_DEF_BOX_512, gui_percentToPixelRawVec('250 250'), CLR_DEF_UI_HANGAR, HUD_ALPHA, 0);
  drawpic(nofs + gui_percentToPixelRawVec('4 4'), UI_HANGAR_BOX, gui_percentToPixelRawVec('242 242'), CLR_DEF_UI_HANGAR, HUD_ALPHA, 0);
  if(SELECT_MECH > FALSE){
    i_sz = draw_getimagesize(MECH_DATA_ICON);
    i_sz = gui_percentToPixelRawVec('250 250');
    hofs_x = nofs_x;
    hofs_y = nofs_y;
    drawpic(hofs, MECH_DATA_ICON, i_sz, '1 1 1', HUD_ALPHA, 0);
    hpnts_x = hofs_x + (i_sz_x / 2);
    hpnts_y = hofs_y + (i_sz_y / 2);
    MECHPANEL_CTR = hpnts;
    local float hlist;
    hlist = 1;
    while( hlist <= 9 ){
      if( MECH_DATA_H_HNG[hlist] != '0 0 0'){
        ui_renderHardPointNumber(hlist, (hpnts + gui_percentToPixelRawVec(MECH_DATA_H_HNG[hlist] )));
      }
      hlist = hlist + 1;
    }
  }
};

void(vector ofs) menu_hangar_MechHPoints={
  local vector nofs, tofs;
  local float tlen, hlist;
  local entity dat;
  nofs = ofs + gui_percentToPixelRawVec('365 272');
  drawpic(nofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('255 192'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', HUD_ALPHA, 0);
  
  tlen = strlen("[HARDPOINTS]");
  tofs = nofs;
  tofs_x = tofs_x + gui_percentXRaw((255/2) - (tlen/2));
  tofs_y = tofs_y + gui_percentYRaw(16);
  drawstring(tofs, "[HARDPOINTS]", '6 6 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('16 24'), "[hardpoint]", '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
  drawstring(nofs + gui_percentToPixelRawVec('125 24'), "[types]", '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
  drawstring(nofs + gui_percentToPixelRawVec('222 24'), "[size]", '6 6 0', CLR_DEF_WHITE,HUD_ALPHA , 0);
    
  if(SELECT_MECH > FALSE){
    hlist = 1;
    while( hlist <= 9) {
      if( MECH_DATA_H_TYPE[hlist] > 0 ){
        ui_renderHardpointRow((nofs + gui_percentToPixelRawVec('16 24')), hlist, MECH_DATA_H_TYPE[hlist], MECH_DATA_H_SIZE[hlist]);
      } 
      hlist = hlist + 1;
    }
  }
};


void(vector ofs) menu_hangar_MechList={
  drawpic(ofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('116 440'),CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', HUD_ALPHA, 0);
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
  ui_lst_cnt = 1;
  ui_lst_act = 0;
  dat_id = 1;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= GAME_TOTAL_MECHS){
    local vector lofs, clr;
    local float siz;
    siz = MECH_DATA_SIZES[dat_id];
    if(MECHLIST_LIGHT_ARR[dat_id] != 0){
      lofs_x = sofs_x;
      lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(siz == self.plr_sel_size && dat_id == self.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
        gui_renderTintImage(TRUE, lofs - gui_percentToPixel(0.0015, 0.0015), UI_BOX_SELECT, gui_percentToPixel(0.075, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + gui_percentToPixel(0.0093, 0), MECH_DATA_NAMES[dat_id], '6 6 0', clr, HUD_ALPHA, 0);
      MECHLIST_LIGHT_VAL[ui_lst_act] = dat_id;
      ui_lst_act = ui_lst_act + 1;
    }
    dat_id = dat_id + 1;
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
  ui_lst_cnt = 1;
  ui_lst_act = 0;
  dat_id = 1;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= GAME_TOTAL_MECHS){
    local vector lofs, clr;
    local float siz;
    siz = MECH_DATA_SIZES[dat_id];
    if(MECHLIST_MEDIUM_ARR[dat_id] != 0){
      lofs_x = sofs_x;
      lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(siz == self.plr_sel_size && dat_id == self.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
        gui_renderTintImage(TRUE, lofs - gui_percentToPixel(0.0015, 0.0015), UI_BOX_SELECT, gui_percentToPixel(0.075, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + gui_percentToPixel(0.0093, 0), MECH_DATA_NAMES[dat_id], '6 6 0', clr, HUD_ALPHA, 0);
      MECHLIST_MEDIUM_VAL[ui_lst_act] = dat_id;
      ui_lst_act = ui_lst_act + 1;
    }
    dat_id = dat_id + 1;
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
  ui_lst_cnt = 1;
  ui_lst_act = 0;
  dat_id = 1;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= GAME_TOTAL_MECHS){
    local vector lofs, clr;   
    local float siz;
    
    siz = MECH_DATA_SIZES[dat_id];
    if(MECHLIST_HEAVY_ARR[dat_id] != 0){
      lofs_x = sofs_x;
      lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
      if(siz == self.plr_sel_size && dat_id == self.plr_sel_mech){
        clr = CLR_DEF_TXT_HIGHLIGHT;
        gui_renderTintImage(TRUE, lofs - gui_percentToPixel(0.0015, 0.0015), UI_BOX_SELECT, gui_percentToPixel(0.075, 0.01), CLR_DEF_ARM_OK, HUD_ALPHA, 0);
      }
      else{
        clr = CLR_DEF_TXT_NONSELECT;
      }
      drawstring(lofs + gui_percentToPixel(0.0093, 0), MECH_DATA_NAMES[dat_id], '6 6 0', clr, HUD_ALPHA, 0);
      MECHLIST_HEAVY_VAL[ui_lst_act] = dat_id;
      ui_lst_act = ui_lst_act + 1;
    }
    dat_id = dat_id + 1;
    ui_lst_cnt = ui_lst_cnt + 1;
  }
  MECHLIST_CNT_HEAVY = ui_lst_act;
  MECHLIST_ORG_HEAVY = sofs;
  MECHLIST_ORG_HEAVY_y = nofs_y + gui_percentYRaw(10);
  MECHLIST_SIZE_HEAVY_x = gui_percentX(0.0687);
  MECHLIST_SIZE_HEAVY_y = gui_percentYRaw(ui_lst_act * 16);
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs, sofs, t_color;
  local float slen;
  local string type;

  nofs_x = ofs_x + gui_percentXRaw(125);
  nofs_y = ofs_y + gui_percentYRaw(43);
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('250 180'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', HUD_ALPHA, 0);

  slen = strlen("[METAL INFO]");
  sofs = nofs;
  sofs_x = sofs_x + gui_percentXRaw(125 - slen);
  sofs_y = sofs_y + gui_percentYRaw(8);
  drawstring(nofs + gui_percentToPixelRawVec('80 8'), "[METAL INFO]", '8 8 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 23'), "[Name] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('115 23'), MECH_DATA_NAME, '6 6 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  drawstring(nofs + gui_percentToPixelRawVec('8 33'), "[Type] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 43'), "[Speed:Forward] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 53'), "[Speed:Strafe] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 63'), "[Speed:Reverse] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 75'), "[Max Energy] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 85'), "[Energy Recharge] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 97'), "[Max Shield] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 107'), "[Shield Recharge] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 119'), "[Armor:Center] ", '6 6 0',CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 129'), "[Armor:Sides] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 139'), "[Armor:Arms] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 149'), "[Armor:Legs] ", '6 6 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('8 161'), "[Radar Range] ", '6 6 0',CLR_DEF_GRAY_H, HUD_ALPHA, 0);
 
  if(SELECT_MECH > FALSE){
    // MECH SIZE
    switch(MECH_DATA_SIZE){
      case 1:
        type = "Light";
        break;
      case 2:
        type = "Medium";
        break;
      case 3:
        type = "Heavy";
        break;
    }
    
    drawstring(nofs + gui_percentToPixelRawVec('115 33'),  type, '6 6 0', CLR_DEF_WHITE, HUD_ALPHA, 0);
    //MECH SPEED
    //Forward Speed
    gui_renderMeter((MECH_DATA_SPEEDF/DISP_MAX_FSPEED)*100, nofs + gui_percentToPixelRawVec('115 42'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
    //Side Speed
    gui_renderMeter((MECH_DATA_SPEEDS/DISP_MAX_SSPEED)*100, nofs + gui_percentToPixelRawVec('115 52'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
    //Reverse
    gui_renderMeter((MECH_DATA_SPEEDB/DISP_MAX_BSPEED)*100, nofs + gui_percentToPixelRawVec('115 62'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
    //Energy
    gui_renderMeter((MECH_DATA_ENMAX/DISP_MAX_ENE)*100, nofs + gui_percentToPixelRawVec('115 75'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, HUD_ALPHA, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_ENRATE/DISP_MAX_ENE_RATE)*100, nofs + gui_percentToPixelRawVec('115 85'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, HUD_ALPHA, 0, AXIS_H, 0);
    
    //Shield
    gui_renderMeter((MECH_DATA_SHMAX/DISP_MAX_SHIELD)*100, nofs + gui_percentToPixelRawVec('115 97'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_SHRATE/DISP_MAX_SHIELD_RATE)*100, nofs + gui_percentToPixelRawVec('115 107'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
    //Armor rates
    gui_renderMeter((MECH_DATA_HPCT/DISP_MAX_ARM_CT)*100, nofs + gui_percentToPixelRawVec('115 119'),gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_HPST/DISP_MAX_ARM_ST)*100, nofs + gui_percentToPixelRawVec('115 129'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_HPAR/DISP_MAX_ARM_AR)*100, nofs + gui_percentToPixelRawVec('115 139'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);   
    gui_renderMeter((MECH_DATA_HPLG/DISP_MAX_ARM_LG)*100, nofs + gui_percentToPixelRawVec('115 149'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, HUD_ALPHA, 0, AXIS_H, 0);
    
    //Radar Range
    gui_renderMeter((MECH_DATA_RAD/DISP_MAX_RAD_RANGE)*100, nofs + gui_percentToPixelRawVec('115 161'),gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_HALF, HUD_ALPHA, 0, AXIS_H, 0);
  }
};

//Displays the fluff text that describes this unit, mostly helpful to give the overall idea of the unit.
void(vector ofs) menu_hangar_MechFluff={
  local vector nofs, fpos;
  local float lne_idx, argc;
  nofs = ofs + gui_percentToPixelRawVec('115 203');
  drawpic(nofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('250 261'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', HUD_ALPHA, 0);
  drawstring(nofs + gui_percentToPixelRawVec('16 16'), "[DESCRIPTION]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  if(SELECT_MECH > FALSE){
    fpos = nofs + gui_percentToPixelRawVec('10 26');
    gui_wrapText(fpos, '235 210', MECH_DATA_DESC, '7 8 0', '0.9 0.9 0.9', 1);
  }
};