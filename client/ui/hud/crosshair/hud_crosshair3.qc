/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  
*/

/*
  Crosshair Type 3
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair3={
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  local vector hitSize;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  local vector hitCenter;
  
  imgSize = '28 28';
  pipSizeH = '34 34';
 
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  if( !lockval ){
    drawpic(imgCenter, "gfx/hud/ret/crosshair3.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  }
  
  //accuracy pips
  pipSizeH_x = pipSizeH_x * unitAccuracy;
  pipSizeH_y = pipSizeH_y * unitAccuracy;
  pipLeft_x = VIEW_CTR_x - pipSizeH_x / 2;
  pipLeft_y = VIEW_CTR_y - pipSizeH_y / 2;
  drawpic(pipLeft, "gfx/hud/ret/crosshair3_r.png", pipSizeH, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);
  
  //lock on indicators  
  if( lockval ){
    lockSize = '34 34';
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair3_lock.png", lockSize, CLR_DEF_RET_HASLOCK, HUD_ALPHA, DRAWFLAG_NORMAL);
  }
  
  if( (hitdirection & STAT_HIT_TRG) ){
    hitSize = '27 27';
    hitCenter_x = VIEW_CTR_x - hitSize_x / 2;
    hitCenter_y = VIEW_CTR_y - hitSize_y / 2;
    if(trg_shield > 0){
      hitColor = CLR_DEF_ARM_OK;
      hitAlpha = 1;
    }
    else{
      hitColor = hitColor + '0.8 0.8 0.8';
      hitAlpha = 1;
    }
    drawpic(hitCenter, "gfx/hud/ret/crosshair3_hit.png", hitSize, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  }
};
