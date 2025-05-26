/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  
  Crosshair Type 4
  
  //GLOBAL REFERENCES
    CLIENT_stat_hit_targ    - hit direction indicators
    CLIENT_stat_trg_face    - player facing selected target
    CLIENT_accuracy         - player moving or not
    CLIENT_target_shield    - target has shield
    CLIENT_stat_rdr_mode    - player active radar
*/
void() hud_renderCrosshair4={
  
  local vector pipSize;
  //local vector drift;
  local vector pipCenter;

  //--------------------
  CROSSHR_HIT_CLR = HUD_COLOR_DEF;
  CROSSHR_HIT_ALPHA = HUD_ALPHA;
  
  //drift = Vector2( 8 * CLIENT_accuracy, 8 * CLIENT_accuracy );
  CROSSHR_IMG_SIZE = '16 16';

  //base image
  CROSSHR_IMG_CENTER_x = VIEW_CTR_x - CROSSHR_IMG_SIZE_x / 2;
  CROSSHR_IMG_CENTER_y = VIEW_CTR_y - CROSSHR_IMG_SIZE_y / 2;

  drawpic(CROSSHR_IMG_CENTER, "gfx/hud/ret/crosshair4.png", CROSSHR_IMG_SIZE, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  if( (CLIENT_stat_hit_targ & STAT_HIT_TRG) ){
    if(CLIENT_target_shield > 0){
      CROSSHR_HIT_CLR = CLR_DEF_ARM_OK;
      CROSSHR_HIT_ALPHA = 1;
    }
    else{
      CROSSHR_HIT_CLR = CROSSHR_HIT_CLR + '0.8 0.8 0.8';
      CROSSHR_HIT_ALPHA = 1;
    }
    pipSize = '24 24';
    pipCenter_x = VIEW_CTR_x - pipSize_x / 2;
    pipCenter_y = VIEW_CTR_y - pipSize_y / 2;
    drawpic(pipCenter, "gfx/hud/ret/crosshair4_r.png", pipSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
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
  if( CROSSHR_HAS_LOCK){
    CROSSHR_LOCK_SIZE = '34 34';
    CROSSHR_LOCK_CENTER_x = VIEW_CTR_x - CROSSHR_LOCK_SIZE_x / 2;
    CROSSHR_LOCK_CENTER_y = VIEW_CTR_y - CROSSHR_LOCK_SIZE_y / 2;
    CROSSHAIR_ANGLE_LOCK = anglemod(CROSSHAIR_ANGLE_LOCK + (frametime * 67));
    drawrotpic(CROSSHR_LOCK_CENTER + CROSSHR_LOCK_SIZE * 0.5, "gfx/hud/ret/crosshair4_lock.png", CROSSHR_LOCK_SIZE, CROSSHR_LOCK_SIZE / 2, CROSSHAIR_ANGLE_LOCK, CLR_DEF_RET_HASLOCK, max(0.45, HUD_ALPHA * 0.67), DRAWFLAG_NORMAL);
  }

  CROSSHR_HAS_LOCK = FALSE;
  CROSSHR_HIT_CLR = '1.0 1.0 1.0';
  CROSSHR_HIT_ALPHA = HUD_ALPHA;
};