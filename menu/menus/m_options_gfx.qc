/*
battleMETAL
Author: Peter Roohr
Date: 4/19/2018
mod: 07/20/2019
Overview: gfx game menu
*/

/*
//gfx menu
bloom color subtract 0 - 0.938 / 0.063
bloom color exponent 1 - 8 / * 2
bloom intensity 0.0 - 4 / 0.63
bloom size 1 - 16 | 1
bloomr resolution 64 - 2048 incr 64
*/

//gfx Globals
entity gfx_title;

entity gfx_corona_intensity_lbl;
entity gfx_corona_intensity_more;
entity gfx_corona_intensity_less;

entity gfx_corona_only_lbl;
entity gfx_corona_only_on;
entity gfx_corona_only_off;

entity gfx_gloss_mode_lbl;
entity gfx_gloss_mode_next;
entity gfx_gloss_mode_prev;

entity gfx_bloom_lbl;
entity gfx_bloom_on;
entity gfx_bloom_off;

entity gfx_scene_brightness_lbl;
entity gfx_scene_brightness_more;
entity gfx_scene_brightness_less;

entity gfx_glow_brightness_lbl;
entity gfx_glow_brightness_more;
entity gfx_glow_brightness_less;

entity gfx_bloom_clr_scale_lbl;
entity gfx_bloom_clr_scale_more;
entity gfx_bloom_clr_scale_less;

entity gfx_bloom_clr_subtract_lbl;
entity gfx_bloom_clr_subtract_more;
entity gfx_bloom_clr_subtract_less;

entity gfx_bloom_clr_exponent_lbl;
entity gfx_bloom_clr_exponent_more;
entity gfx_bloom_clr_exponent_less;

entity gfx_bloom_intense_lbl;
entity gfx_bloom_intense_more;
entity gfx_bloom_intense_less;

entity gfx_bloom_blur_lbl;
entity gfx_bloom_blur_more;
entity gfx_bloom_blur_less;

entity gfx_bloom_resolution_lbl;
entity gfx_bloom_resolution_more;
entity gfx_bloom_resolution_less;

entity gfx_back;
entity gfx_save;

//gfx constants
string(float select) gfx_gloss_mode_get={
  local string mode;
  switch(select){
    case 0:
      mode = "OFF";
      break;
    case 1:
      mode = "FOUND";
      break;
    case 2:
      mode = "AUTO";
      break;
  }
  return mode;
};

void(float show) gfx_bloom_toggle_menu={
  gfx_bloom_clr_scale_lbl.drawme = show;
  gfx_bloom_clr_scale_more.drawme = show;
  gfx_bloom_clr_scale_less.drawme = show;

  gfx_bloom_clr_subtract_lbl.drawme = show;
  gfx_bloom_clr_subtract_more.drawme = show;
  gfx_bloom_clr_subtract_less.drawme = show;

  gfx_bloom_clr_exponent_lbl.drawme = show;
  gfx_bloom_clr_exponent_more.drawme = show;
  gfx_bloom_clr_exponent_less.drawme = show;

  gfx_bloom_intense_lbl.drawme = show;
  gfx_bloom_intense_more.drawme = show;
  gfx_bloom_intense_less.drawme = show;

  gfx_bloom_blur_lbl.drawme = show;
  gfx_bloom_blur_more.drawme = show;
  gfx_bloom_blur_less.drawme = show;

  gfx_bloom_resolution_lbl.drawme = show;
  gfx_bloom_resolution_more.drawme = show;
  gfx_bloom_resolution_less.drawme = show;
};

//gfx callbacks
void() click_gfx_coronas_more={
  local float val;
  local string clean;
  val = gfx_corona_intensity_lbl.len;
  val = val + 0.125;
  if( val >= 4){
    val = 4;
    gfx_corona_intensity_more.drawme = FALSE;
  }
  gfx_corona_intensity_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_corona_intensity_lbl.label);
  gfx_corona_intensity_lbl.label = strzone(clean);
  gfx_corona_intensity_less.drawme = TRUE;
};
void() click_gfx_coronas_less={
  local float val;
  local string clean;
  val = gfx_corona_intensity_lbl.len;
  val = val - 0.125;
  if( val <= 0){
    val = 0;
    gfx_corona_intensity_less.drawme = FALSE;
  }
  gfx_corona_intensity_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_corona_intensity_lbl.label);
  gfx_corona_intensity_lbl.label = strzone(clean);
  gfx_corona_intensity_more.drawme = TRUE;
};

