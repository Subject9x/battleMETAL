/*
battleMETAL
Author: Peter Roohr
Date: 12/20/2019
Overview: 
  Help Menu file
    + getting started
    + options
    + UI explain
      -> Briefing
      -> Hangar
      -> Arming
      -> Deployment
*/

//m_help GLOBALS
entity help_title;
entity help_back;
entity help_starting;
entity help_options;
entity help_menus_briefing;
entity help_menus_hangar;
entity help_menus_arming;
entity help_menus_deploy;
//entity help_menus_hud;

entity help_start_overview;
entity help_start_contact;

entity help_config_overview;
entity help_config_adv;

entity help_briefing_img;
entity help_briefing_title;
entity help_briefing_text;

entity help_hangar_img;
entity help_hangar_title;
entity help_hangar_text;

entity help_arming_img;
entity help_arming_title;
entity help_arming_text;

entity help_deploy_img;
entity help_deploy_title;
entity help_deploy_text;

//entity help_hud_img;
//entity help_hud_title;
//entity help_hud_text;

float HELP_MENU_CHOICE;

//m_help CONSTANTS
#define HELP_MENU_MAIN 1
#define HELP_MENU_BRIEF 2
#define HELP_MENU_HANGAR 3
#define HELP_MENU_ARMING 4
#define HELP_MENU_DEPLOY 5
#define HELP_MENU_START 6
#define HELP_MENU_CONFIG 7
//#define HELP_MENU_HUD 8

string IMG_HELP_TITLE = "gfx/menu/help/help_title.png";

//m_help functions
void() click_help_back={
  menu_clear_items(M_STATE);
  M_STATE = M_MAIN;
  m_main_f();
};

void() click_help_start={
  HELP_MENU_CHOICE = HELP_MENU_START;
  menu_parent_setup(VIEW_ORG + '0 40', '512 336');
};

void() click_help_options={
  HELP_MENU_CHOICE = HELP_MENU_CONFIG;
  menu_parent_setup(VIEW_ORG + '0 40', '512 368');
};

void() click_help_enter_briefing={
  HELP_MENU_CHOICE = HELP_MENU_BRIEF;
  menu_parent_setup(VIEW_ORG + '0 40', '512 432');
};

void() click_help_enter_hangar={
  HELP_MENU_CHOICE = HELP_MENU_HANGAR;
  menu_parent_setup(VIEW_ORG + '0 40', '512 432');
};

void() click_help_enter_arming={
  HELP_MENU_CHOICE = HELP_MENU_ARMING;
  menu_parent_setup(VIEW_ORG + '0 40', '512 432');
};

void() click_help_enter_deploy={
  HELP_MENU_CHOICE = HELP_MENU_DEPLOY;
  menu_parent_setup(VIEW_ORG + '0 40', '512 432');
};

//void() click_help_enter_hud={
//  HELP_MENU_CHOICE = HELP_MENU_HUD;
//};

//api
void() m_help_f={
  DRAW_MOUSE = TRUE;
  HELP_MENU_CHOICE = HELP_MENU_MAIN;
  setkeydest(KEY_MENU);
  m_help_i();
};

