/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  
*/

float CROSSHAIR4_ANGLE;

/*
  Crosshair Type 4
*/
void(float hitdirection, float lockval, float unitAccuracy, float trg_shield) hud_renderCrosshair4={  
  
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector pipSize;
  local vector lockSize;
  local vector drift;
  
  local vector imgCenter;
  local vector pipCenter;
  local vector lockCenter;

  //--------------------
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  drift = Vector2( 8 * unitAccuracy, 8 * unitAccuracy );
  imgSize = '16 16';

  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;

  drawpic(imgCenter, "gfx/hud/ret/crosshair4.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  if( (hitdirection & STAT_HIT_TRG) ){
    if(trg_shield > 0){
      hitColor = CLR_DEF_ARM_OK;
      hitAlpha = 1;
    }
    else{
      hitColor = hitColor + '0.8 0.8 0.8';
      hitAlpha = 1;
    }
    pipSize = '24 24';
    pipCenter_x = VIEW_CTR_x - pipSize_x / 2;
    pipCenter_y = VIEW_CTR_y - pipSize_y / 2;
    drawpic(pipCenter, "gfx/hud/ret/crosshair4_r.png", pipSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  }
  

  //lock on indicators
  if( lockval ){
    lockSize = '34 34';
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    CROSSHAIR4_ANGLE = anglemod(CROSSHAIR4_ANGLE + (frametime * 67));
    drawrotpic(lockCenter + lockSize * 0.5, "gfx/hud/ret/crosshair4_lock.png", lockSize, lockSize / 2, CROSSHAIR4_ANGLE, CLR_DEF_RET_HASLOCK, max(0.33, HUD_ALPHA * 0.5), DRAWFLAG_NORMAL);
  }
};