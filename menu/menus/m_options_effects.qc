/*
battleMETAL
Author: Peter Roohr
Date: 4/19/2018
mod: 07/20/2019
Overview: 
  Graphical Details settings
*/
//effects Globals
entity effects_title;
entity effects_particles_lbl;
entity effects_particles_on;
entity effects_particles_off;

entity effects_particles_quality_lbl;
entity effects_particles_quality_more;
entity effects_particles_quality_less;

entity effects_decals_select_lbl;
entity effects_decals_select_next;
entity effects_decals_select_prev;

entity effects_bullet_impact_lbl;
entity effects_bullet_impact_on;
entity effects_bullet_impact_off;

entity effects_smoke_lbl;
entity effects_smoke_on;
entity effects_smoke_off;

entity effects_sparks_lbl;
entity effects_sparks_on;
entity effects_sparks_off;

entity effects_bubbles_lbl;
entity effects_bubbles_on;
entity effects_bubbles_off;

entity effects_rain_lbl;
entity effects_rain_on;
entity effects_rain_off;
  
entity effects_snow_lbl;
entity effects_snow_on;
entity effects_snow_off;

entity effects_model_interpol_lbl;
entity effects_model_interpol_on;
entity effects_model_interpol_off;

entity effects_sprite_interpol_lbl;
entity effects_sprite_interpol_on;
entity effects_sprite_interpol_off;

entity effects_flicker_interpol_lbl;
entity effects_flicker_interpol_on;
entity effects_flicker_interpol_off;

entity effects_back;
entity effects_save;

//effects constants
string(float val) effects_particle_quality_get={
  local string lbl;
  switch(val){
    case 0:
      lbl = "LOW";
      break;
    case 1:
      lbl = "MEDIUM";
      break;
    case 2:
      lbl = "HIGH";
      break;
    case 3:
      lbl = "SUPER";
      break;
  }
  return lbl;
};

float() effects_particle_quality_get_val={
  local float qk, qy, val;
  qk = cvar("cl_particles_quake");
  qy = cvar("cl_particles_quality");
  val = 0;
  if( qk && (qy == 1) ){
    val =  0;
  }
  if( !qk && (qy >= 2)){
    val = 1;
  }
  if( !qk && (qy >= 4)){
    val = 2;
  }
  if( !qk && (qy >= 6)){
    val = 3;
  }
  return val;
};

