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
  
  menu_debrief_objectives( topleftroot );
  menu_debrief_stats( topleftroot );
  menu_debrief_unlocks( topleftroot );
};

void(vector panelOffset) menu_debrief_objectives={
  local vector thisOrg;
  local vector panelImageSize;
  
  thisOrg = panelOffset;
  panelImageSize_x = VIEW_MAX_x;
  panelImageSize_y = gui_percentYRaw( 128 );
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
};

void(vector panelOffset) menu_debrief_stats={
  local vector thisOrg;
  local vector panelImageSize;
  
  thisOrg = panelOffset;
  panelImageSize_x = VIEW_MAX_x;
  panelImageSize_y = gui_percentYRaw( 128 );
  drawpic(thisOrg + gui_percentToPixelRawVec('0 128'), UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);

};

void(vector panelOffset) menu_debrief_unlocks={
  local vector thisOrg;
  local vector panelImageSize;
  
  thisOrg = panelOffset;
  panelImageSize_x = VIEW_MAX_x;
  panelImageSize_y = gui_percentYRaw( 128 );
  drawpic(thisOrg + gui_percentToPixelRawVec('0 256'), UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
};