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
entity controls_fire_group1;
entity controls_fire_group2;
entity controls_fire_group3;
entity controls_fire_group4;
entity controsl_select_fire_group;
entity controsl_select_fire_chain;
entity controls_open_bind_menu;

/*entity controls_fire_group;
entity controls_group_next;
entity controls_group_prev;
entity controls_select_group1;
entity controls_select_group2;
entity controls_select_group3;
entity controls_select_group4;
*/

//movement
entity controls_forward;
entity controls_backward;
entity controls_strafe_left;
entity controls_strafe_right;
entity controls_sprint;
entity controls_ram;

//piloting
entity controls_radar;
entity controls_navs;
entity controls_objectives;
entity controls_tacmap;
//entity controls_repair;
entity controls_chat_team;
entity controls_chat_all;
entity controls_zoom;
entity controls_regen;
entity controls_camera;
entity controls_headlight;

//controls constants
string IMG_CONTROLS_TITLE = "gfx/menu/options/options_title.png";

//controls callbacks
entity controls_mouse_sense;
entity controls_mouse_sense_more;
entity controls_mouse_sense_less;

entity controls_mouse_invert;

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
  cvar_set("sensitivity", ftos(controls_mouse_sense.len));
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
  cvar_set("sensitivity", ftos(controls_mouse_sense.len));
};

