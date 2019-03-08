/*
mech Mod
Author: Peter Roohr
Date: 4/17/2018
Overview: options - audio menu
*/

//audio Globals
entity audio_title;

entity audio_sfx_toggle_lbl;
entity audio_sfx_toggle_on;
entity audio_sfx_toggle_off;

entity audio_sfx_vol_lbl;
entity audio_sfx_up;
entity audio_sfx_dn;

entity audio_music_toggle_lbl;
entity audio_music_toggle_on;
entity audio_music_toggle_off;

entity audio_music_vol_lbl;
entity audio_music_up;
entity audio_music_dn;

//headphone friendly cvar
//snd_spatialization_control
entity audio_speakers_lbl;
entity audio_speakers_more;
entity audio_speakers_less;

entity audio_mute_idle_lbl;
entity audio_mute_idle_on;
entity audio_mute_idle_off;

//snd_speed == 48000
entity audio_quality_lbl;
entity audio_quality_up;
entity audio_quality_dn;

entity audio_back;
entity audio_save;

//audio constants
float(float channels, float headphone_check) audio_speakers_mode_get={
  if( headphone_check && (channels == 2) ){
    return 0;
  }
  switch(channels){
    case 2:
      return 1;
    case 4:
      return 2;
    case 5:
      return 3;
    case 7:
      return 4;
  }
};

string(float select) audio_speakers_mode_val={

  switch(select){
    case 0:
      return "Headphones";
    case 1:
      return "Stereo";
    case 2:
      return "Quadrophonic";
    case 3:
      return "5.1 Surround";
    case 4:
      return "7.1 Surround";
  }
};

void(float select) audio_speakers_mode_setcvar={
  switch(select){
    case 0:
      cvar_set("snd_spatialization_control", "1");
      cvar_set("snd_channels", "2");
      break;
    case 1:
      cvar_set("snd_spatialization_control", "0");
      cvar_set("snd_channels", "2");
      break;
    case 2:
      cvar_set("snd_spatialization_control", "0");
      cvar_set("snd_channels", "4");
      break;
    case 3:
      cvar_set("snd_spatialization_control", "0");
      cvar_set("snd_channels", "5");
      break;
    case 4:
      cvar_set("snd_spatialization_control", "0");
      cvar_set("snd_channels", "7");
      break;
  }
};

string(float select) audio_speed_get_val={
  switch(select){
    case 0:
      return "11025";
    case 1:
      return "16000";
    case 2:
      return "22050";
    case 3:
      return "32000";
    case 4:
      return "44100";
  }
};

float(float sndspeed) audio_speed_get={
  local float val;
  switch(sndspeed){
    case 11025:
      val = 0;
    break;
    case 16000:
      val = 1;
    break;
    case 22050:
      val = 2;
    break;
    case 32000:
      val = 3;
    break;
    case 44100:
      val = 4;
    break;
  }
  if( !val){
    val = 0;
  }
  return val;
};

void(float select) audio_speed_set={
  local float val;
  switch(select){
    case 0:
      cvar_set("snd_speed", "11025");
      break;
    case  1:
      cvar_set("snd_speed", "16000");
      break;
    case 2:
      cvar_set("snd_speed", "22050");
      break;
    case 3:
      cvar_set("snd_speed", "32000");
      break;
    case 4:
      cvar_set("snd_speed", "44100");
      break;
  }
};

//audio callbacks
void() click_audio_sfx_on={
  strunzone(audio_sfx_toggle_lbl.label);
  audio_sfx_toggle_lbl.label = strzone("ON");
  audio_sfx_toggle_on.drawme = FALSE;
  audio_sfx_toggle_off.drawme = TRUE;
  
  audio_sfx_vol_lbl.len = 0.3;
  strunzone(audio_sfx_vol_lbl.label);
  audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len * 10)));
  audio_sfx_up.drawme = TRUE;
  audio_sfx_dn.drawme = TRUE;
};
void() click_audio_sfx_off={
  strunzone(audio_sfx_toggle_lbl.label);
  audio_sfx_toggle_lbl.label = strzone("OFF");
  audio_sfx_toggle_on.drawme = TRUE;
  audio_sfx_toggle_off.drawme = FALSE;
  
  audio_sfx_vol_lbl.len = 0;
  strunzone(audio_sfx_vol_lbl.label);
  audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len)));
  audio_sfx_up.drawme = FALSE;
  audio_sfx_dn.drawme = FALSE;
};

