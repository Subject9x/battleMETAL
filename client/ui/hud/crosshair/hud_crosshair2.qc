/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  Crosshair Type 2
  
  //GLOBAL REFERENCES
    CLIENT_stat_hit_targ    - hit direction indicators
    CLIENT_stat_trg_face    - player facing selected target
    CLIENT_accuracy         - player moving or not
    CLIENT_target_shield    - target has shield
    CLIENT_stat_rdr_mode    - player active radar
*/
void() hud_renderCrosshair2={
  
  local vector pipSizeH;
  local vector pipSizeV;
  local vector drift;
  local vector pipLeft;
  local vector pipRight;
  local vector pipTop;
  local vector pipBottom;
  
  
  CROSSHR_HAS_LOCK = FALSE;
  if( CLIENT_stat_rdr_mode ){
    if( CLIENT_target_ent != world ){
      if( CLIENT_stat_trg_face >= 270 || CLIENT_stat_trg_face <= 45){
        CROSSHR_HAS_LOCK = TRUE;
      }
    }
  }
  
  CROSSHR_HIT_CLR = HUD_COLOR_DEF;
  CROSSHR_HIT_ALPHA = HUD_ALPHA;
  
  drift = [ 8 * CLIENT_accuracy, 8 * CLIENT_accuracy ];
  CROSSHR_IMG_SIZE = '28 28';
  pipSizeH = '15 3';
  pipSizeV = '3 15';
  
  if( (CLIENT_stat_hit_targ & STAT_HIT_TRG) ){
    if(CLIENT_target_shield > 0){
      CROSSHR_HIT_CLR = CLR_DEF_ARM_OK;
      CROSSHR_HIT_ALPHA = 1;
    }
    else{
      CROSSHR_HIT_CLR = CROSSHR_HIT_CLR + '0.8 0.8 0.8';
      CROSSHR_HIT_ALPHA = 1;
    }
  }
  
  //base image
  CROSSHR_IMG_CENTER_x = VIEW_CTR_x - CROSSHR_IMG_SIZE_x / 2;
  CROSSHR_IMG_CENTER_y = VIEW_CTR_y - CROSSHR_IMG_SIZE_y / 2;
  if( !CLIENT_stat_trg_face || CLIENT_stat_trg_face != AIM_FACE_FRONT ){
    drawpic(CROSSHR_IMG_CENTER, "gfx/hud/ret/crosshair2.png", CROSSHR_IMG_SIZE, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  }

  //lock on indicators
  if( CROSSHR_HAS_LOCK ){
    CROSSHR_LOCK_SIZE = '34 34';
    CROSSHR_LOCK_CENTER_x = VIEW_CTR_x - CROSSHR_LOCK_SIZE_x / 2;
    CROSSHR_LOCK_CENTER_y = VIEW_CTR_y - CROSSHR_LOCK_SIZE_y / 2;
    drawpic(CROSSHR_LOCK_CENTER, "gfx/hud/ret/crosshair2_lock.png", CROSSHR_LOCK_SIZE, CLR_DEF_RET_HASLOCK, HUD_ALPHA, DRAWFLAG_NORMAL);
  }
  else{
    //convergence
    pipLeft = VIEW_CTR - '17 1.5';
    pipLeft_x = pipLeft_x - drift_x;
      
    pipRight = VIEW_CTR + '2 -1.5';
    pipRight_x = pipRight_x + drift_x;
    
    pipTop = VIEW_CTR - '1.5 17';
    pipTop_y = pipTop_y - drift_y;
    
    pipBottom = VIEW_CTR + '-1.5 2';
    pipBottom_y = pipBottom_y + drift_y;
    
    drawpic(pipLeft, "gfx/hud/ret/crosshair2_rhrz.png", pipSizeH, CROSSHR_HIT_CLR, CROSSHR_HIT_ALPHA, DRAWFLAG_NORMAL);
    drawpic(pipRight, "gfx/hud/ret/crosshair2_rhrz.png", pipSizeH, CROSSHR_HIT_CLR, CROSSHR_HIT_ALPHA, DRAWFLAG_NORMAL);
    
    drawpic(pipTop, "gfx/hud/ret/crosshair2_rvrt.png", pipSizeV, CROSSHR_HIT_CLR, CROSSHR_HIT_ALPHA, DRAWFLAG_NORMAL);
    drawpic(pipBottom, "gfx/hud/ret/crosshair2_rvrt.png", pipSizeV, CROSSHR_HIT_CLR, CROSSHR_HIT_ALPHA, DRAWFLAG_NORMAL);
  }
  CROSSHR_HAS_LOCK = FALSE;
  CROSSHR_HIT_CLR = '1.0 1.0 1.0';
  CROSSHR_HIT_ALPHA = HUD_ALPHA;
};