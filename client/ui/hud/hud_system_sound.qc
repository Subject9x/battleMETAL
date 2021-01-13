/*
battleMETAL
Author: Peter Roohr
Date: 04/10/2017
08/01/2019 - added aI voice queue, and some big refactoring.

Overview: 
  impl file for the hud sound system.
*/

/*
  
*/
void() snd_hud_vfx_frame={
  local float sfx_len;
  local float itr;
  local float prev;
  local float vol;
  local string nextSound;
  local float nextEnt;
  
  if( cvar("bgmvolume") <= 0 ){
    if( time > SFX_REACT_TIME ){
      SFX_REACT_TIME = time + 30;
      pointsound(pmove_org, SND_MCH_SFX_REACT, 1, ATTN_NONE);
    }
  }
  
  if(time > STIME_NEXT){
    if(SOUNDQUEUE[0] != "null"){
      sfx_len = soundlength(SOUNDQUEUE[0]);
      pointsound(pmove_org, SOUNDQUEUE[0], 1, ATTN_NONE);
      STIME_NEXT = time + sfx_len;
      //TODO - possibly pause AI voice playback until message is done?
    }
    else{
      STIME_NEXT = time + 0.05;
    }
    itr = 1;
    while( itr < SQSIZE){
      prev = itr - 1;
      nextSound = SOUNDQUEUE[itr];
    
      SOUNDQUEUE[prev] = nextSound;  
      SOUNDQUEUE[itr] = "null";
      
      itr = itr + 1;
    }
  }
  
  if( time > TR_TIME_NEXT ){
    if( TRANSMISSIONQUEUE_ENT[0] > -1 ){
      sfx_len = soundlength(TRANSMISSIONQUEUE[0]);
      vol = 1;
      if( SOUNDQUEUE[0] != NULL_STRING ){
        vol = 0.65; //dim volume for hud voice
      }
      pointsound(pmove_org, TRANSMISSIONQUEUE[0], vol, ATTN_NONE);
      TR_TIME_NEXT = time + sfx_len + 0.25;
      TRANSMISSIONQUEUE[0] = NULL_STRING;
      TRANSMISSIONQUEUE_ENT[0] = -1;
    }
    else{
      TR_TIME_NEXT = time + 1;
      TRANSMISSIONQUEUE[0] = NULL_STRING;
      TRANSMISSIONQUEUE_ENT[0] = -1;
    }
    itr = 1;
    while( itr < TQSIZE){
      prev = itr - 1;
      nextSound = TRANSMISSIONQUEUE[itr];
      nextEnt = TRANSMISSIONQUEUE_ENT[itr];
      
      TRANSMISSIONQUEUE[prev] = nextSound;
      TRANSMISSIONQUEUE_ENT[prev] = nextEnt;
      
      TRANSMISSIONQUEUE[itr] = NULL_STRING;
      TRANSMISSIONQUEUE_ENT[itr] = -1;
      itr = itr + 1;
    }
  }
};

//count == how many instances of 1 sound can be queued at a time
void(string requestedSound, float cnt) snd_hud_vfx_addtoqueue={
  local float idx, cur, added;
  idx = cur = 0;
  SQUED = FALSE;  
  while(idx < SQSIZE){
    if(SOUNDQUEUE[idx] == requestedSound){
      cur = cur + 1;
    }
    idx = idx + 1;
  }

  if( cur < cnt ){
    idx = 1;
    added = FALSE;
    while(idx < SQSIZE){
      if(SOUNDQUEUE[idx] == "null"){
        if( !added ){
          SOUNDQUEUE[idx] = requestedSound;
          added = TRUE;
        }
      }
      idx = idx + 1;
    }
  }

  while(idx < SQSIZE){
    if(SOUNDQUEUE[idx] == requestedSound){
      cur = cur + 1;
    }
    if(SOUNDQUEUE[idx] == NULL_STRING){
      if(cur < cnt){
        SOUNDQUEUE[idx] = requestedSound;
        cur = cur + 1;
      }
    }
    idx = idx + 1;
  }
  SQUED = FALSE;
};

/*
  entityId is used to prevent flooding the player's radio buffer with just 1 unit hollering.
*/  
void(float voiceGroup, float voiceId, float limitCheck, float entityId) snd_hud_trnsmsn_addtoqueue={
  local float idx, cur, added;
  local string requestedSoundValue;
  
  idx = cur = 0;

  if( CLIENT_player_state == PLAYER_BRIEF ){
    return;
  }
  
  switch( voiceGroup ){
    case AI_VOICE_GROUP_A:
      requestedSoundValue = AI_VOICE_A[voiceId];
      break;
    case AI_VOICE_GROUP_B:
      requestedSoundValue = AI_VOICE_B[voiceId];
      break;
    default:
      requestedSoundValue = AI_VOICE_C[voiceId];
      break;
  }

  while(idx <= TQSIZE){
    if( TRANSMISSIONQUEUE[idx] == requestedSoundValue || TRANSMISSIONQUEUE_ENT[idx] == entityId){
      cur = cur + 1;
    }
    idx = idx + 1;
  }
  if(cur > limitCheck){
    return;
  }
  added = FALSE;
  idx = 1;
  while(idx < TQSIZE){
    if(TRANSMISSIONQUEUE[idx] == NULL_STRING){
      if( !added ){
        TRANSMISSIONQUEUE[idx] = requestedSoundValue;
        TRANSMISSIONQUEUE_ENT[idx] = entityId;
        added = TRUE;
      }
    }
    idx = idx + 1;
  }
};


void(float lockstate) snd_hud_vfx_locklistener={
};

void(float curEn) snd_hud_vfx_enelistener={
  if( (curEn > 15) && (curEn <= 15.99) ){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ENELOW, 1);
  }
};

void(float curSh) snd_hud_vfx_shdlistener={
  if(curSh == 10){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_SHDLOW, 1);
  }
};

void( string critSound, float limiter ) snd_hud_vfx_criticalHit={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 2); 
  snd_hud_vfx_addtoqueue(critSound, limiter);
};

//SFX
void() te_targ_kill={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL, 3);
};

void() te_mission_win={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_WIN, 1);
};

void() te_mission_lose={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL, 1);
};

void() te_msn_boundary={
  
};

void(float dedflg) snd_hud_vfx_targkill={
  if(dedflg == DEAD_DYING){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL, 1);
  }
};