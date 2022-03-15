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
entity graphics_resolution_change;

entity graphics_resolution_aspect_lbl;


entity graphics_borderless_lbl;
entity graphics_borderless_off;
entity graphics_borderless_on;

entity graphics_bits_lbl;
entity graphics_bits_less;
entity graphics_bits_more;

//vid_samples is...broken I think engine-side.
/*entity graphics_aa_lbl;
entity graphics_aa_more;
entity graphics_aa_less;*/

entity graphics_fxaa_lbl;
entity graphics_fxaa_more;
entity graphics_fxaa_less;

entity graphics_refresh_lbl;
entity graphics_refresh_on;
entity graphics_refresh_off;

entity graphics_refresh_rate_lbl;
entity graphics_refresh_rate_up;
entity graphics_refresh_rate_dn;

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
float options_graphics_submenu;

#define SUB_GRAPHICS_MAIN 1
#define SUB_GRAPHICS_RESO 2

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


void() graphics_reso_back={
  VID_NEXT = '0 0 0';
  VID_CNEXT = '0 0 0';
  
  graphics_resolution_aspect_lbl.len = graphics_resolution_lbl.len = menu_getvideo_modeid();
  
  freeGlobalString(graphics_resolution_lbl.label)
  cacheGlobalString(graphics_resolution_lbl.label, menu_getvideo_clean(graphics_resolution_lbl.len))
  
  freeGlobalString(graphics_resolution_aspect_lbl.label)
  cacheGlobalString(graphics_resolution_aspect_lbl.label, VID_RESO_NAME[graphics_resolution_lbl.len])
};

void(float choice) graphics_reso_menu={
  local entity reso_list, opt_list;

  reso_list = findchainfloat(subid, SUB_GRAPHICS_RESO);
  while(reso_list){
    reso_list.drawme = choice;
    reso_list = reso_list.chain;
  }
  
  if(choice){
    options_graphics_submenu = SUB_GRAPHICS_RESO;
  }
  else{
    options_graphics_submenu = SUB_GRAPHICS_MAIN;
    if(graphics_effects_lbl.len > 0){
      graphics_effects_custom.drawme = FALSE;
    }
    if(graphics_gfx_lbl.len > 0){
      graphics_gfx_custom.drawme = FALSE;
    }
    
  }
  
  opt_list = findchainfloat( subid, SUB_GRAPHICS_MAIN);
  while(opt_list){
    opt_list.drawme = !choice;
    opt_list = opt_list.chain;
  }
};

//graphics callbacks

void() click_graphics_reso_change={

  menu_parent_setup(VIEW_ORG + '0 40', '512 400');
  
  graphics_reso_menu(TRUE);

};

void() click_graphics_reso_select={
  
  menu_parent_setup(VIEW_ORG + '0 40', '448 384');
  
  VID_NEXT = VID_RESO_SIZE[self.len];
  VID_CNEXT = VID_RESO_HALF[self.len];
  
  freeGlobalString(graphics_resolution_lbl.label)
  cacheGlobalString(graphics_resolution_lbl.label, menu_getvideo_clean(self.len) )

  graphics_resolution_lbl.len = self.len;

  freeGlobalString(graphics_resolution_aspect_lbl.label)
  cacheGlobalString(graphics_resolution_aspect_lbl.label,VID_RESO_NAME[self.len] )
  
  graphics_reso_menu(FALSE);
};


void() click_graphics_bits_less={
  graphics_bits_lbl.len = 16;
  graphics_bits_less.drawme = FALSE;
  graphics_bits_more.drawme = TRUE;
};
void() click_graphics_bits_more={
  graphics_bits_lbl.len = 32;
  graphics_bits_less.drawme = TRUE;
  graphics_bits_more.drawme = FALSE;
};

//vid_samples is...broken I think engine-side.
/*void() click_graphics_aa_more={
  local float sampl;
  local float dir;
  
  dir = 1;
  sampl = graphics_aa_lbl.len;
  sampl = bound(1, sampl * (dir > 0 ? 2 : 0.5), 32);
  
  if(sampl >= 32){
    graphics_aa_more.drawme = FALSE;
  }
  if( !graphics_aa_less.drawme ){
    graphics_aa_less.drawme = TRUE;
  }
  graphics_aa_lbl.len = sampl;
};
void() click_graphics_aa_less={
  local float sampl;  local float dir;
  
  dir = -1;
  sampl = graphics_aa_lbl.len;
  sampl = bound(1, sampl * (dir > 0 ? 2 : 0.5), 32);
  
  if(sampl == 1){
    graphics_aa_less.drawme = FALSE;
  }
  if( !graphics_aa_more.drawme ){
    graphics_aa_more.drawme = TRUE;
  }
  graphics_aa_lbl.len = sampl;
};*/

