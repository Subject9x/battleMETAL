/*
battleMETAL
Author: Peter Roohr
Date: 4/17/2018
Overview: 
  options - graphics menu
*/

//graphics Globals
entity graphics_title;
entity graphics_resolution_lbl;
entity graphics_resolution_less;
entity graphics_resolution_more;

entity graphics_resolution_aspect_lbl;

entity graphics_bits_lbl;
entity graphics_bits_less;
entity graphics_bits_more;

entity graphics_aa_lbl;
entity graphics_aa_more;
entity graphics_aa_less;

entity graphics_refresh_lbl;
entity graphics_refresh_on;
entity graphics_refresh_off;

entity graphics_refreshieldRate_lbl;
entity graphics_refreshieldRate_up;
entity graphics_refreshieldRate_dn;

entity graphics_fullscreen_lbl;
entity graphics_fullscreen_on;
entity graphics_fullscreen_off;

entity graphics_vsync_lbl;
entity graphics_vsync_on;
entity graphics_vsync_off;

entity graphics_aniso_lbl;
entity graphics_aniso_more;
entity graphics_aniso_less;

entity graphics_texture_quality_lbl;
entity graphics_texture_quality_more;
entity graphics_texture_quality_less;

entity graphics_texture_compress_lbl;
entity graphics_texture_compress_on;
entity graphics_texture_compress_off;

entity graphics_effects_lbl;
entity graphics_effects_more;
entity graphics_effects_less;
entity graphics_effects_custom;

entity graphics_gfx_lbl;
entity graphics_gfx_more;
entity graphics_gfx_less;
entity graphics_gfx_custom;

entity graphics_game_contrast_lbl;
entity graphics_game_contrast_more;
entity graphics_game_contrast_less;

entity graphics_gamma_lbl;
entity graphics_gamma_more;
entity graphics_gamma_less;

entity graphics_back;
entity graphics_accept;

//graphics constants
vector VID_NEXT;
vector VID_CNEXT;

float ACCEPT_TIMER;
float ACCEPT_PAUSE = 3;

string(float val) graphics_get_detail={
  local string lbl;
  switch(val){
    case 0:
      lbl = "CUSTOM";
      break;
    case 1:
      lbl = "LOW";
      break;
    case 2:
      lbl = "MEDIUM";
      break;
    case 3:
      lbl = "HIGH";
      break;
  }
  return lbl;
};

string(float val) graphics_get_gx={
  local string lbl;
  switch(val){
    default:
      lbl = "CUSTOM";
      break;
    case 1:
      lbl = "LOW";
      break;
    case 2:
      lbl = "NORMAL";
      break;
    case 3:
      lbl = "HIGH";
      break;
    case 4:
      lbl = "MAX";
      break;
  }
  return lbl;
};

void(float level) graphics_effects_set={
  local string cvars;
  switch(level){
    default:
      cvars = "data/cache/settings/graphics_medium.cvl";
      break;
    case 2:
      cvars = "data/cache/settings/graphics_low.cvl"; 
      break;
    case 3:
      cvars = "data/cache/settings/graphics_medium.cvl";
      break;
    case 4:
      cvars = "data/cache/settings/graphics_high.cvl";
      break;
  }
  menu_execute_cvar_list(cvars);
};

void(float level) graphics_light_set={
  local string cvars;
  switch(level){
    default:
      cvars = "data/cache/settings/lighting_low.cvl";
      break;
    case 2:
      cvars = "data/cache/settings/lighting_normal.cvl"; 
      break;
    case 3:
      cvars = "data/cache/settings/lighting_high.cvl";
      break;
    case 4:
      cvars = "data/cache/settings/lighting_max.cvl";
      break;
  }
  menu_execute_cvar_list(cvars);
};

string(float level) graphics_set_texture_quality_label={
  switch(level){
    case 4:
      return "VERY LOW";
    case 3:
      return "LOW";
    case 2:
      return "PERFORMANCE";
    case 1:
      return "NORMAL";
    case 0:
      return "ULTRA";
  }
  return "NORMAL";
};

string(float level) graphics_set_aa_value={
  switch(level){
    case 16:
      return "VERY HIGH";
    case 8:
      return "HIGH";
    case 4:
      return "NORMAL";
    case 2:
      return "LOW";
    case 1:
      return "VERY LOW";
  }
  return "NORMAL";
};

