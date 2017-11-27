/*
mech Mod
Author: Peter Roohr
Date: 04/10/2017
Overview: impl file for the hud sound system
*/

void() snd_hud_vfx_frame={
  if(time > VOICE_TIME_NEXT){
    local float playing;
    local string snd;
    snd = VOICE_QUEUE[VOICE_QUEUE_IDX];
    if(snd != "null"){
      VOICE_TIME = soundlength(snd);
      sound7(PLAYER_HELPER, CHAN_AUTO, snd, 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
    }
    else{
      VOICE_TIME = 0;
    }
    VOICE_QUEUE[VOICE_QUEUE_IDX] = "null";
    VOICE_TIME_NEXT = time + VOICE_TIME;
    VOICE_QUEUE_IDX = VOICE_QUEUE_IDX + 1;
    if(VOICE_QUEUE_IDX > VOICE_QUEUE_SIZE){
      VOICE_QUEUE_IDX = 0;
    }
  }
};

void() snd_hud_vfx_cleanqueue={
  local float idx;
  idx = 0;
  while(idx < VOICE_QUEUE_SIZE){
    VOICE_QUEUE[idx] = "null";
    idx = idx + 1;
  }
};

void(string requestedSound) snd_hud_vfx_addtoqueue={
  local float lst_idx, set_idx, existing;
  local string snd;
  lst_idx = 0;
  existing = 0;
  while(lst_idx < VOICE_QUEUE_SIZE){
    snd = VOICE_QUEUE[lst_idx];
    if(snd == requestedSound){
      existing = 1;
    }
    lst_idx = lst_idx + 1;
  }
  if(!existing){
    set_idx = 0;
    while(set_idx < VOICE_QUEUE_SIZE){
      snd = VOICE_QUEUE[set_idx];
      if(snd == "null"){
        if(!existing){
          existing = 1;
          VOICE_QUEUE[set_idx] = requestedSound;
        }
      }
      set_idx = set_idx + 1;
    }
  }
};

void(float playerState) snd_hud_vfx_statelistener={
  if(getstati(STAT_PLR_STT) == PLAYER_START){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE);
    PLAYER_HELPER.drawme = 0;
  }
  else if(getstati(STAT_PLR_STT) == PLAYER_IDLE){
    if(PLAYER_HELPER.drawme == 0){
      PLAYER_HELPER.drawme = PLAYER_HELPER.drawme | 1 | 2 | 4 | 8 | 16 | 32;
    }
  }
};

void(float lockstate) snd_hud_vfx_locklistener={
};

void(float curEn) snd_hud_vfx_enelistener={
  if((curEn >= 30) && (curEn <= 35)){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ENELOW);
  }
};

void(float curSh) snd_hud_vfx_shdlistener={
  if((curSh >= 30) && (curSh <= 35)){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_SHDLOW);
  }
};

void(float amt, float bit, string snd) snd_hud_vfx_armlistener={
  if(getstati(STAT_PLR_STT) == PLAYER_IDLE){
    if(amt <= 0){
      if((PLAYER_HELPER.drawme & bit)){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE); 
        snd_hud_vfx_addtoqueue(snd); 
        PLAYER_HELPER.drawme = PLAYER_HELPER.drawme - (PLAYER_HELPER.drawme & bit);
      }
    }
  }
};

void(float preState, float nexState) snd_hud_vfx_navpointlistener={
  if(self.i_faction == getstati(STAT_PLR_IFAC)){
    if(nexState == FALSE){
      if(preState == TRUE){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_NAVRECH);
      }
    }
  }
};

void(float preState, float nexState) snd_hud_vfx_objectivelistener={
  if(self.i_faction == getstati(STAT_PLR_IFAC)){
    if(nexState == FALSE){
      if(preState == TRUE){
        print(ftos(self.data_idx));
        if(self.data_idx == 1){
          snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_PRIME);
        }
        else if(self.data_idx == 2){
          snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_SECON);
        }
        else if(self.data_idx == 3){
          snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_THIRD);
        }
        else if(self.data_idx == 254){
          snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_WIN);
        }
        else if(self.data_idx == 255){
          snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL);
        }
      }
    }
  }
};

void(float mode) snd_hud_vfx_toggleradar={
  if(SND_HUD_RADARMODE != mode){
    SND_HUD_RADARMODE = mode;
    if(mode){
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRACTIVE);
    }
    else{
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRPASSIVE); 
      
    }
  }
};

void(float dedflg) snd_hud_vfx_targkill={
  if(dedflg > DEAD_DEAD && dedflg < 5){
    dedflg = 5;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL);
  }
};