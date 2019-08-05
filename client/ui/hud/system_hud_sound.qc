/*
battleMETAL
Author: Peter Roohr
Date: 04/10/2017
Overview: impl file for the hud sound system
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
  
  if(time > STIME_NEXT){
    if(SOUNDQUEUE[0] != "null"){
      sfx_len = soundlength(SOUNDQUEUE[0]);
      pointsound(pmove_org, SOUNDQUEUE[0], 1, ATTN_NONE);
      STIME_NEXT = time + sfx_len + 0.05;
      //TODO - possibly pause AI voice playback until message is done?
    }
    else{
      STIME_NEXT = time + 0.05;
    }
    itr = SQSIZE;
    while( itr > -1 ){
      prev = itr - 1;
      SOUNDQUEUE[prev] = SOUNDQUEUE[itr];
      SOUNDQUEUE[itr] = "null";
      itr = itr - 1;
    }
  }
  
  if( time > TR_TIME_NEXT ){
    if( TRANSMISSIONQUEUE_ENT[0] > -1 ){
      sfx_len = soundlength(TRANSMISSIONQUEUE[0]);
      vol = 1;
      if( SOUNDQUEUE[0] != NULL_SOUND ){
        vol = 0.75; //dim volume for hud voice
      }
      pointsound(pmove_org, TRANSMISSIONQUEUE[0], vol, ATTN_NONE);
      TR_TIME_NEXT = time + sfx_len + 0.25;
      TRANSMISSIONQUEUE[0] = NULL_SOUND;
      TRANSMISSIONQUEUE_ENT[0] = -1;
    }
    else{
      TR_TIME_NEXT = time + 1;
      TRANSMISSIONQUEUE[0] = NULL_SOUND;
      TRANSMISSIONQUEUE_ENT[0] = -1;
    }
    itr = 1;
    while( itr < TQSIZE){
      prev = itr - 1;
      nextSound = TRANSMISSIONQUEUE[itr];
      nextEnt = TRANSMISSIONQUEUE_ENT[itr];
      
      TRANSMISSIONQUEUE[prev] = nextSound;
      TRANSMISSIONQUEUE_ENT[prev] = nextEnt;
      
      TRANSMISSIONQUEUE[itr] = NULL_SOUND;
      TRANSMISSIONQUEUE_ENT[itr] = -1;
      itr = itr + 1;
    }
  }
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
    if(SOUNDQUEUE[idx] == NULL_SOUND){
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

  switch( voiceGroup ){
    case AI_VOICE_GROUP_A:
      //TODO - voice group A
      break;
    case AI_VOICE_GROUP_B:
      //TODO - voice group B
      break;
    default:
      //C - debug / default
      requestedSoundValue = AI_VOICE_C[voiceId];
      break;
  }

  while(idx <= TQSIZE){
    if( TRANSMISSIONQUEUE_ENT[idx] == entityId ){
      cur = cur + 1;
    }
    idx = idx + 1;
  }
  if(cur < limitCheck){
    added = FALSE;
    idx = 0;
    while(idx <= TQSIZE){
      if(TRANSMISSIONQUEUE[idx] == NULL_SOUND){
        if( !added ){
          TRANSMISSIONQUEUE[idx] = requestedSoundValue;
          TRANSMISSIONQUEUE_ENT[idx] = entityId;
          added = TRUE;
        }
      }
      idx = idx + 1;
    }
  }
};

void(float playerState) snd_hud_vfx_statelistener={
  if(CLIENT_player_state == PLAYER_POWERUP_BEGIN){
    if( CRITBITS < 0){
      if( !cvar("developer") ){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE, 1);
      }
      
      CRITBITS = 0;    
    }
  }
  else if(CLIENT_player_state == PLAYER_ACTIVE){
    if(CRITBITS == 0){
      CRITBITS = CRITBITS | (1 | 2 | 4 | 8 | 16);
    }
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

void(float amt, float bit, string snd) snd_hud_vfx_armlistener={
  if(self.player_state >= PLAYER_ACTIVE){
    if(amt <= 0){
      if( (CRITBITS & bit) ){
        snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 2); 
        snd_hud_vfx_addtoqueue(snd, 6);
        if( bit == 4 ){
          text_hud_message_critical_left_arm();
        }
        else{
          text_hud_message_critical_right_arm();
        }
        CRITBITS = CRITBITS - (CRITBITS & bit);
      }
    }
  }
};

void( string critSound, float limiter ) snd_hud_vfx_criticalHit={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 2); 
  snd_hud_vfx_addtoqueue(snd, limiter);
};

//SFX
void() te_nav_reach={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_NAVRECH, 3);
};

void() te_targ_kill={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL, 3);
};

void( float type ) te_objective_complete={
  switch( type ){
    case 1:
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_PRIME, 1);
      break;
    case 2:
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_SECON, 1);
      break;
    case 3:
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_THIRD, 1);
      break;
  }
};
void() te_objective_failed={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL, 1);
};

void() te_mission_win={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_WIN, 1);
};

void() te_mission_lose={
  snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL, 1);
};


void() te_msn_boundary={
  
};


void(float mode) snd_hud_vfx_toggleradar={
  if(CLIENT_stat_rdr_mode_prev != mode){
    CLIENT_stat_rdr_mode_prev = mode;
    if(mode){
     snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRACTIVE, 3);
    }
    else{
      snd_hud_vfx_addtoqueue(SND_HUD_VFX_RDRPASSIVE, 3); 
    }
  }
};

void(float dedflg) snd_hud_vfx_targkill={
  if(dedflg == DEAD_DYING){
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL, 1);
  }
};