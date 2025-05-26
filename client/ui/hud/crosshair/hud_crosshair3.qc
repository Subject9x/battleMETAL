/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.  
  Crosshair Type 3
  
  //GLOBAL REFERENCES
    CLIENT_stat_hit_targ    - hit direction indicators
    CLIENT_stat_trg_face    - player facing selected target
    CLIENT_accuracy         - player moving or not
    CLIENT_target_shield    - target has shield
    CLIENT_stat_rdr_mode    - player active radar
*/
void() hud_renderCrosshair3={
  local vector hitSize;
  local vector hitCenter;
  
  CROSSHR_IMG_SIZE = '28 28';
  
  //base image
  CROSSHR_IMG_CENTER_x = VIEW_CTR_x - CROSSHR_IMG_SIZE_x / 2;
  CROSSHR_IMG_CENTER_y = VIEW_CTR_y - CROSSHR_IMG_SIZE_y / 2;
  if( CLIENT_stat_trg_face ){
    CROSSHR_RET_ALPHA =  max(0.5, HUD_ALPHA * 0.67);
  }
  else{
    CROSSHR_RET_ALPHA = HUD_ALPHA;
  }
  drawpic(CROSSHR_IMG_CENTER, "gfx/hud/ret/crosshair3.png", CROSSHR_IMG_SIZE, HUD_COLOR_DEF, CROSSHR_RET_ALPHA, DRAWFLAG_NORMAL);  
  
  if( (CLIENT_stat_hit_targ & STAT_HIT_TRG) ){
    hitSize = '27 27';
    hitCenter_x = VIEW_CTR_x - hitSize_x / 2;
    hitCenter_y = VIEW_CTR_y - hitSize_y / 2;
    if(CLIENT_target_shield > 0){
      CROSSHR_HIT_CLR = CLR_DEF_ARM_OK;
      CROSSHR_HIT_ALPHA = 1;
    }
    else{
      CROSSHR_HIT_CLR = CROSSHR_HIT_CLR + '0.8 0.8 0.8';
      CROSSHR_HIT_ALPHA = 1;
    }
    drawpic(hitCenter, "gfx/hud/ret/crosshair3_hit.png", hitSize, CROSSHR_HIT_CLR, CROSSHR_HIT_ALPHA, DRAWFLAG_NORMAL);
  }
  //lock on indicators  
  CROSSHR_HAS_LOCK = FALSE;
  if( CLIENT_target_ent != world ){
    if( CLIENT_stat_rdr_mode ){
      if( CLIENT_stat_trg_face >= 270 || CLIENT_stat_trg_face <= 45){
        CROSSHR_HAS_LOCK = TRUE;
      }
    }
  }
  
  if( CROSSHR_HAS_LOCK ){
    CROSSHR_LOCK_SIZE = '34 34';
    CROSSHR_LOCK_CENTER_x = VIEW_CTR_x - CROSSHR_LOCK_SIZE_x / 2;
    CROSSHR_LOCK_CENTER_y = VIEW_CTR_y - CROSSHR_LOCK_SIZE_y / 2;
    
    CROSSHAIR_ANGLE_LOCK = anglemod(CROSSHAIR_ANGLE_LOCK + (frametime * 75));
    drawrotpic(CROSSHR_LOCK_CENTER + CROSSHR_LOCK_SIZE * 0.5, "gfx/hud/ret/crosshair3_lock.png", CROSSHR_LOCK_SIZE, CROSSHR_LOCK_SIZE / 2, CROSSHAIR_ANGLE_LOCK, CLR_DEF_RET_HASLOCK, max(0.5, HUD_ALPHA * 0.67), DRAWFLAG_NORMAL);
  }
  CROSSHR_HAS_LOCK = FALSE;
  CROSSHR_HIT_CLR = '1.0 1.0 1.0';
  CROSSHR_HIT_ALPHA = HUD_ALPHA;
  CROSSHR_RET_ALPHA = HUD_ALPHA;
};
