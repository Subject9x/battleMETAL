/*
  author: Peter Roohr
  date: 04/11/2018
  
  overview: header for menu system
*/
//MENU GLOBALS
float DRAW_MOUSE;
.string classname;

//MENU STATE CONSTANTS
float M_STATE;
float M_NONE = 0;
float M_MAIN = 1;
float M_SINGLE = 2;
float M_LOAD = 3;
float M_SAVE = 4;
float M_MULTI = 5;
float M_SETUP = 6;
float M_OPTIONS = 7;
float M_OPTIONS_EFFECT = 8;
float M_OPTIONS_GFX = 9;
float M_OPTIONS_COLOR = 10;
float M_KEYS = 11;
float M_VIDEO = 12;
float M_RESET = 13;
float M_MODS = 14;
float M_HELP = 15;
float M_CREDIT = 16;

void(float drawmous) m_drawmouse;

//see /menus/m_main.qc for info on these '_x' functions
void() m_main_f;

void() m_main_d;

void(float ky, float ascii) m_main_k;

/*void() M_Menu_Singleplayer;
void() M_Menu_Load;
void() M_Menu_Save;
void() M_Menu_Multiplayer;
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





