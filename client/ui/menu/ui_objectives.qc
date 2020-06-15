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
    
    lst_idx = 0;
    itr = 1; 
    torg = org + gui_percentToPixelRawVec('32 128');
    drawstring(torg, "[OBJECTIVES]", '14 14 0', HUD_COLOR_DEF, 1.1, 0);
    while( itr < 32 ){
      local float complete;
      local vector line, colr;
      local string obj;

      complete = OBJECTIVES[itr];
      if( complete != OBJECTIVE_DISABLE ){
        line = torg;
        line_y = line_y + gui_percentYRaw( (lst_idx+1) * 16);
        obj = strcat(ftos(lst_idx+1),") ",MSN_OBJ_DESC[itr]); 
        colr = HUD_COLOR_DEF;
        if( complete == OBJECTIVE_FAIL ){
          colr = CLR_DEF_RED;
          obj = strcat(obj, " !FAILED!");
        }
        if( complete == OBJECTIVE_WIN ){
          colr = CLR_DEF_GREEN_OK;
          obj = strcat(obj, " [COMPLETE]");
        }
        drawstring(line, obj, '12 12 0', colr * 1.33, 1, 0);
        lst_idx = lst_idx + 1;
      }
      
      itr = itr + 1;
    }
  }
  
  drawfont = drawfont_prev;
};
