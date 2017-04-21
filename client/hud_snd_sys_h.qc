/*
mech Mod
Author: Subject9x
Date: 04/10/2017
Overview: header file for the hud sound system
*/

//sound precache
string SND_HUD_VFX_ONLINE;
string SND_HUD_VFX_ENELOW;
string SND_HUD_VFX_SHDLOW;
string SND_HUD_VFX_RDRACTIVE;
string SND_HUD_VFX_RDRPASSIVE;
string SND_HUD_VFX_TARGKILL;

float SND_HUD_RADARMODE = FALSE;
float SND_HUD_TARGKILL = FALSE;
//channels so far
//hud voice
float VOICE_PLAY = FALSE;
float VOICE_TIME;
float VOICE_TIME_NEXT;
float VOICE_ADDTIME;
float VOICE_QUEUE_SIZE = 4;

float VOICE_QUEUE_IDX;
string VOICE_QUEUE[VOICE_QUEUE_SIZE];
void() snd_hud_vfx_frame;
void(string requestedSound) snd_hud_vfx_addtoqueue;
void(float playerState) snd_hud_vfx_statelistener;
void(float lockstate) snd_hud_vfx_locklistener;
void(float curEn) snd_hud_vfx_enelistener;
void(float curSh) snd_hud_vfx_shdlistener;
void(float curAm) snd_hud_vfx_armlistener;
void(float mode) snd_hud_vfx_toggleradar;
void(float trgArm) snd_hud_vfx_targkill;


//hud beeps


//map voice

