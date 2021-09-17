/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  
*/
/*
  Crosshair Type 1
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair1={
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector lockSize;
  local vector pipSizeH;
  local vector pipSizeV;
  local vector drift;
  
  local vector imgCenter;
  local vector lockCenter;
  local vector pipLeft;
  local vector pipRight;
  local vector pipTop;
  local vector pipBottom;
  
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  drift = Vector2( 8 * unitAccuracy, 8 * unitAccuracy );
  imgSize = '28 28';
  pipSizeH = '8 3';
  pipSizeV = '3 8';
  
  if( (hitdirection & STAT_HIT_TRG) ){
    if(trg_shield > 0){
      hitColor = CLR_DEF_ARM_OK;
      hitAlpha = 1;
    }
    else{
      hitColor = hitColor + '0.8 0.8 0.8';
      hitAlpha = 1;
    }
  }
  
  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;
  if( !lockval ){
    drawpic(imgCenter, "gfx/hud/ret/crosshair1.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  }

  //convergence
  pipLeft = VIEW_CTR - '11 1.5';
  pipLeft_x = pipLeft_x - drift_x;
    
  pipRight = VIEW_CTR + '3 -1.5';
  pipRight_x = pipRight_x + drift_x;
  
  pipTop = VIEW_CTR - '1.5 11';
  pipTop_y = pipTop_y - drift_y;
  
  pipBottom = VIEW_CTR + '-1.5 3';
  pipBottom_y = pipBottom_y + drift_y;
  
  drawpic(pipLeft, "gfx/hud/ret/crosshair1_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipRight, "gfx/hud/ret/crosshair1_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  
  drawpic(pipTop, "gfx/hud/ret/crosshair1_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipBottom, "gfx/hud/ret/crosshair1_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);

  //lock on indicators
  if( lockval ){
    lockSize = '34 34';
    //lockSize = '34 34' * HUD_LOCK_SIZE; //couldnt get it working for release.
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair1_lock.png", lockSize, CLR_DEF_RET_HASLOCK, HUD_ALPHA, DRAWFLAG_NORMAL);
  }
}; 