void() click_control_mouse_invert_on={
  cvar_set("m_pitch", "-0.022");
  controls_mouse_invert_on.drawme = FALSE;
  controls_mouse_invert_off.drawme = TRUE;

};
void() click_control_mouse_invert_off={
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
//mechwarrior-style weapon groups not needed, but left in for modders who want legacy controls.
/*
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
};*/
//void() txt_control_bind_sel_grp5={
//  menu_keybind_change ("impulse 24");
//};
void() txt_control_bind_fire_grp={
  menu_keybind_change ("impulse 10");
};
void() txt_control_bind_fire_chain={
  menu_keybind_change ("impulse 11");
};
void() txt_control_bind_group_menu={
  menu_keybind_change ("impulse 31");
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
void() txt_control_bind_ram={
  menu_keybind_change("impulse 27");
};
void() txt_control_bind_regen={
  menu_keybind_change ("+button10");
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
void() txt_control_bind_map={
  menu_keybind_change ("impulse 12");
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
void() txt_control_bind_camera={
  menu_keybind_change ("impulse 30");
};
void() txt_control_bind_headlight={
  menu_keybind_change ("impulse 32");
};



void() click_controls_back={
  menu_clear_items(M_STATE);
  m_options_f();
};

void() click_controls_accept={
  localcmd("saveconfig\n");
  click_controls_back();
};


//break out 3 major categories into 'sub' groups for alignment
void(vector rootOfs) controls_ini_movement={

  controls_mouse_sense = lbl_text(rootOfs + '110 0', '14 14', " ", CLR_DEF_TXT_GRAY_SMOOTH, VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_LBL_USELEN);
  controls_mouse_sense.len = cvar("sensitivity");
  
  controls_mouse_sense_more = btn_img_callback(controls_mouse_sense.origin + '16 0', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_CONTROLS, click_control_mouse_sense_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_sense_less = btn_img_callback(controls_mouse_sense.origin - Vector2(24,0), '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_CONTROLS, click_control_mouse_sense_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_sense.len == 1){
    controls_mouse_sense_less.drawme = FALSE;
  }
  else if(controls_mouse_sense.len == 35){
    controls_mouse_sense_more.drawme = FALSE;
  }
  
  controls_mouse_invert = lbl_text(rootOfs + '110 19', '14 14', "", CLR_DEF_TXT_GRAY_SMOOTH, VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_LBL_BOOL_ON);
  controls_mouse_invert.len = cvar("m_pitch");
  
  controls_mouse_invert_on = btn_img_callback(controls_mouse_invert.origin + '20 0', '12 12', UI_IMG_ARW_RGT, 0, M_OPTIONS_CONTROLS, click_control_mouse_invert_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_invert_off = btn_img_callback(controls_mouse_invert.origin - Vector2(24,0), '12 12', UI_IMG_ARW_LFT, 0, M_OPTIONS_CONTROLS, click_control_mouse_invert_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_invert.len < 0){
    controls_mouse_invert_on.drawme = FALSE;
  }
  else{
    controls_mouse_invert_off.drawme = FALSE;
  }
  
  controls_forward = inp_keybindfield(rootOfs + '86 38', '14 14', txt_control_bind_forward, "Forward:  ", "+forward", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_backward = inp_keybindfield(rootOfs + '86 60', '14 14', txt_control_bind_backward, "Backward:  ", "+back", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_left = inp_keybindfield(rootOfs + '86 82', '14 14', txt_control_bind_strafeleft, "Strafe Left:  ", "+moveleft", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_right = inp_keybindfield(rootOfs + '86 104', '14 14', txt_control_bind_straferight, "Strafe Right:  ", "+moveright", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_sprint = inp_keybindfield(rootOfs + '86 126', '14 14', txt_control_bind_sprint, "Sprint:  ", "+button8", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_ram = inp_keybindfield(rootOfs + '86 148', '14 14', txt_control_bind_ram, "Ram Attack:  ", "impulse 27", M_OPTIONS_CONTROLS, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
};


void(vector rootOfs) controls_ini_combat={
  controls_target = inp_keybindfield(rootOfs + '56 16', '14 14', txt_control_bind_target, "Acquire Target:  ", "impulse 7", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
   
  controls_fire_group1 = inp_keybindfield(rootOfs + '56 38', '14 14', txt_control_bind_fire_grp1, "Fire Group 1:  ", "+button3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group2 = inp_keybindfield(rootOfs + '56 60', '14 14', txt_control_bind_fire_grp2, "Fire Group 2:  ", "+button4", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group3 = inp_keybindfield(rootOfs + '56 82', '14 14', txt_control_bind_fire_grp3, "Fire Group 3:  ", "+button5", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_fire_group4 = inp_keybindfield(rootOfs + '56 104', '14 14', txt_control_bind_fire_grp4, "Fire Group 4:  ", "+button6", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controsl_select_fire_group = inp_keybindfield(rootOfs + '56 126', '14 14', txt_control_bind_fire_grp, "Toggle Group Fire:  ", "impulse 10", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controsl_select_fire_chain = inp_keybindfield(rootOfs + '56 148', '14 14', txt_control_bind_fire_chain, "Toggle Chain Fire:  ", "impulse 11", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_open_bind_menu = inp_keybindfield(rootOfs + '56 170', '14 14', txt_control_bind_group_menu, "Toggle Weapon Bind Menu:  " , "impulse 31", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //2.0.0 - mechwarrior-style controls aren't really needed anymore.
  //controls_fire_group = inp_keybindfield('11 119', '14 14 0', txt_control_bind_fire, "Fire Select Group:  ", "+attack", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  //controls_group_next = inp_keybindfield('0 238', '14 14 0', txt_control_bind_grp_nxt, "Next Weapon Group:  ", "impulse 4", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //controls_group_prev = inp_keybindfield('0 258', '14 14 0', txt_control_bind_grp_prv, "Prev Weapon Group:  ", "impulse 5", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //controls_select_group1 = inp_keybindfield('22 278', '14 14 0', txt_control_bind_sel_grp1, "Select Group 1:  ", "impulse 1", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //controls_select_group2 = inp_keybindfield('22 298', '14 14 0', txt_control_bind_sel_grp2, "Select Group 2:  ", "impulse 2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //controls_select_group3 = inp_keybindfield('22 318', '14 14 0', txt_control_bind_sel_grp3, "Select Group 3:  ", "impulse 3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  //controls_select_group4 = inp_keybindfield('22 338', '14 14 0', txt_control_bind_sel_grp4, "Select Group 4:  ", "impulse 23", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

};


void(vector rootOfs) controls_ini_pilot={
  controls_radar = inp_keybindfield(rootOfs + '56 16', '14 14 0', txt_control_bind_radar, "Toggle RADAR:  ", "impulse 8", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_navs = inp_keybindfield(rootOfs + '56 38', '14 14 0', txt_control_bind_nav, "Show Navs:  ", "impulse 9", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_objectives = inp_keybindfield(rootOfs + '56 60', '14 14 0', txt_control_bind_obj, "Display Objectives:  ", "impulse 25", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_tacmap = inp_keybindfield(rootOfs + '56 82', '14 14 0', txt_control_bind_map, "Display Map:  ", "impulse 12", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_team = inp_keybindfield(rootOfs + '56 104', '14 14 0', txt_control_bind_chat_team, "Chat Team:  ", "messagemode2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_all = inp_keybindfield(rootOfs + '56 126', '14 14 0', txt_control_bind_chat_all, "Chat All:  ", "messagemode", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_zoom = inp_keybindfield(rootOfs + '56 148', '14 14 0', txt_control_bind_zoom, "Optical Zoom:  ", "+button9", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_regen = inp_keybindfield(rootOfs + '56 170', '14 14 0', txt_control_bind_regen, "Shield Regen:  ", "+button10", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_camera = inp_keybindfield(rootOfs + '56 192', '14 14 0', txt_control_bind_camera, "External Camera: ", "impulse 30", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_headlight = inp_keybindfield(rootOfs + '56 212', '14 14 0', txt_control_bind_headlight, "Headlight: ", "impulse 32", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
};

// ini function, called by '_f' function as a setup func
void() m_controls_i={
  
  menu_parent_setup(VIEW_ORG + '0 40', '560 320');
  
  controls_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', VIEW_CTX, M_OPTIONS_CONTROLS, 1, UI_FLAG_SIZE_IMG );
  
  //movement
  controls_ini_movement(MENU_ORG + '10 58');
  
  //combat
  controls_ini_combat(MENU_ORG + '235 45');

  //piloting
  controls_ini_pilot(MENU_ORG + '450 45');
  
  controls_back = btn_text_callback(MENU_ORG + '40 272', '16 16', "BACK", VIEW_CTX, M_OPTIONS_CONTROLS, click_controls_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  controls_back.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  controls_accept = btn_text_callback(MENU_ORG + '255 272', '16 16', "ACCEPT", VIEW_CTX, M_OPTIONS_CONTROLS, click_controls_accept, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  controls_accept.fontId = FONT_NUM_XOLONIUM_BOLD;
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
  //local float titleLen;
  //local vector titleOrg;
  local entity widget;

  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);

  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;

  //titleLen = stringwidth( "Controls - click a key to change it. Hit <ESC> to cancel.", 0, '16 16 0');
  //titleOrg_x = VIEW_CTR_x - ( titleLen / 2.5 );
  //titleOrg_y = 20;
  //gui_renderString("Controls - click a key to change it. Hit <ESC> to cancel.", titleOrg, '1 1 1', '16 16 0', 1, 0);
  
  //combat
  gui_renderString("-Movement-", MENU_ORG + '46 40', CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
    gui_renderString("Mouse Sensitivity:", controls_mouse_sense_less.origin - Vector2(stringwidth("Mouse Sensitivity:  ", 0, '12 12'), -1), CLR_DEF_WHITE, '12 12', 1, 0);
    gui_renderString("Invert Mouse:", controls_mouse_invert_off.origin - Vector2(stringwidth("Invert Mouse:  ", 0, '12 12'),-1), CLR_DEF_WHITE, '12 12', 1, 0);
  
  //controls
  gui_renderString("-Combat-", MENU_ORG + '235 40', CLR_DEF_IIF_FRIEND_BLD, '16 16 0', 1, 0);

  //movement
  gui_renderString("-Piloting-", MENU_ORG + '450 40', CLR_DEF_GREEN, '16 16 0', 1, 0);
  
  drawfont = drawfont_prev;
  
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
      localcmd("saveconfig\n");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};