//graphics callbacks
void() click_graphics_resolution_less={
  local float vid;
  vid = graphics_resolution_lbl.len;
  vid = vid - 1;
  if(vid < 0){
    vid = VID_RESO_TOTAL - 1;
  }
  cons_logAFloat("click_graphics_resolution_less()->vid", vid); //DEBUG
  VID_NEXT = VID_RESO_SIZE[vid];
  VID_CNEXT = VID_RESO_HALF[vid];
  strunzone(graphics_resolution_lbl.label);
  graphics_resolution_lbl.label = strzone(menu_getvideo_clean(vid));
  graphics_resolution_lbl.len = vid;
  strunzone(graphics_resolution_aspect_lbl.label);
  graphics_resolution_aspect_lbl.label = strzone(VID_RESO_NAME[vid]);
};
void() click_graphics_resolution_more={
  local float vid;
  vid = graphics_resolution_lbl.len;
  vid = vid + 1;
  if(vid > VID_RESO_TOTAL){
    vid = 0;
  }
  VID_NEXT = VID_RESO_SIZE[vid];
  VID_CNEXT = VID_RESO_HALF[vid];
  strunzone(graphics_resolution_lbl.label);
  graphics_resolution_lbl.label = strzone(menu_getvideo_clean(vid));
  graphics_resolution_lbl.len = vid;
  strunzone(graphics_resolution_aspect_lbl.label);
  graphics_resolution_aspect_lbl.label = strzone(VID_RESO_NAME[vid]);
};

void() click_graphics_bits_less={
  graphics_bits_lbl.label = "16";
  graphics_bits_less.drawme = FALSE;
  graphics_bits_more.drawme = TRUE;
};
void() click_graphics_bits_more={
  graphics_bits_lbl.label = "32";
  graphics_bits_less.drawme = TRUE;
  graphics_bits_more.drawme = FALSE;
};

void() click_graphics_aa_more={
  local float sampl;
  sampl = graphics_aa_lbl.len;
  sampl = sampl * 2;
  if(sampl >= 16){
    sampl = 16;
    graphics_aa_more.drawme = FALSE;
  }
  if( !graphics_aa_less.drawme ){
    graphics_aa_less.drawme = TRUE;
  }
  graphics_aa_lbl.len = sampl;
  strunzone(graphics_aa_lbl.label); 
  graphics_aa_lbl.label = strzone(ftos(sampl));
};
void() click_graphics_aa_less={
  local float sampl;
  sampl = graphics_aa_lbl.len;
  sampl = rint(sampl / 2);
  if(sampl <= 1){
    sampl = 1;
    graphics_aa_less.drawme = FALSE;
  }
  if( !graphics_aa_more.drawme ){
    graphics_aa_more.drawme = TRUE;
  }
  graphics_aa_lbl.len = sampl;
  strunzone(graphics_aa_lbl.label); 
  graphics_aa_lbl.label = strzone(ftos(sampl));
};

void() click_refresh_on={
  strunzone(graphics_refresh_lbl.label); 
  graphics_refresh_lbl.label = strzone("ON");
  graphics_refresh_lbl.len = TRUE;
 
  graphics_refresh_off.drawme = TRUE;
  graphics_refresh_on.drawme = FALSE;
  
  graphics_refreshieldRate_lbl.len = 60;
  strunzone(graphics_refreshieldRate_lbl.label); 
  graphics_refreshieldRate_lbl.label = strzone(ftos(cvar("vid_refreshrate")));
  graphics_refreshieldRate_up.drawme = TRUE;
  graphics_refreshieldRate_dn.drawme = TRUE;
  graphics_refresh_lbl.color = CLR_DEF_ARM_OK;
};
void() click_refresh_off={
  strunzone(graphics_refresh_lbl.label); 
  graphics_refresh_lbl.label = strzone("OFF");
  graphics_refresh_lbl.len = FALSE;

  graphics_refresh_off.drawme = FALSE;
  graphics_refresh_on.drawme = TRUE;
  
  graphics_refreshieldRate_lbl.len = 0;
  strunzone(graphics_refreshieldRate_lbl.label); 
  graphics_refreshieldRate_lbl.label = strzone("OFF");
  graphics_refreshieldRate_up.drawme = FALSE;
  graphics_refreshieldRate_dn.drawme = FALSE;
  graphics_refresh_lbl.color = CLR_DEF_GRAY_H;
};