string(float val) effects_decals_mode_select={
  local string lbl;
  switch(val){
    case 0:
      lbl = "OFF";
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

float() effects_decals_get_val={
  local float mode, st, dc;
  st = cvar("cl_stainmaps"); 
  dc = cvar("cl_decals");
  
  if( !st && !dc ){
    mode = 0;
  }
  if( st && !dc ){
    mode = 1;
  }
  if( !st && dc ){
    mode = 2;
  }
  if( st && dc ){
    mode = 3;
  }
  return mode;
};

void(float select) effects_particle_setcvar={
  switch(select){
    case 0:
      cvar_set("cl_particles_quake", "1");
      cvar_set("cl_particles_quality", "1");
      break;
    case 1:
      cvar_set("cl_particles_quake", "0");
      cvar_set("cl_particles_quality", "2");
      break;
    case 2:
      cvar_set("cl_particles_quake", "0");
      cvar_set("cl_particles_quality", "4");
      break;
    case 3:
      cvar_set("cl_particles_quake", "0");
      cvar_set("cl_particles_quality", "6");
      break;
  }
};

void(float select) effects_decals_setcvar={
  switch(select){
    case 0:
      cvar_set("cl_stainmaps", "0");
      cvar_set("cl_decals", "0");
      break;
    case 1:
      cvar_set("cl_stainmaps", "1");
      cvar_set("cl_stainmaps_clearonload", "1");
      cvar_set("cl_decals", "0");
      break;
    case 2:
      cvar_set("cl_stainmaps", "0");
      cvar_set("cl_decals", "1");
      cvar_set("cl_decals_fadetime", "1");
      cvar_set("cl_decals_max", "2048");
      cvar_set("cl_decals_time", "20");
      break;
    case 3:
      cvar_set("cl_stainmaps", "1");
      cvar_set("cl_stainmaps_clearonload", "1");
      cvar_set("cl_decals", "1");
      cvar_set("cl_decals_fadetime", "30");
      cvar_set("cl_decals_max", "4096");
      cvar_set("cl_decals_models", "1");
      cvar_set("cl_decals_newsystem", "1");
      cvar_set("cl_decals_time", "40");
      break;
  }
};

//effects callbacks
void() click_effects_particles_on={
  effects_particles_lbl.len = 1;
  
  effects_particles_on.drawme = FALSE;
  effects_particles_off.drawme = TRUE;
  effects_particles_quality_lbl.drawme = TRUE;
  effects_particles_quality_more.drawme = TRUE;
  effects_particles_quality_less.drawme = TRUE;
  effects_particles_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_particles_off={
  effects_particles_lbl.len = 0;
  
  effects_particles_on.drawme = TRUE;
  effects_particles_off.drawme = FALSE;
  effects_particles_quality_lbl.drawme = FALSE;
  effects_particles_quality_more.drawme = FALSE;
  effects_particles_quality_less.drawme = FALSE;
  effects_particles_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effets_particles_quality_more={
  local float level;
  level = effects_particles_quality_lbl.len;
  level = level + 1;
  if(level >= 3){
    level = 3;
    effects_particles_quality_more.drawme = FALSE;
  }
  effects_particles_quality_lbl.len = level;
  effects_particles_quality_less.drawme = TRUE;
  effects_particles_quality_lbl.label = effects_particle_quality_get(effects_particles_quality_lbl.len);
};
void() click_effets_particles_quality_less={
  local float level;
  level = effects_particles_quality_lbl.len;
  level = level - 1;
  if(level <= 0){
    level = 0;
    effects_particles_quality_less.drawme = FALSE;
  }
  effects_particles_quality_lbl.len = level;
  effects_particles_quality_more.drawme = TRUE;
  effects_particles_quality_lbl.label = effects_particle_quality_get(effects_particles_quality_lbl.len);
};

//Decal sub menu
void() click_decals_select_next={
  local float select;
  select = effects_decals_select_lbl.len;
  select = select + 1;
  if(select >= 3){
    select = 3;
    effects_decals_select_next.drawme = FALSE;
  }
  effects_decals_select_lbl.len = select;
  effects_decals_select_prev.drawme = TRUE;
  effects_decals_select_lbl.label = effects_decals_mode_select(effects_decals_select_lbl.len);
};
void() click_decals_select_prev={
  local float select;
  select = effects_decals_select_lbl.len;
  select = select - 1;
  if(select <= 0){
    select = 0;
    effects_decals_select_prev.drawme = FALSE;
  }
  effects_decals_select_lbl.len = select;
  effects_decals_select_next.drawme = TRUE;
  effects_decals_select_lbl.label = effects_decals_mode_select(effects_decals_select_lbl.len);
};

void() click_effects_bulletimpact_on={
  effects_bullet_impact_lbl.len = 1;
  effects_bullet_impact_on.drawme = FALSE;
  effects_bullet_impact_off.drawme = TRUE;
  effects_bullet_impact_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_bulletimpact_off={
  effects_bullet_impact_lbl.len = 0;
  effects_bullet_impact_on.drawme = TRUE;
  effects_bullet_impact_off.drawme = FALSE;
  effects_bullet_impact_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_smoke_on={
  effects_smoke_lbl.len = 1;
  effects_smoke_on.drawme = FALSE;
  effects_smoke_off.drawme = TRUE;
  effects_smoke_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_smoke_off={
  effects_smoke_lbl.len = 0;
  effects_smoke_on.drawme = TRUE;
  effects_smoke_off.drawme = FALSE;
  effects_smoke_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_sparks_on={
  effects_sparks_lbl.len = 1;
  effects_sparks_on.drawme = FALSE;
  effects_sparks_off.drawme = TRUE;
  effects_sparks_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_sparks_off={
  effects_sparks_lbl.len = 0;
  effects_sparks_on.drawme = TRUE;
  effects_sparks_off.drawme = FALSE;
  effects_sparks_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_bubbles_on={
  effects_bubbles_lbl.len = 1;
  effects_bubbles_on.drawme = FALSE;
  effects_bubbles_off.drawme = TRUE;
  effects_bubbles_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_bubbles_off={
  effects_bubbles_lbl.len = 0;
  effects_bubbles_on.drawme = TRUE;
  effects_bubbles_off.drawme = FALSE;
  effects_bubbles_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_rain_on={
  effects_rain_lbl.len = 1;
  effects_rain_on.drawme = FALSE;
  effects_rain_off.drawme = TRUE;
  effects_rain_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_rain_off={
  effects_rain_lbl.len = 0;
  effects_rain_on.drawme = TRUE;
  effects_rain_off.drawme = FALSE;
  effects_rain_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_snow_on={
  effects_snow_lbl.len = 1;
  effects_snow_on.drawme = FALSE;
  effects_snow_off.drawme = TRUE;
  effects_snow_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_snow_off={
  effects_snow_lbl.len = 0;
  effects_snow_on.drawme = TRUE;
  effects_snow_off.drawme = FALSE;
  effects_snow_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_interpol_model_on={
  effects_model_interpol_lbl.len = 1;
  effects_model_interpol_on.drawme = FALSE;
  effects_model_interpol_off.drawme = TRUE;
  effects_model_interpol_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_interpol_model_off={
  effects_model_interpol_lbl.len = 0;
  effects_model_interpol_on.drawme = TRUE;
  effects_model_interpol_off.drawme = FALSE;
  effects_model_interpol_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_interpol_sprite_on={
  effects_sprite_interpol_lbl.len = 1;
  effects_sprite_interpol_on.drawme = FALSE;
  effects_sprite_interpol_off.drawme = TRUE;
  effects_sprite_interpol_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_interpol_sprite_off={
  effects_sprite_interpol_lbl.len = 0;
  effects_sprite_interpol_on.drawme = TRUE;
  effects_sprite_interpol_off.drawme = FALSE;
  effects_sprite_interpol_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_interpol_flicker_on={
  effects_flicker_interpol_lbl.len = 1;
  effects_flicker_interpol_on.drawme = FALSE;
  effects_flicker_interpol_off.drawme = TRUE;
  effects_flicker_interpol_lbl.color = CLR_DEF_ARM_OK;
};
void() click_effects_interpol_flicker_off={
  effects_flicker_interpol_lbl.len = 0;
  effects_flicker_interpol_on.drawme = TRUE;
  effects_flicker_interpol_off.drawme = FALSE;
  effects_flicker_interpol_lbl.color = CLR_DEF_GRAY_H;
};

void() click_effects_back{
  menu_clear_items(M_STATE);
  m_graphics_f();
};

void() click_effects_save={
  cvar_set("cl_particles", ftos(effects_particles_lbl.len));
  if( ftos(effects_particles_lbl.len) ){
    effects_particle_setcvar(effects_particles_quality_lbl.len);
  }
  else{
    cvar_set("cl_particles_quake", "0");
    cvar_set("cl_particles_quality", "0");
  }
  effects_decals_setcvar(effects_decals_select_lbl.len);
  cvar_set("cl_particles_bulletimpacts", ftos(effects_bullet_impact_lbl.len));
  cvar_set("cl_particles_smoke", ftos(effects_smoke_lbl.len));
  cvar_set("cl_particles_sparks", ftos(effects_sparks_lbl.len));
  cvar_set("cl_particles_bubbles", ftos(effects_bubbles_lbl.len));
  cvar_set("cl_particles_rain", ftos(effects_rain_lbl.len));
  cvar_set("cl_particles_snow", ftos(effects_snow_lbl.len));
  cvar_set("r_lerpmodels", ftos(effects_model_interpol_lbl.len));
  cvar_set("r_lerpsprites", ftos(effects_sprite_interpol_lbl.len));
  cvar_set("r_lerplightstyles", ftos(effects_flicker_interpol_lbl.len));
  cvar_set("saved1", "0");
  localcmd("saveconfig\n");
  menu_clear_items(M_STATE);
  m_graphics_f();
};

// ini function, called by '_f' function as a setup func
void() m_effects_i={
  
  menu_parent_setup(VIEW_ORG + '0 40', '240 352');
  
  effects_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_SIZE_IMG );
  
  //particles
  effects_particles_lbl = lbl_text( MENU_ORG + '150 63', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
    effects_particles_lbl.len = cvar("cl_particles");
  effects_particles_on = btn_img_callback(effects_particles_lbl.origin + Vector2(stringwidth("OFF", 0, effects_particles_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_particles_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_particles_off = btn_img_callback(effects_particles_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_particles_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  effects_particles_quality_lbl = lbl_text(MENU_ORG + '150 83', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, 0);
    effects_particles_quality_lbl.len = effects_particle_quality_get_val();
    effects_particles_quality_lbl.label = effects_particle_quality_get(effects_particles_quality_lbl.len);
  
  effects_particles_quality_more = btn_img_callback(effects_particles_quality_lbl.origin + Vector2(stringwidth("MEDIUM", 0, effects_particles_quality_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effets_particles_quality_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_particles_quality_less = btn_img_callback(effects_particles_quality_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effets_particles_quality_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(cvar("cl_particles")){
    effects_particles_on.drawme = FALSE;
    effects_particles_lbl.color = CLR_DEF_ARM_OK;
    if(effects_particles_quality_lbl.len > 0){
      effects_particles_quality_less.drawme = FALSE;
    }
    else if(effects_particles_quality_lbl.len >= 6){
      effects_particles_quality_more.drawme = FALSE;
    }
  }
  else{
    effects_particles_off.drawme = FALSE;
    effects_particles_quality_lbl.drawme = FALSE;
    effects_particles_quality_more.drawme = FALSE;
    effects_particles_quality_less.drawme = FALSE;
    effects_particles_lbl.color = CLR_DEF_GRAY_H;
  }

  //decals
  effects_decals_select_lbl = lbl_text(MENU_ORG + '150 103', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, 0);
  effects_decals_select_lbl.len = effects_decals_get_val();
  effects_decals_select_lbl.label = effects_decals_mode_select(effects_decals_select_lbl.len);
  
  effects_decals_select_next = btn_img_callback(effects_decals_select_lbl.origin + Vector2(stringwidth("MEDIUM", 0, effects_decals_select_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_decals_select_next, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_decals_select_prev = btn_img_callback(effects_decals_select_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_decals_select_prev, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_decals_select_lbl.len == 0){
    effects_decals_select_prev.drawme = FALSE;
  }
  else if(effects_decals_select_lbl.len == 3){
    effects_decals_select_next.drawme = FALSE;
  }
  
  //Bullet impact options
  effects_bullet_impact_lbl = lbl_text(MENU_ORG + '150 123', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_bullet_impact_lbl.len = cvar("cl_particles_bulletimpacts");
  effects_bullet_impact_on = btn_img_callback(effects_bullet_impact_lbl.origin + Vector2(stringwidth("OFF", 0, effects_bullet_impact_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_bulletimpact_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_bullet_impact_off = btn_img_callback(effects_bullet_impact_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_bulletimpact_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_bullet_impact_lbl.len){
    effects_bullet_impact_on.drawme = FALSE;
    effects_bullet_impact_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_bullet_impact_off.drawme = FALSE;
    effects_bullet_impact_lbl.color = CLR_DEF_GRAY_H;
  }
  
  //Smoke options
  effects_smoke_lbl = lbl_text(MENU_ORG + '150 143', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_smoke_lbl.len = cvar("cl_particles_smoke");
  effects_smoke_on = btn_img_callback(effects_smoke_lbl.origin + Vector2(stringwidth("OFF", 0, effects_smoke_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_smoke_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_smoke_off = btn_img_callback(effects_smoke_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_smoke_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_smoke_lbl.len){
    effects_smoke_on.drawme = FALSE;
    effects_smoke_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_smoke_off.drawme = FALSE;
    effects_smoke_lbl.color = CLR_DEF_GRAY_H;
  }

  //Sparks options
  effects_sparks_lbl = lbl_text(MENU_ORG + '150 163', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_sparks_lbl.len = cvar("cl_particles_sparks");
  effects_sparks_on = btn_img_callback(effects_sparks_lbl.origin + Vector2(stringwidth("OFF", 0, effects_sparks_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_sparks_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_sparks_off = btn_img_callback(effects_sparks_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_sparks_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_sparks_lbl.len){
    effects_sparks_on.drawme = FALSE;
    effects_sparks_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_sparks_off.drawme = FALSE;
    effects_sparks_lbl.color = CLR_DEF_GRAY_H;
  }

  //bubble options
  effects_bubbles_lbl = lbl_text(MENU_ORG + '150 183', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_bubbles_lbl.len = cvar("cl_particles_bubbles");
  effects_bubbles_on = btn_img_callback(effects_bubbles_lbl.origin + Vector2(stringwidth("OFF", 0, effects_bubbles_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_bubbles_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_bubbles_off = btn_img_callback(effects_bubbles_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_bubbles_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_bubbles_lbl.len){
    effects_bubbles_on.drawme = FALSE;
    effects_bubbles_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_bubbles_off.drawme = FALSE;
    effects_bubbles_lbl.color = CLR_DEF_GRAY_H;
  }

  //rain options
  effects_rain_lbl = lbl_text(MENU_ORG + '150 203', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_rain_lbl.len = cvar("cl_particles_rain");
  effects_rain_on = btn_img_callback(effects_rain_lbl.origin + Vector2(stringwidth("OFF", 0, effects_rain_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_rain_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_rain_off = btn_img_callback(effects_rain_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_rain_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_rain_lbl.len){
    effects_rain_on.drawme = FALSE;
    effects_rain_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_rain_off.drawme = FALSE;
    effects_rain_lbl.color = CLR_DEF_GRAY_H;
  }
  
  //rain options
  effects_snow_lbl = lbl_text(MENU_ORG + '150 223', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_snow_lbl.len = cvar("cl_particles_snow");
  effects_snow_on = btn_img_callback(effects_snow_lbl.origin + Vector2(stringwidth("OFF", 0, effects_snow_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_snow_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_snow_off = btn_img_callback(effects_snow_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_snow_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_snow_lbl.len){
    effects_snow_on.drawme = FALSE;
    effects_snow_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_snow_off.drawme = FALSE;
    effects_snow_lbl.color = CLR_DEF_GRAY_H;
  }
  
  //animation
  effects_model_interpol_lbl = lbl_text(MENU_ORG + '150 243', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_model_interpol_lbl.len = cvar("r_lerpmodels");
  effects_model_interpol_on = btn_img_callback(effects_model_interpol_lbl.origin + Vector2(stringwidth("OFF", 0, effects_model_interpol_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_interpol_model_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_model_interpol_off = btn_img_callback(effects_model_interpol_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_interpol_model_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_model_interpol_lbl.len){
    effects_model_interpol_on.drawme = FALSE;
    effects_model_interpol_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_model_interpol_off.drawme = FALSE;
    effects_model_interpol_lbl.color = CLR_DEF_GRAY_H;
  }

  effects_sprite_interpol_lbl = lbl_text(MENU_ORG + '150 263', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_sprite_interpol_lbl.len = cvar("r_lerpsprites");
  effects_sprite_interpol_on = btn_img_callback(effects_sprite_interpol_lbl.origin + Vector2(stringwidth("OFF", 0, effects_sprite_interpol_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_interpol_sprite_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_sprite_interpol_off = btn_img_callback(effects_sprite_interpol_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_interpol_sprite_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_sprite_interpol_lbl.len){
    effects_sprite_interpol_on.drawme = FALSE;
    effects_sprite_interpol_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_sprite_interpol_off.drawme = FALSE;
    effects_sprite_interpol_lbl.color = CLR_DEF_GRAY_H;
  }

  effects_flicker_interpol_lbl = lbl_text(MENU_ORG + '150 283', '14 14', "", CLR_DEF_WHITE, VIEW_CTX, M_OPTIONS_EFFECT, 1, UI_FLAG_LBL_BOOL_ON);
  effects_flicker_interpol_lbl.len = cvar("r_lerplightstyles");
  effects_flicker_interpol_on = btn_img_callback(effects_flicker_interpol_lbl.origin + Vector2(stringwidth("OFF", 0, effects_flicker_interpol_lbl.size), 0), '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_EFFECT, click_effects_interpol_flicker_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  effects_flicker_interpol_off = btn_img_callback(effects_flicker_interpol_lbl.origin - '20 0', '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_EFFECT, click_effects_interpol_flicker_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(effects_flicker_interpol_lbl.len){
    effects_flicker_interpol_on.drawme = FALSE;
    effects_flicker_interpol_lbl.color = CLR_DEF_ARM_OK;
  }
  else{
    effects_flicker_interpol_off.drawme = FALSE;
    effects_flicker_interpol_lbl.color = CLR_DEF_GRAY_H;
  }

  //operations
  effects_back = btn_text_callback(MENU_ORG + '45 310', '16 16', "BACK", VIEW_CTX , M_OPTIONS_EFFECT, click_effects_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  effects_back.fontId = FONT_NUM_XOLONIUM_BOLD;
 
  effects_save = btn_text_callback(MENU_ORG + '200 310', '16 16', "SAVE", VIEW_CTX, M_OPTIONS_EFFECT, click_effects_save, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  effects_save.fontId = FONT_NUM_XOLONIUM_BOLD;
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_effects_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_EFFECT;
  setkeydest(KEY_MENU);
  m_effects_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_effects_d={
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  gui_renderString("- Particle Settings -", MENU_ORG + menu_parent_center_width(40) - Vector2((stringwidth("- Particle Settings -", 0, '16 16')/2),0), CLR_DEF_WHITE, '16 16', 1, 0);
  
  drawfont = FONT_NUM_ROBOT_LIGHT;
    
    gui_renderString("Particle Effects:", effects_particles_off.origin  - Vector2(stringwidth("Particle Effects:  ", 0, '12 12'),0) , CLR_DEF_TXT_GRAY_SMOOTH,'12 12', 1, 0);
    
    gui_renderHighlightString("Particle Quality:", effects_particles_quality_less.origin - Vector2(stringwidth("Particle Quality:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_particles_quality_lbl.len, '12 12', 1, 0);
    
    gui_renderHighlightString("Decal Mode:", effects_decals_select_prev.origin - Vector2(stringwidth("Decal Mode:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_decals_select_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Bullet Impact:", effects_bullet_impact_off.origin - Vector2(stringwidth("Bullet Impact:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_bullet_impact_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Smoke:", effects_smoke_off.origin - Vector2(stringwidth("Smoke:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_smoke_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Sparks:", effects_sparks_off.origin - Vector2(stringwidth("Sparks:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_sparks_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Bubbles:", effects_bubbles_off.origin - Vector2(stringwidth("Bubbles:   ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_bubbles_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Rain:", effects_rain_off.origin - Vector2(stringwidth("Rain:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_rain_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Snow:", effects_snow_off.origin - Vector2(stringwidth("Snow:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_snow_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Model Interpolation:", effects_model_interpol_off.origin - Vector2(stringwidth("Model Interpolation:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_model_interpol_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Sprite Interpolation:", effects_sprite_interpol_off.origin - Vector2(stringwidth("Sprite Interpolation:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_sprite_interpol_lbl.len,'12 12', 1, 0);
    
    gui_renderHighlightString("Light Interpolation:", effects_flicker_interpol_off.origin - Vector2(stringwidth("Light Interpolation:  ", 0, '12 12'),0), CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_TXT_NONSELECT, effects_flicker_interpol_lbl.len, '12 12', 1, 0);

  drawfont = drawfont_prev;

  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_EFFECT);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_effects_k={
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