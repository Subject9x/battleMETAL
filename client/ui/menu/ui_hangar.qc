/*
battleMETAL
Author: Peter Roohr
Date: 3/8/2017
Overview: class file for hangar ui

*/

//hook for input events
void() menu_hangarListener_onClick={
  menu_navbBar_listener();
  mechSelectListener();
  
};

void() menu_hangarListener_onDrag={

};

void() menu_hangarListener_onHover={
  if( menu_checkMouseInBounds(cursorpos, HANGAR_HELP_GRAPH, '12 12', FALSE) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = '164 56 0';
    toolTip.description = "Hardpoints are where Weapons and Equipment are mounted to your mech. This panel shows where on the mech the weapons will be.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds(cursorpos, HANGAR_HELP_HARDPOINT_LIST, '12 12', FALSE) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = '164 64 0';
    toolTip.description = "Hardpoints can only accept certain {Types} and {Sizes} of Weapons and Equipment.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 12';
    toolTip.alpha = 1;
    return;
  }
  toolTip.data_idx = FALSE;
};

void() mechSelectListener={
  local float found;
  if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT, TRUE)){
    found = listListener(MECHLIST_ORG_LIGHT, cursorpos, MECHLIST_SIZE_LIGHT, '90 16', MECHLIST_CNT_LIGHT, 0);
    found = MECHLIST_LIGHT_VAL[found];
  }
  if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_MEDIUM, MECHLIST_SIZE_MEDIUM, TRUE)){
    found = listListener(MECHLIST_ORG_MEDIUM, cursorpos, MECHLIST_SIZE_MEDIUM, '90 16', MECHLIST_CNT_MEDIUM, 0);
    found = MECHLIST_MEDIUM_VAL[found];
  }
  if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_HEAVY, MECHLIST_SIZE_HEAVY, TRUE)){
    found = listListener(MECHLIST_ORG_HEAVY, cursorpos, MECHLIST_SIZE_HEAVY, '90 16', MECHLIST_CNT_HEAVY, 0);
    found = MECHLIST_HEAVY_VAL[found];
  }
  if(found > FALSE){
    if( (LAUNCH_VALIDATION & VALID_MECH) ){
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS | VALID_NODE)) ;
    }
    if( found != CLIENT_MENU_sel_mech ){
      ui_mech_config_switch( found, 1 );
    }

    if( !(LAUNCH_VALIDATION & VALID_MECH) ){
      LAUNCH_VALIDATION = LAUNCH_VALIDATION | VALID_MECH;
    }
  }
};

