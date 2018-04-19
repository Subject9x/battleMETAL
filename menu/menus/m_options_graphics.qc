/*
mech Mod
Author: Peter Roohr
Date: 4/17/2018
Overview: options - graphics menu
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

entity graphics_accept;

//graphics constants
vector VID_NEXT;

//graphics callbacks
void() click_graphics_resolution_less={
  local float vid;
  vid = graphics_resolution_lbl.len;
  vid = vid + 1;
  if(vid > 56){
    vid = 1;
  }
  VID_NEXT = VID_RESO_SIZE[vid];
  strunzone(graphics_resolution_lbl.label);
  graphics_resolution_lbl.label = strzone(menu_getvideo_clean(vid));
  graphics_resolution_lbl.len = vid;
  strunzone(graphics_resolution_aspect_lbl.label);
  graphics_resolution_aspect_lbl.label = strzone(VID_RESO_NAME[vid]);

};
void() click_graphics_resolution_more={
  local float vid;
  vid = graphics_resolution_lbl.len;
  vid = vid - 1;
  if(vid < 1){
    vid = 56;
  }
  VID_NEXT = VID_RESO_SIZE[vid];
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
  sampl = stof(graphics_aa_lbl.label);
  sampl = sampl * 2;
  if(sampl >= 32){
    sampl = 32;
    graphics_aa_more.drawme = FALSE;
  }
  if( !graphics_aa_less.drawme ){
    graphics_aa_less.drawme = TRUE;
  }
  strunzone(graphics_aa_lbl.label); 
  graphics_aa_lbl.label = strzone(ftos(sampl));
};
void() click_graphics_aa_less={
  local float sampl;
  sampl = stof(graphics_aa_lbl.label);
  sampl = sampl * 0.5;
  if(sampl <= 1){
    sampl = 1;
    graphics_aa_less.drawme = FALSE;
  }
  if( !graphics_aa_more.drawme ){
    graphics_aa_more.drawme = TRUE;
  }
  strunzone(graphics_aa_lbl.label); 
  graphics_aa_lbl.label = strzone(ftos(sampl));
};

void() click_refresh_on={
  strunzone(graphics_refresh_lbl.label); 
  graphics_refresh_lbl.label = strzone("[ON]");
  graphics_refresh_lbl.len = TRUE;
 
  graphics_refresh_off.drawme = TRUE;
  graphics_refresh_on.drawme = FALSE;
  
  graphics_refresh_rate_lbl.len = 60;
  strunzone(graphics_refresh_rate_lbl.label); 
  graphics_refresh_rate_lbl.label = strzone(ftos(cvar("vid_refreshrate")));
  graphics_refresh_rate_up.drawme = TRUE;
  graphics_refresh_rate_dn.drawme = TRUE;
};
void() click_refresh_off={
  strunzone(graphics_refresh_lbl.label); 
  graphics_refresh_lbl.label = strzone("[OFF]");
  graphics_refresh_lbl.len = FALSE;

  graphics_refresh_off.drawme = FALSE;
  graphics_refresh_on.drawme = TRUE;
  
  graphics_refresh_rate_lbl.len = 0;
  strunzone(graphics_refresh_rate_lbl.label); 
  graphics_refresh_rate_lbl.label = strzone("[OFF]");
  graphics_refresh_rate_up.drawme = FALSE;
  graphics_refresh_rate_dn.drawme = FALSE;
};

void() click_refresh_rate_up={
  local float rate;
  rate = graphics_refresh_rate_lbl.len;
  rate = rate + 10;
  if(rate >= 120){
    rate = 120;
    graphics_refresh_rate_up.drawme = FALSE;
  }
  strunzone(graphics_refresh_rate_lbl.label);
  graphics_refresh_rate_lbl.label = strzone(ftos(rate));
  graphics_refresh_rate_lbl.len = rate;
  if( !graphics_refresh_rate_dn.drawme ){
    graphics_refresh_rate_dn.drawme = TRUE;
  }
};
void() click_refresh_rate_dn={
  local float rate;
  rate = graphics_refresh_rate_lbl.len;
  rate = rate - 10;
  if(rate <= 20){
    rate = 20;
    graphics_refresh_rate_dn.drawme = FALSE;
  }
  strunzone(graphics_refresh_rate_lbl.label);
  graphics_refresh_rate_lbl.label = strzone(ftos(rate));
  graphics_refresh_rate_lbl.len = rate;
  
  if( !graphics_refresh_rate_up.drawme ){
    graphics_refresh_rate_up.drawme = TRUE;
  }
};

void() click_graphics_fullscreen_on={
  local float flip;
  
  if(!graphics_fullscreen_lbl.len){
    graphics_fullscreen_lbl.len = TRUE;
    graphics_fullscreen_on.drawme = FALSE;
  }
  if( !graphics_fullscreen_off.drawme ){
    graphics_fullscreen_off.drawme = TRUE;
  }
  strunzone(graphics_fullscreen_lbl.label); 
  graphics_fullscreen_lbl.label = strzone("[ON]");
};
void() click_graphics_fullscreen_off={
  local float flip;
  
  if(graphics_fullscreen_lbl.len){
    graphics_fullscreen_lbl.len = FALSE;
    graphics_fullscreen_off.drawme = FALSE;
  }
  if( !graphics_fullscreen_on.drawme ){
    graphics_fullscreen_on.drawme = TRUE;
  }
  strunzone(graphics_fullscreen_lbl.label); 
  graphics_fullscreen_lbl.label = strzone("[OFF]");
};

void() click_graphics_vsync_on={
  local float flip;
  
  if(!graphics_vsync_lbl.len){
    graphics_vsync_lbl.len = TRUE;
    graphics_vsync_on.drawme = FALSE;
  }
  if( !graphics_vsync_off.drawme ){
    graphics_vsync_off.drawme = TRUE;
  }
  strunzone(graphics_vsync_lbl.label); 
  graphics_vsync_lbl.label = strzone("[ON]");
};
void() click_graphics_vsync_off={
  local float flip;
  
  if(graphics_vsync_lbl.len){
    graphics_vsync_lbl.len = FALSE;
    graphics_vsync_off.drawme = FALSE;
  }
  if( !graphics_vsync_on.drawme ){
    graphics_vsync_on.drawme = TRUE;
  }
  strunzone(graphics_vsync_lbl.label); 
  graphics_vsync_lbl.label = strzone("[OFF]");
};

void() click_graphics_aniso_more={
  local float sampl;
  sampl = stof(graphics_aniso_lbl.label);
  sampl = sampl * 2;
  if(sampl >= 32){
    sampl = 32;
    graphics_aniso_more.drawme = FALSE;
  }
  if( !graphics_aniso_less.drawme ){
    graphics_aniso_less.drawme = TRUE;
  }
  strunzone(graphics_aniso_lbl.label); 
  graphics_aniso_lbl.label = strzone(ftos(sampl));
};
void() click_graphics_aniso_less={
  local float sampl;
  sampl = stof(graphics_aniso_lbl.label);
  sampl = sampl * 0.5;
  if(sampl <= 1){
    sampl = 1;
    graphics_aniso_more.drawme = FALSE;
  }
  if( !graphics_aa_more.drawme ){
    graphics_aa_more.drawme = TRUE;
  }
  strunzone(graphics_aniso_lbl.label); 
  graphics_aniso_lbl.label = strzone(ftos(sampl));
};

void() click_graphics_texture_quality_more={
  local float sampl;
  sampl = stof(graphics_texture_quality_lbl.label);
  sampl = sampl - 1;
  if(sampl <= 0){
    sampl = 0;
    graphics_texture_quality_more.drawme = FALSE;
  }
  if( !graphics_texture_quality_less.drawme ){
    graphics_texture_quality_less.drawme = TRUE;
  }
  strunzone(graphics_texture_quality_lbl.label); 
  graphics_texture_quality_lbl.label = strzone(ftos(sampl));
};
void() click_graphics_texture_quality_less={
  local float sampl;
  sampl = stof(graphics_texture_quality_lbl.label);
  sampl = sampl + 1;
  if(sampl >= 4){
    sampl = 4;
    graphics_texture_quality_less.drawme = FALSE;
  }
  if( !graphics_texture_quality_more.drawme ){
    graphics_texture_quality_more.drawme = TRUE;
  }
  strunzone(graphics_texture_quality_lbl.label); 
  graphics_texture_quality_lbl.label = strzone(ftos(sampl));
};

void() click_graphics_texture_compression_on={
  local float flip;
  
  if(!graphics_texture_compress_lbl.len){
    graphics_texture_compress_lbl.len = TRUE;
    graphics_texture_compress_on.drawme = FALSE;
  }
  if( !graphics_texture_compress_off.drawme ){
    graphics_texture_compress_off.drawme = TRUE;
  }
  strunzone(graphics_texture_compress_lbl.label); 
  graphics_texture_compress_lbl.label = strzone("[ON]");
};
void() click_graphics_texture_compression_off={
  local float flip;
  
  if(graphics_texture_compress_lbl.len){
    graphics_texture_compress_lbl.len = FALSE;
    graphics_texture_compress_off.drawme = FALSE;
  }
  if( !graphics_texture_compress_on.drawme ){
    graphics_texture_compress_on.drawme = TRUE;
  }
  strunzone(graphics_texture_compress_lbl.label); 
  graphics_texture_compress_lbl.label = strzone("[OFF]");
};

void() click_graphics_accept={
  
  cvar_set("vid_bitsperpixel", graphics_bits_lbl.label);
  cvar_set("vid_samples", graphics_aa_lbl.label);
  if(graphics_refresh_rate_lbl.label != "[OFF]"){
    cvar_set("vid_userefreshrate", ftos(graphics_refresh_lbl.len));
    cvar_set("vid_refreshrate", ftos(graphics_refresh_rate_lbl.len));
  }
  else{
    cvar_set("vid_userefreshrate", ftos(0));
    cvar_set("vid_refreshrate", ftos(0));
  }
  cvar_set("vid_fullscreen", ftos(graphics_fullscreen_lbl.len));
  cvar_set("vid_vsync", ftos(graphics_vsync_lbl.len));
  cvar_set("gl_texture_anisotropy", graphics_aniso_lbl.label);
  cvar_set("gl_picmip", graphics_texture_quality_lbl.label);
  cvar_set("gl_texturecompression", ftos(graphics_texture_compress_lbl.len));
  if(VID_NEXT != '0 0 0'){
    cvar_set("vid_width", ftos(VID_NEXT_x));
    cvar_set("vid_height", ftos(VID_NEXT_y));
    cvar_set("vid_pixelheight", ftos(VID_NEXT_z));
  }
  VIEW_MAX = VID_RESO_HALF[graphics_resolution_lbl.len];
  cmd("vid_restart\n");
};

// ini function, called by '_f' function as a setup func
void() m_graphics_i={
  graphics_title = lbl_img('10 25', '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, (UI_FLAG_SIZE_IMG) );
  
  //resolution
  local float vid;
  vid = menu_getvideo_modeid(VIEW_MAX); 

  graphics_resolution_lbl = lbl_text('190 108', '9 9 0', strzone(menu_getvideo_clean(vid)), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_resolution_lbl.len = vid;
  graphics_resolution_more = btn_img_callback('297 106 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_resolution_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_resolution_less = btn_img_callback('176 106 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_resolution_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  //new resolution  
  graphics_resolution_aspect_lbl = lbl_text('190 121', '9 9 0', strzone(VID_RESO_NAME[vid]), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  
  //bits
  graphics_bits_lbl = lbl_text('190 135', '9 9 0', strzone(ftos(cvar("vid_bitsperpixel"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_bits_more = btn_img_callback('215 134 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_bits_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_bits_less = btn_img_callback('176 134 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_bits_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_bits_lbl.label == "32"){
    graphics_bits_more.drawme = FALSE;
  }
  else{
    graphics_bits_less.drawme = FALSE;
  }
  
  //anti-alias
  graphics_aa_lbl = lbl_text('190 149', '9 9 0', strzone(ftos(cvar("vid_samples"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_aa_more = btn_img_callback('215 148 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aa_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_aa_less = btn_img_callback('176 148 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aa_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_aa_lbl.label == "32"){
    graphics_aa_more.drawme = FALSE;
  }
  else if(graphics_aa_lbl.label == "1"){
    graphics_aa_less.drawme = FALSE;
  }
  
  //refresh
  graphics_refresh_lbl = lbl_text('190 164', '9 9 0', ftos(cvar("vid_userefreshrate")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_refresh_on = btn_img_callback('238 162 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refresh_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_refresh_off = btn_img_callback('176 162 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refresh_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_refresh_lbl.label == "0"){
    graphics_refresh_lbl.label = strzone("[OFF]");
    graphics_refresh_off.drawme = FALSE;
  }
  else if(graphics_refresh_lbl.label == "1"){
    graphics_refresh_lbl.label = strzone("[ON]");
    graphics_refresh_on.drawme = FALSE;
  }
  
  graphics_refresh_rate_lbl = lbl_text('190 177', '9 9 0', ftos(cvar("vid_refreshrate")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_refresh_rate_up = btn_img_callback('238 176 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refresh_rate_up, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_refresh_rate_dn = btn_img_callback('176 176 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_refresh_rate_dn, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_refresh_lbl.label == "[OFF]"){
    graphics_refresh_rate_lbl.len = 0;
    graphics_refresh_rate_lbl.label = strzone("OFF");
    graphics_refresh_rate_up.drawme = FALSE;
    graphics_refresh_rate_dn.drawme = FALSE;
  }
  else{
    graphics_refresh_rate_lbl.len = stof(graphics_refresh_rate_lbl.label);
    graphics_refresh_rate_lbl.label = strzone(graphics_refresh_rate_lbl.label);
  }
  
  //fullscreen
  graphics_fullscreen_lbl = lbl_text('190 191', '9 9 0', ftos(cvar("vid_fullscreen")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_fullscreen_on = btn_img_callback('238 190 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_fullscreen_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_fullscreen_off = btn_img_callback('176 190 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_fullscreen_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_fullscreen_lbl.label == "0"){
    graphics_fullscreen_lbl.len = FALSE;
    graphics_fullscreen_lbl.label = strzone("[OFF]");
    graphics_fullscreen_off.drawme = FALSE;
  }
  else if(graphics_fullscreen_lbl.label == "1"){
    graphics_fullscreen_lbl.len = TRUE;
    graphics_fullscreen_lbl.label = strzone("[ON]");
    graphics_fullscreen_on.drawme = FALSE;
  }
  
  //v-sync
  graphics_vsync_lbl = lbl_text('190 205', '9 9 0', ftos(cvar("vid_fullscreen")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_vsync_on = btn_img_callback('238 204 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_vsync_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_vsync_off = btn_img_callback('176 204 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_vsync_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_vsync_lbl.label == "0"){
    graphics_vsync_lbl.len = FALSE;
    graphics_vsync_lbl.label = strzone("[OFF]");
    graphics_vsync_off.drawme = FALSE;
  }
  else if(graphics_vsync_lbl.label == "1"){
    graphics_vsync_lbl.len = TRUE;
    graphics_vsync_lbl.label = strzone("[ON]");
    graphics_vsync_on.drawme = FALSE;
  }
  
  //aniso
  graphics_aniso_lbl = lbl_text('190 219', '9 9 0', strzone(ftos(cvar("gl_texture_anisotropy"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_aniso_more = btn_img_callback('215 218 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aniso_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_aniso_less = btn_img_callback('176 218 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_aniso_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_aniso_lbl.label == "32"){
    graphics_aniso_more.drawme = FALSE;
  }
  else if(graphics_aniso_lbl.label == "1"){
    graphics_aniso_less.drawme = FALSE;
  }
  
  //texture
  graphics_texture_quality_lbl = lbl_text('190 233', '9 9 0', strzone(ftos(cvar("gl_picmip"))), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_texture_quality_more = btn_img_callback('215 232 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_quality_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_texture_quality_less = btn_img_callback('176 232 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_quality_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  
  if(graphics_texture_quality_lbl.label == "0"){
    
    graphics_texture_quality_more.drawme = FALSE;
  }
  else if(graphics_texture_quality_lbl.label == "4"){
    graphics_texture_quality_less.drawme = FALSE;
  }

  graphics_texture_compress_lbl = lbl_text('190 247', '9 9 0', ftos(cvar("gl_texturecompression")), CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, 1, 0);
  graphics_texture_compress_on = btn_img_callback('238 246 0', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_compression_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  graphics_texture_compress_off = btn_img_callback('176 246 0', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_texture_compression_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(graphics_texture_compress_lbl.label == "0"){
    graphics_texture_compress_lbl.len = FALSE;
    graphics_texture_compress_lbl.label = strzone("[OFF]");
    graphics_texture_compress_off.drawme = FALSE;
  }
  else if(graphics_texture_compress_lbl.label == "1"){
    graphics_texture_compress_lbl.len = TRUE;
    graphics_texture_compress_lbl.label = strzone("[ON]");
    graphics_texture_compress_on.drawme = FALSE;
  }
  
  graphics_accept = btn_img_callback('25 282 0', '96 24', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_GRAPHICS, click_graphics_accept, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL));
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
  gui_renderString("[- GRAPHICS SETTINGS -]", gui_percentToPixelRawVec('150 64'), CLR_DEF_WHITE, '10 10 0', 1, 0);
  //display
  gui_renderString("DISPLAY", gui_percentToPixelRawVec('90 80'), CLR_DEF_ARM_THREEQ, '9 9 0', 1, 0);
    gui_renderString("Current Resolution :", gui_percentToPixelRawVec('13 94'), CLR_DEF_WHITE, '8 8 0', 1, 0);
      gui_renderString(strcat(ftos(VIEW_MAX_x),"x",ftos(VIEW_MAX_y)), gui_percentToPixelRawVec('179 94'), CLR_DEF_WHITE, '9 9 0', 1, 0);
    gui_renderString("New Resolution :", gui_percentToPixelRawVec('45 108'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Type :", gui_percentToPixelRawVec('125 122'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Bits per pixel :", gui_percentToPixelRawVec('45 136'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Anti-Aliasing :", gui_percentToPixelRawVec('53 150'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Custom Refresh Rate :", gui_percentToPixelRawVec('5 164'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Refresh Rate :", gui_percentToPixelRawVec('61 178'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fullscreen :", gui_percentToPixelRawVec('77 192'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("V-Sync :", gui_percentToPixelRawVec('109 206'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Anisotropic Filter :", gui_percentToPixelRawVec('13 220'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Texture Quality :", gui_percentToPixelRawVec('37 234'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Texture Compression :", gui_percentToPixelRawVec('5 248'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    
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
  cons_logAFloat("m_graphics_k.key", key);  //DEBUG
  cons_logAFloat("m_graphics_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
    case K_MOUSE1:
      m_sys_doclick();
      break;
  }
};