void() click_refreshieldRate_up={
  local float rate;
  rate = graphics_refreshieldRate_lbl.len;
  rate = rate + 10;
  if(rate >= 120){
    rate = 120;
    graphics_refreshieldRate_up.drawme = FALSE;
  }
  strunzone(graphics_refreshieldRate_lbl.label);
  graphics_refreshieldRate_lbl.label = strzone(ftos(rate));
  graphics_refreshieldRate_lbl.len = rate;
  if( !graphics_refreshieldRate_dn.drawme ){
    graphics_refreshieldRate_dn.drawme = TRUE;
  }
};
void() click_refreshieldRate_dn={
  local float rate;
  rate = graphics_refreshieldRate_lbl.len;
  rate = rate - 10;
  if(rate <= 50){
    rate = 50;
    graphics_refreshieldRate_dn.drawme = FALSE;
  }
  strunzone(graphics_refreshieldRate_lbl.label);
  graphics_refreshieldRate_lbl.label = strzone(ftos(rate));
  graphics_refreshieldRate_lbl.len = rate;
  
  if( !graphics_refreshieldRate_up.drawme ){
    graphics_refreshieldRate_up.drawme = TRUE;
  }
};

void() click_graphics_fullscreen_on={
  if(!graphics_fullscreen_lbl.len){
    graphics_fullscreen_lbl.len = TRUE;
    graphics_fullscreen_on.drawme = FALSE;
  }
  if( !graphics_fullscreen_off.drawme ){
    graphics_fullscreen_off.drawme = TRUE;
  }
  strunzone(graphics_fullscreen_lbl.label); 
  graphics_fullscreen_lbl.label = strzone("ON");
  graphics_fullscreen_lbl.color = CLR_DEF_ARM_OK;
};
void() click_graphics_fullscreen_off={
  if(graphics_fullscreen_lbl.len){
    graphics_fullscreen_lbl.len = FALSE;
    graphics_fullscreen_off.drawme = FALSE;
  }
  if( !graphics_fullscreen_on.drawme ){
    graphics_fullscreen_on.drawme = TRUE;
  }
  strunzone(graphics_fullscreen_lbl.label); 
  graphics_fullscreen_lbl.label = strzone("OFF");
  graphics_fullscreen_lbl.color = CLR_DEF_GRAY_H;
};

void() click_graphics_vsync_on={
  if(!graphics_vsync_lbl.len){
    graphics_vsync_lbl.len = TRUE;
    graphics_vsync_on.drawme = FALSE;
  }
  if( !graphics_vsync_off.drawme ){
    graphics_vsync_off.drawme = TRUE;
  }
  strunzone(graphics_vsync_lbl.label); 
  graphics_vsync_lbl.label = strzone("ON");
  graphics_vsync_lbl.color = CLR_DEF_ARM_OK;
};
void() click_graphics_vsync_off={
  if(graphics_vsync_lbl.len){
    graphics_vsync_lbl.len = FALSE;
    graphics_vsync_off.drawme = FALSE;
  }
  if( !graphics_vsync_on.drawme ){
    graphics_vsync_on.drawme = TRUE;
  }
  strunzone(graphics_vsync_lbl.label); 
  graphics_vsync_lbl.label = strzone("OFF");
  graphics_vsync_lbl.color = CLR_DEF_GRAY_H;
};

void() click_graphics_aniso_more={
  local float sampl;
  sampl = graphics_aniso_lbl.len;
  sampl = sampl * 2;
  if(sampl >= 32){
    sampl = 32;
    graphics_aniso_more.drawme = FALSE;
  }
  if( !graphics_aniso_less.drawme ){
    graphics_aniso_less.drawme = TRUE;
  }
  graphics_aniso_lbl.len = sampl;
  strunzone(graphics_aniso_lbl.label); 
  graphics_aniso_lbl.label = strzone(ftos(sampl));
};
void() click_graphics_aniso_less={
  local float sampl;
  sampl = graphics_aniso_lbl.len;
  sampl = sampl / 2;
  if(sampl <= 2){
    sampl = 2;
    graphics_aniso_less.drawme = FALSE;
  }
  if( !graphics_aniso_more.drawme ){
    graphics_aniso_more.drawme = TRUE;
  }
  graphics_aniso_lbl.len = sampl;
  strunzone(graphics_aniso_lbl.label); 
  graphics_aniso_lbl.label = strzone(ftos(sampl));
};