void() click_gfx_coronas_only_on={
  gfx_corona_only_lbl.len = TRUE;
  gfx_corona_only_on.drawme = FALSE;
  gfx_corona_only_off.drawme = TRUE;
  gfx_corona_only_lbl.color = CLR_DEF_ARM_OK;
};
void() click_gfx_coronas_only_off={
  gfx_corona_only_lbl.len = FALSE;
  gfx_corona_only_on.drawme = TRUE;
  gfx_corona_only_off.drawme = FALSE;
  gfx_corona_only_lbl.color = CLR_DEF_GRAY_H;
};

void() click_gfx_gloss_mode_next={
  local float select;
  select = gfx_gloss_mode_lbl.len;
  select = select + 1;
  if(select >= 2){
    select = 2;
    gfx_gloss_mode_next.drawme = FALSE;
  }
  gfx_gloss_mode_lbl.len = select;
  
  gfx_gloss_mode_lbl.label = gfx_gloss_mode_get(select);
  gfx_gloss_mode_prev.drawme = TRUE;
};
void() click_gfx_gloss_mode_prev={
  local float select;
  select = gfx_gloss_mode_lbl.len;
  select = select - 1;
  if(select <= 0){
    select = 0;
    gfx_gloss_mode_prev.drawme = FALSE;
  }
  gfx_gloss_mode_lbl.len = select;
  
  gfx_gloss_mode_lbl.label = gfx_gloss_mode_get(select);
  gfx_gloss_mode_next.drawme = TRUE;
};

void() click_gfx_bloom_on={
  gfx_bloom_lbl.len = TRUE;
  gfx_bloom_on.drawme = FALSE;
  gfx_bloom_off.drawme = TRUE;
  gfx_bloom_toggle_menu(TRUE);
  gfx_bloom_lbl.color = CLR_DEF_ARM_OK;
};
void() click_gfx_bloom_off={
  gfx_bloom_lbl.len = FALSE;
  gfx_bloom_on.drawme = TRUE;
  gfx_bloom_off.drawme = FALSE;
  gfx_bloom_toggle_menu(FALSE);
  gfx_bloom_lbl.color = CLR_DEF_GRAY_H;
};

void() click_gfx_scene_brightness_more={
  local float val;
  local string clean;
  val = gfx_scene_brightness_lbl.len;
  val = val + 0.125;
  if( val >= 4){
    val = 4;
    gfx_scene_brightness_more.drawme = FALSE;
  }
  gfx_scene_brightness_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_scene_brightness_lbl.label);
  gfx_scene_brightness_lbl.label = strzone(clean);
  gfx_scene_brightness_less.drawme = TRUE;
};
void() click_gfx_scene_brightness_less={
  local float val;
  local string clean;
  val = gfx_scene_brightness_lbl.len;
  val = val - 0.125;
  if( val <= 0){
    val = 0;
    gfx_scene_brightness_less.drawme = FALSE;
  }
  gfx_scene_brightness_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_scene_brightness_lbl.label);
  gfx_scene_brightness_lbl.label = strzone(clean);
  gfx_scene_brightness_more.drawme = TRUE;
};

void() click_gfx_glow_brightness_more={
  local float val;
  local string clean;
  val = gfx_glow_brightness_lbl.len;
  val = val + 0.125;
  if( val >= 4){
    val = 4;
    gfx_glow_brightness_more.drawme = FALSE;
  }
  gfx_glow_brightness_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_glow_brightness_lbl.label);
  gfx_glow_brightness_lbl.label = strzone(clean);
  gfx_glow_brightness_less.drawme = TRUE;
};
void() click_gfx_glow_brightness_less={
  local float val;
  local string clean;
  val = gfx_glow_brightness_lbl.len;
  val = val - 0.125;
  if( val <= 0){
    val = 0;
    gfx_glow_brightness_less.drawme = FALSE;
  }
  gfx_glow_brightness_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_glow_brightness_lbl.label);
  gfx_glow_brightness_lbl.label = strzone(clean);
  gfx_glow_brightness_more.drawme = TRUE;
};

