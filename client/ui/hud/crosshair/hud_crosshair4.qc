/*
battleMETAL
Author: Peter Roohr
Date: 09/09/2020
Overview:
  Crosshair code file - taken from hud_view for readability / maintenance.
  
  Crosshair Type 4
  
  //GLOBAL REFERENCES
    CLIENT_stat_hit_dirs    - hit direction indicators
    CLIENT_stat_trg_face    - player facing selected target
    CLIENT_accuracy         - player moving or not
    CLIENT_target_shield    - target has shield
    CLIENT_stat_rdr_mode    - player active radar
*/
void() hud_renderCrosshair4={  
  
  local float hitAlpha;
  local vector hitColor;
  
  local vector imgSize;
  local vector pipSize;
  local vector lockSize;
  //local vector drift;
  
  local vector imgCenter;
  local vector pipCenter;
  local vector lockCenter;

  //--------------------
  hitColor = HUD_COLOR_DEF;
  hitAlpha = HUD_ALPHA;
  
  //drift = Vector2( 8 * CLIENT_accuracy, 8 * CLIENT_accuracy );
  imgSize = '16 16';

  //base image
  imgCenter_x = VIEW_CTR_x - imgSize_x / 2;
  imgCenter_y = VIEW_CTR_y - imgSize_y / 2;

  drawpic(imgCenter, "gfx/hud/ret/crosshair4.png", imgSize, HUD_COLOR_DEF, HUD_ALPHA, DRAWFLAG_NORMAL);  
  
  if( (CLIENT_stat_hit_dirs & STAT_HIT_TRG) ){
    if(CLIENT_target_shield > 0){
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
  if( CLIENT_stat_trg_ent_id == 0 ){
    return;
  }
  if( !CLIENT_stat_rdr_mode ){
    return;
  }
  if( CLIENT_stat_trg_face > 270 || CLIENT_stat_trg_face < 45 ){
    lockSize = '34 34';
    lockCenter_x = VIEW_CTR_x - lockSize_x / 2;
    lockCenter_y = VIEW_CTR_y - lockSize_y / 2;
    CROSSHAIR_ANGLE_LOCK = anglemod(CROSSHAIR_ANGLE_LOCK + (frametime * 67));
    drawrotpic(lockCenter + lockSize * 0.5, "gfx/hud/ret/crosshair4_lock.png", lockSize, lockSize / 2, CROSSHAIR_ANGLE_LOCK, CLR_DEF_RET_HASLOCK, max(0.45, HUD_ALPHA * 0.67), DRAWFLAG_NORMAL);
  }
};