/*
battleMETAL
Author: Peter Roohr
Date: 05/26/2023
Overview:
  Gameplay wiki and lore dump
*/


/*
  Primary menu rendering function, called by client_main.
  renders the NavBar at the top, along with the chosen menu sub function
*/
void() wiki_handleFrame={
  local vector mpos;
  
  cursorpos = getmousepos();
  
  cursorImageSize = draw_getimagesize(UI_CURSOR_IMG);
  cursorImageSize =  gui_scaleSize(cursorImageSize, VIEW_SCALE/1.25);
  
  mpos_x = cursorpos_x - 2;
  mpos_y = cursorpos_y - 4;
  
  handle_input_drag();
  handle_input_hover();
  
  switch( WIKI_MENU_CHOICE ){
    case MENU_HANGAR_ACTIVE:
      menu_hangarDrawFrame(); 
      break;
    case MENU_BRIEF_ACTIVE:
      menu_briefDrawFrame();
      break;
    case MENU_ARMING_ACTIVE:
      menu_arming_drawFrame();
      break;
    case MENU_DEPLOY_ACTIVE:
      menu_deployDrawFrame();
      break;
    case MENU_DEBRIEF_ACTIVE:
      menu_debrief_drawFrame();
      break;
    case MENU_CONNECT_ACTIVE:
      menu_connect_drawFrame();
      break;
    case MENU_SCORE_ACTIVE:
      menu_score_drawFrame();
      break;
    case MENU_REBIND_ACTIVE:
      menu_rebind_drawFrame();
      break;
  }

  if( toolTip.data_idx > FALSE ){
    gui_toolTipMessage(toolTip.description, toolTip.mins, toolTip.maxs, UI_DEF_BOX_512, '12 0', toolTip.angles, '0.85 0.85 0.85', 1 ); 
  }
  drawpic(mpos, UI_CURSOR_IMG, cursorImageSize, '1 1 1', 1, 0);
}

void() wiki_mainListener={

  local vector v;
  
  v = '0 0 0';
};