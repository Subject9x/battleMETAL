/*
battleMETAL
Author: Peter Roohr
Date: 04/11/2020
Overview: 
  End of Round score screen for DM / TDM / Coop(?) games
  also shown when player dies.
*/

//pseudo interface
void() menu_scoreListener_onClick={
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), TRUE)){
    ui_navbutton_disconnect_click();
  }
  
  
};

//void() menu_scoreListener_onDrag={};

void() menu_scoreListener_onHover={};

//void() menu_scoreListener_onKeyUp={};

void() menu_score_drawFrame={
  local vector topleftroot;
  
  topleftroot = VIEW_ORG;
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '0.85 0.85 0.85', 1, 0);
  
  //Navbar
  menu_score_draw_bar( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );

};
//------------------

void( vector menuOrg ) menu_score_draw_bar={
  ui_navbutton_disconnect_draw( menuOrg );
};