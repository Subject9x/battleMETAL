/*
battleMETAL
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
    case 4:
      return 2;
    case 5:
      return 3;
    case 7:
      return 4;
    default:
      return 1;
  }
};

string(float select) audio_speakers_mode_val={

  switch(select){
    case 1:
      return "Stereo";
    case 2:
      return "Quadrophonic";
    case 3:
      return "5.1 Surround";
    case 4:
      return "7.1 Surround";
    default:
      return "Headphones";
  }
};

void(float select) audio_speakers_mode_setcvar={
  switch(select){
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
    default:
      cvar_set("snd_spatialization_control", "1");
      cvar_set("snd_channels", "2");
      break;
  }
};

string(float select) audio_speed_get_val={
  switch(select){
    case 1:
      return "16000";
    case 2:
      return "22050";
    case 3:
      return "32000";
    case 4:
      return "44100";
    default:
      return "11025";
  }
};

float(float sndspeed) audio_speed_get={
  local float val;
  switch(sndspeed){
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
    default:
      val = 0;
      break;
  }
  if( !val){
    val = 0;
  }
  return val;
};

void(float select) audio_speed_set={
  switch(select){
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
    default:
      cvar_set("snd_speed", "11025");
      break;
  }
};

//audio callbacks
void() click_audio_sfx_on={
  audio_sfx_toggle_on.drawme = FALSE;
  audio_sfx_toggle_off.drawme = TRUE;
  
  audio_sfx_toggle_lbl.label = "ON";
  audio_sfx_toggle_lbl.color = CLR_DEF_ARM_OK;
  
  audio_sfx_vol_lbl.len = 0.3;
  cacheGlobalString( audio_sfx_vol_lbl.label, ftos(floor(audio_sfx_vol_lbl.len * 10)) )
  
  audio_sfx_up.drawme = TRUE;
  audio_sfx_dn.drawme = TRUE;
};
void() click_audio_sfx_off={
  audio_sfx_toggle_on.drawme = TRUE;
  audio_sfx_toggle_off.drawme = FALSE;
  
  audio_sfx_toggle_lbl.label = "OFF";
  audio_sfx_toggle_lbl.color = CLR_DEF_GRAY_H;
  audio_sfx_vol_lbl.len = 0;
  cacheGlobalString( audio_sfx_vol_lbl.label, ftos(floor(audio_sfx_vol_lbl.len * 10)) )
  
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
  cacheGlobalString( audio_sfx_vol_lbl.label, ftos(floor(audio_sfx_vol_lbl.len * 10)) )
  
  audio_sfx_dn.drawme = TRUE;
  cvar_set("volume", ftos(audio_sfx_vol_lbl.len));
  localcmd("saveconfig\n");
  
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
  cacheGlobalString( audio_sfx_vol_lbl.label, ftos(floor(audio_sfx_vol_lbl.len * 10)) )
  
  audio_sfx_up.drawme = TRUE;
  cvar_set("volume", ftos(audio_sfx_vol_lbl.len));
  localcmd("saveconfig\n");
};

void() click_audio_music_on={
  audio_music_toggle_on.drawme = FALSE;
  audio_music_toggle_off.drawme = TRUE;
  
  audio_music_toggle_lbl.label = "ON";
  audio_music_toggle_lbl.color = CLR_DEF_ARM_OK;
  
  audio_music_vol_lbl.len = 0.3;
  cacheGlobalString( audio_music_vol_lbl.label, ftos(floor(audio_music_vol_lbl.len * 10)) )
  
  audio_music_up.drawme = TRUE;
  audio_music_dn.drawme = TRUE;
};
void() click_audio_music_off={
  audio_music_toggle_on.drawme = TRUE;
  audio_music_toggle_off.drawme = FALSE;
  
  audio_music_toggle_lbl.label = "OFF";
  audio_music_toggle_lbl.color = CLR_DEF_GRAY_H;
  
  audio_music_vol_lbl.len = 0;
  cacheGlobalString( audio_music_vol_lbl.label, ftos(floor(audio_music_vol_lbl.len * 10)) )
  
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
  cacheGlobalString( audio_music_vol_lbl.label, ftos(floor(audio_music_vol_lbl.len * 10)) )
  
  audio_music_dn.drawme = TRUE;
  cvar_set("bgmvolume", ftos(audio_music_vol_lbl.len));
  localcmd("saveconfig\n");
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
  cacheGlobalString( audio_music_vol_lbl.label, ftos(floor(audio_music_vol_lbl.len * 10)) )
  
  audio_music_up.drawme = TRUE;
  cvar_set("bgmvolume", ftos(audio_music_vol_lbl.len));
  localcmd("saveconfig\n");
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
  audio_speakers_lbl.label = audio_speakers_mode_val(audio_speakers_lbl.len);
  
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
  audio_speakers_lbl.label = audio_speakers_mode_val(audio_speakers_lbl.len);
  
  audio_speakers_more.drawme = TRUE;
};

void() click_mute_idle_on={
  audio_mute_idle_lbl.len = 1;
  
  audio_mute_idle_on.drawme = FALSE;
  audio_mute_idle_off.drawme = TRUE;
};
void() click_mute_idle_off={
  audio_mute_idle_lbl.len = 0;
  
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
  
  freeGlobalString(audio_quality_lbl.label)
  
  cacheGlobalString(audio_quality_lbl.label, audio_speed_get_val(audio_quality_lbl.len) )

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
  
  freeGlobalString(audio_quality_lbl.label)
  
  cacheGlobalString(audio_quality_lbl.label, audio_speed_get_val(audio_quality_lbl.len) )
  
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
  
  localcmd("saveconfig\n");

  click_audio_back();
};

// ini function, called by '_f' function as a setup func
void() m_audio_i={
  local float sfx_vol;
  local float mus_vol;
  
  menu_parent_setup(VIEW_ORG + '0 30', '304 304');
  
  audio_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_AUDIO, 1, UI_FLAG_SIZE_IMG );

  //SFX Volume
  audio_sfx_toggle_lbl = lbl_text(MENU_ORG + '162 55', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_AUDIO, 1, 0);
  
  audio_sfx_toggle_on = btn_img_callback(MENU_ORG + '180 55', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_audio_sfx_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_sfx_toggle_off = btn_img_callback(MENU_ORG + '140 55', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_audio_sfx_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  audio_sfx_vol_lbl = lbl_text(MENU_ORG + '165 75', '14 14',"", CLR_DEF_TXT_GRAY_SMOOTH, VIEW_CTX, M_OPTIONS_AUDIO, 1, 0);
  
  audio_sfx_up = btn_img_callback(MENU_ORG + '180 74', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_sfx_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_sfx_dn = btn_img_callback(MENU_ORG + '140 74', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_sfx_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  sfx_vol = cvar("volume");
  if(sfx_vol > 0){
    audio_sfx_toggle_lbl.label = "ON";
    audio_sfx_toggle_lbl.color = CLR_DEF_ARM_OK;
    
    audio_sfx_toggle_lbl.len = TRUE;
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
    audio_sfx_toggle_lbl.label = "OFF";
    audio_sfx_toggle_lbl.color = CLR_DEF_GRAY_H;
    audio_sfx_toggle_lbl.len = FALSE;
    audio_sfx_toggle_off.drawme = FALSE;
    audio_sfx_vol_lbl.len = sfx_vol; 
    audio_sfx_vol_lbl.label = strzone(ftos(floor(audio_sfx_vol_lbl.len * 10)));
    audio_sfx_up.drawme = FALSE;
    audio_sfx_dn.drawme = FALSE;
  }
  
  // MUSIC VOLUME
  audio_music_toggle_lbl = lbl_text(MENU_ORG + '162 104', '14 14  0', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_AUDIO, 1, 0);
  
  audio_music_toggle_on = btn_img_callback(MENU_ORG + '180 103', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_audio_music_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_music_toggle_off = btn_img_callback(MENU_ORG + '140 103', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_audio_music_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  audio_music_vol_lbl = lbl_text(MENU_ORG + '165 126', '14 14',"", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_AUDIO, 1, 0);
  
  audio_music_up = btn_img_callback(MENU_ORG + '180 125', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_music_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_music_dn = btn_img_callback(MENU_ORG + '140 125', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_music_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  mus_vol = cvar("bgmvolume");
  if(mus_vol > 0){
    audio_music_toggle_lbl.label = "ON";
    audio_music_toggle_lbl.len = TRUE;
    audio_music_toggle_lbl.color = CLR_DEF_ARM_OK;
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
    audio_music_toggle_lbl.label = "OFF";
    audio_music_toggle_lbl.len = FALSE;
    audio_music_toggle_lbl.color = CLR_DEF_GRAY_H;
    audio_music_toggle_off.drawme = FALSE;
    audio_music_vol_lbl.len = mus_vol; 
    audio_music_vol_lbl.label = strzone(ftos(floor(audio_music_vol_lbl.len * 10)));
    audio_music_up.drawme = FALSE;
    audio_music_dn.drawme = FALSE;
  }
  
  //speaker mode
  audio_speakers_lbl = lbl_text(MENU_ORG + '162 182', '14 14',"", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_AUDIO, 1, 0);
  audio_speakers_more = btn_img_callback(MENU_ORG + '240 181', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_speakers_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_speakers_less = btn_img_callback(MENU_ORG + '140 181', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_speakers_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  audio_speakers_lbl.len = audio_speakers_mode_get(cvar("snd_channels"), cvar("snd_spatialization_control"));
  audio_speakers_lbl.label = audio_speakers_mode_val(audio_speakers_lbl.len);
  
  if(audio_speakers_lbl.len == 0){
    audio_speakers_less.drawme = FALSE;
  }
  else if(audio_speakers_lbl.len == 4){
    audio_speakers_more.drawme = FALSE;
  }

  audio_mute_idle_lbl = lbl_text(MENU_ORG + '162 204', '14 14',"", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_AUDIO, 1, UI_FLAG_LBL_BOOL_ON);
  audio_mute_idle_lbl.len = cvar("snd_mutewhenidle");
  audio_mute_idle_on = btn_img_callback(MENU_ORG + '184 203', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_mute_idle_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_mute_idle_off = btn_img_callback(MENU_ORG + '140 203', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_mute_idle_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(audio_mute_idle_lbl.len){
    audio_mute_idle_on.drawme = FALSE;
  }
  else{
    audio_mute_idle_off.drawme = FALSE;
  }

  audio_quality_lbl = lbl_text(MENU_ORG + '162 226', '14 14 0',"", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_AUDIO, 1, 0);
  audio_quality_up = btn_img_callback(MENU_ORG + '200 225', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_AUDIO, click_quality_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  audio_quality_dn = btn_img_callback(MENU_ORG + '140 225', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_AUDIO, click_quality_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  audio_quality_lbl.len = audio_speed_get(cvar("snd_speed"));
  
  cacheGlobalString( audio_quality_lbl.label, audio_speed_get_val(audio_quality_lbl.len) )
  
  if(audio_quality_lbl.len == 0){
    audio_quality_dn.drawme = FALSE;
  }
  else if(audio_speakers_lbl.len == 4){
    audio_quality_up.drawme = FALSE;
  }
  
  //operations
  audio_back = btn_text_callback(MENU_ORG + '40 272', '16 16', "BACK", VIEW_CTX, M_OPTIONS_AUDIO, click_audio_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  audio_back.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  audio_save = btn_text_callback(MENU_ORG + '245 272', '16 16', "ACCEPT", VIEW_CTX, M_OPTIONS_AUDIO, click_audio_save, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  audio_save.fontId = FONT_NUM_XOLONIUM_BOLD;

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
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  gui_renderString("- Audio Settings -", MENU_ORG + menu_parent_center_width(35) - Vector2(stringwidth("- Audio Settings -", 0, '16 16')/2,0), CLR_DEF_WHITE, '16 16', 1, 0);

  gui_renderString("Sound On/Off :", audio_sfx_toggle_off.origin - Vector2(stringwidth("Sound On/Off :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString("Sound Volume :", audio_sfx_dn.origin - Vector2(stringwidth("Sound Volume :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString("Music On/Off :", audio_music_toggle_off.origin - Vector2(stringwidth("Music On/Off :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString("Music Volume :", audio_music_dn.origin - Vector2(stringwidth("Music Volume :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  
  local string lbl;
  if( !isdemo() && clientstate() == CS_CONNECTED){
    lbl = "Advanced Settings - changes will require restart";
  }
  else{
    lbl = "Advanced Settings";
  }
  gui_renderString(lbl, MENU_ORG + '25 160', CLR_DEF_ARM_THREEQ, '12 12', 1, 0);
  gui_renderString("Speaker Mode :", audio_speakers_less.origin - Vector2(stringwidth("Speaker Mode :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString("Mute Minimized :", audio_mute_idle_off.origin - Vector2(stringwidth("Mute Minimized :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  gui_renderString("Sound Quality :", audio_quality_dn.origin  - Vector2(stringwidth("Sound Quality :  ", 0, '12 12'),-1), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);  

  drawfont = drawfont_prev;

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