void() click_graphics_texture_quality_more={
  local float sampl;
  sampl = graphics_texture_quality_lbl.len;
  sampl = sampl - 1;
  if(sampl <= 0){
    sampl = 0;
    graphics_texture_quality_more.drawme = FALSE;
  }
  if( !graphics_texture_quality_less.drawme ){
    graphics_texture_quality_less.drawme = TRUE;
  }
  graphics_texture_quality_lbl.len = sampl;
  strunzone(graphics_texture_quality_lbl.label);
  graphics_texture_quality_lbl.label = strzone( graphics_set_texture_quality_label(sampl));
};
void() click_graphics_texture_quality_less={
  local float sampl;
  sampl = graphics_texture_quality_lbl.len;
  sampl = sampl + 1;
  if(sampl >= 4){
    sampl = 4;
    graphics_texture_quality_less.drawme = FALSE;
  }
  graphics_texture_quality_lbl.len = sampl;
  if( !graphics_texture_quality_more.drawme ){
    graphics_texture_quality_more.drawme = TRUE;
  }
  strunzone(graphics_texture_quality_lbl.label);
  graphics_texture_quality_lbl.label = strzone( graphics_set_texture_quality_label(sampl));
};

void() click_graphics_texture_compression_on={
  if(!graphics_texture_compress_lbl.len){
    graphics_texture_compress_lbl.len = TRUE;
    graphics_texture_compress_on.drawme = FALSE;
  }
  if( !graphics_texture_compress_off.drawme ){
    graphics_texture_compress_off.drawme = TRUE;
  }
  strunzone(graphics_texture_compress_lbl.label); 
  graphics_texture_compress_lbl.label = strzone("ON");
  graphics_texture_compress_lbl.color = CLR_DEF_GRAY_H;
};
void() click_graphics_texture_compression_off={
  if(graphics_texture_compress_lbl.len){
    graphics_texture_compress_lbl.len = FALSE;
    graphics_texture_compress_off.drawme = FALSE;
  }
  if( !graphics_texture_compress_on.drawme ){
    graphics_texture_compress_on.drawme = TRUE;
  }
  strunzone(graphics_texture_compress_lbl.label); 
  graphics_texture_compress_lbl.label = strzone("OFF");
  graphics_texture_compress_lbl.color = CLR_DEF_ARM_OK;
};

void() click_graphics_effects_more={
  local float level;
  level = graphics_effects_lbl.len;
  level = level + 1;
  if( level > 0){ 
    graphics_effects_custom.drawme = FALSE;
  }
  if(level >= 3){
    level = 3;
    graphics_effects_more.drawme = FALSE;
  }
  if(level != 0){
    graphics_effects_set(level);
  }
  strunzone(graphics_effects_lbl.label);
  graphics_effects_lbl.label = strzone(graphics_get_detail(level));
  graphics_effects_lbl.len = level;
  if( !graphics_effects_less.drawme ){
    graphics_effects_less.drawme = TRUE;
  }
};
void() click_graphics_effects_less={
  local float level;
  level = graphics_effects_lbl.len;
  level = level - 1;
  if(level <= 0){
    level = 0;
    graphics_effects_less.drawme = FALSE;
    graphics_effects_custom.drawme = TRUE;
  }
  if(level != 0){
    graphics_effects_set(level);
  }
  strunzone(graphics_effects_lbl.label);
  graphics_effects_lbl.label = strzone(graphics_get_detail(level));
  graphics_effects_lbl.len = level;
  if( !graphics_effects_more.drawme ){
    graphics_effects_more.drawme = TRUE;
  }
};

