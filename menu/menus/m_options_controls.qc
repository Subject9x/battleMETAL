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
entity controls_mouse_invert;
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

//piloting

//controls constants
string IMG_CONTROLS_TITLE = "gfx/menu/options/options_title.png";

//controls callbacks
void() txt_control_bind_target={
  menu_keybind_change ("impulse 7");
};
void() txt_control_bind_fire={};
void() txt_control_bind_fire_grp1={};
void() txt_control_bind_fire_grp2={};
void() txt_control_bind_fire_grp3={};
void() txt_control_bind_fire_grp4={};
void() txt_control_bind_fire_grp5={};
void() txt_control_bind_grp_nxt={};
void() txt_control_bind_grp_prv={};
void() txt_control_bind_sel_grp1={};
void() txt_control_bind_sel_grp2={};
void() txt_control_bind_sel_grp3={};
void() txt_control_bind_sel_grp4={};
void() txt_control_bind_sel_grp5={};

// ini function, called by '_f' function as a setup func
void() m_controls_i={
  controls_title = lbl_img('10 50', '1 1 0', IMG_CONTROLS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_OPTIONS_CONTROLS, 1, (UI_FLAG_SIZE_IMG) );
  //combat
  controls_target = inp_keybindfield('183 138', '10 10 0', txt_control_bind_target, 0, M_OPTIONS_CONTROLS, CLR_DEF_WHITE, CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_TXTFIELD_NUM | UI_FLAG_TXTFIELD_SPEC | UI_FLAG_TXTFIELD_LOW | UI_FLAG_TXTFIELD_MOUSE | UI_FLAG_TXTFIELD_FUNC));
  controls_target.label = strzone(menu_keybind_forkey("impulse 7"));
  //movement
  
  
  //piloting
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
  gui_renderString("[- CONTROLS -]", gui_percentToPixelRawVec('75 85'), '1 1 1', '10 10 0', 1, 0);
  
  //combat
  gui_renderString("COMBAT", gui_percentToPixelRawVec('116 100'), CLR_DEF_ARM_THREEQ, '9 9 0', 1, 0);
    gui_renderString("Mouse Sensitiy  :", gui_percentToPixelRawVec('34 114'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Invert Mouse  :", gui_percentToPixelRawVec('50 126'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Target  :", gui_percentToPixelRawVec('98 138'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Select Group  :", gui_percentToPixelRawVec('10 150'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 1  :", gui_percentToPixelRawVec('50 162'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 2  :", gui_percentToPixelRawVec('50 174'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 3  :", gui_percentToPixelRawVec('50 186'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 4  :", gui_percentToPixelRawVec('50 198'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Fire Group 5  :", gui_percentToPixelRawVec('50 210'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Next Weapon Group  :", gui_percentToPixelRawVec('10 222'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Prev Weapon Group  :", gui_percentToPixelRawVec('10 234'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 1  :", gui_percentToPixelRawVec('34 246'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 2  :", gui_percentToPixelRawVec('34 258'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 3  :", gui_percentToPixelRawVec('34 270'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 4  :", gui_percentToPixelRawVec('34 282'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Select Group 5  :", gui_percentToPixelRawVec('34 294'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  
  //movement
  gui_renderString("MOVEMENT", gui_percentToPixelRawVec('463 200'), CLR_DEF_GREEN, '9 9 0', 1, 0);
    gui_renderString("Forward  :", gui_percentToPixelRawVec('455 214'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Backward   :", gui_percentToPixelRawVec('439 224'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Strafe Left  :", gui_percentToPixelRawVec('423 234'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Strafe Right  :", gui_percentToPixelRawVec('415 244'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Engage Sprint  :", gui_percentToPixelRawVec('407 254'), CLR_DEF_WHITE, '8 8 0', 1, 0);
  
  //controls
  gui_renderString("PILOTING", gui_percentToPixelRawVec('460 100'), CLR_DEF_IIF_FRIEND_BLD, '9 9 0', 1, 0);
    gui_renderString("Toggle RADAR  :", gui_percentToPixelRawVec('414 114'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Toggle Show Navs  :", gui_percentToPixelRawVec('382 124'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Toggle Objectives Display  :", gui_percentToPixelRawVec('310 134'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Engage Repair Bay  :", gui_percentToPixelRawVec('374 144'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Chat Team :", gui_percentToPixelRawVec('446 154'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    gui_renderString("Chat All :", gui_percentToPixelRawVec('454 165'), CLR_DEF_WHITE, '8 8 0', 1, 0);
    
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
  cons_logAFloat("m_controls_k.key", key);  //DEBUG
  cons_logAFloat("m_controls_k.ascii", ascii);  //DEBUG   
  
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