/*
mech Mod
Author: Peter Roohr
Date: 4/15/2018
Overview: host game menu
*/

//constants
float FRAG_MAX = 1000;
float TIME_MAX = 20;
float SUB_COOP = -1;
float SUB_DM = -2;
float NO_SUB = 0;
float SUB_SELECT;

//globals
entity host_title;
entity host_name;
entity host_port;
entity host_gametype;
entity host_playernum;
entity host_public;
entity host_serverrate;

//coop settings
entity host_skill;

//non-coop settings
entity host_dm_fraglim;
entity host_dm_timelim;

entity host_launch;

//images
string IMG_HOST_TITLE = "gfx/menu/host/host_title.png"

//callbacks

void() m_host_i={
  SUB_SELECT = 0;
  load_title = lbl_img('10 100', '1 1 0', IMG_HOST_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_HOST, 1, (UI_FLAG_SIZE_IMG) );
  load_title.subid = NO_SUB;
  
};

void() m_host_f={
  M_STATE = M_HOST;
  setkeydest(KEY_MENU);
  m_host_i();
};

void() m_host_d={

  gui_renderString("[Server Name]", gui_percentToPixelRawVec('10 135'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("[Port Number]", gui_percentToPixelRawVec('10 150'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("[Server Type]", gui_percentToPixelRawVec('10 165'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("[Server Rate]", gui_percentToPixelRawVec('10 180'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("[Max Players]", gui_percentToPixelRawVec('10 195'), '1 1 1', '9 9 0', 1, 0);
  gui_renderString("[Game Type]", gui_percentToPixelRawVec('10 210'), '1 1 1', '9 9 0', 1, 0);

  switch(SUB_SELECT){
    case SUB_COOP:
    
      break;
    
    case SUB_DM:
    
      break;
  }
  
  local entity widget;
  widget = findchainfloat(menuId, M_HOST);
  while(widget){
    if( widget.subid == NO_SUB){
      widget.draw(widget);
    }
    else if( widget.subid = SUB_SELECT ){
      widget.draw(widget);
    }
    widget = widget.chain;
  }

};

void(float key, float ascii) m_host_k={
  cons_logAFloat("m_load_k.key", key);  //DEBUG
  cons_logAFloat("m_load_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      //note how this is different than m_main_k, here we just want to go 'up' one
      //menu and not leave the menu system
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MULTI;
      m_multi_f();
      break;
    case K_MOUSE1:
      m_sys_doclick();
      break;
  }
};