/*
battleMETAL
Author: Peter Roohr
Date: 07/23/2019
Overview: 
  Debriefing screen ( sure, score screen).
  Occurs once the map has sent the PLAYER_INTERMSN.
*/

//menu hooks
void() menu_debriefListener_onClick={

};

void() menu_debriefListener_onHover={

};
//void() menu_debriefListener_onDrag; unused

//menu rendering
void() menu_debrief_drawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG;
  
  //MENU_DEBRIEF_status
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_DEPLOY, 1, 0);
  menu_debrief_header( topleftroot );
  menu_debrief_objectives( topleftroot + gui_percentToPixelRawVec('10 32'));
  menu_debrief_stats( topleftroot + gui_percentToPixelRawVec('10 160'));
  menu_debrief_unlocks( topleftroot + gui_percentToPixelRawVec('10 288'));
};

void(vector panelOffset) menu_debrief_header={
  local vector thisOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  thisOrg = panelOffset;
  
  drawstring( thisOrg + gui_percentToPixelRawVec('10 10'), "Mission Status:", '14 14', CLR_DEF_GRAY_H, 1, 0);
  
  drawstring( thisOrg + gui_percentToPixelRawVec('50 10'), MENU_DEBRIEF_data_mission_status, '16 16', CLR_DEF_GRAY_H, 1, 0);
  gui_renderHighlightStringvoid(string str, vector ofs, vector hclr, vector clr, float bool, vector sz, float alpha, float flg);
  
  drawfont = drawfont_prev;
  
};

void(vector panelOffset) menu_debrief_objectives={
  local vector thisOrg;
  local vector panelImageSize;
  
  thisOrg = panelOffset;
  panelImageSize_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw(20);
  panelImageSize_y = gui_percentYRaw( 128 );
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
};

void(vector panelOffset) menu_debrief_stats={
  local vector thisOrg;
  local vector panelImageSize;
  
  thisOrg = panelOffset;
  panelImageSize_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw(20);
  panelImageSize_y = gui_percentYRaw( 128 );
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);

};

void(vector panelOffset) menu_debrief_unlocks={
  local vector thisOrg;
  local vector panelImageSize;
  
  thisOrg = panelOffset;
  panelImageSize_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw(20);
  panelImageSize_y = gui_percentYRaw( 128 );
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
};