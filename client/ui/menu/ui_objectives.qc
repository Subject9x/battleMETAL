/*
battleMETAL
Author: Peter Roohr
Date: 01/08/2018
Overview: implementation for objectives menu overlay
*/

void(vector org) ui_objective_frame={
  if(UI_OBJECTIVE_ACTIVE){
    local float lst_idx, itr;
    local vector torg;
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    
    lst_idx = 1;
    itr = 0; 
    torg = org + gui_percentToPixelRawVec('16 128');
    drawstring(torg, "[OBJECTIVES]", '14 14 0', HUD_COLOR_DEF, 0.9, 0);
    while( itr <= 32 ){
      local float complete;
      local vector line, colr;
      local string obj;
      
      complete = OBJECTIVES[itr];
      if( complete < 254 ){
        if( complete != FALSE ){
          line = torg;
          line_y = line_y + (lst_idx * 16);
          obj = strcat(ftos(lst_idx),") ",MSN_OBJ_DESC[lst_idx]); 
          colr = HUD_COLOR_DEF;
          if( complete == OBJECTIVE_FAIL ){
            colr = CLR_DEF_RED;
            obj = strcat(obj, " !FAILED!");
          }
          if( complete == OBJECTIVE_WIN ){
            colr = CLR_DEF_GREEN_OK;
            obj = strcat(obj, " [COMPLETE]");
          }
          drawstring(line, obj, '12 12 0', colr, 0.9, 0);
          lst_idx = lst_idx + 1;
        }
      }
      itr = itr + 1;
    }
  }
  
  drawfont = drawfont_prev;
};
