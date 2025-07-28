/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/

// typ 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
// typ 1 = keyup (keysym, may have unicode character but generally not)
// typ 2 = mousemove (x, y) if inputmode is off
// typ 3 = mousepos (x, y) if inputmode is on
// return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent = {
  //we kick this over to battleMETAL's own input handling
    // ref: qc/client/input_events.qc
  return handle_input(evtype, scanx, chary, devid);
};

// return TRUE if you wish to eat this sound, return FALSE to let engine handle it.
float(entity ent, float channel, string soundname, float volume, float attenuation, vector pos, float speed100, float sflags) CSQC_Event_Sound =
{
  
  if((sflags & SOUNDFLAG_INTERIOR)){
    if(CLIENT_server_ent.chaseActive){
      sound7(ent, channel, sprintf(soundname, ""), volume, attenuation, speed100, sflags);
    }
    else{
      sound7(ent, channel, sprintf(soundname, "_int"), volume, attenuation, speed100, sflags);
    }
    return TRUE;
  }
	return FALSE;
};


// SOUNDFLAG_RELIABLE 1
// SOUNDFLAG_FORCELOOP	2 // force looping even if the sound is not looped
// SOUNDFLAG_LOCALSOUND 4 // INTERNAL USE. Not settable by S_SetChannelFlag
// SOUNDFLAG_PAUSED 8 // pause status
// SOUNDFLAG_FULLVOLUME 16 // isn't affected by the general volume
//WARN: battleMETAL exclusive flag that may need changing if ever more flags are addded!
// SOUNDFLAG_DYNAMIC_INT 65536

string SND_DYNAMIC_FILE;
//Custom wrapper for sounds, allowing for sound file mix-in via sprintf values in file name.
void(entity ent, float channel, string soundname, float volume, float attenuation, float speed100, float sflags) Sound7_Dynamic={
  
  if( cvar("snd_cockpit_effect") == 0 ){
    sound7(ent, channel, sprintf(soundname, ""), volume, attenuation, speed100, sflags);
    return;
  }

  if( (sflags & SOUNDFLAG_DYNAMIC_INT) && CLIENT_server_ent.chaseActive ){
    sound7(ent, channel, sprintf(soundname, ""), volume, attenuation, speed100, sflags);
  }
  else{
    sound7(ent, channel, sprintf(soundname, "_int"), volume, attenuation, speed100, sflags);
  }
};

//Custom wrapper for sounds, allowing for sound file mix-in via sprintf values in file name.
void(vector pos, string soundname, float volume, float attenuation, float sflags) PointSound_Dynamic={
  if( cvar("snd_cockpit_effect") == 0 ){
    pointsound(pos, sprintf(soundname, ""), volume, attenuation);
    return;
  }
  if((sflags & SOUNDFLAG_DYNAMIC_INT) && CLIENT_server_ent.chaseActive){
    pointsound(pos, sprintf(soundname, ""), volume, attenuation);
  }
  else{
    pointsound(pos, sprintf(soundname, "_int"), volume, attenuation);
  }
};

//not used in darkplaces
//float() CSQC_Parse_Event={
 // return FALSE;
//};


// return TRUE if you want to eat this event, otherwise return FALSE to let engine handle it.
// NOT USED IN DARKPLACES
float(float event) CSQC_Event =
{  
	return FALSE;
};