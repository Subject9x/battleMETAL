/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  
*/

/*
  Crosshair Type 4
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair4={  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  
  imgSize = gui_percentToPixelRawVec('32 32');
  pipSizeH = gui_percentToPixelRawVec('34 34');
 
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  if( !(lockval & LOCK_TARG_HAS)  ){
    drawpic(imgCenter, "gfx/hud/ret/crosshair4.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  }
  
  pipSizeH_x = pipSizeH_x * unitAccuracy;
  pipSizeH_y = pipSizeH_y * unitAccuracy;
  pipLeft_x = VIEW_CTR_x - pipSizeH_x / 2;
  pipLeft_y = VIEW_CTR_y - pipSizeH_y / 2;
  drawpic(pipLeft, "gfx/hud/ret/crosshair4_r.png", pipSizeH, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);
  
  //lock on indicators  
  if( (lockval & LOCK_TARG_START) || (lockval & LOCK_TARG_HAS) ){
    lockSize = gui_percentToPixelRawVec('34 34');
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair4_lock.png", lockSize, HUD_LOCK_COLOR, HUD_LOCK_ALPHA, DRAWFLAG_NORMAL);
  }
};