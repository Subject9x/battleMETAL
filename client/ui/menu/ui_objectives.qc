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
    lst_idx = 1;
    itr = 0; 
    torg = org + gui_percentToPixelRawVec('16 128');
    drawstring(torg, "[OBJECTIVES]", '8 8 0', CLR_DEF_ARM_OK, HUD_ALPHA, 0);
    while( itr <= 32 ){
      local float complete;
      local vector line, colr;
      local string obj;
      
      complete = OBJECTIVES[itr];
      if( complete != FALSE ){
        line = torg;
        line_y = line_y + (lst_idx *14);
        obj = strcat("[",ftos(lst_idx),"]:",MSN_OBJ_DESC[lst_idx],"\n"); 
        colr = CLR_DEF_GRAY_H;
        if( complete == -1 ){
          colr = CLR_DEF_ARM_DED;
        }
        if( complete == 2 ){
          colr = CLR_DEF_ARM_OK;
        }
        drawstring(line, obj, '7 8 0', colr, HUD_ALPHA, 0);
        lst_idx = lst_idx + 1;
      }
      itr = itr + 1;
    }
  }
};
