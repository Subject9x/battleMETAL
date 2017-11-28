/*
mech Mod
Author: Peter Roohr
Date: 04/10/2017
Overview: header file for the hud sound system
*/

//sound precache
string SND_MCH_SFX_REACT;

string SND_HUD_VFX_ONLINE;
string SND_HUD_VFX_ENELOW;
string SND_HUD_VFX_SHDLOW;
string SND_HUD_VFX_RDRACTIVE;
string SND_HUD_VFX_RDRPASSIVE;
string SND_HUD_VFX_CRITARM;
string SND_HUD_VFX_CRITTOR;
string SND_HUD_VFX_CRITLEG;
string SND_HUD_VFX_CRITTONE;
string SND_HUD_VFX_NAVRECH;
string SND_HUD_VFX_TARGKILL;
string SND_HUD_VFX_MSN_WIN;
string SND_HUD_VFX_MSN_FAL;

string SND_HUD_VFX_OBJ_PRIME;
string SND_HUD_VFX_OBJ_SECON;
string SND_HUD_VFX_OBJ_THIRD;
string SND_HUD_VFX_OBJ_FOURT;

float SND_HUD_RADARMODE = FALSE;
float SND_HUD_TARGKILL = FALSE;
float SND_HUD_CRITPART = 0;

//channels so far
float REACT_TIME;
//hud voice
float VOICE_PLAY = FALSE;
float VOICE_TIME;
float VOICE_TIME_NEXT;
float VOICE_ADDTIME;
float VOICE_QUEUE_SIZE = 7;

float VOICE_QUEUE_IDX;
float VOICE_QUEUE_ADD_IDX;
string VOICE_QUEUE[VOICE_QUEUE_SIZE];
string VOICE_PLAYING ="";

void() snd_hud_vfx_frame;
void() snd_hud_vfx_cleanqueue;

void(string requestedSound, float cnt) snd_hud_vfx_addtoqueue;

void(float playerState) snd_hud_vfx_statelistener;
void(float lockstate) snd_hud_vfx_locklistener;
void(float curEn) snd_hud_vfx_enelistener;
void(float curSh) snd_hud_vfx_shdlistener;
void(float amt, float bit, string snd) snd_hud_vfx_armlistener;
void(float mode) snd_hud_vfx_toggleradar;
void(float trgArm) snd_hud_vfx_targkill;
void(float preState, float nexState) snd_hud_vfx_objectivelistener;
void(float preState, float nexState) snd_hud_vfx_navpointlistener;


//hud beeps


//map voice

