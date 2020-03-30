/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  Utility functions for the UI system.
  These are non-menu specific functions that I couldn't find a better
  place to put.
  
*/

/*
  Renders the weapon icon, and a highlight box for a selected hardpoint in
  the Arming Menu.
*/
void(string imageIcon, vector org, float selected, float allow) ui_renderHardPointGraphic={
  local vector iorg;
  local vector noEditColorAdj;
  local float allowAlpha;
  
  if( imageIcon != ""){
    if(selected){
      iorg = org - gui_percentToPixelRawVec('2 2');
      gui_renderTintImage(selected, iorg, UI_DEF_BOX_256, gui_percentToPixelRawVec('32 32'), CLR_DEF_ARM_THREEQ + '0.1 0.1 0.1' , 1, 0);
    }
    allowAlpha = 0.45;
    if( allow ){
      allowAlpha = 1;
    }
    drawpic( org, imageIcon,  gui_percentToPixelRawVec('28 28'), '1 1 1' - noEditColorAdj, allowAlpha, 0);
  }
};

/*
  Renders 1 row in the Hangar Menu.
  Displays Hardpoint data for the selected Mech.
*/
void(vector org, float hpt_num, float types, float sz) ui_renderHardpointRow={
  local vector pofs, hptNumOrg, hptSizeOrg;
  local float localHardpointSize;
  local string hardpointLabel, hardpointSizeLabel;
  local float drawfontLocal;
  
  drawfontLocal = drawfont;
  drawfontLocal = FONT_NUM_ROBOT_REGULAR;
  
  pofs = org + gui_percentToPixelRawVec('0 8');
  pofs_x = org_x + gui_percentXRaw((hpt_num * 26));
  
  drawpic( pofs + gui_percentToPixelRawVec('0 -2'), UI_BOX_SELECT, gui_percentToPixelRawVec('25 150'), '0.45 0.45 0.45', 0.75, 0);
  
  hardpointLabel = strcat("{",ftos(hpt_num + 1),"}");
  
  hptNumOrg = pofs + gui_percentToPixelRawVec('0 -2');
  hptNumOrg_x = hptNumOrg_x + gui_percentXRaw(25 / 2) - gui_percentXRaw(stringwidth(hardpointLabel, 0, '12 12 0') / 2);
  
  drawstring(hptNumOrg, hardpointLabel, '12 12 0', CLR_DEF_RET_HASLOCK, 1, 0);
  
  localHardpointSize = sz;
  hardpointSizeLabel = ftos(localHardpointSize);
  hptSizeOrg = pofs + gui_percentToPixelRawVec('0 24');
  hptSizeOrg_x = hptSizeOrg_x + gui_percentXRaw(30 / 2) - gui_percentXRaw(stringwidth(hardpointLabel, 0, '14 14 0') / 2);
  if( localHardpointSize == 2 ){
    drawstring(hptSizeOrg, hardpointSizeLabel, '14 14 0', CLR_DEF_WHITE,1 , 0);
  }
  else if( localHardpointSize == 3){
    drawstring(hptSizeOrg, hardpointSizeLabel, '14 14 0', CLR_DEF_WHITE,1 , 0);
  }
  else{
    drawstring(hptSizeOrg, hardpointSizeLabel, '14 14 0', CLR_DEF_WHITE,1 , 0);
  }
  
  if((types & DMG_ENE)){
    drawpic(pofs + gui_percentToPixelRawVec('3 60'), UI_WEP_ENE, gui_percentToPixelRawVec('18 18'), CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2', 1, 0);
  }
  if((types & DMG_BAL)){
    drawpic(pofs + gui_percentToPixelRawVec('3 80'), UI_WEP_BAL, gui_percentToPixelRawVec('18 18'), CLR_DEF_ARM_HALF, 1, 0);
  }
  if((types & DMG_EXP)){
    drawpic(pofs + gui_percentToPixelRawVec('3 100'), UI_WEP_EXP, gui_percentToPixelRawVec('18 18'), CLR_DEF_ARM_OK, 1, 0);
  }
  if((types & DMG_MSC)){
    drawpic(pofs + gui_percentToPixelRawVec('3 120'), UI_WEP_MSC, gui_percentToPixelRawVec('18 18'), CLR_HUD_PURPLE, 1, 0);
  }
  
  drawfont = drawfontLocal;
};

/*

*/
void(float num, vector org) ui_renderHardPointNumber={
  local vector numberOrg;
  local float width;
  local string hardpointLabel;
  local float drawfontLocal;
  
  drawfontLocal = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  hardpointLabel = ftos(num);
  width = stringwidth(hardpointLabel, 0, gui_percentToPixelRawVec('16 14'));
  numberOrg = org;
  numberOrg_x = numberOrg_x - gui_percentXRaw(width / 2);
  drawstring(numberOrg, hardpointLabel, gui_percentToPixelRawVec('16 14'), CLR_DEF_RET_HASLOCK, 1, 0);
  
  drawfont = drawfontLocal;
};

/*
float SPRITE_deploy_point_FRAME;
float SPRITE_deploy_point_FRAME_MAX;
string SPRITE_deploy_point_FRAMES[3];
*/
void(vector org, vector imageSize, vector imageColor, float imageAlpha ) ui_renderSprite_DeployPoint={
  local vector screenImageSize;
  
  screenImageSize = gui_percentToPixelRawVec( imageSize );
  if( SPRITE_deploy_point_FRAMES[SPRITE_deploy_point_FRAME] != "" ){
    drawpic( org, SPRITE_deploy_point_FRAMES[SPRITE_deploy_point_FRAME], screenImageSize, imageColor, imageAlpha, 0);
  }
  
  if( time > SPRITE_deploy_point_FRAME_TIMER ){
    SPRITE_deploy_point_FRAME = SPRITE_deploy_point_FRAME + 1;
    if( SPRITE_deploy_point_FRAME > SPRITE_deploy_point_FRAME_MAX ){
      SPRITE_deploy_point_FRAME = 1;
    }
    SPRITE_deploy_point_FRAME_TIMER = time + 0.15;
  }
};