void() click_graphics_light_more={
  local float level;
  level = graphics_gfx_lbl.len;
  level = level + 1;
  if( level > 0){ 
    graphics_gfx_custom.drawme = FALSE;
  }
  if(level >= 4){
    level = 4;
    graphics_gfx_more.drawme = FALSE;
  }
  if(level != 0){
    graphics_light_set(level);
  }
  strunzone(graphics_gfx_lbl.label);
  graphics_gfx_lbl.label = strzone(graphics_get_gx(level));
  graphics_gfx_lbl.len = level;
  if( !graphics_gfx_less.drawme ){
    graphics_gfx_less.drawme = TRUE;
  }
};
void() click_graphics_light_less={
  local float level;
  level = graphics_gfx_lbl.len;
  level = level - 1;
  if(level <= 0){
    level = 0;
    graphics_gfx_less.drawme = FALSE;
    graphics_gfx_custom.drawme = TRUE;
  }
  if(level != 0){
    graphics_light_set(level);
  }
  strunzone(graphics_gfx_lbl.label);
  graphics_gfx_lbl.label = strzone(graphics_get_gx(level));
  graphics_gfx_lbl.len = level;
  if( !graphics_gfx_more.drawme ){
    graphics_gfx_more.drawme = TRUE;
  }
};

void() click_graphics_gfx={
  menu_clear_items(M_STATE);
  m_gfx_f();
};

void() click_graphics_effects={
  menu_clear_items(M_STATE);
  m_effects_f();
};

void() click_contrast_up={
  local float rate;
  rate = graphics_game_contrast_lbl.len;
  rate = rate + 0.062;
  if(rate >= 4){
    rate = 4;
    graphics_game_contrast_more.drawme = FALSE;
  }
  strunzone(graphics_game_contrast_lbl.label);
  graphics_game_contrast_lbl.label = strzone(sprintf("%0.3f", rate));
  graphics_game_contrast_lbl.len = rate;
  cvar_set("v_contrast",  graphics_game_contrast_lbl.label);
  graphics_game_contrast_less.drawme = TRUE;
  
};
void() click_contrast_dn={
  local float rate;
  rate = graphics_game_contrast_lbl.len;
  rate = rate - 0.062;
  if(rate <= 1){
    rate = 1;
    graphics_game_contrast_less.drawme = FALSE;
  }
  strunzone(graphics_game_contrast_lbl.label);
  graphics_game_contrast_lbl.label = strzone(sprintf("%0.3f", rate));
  graphics_game_contrast_lbl.len = rate;
  cvar_set("v_contrast",  graphics_game_contrast_lbl.label);
  graphics_game_contrast_more.drawme = TRUE;
  
};

void() click_gamma_up={
  local float rate;
  rate = graphics_gamma_lbl.len;
  rate = rate + 0.062;
  if(rate >= 3){
    rate = 3;
    graphics_gamma_more.drawme = FALSE;
  }
  strunzone(graphics_gamma_lbl.label);
  graphics_gamma_lbl.label = strzone(sprintf("%0.3f", rate));
  graphics_gamma_lbl.len = rate;
  cvar_set("v_gamma",  graphics_gamma_lbl.label);
  graphics_gamma_less.drawme = TRUE;
  
};
void() click_gamma_dn={
  local float rate;
  rate = graphics_gamma_lbl.len;
  rate = rate - 0.062;
  if(rate <= 1){
    rate = 1;
    graphics_gamma_less.drawme = FALSE;
  }
  strunzone(graphics_gamma_lbl.label);
  graphics_gamma_lbl.label = strzone(sprintf("%0.3f", rate));
  graphics_gamma_lbl.len = rate;
  cvar_set("v_gamma",  graphics_gamma_lbl.label);
  graphics_gamma_more.drawme = TRUE;
  
};

