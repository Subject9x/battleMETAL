/*
mech Mod
Author: Peter Roohr
Date: 04/10/2017
Overview: impl file for the hud sound system
*/

void() snd_hud_vfx_frame={
  if(time > STIME_NEXT){
    local float sfx_len, itr;
    if(SOUNDQUEUE[0] != "null"){
      sfx_len = soundlength(SOUNDQUEUE[0]);
      pointsound(pmove_org, SOUNDQUEUE[0], 1, ATTN_NONE);
      STIME_NEXT = time + sfx_len + 0.05;
    }
    itr = SQSIZE;
    while( itr > -1 ){
      local float prev;
      prev = itr - 1;
      SOUNDQUEUE[prev] = SOUNDQUEUE[itr];
      SOUNDQUEUE[itr] = "null";
      itr = itr - 1;
    }
  }
};

void() snd_hud_vfx_cleanqueue={

};

//count == how many instances of 1 sound can be queued at a time
void(string requestedSound, float cnt) snd_hud_vfx_addtoqueue={
  local float idx, cur;
  idx = cur = 0;
  SQUED = FALSE;  
  while(idx < SQSIZE){
    if(SOUNDQUEUE[idx] == requestedSound){
      cur = cur + 1;
    }
    idx = idx + 1;
  }
  if(cur >= cnt){
    return;
  }
  cur = 0;
  idx = 0;
  while(idx < SQSIZE){
    if(SOUNDQUEUE[idx] == requestedSound){
      cur = cur + 1;
    }
    if(SOUNDQUEUE[idx] == "null"){
      if(cur < cnt){
        SOUNDQUEUE[idx] = requestedSound;
        cur = cur + 1;
      }
    }
    idx = idx + 1;
  }
  SQUED = FALSE;
};

void(float playerState) snd_hud_vfx_statelistener={
  if(self.player_state == PLAYER_POWERUP_BEGIN){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE, 1);
    CRITBITS = 0;
  }
  else if(self.player_state == PLAYER_ACTIVE){
    if(CRITBITS == 0){
      CRITBITS = CRITBITS | 1 | 2 | 4 | 8 | 16 | 32;
    }
  }
};

void(float lockstate) snd_hud_vfx_locklistener={
};

void(float curEn) snd_hud_vfx_enelistener={
  if(curEn == 10){
    if(SQ1 != SND_HUD_VFX_ENELOW){
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_ENELOW, 1);
    }
  }
};

void(float curSh) snd_hud_vfx_shdlistener={
  if(curSh == 10){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_SHDLOW, 1);
  }
};

void(float amt, float bit, string snd) snd_hud_vfx_armlistener={
  if(self.player_state == PLAYER_ACTIVE){
    if(amt <= 0){
      if( (CRITBITS & bit) ){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 3); 
        snd_hud_vfx_addtoqueue(snd, 1);
        CRITBITS = CRITBITS - (CRITBITS & bit);
      }
    }
  }
};

void(float preState, float nexState) snd_hud_vfx_navpointlistener={
  local entity player;
  player = entitybyindex(player_localentnum);
  if(player){
    if(self.i_faction == player.i_faction){
      if(nexState == FALSE){
        if(preState == TRUE){
          snd_hud_vfx_addtoqueue(SND_HUD_VFX_NAVRECH, 3);
          MSN_OBJ_STATUS[self.data_idx] = TRUE;
        }
      }
    }
  }
};

void(float preState, float nexState) snd_hud_vfx_objectivelistener={
  local entity player;
  player = entitybyindex(player_localentnum);
  if(player){
    if(self.i_faction == player.i_faction){
      if(nexState == FALSE){
        if(preState == TRUE){
          if(self.data_idx == 1){
            snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_PRIME, 1);
          }
          else if(self.data_idx == 2){
            snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_SECON, 1);
          }
          else if(self.data_idx == 3){
            snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_THIRD, 1);
          }
          else if(self.data_idx == 254){
            snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_WIN, 1);
          }
          else if(self.data_idx == 255){
            snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL, 1);
          }
        }
      }
    }
  }
};

void(float mode) snd_hud_vfx_toggleradar={
  if(self.stat_rdr_mode_prev != mode){
    self.stat_rdr_mode_prev = mode;
    if(mode){
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRACTIVE, 3);
    }
    else{
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRPASSIVE, 3); 
    }
  }
};

void(float dedflg) snd_hud_vfx_targkill={
  if(dedflg > DEAD_DEAD && dedflg < 5){
    dedflg = 5;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL, 1);
  }
};