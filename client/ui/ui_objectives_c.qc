/*
mech Mod
Author: Peter Roohr
Date: 01/08/2018
Overview: implementation for objectives menu overlay
*/


void(vector org) ui_objective_frame={
  if(UI_OBJECTIVE_ACTIVE){
    local float lst_idx, eol;
    local vector torg;
    lst_idx = 1;
    eol = TRUE;
    torg = org + gui_percentToPixelRawVec('16 128');
    drawstring(torg, "[OBJECTIVES]", '8 8 0', CLR_DEF_GRAY_H, HUD_ALPHA, 0);
    while(eol){
      local float complete;
      local vector line;
      local string obj;
      complete = MSN_OBJ_STATUS[lst_idx];
      line = torg;
      line_y = line_y + (lst_idx *14);
      obj = strcat("[",ftos(lst_idx),"]:",MSN_OBJ_DESC[lst_idx],"\n"); 
      gui_renderHighlightString(obj, line, CLR_DEF_GRAY_H, CLR_DEF_ARM_OK, complete, '7 8 0', HUD_ALPHA, 0) ;
      if(MSN_OBJ_DESC[lst_idx+1] == ""){
        eol = FALSE;
      }
      else{
        lst_idx = lst_idx + 1;
      }
    }
  }
};
