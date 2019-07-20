/*
battleMETAL
Author: Peter Roohr
Date: 4/17/2018
mod: 07/19/2019
Overview: options-controls
*/

//controls Globals
entity controls_title;

//combat
entity controls_mouse_sense;
entity controls_mouse_sense_more;
entity controls_mouse_sense_less;
entity controls_mouse_invert;
entity controls_mouse_invert_on;
entity controls_mouse_invert_off;
entity controls_target;
entity controls_fire_group;
entity controls_fire_group1;
entity controls_fire_group2;
entity controls_fire_group3;
entity controls_fire_group4;
entity controls_fire_group5;
entity controls_group_next;
entity controls_group_prev;
entity controls_select_group1;
entity controls_select_group2;
entity controls_select_group3;
entity controls_select_group4;
entity controls_select_group5;
entity controls_select_group5;

//movement
entity controls_forward;
entity controls_backward;
entity controls_strafe_left;
entity controls_strafe_right;
entity controls_sprint;

//piloting
entity controls_radar;
entity controls_navs;
entity controls_objectives;
entity controls_repair;
entity controls_chat_team;
entity controls_chat_all;
entity controls_zoom;

//controls constants
string IMG_CONTROLS_TITLE = "gfx/menu/options/options_title.png";

//controls callbacks
entity controls_mouse_sense;
entity controls_mouse_sense_more;
entity controls_mouse_sense_less;

entity controls_mouse_invert;
entity controls_mouse_invert_more;
entity controls_mouse_invert_less;

entity controls_back;
entity controls_accept;

void() click_control_mouse_sense_more={
  local float val;
  val = controls_mouse_sense.len;
  val = val + 1;
  if(val >= 35){
    val = 35;
    controls_mouse_sense_more.drawme = FALSE;
  }
  controls_mouse_sense_less.drawme = TRUE;
  controls_mouse_sense.len = val;
  strunzone(controls_mouse_sense.label); 
  controls_mouse_sense.label = strzone(ftos(val));
  cvar_set("sensitivity", controls_mouse_sense.label);
};
void() click_control_mouse_sense_less={
  local float val;
  val = controls_mouse_sense.len;
  val = val - 1;
  if(val <= 1){
    val = 1;
    controls_mouse_sense_less.drawme = FALSE;
  }
  controls_mouse_sense_more.drawme = TRUE;
  controls_mouse_sense.len = val;
  strunzone(controls_mouse_sense.label); 
  controls_mouse_sense.label = strzone(ftos(val));
  cvar_set("sensitivity", controls_mouse_sense.label);
};

void() click_control_mouse_invert_on={
  strunzone(controls_mouse_invert.label); 
  controls_mouse_invert.label = strzone("ON");  
  cvar_set("m_pitch", "-0.022");
  controls_mouse_invert_on.drawme = FALSE;
  controls_mouse_invert_off.drawme = TRUE;

};
void() click_control_mouse_invert_off={
  strunzone(controls_mouse_invert.label); 
  controls_mouse_invert.label = strzone("OFF");  
  cvar_set("m_pitch", "0.022");  
  controls_mouse_invert_on.drawme = TRUE;
  controls_mouse_invert_off.drawme = FALSE;
};

void() txt_control_bind_target={
  menu_keybind_change ("impulse 7");
};
void() txt_control_bind_fire={
  menu_keybind_change ("+attack");
};
void() txt_control_bind_fire_grp1={
  menu_keybind_change ("+button3");
};
void() txt_control_bind_fire_grp2={
  menu_keybind_change ("+button4");
};
void() txt_control_bind_fire_grp3={
  menu_keybind_change ("+button5");
};
void() txt_control_bind_fire_grp4={
  menu_keybind_change ("+button6");
};
void() txt_control_bind_fire_grp5={
  menu_keybind_change ("+button7");
};
void() txt_control_bind_grp_nxt={
  menu_keybind_change ("impulse 4");

};
void() txt_control_bind_grp_prv={
  menu_keybind_change ("impulse 5");
};
void() txt_control_bind_sel_grp1={
  menu_keybind_change ("impulse 1");
};
void() txt_control_bind_sel_grp2={
  menu_keybind_change ("impulse 2");
};
void() txt_control_bind_sel_grp3={
  menu_keybind_change ("impulse 3");
};
void() txt_control_bind_sel_grp4={
  menu_keybind_change ("impulse 23");
};
void() txt_control_bind_sel_grp5={
  menu_keybind_change ("impulse 24");
};

