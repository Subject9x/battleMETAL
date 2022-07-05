/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  Crosshair Type 2
  
  //GLOBAL REFERENCES
    CLIENT_stat_hit_dirs    - hit direction indicators
    CLIENT_stat_trg_face    - player facing selected target
    CLIENT_accuracy         - player moving or not
    CLIENT_target_shield    - target has shield
    CLIENT_stat_rdr_mode    - player active radar
*/
void() hud_renderCrosshair2={
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
  
  drift = [ 8 * CLIENT_accuracy, 8 * CLIENT_accuracy ];
  imgSize = '28 28';
  pipSizeH = '15 3';
  pipSizeV = '3 15';
  
  if( (CLIENT_stat_hit_dirs & STAT_HIT_TRG) ){
    if(CLIENT_target_shield > 0){
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
  if( !CLIENT_stat_trg_face || CLIENT_stat_trg_face != AIM_FACE_FRONT ){
    drawpic(imgCenter, "gfx/hud/ret/crosshair2.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  }

  //convergence
  pipLeft = VIEW_CTR - '17 1.5';
  pipLeft_x = pipLeft_x - drift_x;
    
  pipRight = VIEW_CTR + '2 -1.5';
  pipRight_x = pipRight_x + drift_x;
  
  pipTop = VIEW_CTR - '1.5 17';
  pipTop_y = pipTop_y - drift_y;
  
  pipBottom = VIEW_CTR + '-1.5 2';
  pipBottom_y = pipBottom_y + drift_y;
  
  drawpic(pipLeft, "gfx/hud/ret/crosshair2_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipRight, "gfx/hud/ret/crosshair2_rhrz.png", pipSizeH, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  
  drawpic(pipTop, "gfx/hud/ret/crosshair2_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);
  drawpic(pipBottom, "gfx/hud/ret/crosshair2_rvrt.png", pipSizeV, hitColor, hitAlpha, DRAWFLAG_NORMAL);

  //lock on indicators
  if( CLIENT_target_ent == world ){
    return;
  }
  if( (CLIENT_stat_trg_face > 270 || CLIENT_stat_trg_face < 45) && CLIENT_stat_rdr_mode ){
    lockSize = '34 34';
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    drawpic(lockCenter, "gfx/hud/ret/crosshair2_lock.png", lockSize, CLR_DEF_RET_HASLOCK, HUD_ALPHA, DRAWFLAG_NORMAL);
  }
};