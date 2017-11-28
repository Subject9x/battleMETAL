/*
mech Mod
Author: Peter Roohr
Date: 04/10/2017
Overview: impl file for the hud sound system
*/

void() snd_hud_vfx_frame={
  if(time >= VOICE_TIME_NEXT){
    local float sfx_len, idx;
    local string snd;
    snd = VOICE_QUEUE[0];
    if(snd != "null"){
      sfx_len = soundlength(snd);
      sound7(PLAYER_HELPER, CHAN_AUTO, snd, 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
      VOICE_TIME_NEXT = time + sfx_len;
    }
    else{
      VOICE_TIME_NEXT = time + 0.5;
    }
    idx = 0;
    while(idx < VOICE_QUEUE_SIZE){
      local float nex;
      nex = idx + 1;
      if(nex > VOICE_QUEUE_SIZE){
        VOICE_QUEUE[idx] = VOICE_QUEUE[nex];
      }
      else{
        VOICE_QUEUE[idx] = "null";
      }
      idx = idx + 1;
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

//count == how many instances of 1 sound can be queued at a time
void(string requestedSound, float cnt) snd_hud_vfx_addtoqueue={
  local string sfx;
  local float idx, cur;
  idx = cur = 0;
  while(idx <= VOICE_QUEUE_SIZE){
    local string snd;
    snd = VOICE_QUEUE[idx];
    if(snd == requestedSound){
      cur = cur + 1;
    }
    idx = idx + 1;
  }
  if(cur >= cnt){
    return;
  }
  while(idx < VOICE_QUEUE_SIZE){
    local string snd;
    snd = VOICE_QUEUE[idx];
    if(snd == "null"){
      VOICE_QUEUE[idx] = requestedSound;
      cons_logAFloat("idx", idx);
      cons_logAString("snd", requestedSound);
      return;
    }
    idx = idx + 1;
  }
};

void(float playerState) snd_hud_vfx_statelistener={
  if(getstati(STAT_PLR_STT) == PLAYER_START){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE, 1);
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
  if((curEn > 10) && (curEn < 15)){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ENELOW, 2);
  }
};

void(float curSh) snd_hud_vfx_shdlistener={
  if((curSh >= 30) && (curSh <= 35)){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_SHDLOW, 2);
  }
};

void(float amt, float bit, string snd) snd_hud_vfx_armlistener={
  if(getstati(STAT_PLR_STT) == PLAYER_IDLE){
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
  if(self.i_faction == getstati(STAT_PLR_IFAC)){
    if(nexState == FALSE){
      if(preState == TRUE){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_NAVRECH, 3);
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