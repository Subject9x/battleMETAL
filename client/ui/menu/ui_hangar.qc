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
      if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
        //todo - send player mech id upstream
        cl_setmech( SELECT_MECH );
      }
      cl_set_faction_colors();
      cl_send_infostring( INFO_FLAG_MECH | INFO_FLAG_COLOR);
      menu_player_MechModel_setup('0 167 0', '1.0 1.0 1.0', 1);
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
  //if(SELECT_MECH > FALSE){  
  //  menu_hangar_MechModelDisplay(topleftroot + '377 38', '225 225'); 
  //}
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
        
    hardpointGraphCenter = Vector2(ofs_x + 130 + 10, ofs_y + (i_sz_y/5.5));

    MECHPANEL_CTR = hardpointGraphCenter;
    
    menu_hangar_MechModelDisplay(nofs, '252 225');

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
  
  
  gui_renderPatch9_1_32(nofs, '106 144', listNameColor * 0.67, 1, DRAWFLAG_NORMAL);
  
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
  
  local vector speedOfs;
  local vector energyOfs;
  local vector shieldOfs;
  local vector armorOrg;
  local vector radarOfs;
    
  fontSizeSmall = '10 10 0';
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  nofs = ofs;
  gui_renderPatch9_1_32(nofs, '224 180', CLR_DEF_UI_HANGAR + '0.3 0.3 0.3', 1, DRAWFLAG_NORMAL);

  slen = stringwidth("-Metal Info-", 0 ,'10 10');
  labelOrg = nofs;
  labelOrg_x = labelOrg_x +  125 - ( slen / 2);
  labelOrg_y = labelOrg_y + 4;
  drawstring(labelOrg, "-Metal Info-", '10 10', CLR_DEF_WHITE, 1, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  if(SELECT_MECH > FALSE){
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    
    //Speed
    speedOfs = ofs + '128 64';
    drawpic(speedOfs, "gfx/hud/hud_icon_ram.tga", '32 24', CLR_HUD_ORANGE, 0.85, DRAWFLAG_NORMAL);
    gui_labelKeyPair( speedOfs + '0 22', "Forward: ", sprintf("%00.1f", MECH_DATA_SPEEDF), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    gui_labelKeyPair( speedOfs + '0 34', "Reverse: ", sprintf("%00.1f", MECH_DATA_SPEEDB), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    gui_labelKeyPair( speedOfs + '0 46', "Strafe: ", sprintf("%00.1f", MECH_DATA_SPEEDS), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    
    //Energy
    energyOfs = ofs + '5 14';
    drawpic(energyOfs, "gfx/hud/hud_icon_power.tga", '32 24', CLR_HUD_BLUE, 0.85, DRAWFLAG_NORMAL);
    gui_labelKeyPair( energyOfs + '0 22', "Max: ", ftos(MECH_DATA_ENMAX), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    gui_labelKeyPair( energyOfs + '0 34', "Recharge: ", sprintf("%00.2f / 1s", MECH_DATA_ENRATE), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    
    
    //Shield   
    shieldOfs = ofs + '128 14';
    drawpic(shieldOfs, "gfx/hud/hud_icon_shield.tga", '24 24', CLR_DEF_SHD_OK, 0.85, DRAWFLAG_NORMAL);
    gui_labelKeyPair( shieldOfs + '0 22', "Max: ", ftos(MECH_DATA_SHMAX), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    gui_labelKeyPair( shieldOfs + '0 34', "Recharge: ", sprintf("%00.2f / 1s", MECH_DATA_SHRATE), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    
    
    //Armor rate
    armorOrg = ofs + '48 90';
    
    drawpic(armorOrg + '-10 -16', HUD_MECH_CT, '20 32', gui_getColorForArmor((MECH_DATA_HPCT/DISP_MAX_ARM_CT)*100), 1.0, DRAWFLAG_NORMAL);
    drawstring(armorOrg + Vector2(stringwidth(ftos(MECH_DATA_HPCT), 0, '10 10')/-2, -25), ftos(MECH_DATA_HPCT), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawpic(armorOrg + '-6.5 -15.5' + '20 -4', HUD_MECH_ST, '13 31', gui_getColorForArmor((MECH_DATA_HPST/DISP_MAX_ARM_ST)*100), 1.0, DRAWFLAG_NORMAL);
    drawstring(armorOrg + '20 -4' + Vector2(stringwidth(ftos(MECH_DATA_HPST), 0, '10 10')/-2, 17), ftos(MECH_DATA_HPST), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawpic(armorOrg + '-6.5 -15.5' - '20 4', HUD_MECH_ST, '13 31', gui_getColorForArmor((MECH_DATA_HPST/DISP_MAX_ARM_ST)*100), 1.0, DRAWFLAG_NORMAL);
    drawstring(armorOrg - '20 4' + Vector2(stringwidth(ftos(MECH_DATA_HPST), 0, '10 10')/-2, 17), ftos(MECH_DATA_HPST), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawpic(armorOrg + '-6 -16' + '35 8', HUD_MECH_RA, '12 32', gui_getColorForArmor((MECH_DATA_HPAR/DISP_MAX_ARM_AR)*100), 1.0, DRAWFLAG_NORMAL);
    drawstring(armorOrg + '35 8' + Vector2(stringwidth(ftos(MECH_DATA_HPAR), 0, '10 10')/-2, 17), ftos(MECH_DATA_HPAR), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawpic(armorOrg + '-6 -16' - '35 -8', HUD_MECH_LA, '12 32', gui_getColorForArmor((MECH_DATA_HPAR/DISP_MAX_ARM_AR)*100), 1.0, DRAWFLAG_NORMAL);
    drawstring(armorOrg - '35 -8' + Vector2(stringwidth(ftos(MECH_DATA_HPAR), 0, '10 10')/-2, 17), ftos(MECH_DATA_HPAR), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    drawpic(armorOrg + '-20 -32' + '0 53', HUD_MECH_LEG, '40 64', gui_getColorForArmor((MECH_DATA_HPLG/DISP_MAX_ARM_LG)*100), 1.0, DRAWFLAG_NORMAL);
    drawstring(armorOrg + Vector2(stringwidth(ftos(MECH_DATA_HPLG), 0, '10 10')/-2, 53), ftos(MECH_DATA_HPLG), '10 10', CLR_DEF_TXT_HIGHLIGHT, 1, 0);
    
    //Radar Range
    radarOfs = ofs + '128 126';
    drawpic(radarOfs, "gfx/hud/hud_icon_radar.tga", '24 24', gui_getColorForArmor((MECH_DATA_RAD/DISP_MAX_RAD_RANGE)*100), 1.0, DRAWFLAG_NORMAL);
    gui_labelKeyPair( radarOfs + '0 26', "Radar Range:", sprintf("%00.1f m", MECH_DATA_RAD), CLR_DEF_TXT_NONSELECT, CLR_DEF_WHITE, fontSizeSmall, '10 10' );
    
    
    /*Lock on Time - 2.0.0 - no longer matters
    local float lock;
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


/*
  Render mech as 3D model in a custom viewport along with hardpoints.
*/
void(vector ofs, vector viewSize) menu_hangar_MechModelDisplay={
  local vector tSize, modelMins, modelMax, cOrg, mOffset;
  local vector viewOrg;
  local float zBias, zTotal;
  
  modelMins = UI_HANGAR_DATA_mech.mins;
  modelMax = UI_HANGAR_DATA_mech.maxs;
  tSize = modelMax - modelMins;
  
  zBias = zBias + (modelMins_z - modelMax_z)/2 - modelMins_z;
  zTotal = ((modelMins_z * -1) + modelMax_z) / 2.3;
  
  viewOrg = pmove_org;
  clearscene();
    setproperty(VF_ORIGIN, viewOrg + '-115 0 0');	//look towards it.
    setproperty(VF_ANGLES, '0 0 0');
    
    setproperty(VF_MIN, vtodpp([ofs_x, ofs_y, 0]) );
    setproperty(VF_SIZE, vtodpp([viewSize_x, viewSize_y, 0]) );
    //set an explicit fov. this thing had better be square. DP doesn't support VF_AFOV
    //setproperty(VF_FOV, [25, atan(viewSize_y/(viewSize_x/tan(25/360*6.28))) * 360/6.28, 0]); 
    setproperty(VF_FOV, [zTotal, atan(viewSize_y/(viewSize_x/tan(zTotal/360*6.28))) * 360/6.28, 0]); 

    setproperty(VF_DRAWENGINESBAR, 0);
    setproperty(VF_DRAWWORLD, 0);
    setproperty(VF_DRAWCROSSHAIR, 0);
    
    setproperty(VF_FOG_DENSITY, 0.0);
    setproperty(VF_FOG_ALPHA,0.0 );
    setproperty(VF_FOG_START, 0);
    setproperty(VF_FOG_END, 0);
    setproperty(VF_FOG_HEIGHT, 0);
    setproperty(VF_FOG_FADEDEPTH, 0.0);
    
    makevectors(getpropertyvec(VF_ANGLES));
    setorigin( UI_HANGAR_DATA_mech, viewOrg + [0, 0, zBias] + (v_forward * ( ((modelMins_z*-1) + modelMax_z) / 1.8 )));
    cOrg = UI_HANGAR_DATA_mech.origin;
    
    addentity(UI_HANGAR_DATA_mech);
    
    makevectors(UI_HANGAR_DATA_mech.angles);
    
    UI_HANGAR_DATA_mech.torsoCenter.origin = UI_HANGAR_DATA_mech.origin;
    addentity(UI_HANGAR_DATA_mech.torsoCenter);
     
    if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_TOR_L) ){
      mOffset = UI_HANGAR_DATA_mech.torsoLeft.compOffset;
      UI_HANGAR_DATA_mech.torsoLeft.origin = cOrg + (v_forward * mOffset_z) + (v_up * mOffset_y) + (v_right * mOffset_x);
      addentity(UI_HANGAR_DATA_mech.torsoLeft);
    }
    if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_TOR_R) ){
      mOffset = UI_HANGAR_DATA_mech.torsoRight.compOffset;
      UI_HANGAR_DATA_mech.torsoRight.origin = cOrg + (v_forward * mOffset_z) + (v_up * mOffset_y) + (v_right * mOffset_x);
      addentity(UI_HANGAR_DATA_mech.torsoRight);
    }
    if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_ARM_L) ){
      mOffset = UI_HANGAR_DATA_mech.armLeft.compOffset;
      UI_HANGAR_DATA_mech.armLeft.origin = cOrg + (v_forward * mOffset_z) + (v_up * mOffset_y) + (v_right * mOffset_x);
      addentity(UI_HANGAR_DATA_mech.armLeft);
    }
    if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_ARM_R) ){
      mOffset = UI_HANGAR_DATA_mech.armRight.compOffset;
      UI_HANGAR_DATA_mech.armRight.origin = cOrg + (v_forward * mOffset_z) + (v_up * mOffset_y) + (v_right * mOffset_x);
      addentity(UI_HANGAR_DATA_mech.armRight);
    }
    
    mOffset = UI_HANGAR_DATA_mech.legs.compOffset;
    UI_HANGAR_DATA_mech.legs.origin = cOrg + (v_forward * mOffset_z) + (v_up * mOffset_y) + (v_right * mOffset_x);
    addentity(UI_HANGAR_DATA_mech.legs);
  
  renderscene();
  setproperty(VF_ORIGIN, VIEW_VF_ORG);
  setproperty(VF_FOV, VIEW_FOV); 
  setproperty(VF_ORIGIN, pmove_org);	//look towards it.
  setproperty(VF_ANGLES, input_angles);
  setproperty(VF_MIN, '0 0 0');
  setproperty(VF_SIZE, VIEW_ACT);
  setproperty(VF_DRAWWORLD, 0);
///==========
};