void() m_help_i={
  menu_parent_setup(VIEW_ORG + '0 40', '208 224');
  
  help_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_HELP_TITLE, '1 1 1', VIEW_CTX, M_HELP, 1, UI_FLAG_SIZE_IMG );
  
  help_back = btn_text_callback(MENU_ORG + '45 197', '16 16', "BACK", 0, M_HELP, click_help_back, CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  help_back.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  //sub menus
    //main help
    help_starting = btn_text_callback( MENU_ORG + '10 45', '16 16', "Getting Started", 0, M_HELP, click_help_start, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    help_starting.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    help_options = btn_text_callback(MENU_ORG + '10 64', '16 16', "Config", 0, M_HELP, click_help_options, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    help_options.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    help_menus_briefing = btn_text_callback(MENU_ORG + '10 83', '16 16', "Briefing Menu", 0, M_HELP, click_help_enter_briefing, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    help_menus_briefing.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    help_menus_hangar = btn_text_callback(MENU_ORG + '10 102', '16 16', "Hangar Menu", 0, M_HELP, click_help_enter_hangar, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    help_menus_hangar.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    help_menus_arming = btn_text_callback(MENU_ORG + '10 121', '16 16', "Arming Menu", 0, M_HELP, click_help_enter_arming, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    help_menus_arming.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    help_menus_deploy = btn_text_callback(MENU_ORG + '10 140', '16 16', "Deploy Menu", 0, M_HELP, click_help_enter_deploy, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    help_menus_deploy.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    //help_menus_hud = btn_text_callback(MENU_ORG + '10 159', '14 14', "Sample Mech HUD", 0, M_HELP, click_help_enter_hud, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
    //help_menus_hud.fontId = FONT_NUM_XOLONIUM_BOLD;
    
    //Starting
    help_start_overview = text_panel(MENU_ORG + '144 45', '320 100', "GETTING STARTED | To launch a new game, simply do Main Menu -> Campaign -> New Game -> then choose a Save Slot. | battleMETAL uses numbered Save Slots to save your progress during gameplay. | | You can run the Training map at any time from the Main Menu to refresh yourself on the gameplay. | | To load an existing saved game, simply go Main Menu -> Campaign -> Load. | | Mission Menus | During a mission, you will interact with 4 primary menus before you launch into the action. | In this HELP section, there's an overview for each Menu to assist you in navigating them. | Further helpful info can be found using the tooltips on each menu, look for the golden box with the question mark [?] and roll your mouse over it.", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    help_start_contact = text_panel(MENU_ORG + '144 288', '320 100', "HELP AND RESOURCES | | Bug Reports:  send email to battleMETAL.qa@gmail.com | | Website:  http://battleMETAL.net | | Source Code:  https://github.com/Subject9x/battleMETAL", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    
    //Config
    help_config_overview = text_panel(MENU_ORG + '144 45', '320 100', "Here is a quick index of all the configuration you may adjust for your install of battleMETAL. | | CONTROLS (Main->Options->Controls) + Configure any and all in-game keybindings. + Change a binding by clicking a key, which will then go ORANGE, press the new key and you're all set. | | GRAPHICS (Main->Options->GRAPHICS) + Adjust all the game's graphical settings in this set of menus. + Clicking ACCEPT will immediately apply and save the settings you changed. | | AUDIO (Main->Options->Audio) + Adjust Audio settings for the game here. + You can ONLY change the ADVANCED settings from the Main Menu. + Advanced Settings may auto adjust your Speaker Mode based on what it detects.", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    help_config_adv = text_panel(MENU_ORG + '144 250', '320 100', "ADVANCED SETTINGS | + You can bring down the Developer Console at any time using the tilde ` key. + All your config settings are saved to the file battleMETAL/metaldata/config.cfg + You can add your own custom config at game startup by modifying either the battleMETAL/metaldata/default.cfg OR /autoexec.cfg files.", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    
    //Briefing
    help_briefing_img = lbl_img(MENU_ORG + '172.5 5', gui_newAspectRatio(drawgetimagesize("gfx/menu/help/help_brief.png"), UI_MAX) * 0.45,  "gfx/menu/help/help_brief.png", '1 1 1', 0, M_HELP, 1, 0 );
    help_briefing_title = lbl_text(MENU_ORG + '144 260', '14 14', "The Briefing Screen", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    help_briefing_text = text_panel(MENU_ORG + '144 275', '320 100', "This menu is the first of 4 screens when you start a new Mission. This menu gives you background, context, and mission objectives for the upcoming operation. | + (A) Insight into expected environment and lighting factors. + (B) Some missions will provide an animated briefing for further detail, activated by pressing this button. + (C) This section contains full briefing text, giving you important context for this mission concerning enemy state, and the war situation. + (D) Tactical Map with Nav markers, this will give you an idea of the mission zone and location of points of interest.  + (E): Objectives and Intel - This panel gives you the list of Objectives you must complete to win the mission. The INTEL button will give you recommendations on mech selection and weapons, and what kind of enemies you might encounter.", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_HELP, 1, 0);
    
    //Hangar
    help_hangar_img = lbl_img(MENU_ORG + '172.5 5', gui_newAspectRatio(drawgetimagesize("gfx/menu/help/help_hangar.png"), UI_MAX) * 0.45 , "gfx/menu/help/help_hangar.png", '1 1 1', 0, M_HELP, 1, 0 );
    help_hangar_title = lbl_text(MENU_ORG + '144 260', '14 14', "The Hangar Screen", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    help_hangar_text = text_panel(MENU_ORG + '144 275', '368 100', "The next screen after the Briefing, this menu is for choosing the mech you will pilot in the upcoming Mission. The available mechs are based on the mechs you've unlocked so far in your campaign. + (A) List of unlocked mechs for you to choose. + (B) Hard stats. Every mech has these stats, though not all mechs are made equally. Speed, Energy, Shields, Armor, and Radar range are generally different per-mech. + (C) Database information. This panel gives a short historical description of the selected mech, as well as a short overview of the mech's tactical role. + (D) Hardpoint layout. Your mech has a limited number of hardpoints for mounting weapons and equipment. This diagram is a preview of the selected mech's hardpoints, their max weapon size, and the allowable weapon types - Energy, Ballistic, Missile, and Modules.", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_HELP, 1, 0);
    
    //Arming
    help_arming_img = lbl_img(MENU_ORG + '172.5 5', gui_newAspectRatio(drawgetimagesize("gfx/menu/help/help_arming.png"), UI_MAX) * 0.45, "gfx/menu/help/help_arming.png", '1 1 1', 0, M_HELP, 1, 0 );
    help_arming_title = lbl_text(MENU_ORG + '144 260', '14 14', "The Arming Screen", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    help_arming_text = text_panel(MENU_ORG + '144 275', '368 100', "Arming is where you now load your selected mech with weapons and equipment. + (A) Hardpoint Layout - you can drag-and-drop items from (F) onto hardpoints IF the hardpoint can accept the weapon. + (B) You are allowed 6 unique LOADOUTS for every mech type, these are saved automatically when you toggle between them. + (C) Weapon Groups - To Fire weapons, they must be grouped into at least 1 of 5 weapon groups. You are free to mix and match weapons as needed. Check the Key Config for firing modes. + (D) Energy Cost - projects the TOTAL energy cost that each Weapon Group will have on your mech's Energy level. + (E) Weapons Comparison - by clicking on a hardpoint THEN on a Weapon from the List, you can compare the stats for each weapon. + (F) Weapons available to you. When selecting a Hardpoint, VALID weapons will glow brighter.", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_HELP, 1, 0);
    
    //Deployment
    help_deploy_img = lbl_img(MENU_ORG + '172.5 5', gui_newAspectRatio(drawgetimagesize("gfx/menu/help/help_deploy.png"), UI_MAX) * 0.45, "gfx/menu/help/help_deploy.png", '1 1 1', 0, M_HELP, 1, 0 );
    help_deploy_title = lbl_text(MENU_ORG + '144 260', '14 14', "The Deploy Screen", CLR_DEF_TXT_HIGHLIGHT, 0, M_HELP, 1, 0);
    help_deploy_text = text_panel(MENU_ORG + '144 275', '320 100', "Final screen before entering a mission, here you will choose your Deploy Point. + (A) Last minute data about the mission before you launch. + (B) Choose your Deploy Point. This will determine WHERE you start in the mission, once you have chosen a point, the LAUNCH button will light up! + (C) Last minute reminder of WHICH selected mech you will be piloting in the mission. + (D) Map Key - defines the meaning of various map points of interest, such as hazards, or enemy bases. + (E) Tactical Map - just like the Briefing screen. A YELLOW line will show you which Deploy Point you have SELECTED. ", CLR_DEF_TXT_GRAY_SMOOTH, 0, M_HELP, 1, 0);
    
    //HUD
    
    //sub menu wiring
    help_start_overview.subid = HELP_MENU_START;
    help_start_contact.subid = HELP_MENU_START;
    
    help_config_overview.subid = HELP_MENU_CONFIG;
    help_config_adv.subid = HELP_MENU_CONFIG;
    
    help_briefing_img.subid = HELP_MENU_BRIEF;
    help_briefing_title.subid = HELP_MENU_BRIEF;
    help_briefing_text.subid = HELP_MENU_BRIEF;
    
    help_hangar_img.subid = HELP_MENU_HANGAR;
    help_hangar_title.subid = HELP_MENU_HANGAR;
    help_hangar_text.subid = HELP_MENU_HANGAR;
    
    help_arming_img.subid = HELP_MENU_ARMING;
    help_arming_title.subid = HELP_MENU_ARMING;
    help_arming_text.subid = HELP_MENU_ARMING;  
    
    help_deploy_img.subid = HELP_MENU_DEPLOY;
    help_deploy_title.subid = HELP_MENU_DEPLOY;
    help_deploy_text.subid = HELP_MENU_DEPLOY;

    //help_hud_img.subid = HELP_MENU_HUD;
    //help_hud_title.subid = HELP_MENU_HUD;
    //help_hud_text.subid = HELP_MENU_HUD;
};

void() m_help_d={
  local entity widget;
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  if( HELP_MENU_CHOICE > 1 ){
    gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  }
  
  for( widget = findchainfloat(menuId, M_HELP); widget != null_entity; widget = widget.chain){
    if( widget.subid == FALSE){
      widget.draw(widget);
    }
    else if( widget.subid == HELP_MENU_CHOICE){
      widget.draw(widget);
    }
  }
};

void(float ky, float ascii) m_help_k={
  switch(ky){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};