void() click_gfx_bloom_color_scale_more={
  local float val;
  local string clean;
  val = gfx_bloom_clr_scale_lbl.len;
  val = val + 0.125;
  if( val >= 1){
    val = 1;
    gfx_bloom_clr_scale_more.drawme = FALSE;
  }
  gfx_bloom_clr_scale_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_bloom_clr_scale_lbl.label);
  gfx_bloom_clr_scale_lbl.label = strzone(clean);
  gfx_bloom_clr_scale_less.drawme = TRUE;
};
void() click_gfx_bloom_color_scale_less={
  local float val;
  local string clean;
  val = gfx_bloom_clr_scale_lbl.len;
  val = val - 0.125;
  if( val <= 0){
    val = 0;
    gfx_bloom_clr_scale_less.drawme = FALSE;
  }
  gfx_bloom_clr_scale_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_bloom_clr_scale_lbl.label);
  gfx_bloom_clr_scale_lbl.label = strzone(clean);
  gfx_bloom_clr_scale_more.drawme = TRUE;
};

void() click_gfx_bloom_color_subtract_more={
  local float val;
  local string clean;
  val = gfx_bloom_clr_subtract_lbl.len;
  val = val + 0.063;
  if( val >= 0.938){
    val = 1;
    gfx_bloom_clr_subtract_more.drawme = FALSE;
  }
  gfx_bloom_clr_subtract_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_bloom_clr_subtract_lbl.label);
  gfx_bloom_clr_subtract_lbl.label = strzone(clean);
  gfx_bloom_clr_subtract_less.drawme = TRUE;
};
void() click_gfx_bloom_color_subtract_less={
  local float val;
  local string clean;
  val = gfx_bloom_clr_subtract_lbl.len;
  val = val - 0.063;
  if( val <= 0){
    val = 0;
    gfx_bloom_clr_subtract_less.drawme = FALSE;
  }
  gfx_bloom_clr_subtract_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_bloom_clr_subtract_lbl.label);
  gfx_bloom_clr_subtract_lbl.label = strzone(clean);
  gfx_bloom_clr_subtract_more.drawme = TRUE;
};

void() click_gfx_bloom_color_exponent_more={
  local float val;
  val = gfx_bloom_clr_exponent_lbl.len;
  val = val * 2;
  if( val >= 8){
    val = 8;
    gfx_bloom_clr_exponent_more.drawme = FALSE;
  }
  gfx_bloom_clr_exponent_lbl.len = val;
  gfx_bloom_clr_exponent_less.drawme = TRUE;
};
void() click_gfx_bloom_color_exponent_less={
  local float val;
  val = gfx_bloom_clr_exponent_lbl.len;
  val = val / 2;
  if( val <= 1){
    val = 1;
    gfx_bloom_clr_exponent_less.drawme = FALSE;
  }
  gfx_bloom_clr_exponent_lbl.len = val;
  gfx_bloom_clr_exponent_more.drawme = TRUE;
};

void() click_gfx_bloom_intensity_more={
  local float val;
  local string clean;
  val = gfx_bloom_intense_lbl.len;
  val = val + 0.063;
  if( val >= 4){
    val = 4;
    gfx_bloom_intense_more.drawme = FALSE;
  }
  gfx_bloom_intense_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_bloom_intense_lbl.label);
  gfx_bloom_intense_lbl.label = strzone(clean);
  gfx_bloom_intense_less.drawme = TRUE;
};
void() click_gfx_bloom_intensity_less={
  local float val;
  local string clean;
  val = gfx_bloom_intense_lbl.len;
  val = val - 0.063;
  if( val <= 0){
    val = 0;
    gfx_bloom_intense_less.drawme = FALSE;
  }
  gfx_bloom_intense_lbl.len = val;
  clean = sprintf("%0.3f", val);
  strunzone(gfx_bloom_intense_lbl.label);
  gfx_bloom_intense_lbl.label = strzone(clean);
  gfx_bloom_intense_more.drawme = TRUE;
};

void() click_gfx_bloom_blur_more={
  local float val;
  val = gfx_bloom_blur_lbl.len;
  val = val + 1;
  if( val >= 16){
    val = 16;
    gfx_bloom_blur_more.drawme = FALSE;
  }
  gfx_bloom_blur_lbl.len = val;
  strunzone(gfx_bloom_blur_lbl.label);
  gfx_bloom_blur_lbl.label = strzone(ftos(val));
  gfx_bloom_intense_less.drawme = TRUE;
};
void() click_gfx_bloom_blur_less={
  local float val;
  val = gfx_bloom_blur_lbl.len;
  val = val - 1;
  if( val <= 1){
    val = 1;
    gfx_bloom_blur_less.drawme = FALSE;
  }
  gfx_bloom_blur_lbl.len = val;
  strunzone(gfx_bloom_blur_lbl.label);
  gfx_bloom_blur_lbl.label = strzone(ftos(val));
  gfx_bloom_blur_more.drawme = TRUE;
};