void() click_sfx_up={
  local float level;
  level = audio_sfx_vol_lbl.len;
  level = level + 0.1;
  if(level >= 1){
    level = 1;
    audio_sfx_up.drawme = FALSE;
  }
  audio_sfx_vol_lbl.len = level;
  strunzone(audio_sfx_vol_lbl.label);
  audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len * 10)));
  audio_sfx_dn.drawme = TRUE;
};
void() click_sfx_dn={
  local float level;
  level = audio_sfx_vol_lbl.len;
  level = level - 0.1;
  if(level <= 0.1){
    level = 0.1;
    audio_sfx_dn.drawme = FALSE;
  }
  audio_sfx_vol_lbl.len = level;
  strunzone(audio_sfx_vol_lbl.label);
  audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len * 10)));
  audio_sfx_up.drawme = TRUE;
};

void() click_audio_music_on={
  strunzone(audio_music_toggle_lbl.label);
  audio_music_toggle_lbl.label = strzone("ON");
  audio_music_toggle_on.drawme = FALSE;
  audio_music_toggle_off.drawme = TRUE;
  
  audio_music_vol_lbl.len = 0.3;
  strunzone(audio_music_vol_lbl.label);
  audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len * 10)));
  audio_music_up.drawme = TRUE;
  audio_music_dn.drawme = TRUE;

};
void() click_audio_music_off={
  strunzone(audio_music_toggle_lbl.label);
  audio_music_toggle_lbl.label = strzone("OFF");
  audio_music_toggle_on.drawme = TRUE;
  audio_music_toggle_off.drawme = FALSE;
  
  audio_music_vol_lbl.len = 0;
  strunzone(audio_music_vol_lbl.label);
  audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len)));
  audio_music_up.drawme = FALSE;
  audio_music_dn.drawme = FALSE;
};

void() click_music_up={
  local float level;
  level = audio_music_vol_lbl.len;
  level = level + 0.1;
  if(level >= 1){
    level = 1;
    audio_music_up.drawme = FALSE;
  }
  audio_music_vol_lbl.len = level;
  strunzone(audio_music_vol_lbl.label);
  audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len * 10)));
  audio_music_dn.drawme = TRUE;
};
void() click_music_dn={
  local float level;
  level = audio_music_vol_lbl.len;
  level = level - 0.1;
  if(level <= 0.1){
    level = 0.1;
    audio_music_dn.drawme = FALSE;
  }
  audio_music_vol_lbl.len = level;
  strunzone(audio_music_vol_lbl.label);
  audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len * 10)));
  audio_music_up.drawme = TRUE;
};

void() click_speakers_more={
  local float val;
  val = audio_speakers_lbl.len;
  val = val + 1;
  if(val >= 4){
    val = 4;
    audio_speakers_more.drawme = FALSE;
  }
  audio_speakers_lbl.len = val;
  strunzone(audio_speakers_lbl.label);
  audio_speakers_lbl.label = strzone(audio_speakers_mode_val(audio_speakers_lbl.len));
  audio_speakers_less.drawme = TRUE;
};
void() click_speakers_less={
  local float val;
  val = audio_speakers_lbl.len;
  val = val - 1;
  if(val <= 0){
    val = 0;
    audio_speakers_less.drawme = FALSE;
  }
  audio_speakers_lbl.len = val;
  strunzone(audio_speakers_lbl.label);
  audio_speakers_lbl.label = strzone(audio_speakers_mode_val(audio_speakers_lbl.len));
  audio_speakers_more.drawme = TRUE;
};

void() click_mute_idle_on={
  audio_mute_idle_lbl.len = 1;
  strunzone(audio_mute_idle_lbl.label);
  audio_mute_idle_lbl.label = strzone("ON");
  audio_mute_idle_on.drawme = FALSE;
  audio_mute_idle_off.drawme = TRUE;
};
void() click_mute_idle_off={
  audio_mute_idle_lbl.len = 0;
  strunzone(audio_mute_idle_lbl.label);
  audio_mute_idle_lbl.label = strzone("OFF");
  audio_mute_idle_on.drawme = TRUE;
  audio_mute_idle_off.drawme = FALSE;
};

