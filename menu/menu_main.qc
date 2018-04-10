/*
  author: Peter Roohr
  date: 11/26/2017
  
  overview: what is a menu.dat? time to explore and find out
*/

void() m_init={

};

void(float keynr, float ascii) m_keydown={
  local string key;
  
  print(strcat(ftos(keynr),":", keynumtostring(keynr),"\n"));
  
};

void(float width, float height) m_draw={
  
};

void(float mode) m_toggle={
  print(strcat("m_toggle:mode : ", ftos(mode),"\n"));
};

void() m_shutdown={

};

void() m_main_menu={
    bprint("Main menu, turkey");
};

void() menu_singleplayer={};
void() menu_load={};
void() menu_save={};
void() menu_multiplayer={};
void() menu_setup={};
void() menu_options={};
void() menu_options_effect={};
void() menu_options_graphics={};
void() menu_options_colorcontrol={};
void() menu_keys={};
void() menu_video={};
void() menu_reset={};
void() menu_mods={};
void() help={};
void() menu_credits={};