void() txt_control_bind_forward={
  menu_keybind_change ("+forward");
};
void() txt_control_bind_backward={
  menu_keybind_change ("+back");
};
void() txt_control_bind_strafeleft={
  menu_keybind_change ("+moveleft");
};
void() txt_control_bind_straferight={
  menu_keybind_change ("+moveright");
};
void() txt_control_bind_sprint={
  menu_keybind_change ("+button8");
};

void() txt_control_bind_radar={
  menu_keybind_change ("impulse 8");
};
void() txt_control_bind_nav={
  menu_keybind_change ("impulse 9");
};
void() txt_control_bind_obj={
  menu_keybind_change ("impulse 25");
};
void() txt_control_bind_repair={
  menu_keybind_change ("impulse 26");
};
void() txt_control_bind_chat_team={
  menu_keybind_change ("messagemode2");
};
void() txt_control_bind_chat_all={
  menu_keybind_change ("messagemode");
};
void() txt_control_bind_zoom={
  menu_keybind_change ("+button9");
};

void() click_controls_back={
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_controls_accept={
  
  cmd("saveconfig\n");
};

// ini function, called by '_f' function as a setup func
void() m_controls_i={
  controls_title = lbl_img('10 10', '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, (UI_FLAG_SIZE_IMG) );
  
  controls_mouse_sense = lbl_text('178 78', '14 14 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, 0);
  controls_mouse_sense.len = cvar("sensitivity");
  controls_mouse_sense.label = strzone(ftos(controls_mouse_sense.len));
  controls_mouse_sense_more = btn_img_callback('204 77', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_sense_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_sense_less = btn_img_callback('167 77', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_sense_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_sense.len == 1){
    controls_mouse_sense_less.drawme = FALSE;
  }
  else if(controls_mouse_sense.len == 35){
    controls_mouse_sense_more.drawme = FALSE;
  }
  
  controls_mouse_invert = lbl_text('178 98', '14 14', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, 0);
  controls_mouse_invert.len = cvar("m_pitch");
  controls_mouse_invert_on = btn_img_callback('204 97', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_invert_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_invert_off = btn_img_callback('167 97', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_invert_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_invert.len < 0){
    controls_mouse_invert.label = strzone("ON");
    controls_mouse_invert_on.drawme = FALSE;
  }
  else{
    controls_mouse_invert.label = strzone("OFF");
    controls_mouse_invert_off.drawme = FALSE;
  }
  
  //combat
  controls_target = inp_keybindfield('167 118', '14 14 0', txt_control_bind_target, "impulse 7", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_fire_group = inp_keybindfield('167 138', '14 14 0', txt_control_bind_fire, "+button0", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
   
  controls_fire_group1 = inp_keybindfield('167 158', '14 14 0', txt_control_bind_fire_grp1, "+button3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group2 = inp_keybindfield('167 178', '14 14 0', txt_control_bind_fire_grp2, "+button4", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group3 = inp_keybindfield('167 198', '14 14 0', txt_control_bind_fire_grp3, "+button5", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_fire_group4 = inp_keybindfield('167 218', '14 14 0', txt_control_bind_fire_grp4, "+button6", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group5 = inp_keybindfield('167 238', '14 14 0', txt_control_bind_fire_grp5, "+button7", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_group_next = inp_keybindfield('167 258', '14 14 0', txt_control_bind_grp_nxt, "impulse 4", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_group_prev = inp_keybindfield('167 278', '14 14 0', txt_control_bind_grp_prv, "impulse 5", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group1 = inp_keybindfield('167 298', '14 14 0', txt_control_bind_sel_grp1, "impulse 1", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group2 = inp_keybindfield('167 318', '14 14 0', txt_control_bind_sel_grp2, "impulse 2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group3 = inp_keybindfield('167 338', '14 14 0', txt_control_bind_sel_grp3, "impulse 3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group4 = inp_keybindfield('167 358', '14 14 0', txt_control_bind_sel_grp4, "impulse 23", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_select_group5 = inp_keybindfield('167 378', '14 14 0', txt_control_bind_sel_grp5, "impulse 24", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //piloting
  controls_radar = inp_keybindfield('400 78', '14 14 0', txt_control_bind_radar, "impulse 8", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_navs = inp_keybindfield('400 98', '14 14 0', txt_control_bind_nav, "impulse 9", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_objectives = inp_keybindfield('400 118', '14 14 0', txt_control_bind_obj, "impulse 25", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
 
  controls_repair = inp_keybindfield('400 138', '14 14 0', txt_control_bind_repair, "impulse 26", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_team = inp_keybindfield('400 158', '14 14 0', txt_control_bind_chat_team, "messagemode2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_all = inp_keybindfield('400 178', '14 14 0', txt_control_bind_chat_all, "messagemode", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_zoom = inp_keybindfield('400 198', '14 14 0', txt_control_bind_zoom, "+button9", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  
  //movement
  controls_forward = inp_keybindfield('400 235', '14 14 0', txt_control_bind_forward, "+forward", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_backward = inp_keybindfield('400 255', '14 14 0', txt_control_bind_backward, "+back", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_left = inp_keybindfield('400 275', '14 14 0', txt_control_bind_strafeleft, "+moveleft", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_right = inp_keybindfield('400 295', '14 14 0', txt_control_bind_straferight, "+moveright", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_sprint = inp_keybindfield('400 315', '14 14 0', txt_control_bind_sprint, "+button8", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_back = btn_img_callback('25 415', '56 12', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_controls_back, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_accept = btn_img_callback('285 415', '70 12', IMG_BTN_ACPT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_controls_accept, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_controls_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_OPTIONS_CONTROLS;
  setkeydest(KEY_MENU);
  m_controls_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_controls_d={

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  local float titleLen;
  local vector titleOrg;
  titleLen = stringwidth( "Controls - click a key to change it. Hit <ESC> to cancel.", 0, '16 16 0');
  titleOrg_x = gui_percentXRaw( VIEW_CTR_x ) - gui_percentXRaw( titleLen / 2 );
  titleOrg_y = gui_percentYRaw( 45 );
  gui_renderString("Controls - click a key to change it. Hit <ESC> to cancel.", titleOrg, '1 1 1', '16 16 0', 1, 0);
  
  //combat
  gui_renderString("-Combat-", gui_percentToPixelRawVec('116 60'), CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
    gui_renderString("Mouse Sensitivity:", gui_percentToPixelRawVec('80 79'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Invert Mouse:", gui_percentToPixelRawVec('99 99'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Acquire Target:", gui_percentToPixelRawVec('93 119'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fire Select Group:", gui_percentToPixelRawVec('81 139'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fire Group 1:", gui_percentToPixelRawVec('102 159'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fire Group 2:", gui_percentToPixelRawVec('102 179'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fire Group 3:", gui_percentToPixelRawVec('102 199'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fire Group 4:", gui_percentToPixelRawVec('102 219'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Fire Group 5:", gui_percentToPixelRawVec('102 239'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Next Weapon Group:", gui_percentToPixelRawVec('69 259'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Prev Weapon Group:", gui_percentToPixelRawVec('69 279'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Select Group 1:", gui_percentToPixelRawVec('92 299'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Select Group 2:", gui_percentToPixelRawVec('92 319'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Select Group 3:", gui_percentToPixelRawVec('92 339'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Select Group 4:", gui_percentToPixelRawVec('92 359'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Select Group 5:", gui_percentToPixelRawVec('92 379'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  //controls
  gui_renderString("-Piloting-", gui_percentToPixelRawVec('345 60'), CLR_DEF_IIF_FRIEND_BLD, '16 16 0', 1, 0);
    gui_renderString("Toggle RADAR:", gui_percentToPixelRawVec('323 79'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Show Navs:", gui_percentToPixelRawVec('339 99'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Display Objectives:", gui_percentToPixelRawVec('306 119'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Engage Repair Bay:", gui_percentToPixelRawVec('305 139'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Chat Team:", gui_percentToPixelRawVec('340 159'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Chat All:", gui_percentToPixelRawVec('351 179'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Optical Zoom:", gui_percentToPixelRawVec('329 199'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  //movement
  gui_renderString("-Movement-", gui_percentToPixelRawVec('330 220'), CLR_DEF_GREEN, '16 16 0', 1, 0);
    gui_renderString("Forward :", gui_percentToPixelRawVec('350 236'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Backward :", gui_percentToPixelRawVec('343 256'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Strafe Left :", gui_percentToPixelRawVec('340 276'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Strafe Right :", gui_percentToPixelRawVec('334 296'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    gui_renderString("Engage Sprint :", gui_percentToPixelRawVec('326 316'), CLR_DEF_WHITE, '12 12 0', 1, 0);

  drawfont = drawfont_prev;
  
  local entity widget;
  widget = findchainfloat(menuId, M_OPTIONS_CONTROLS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_controls_k={
  //cons_logAFloat("m_controls_k.key", key);  //DEBUG
  //cons_logAFloat("m_controls_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      cmd("saveconfig\n");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};