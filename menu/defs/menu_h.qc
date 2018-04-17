/*
  author: Peter Roohr
  date: 04/11/2018
  overview: header for menu system
*/
//MENU GLOBALS
float MOUSE_DOWN;
float DRAW_MOUSE;
float M_STATE;
entity MOUSE_TARGET;
float SUB_MENU; //can only really do 1 sub menu at a time, so

//MENU STATE CONSTANTS
float M_NONE    = 0;
float M_MAIN    = 1;
float M_SINGLE  = 2;
float M_NEWGAME = 3;
float M_LOAD    = 4;
float M_SAVE    = 5;
float M_MULTI   = 6;
float M_SETUP   = 7;
float M_HOST    = 8;
float M_JOIN    = 9;
float M_OPTIONS = 10;
float M_OPTIONS_EFFECT = 11;
float M_OPTIONS_GFX = 12;
float M_OPTIONS_COLOR = 13;
float M_KEYS    = 14;
float M_VIDEO   = 15;
float M_RESET   = 16;
float M_MODS    = 17;
float M_HELP    = 18;
float M_CREDIT  = 19;

string MAPS_COOP[128];
string MAPS_TDM[128];

void(float drawmous) m_drawmouse;

//see /menus/m_main.qc for info on these '_x' functions
void() m_main_i;

void() m_camp_i;
  void() m_newg_i;
  void() m_load_i;

void() m_multi_i;
  void() m_setup_i;
  void() m_host_i;
  void() m_join_i;

void() m_main_f;

void() m_camp_f;
  void() m_newg_f;
  void() m_load_f;

void() m_multi_f;
  void() m_setup_f;
  void() m_host_f;
  void() m_join_f;

void() m_main_d;

void() m_camp_d;
  void() m_newg_d;
  void() m_load_d;

void() m_multi_d;
  void() m_setup_d;
  void() m_host_d;
  void() m_join_d;

void(float ky, float ascii) m_main_k;

void(float ky, float ascii) m_camp_k;
  void(float ky, float ascii) m_newg_k;
  void(float ky, float ascii) m_load_k;
  
void(float ky, float ascii) m_multi_k;
  void(float ky, float ascii) m_setup_k;
  void(float ky, float ascii) m_host_k;
  void(float ky, float ascii) m_join_k;

/*
void() M_Menu_Save;
void() M_Menu_Setup;
void() M_Menu_Options;
void() M_Menu_Options_Effect;
void() M_Menu_Options_Graphics;
void() M_Menu_Options_Colorcontrol;
void() M_Menu_Keys;
void() M_Menu_Video;
void() M_Menu_Reset;
void() M_Menu_Mods;
void() M_Menu_Help;
void() M_Menu_Credits;*/





