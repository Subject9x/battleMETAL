/*
battleMETAL
Author: Peter Roohr
Date: 01/08/2018
Overview: implementation for objectives menu overlay
*/

void(vector org) ui_objective_frame={
  local float lst_idx, itr;
  local vector torg;
  local entity eObj;
  if(UI_OBJECTIVE_ACTIVE){
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    
    lst_idx = 0;
    itr = 1; 
    torg = org + '8 52';
    drawstring(torg, "[OBJECTIVES]", '14 14 0', HUD_COLOR_DEF, 1.1, 0);
    while( itr < 32 ){
      local float complete;
      local vector line, colr;
      local string objText;

      complete = OBJECTIVES[itr];
      if( complete != OBJECTIVE_DISABLE ){
        
        eObj = data_objective_find( itr );
        line = torg;
        line_y = line_y + ( (lst_idx+1) * 16);
        objText = strcat(ftos(lst_idx+1),") ",MSN_OBJ_DESC[itr]); 
        colr = HUD_COLOR_DEF;
        if( eObj ){
          if( eObj.aState == 2 ){
            colr = CLR_UI_OBJT_SECOND;
            objText = strcat("(OPTIONAL)", objText);
          }
          if(  eObj.aState == 3 ){
            colr = CLR_UI_OBJT_THIRD;
            objText = strcat("(OPTIONAL)", objText);
          }
        }
        if( complete == OBJECTIVE_FAIL ){
          colr = CLR_DEF_RED;
          objText = strcat(objText, " !FAILED!");
        }
        if( complete == OBJECTIVE_WIN ){
          colr = CLR_DEF_GREEN_OK;
          objText = strcat(objText, " [COMPLETE]");
        }
        drawstring(line, objText, '12 12 0', colr * 1.33, 1, 0);
        lst_idx = lst_idx + 1;
      }
      
      itr = itr + 1;
    }
  }
  
  drawfont = drawfont_prev;
};