void() click_gfx_bloom_resolution_more={
  local float val;
  val = gfx_bloom_resolution_lbl.len;
  val = val + 64;
  if( val >= 2048){
    val = 2048;
    gfx_bloom_resolution_more.drawme = FALSE;
  }
  gfx_bloom_resolution_lbl.len = val;
  strunzone(gfx_bloom_resolution_lbl.label);
  gfx_bloom_resolution_lbl.label = strzone(ftos(val));
  gfx_bloom_intense_less.drawme = TRUE;
};
void() click_gfx_bloom_resolution_less={
  local float val;
  val = gfx_bloom_resolution_lbl.len;
  val = val - 64;
  if( val <= 64){
    val = 64;
    gfx_bloom_resolution_less.drawme = FALSE;
  }
  gfx_bloom_resolution_lbl.len = val;
  strunzone(gfx_bloom_resolution_lbl.label);
  gfx_bloom_resolution_lbl.label = strzone(ftos(val));
  gfx_bloom_resolution_more.drawme = TRUE;
};

void() click_gfx_back={
  menu_clear_items(M_STATE);
  m_graphics_f();
};

void() click_gfx_save={
 
  //veto power, you can't override RT_lights cause the entire game depends on them 
  //being on all the time
  cvar_set("r_shadow_realtime_dlight", "1");
  cvar_set("r_shadow_realtime_dlight_shadows", "1");
  cvar_set("r_shadow_realtime_world", "1");
  cvar_set("r_shadow_realtime_world_lightmaps", "0.8");
  cvar_set("r_shadow_realtime_world_shadows", "1");
  cvar_set("r_shadow_glossexact", "1");
  //=====================
  
  cvar_set("r_coronas", ftos(gfx_corona_intensity_lbl.len));
  cvar_set("gl_flashblend", ftos(gfx_corona_only_lbl.len));
  cvar_set("r_shadow_gloss", ftos(gfx_gloss_mode_lbl.len));
  
  cvar_set("r_bloom", ftos(gfx_bloom_lbl.len));
  
  cvar_set("r_hdr_scenebrightness", ftos(gfx_scene_brightness_lbl.len));
  cvar_set("r_hdr_glowintensity", ftos(gfx_glow_brightness_lbl.len));
  cvar_set("r_bloom_colorscale", ftos(gfx_bloom_clr_scale_lbl.len));
  cvar_set("r_bloom_colorsubtract", ftos(gfx_bloom_clr_subtract_lbl.len));
  cvar_set("r_bloom_colorexponent", ftos(gfx_bloom_clr_exponent_lbl.len));
  cvar_set("r_bloom_brighten", ftos(gfx_bloom_intense_lbl.len));
  cvar_set("r_bloom_blur", ftos(gfx_bloom_blur_lbl.len));
  
  
  cvar_set("saved2", "0");
  localcmd("saveconfig\n");
  menu_clear_items(M_STATE);
  m_graphics_f();
};

