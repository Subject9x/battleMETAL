/*
battleMETAL
Author: Peter Roohr
Date: 3/8/2017
Overview: class file for hangar ui

*/

//hook for input events
void() menu_hangarListener_onClick={
  mechSelectListener();
};

void() menu_hangarListener_onDrag={

};

void() menu_hangarListener_onHover={
  if( menu_checkMouseInBounds(cursorpos, HANGAR_HELP_GRAPH, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = gui_percentToPixelRawVec('164 56 0');
    toolTip.description = "Hardpoints are where Weapons and Equipment are mounted to your mech. This panel shows where on the mech the weapons will be.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  
  if( menu_checkMouseInBounds(cursorpos, HANGAR_HELP_HARDPOINT_LIST, gui_percentToPixelRawVec('12 12'), FALSE) ){
    toolTip.data_idx = MENU_BRIEF_ACTIVE;
    toolTip.mins = gui_percentToPixelRawVec('164 64 0');
    toolTip.description = "Hardpoints can only accept certain {Types} and {Sizes} of Weapons and Equipment.";
    toolTip.angles = '0.85 0.85 0.85';
    toolTip.maxs = '12 10 0';
    toolTip.alpha = 1;
    return;
  }
  toolTip.data_idx = FALSE;
};

void() mechSelectListener={
  local float found;
  
  if(menu_checkMouseInBounds(cursorpos, gui_percentToPixel(0.025, 0.0416), gui_percentToPixel(0.075, 0.4166), FALSE)){
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT, TRUE)){
      found = listListener(MECHLIST_ORG_LIGHT, cursorpos, MECHLIST_SIZE_LIGHT, gui_percentToPixelRawVec('90 16'), MECHLIST_CNT_LIGHT, 0);
      found = MECHLIST_LIGHT_VAL[found];
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_MEDIUM, MECHLIST_SIZE_MEDIUM, TRUE)){
      found = listListener(MECHLIST_ORG_MEDIUM, cursorpos, MECHLIST_SIZE_MEDIUM, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_MEDIUM, 0);
      found = MECHLIST_MEDIUM_VAL[found];
    }
    if(menu_checkMouseInBounds(cursorpos, MECHLIST_ORG_HEAVY, MECHLIST_SIZE_HEAVY, TRUE)){
      found = listListener(MECHLIST_ORG_HEAVY, cursorpos, MECHLIST_SIZE_HEAVY, gui_percentToPixel(0.0703, 0.0166), MECHLIST_CNT_HEAVY, 0);
      found = MECHLIST_HEAVY_VAL[found];
    }
    
    if(found > FALSE){

      if( (LAUNCH_VALIDATION & VALID_MECH) ){
        LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & VALID_MECH) ;
      }
      if(found != CLIENT_MENU_sel_mech){
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
  local vector topleftroot;
  
  if(CLIENT_MENU_sel_mech <= 0){
    cleanHardPoints();
  }
  
  topleftroot = VIEW_ORG;
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_HANGAR, 1, 0);
  menu_hangar_MechDisplay(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_hangar_MechList(topleftroot + gui_percentToPixelRawVec('0 24'));
  menu_hangar_MechInfo(topleftroot);
  menu_hangar_MechFluff(topleftroot);
  menu_hangar_MechHPoints(topleftroot);
};

void(vector ofs) menu_hangar_MechDisplay={
  local vector nofs, hofs, i_sz, hardpointGraphCenter;
  local float hardpointItr;
  local entity hardpoint;
  local vector hardpointOffset;
  local vector hardpointCoord;
  local vector mechSize;
  local vector mechMins;
  
  nofs = ofs + gui_percentToPixelRawVec('377 8');
  
  drawpic(nofs, UI_DEF_BOX_512, gui_percentToPixelRawVec('250 250'), CLR_DEF_UI_HANGAR, 1, 0);
  drawpic(nofs + gui_percentToPixelRawVec('4 4'), UI_HANGAR_BOX, gui_percentToPixelRawVec('242 242'), CLR_DEF_UI_HANGAR, 1, 0);
  
  if(SELECT_MECH > FALSE){
    i_sz = gui_percentToPixelRawVec('250 250');
    hofs_x = nofs_x;
    hofs_y = nofs_y;
    if( MECH_DATA_ICON != "" ){
      drawpic(hofs, MECH_DATA_ICON, i_sz, '1 1 1', 1, 0);	
    }
    
    hardpointGraphCenter_x = hofs_x + (i_sz_x / 2);
    hardpointGraphCenter_y = hofs_y + i_sz_y;
    hardpointGraphCenter_y = hardpointGraphCenter_y + ( gui_percentYRaw( UI_HANGAR_DATA_mech.mins_z * 3.75) );

    mechSize_x = (UI_HANGAR_DATA_mech.mins_x * -1) + UI_HANGAR_DATA_mech.maxs_x;
    mechSize_y = UI_HANGAR_DATA_mech.maxs_y;
    mechSize_y = (mechSize_y * 0.75) + UI_HANGAR_DATA_mech.maxs_y;
    
    mechMins_x = UI_HANGAR_DATA_mech.mins_x;
    mechMins_y = (UI_HANGAR_DATA_mech.maxs_y * -1.26);

    MECHPANEL_CTR = hardpointGraphCenter;

    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){
      hardpointOffset = hardpoint.compOffset;
      hardpointOffset_x = hardpointOffset_x * 0.65;
      hardpointOffset_y = hardpointOffset_y * 0.49; 
      hardpointCoord = gui_mapCoordToImgCoord( mechMins, mechSize, hardpointOffset, hofs, gui_percentToPixelRawVec('250 250') );

      if( hardpointCoord_y < hofs_y ){
        hardpointCoord_y = hofs_y + gui_percentYRaw(6);
      }

      ui_renderHardPointNumber( hardpointItr, hardpointCoord );
      hardpointItr = hardpointItr + 1;
      hardpoint = hardpoint.w_slot;
    }
  }
  
  local vector helpOrg;
  helpOrg = nofs;
  helpOrg_x = nofs_x + gui_percentXRaw(250) - gui_percentXRaw(12);
  HANGAR_HELP_GRAPH = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_hangar_MechHPoints={
  local vector nofs, tofs;
  local float tlen, hardpointItr;
  local entity hardpoint;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  nofs = ofs + gui_percentToPixelRawVec('365 272');
  drawpic(nofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('255 192'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, 0);
  drawpic(nofs + gui_percentToPixelRawVec('18.5 32'), UI_DEF_BOX_512, gui_percentToPixelRawVec('236 38'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, 0);
  drawpic(nofs + gui_percentToPixelRawVec('18.5 70'), UI_DEF_BOX_512, gui_percentToPixelRawVec('236 128'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, 0);
  
  tlen = gui_percentXRaw(stringwidth("- Hardpoint Data -", 0, '10 8 0'));
  tofs_x = nofs_x + gui_percentXRaw(255/2) - (tlen/2);
  tofs_y = nofs_y + gui_percentYRaw(10);
  drawstring(tofs, "-HardpointData -", '10 10 0', CLR_DEF_WHITE, 1, 0);
    
  if(SELECT_MECH > FALSE){
    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    hardpointItr = 1;
    while( hardpoint ){
      ui_renderHardpointRow((nofs + gui_percentToPixelRawVec('20 14')), hardpointItr - 1, hardpoint.hardpointType, hardpoint.hardpointSize);
      hardpointItr = hardpointItr + 1;
      hardpoint = hardpoint.w_slot;
    }
  }
  drawstring(nofs + gui_percentToPixelRawVec('20 32'), "-Sizes-", '8 8 0', CLR_DEF_WHITE, 1, 0);
  
  drawstring(nofs + gui_percentToPixelRawVec('20 72'), "-Types-", '8 8 0', CLR_DEF_WHITE, 1, 0);
  
  drawfont = drawfont_prev;
  
  local vector helpOrg;
  helpOrg_x = nofs_x + gui_percentXRaw(260) - gui_percentXRaw(12);
  helpOrg_y = nofs_y + gui_percentYRaw(12);
  HANGAR_HELP_HARDPOINT_LIST = helpOrg;
  gui_renderTooltipIcon( helpOrg) ;
};

void(vector ofs) menu_hangar_MechList={
  local float textLen;
  local vector labelOfs;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  drawpic(ofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('116 440'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, 0);
  
  textLen = stringwidth( "-Available Metal-", 0, '10 10 0');
  labelOfs = ofs + gui_percentToPixelRawVec('9.9 16');
  labelOfs_x = labelOfs_x + gui_percentXRaw( 116 / 2 ) - gui_percentXRaw( textLen / 2 );
  drawstring(labelOfs, "-Available Metal-", '10 10 0', '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
  
  menu_hangar_MechList_draw(ofs + gui_percentToPixelRawVec('16 24'), 1, "======LIGHT======", CLR_DEF_IFF_ENEMY, MECHLIST_CNT_LIGHT, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT);
  menu_hangar_MechList_draw(ofs + gui_percentToPixelRawVec('16 150'), 2, "======MEDIUM=====", CLR_DEF_ARM_HALF, MECHLIST_CNT_LIGHT, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT);
  menu_hangar_MechList_draw(ofs + gui_percentToPixelRawVec('16 275'), 3, "======HEAVY======", CLR_DEF_ARM_OK, MECHLIST_CNT_LIGHT, MECHLIST_ORG_LIGHT, MECHLIST_SIZE_LIGHT);
};

void(vector ofs, float mechSize, string listName, vector listNameColor, float mechListTotalValue, vector mechListOriginValue, vector mechListSizeValue ) menu_hangar_MechList_draw={
  local vector nofs, clr, sofs;
  local float ui_lst_cnt, mechId, ui_lst_act;
  local float mechSizeCheck;
  
  local float labelLen;
  local vector labelOrg;
  local float drawFontLocal;
  
  nofs = ofs;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
  
  labelLen = stringwidth( listName, 0, '12 12 0');
  labelOrg = nofs;
  labelOrg_x = labelOrg_x + gui_percentXRaw( 100 / 2) - gui_percentXRaw( labelLen / 2 );
  drawstring(labelOrg, listName, '12 12 0', listNameColor, 1, 0);
  
  drawfont = drawfont_prev;
  
  ui_lst_cnt = 0;
  ui_lst_act = 0;
  sofs = nofs;
  sofs_y = sofs_y + gui_percentYRaw(4);
  while(ui_lst_cnt <= 24){
    local vector lofs, iofs;
    local float nameLen;
    mechId = UNLOCKED_MECHS[ui_lst_cnt];
    if( mechId != 0){
      mechSizeCheck = MECH_DATA_SIZES[mechId];
      if( mechSizeCheck == mechSize ){
        lofs_x = sofs_x;
        lofs_y = sofs_y + gui_percentYRaw(8 + ui_lst_act * 16);
        if( (mechId == CLIENT_MENU_sel_mech) ){
          clr = CLR_DEF_TXT_HIGHLIGHT;
          gui_renderTintImage(TRUE, lofs - gui_percentToPixelRawVec('2 2'), UI_BOX_SELECT, gui_percentToPixelRawVec('108 13'), CLR_DEF_ARM_OK, 1, 0);
        }
        else{
          clr = CLR_DEF_TXT_NONSELECT;
        }
        nameLen = stringwidth( MECH_DATA_NAMES[mechId], 0, '14 12 0');
        iofs = lofs;
        iofs_x = iofs_x + gui_percentXRaw( 50 - nameLen / 2);
        
        drawFontLocal = drawfont;
        drawfont = FONT_NUM_ROBOT_REGULAR;
        
        drawstring(iofs, MECH_DATA_NAMES[mechId], '14 12 0', clr, 1, 0);
        
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
      MECHLIST_ORG_LIGHT = sofs;
      MECHLIST_ORG_LIGHT_y = nofs_y + gui_percentYRaw(10);
      MECHLIST_SIZE_LIGHT_x = gui_percentXRaw(107);
      MECHLIST_SIZE_LIGHT_y = gui_percentYRaw(ui_lst_act * 16);
      break;
    case 2:
      MECHLIST_CNT_MEDIUM = ui_lst_act;
      MECHLIST_ORG_MEDIUM = sofs;
      MECHLIST_ORG_MEDIUM_y = nofs_y + gui_percentYRaw(10);
      MECHLIST_SIZE_MEDIUM_x = gui_percentXRaw(107);
      MECHLIST_SIZE_MEDIUM_y = gui_percentYRaw(ui_lst_act * 16);
      break;
    default:
      MECHLIST_CNT_HEAVY = ui_lst_act;
      MECHLIST_ORG_HEAVY = sofs;
      MECHLIST_ORG_HEAVY_y = nofs_y + gui_percentYRaw(10);
      MECHLIST_SIZE_HEAVY_x = gui_percentXRaw(107);
      MECHLIST_SIZE_HEAVY_y = gui_percentYRaw(ui_lst_act * 16);
      break;
  }
};

void(vector ofs) menu_hangar_MechInfo={
  local vector nofs, labelOrg;
  local float slen;
  
  local vector fontSize, fontSizeSmall;
  
  fontSizeSmall = '10 8 0';
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  nofs = ofs + gui_percentToPixelRawVec('125 32');
  drawpic(nofs, UI_DEF_BOX_256, gui_percentToPixelRawVec('250 180'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, 0);

  slen = stringwidth("-Metal Info-", 0 ,'10 10 0');
  labelOrg = nofs;
  labelOrg_x = labelOrg_x + gui_percentXRaw( 125 ) - gui_percentXRaw( slen / 2);
  labelOrg_y = labelOrg_y + gui_percentYRaw(8);
  drawstring(labelOrg, "-Metal Info-", '10 10 0', CLR_DEF_WHITE, 1, 0);
  
  fontSize = fontSizeSmall;
    drawstring(nofs + gui_percentToPixelRawVec('8 23'), "Type:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 33'), "Speed:Forward:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 43'), "Speed:Strafe:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 53'), "Speed:Reverse:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 65'), "Max Energy:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 75'), "Energy Recharge:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 87'), "Max Shield:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 97'), "Shield Recharge:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 109'), "Armor:Center:", fontSize,CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 119'), "Armor:Sides:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 129'), "Armor:Arms:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 139'), "Armor:Legs:", fontSize, CLR_DEF_GRAY_H, 1, 0);
    drawstring(nofs + gui_percentToPixelRawVec('8 151'), "Radar Range:", fontSize,CLR_DEF_GRAY_H, 1, 0);
  drawfont = drawfont_prev;
  
  if(SELECT_MECH > FALSE){
    
    //MECH SPEED
    //Forward Speed
    gui_renderMeter((MECH_DATA_SPEEDF/DISP_MAX_FSPEED)*100, nofs + gui_percentToPixelRawVec('115 32'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    
    //Side Speed
    gui_renderMeter((MECH_DATA_SPEEDS/DISP_MAX_SSPEED)*100, nofs + gui_percentToPixelRawVec('115 42'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    
    //Reverse
    gui_renderMeter((MECH_DATA_SPEEDB/DISP_MAX_BSPEED)*100, nofs + gui_percentToPixelRawVec('115 52'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    
    //Energy
    gui_renderMeter((MECH_DATA_ENMAX/DISP_MAX_ENE)*100, nofs + gui_percentToPixelRawVec('115 65'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, 1, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_ENRATE/DISP_MAX_ENE_RATE)*100, nofs + gui_percentToPixelRawVec('115 75'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ENE_BCK, CLR_DEF_ENE_FRT, 1, 0, AXIS_H, 0);
    
    //Shield
    gui_renderMeter((MECH_DATA_SHMAX/DISP_MAX_SHIELD)*100, nofs + gui_percentToPixelRawVec('115 87'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_SHRATE/DISP_MAX_SHIELD_RATE)*100, nofs + gui_percentToPixelRawVec('115 97'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    
    //Armor rates
    gui_renderMeter((MECH_DATA_HPCT/DISP_MAX_ARM_CT)*100, nofs + gui_percentToPixelRawVec('115 109'),gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_HPST/DISP_MAX_ARM_ST)*100, nofs + gui_percentToPixelRawVec('115 119'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    gui_renderMeter((MECH_DATA_HPAR/DISP_MAX_ARM_AR)*100, nofs + gui_percentToPixelRawVec('115 129'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);   
    gui_renderMeter((MECH_DATA_HPLG/DISP_MAX_ARM_LG)*100, nofs + gui_percentToPixelRawVec('115 139'), gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_OK, 1, 0, AXIS_H, 0);
    
    //Radar Range
    gui_renderMeter((MECH_DATA_RAD/DISP_MAX_RAD_RANGE)*100, nofs + gui_percentToPixelRawVec('115 151'),gui_percentToPixelRawVec('102 8'), CLR_DEF_ARM_DED, CLR_DEF_ARM_HALF, 1, 0, AXIS_H, 0);
  }
};

//Displays the fluff text that describes this unit, mostly helpful to give the overall idea of the unit.
void(vector ofs) menu_hangar_MechFluff={
  local vector nofs, fpos;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  nofs = ofs + gui_percentToPixelRawVec('115 203');
  drawpic(nofs + gui_percentToPixelRawVec('9.9 8'), UI_DEF_BOX_256_TALL, gui_percentToPixelRawVec('250 261'), CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, 0);
  
  if(SELECT_MECH > FALSE){
    fpos = nofs + gui_percentToPixelRawVec('22 12');
    gui_wrapText(fpos, '235 210', MECH_DATA_DESC, '12 10 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
  }
  
  drawfont = drawfont_prev;
};