//main hook for menu system
void() menu_hangarDrawFrame={
  local vector topleftroot;
  
  if(CLIENT_MENU_sel_mech <= 0){
    cleanHardPoints();
  }
  
  topleftroot = UI_ORG;
  
  drawfill(VIEW_ORG, VIEW_MAX, CLR_DEF_UI_HANGAR * 0.25, 1, 0 );
  
  menu_navBar_drawFrame(topleftroot);
  
  menu_hangar_MechDisplay(topleftroot + '367 32');
  menu_hangar_MechList(topleftroot + '0 32');
  menu_hangar_MechInfo(topleftroot + '118 32');
  menu_hangar_MechFluff(topleftroot + '118 208');
  menu_hangar_MechHPoints(topleftroot + '367 273');
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector imgSize;
  local vector nofs, hofs, i_sz, hardpointGraphCenter;
  local float hardpointItr;
  local entity hardpoint;
  local vector helpOrg;
  
  nofs = ofs;
  
  gui_renderBorder9_1_32(nofs,  '260 250', CLR_DEF_UI_HANGAR, 1, 0) ;
  
  nofs = nofs + '10 6';
  
  drawpic(nofs, UI_HANGAR_BOX, '252 225', CLR_DEF_UI_HANGAR, 1, 0);
  
  if(SELECT_MECH > FALSE){
    imgSize = draw_getimagesize(MECH_DATA_ICON);
    
    i_sz_y = 234;
    i_sz_x = floor(i_sz_y * (imgSize_x / imgSize_y));
    
    hofs = Vector2(ofs_x + 10 + 130 - (i_sz_x/2), ofs_y + 2);
    
    if( MECH_DATA_ICON != "" ){
      drawpic(hofs, MECH_DATA_ICON, i_sz, CLR_DEF_ARM_OK * 2, 0.5, 0);
    }
    
    hardpointGraphCenter = Vector2(ofs_x + 130 + 10, ofs_y + (i_sz_y/5.5));

    MECHPANEL_CTR = hardpointGraphCenter;

    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){
      hardpoint.ui_org = MECHPANEL_CTR + (hardpoint.uiOffset * (i_sz_y / i_sz_x) * 0.67);
      
      drawpic( hardpoint.ui_org +'-8 -2', UI_DEF_BOX_64, '16 16', '1 1 1', 1, 0);
      ui_renderHardPointNumber( hardpointItr, hardpoint.ui_org );
      
      hardpointItr = hardpointItr + 1;
      hardpoint = hardpoint.w_slot;
    }
  }
  //draw hardpoint keys
  local vector iconOfs;
  iconOfs = Vector2(ofs_x + 4, ofs_y + 165);
  
  drawpic(iconOfs, "gfx/ui/wep_icons/bal1.tga", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
  drawstring(iconOfs + '18 4', "Ballistic", '10 10', CLR_DEF_ARM_HALF, 1, 0);
  
  drawpic(iconOfs + '0 18', "gfx/ui/wep_icons/ene1.tga", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
  drawstring(iconOfs + '18 22', "Energy", '10 10', CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2' , 1, 0);
  
  drawpic(iconOfs + '0 36',  "gfx/ui/wep_icons/mis1.tga", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
  drawstring(iconOfs + '18 40', "Missile", '10 10', CLR_DEF_ARM_OK, 1, 0);
  
  drawpic(iconOfs + '0 54', "gfx/ui/wep_icons/misc1.tga", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
  drawstring(iconOfs + '18 58', " Module", '10 10', CLR_HUD_PURPLE + '0.15 0.15 0.15', 1, 0);  
  
  helpOrg = nofs;
  helpOrg_x = nofs_x + 250 - 12;
  HANGAR_HELP_GRAPH = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};


void(vector ofs) menu_hangar_MechHPoints={
  local vector nofs, tofs;
  local float tlen, hardpointItr;
  local entity hardpoint;
  local vector helpOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  nofs = ofs;
  gui_renderPatch9_1_32(nofs, '265 220',  CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  tlen = stringwidth("Hardpoint Restrictions", 0, '10 10');
  tofs = Vector2(nofs_x + (255/2) - (tlen/2),  nofs_y + 2);
  
  drawstring(tofs + '9.9 0', "-Hardpoint Restrictions-", '10 10', CLR_DEF_WHITE, 1, 0);
    
  if(SELECT_MECH > FALSE){
    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){
      ui_renderHardpointRow(nofs + '10 10', hardpointItr - 1, hardpoint.hardpointType, hardpoint.hardpointSize);
      hardpointItr = hardpointItr + 1;
      hardpoint = hardpoint.w_slot;
    }
  }
  drawfont = drawfont_prev;
  
  helpOrg_x = nofs_x + 270 - 12;
  helpOrg_y = nofs_y - 6;
  HANGAR_HELP_HARDPOINT_LIST = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_hangar_MechList={
  menu_hangar_MechList_draw(ofs, 1,  "LIGHT", CLR_DEF_IFF_ENEMY * 1.25, MECHLIST_CNT_LIGHT, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT);
  menu_hangar_MechList_draw(ofs + '0 145', 2, "MEDIUM", CLR_DEF_ARM_HALF, MECHLIST_CNT_LIGHT, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT);
  menu_hangar_MechList_draw(ofs + '0 289', 3, "HEAVY", CLR_DEF_ARM_OK, MECHLIST_CNT_LIGHT, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT);
};

void(vector ofs, float mechSize, string listName, vector listNameColor, float mechListTotalValue, vector mechListOriginValue, vector mechListSizeValue ) menu_hangar_MechList_draw={
  local vector nofs, clr, sofs;
  local float ui_lst_cnt, mechId, ui_lst_act;
  local float mechSizeCheck;
  
  local float labelLen;
  local vector labelOrg;
  local float drawFontLocal;
  local vector lofs, iofs;
  local float nameLen;
  
  nofs = ofs;
  
  gui_renderPatch9_1_32(nofs, '106 144',  CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
  
  labelLen = stringwidth( listName, 0, '12 12');
  labelOrg = Vector2(nofs_x + 10,nofs_y + 2);
  drawstring(labelOrg, listName, '12 12', listNameColor, 1, 0);
  
  drawfont = drawfont_prev;
  
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  
  sofs = Vector2(nofs_x + 4, nofs_y + 6);
  
  while(ui_lst_cnt <= 24){
    mechId = UNLOCKED_MECHS[ui_lst_cnt];
    if( mechId != 0){
      mechSizeCheck = MECH_DATA_SIZES[mechId];
      if( mechSizeCheck == mechSize ){
        lofs = Vector2(sofs_x, sofs_y + (8 + ui_lst_act * 16));
        if( mechId == CLIENT_MENU_sel_mech ){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs, UI_BOX_SELECT, '104 13', CLR_DEF_ARM_OK, 1, 0);
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        nameLen = stringwidth( MECH_DATA_NAMES[mechId], 0, '14 14');
        iofs = Vector2( lofs_x + ( 50 - nameLen / 2), lofs_y);
        
        drawFontLocal = drawfont;
        drawfont = FONT_NUM_ROBOT_REGULAR;
        
        drawstring(iofs, MECH_DATA_NAMES[mechId], '14 14', clr, 1, 0);
        
        drawfont = drawFontLocal;
        
        switch( mechSize ){
          case 1:
            MECHLIST_LIGHT_VAL[ui_lst_act] = mechId;
            break;
          case 2:
            MECHLIST_MEDIUM_VAL[ui_lst_act] = mechId;
            break;
          default:
            MECHLIST_HEAVY_VAL[ui_lst_act] = mechId;
            break;
        }
        ui_lst_act = ui_lst_act + 1;
      }
    }
    ui_lst_cnt = ui_lst_cnt + 1;
  }
  
  //list details
  //cause qc has issues passing values back up the param stack
  switch( mechSize ){
    case 1:
      MECHLIST_CNT_LIGHT = ui_lst_act;
      MECHLIST_ORG_LIGHT = Vector2(sofs_x, nofs_y + 10);
      MECHLIST_SIZE_LIGHT = Vector2(107,  ui_lst_act * 16);
      break;
    case 2:
      MECHLIST_CNT_MEDIUM = ui_lst_act;
      MECHLIST_ORG_MEDIUM = Vector2(sofs_x, nofs_y + 10);
      MECHLIST_SIZE_MEDIUM = Vector2(107,  ui_lst_act * 16);
      break;
    default:
      MECHLIST_CNT_HEAVY = ui_lst_act;
      MECHLIST_ORG_HEAVY = Vector2(sofs_x, nofs_y + 10);
      MECHLIST_SIZE_HEAVY = Vector2(107,  ui_lst_act * 16);
      break;
  }
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs, labelOrg;
  local float slen;
  
  local vector fontSize, fontSizeSmall;
  
  fontSizeSmall = '10 10 0';
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  nofs = ofs;
  gui_renderPatch9_1_32(nofs, '224 180',  CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);

  slen = stringwidth("-Metal Info-", 0 ,'10 10');
  labelOrg = nofs;
  labelOrg_x = labelOrg_x +  125 - ( slen / 2);
  labelOrg_y = labelOrg_y + 8;
  drawstring(labelOrg, "-Metal Info-", '10 10', CLR_DEF_WHITE, 1, 0);
  
  fontSize = fontSizeSmall;
    drawstring(nofs + '8 23', "Type:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 33', "Speed-Forward:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 43', "Speed-Strafe:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 53', "Speed-Reverse:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 65', "Max Energy:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 75', "Energy Recharge:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 87', "Max Shield:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 97', "Shield Recharge:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 109', "Armor-Center:", fontSize,CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 119', "Armor-Sides:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 129', "Armor-Arms:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 139', "Armor-Legs:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + '8 151', "Radar Range:", fontSize,CLR_DEF_GRAY_H, 1, 0);
  drawfont = drawfont_prev;
  
  if(SELECT_MECH > FALSE){
      drawfont_prev = drawfont;
      drawfont = FONT_NUM_ROBOT_REGULAR;

    //MECH SPEED
    //Forward Speed
    gui_renderMeter((MECH_DATA_SPEEDF/DISP_MAX_FSPEED)*100, nofs + '85 32', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 31', ftos(MECH_DATA_SPEEDF), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Side Speed
    gui_renderMeter((MECH_DATA_SPEEDS/DISP_MAX_SSPEED)*100, nofs + '85 42', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 41', ftos(MECH_DATA_SPEEDS), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Reverse
    gui_renderMeter((MECH_DATA_SPEEDB/DISP_MAX_BSPEED)*100, nofs + '85 52', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 51', ftos(MECH_DATA_SPEEDB), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Energy
    gui_renderMeter((MECH_DATA_ENMAX/DISP_MAX_ENE)*100, nofs + '85 65', '67 8', CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 64', ftos(MECH_DATA_ENMAX), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    gui_renderMeter((MECH_DATA_ENRATE/DISP_MAX_ENE_RATE)*100, nofs + '85 75', '67 8', CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 74', sprintf("%00.2f", MECH_DATA_ENRATE), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Shield
    gui_renderMeter((MECH_DATA_SHMAX/DISP_MAX_SHIELD)*100, nofs + '85 87', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 86', ftos(MECH_DATA_SHMAX), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    gui_renderMeter((MECH_DATA_SHRATE/DISP_MAX_SHIELD_RATE)*100, nofs + '85 97', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 96', sprintf("%00.2f", MECH_DATA_SHRATE), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Armor rates
    gui_renderMeter((MECH_DATA_HPCT/DISP_MAX_ARM_CT)*100, nofs + '85 109','67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 108', ftos(MECH_DATA_HPCT), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    gui_renderMeter((MECH_DATA_HPST/DISP_MAX_ARM_ST)*100, nofs + '85 119', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 118', ftos(MECH_DATA_HPST), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    gui_renderMeter((MECH_DATA_HPAR/DISP_MAX_ARM_AR)*100, nofs + '85 129', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);  
    drawstring(nofs + '162 128', ftos(MECH_DATA_HPAR), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0); 
    gui_renderMeter((MECH_DATA_HPLG/DISP_MAX_ARM_LG)*100, nofs + '85 139', '67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 138', ftos(MECH_DATA_HPLG), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Radar Range
    gui_renderMeter((MECH_DATA_RAD/DISP_MAX_RAD_RANGE)*100, nofs + '85 151','67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_HALF, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 150', ftos(MECH_DATA_RAD), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Lock on Time - 2.0.0 - no longer matters
    /*local float lock;
    lock = 6 - MECH_DATA_LOCKON;
    lock = lock / 6;
    gui_renderMeter(lock*100, nofs + '85 163','67 8', CLR_DEF_ARM_DED, CLR_DEF_ARM_HALF, 1, 0, AXIS_H, 0);
    drawstring(nofs + '162 162', strcat(ftos(MECH_DATA_LOCKON)," seconds"), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);*/
    
    drawfont = drawfont_prev;
  }
};

//Displays the fluff text that describes this unit, mostly helpful to give the overall idea of the unit.
void(vector ofs) menu_hangar_MechFluff={
  local vector nofs, fpos;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  nofs = ofs;
  gui_renderPatch9_1_32(nofs, '224 272',  CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);
  
  if(SELECT_MECH > FALSE){
    fpos = nofs + '8 12';
    gui_wrapText(fpos, '230 252', MECH_DATA_DESC, '12 12', CLR_DEF_TXT_GRAY_SMOOTH, 1);
  }
  
  drawfont = drawfont_prev;
};