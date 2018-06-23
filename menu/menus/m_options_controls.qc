/*
mech Mod
Author: Peter Roohr
Date: 4/17/2018
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
  menu_keybind_change ("+zoom");
};

// ini function, called by '_f' function as a setup func
void() m_controls_i={
  controls_title = lbl_img('10 50', '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, (UI_FLAG_SIZE_IMG) );
  
  controls_mouse_sense = lbl_text('178 113', '9 9 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, 0);
  controls_mouse_sense.len = cvar("sensitivity");
  controls_mouse_sense.label = strzone(ftos(controls_mouse_sense.len));
  controls_mouse_sense_more = btn_img_callback('204 112', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_sense_more, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_sense_less = btn_img_callback('167 112', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_sense_less, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_sense.len == 1){
    controls_mouse_sense_less.drawme = FALSE;
  }
  else if(controls_mouse_sense.len == 35){
    controls_mouse_sense_more.drawme = FALSE;
  }
  
  controls_mouse_invert = lbl_text('178 125', '9 9 0', " ", CLR_DEF_WHITE, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, 0);
  controls_mouse_invert.len = cvar("m_pitch");
  controls_mouse_invert_on = btn_img_callback('204 124', '8 12', UI_IMG_ARW_RGT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_invert_on, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);
  controls_mouse_invert_off = btn_img_callback('167 124', '8 12', UI_IMG_ARW_LFT, (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, click_control_mouse_invert_off, '1 1 1', '0 1 0', 1, UI_FLAG_NOLABEL);

  if(controls_mouse_invert.len < 0){
    controls_mouse_invert.label = strzone("ON");
    controls_mouse_invert_on.drawme = FALSE;
  }
  else{
    controls_mouse_invert.label = strzone("OFF");
    controls_mouse_invert_off.drawme = FALSE;
  }
  
  //combat
  controls_target = inp_keybindfield('167 138', '10 10 0', txt_control_bind_target, "impulse 7", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_fire_group = inp_keybindfield('167 149', '10 10 0', txt_control_bind_fire, "+attack", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
   
  controls_fire_group1 = inp_keybindfield('167 162', '10 10 0', txt_control_bind_fire_grp1, "+button3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group2 = inp_keybindfield('167 174', '10 10 0', txt_control_bind_fire_grp2, "+button4", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group3 = inp_keybindfield('167 186', '10 10 0', txt_control_bind_fire_grp3, "+button5", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_fire_group4 = inp_keybindfield('167 198', '10 10 0', txt_control_bind_fire_grp4, "+button6", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_fire_group5 = inp_keybindfield('167 210', '10 10 0', txt_control_bind_fire_grp5, "+button7", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  
  controls_group_next = inp_keybindfield('167 221', '10 10 0', txt_control_bind_grp_nxt, "impulse 4", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_group_prev = inp_keybindfield('167 233', '10 10 0', txt_control_bind_grp_prv, "impulse 5", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group1 = inp_keybindfield('167 245', '10 10 0', txt_control_bind_sel_grp1, "impulse 1", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group2 = inp_keybindfield('167 257', '10 10 0', txt_control_bind_sel_grp2, "impulse 2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group3 = inp_keybindfield('167 269', '10 10 0', txt_control_bind_sel_grp3, "impulse 3", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_select_group4 = inp_keybindfield('167 281', '10 10 0', txt_control_bind_sel_grp4, "impulse 23", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_select_group5 = inp_keybindfield('167 293', '10 10 0', txt_control_bind_sel_grp5, "impulse 24", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  
  //movement
  controls_forward = inp_keybindfield('515 213', '10 10 0', txt_control_bind_forward, "+forward", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_backward = inp_keybindfield('515 225', '10 10 0', txt_control_bind_backward, "+back", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_left = inp_keybindfield('515 237', '10 10 0', txt_control_bind_strafeleft, "+moveleft", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_strafe_right = inp_keybindfield('515 249', '10 10 0', txt_control_bind_straferight, "+moveright", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_sprint = inp_keybindfield('515 261', '10 10 0', txt_control_bind_sprint, "+speed", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  
  //piloting
  controls_radar = inp_keybindfield('515 113', '10 10 0', txt_control_bind_radar, "impulse 8", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_navs = inp_keybindfield('515 125', '10 10 0', txt_control_bind_nav, "impulse 9", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_objectives = inp_keybindfield('515 137', '10 10 0', txt_control_bind_obj, "impulse 25", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
 
  controls_repair = inp_keybindfield('515 149', '10 10 0', txt_control_bind_repair, "impulse 26", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_team = inp_keybindfield('515 161', '10 10 0', txt_control_bind_chat_team, "messagemode2", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));

  controls_chat_all = inp_keybindfield('515 173', '10 10 0', txt_control_bind_chat_all, "messagemode", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  
  controls_zoom = inp_keybindfield('515 185', '10 10 0', txt_control_bind_zoom, "+zoom", M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
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
  gui_renderString("[- CONTROLS -] Click on a key to change it", gui_percentToPixelRawVec('75 85'), '1 1 1', '10 10 0', 1, 0);
  
  //combat
  gui_renderString("COMBAT", gui_percentToPixelRawVec('116 100'), CLR_DEF_ARM_THREEQ, '9 9 0', 1, 0);
    gui_renderString("Mouse Sensitiy :", gui_percentToPixelRawVec('34 114'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Invert Mouse :", gui_percentToPixelRawVec('50 126'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Target :", gui_percentToPixelRawVec('98 138'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Select Group :", gui_percentToPixelRawVec('10 150'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 1 :", gui_percentToPixelRawVec('50 162'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 2 :", gui_percentToPixelRawVec('50 174'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 3 :", gui_percentToPixelRawVec('50 186'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 4 :", gui_percentToPixelRawVec('50 198'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 5 :", gui_percentToPixelRawVec('50 210'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Next Weapon Group :", gui_percentToPixelRawVec('10 222'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Prev Weapon Group :", gui_percentToPixelRawVec('10 234'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 1 :", gui_percentToPixelRawVec('34 246'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 2 :", gui_percentToPixelRawVec('34 258'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 3 :", gui_percentToPixelRawVec('34 270'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 4 :", gui_percentToPixelRawVec('34 282'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 5 :", gui_percentToPixelRawVec('34 294'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  
  //movement
  gui_renderString("MOVEMENT", gui_percentToPixelRawVec('438 206'), CLR_DEF_GREEN, '9 9 0', 1, 0);
    gui_renderString("Forward :", gui_percentToPixelRawVec('439 220'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Backward :", gui_percentToPixelRawVec('431 232'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Strafe Left :", gui_percentToPixelRawVec('407 244'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Strafe Right :", gui_percentToPixelRawVec('399 256'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Engage Sprint :", gui_percentToPixelRawVec('391 268'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  
  //controls
  gui_renderString("PILOTING", gui_percentToPixelRawVec('436 100'), CLR_DEF_IIF_FRIEND_BLD, '9 9 0', 1, 0);
    gui_renderString("Toggle RADAR :", gui_percentToPixelRawVec('398 114'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Show Navs :", gui_percentToPixelRawVec('422 126'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Objectives Display :", gui_percentToPixelRawVec('350 138'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Engage Repair Bay :", gui_percentToPixelRawVec('358 150'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Chat Team :", gui_percentToPixelRawVec('422 162'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Chat All :", gui_percentToPixelRawVec('430 174'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Optical Zoom :", gui_percentToPixelRawVec('398 186'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    
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
      cmd("saveconfig");
      menu_clear_items(M_STATE);
      M_STATE = M_OPTIONS;
      m_options_f();
      break;
  }
};