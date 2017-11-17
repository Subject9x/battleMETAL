/*
mech Mod
Author: Subject9x
Date: 04/10/2017
Overview: impl file for the hud sound system
*/

void() snd_hud_vfx_frame={
  if(time > VOICE_TIME_NEXT){
    local float playing;
    local string snd;
    playing = getsoundtime(PLAYER_HELPER, CHAN_AUTO);
    if(playing < 0){
      VOICE_TIME = soundlength(snd);
      VOICE_TIME_NEXT = time + VOICE_TIME;
      snd = VOICE_QUEUE[VOICE_QUEUE_IDX];
      sound7(PLAYER_HELPER, CHAN_AUTO, snd, 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
      VOICE_QUEUE[VOICE_QUEUE_IDX] = "null";
      VOICE_QUEUE_IDX = VOICE_QUEUE_IDX + 1;
      if(VOICE_QUEUE_IDX > (VOICE_QUEUE_SIZE - 1)){
        VOICE_QUEUE_IDX = 0;
      }
    }
  }
};

void(string requestedSound) snd_hud_vfx_addtoqueue={
  if(time > VOICE_ADDTIME){
    //check if sound already queued
    local float lst_idx, existing;
    local string snd;
    lst_idx = 0;
    existing = 0;
    while(lst_idx < VOICE_QUEUE_SIZE){
      snd = VOICE_QUEUE[lst_idx];
      if(snd == requestedSound){
        existing = existing + 1;
      }
      lst_idx = lst_idx + 1;
    }
    if(existing == 0){
      lst_idx = 0;
      existing = 0;
      while(lst_idx < VOICE_QUEUE_SIZE){
        snd = VOICE_QUEUE[lst_idx];
        if(snd == "null"){
          if(existing == 0){
            existing = 1;
            VOICE_QUEUE[lst_idx] = requestedSound;
            VOICE_ADDTIME = time + soundlength(requestedSound);
          }
        }
        lst_idx = lst_idx + 1;
      }
    }
  }
};

void(float playerState) snd_hud_vfx_statelistener={
  if(playerState == PLAYER_SPAWN){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE);
    PLAYER_HELPER.drawme = 0;
    playerState = PLAYER_IDLE;
  }
  else if(playerState == PLAYER_IDLE){
    local float t;
    if(time > REACT_TIME){
      REACT_TIME = time + soundlength(SND_MCH_SFX_REACT);
      sound7(PLAYER_HELPER, CHAN_ITEM, SND_MCH_SFX_REACT, 1, ATTN_NORM, 100,SOUNDFLAG_RELIABLE );
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
  if(getstati(STAT_PLR_STT) != PLAYER_SPAWN){
    if(amt <= 0){
      if(!(PLAYER_HELPER.drawme & bit)){
        snd_hud_vfx_addtoqueue(snd); 
        PLAYER_HELPER.drawme = PLAYER_HELPER.drawme | bit;
        
      }
    }
  }
};

void(float mode) snd_hud_vfx_toggleradar={
  if(SND_HUD_RADARMODE != mode){
    SND_HUD_RADARMODE = mode;
    if(mode==0){
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRPASSIVE); 
    }
    else{
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRACTIVE);
    }
  }
};

void(float dedflg) snd_hud_vfx_targkill={
  if(dedflg > DEAD_DEAD && dedflg < 5){
    dedflg = 5;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL);
  }
};