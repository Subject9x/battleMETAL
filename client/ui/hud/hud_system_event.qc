/*
battleMETAL
Author: Peter Roohr
Date: 08/06/2019
Overview: 
  Concatenating all HUD events into a single queue.
  Functions will contain all that is needed for an event.
*/

//System Functions
void() hud_event_frame={
  local float arrIdx;
  
  local float prevArrIdx;
  local float nextArrayValue;
  
  if( time > HUD_EVENT_TIME_NEXT ){
    HUD_EVENT_ID = HUD_EVENTS[0];
    if( HUD_EVENT_ID > 0 ){
      HUD_EVENT_SOUND_START = FALSE;
      HUD_EVENT_TIME_NEXT = time + 2.67;
    }
    else{
      HUD_EVENT_TIME_NEXT = time + 0.1;
    }
    arrIdx = 1;
    while( arrIdx < HUD_EVENT_SIZE ){
      prevArrIdx = arrIdx - 1;
      nextArrayValue = HUD_EVENTS[arrIdx];
      HUD_EVENTS[prevArrIdx] = nextArrayValue;
      HUD_EVENTS[arrIdx] = -1;
      arrIdx = arrIdx + 1;
    }
  }
  switch( HUD_EVENT_ID ){
    default:
      break;
    case HUD_EVENT_CRITICAL_LEGS:
      hud_event_critical_legs();
      break;
    case HUD_EVENT_CRITICAL_TORSO_LEFT:
      hud_event_critical_left_torso();
      break;
    case HUD_EVENT_CRITICAL_TORSO_RIGHT:
      hud_event_critical_right_torso();
      break;
    case HUD_EVENT_CRITICAL_ARM_LEFT:
      hud_event_critical_left_arm();
      break;
    case HUD_EVENT_CRITICAL_ARM_RIGHT:
      hud_event_critical_right_arm();
      break;
    case HUD_EVENT_POWERUP:
      hud_event_powerup();
      break;
    case HUD_EVENT_NAV_REACHED:
      hud_event_nav_reached();
      break;
    case HUD_EVENT_OBJECTIVE_COMPLETE_PRIME:
      hud_event_objective_complete_prime();
      break;
    case HUD_EVENT_OBJECTIVE_COMPLETE_SECOND:
      hud_event_objective_complete_second();
      break;
    case HUD_EVENT_OBJECTIVE_FAILED:
      hud_event_objective_failed();
      break;
    case HUD_EVENT_MISSION_COMPLETE:
      hud_event_mission_complete();
      break;
    case HUD_EVENT_MISSION_FAILED:
      hud_event_mission_failed();
      break;
    case HUD_EVENT_TARGET_KILLED:
      hud_event_target_killed();
      break;
  }
};

/*
  An event requests to be added to the queue, this attempts to place
  it on the queue but also checks the limitMax var as a kind of flood-protection.
*/
void( float eventAdd, float limitMax) hud_event_enqueue={
  local float arrIdx;
  local float foundTotal;
  local float arrayValue;
  
  arrIdx = 1;
  while( arrIdx < HUD_EVENT_SIZE ){
    arrayValue = HUD_EVENTS[arrIdx];
    if( arrayValue == eventAdd ){
      foundTotal = foundTotal + 1;
    }
    if( foundTotal < limitMax ){
      if( arrayValue < 1){
        HUD_EVENTS[arrIdx] = eventAdd;
        foundTotal = foundTotal + 1;
      }
    }
    arrIdx = arrIdx + 1;
  }
};

//Event functions
void() hud_event_critical_left_arm={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 1);
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITARM, 1); 
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_TARGET_KILLED, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_critical_right_arm={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 1);
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITARM, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_CRITICAL_ARM_RIGHT, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_critical_left_torso={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 1);
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTOR, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_CRITICAL_TORSO_LEFT, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_critical_right_torso={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 1);
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTOR, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_CRITICAL_TORSO_RIGHT, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_critical_legs={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 1);
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITLEG, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_CRITICAL_LEGS, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_critical_weapon={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_CRITTONE, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_CRITICAL_WEAPON, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_powerup={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_ONLINE, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_POWERUP, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_nav_reached={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_NAVRECH, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_NAV_REACHED, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_objective_complete_prime={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_PRIME, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_OBJECTIVE_COMPLETE_PRIME, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_objective_complete_second={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_OBJ_SECON, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_OBJECTIVE_COMPLETE_SECOND, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_objective_failed={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_OBJECTIVE_FAILED, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_mission_complete={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_WIN, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_MISSION_COMPLETE, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};

void() hud_event_mission_failed={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_MSN_FAL, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_MISSION_FAILED, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);

};

void() hud_event_target_killed={
  if( !HUD_EVENT_SOUND_START ){
    HUD_EVENT_SOUND_START = TRUE;
    snd_hud_vfx_addtoqueue(SND_HUD_VFX_TARGKILL, 1);
  }
  hud_render_message( HUD_TXT_ORG, HUD_TEXT_TARGET_KILLED, HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN);
};