// ini function, called by '_f' function as a setup func
void() m_gfx_i={

  menu_parent_setup(VIEW_ORG + '0 40', '240 352');

  gfx_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_GFX, 1, UI_FLAG_SIZE_IMG );
  
  //coronas
  gfx_corona_intensity_lbl = lbl_text(MENU_ORG + '150 63', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_corona_intensity_lbl.len = cvar("r_coronas");
  gfx_corona_intensity_lbl.label = sprintf("%0.3f", gfx_corona_intensity_lbl.len);
  gfx_corona_intensity_lbl.label = strzone(gfx_corona_intensity_lbl.label);
  gfx_corona_intensity_more = btn_img_callback(gfx_corona_intensity_lbl.origin + Vector2(stringwidth(gfx_corona_intensity_lbl.label, 0, gfx_corona_intensity_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_coronas_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_corona_intensity_less = btn_img_callback(gfx_corona_intensity_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_coronas_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_corona_intensity_lbl.len == 0){
    gfx_corona_intensity_less.drawme = FALSE;
  }
  else if(gfx_corona_intensity_lbl.len >= 4){
    gfx_corona_intensity_more.drawme = FALSE;
  }
  
  gfx_corona_only_lbl = lbl_text(MENU_ORG + '150 83', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, UI_FLAG_LBL_BOOL_ON);
  gfx_corona_only_lbl.len = cvar("gl_flashblend");
  gfx_corona_only_on = btn_img_callback(gfx_corona_only_lbl.origin + Vector2(stringwidth("OFF", 0, gfx_corona_only_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_coronas_only_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_corona_only_off = btn_img_callback(gfx_corona_only_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_coronas_only_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_corona_only_lbl.len){
    gfx_corona_only_on.drawme = FALSE;
  }
  else{
    gfx_corona_only_off.drawme = FALSE;
  }
  
  //gloss mode
  gfx_gloss_mode_lbl = lbl_text(MENU_ORG + '150 103', '14 14', strzone(gfx_gloss_mode_get(cvar("r_shadow_gloss"))), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_gloss_mode_lbl.len = cvar("r_shadow_gloss");
  gfx_gloss_mode_next = btn_img_callback(gfx_gloss_mode_lbl.origin + Vector2(stringwidth(gfx_gloss_mode_lbl.label, 0, gfx_gloss_mode_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_gloss_mode_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_gloss_mode_prev = btn_img_callback(gfx_gloss_mode_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_gloss_mode_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_gloss_mode_lbl.len == 0){
    gfx_gloss_mode_prev.drawme = FALSE;
  }
  else if(gfx_gloss_mode_lbl.len == 2){
    gfx_gloss_mode_next.drawme = FALSE;
  }
  
  //scene bright
  gfx_scene_brightness_lbl = lbl_text(MENU_ORG + '150 123', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_scene_brightness_lbl.len = cvar("r_hdr_scenebrightness");
  gfx_scene_brightness_lbl.label = sprintf("%0.3f", gfx_scene_brightness_lbl.len);
  gfx_scene_brightness_lbl.label = strzone(gfx_scene_brightness_lbl.label);
  gfx_scene_brightness_more = btn_img_callback(gfx_scene_brightness_lbl.origin + Vector2(stringwidth(gfx_gloss_mode_lbl.label, 0, gfx_gloss_mode_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_scene_brightness_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_scene_brightness_less = btn_img_callback(gfx_scene_brightness_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_scene_brightness_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_scene_brightness_lbl.len == 0){
    gfx_scene_brightness_less.drawme = FALSE;
  }
  else if(gfx_scene_brightness_lbl.len >= 4){
    gfx_scene_brightness_more.drawme = FALSE;
  }

  //glow?
  gfx_glow_brightness_lbl = lbl_text(MENU_ORG + '150 143', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_glow_brightness_lbl.len = cvar("r_hdr_glowintensity");
  gfx_glow_brightness_lbl.label = sprintf("%0.3f", gfx_glow_brightness_lbl.len);
  gfx_glow_brightness_lbl.label = strzone(gfx_glow_brightness_lbl.label);
  gfx_glow_brightness_more = btn_img_callback(gfx_glow_brightness_lbl.origin + Vector2(stringwidth(gfx_glow_brightness_lbl.label, 0, gfx_glow_brightness_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_glow_brightness_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_glow_brightness_less = btn_img_callback(gfx_glow_brightness_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_glow_brightness_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_glow_brightness_lbl.len == 0){
    gfx_glow_brightness_less.drawme = FALSE;
  }
  else if(gfx_glow_brightness_lbl.len >= 4){
    gfx_glow_brightness_more.drawme = FALSE;
  }

  //bloom toggle
  gfx_bloom_lbl = lbl_text(MENU_ORG + '150 163', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, UI_FLAG_LBL_BOOL_ON);
  gfx_bloom_lbl.len = cvar("r_bloom");
  gfx_bloom_on = btn_img_callback(gfx_bloom_lbl.origin + Vector2(stringwidth("OFF", 0, gfx_bloom_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_bloom_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_off = btn_img_callback(gfx_bloom_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_bloom_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_bloom_lbl.len == 0){
    gfx_bloom_off.drawme = FALSE;
  }
  else{
    gfx_bloom_on.drawme = FALSE;
  }

  //bloom config
  gfx_bloom_clr_scale_lbl = lbl_text(MENU_ORG + '150 183', '14 14', " ", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_bloom_clr_scale_lbl.len = cvar("r_bloom_colorscale");
  gfx_bloom_clr_scale_lbl.label = sprintf("%0.3f", gfx_bloom_clr_scale_lbl.len);
  gfx_bloom_clr_scale_lbl.label = strzone(gfx_bloom_clr_scale_lbl.label);
  gfx_bloom_clr_scale_more = btn_img_callback(gfx_bloom_clr_scale_lbl.origin + Vector2(stringwidth(gfx_bloom_clr_scale_lbl.label, 0, gfx_bloom_clr_scale_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_bloom_color_scale_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_clr_scale_less = btn_img_callback(gfx_bloom_clr_scale_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_bloom_color_scale_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_bloom_clr_scale_lbl.len == 0){
    gfx_bloom_clr_scale_less.drawme = FALSE;
  }
  else if(gfx_bloom_clr_scale_lbl.len >= 1){
    gfx_bloom_clr_scale_more.drawme = FALSE;
  }

  gfx_bloom_clr_subtract_lbl = lbl_text(MENU_ORG + '150 203', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_bloom_clr_subtract_lbl.len = cvar("r_bloom_colorsubtract");
  gfx_bloom_clr_subtract_lbl.label = sprintf("%0.3f", gfx_bloom_clr_subtract_lbl.len);
  gfx_bloom_clr_subtract_lbl.label = strzone(gfx_bloom_clr_subtract_lbl.label);
  gfx_bloom_clr_subtract_more = btn_img_callback(gfx_bloom_clr_subtract_lbl.origin + Vector2(stringwidth(gfx_bloom_clr_subtract_lbl.label, 0, gfx_bloom_clr_subtract_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_bloom_color_subtract_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_clr_subtract_less = btn_img_callback(gfx_bloom_clr_subtract_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_bloom_color_subtract_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(gfx_bloom_clr_subtract_lbl.len == 0){
    gfx_bloom_clr_subtract_less.drawme = FALSE;
  }
  else if(gfx_bloom_clr_subtract_lbl.len >= 1){
    gfx_bloom_clr_subtract_more.drawme = FALSE;
  }

  gfx_bloom_clr_exponent_lbl = lbl_text(MENU_ORG + '150 223', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, UI_FLAG_LBL_USELEN);
  gfx_bloom_clr_exponent_lbl.len = cvar("r_bloom_colorexponent");
  gfx_bloom_clr_exponent_more = btn_img_callback(gfx_bloom_clr_exponent_lbl.origin + Vector2(stringwidth(gfx_bloom_clr_exponent_lbl.label, 0, gfx_bloom_clr_exponent_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_bloom_color_exponent_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_clr_exponent_less = btn_img_callback(gfx_bloom_clr_exponent_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_bloom_color_exponent_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(gfx_bloom_clr_exponent_lbl.len == 0){
    gfx_bloom_clr_exponent_less.drawme = FALSE;
  }
  else if(gfx_bloom_clr_exponent_lbl.len >= 8){
    gfx_bloom_clr_exponent_more.drawme = FALSE;
  }
  
  gfx_bloom_intense_lbl = lbl_text(MENU_ORG + '150 243', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_bloom_intense_lbl.len = cvar("r_bloom_brighten");
  gfx_bloom_intense_lbl.label = strzone(sprintf("%0.3f", gfx_bloom_intense_lbl.len));
  gfx_bloom_intense_more = btn_img_callback(gfx_bloom_intense_lbl.origin + Vector2(stringwidth(gfx_bloom_intense_lbl.label, 0, gfx_bloom_intense_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_bloom_intensity_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_intense_less = btn_img_callback(gfx_bloom_intense_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_bloom_intensity_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(gfx_bloom_intense_lbl.len == 0){
    gfx_bloom_intense_less.drawme = FALSE;
  }
  else if(gfx_bloom_intense_lbl.len >= 4){
    gfx_bloom_intense_more.drawme = FALSE;
  }

  gfx_bloom_blur_lbl = lbl_text(MENU_ORG + '150 263', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_bloom_blur_lbl.len = cvar("r_bloom_blur");
  gfx_bloom_blur_lbl.label = strzone(ftos(gfx_bloom_blur_lbl.len));
  gfx_bloom_blur_more = btn_img_callback(gfx_bloom_blur_lbl.origin + Vector2(stringwidth(gfx_bloom_blur_lbl.label, 0, gfx_bloom_blur_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GFX, click_gfx_bloom_blur_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_blur_less = btn_img_callback(gfx_bloom_blur_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GFX, click_gfx_bloom_blur_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(gfx_bloom_blur_lbl.len <= 1){
    gfx_bloom_blur_less.drawme = FALSE;
  }
  else if(gfx_bloom_blur_lbl.len >= 16){
    gfx_bloom_blur_more.drawme = FALSE;
  }

  gfx_bloom_resolution_lbl = lbl_text(MENU_ORG + '150 283', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GFX, 1, 0);
  gfx_bloom_resolution_lbl.len = cvar("r_bloom_resolution");
  gfx_bloom_resolution_lbl.label = strzone(ftos(gfx_bloom_resolution_lbl.len));
  gfx_bloom_resolution_more = btn_img_callback(gfx_bloom_resolution_lbl.origin + Vector2(stringwidth("9999", 0, gfx_bloom_resolution_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, VIEW_CTX, M_OPTIONS_GFX, click_gfx_bloom_resolution_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  gfx_bloom_resolution_less = btn_img_callback(gfx_bloom_resolution_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, VIEW_CTX, M_OPTIONS_GFX, click_gfx_bloom_resolution_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(gfx_bloom_resolution_lbl.len <= 64){
    gfx_bloom_resolution_less.drawme = FALSE;
  }
  else if(gfx_bloom_resolution_lbl.len >= 2048){
    gfx_bloom_resolution_more.drawme = FALSE;
  }
  
  gfx_bloom_toggle_menu(gfx_bloom_lbl.len);

  //operations
  gfx_back = btn_text_callback(MENU_ORG + '45 310', '16 16', "BACK", VIEW_CTX, M_OPTIONS_GFX, click_gfx_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  gfx_back.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  gfx_save = btn_text_callback(MENU_ORG + '200 310', '16 16', "SAVE", VIEW_CTX, M_OPTIONS_GFX, click_gfx_save, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  gfx_save.fontId = FONT_NUM_XOLONIUM_BOLD;

};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_gfx_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_GFX;
  setkeydest(KEY_MENU);
  m_gfx_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_gfx_d={ 

  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderString("- Lighting Settings -", MENU_ORG + menu_parent_center_width(40) - Vector2((stringwidth("- Lighting Settings -", 0, '16 16')/2),0), CLR_DEF_TXT_NONSELECT, '16 16', 1, 0);
  
    gui_renderString("Corona Intensity:", gfx_corona_intensity_less.origin - Vector2(stringwidth("Corona Intensity:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Use Only Coronas:", gfx_corona_only_off.origin - Vector2(stringwidth("Use Only Coronas:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Gloss Mode:", gfx_gloss_mode_prev.origin - Vector2(stringwidth("Gloss Mode:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("HDR Scene Brightness:", gfx_scene_brightness_less.origin - Vector2(stringwidth("HDR Scene Brightness:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("HDR Glow Brightness:", gfx_glow_brightness_less.origin - Vector2(stringwidth("HDR Glow Brightness:   ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Bloom Effect:", gfx_bloom_off.origin - Vector2(stringwidth("Bloom Effect:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  if(gfx_bloom_lbl.len){
    gui_renderString("Bloom Color Scale:", gfx_bloom_clr_scale_less.origin - Vector2(stringwidth("Bloom Color Scale:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Bloom color Subtract:", gfx_bloom_clr_subtract_less.origin - Vector2(stringwidth("Bloom color Subtract:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Bloom color Exponent:", gfx_bloom_clr_exponent_less.origin - Vector2(stringwidth("Bloom color Exponent:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Bloom Intensity:", gfx_bloom_intense_less.origin - Vector2(stringwidth("Bloom Intensity:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Bloom Blur:", gfx_bloom_blur_less.origin - Vector2(stringwidth("Bloom Blur:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    gui_renderString("Bloom Fidelity:", gfx_bloom_resolution_less.origin - Vector2(stringwidth("Bloom Fidelity:   ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  }
  drawfont = drawfont_prev;

  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_GFX);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_gfx_k={
  //cons_logAFloat("m_effects_k.key", key);  //DEBUG
  //cons_logAFloat("m_effects_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS_GRAPHICS;
      m_graphics_f();
      break;
  }
};