void() click_quality_up={
  local float val;
  val = audio_quality_lbl.len;
  val = val + 1;
  if(val >= 4){
    val = 4;
    audio_quality_up.drawme = FALSE;
  }
  audio_quality_lbl.len = val;
  strunzone(audio_quality_lbl.label);
  audio_quality_lbl.label = strzone(audio_speed_get_val(audio_quality_lbl.len));
  audio_quality_dn.drawme = TRUE;
};
void() click_quality_dn={
  local float val;
  val = audio_quality_lbl.len;
  val = val - 1;
  if(val <= 0){
    val = 0;
    audio_quality_dn.drawme = FALSE;
  }
  audio_quality_lbl.len = val;
  strunzone(audio_quality_lbl.label);
  audio_quality_lbl.label = strzone(audio_speed_get_val(audio_quality_lbl.len));
  audio_quality_up.drawme = TRUE;
};


void() click_audio_back={
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_audio_save={
  
  cvar_set("volume", ftos(audio_sfx_vol_lbl.len));
  cvar_set("bgmvolume", ftos(audio_music_vol_lbl.len));
  audio_speakers_mode_setcvar(audio_speakers_lbl.len);
  cvar_set("snd_mutewhenidle", ftos(audio_mute_idle_lbl.len));  
  audio_speed_set(audio_quality_lbl.len);
  
  cmd("saveconfig\n");
  
  if( !isdemo() && (clientstate() != CS_CONNECTED)){
    //cmd("snd_restart\n");
  }  
  
  if( isdemo() && (clientstate() == CS_CONNECTED) ){
    cmd("disconnect\n");
   // cmd("snd_restart\n");
    cmd("playdemo demo1\n");
  }
  click_audio_back();
};

// ini function, called by '_f' function as a setup func
void() m_audio_i={
  audio_title = lbl_img('10 25', '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, (UI_FLAG_SIZE_IMG) );

  //SFX Volume
  audio_sfx_toggle_lbl = lbl_text('154 93', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_sfx_toggle_on = btn_img_callback('180 92', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_audio_sfx_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_sfx_toggle_off = btn_img_callback('140 92', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_audio_sfx_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  audio_sfx_vol_lbl = lbl_text('154 107', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_sfx_up = btn_img_callback('180 104', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_sfx_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_sfx_dn = btn_img_callback('140 104', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_sfx_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  local float sfx_vol;
  sfx_vol = cvar("volume");
  if(sfx_vol > 0){
    audio_sfx_toggle_lbl.label = strzone("ON");
    audio_sfx_toggle_on.drawme = FALSE;
    
    audio_sfx_vol_lbl.len = sfx_vol;
    audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len * 10)));
    if( audio_sfx_vol_lbl.len == 0.1){
      audio_sfx_dn.drawme = FALSE;
    }
    if( audio_sfx_vol_lbl.len == 1){
      audio_sfx_up.drawme = FALSE;
    }
  }
  else{
    audio_sfx_toggle_lbl.label = strzone("OFF");
    audio_sfx_toggle_off.drawme = FALSE;
    audio_sfx_vol_lbl.len = sfx_vol; 
    audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len * 10)));
    audio_sfx_up.drawme = FALSE;
    audio_sfx_dn.drawme = FALSE;
  }
  
  // MUSIC VOLUME
  audio_music_toggle_lbl = lbl_text('154 134', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_music_toggle_on = btn_img_callback('180 133', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_audio_music_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_music_toggle_off = btn_img_callback('140 133', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_audio_music_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  audio_music_vol_lbl = lbl_text('154 149', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_music_up = btn_img_callback('180 148', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_music_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_music_dn = btn_img_callback('140 148', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_music_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  local float mus_vol;
  mus_vol = cvar("bgmvolume");
  if(mus_vol > 0){
    audio_music_toggle_lbl.label = strzone("ON");
    audio_music_toggle_on.drawme = FALSE;
    
    audio_music_vol_lbl.len = mus_vol;
    audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len * 10)));
    if( audio_music_vol_lbl.len == 0.1){
      audio_music_dn.drawme = FALSE;
    }
    if( audio_music_vol_lbl.len == 1){
      audio_music_up.drawme = FALSE;
    }
  }
  else{
    audio_music_toggle_lbl.label = strzone("OFF");
    audio_music_toggle_off.drawme = FALSE;
    audio_music_vol_lbl.len = mus_vol; 
    audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len * 10)));
    audio_music_up.drawme = FALSE;
    audio_music_dn.drawme = FALSE;
  }
  
  //speaker mode
  audio_speakers_lbl = lbl_text('154 197', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_speakers_more = btn_img_callback('268 196', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_speakers_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_speakers_less = btn_img_callback('140 196', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_speakers_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  audio_speakers_lbl.len = audio_speakers_mode_get(cvar("snd_channels"), cvar("snd_spatialization_control"));
  audio_speakers_lbl.label = strzone(audio_speakers_mode_val(audio_speakers_lbl.len));
  
  if(audio_speakers_lbl.len == 0){
    audio_speakers_less.drawme = FALSE;
  }
  else if(audio_speakers_lbl.len == 4){
    audio_speakers_more.drawme = FALSE;
  }

  audio_mute_idle_lbl = lbl_text('154 213', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_mute_idle_lbl.len = cvar("snd_mutewhenidle");
  audio_mute_idle_lbl.label = strzone(menu_float_bool(audio_mute_idle_lbl.len));
  audio_mute_idle_on = btn_img_callback('184 212', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_mute_idle_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_mute_idle_off = btn_img_callback('140 212', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_mute_idle_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(audio_mute_idle_lbl.len){
    audio_mute_idle_on.drawme = FALSE;
  }
  else{
    audio_mute_idle_off.drawme = FALSE;
  }

  audio_quality_lbl = lbl_text('154 229', '9 9 0'," ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, 1, 0);
  audio_quality_up = btn_img_callback('200 228', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_quality_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_quality_dn = btn_img_callback('140 228', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_quality_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  audio_quality_lbl.len = audio_speed_get(cvar("snd_speed"));
  audio_quality_lbl.label = strzone(audio_speed_get_val(audio_quality_lbl.len));
  
  if(audio_quality_lbl.len == 0){
    audio_quality_dn.drawme = FALSE;
  }
  else if(audio_speakers_lbl.len == 4){
    audio_quality_up.drawme = FALSE;
  }
  
  //operations
  audio_back = btn_img_callback('25 282 0', '56 12', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_audio_back, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_save = btn_img_callback('285 282 0', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_AUDIO, click_audio_save, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_audio_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_AUDIO;
  setkeydest(KEY_MENU);
  m_audio_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_audio_d={
  gui_renderString("[- AUDIO SETTINGS -]", gui_percentToPixelRawVec('190 64'), CLR_DEF_WHITE, '10 10 0', 1, 0);

  gui_renderString("Sound On/Off :", gui_percentToPixelRawVec('25 94'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Sound Volume :", gui_percentToPixelRawVec('25 108'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Music On/Off :", gui_percentToPixelRawVec('25 135'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Music Volume :", gui_percentToPixelRawVec('25 150'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  
  local string lbl;
  if( !isdemo() && clientstate() == CS_CONNECTED){
    lbl = "Advanced Settings - changes will require restart";
  }
  else{
    lbl = "Advanced Settings";
  }
  gui_renderString(lbl, gui_percentToPixelRawVec('25 174'), CLR_DEF_ARM_THREEQ, '9 9 0', 1, 0);
  gui_renderString("Speaker Mode :", gui_percentToPixelRawVec('25 198'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Mute Minimized :", gui_percentToPixelRawVec('9 214'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  gui_renderString("Sound Quality :", gui_percentToPixelRawVec('17 230'), CLR_DEF_WHITE, '8 8 0', 1, 0);  

  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_AUDIO);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_audio_k={
  //cons_logAFloat("m_audio_k.key", key);  //DEBUG
  //cons_logAFloat("m_audio_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};