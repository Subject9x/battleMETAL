/*
mech Mod
Author: Peter Roohr
Date: 04/10/2017
Overview: impl file for the hud sound system
*/

void() snd_hud_vfx_frame={
  if(time > PLAYER_HELPER.VOICE_TIME_NEXT){
    local float sfx_len, idx;
    local string snd;
    snd = PLAYER_HELPER.SOUND_QUEUE_1;
    if(snd != "null"){
      sfx_len = soundlength(snd);
      sound7(self, CHAN_AUTO, snd, 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
      PLAYER_HELPER.VOICE_TIME_NEXT = time + sfx_len + 0.05;
    }
    //else{
    //  PLAYER_HELPER.VOICE_TIME_NEXT = time + 0.25;
    //}
    PLAYER_HELPER.SOUND_QUEUE_1 = PLAYER_HELPER.SOUND_QUEUE_2;
    PLAYER_HELPER.SOUND_QUEUE_2 = PLAYER_HELPER.SOUND_QUEUE_3;
    PLAYER_HELPER.SOUND_QUEUE_3 = PLAYER_HELPER.SOUND_QUEUE_4;
    PLAYER_HELPER.SOUND_QUEUE_4 = PLAYER_HELPER.SOUND_QUEUE_5;
    PLAYER_HELPER.SOUND_QUEUE_5 = PLAYER_HELPER.SOUND_QUEUE_6;
    PLAYER_HELPER.SOUND_QUEUE_6 = "null";
  }
};

void() snd_hud_vfx_cleanqueue={
  /*local float idx;
  idx = 0;
  while(idx < PLAYER_HELPER.VOICE_QUEUE_SIZE){
    VOICE_QUEUE[idx] = "null";
    idx = idx + 1;
  }*/
};

float(.string snd_q, float max, float count, .float qued, string requestedSound) snd_hud_vfx_enqueue={
  if(count < max){
    if(self.snd_q == "null"){
      if(self.qued == FALSE){
        self.snd_q = requestedSound;
        self.qued = TRUE;
        count = count + 1;
      }
    }
    else if(self.snd_q == requestedSound){
      count = count + 1;
    }
  }
  return count;
};

//count == how many instances of 1 sound can be queued at a time
void(string requestedSound, float cnt) snd_hud_vfx_addtoqueue={
  local entity this;
  this = self;
  self = PLAYER_HELPER;
  local string sfx;
  local float idx, cur;
  idx = cur = 0;
  self.queued = FALSE;
  if(self.SOUND_QUEUE_1 == requestedSound){
    cur = cur + 1;
  }
  if(self.SOUND_QUEUE_2 == requestedSound){
    cur = cur + 1;
  }
  if(self.SOUND_QUEUE_3 == requestedSound){
    cur = cur + 1;
  }
  if(self.SOUND_QUEUE_4 == requestedSound){
    cur = cur + 1;
  }
  if(self.SOUND_QUEUE_5 == requestedSound){
    cur = cur + 1;
  }
  if(self.SOUND_QUEUE_6 == requestedSound){
    cur = cur + 1;
  }
  if(cur >= cnt){
    self = this;
    return;
  }
  cur = 0;
  idx = 0;
  while(idx < self.VOICE_QUEUE_SIZE){
    local string sfx;
    if(idx == 0){
      cur = snd_hud_vfx_enqueue(SOUND_QUEUE_1, cnt, cur, queued, requestedSound);
    }
    else if( idx == 1){
      cur = snd_hud_vfx_enqueue(SOUND_QUEUE_2, cnt, cur, queued, requestedSound);
    }
    else if( idx == 2){
      cur = snd_hud_vfx_enqueue(SOUND_QUEUE_3, cnt, cur, queued, requestedSound);
    }
    else if( idx == 3){
      cur = snd_hud_vfx_enqueue(SOUND_QUEUE_4, cnt, cur, queued, requestedSound);
    }
    else if( idx == 4){
      cur = snd_hud_vfx_enqueue(SOUND_QUEUE_5, cnt, cur, queued, requestedSound);
    }
    else if( idx == 5){
      cur = snd_hud_vfx_enqueue(SOUND_QUEUE_6, cnt, cur, queued, requestedSound);
    }
    idx = idx + 1;
  }
  self = this;
};

void(float playerState) snd_hud_vfx_statelistener={
  if(getstati(STAT_PLR_STT) == PLAYER_POWERUP_BEGIN){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE, 1);
    PLAYER_HELPER.drawme = 0;
  }
  else if(getstati(STAT_PLR_STT) == PLAYER_ACTIVE){
    if(PLAYER_HELPER.drawme == 0){
      PLAYER_HELPER.drawme = PLAYER_HELPER.drawme | 1 | 2 | 4 | 8 | 16 | 32;
    }
  }
};

void(float lockstate) snd_hud_vfx_locklistener={
};

void(float curEn) snd_hud_vfx_enelistener={
  if(curEn == 10){
    if(PLAYER_HELPER.SOUND_QUEUE_1 != SND_HUD_VFX_ENELOW){
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
  if(getstati(STAT_PLR_STT) == PLAYER_ACTIVE){
    if(amt <= 0){
      if((PLAYER_HELPER.drawme & bit)){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 3); 
        snd_hud_vfx_addtoqueue(snd, 1); 
        PLAYER_HELPER.drawme = PLAYER_HELPER.drawme - (PLAYER_HELPER.drawme & bit);
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
          print(ftos(self.data_idx));
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
  if(SND_HUD_RADARMODE != mode){
    SND_HUD_RADARMODE = mode;
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