void() click_graphics_back={
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_graphics_accept={
  if( gettime() < ACCEPT_TIMER ){
    return;
  }
  ACCEPT_TIMER = gettime() + ACCEPT_PAUSE;
  
  cvar_set("vid_bitsperpixel", graphics_bits_lbl.label);
  cvar_set("vid_samples", graphics_aa_lbl.label);
  if(graphics_refreshieldRate_lbl.label != "OFF"){
    cvar_set("vid_userefreshrate", ftos(graphics_refresh_lbl.len));
    cvar_set("vid_refreshrate", ftos(graphics_refreshieldRate_lbl.len));
  }
  else{
    cvar_set("vid_userefreshrate", ftos(0));
    cvar_set("vid_refreshrate", ftos(0));
  }
  cvar_set("vid_fullscreen", ftos(graphics_fullscreen_lbl.len));
  cvar_set("vid_vsync", ftos(graphics_vsync_lbl.len));
  cvar_set("gl_texture_anisotropy", ftos(graphics_aniso_lbl.len));
  cvar_set("gl_picmip", ftos(graphics_texture_quality_lbl.len));
  cvar_set("gl_texturecompression", ftos(graphics_texture_compress_lbl.len));
  if(VID_NEXT != '0 0 0'){
    cvar_set("vid_width", ftos(VID_NEXT_x));
    cvar_set("vid_height", ftos(VID_NEXT_y));
    cvar_set("vid_pixelheight", ftos(VID_NEXT_z));
    
    cvar_set("vid_conwidth", ftos(VID_CNEXT_x));
    cvar_set("vid_conheight", ftos(VID_CNEXT_y));
  }
  cvar_set("saved1", ftos(graphics_effects_lbl.len));
  cvar_set("saved2", ftos(graphics_gfx_lbl.len));
  
  cmd("saveconfig\n");
  cmd("loadconfig\n");
  cmd("vid_restart\n");
};

// ini function, called by '_f' function as a setup func
void() m_graphics_i={
  graphics_title = lbl_img('10 25', '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, (UI_FLAG_SIZE_IMG) );
  
  //resolution
  local float vid;
  vid = menu_getvideo_modeid(VIEW_MAX); 
  local string reso;
  reso = strcat(ftos(VIEW_ACT_x), " x ", ftos(VIEW_ACT_y) );
  graphics_resolution_lbl = lbl_text('150 102', '14 14 0', strzone(reso), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_resolution_lbl.len = vid;
  graphics_resolution_more = btn_img_callback('240 101 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_resolution_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_resolution_less = btn_img_callback('140 101 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_resolution_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  //new resolution  
  graphics_resolution_aspect_lbl = lbl_text('150 121', '10 10 0', strzone(VID_RESO_NAME[vid]), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  
  //bits
  graphics_bits_lbl = lbl_text('150 142', '14 14 0', strzone(ftos(cvar("vid_bitsperpixel"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_bits_more = btn_img_callback('165 142 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_bits_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_bits_less = btn_img_callback('140 142 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_bits_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_bits_lbl.label == "32"){
    graphics_bits_more.drawme = FALSE;
  }
  else{
    graphics_bits_less.drawme = FALSE;
  }
  
  //anti-alias
  graphics_aa_lbl = lbl_text('150 162', '14 14 0', strzone(ftos(cvar("vid_samples"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_aa_lbl.len = cvar("vid_samples");
  graphics_aa_more = btn_img_callback('165 162 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aa_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_aa_less = btn_img_callback('140 162 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aa_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_aa_lbl.len >= 32){
    graphics_aa_lbl.len = 16;
    graphics_aa_more.drawme = FALSE;
  }
  else if(graphics_aa_lbl.len <= 1){
    graphics_aa_lbl.len = 1;
    graphics_aa_less.drawme = FALSE;
  }
  
  //refresh
  graphics_refresh_lbl = lbl_text('150 182', '14 14 0', ftos(cvar("vid_userefreshrate")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_refresh_on = btn_img_callback('175 182 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refresh_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_refresh_off = btn_img_callback('140 182 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refresh_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_refresh_lbl.label == "0"){
    graphics_refresh_lbl.label = strzone("OFF");
    graphics_refresh_off.drawme = FALSE;
  }
  else if(graphics_refresh_lbl.label == "1"){
    graphics_refresh_lbl.label = strzone("ON");
    graphics_refresh_on.drawme = FALSE;
  }
  
  graphics_refreshieldRate_lbl = lbl_text('150 202', '14 14 0', ftos(cvar("vid_refreshrate")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_refreshieldRate_up = btn_img_callback('175 202 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refreshieldRate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_refreshieldRate_dn = btn_img_callback('140 202 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refreshieldRate_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_refresh_lbl.label == "OFF"){
    graphics_refreshieldRate_lbl.len = 0;
    graphics_refreshieldRate_lbl.label = strzone("OFF");
    graphics_refreshieldRate_up.drawme = FALSE;
    graphics_refreshieldRate_dn.drawme = FALSE;
  }
  else{
    graphics_refreshieldRate_lbl.len = stof(graphics_refreshieldRate_lbl.label);
    graphics_refreshieldRate_lbl.label = strzone(graphics_refreshieldRate_lbl.label);
  }
  
  //fullscreen
  graphics_fullscreen_lbl = lbl_text('150 222', '14 14 0', ftos(cvar("vid_fullscreen")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_fullscreen_lbl.len = cvar("vid_fullscreen");
  graphics_fullscreen_on = btn_img_callback('175 222 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_fullscreen_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_fullscreen_off = btn_img_callback('140 222', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_fullscreen_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_fullscreen_lbl.len == FALSE){
    graphics_fullscreen_lbl.label = strzone("OFF");
    graphics_fullscreen_off.drawme = FALSE;
  }
  else if(graphics_fullscreen_lbl.len == TRUE){
    graphics_fullscreen_lbl.label = strzone("ON");
    graphics_fullscreen_on.drawme = FALSE;
  }
  
  //v-sync
  graphics_vsync_lbl = lbl_text('150 242', '14 14 0', ftos(cvar("vid_fullscreen")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_vsync_on = btn_img_callback('175 242 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_vsync_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_vsync_off = btn_img_callback('140 242 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_vsync_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_vsync_lbl.label == "0"){
    graphics_vsync_lbl.len = FALSE;
    graphics_vsync_lbl.label = strzone("OFF");
    graphics_vsync_off.drawme = FALSE;
  }
  else if(graphics_vsync_lbl.label == "1"){
    graphics_vsync_lbl.len = TRUE;
    graphics_vsync_lbl.label = strzone("ON");
    graphics_vsync_on.drawme = FALSE;
  }
  
  //aniso
  graphics_aniso_lbl = lbl_text('150 262', '14 14 0', strzone(ftos(cvar("gl_texture_anisotropy"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_aniso_lbl.len = cvar("gl_texture_anisotropy");
  graphics_aniso_more = btn_img_callback('164 262 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aniso_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_aniso_less = btn_img_callback('140 262 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aniso_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_aniso_lbl.len == 32){
    graphics_aniso_more.drawme = FALSE;
  }
  else if(graphics_aniso_lbl.len == 2){
    graphics_aniso_less.drawme = FALSE;
  }
  
  //texture
  graphics_texture_quality_lbl = lbl_text('150 282', '14 14 0', strzone( graphics_set_texture_quality_label(cvar("gl_picmip"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_texture_quality_lbl.len = cvar("gl_picmip");
  graphics_texture_quality_more = btn_img_callback('238 282 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_quality_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_texture_quality_less = btn_img_callback('140 282 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_quality_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_texture_quality_lbl.len == 0){
    graphics_texture_quality_more.drawme = FALSE;
  }
  else if(graphics_texture_quality_lbl.len == 4){
    graphics_texture_quality_less.drawme = FALSE;
  }

  graphics_texture_compress_lbl = lbl_text('150 302', '14 14 0', ftos(cvar("gl_texturecompression")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_texture_compress_on = btn_img_callback('175 302 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_compression_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_texture_compress_off = btn_img_callback('140 302 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_compression_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_texture_compress_lbl.label == "0"){
    graphics_texture_compress_lbl.len = FALSE;
    graphics_texture_compress_lbl.label = strzone("OFF");
    graphics_texture_compress_off.drawme = FALSE;
  }
  else if(graphics_texture_compress_lbl.label == "1"){
    graphics_texture_compress_lbl.len = TRUE;
    graphics_texture_compress_lbl.label = strzone("ON");
    graphics_texture_compress_on.drawme = FALSE;
  }
  
  //effects settings
  graphics_effects_lbl = lbl_text('345 93', '14 14 0', strzone(graphics_get_detail(cvar("saved1"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_effects_lbl.len = cvar("saved1");
  graphics_effects_more = btn_img_callback('400 93 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_effects_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_effects_less = btn_img_callback('320 93 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_effects_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  //graphics_effects_custom
  graphics_effects_custom = btn_text_callback('320 113 0', '14 14 0', "[Click to Customize]", (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_effects, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  graphics_effects_custom.drawme = FALSE;
  if(graphics_effects_lbl.len == 0){
    graphics_effects_custom.drawme = TRUE;
  }
   
   //gfx / lighting
  graphics_gfx_lbl = lbl_text('345 165', '14 14 0', strzone(graphics_get_gx(cvar("saved2"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_gfx_lbl.len = cvar("saved2");
  graphics_gfx_more = btn_img_callback('400 165 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_light_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_gfx_less = btn_img_callback('320 165 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_light_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
   
  graphics_gfx_custom = btn_text_callback('320 180', '14 14', "[Click to Customize]", (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_gfx, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  graphics_gfx_custom.drawme = FALSE;
  if(graphics_gfx_lbl.len == 0){
    graphics_gfx_custom.drawme = TRUE;
  }
   
  //contrasts
  
  graphics_game_contrast_lbl = lbl_text('360 202', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_game_contrast_lbl.len = cvar("v_contrast");
  graphics_game_contrast_lbl.label = strzone(sprintf("%0.3f", graphics_game_contrast_lbl.len));
  graphics_game_contrast_more = btn_img_callback('400 202', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_contrast_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_game_contrast_less = btn_img_callback('345 202', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_contrast_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_game_contrast_lbl.len >= 4){
    graphics_game_contrast_more.drawme = FALSE;
  }
  else if (graphics_game_contrast_lbl.len <= 1){
    graphics_game_contrast_less.drawme = FALSE;
  }
  
  graphics_gamma_lbl = lbl_text('360 222', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_gamma_lbl.len = cvar("v_gamma");
  graphics_gamma_lbl.label = strzone(sprintf("%0.3f", graphics_gamma_lbl.len));
  graphics_gamma_more = btn_img_callback('400 222', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_gamma_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_gamma_less = btn_img_callback('345 222', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_gamma_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_game_contrast_lbl.len >= 3){
    graphics_gamma_more.drawme = FALSE;
  }
  else if (graphics_game_contrast_lbl.len <= 1){
    graphics_gamma_less.drawme = FALSE;
  }
   
  graphics_back = btn_img_callback('25 322', '56 12', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_back, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_accept = btn_img_callback('285 322', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_accept, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_graphics_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_GRAPHICS;
  setkeydest(KEY_MENU);
  menu_ini_display_constants();
  m_graphics_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_graphics_d={
  local float titleLen;
  local vector titleOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  titleLen = stringwidth( "- Graphics Settings -", 0, '16 16 0' );
  titleOrg_x = gui_percentXRaw( VIEW_CTR_x ) - gui_percentXRaw( titleLen);
  titleOrg_y = gui_percentYRaw( 48 );
  
  gui_renderString("- Graphics Settings -", titleOrg, CLR_DEF_WHITE, '16 16 0', 1, 0);
  
  //display
  gui_renderString("- Display -", gui_percentToPixelRawVec('90 64'), CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
    gui_renderString("Current Resolution:", gui_percentToPixelRawVec('48 83'), CLR_DEF_WHITE, '12 12 0', 1, 0);
      gui_renderString(strcat(ftos(VIEW_ACT_x),"x",ftos(VIEW_ACT_y)), gui_percentToPixelRawVec('150 82'), CLR_DEF_WHITE, '14 14 0', 1, 0);
    gui_renderString("New Resolution:", gui_percentToPixelRawVec('62 103'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Type:", gui_percentToPixelRawVec('110 122'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Bits per pixel:", gui_percentToPixelRawVec('74 142'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Anti-Aliasing:", gui_percentToPixelRawVec('73 162'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Custom Refresh Rate:", gui_percentToPixelRawVec('37 182'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Refresh Rate:", gui_percentToPixelRawVec('74 202'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fullscreen:", gui_percentToPixelRawVec('86 222'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("V-Sync:", gui_percentToPixelRawVec('98 242'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Anisotropic Filter:", gui_percentToPixelRawVec('56 262'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Texture Quality:", gui_percentToPixelRawVec('64 282'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Texture Compression:", gui_percentToPixelRawVec('37 302'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  //effects
  gui_renderString("- Graphical Detail -", gui_percentToPixelRawVec('300 64'), CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
  
  //gfx / lighting
  gui_renderString("- Lighting Detail -", gui_percentToPixelRawVec('300 140'), CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
  
  //contrast
  gui_renderString("Video Contrast:", gui_percentToPixelRawVec('270 202'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  gui_renderString("Video Gamma:", gui_percentToPixelRawVec('273 222'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  drawfont = drawfont_prev;
  
  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_GRAPHICS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_graphics_k={
  //cons_logAFloat("m_graphics_k.key", key);  //DEBUG
  //cons_logAFloat("m_graphics_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};