void() click_refresh_on={
  graphics_refresh_lbl.len = TRUE;
  
  graphics_refresh_off.drawme = TRUE;
  graphics_refresh_on.drawme = FALSE;
  
  graphics_refresh_rate_up.drawme = TRUE;
  graphics_refresh_rate_dn.drawme = TRUE;
  graphics_refresh_lbl.color = CLR_DEF_ARM_OK;
  graphics_refresh_rate_lbl.color = CLR_DEF_ARM_OK;
};
void() click_refresh_off={
  graphics_refresh_lbl.len = FALSE;
  
  graphics_refresh_off.drawme = FALSE;
  graphics_refresh_on.drawme = TRUE;
  
  graphics_refresh_rate_up.drawme = FALSE;
  graphics_refresh_rate_dn.drawme = FALSE;
  graphics_refresh_lbl.color = CLR_DEF_GRAY_H;
  graphics_refresh_rate_lbl.color = CLR_DEF_GRAY_H;
};

void() click_refresh_rate_up={
  local float rate;
  rate = graphics_refresh_rate_lbl.len;
  rate = rate + 10;
  if(rate > 120){
    rate = 120;
    graphics_refresh_rate_up.drawme = FALSE;
  }
  graphics_refresh_rate_lbl.len = rate;
  if( !graphics_refresh_rate_dn.drawme ){
    graphics_refresh_rate_dn.drawme = TRUE;
  }
};
void() click_refresh_rate_dn={
  local float rate;
  rate = graphics_refresh_rate_lbl.len;
  rate = rate - 10;
  if(rate < 50){
    rate = 50;
    graphics_refresh_rate_dn.drawme = FALSE;
  }
  graphics_refresh_rate_lbl.len = rate;
  
  if( !graphics_refresh_rate_up.drawme ){
    graphics_refresh_rate_up.drawme = TRUE;
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
  graphics_vsync_lbl.color = CLR_DEF_GRAY_H;
};

void() click_graphics_aniso_more={
  local float sampl;
  sampl = graphics_aniso_lbl.len;
  
  if( sampl == 0 ){
    sampl = 1;
  }
  else{
    sampl = sampl * 2;
  }
  if(sampl >= 32){
    sampl = 32;
    graphics_aniso_more.drawme = FALSE;
  }
  if( !graphics_aniso_less.drawme ){
    graphics_aniso_less.drawme = TRUE;
  }
  graphics_aniso_lbl.len = sampl;
};
void() click_graphics_aniso_less={
  local float sampl;
  
  sampl = graphics_aniso_lbl.len;
  if( sampl > 1){
    sampl = sampl / 2;
  }
  else{
    sampl = 0;
  }
  if(sampl == 0){
    graphics_aniso_less.drawme = FALSE;
  }
  if( !graphics_aniso_more.drawme ){
    graphics_aniso_more.drawme = TRUE;
  }
  graphics_aniso_lbl.len = sampl;
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
  graphics_texture_quality_lbl.label = graphics_set_texture_quality_label(sampl);
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
  graphics_texture_quality_lbl.label =  graphics_set_texture_quality_label(sampl);
};

void() click_graphics_texture_compression_on={
  if(!graphics_texture_compress_lbl.len){
    graphics_texture_compress_lbl.len = TRUE;
    graphics_texture_compress_on.drawme = FALSE;
  }
  if( !graphics_texture_compress_off.drawme ){
    graphics_texture_compress_off.drawme = TRUE;
  }
  graphics_texture_compress_lbl.color = CLR_DEF_ARM_OK;
};
void() click_graphics_texture_compression_off={
  if(graphics_texture_compress_lbl.len){
    graphics_texture_compress_lbl.len = FALSE;
    graphics_texture_compress_off.drawme = FALSE;
  }
  if( !graphics_texture_compress_on.drawme ){
    graphics_texture_compress_on.drawme = TRUE;
  }
  graphics_texture_compress_lbl.color = CLR_DEF_GRAY_H;
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
  graphics_effects_lbl.label = graphics_get_detail(level);
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
  graphics_effects_lbl.label = graphics_get_detail(level);
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
  graphics_gfx_lbl.label = graphics_get_gx(level);
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
  graphics_gfx_lbl.label = graphics_get_gx(level);
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
  cacheGlobalString( graphics_game_contrast_lbl.label, sprintf("%0.3f", rate))
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
  cacheGlobalString( graphics_game_contrast_lbl.label, sprintf("%0.3f", rate))
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
  cacheGlobalString( graphics_gamma_lbl.label, sprintf("%0.3f", rate))
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
  cacheGlobalString( graphics_gamma_lbl.label, sprintf("%0.3f", rate))
  graphics_gamma_lbl.len = rate;
  cvar_set("v_gamma",  graphics_gamma_lbl.label);
  graphics_gamma_more.drawme = TRUE;
  
};

void() click_graphics_borderless_on={
  graphics_borderless_lbl.len = TRUE;
  graphics_borderless_on.drawme = FALSE;
  graphics_borderless_off.drawme = TRUE;
};
void() click_graphics_borderless_off={
  graphics_borderless_lbl.len = FALSE;
  graphics_borderless_on.drawme = TRUE;
  graphics_borderless_off.drawme = FALSE;
};


void() click_graphics_fxaa_more={
  if(graphics_fxaa_lbl.len == 0 ){
    graphics_fxaa_lbl.len = graphics_fxaa_lbl.len + 1;
  }
  else{
    graphics_fxaa_lbl.len = graphics_fxaa_lbl.len * 2;
  }
  
  if( graphics_fxaa_lbl.len > 4 ){
    graphics_fxaa_lbl.len = 8;
    graphics_fxaa_more.drawme = FALSE;
  }
  graphics_fxaa_less.drawme = TRUE;
};
void() click_graphics_fxaa_less={
  if(graphics_fxaa_lbl.len == 1 ){
    graphics_fxaa_lbl.len = graphics_fxaa_lbl.len - 1;
  }
  else{
    graphics_fxaa_lbl.len = rint(graphics_fxaa_lbl.len * 0.5);
  }
  
  if( graphics_fxaa_lbl.len == 0){
    graphics_fxaa_lbl.len = 0;
    graphics_fxaa_less.drawme = FALSE;
  }
  graphics_fxaa_more.drawme = TRUE;
};

void() click_graphics_back={
  
  if(options_graphics_submenu == SUB_GRAPHICS_RESO ){
    graphics_reso_menu(FALSE);
    graphics_reso_back();
    return;
  }

  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_graphics_accept={
  if( gettime() < ACCEPT_TIMER ){
    return;
  }
  ACCEPT_TIMER = gettime() + ACCEPT_PAUSE;
  
  cvar_set("vid_borderless", ftos(graphics_borderless_lbl.len));
  
  cvar_set("r_fxaa", ftos(graphics_fxaa_lbl.len));
  
  cvar_set("vid_bitsperpixel", ftos(graphics_bits_lbl.len));
  
  //vid_samples is...broken I think engine-side.
  //cvar_set("vid_samples", ftos(graphics_aa_lbl.len));
  
  if(graphics_refresh_rate_lbl.len != FALSE){
    cvar_set("vid_userefreshrate", ftos(rint(graphics_refresh_lbl.len)));
    cvar_set("vid_refreshrate", ftos(rint(graphics_refresh_rate_lbl.len)));
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
  cvar_set("saved1", ftos(graphics_effects_lbl.len));
  cvar_set("saved2", ftos(graphics_gfx_lbl.len));
  
  
  if(VID_NEXT != '0 0 0'){
    cvar_set("vid_width", ftos(rint(VID_NEXT_x)));
    cvar_set("vid_height", ftos(rint(VID_NEXT_y)));
    cvar_set("vid_pixelheight", ftos(rint(VID_NEXT_z)));
    cvar_set("vid_conwidthauto", "1"); //enforced
    //cvar_set("vid_conwidth", ftos(rint(VID_CNEXT_x)));
    cvar_set("vid_conheight",ftos(rint(VID_CNEXT_y)));
    VID_NEXT = '0 0 0';
  }
  
  localcmd("saveconfig;\n");
  localcmd("vid_restart;\n");
  RESO_CHANGE = TRUE;
  //apparently also loads autoexec.cfg and .rc
};

// ini function, called by '_f' function as a setup func
void() m_graphics_i={
  local float vid;
  local vector panelSize;
  local float panelCol;
  
  local string vidResName;
  local vector vidResSize;
  local vector vidConsize;
  local float row, col;
  local vector startOrg;
  local float idx;
  local entity reso_list;
  
  panelSize = '448 384';
  panelCol = (panelSize_x - 25) / 5;
  
  options_graphics_submenu = SUB_GRAPHICS_MAIN;
  menu_parent_setup(VIEW_ORG + '0 40', panelSize);
  
  VID_NEXT = '0 0 0'; //initialize this here so its not null;

  graphics_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_SIZE_IMG );
  
  //resolution
  vid = menu_getvideo_modeid();
  vidResName = strcat(ftos(VIEW_ACT_x), " x ", ftos(VIEW_ACT_y) );
  graphics_resolution_lbl = lbl_text(MENU_ORG + '150 82', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  graphics_resolution_lbl.len = vid;
  cacheGlobalString(graphics_resolution_lbl.label, vidResName)
  
  //new resolution  
  graphics_resolution_aspect_lbl = lbl_text(MENU_ORG + '150 102', '10 10', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  cacheGlobalString( graphics_resolution_aspect_lbl.label, VID_RESO_NAME[vid])
  
  graphics_resolution_change = btn_text_callback(graphics_resolution_aspect_lbl.origin + '0 16', '16 16', "Change", 0, M_OPTIONS_GRAPHICS, click_graphics_reso_change, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG );
  graphics_resolution_change.fontId = FONT_NUM_XOLONIUM_BOLD;
  graphics_resolution_change.subid = SUB_GRAPHICS_MAIN;
  
  startOrg = MENU_ORG + '25 125';
  col = 0;
  row = 0;
  for( idx = 1; idx < VID_RESO_TOTAL; idx = idx + 1){
    vidResName = VID_RESO_NAME[idx];
    vidResSize = VID_RESO_SIZE[idx];
    vidConsize = VID_RESO_HALF[idx];
    
    if( vidResSize_x >= 640 && vidResSize_y >= 480 && vidConsize_x >= 640 && vidConsize_y >= 480){
      reso_list = btn_text_callback(startOrg + [col * max(stringwidth(vidResName, 0, '12 12'), panelCol), row * 25], '12 12', "", 0, M_OPTIONS_GRAPHICS, click_graphics_reso_select, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
      reso_list.len = idx;
      reso_list.subid = SUB_GRAPHICS_RESO;
      cacheGlobalString( reso_list.label, vidResName)
      reso_list.fontId = FONT_NUM_ROBOT_REGULAR;
      if( col < (panelSize_x / panelCol) - 1 ){
        col = col + 1;
      }
      else{
        col = 0;
        row = row + 1;
      }
    }
  }
  
  //borderless window
  graphics_borderless_lbl = lbl_text(MENU_ORG + '150 142', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_BOOL_ON);
  graphics_borderless_lbl.len = cvar("vid_borderless");
  
  graphics_borderless_on = btn_img_callback(graphics_borderless_lbl.origin + Vector2(stringwidth("OFF", 0, graphics_borderless_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_borderless_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_borderless_off = btn_img_callback(graphics_borderless_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_borderless_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  
  if(graphics_borderless_lbl.len){
    graphics_borderless_on.drawme = FALSE;
    graphics_borderless_off.drawme = TRUE;
  }
  else{
    graphics_borderless_off.drawme = FALSE;
    graphics_borderless_on.drawme = TRUE;
  }
  
  //FXAA
  graphics_fxaa_lbl = lbl_text(MENU_ORG + '150 162', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
  graphics_fxaa_lbl.len = cvar("r_fxaa");
  graphics_fxaa_more = btn_img_callback(graphics_fxaa_lbl.origin + Vector2(stringwidth(ftos(graphics_fxaa_lbl.len), 0, graphics_fxaa_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_fxaa_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_fxaa_less = btn_img_callback(graphics_fxaa_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_fxaa_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_fxaa_lbl.len >= 8){
    graphics_fxaa_more.drawme = FALSE;
  }
  else{
    graphics_fxaa_less.drawme = FALSE;
  }
  cacheGlobalString(graphics_fxaa_lbl.label, ftos(graphics_fxaa_lbl.len))
  
  
  //bits
  graphics_bits_lbl = lbl_text(MENU_ORG + '150 182', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
  graphics_bits_lbl.len = cvar("vid_bitsperpixel");
  graphics_bits_more = btn_img_callback(graphics_bits_lbl.origin + Vector2(stringwidth(ftos(graphics_bits_lbl.len), 0, graphics_bits_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_bits_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_bits_less = btn_img_callback(graphics_bits_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_bits_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_bits_lbl.len == 32){
    graphics_bits_more.drawme = FALSE;
  }
  else{
    graphics_bits_less.drawme = FALSE;
  }
  
  //anti-alias
  //vid_samples is...broken I think engine-side.
  /*graphics_aa_lbl = lbl_text(MENU_ORG + '150 202', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
  graphics_aa_lbl.len = cvar("vid_samples");
  
  graphics_aa_more = btn_img_callback(graphics_aa_lbl.origin + Vector2(stringwidth("32", 0, graphics_aa_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_aa_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_aa_less = btn_img_callback(graphics_aa_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_aa_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_aa_lbl.len >= 32){
    graphics_aa_lbl.len = 16;
    graphics_aa_more.drawme = FALSE;
  }
  else if(graphics_aa_lbl.len == 0){
    graphics_aa_lbl.len = 0;
    graphics_aa_less.drawme = FALSE;
  }
  cacheGlobalString(graphics_aa_lbl.label, ftos(graphics_aa_lbl.len))*/
  
  //refresh-------------------------------------------
  graphics_refresh_lbl = lbl_text(MENU_ORG + '150 202', '14 14 0', "60", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_BOOL_ON);
  graphics_refresh_lbl.len = cvar("vid_userefreshrate");
  graphics_refresh_on = btn_img_callback(graphics_refresh_lbl.origin + Vector2(stringwidth(graphics_refresh_lbl.label, 0, graphics_refresh_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_refresh_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_refresh_off = btn_img_callback(graphics_refresh_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_refresh_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  graphics_refresh_rate_lbl = lbl_text(MENU_ORG + '150 222', '14 14 0', "60", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
  graphics_refresh_rate_lbl.len =  cvar("vid_refreshrate");
  graphics_refresh_rate_up = btn_img_callback(graphics_refresh_rate_lbl.origin + Vector2(stringwidth(graphics_refresh_rate_lbl.label, 0, graphics_refresh_rate_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_refresh_rate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_refresh_rate_dn = btn_img_callback(graphics_refresh_rate_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_refresh_rate_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_refresh_lbl.len == FALSE){
    graphics_refresh_lbl.color = CLR_DEF_GRAY_H;
    graphics_refresh_rate_lbl.color = CLR_DEF_GRAY_H;
    graphics_refresh_off.drawme = FALSE;
    graphics_refresh_rate_lbl.len = 60;
    graphics_refresh_rate_up.drawme = FALSE;
    graphics_refresh_rate_dn.drawme = FALSE;
  }
  else if(graphics_refresh_lbl.len == TRUE){
    graphics_refresh_lbl.color = CLR_DEF_ARM_OK;
    graphics_refresh_rate_lbl.color = CLR_DEF_ARM_OK;
    graphics_refresh_on.drawme = FALSE;
  }
  
  //fullscreen----------------------------
  graphics_fullscreen_lbl = lbl_text(MENU_ORG + '150 242', '14 14', "OFF", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_BOOL_ON);
  graphics_fullscreen_lbl.len = cvar("vid_fullscreen");
  graphics_fullscreen_on = btn_img_callback(graphics_fullscreen_lbl.origin + Vector2(stringwidth(graphics_fullscreen_lbl.label, 0, graphics_fullscreen_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_fullscreen_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_fullscreen_off = btn_img_callback(graphics_fullscreen_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_fullscreen_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_fullscreen_lbl.len == FALSE){
    graphics_fullscreen_off.drawme = FALSE;
  }
  else if(graphics_fullscreen_lbl.len == TRUE){
    graphics_fullscreen_on.drawme = FALSE;
  }
  
  //v-sync
  graphics_vsync_lbl = lbl_text(MENU_ORG + '150 262', '14 14', "OFF", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_BOOL_ON);
  graphics_vsync_lbl.len = cvar("vid_fullscreen");
  graphics_vsync_on = btn_img_callback(graphics_vsync_lbl.origin + Vector2(stringwidth(graphics_vsync_lbl.label, 0, graphics_vsync_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_vsync_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_vsync_off = btn_img_callback(graphics_vsync_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_vsync_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_vsync_lbl.len == FALSE){
    graphics_vsync_off.drawme = FALSE;
  }
  else if(graphics_vsync_lbl.len == TRUE){
    graphics_vsync_on.drawme = FALSE;
  }
  
  //aniso
  graphics_aniso_lbl = lbl_text(MENU_ORG + '150 282', '14 14', "16", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_USELEN);
  graphics_aniso_lbl.len = cvar("gl_texture_anisotropy");
  graphics_aniso_more = btn_img_callback(graphics_aniso_lbl.origin + Vector2(stringwidth(graphics_aniso_lbl.label, 0, graphics_aniso_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0 , M_OPTIONS_GRAPHICS, click_graphics_aniso_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_aniso_less = btn_img_callback(graphics_aniso_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_aniso_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_aniso_lbl.len == 32){
    graphics_aniso_more.drawme = FALSE;
  }
  else if(graphics_aniso_lbl.len == 0){
    graphics_aniso_less.drawme = FALSE;
  }
  
  //texture
  graphics_texture_quality_lbl = lbl_text(MENU_ORG + '150 302', '14 14', graphics_set_texture_quality_label(cvar("gl_picmip")), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  graphics_texture_quality_lbl.len = cvar("gl_picmip");
  graphics_texture_quality_more = btn_img_callback(graphics_texture_quality_lbl.origin + Vector2(stringwidth(graphics_texture_quality_lbl.label, 0, graphics_texture_quality_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_texture_quality_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_texture_quality_less = btn_img_callback(graphics_texture_quality_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_texture_quality_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_texture_quality_lbl.len == 0){
    graphics_texture_quality_more.drawme = FALSE;
  }
  else if(graphics_texture_quality_lbl.len == 4){
    graphics_texture_quality_less.drawme = FALSE;
  }

  graphics_texture_compress_lbl = lbl_text(MENU_ORG + '150 322', '14 14', "OFF", CLR_DEF_TXT_GRAY_SMOOTH, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, UI_FLAG_LBL_BOOL_ON);
  graphics_texture_compress_lbl.len = cvar("gl_texturecompression");
  graphics_texture_compress_on = btn_img_callback(graphics_texture_compress_lbl.origin + Vector2(stringwidth(graphics_texture_compress_lbl.label, 0, graphics_texture_compress_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_texture_compression_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_texture_compress_off = btn_img_callback(graphics_texture_compress_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_texture_compression_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_texture_compress_lbl.len == FALSE){
    graphics_texture_compress_off.drawme = FALSE;
  }
  else if(graphics_texture_compress_lbl.len == TRUE){
    graphics_texture_compress_on.drawme = FALSE;
  }
  //-----------------------------------------------------------------------
  //effects settings
  graphics_effects_lbl = lbl_text(MENU_ORG + '330 60', '14 14', graphics_get_detail(cvar("saved1")), CLR_DEF_WHITE,VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  graphics_effects_lbl.len = cvar("saved1");
  graphics_effects_more = btn_img_callback(graphics_effects_lbl.origin + Vector2(stringwidth("MEDIUM", 0, graphics_effects_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_effects_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_effects_less = btn_img_callback(graphics_effects_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_effects_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  //graphics_effects_custom
  graphics_effects_custom = btn_text_callback(MENU_ORG + '300 80', '14 14', "[Click to Customize]", 0, M_OPTIONS_GRAPHICS, click_graphics_effects, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  graphics_effects_custom.drawme = FALSE;
  if(graphics_effects_lbl.len == 0){
    graphics_effects_custom.drawme = TRUE;
  }
  
  //gfx / lighting
  graphics_gfx_lbl = lbl_text(MENU_ORG + '330 160', '14 14', graphics_get_gx(cvar("saved2")), CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  graphics_gfx_lbl.len = cvar("saved2");
  graphics_gfx_more = btn_img_callback(graphics_gfx_lbl.origin + Vector2(stringwidth("MEDIUM", 0, graphics_gfx_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_graphics_light_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_gfx_less = btn_img_callback(graphics_gfx_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_graphics_light_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
   
  graphics_gfx_custom = btn_text_callback(MENU_ORG + '300 180', '14 14', "[Click to Customize]", 0, M_OPTIONS_GRAPHICS, click_graphics_gfx, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  graphics_gfx_custom.drawme = FALSE;
  if(graphics_gfx_lbl.len == 0){
    graphics_gfx_custom.drawme = TRUE;
  }
   
  //contrasts
  
  graphics_game_contrast_lbl = lbl_text(MENU_ORG + '360 230', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  graphics_game_contrast_lbl.len = cvar("v_contrast");
  
  cacheGlobalString( graphics_game_contrast_lbl.label, sprintf("%0.3f", graphics_game_contrast_lbl.len))
  
  graphics_game_contrast_more = btn_img_callback(graphics_game_contrast_lbl.origin + Vector2(stringwidth(graphics_game_contrast_lbl.label, 0, graphics_game_contrast_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_contrast_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_game_contrast_less = btn_img_callback(graphics_game_contrast_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_contrast_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_game_contrast_lbl.len >= 4){
    graphics_game_contrast_more.drawme = FALSE;
  }
  else if (graphics_game_contrast_lbl.len <= 1){
    graphics_game_contrast_less.drawme = FALSE;
  }
  
  graphics_gamma_lbl = lbl_text(MENU_ORG + '360 250', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_GRAPHICS, 1, 0);
  graphics_gamma_lbl.len = cvar("v_gamma");
  
  cacheGlobalString( graphics_gamma_lbl.label, sprintf("%0.3f", graphics_gamma_lbl.len))
  
  graphics_gamma_more = btn_img_callback(graphics_gamma_lbl.origin + Vector2(stringwidth(graphics_gamma_lbl.label, 0, graphics_gamma_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_GRAPHICS, click_gamma_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_gamma_less = btn_img_callback(graphics_gamma_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_GRAPHICS, click_gamma_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_game_contrast_lbl.len >= 3){
    graphics_gamma_more.drawme = FALSE;
  }
  else if (graphics_game_contrast_lbl.len <= 1){
    graphics_gamma_less.drawme = FALSE;
  }
  
  graphics_back = btn_text_callback(MENU_ORG + '45 365', '16 16', "BACK", VIEW_CTX, M_OPTIONS_GRAPHICS, click_graphics_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  graphics_back.fontId = FONT_NUM_XOLONIUM_BOLD;

  graphics_accept = btn_text_callback(MENU_ORG + '285 365', '16 16', "ACCEPT", VIEW_CTX, M_OPTIONS_GRAPHICS, click_graphics_accept, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  graphics_accept.fontId = FONT_NUM_XOLONIUM_BOLD;
  graphics_accept.subid = SUB_GRAPHICS_MAIN;
  
  //assign sub menu
  graphics_resolution_change.subid = SUB_GRAPHICS_MAIN;
  
  graphics_borderless_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_borderless_on.subid = SUB_GRAPHICS_MAIN;
  graphics_borderless_off.subid = SUB_GRAPHICS_MAIN;
  
  graphics_fxaa_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_fxaa_more.subid = SUB_GRAPHICS_MAIN;
  graphics_fxaa_less.subid = SUB_GRAPHICS_MAIN;
  
  graphics_bits_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_bits_less.subid = SUB_GRAPHICS_MAIN;
  graphics_bits_more.subid = SUB_GRAPHICS_MAIN;
  
  /*graphics_aa_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_aa_more.subid = SUB_GRAPHICS_MAIN;
  graphics_aa_less.subid = SUB_GRAPHICS_MAIN;*/
  
  graphics_refresh_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_refresh_on.subid = SUB_GRAPHICS_MAIN;
  graphics_refresh_off.subid = SUB_GRAPHICS_MAIN;
  
  graphics_refresh_rate_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_refresh_rate_up.subid = SUB_GRAPHICS_MAIN;
  graphics_refresh_rate_dn.subid = SUB_GRAPHICS_MAIN;
  
  graphics_fullscreen_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_fullscreen_on.subid = SUB_GRAPHICS_MAIN;
  graphics_fullscreen_off.subid = SUB_GRAPHICS_MAIN;
  
  graphics_vsync_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_vsync_on.subid = SUB_GRAPHICS_MAIN;
  graphics_vsync_off.subid = SUB_GRAPHICS_MAIN;
  
  graphics_aniso_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_aniso_more.subid = SUB_GRAPHICS_MAIN;
  graphics_aniso_less.subid = SUB_GRAPHICS_MAIN;
  
  graphics_texture_quality_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_texture_quality_more.subid = SUB_GRAPHICS_MAIN;
  graphics_texture_quality_less.subid = SUB_GRAPHICS_MAIN;
  
  graphics_texture_compress_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_texture_compress_on.subid = SUB_GRAPHICS_MAIN;
  graphics_texture_compress_off.subid = SUB_GRAPHICS_MAIN;
  
  graphics_effects_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_effects_more.subid = SUB_GRAPHICS_MAIN;
  graphics_effects_less.subid = SUB_GRAPHICS_MAIN;
  graphics_effects_custom.subid = SUB_GRAPHICS_MAIN;
  
  graphics_gfx_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_gfx_more.subid = SUB_GRAPHICS_MAIN;
  graphics_gfx_less.subid = SUB_GRAPHICS_MAIN;
  graphics_gfx_custom.subid = SUB_GRAPHICS_MAIN;
  
  graphics_game_contrast_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_game_contrast_more.subid = SUB_GRAPHICS_MAIN;
  graphics_game_contrast_less.subid = SUB_GRAPHICS_MAIN;
  
  graphics_gamma_lbl.subid = SUB_GRAPHICS_MAIN;
  graphics_gamma_more.subid = SUB_GRAPHICS_MAIN;
  graphics_gamma_less.subid = SUB_GRAPHICS_MAIN;
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
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_LIGHT;
  
  //display
  gui_renderString("Display", MENU_ORG + '90 40', CLR_DEF_ARM_THREEQ, '16 16', 1, 0);
    
    gui_renderString("Current Resolution:", MENU_ORG + '36 60', CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
      gui_renderString(strcat(ftos(VIEW_ACT_x),"x",ftos(VIEW_ACT_y)), MENU_ORG + '150 60', CLR_DEF_WHITE, '14 14', 1, 0);
    
    gui_renderString("New Resolution:", graphics_resolution_lbl.origin - Vector2(stringwidth("Current Resolution:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Type:", graphics_resolution_aspect_lbl.origin - Vector2(stringwidth("Type:    ", 0, '12 12'),2), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
  if( options_graphics_submenu == SUB_GRAPHICS_MAIN ){
    gui_renderString("Borderless Window:", graphics_borderless_off.origin - Vector2(stringwidth("Borderless Window:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Anti-aliasing (FXAA)", graphics_fxaa_less.origin - Vector2(stringwidth("Anti-aliasing (FXAA):  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Bits per pixel:", graphics_bits_less.origin - Vector2(stringwidth("Bits per pixel:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    //vid_samples is...broken I think engine-side.
    //gui_renderString("Anti-Aliasing:", graphics_aa_less.origin - Vector2(stringwidth("Anti-Aliasing:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Custom Refresh Rate:", graphics_refresh_off.origin - Vector2(stringwidth("Custom Refresh Rate:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Refresh Rate:", graphics_refresh_rate_dn.origin - Vector2(stringwidth("Refresh Rate:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Fullscreen:", graphics_fullscreen_off.origin - Vector2(stringwidth("Fullscreen:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("V-Sync:", graphics_vsync_off.origin - Vector2(stringwidth("V-Sync:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Anisotropic Filter:", graphics_aniso_less.origin - Vector2(stringwidth("Anisotropic Filter:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Texture Quality:", graphics_texture_quality_less.origin - Vector2(stringwidth("Texture Quality:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
    
    gui_renderString("Texture Compression:", graphics_texture_compress_off.origin - Vector2(stringwidth("Texture Compression:  ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12', 1, 0);
  
  //effects
  gui_renderString("Particle Details", MENU_ORG + '300 40', CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
  
  //gfx / lighting
  gui_renderString("Lighting Detail", MENU_ORG + '300 140', CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
  
  //contrast
  gui_renderString("Video Contrast:", graphics_game_contrast_less.origin - Vector2(stringwidth("Video Contrast:    ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12 0', 1, 0);
  gui_renderString("Video Gamma:", graphics_gamma_less.origin - Vector2(stringwidth("Video Contrast:    ", 0, '12 12'),0), CLR_DEF_TXT_NONSELECT, '12 12 0', 1, 0);
  }
  drawfont = drawfont_prev;
  
  local entity widget;
  
  
  widget = findchainfloat(menuId, M_OPTIONS_GRAPHICS);
  while(widget){
    if( widget.subid == FALSE){
      widget.draw(widget);
    }    
    else if( widget.subid == options_graphics_submenu){
      widget.draw(widget);
    }
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_graphics_k={
  //cons_logAFloat("m_graphics_k.key", key);  //DEBUG
  //cons_logAFloat("m_graphics_k.ascii", ascii);  //DEBUG   
  
  if(key == K_ESCAPE){
    localsound("sound/misc/menu2.wav");
    if(options_graphics_submenu == SUB_GRAPHICS_RESO ){
      graphics_reso_menu(FALSE);
      graphics_reso_back();
      return;
    }
    
    menu_clear_items(M_STATE);
    M_STATE = M_OPTIONS;
    m_options_f();
  }
};