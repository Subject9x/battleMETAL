/*
battleMETAL
Author: Peter Roohr
Date: 4/14/2018
Overview:
  menu definition file
  NEW GAME MENU
*/

//Main Menu Globals
entity new_title;
entity new_novice;
entity new_regular;
entity new_veteran;
entity new_elite;
entity new_back;

float newgame_substate;

vector newgame_back_cacheOrg;

string TRAINING_LABEL;

//Main Menu Constants
#define NEWGAME_CAMPAIGN 1
#define NEWGAME_SKILL 2
#define NEWGAME_BRIEF 3

#define IMG_NEW_TITLE "gfx/menu/newgame/new_title.png"

#define NEWGAME_ROLL_ROK 1
#define NEWGAME_ROLL_REG 2
#define NEWGAME_ROLL_VET 3
#define NEWGAME_ROLL_ACE 4


//Campaign Maps
entity new_camp_lbl;
entity new_camp_start_lbl;
entity new_camp_start_btn;


string( string mapName ) newg_format_map={
  local float idx;
  local string a,b;
  
  idx = strstrofs(mapName, "_", 0);
  
  a = substring(mapName, 0, idx);
  b = substring(mapName, idx+1, strlen(mapName) - (idx+1));
  return strcat(a, "-", b);
};


//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_newg_back={
  if( newgame_substate == NEWGAME_SKILL ){
    newgame_substate = NEWGAME_CAMPAIGN;
    new_back.origin = newgame_back_cacheOrg;
  }
  else if( newgame_substate == NEWGAME_BRIEF ){
    newgame_substate = NEWGAME_CAMPAIGN;
    new_back.origin = newgame_back_cacheOrg;
  }
  else{
    menu_clear_items(M_STATE);
    m_newsave_f();
    localsound("sound/misc/menu2.wav");
    cvar_set("cl_newgameplus", "0");
  }
};


void() click_newg_launch_map={  
  
  if( GAME_SAVES_NEWG[cvar("saveslot")] == FALSE ){
    menu_write_new_save();
  }
  
  menu_clear_items(M_STATE);
  menu_exit_togame();
  localcmd("deathmatch 0\n");
  localcmd("teamplay 0\n");
  localcmd("coop 0\n");
  localcmd("cd stop\n");
  localcmd("maxplayers 1\n");
  
  if( GAME_SAVES_NEWG[cvar("saveslot")] ){
    localcmd("map o1m1\n"); 
  }
  else{
    localcmd(strcat("map ", self.data_text,"\n")); 
  }
  
  freeGlobalString(CAMP_SELECT_START)
  freeGlobalString(CAMP_SELECT_INFO)
  freeGlobalString(CAMP_SELECT_NAME)
  freeGlobalString(CAMP_SELECT_MECHS)
  freeGlobalString(CAMP_SELECT_ITEMS)
};

/*
  Sub-Menu: Campaign Briefing
  allow player to skip training here.
*/
void() click_newg_info={
  newgame_substate = NEWGAME_BRIEF;
  new_camp_lbl.label = CAMP_SELECT_NAME;
  
  /*if( CAMP_SELECT_INFO != "" ){
    new_camp_train_lbl.label = CAMP_SELECT_INFO;
    new_camp_train_lbl.drawme = TRUE;
    new_camp_start_lbl.drawme = TRUE;
  }*/
  new_camp_start_btn.data_text = CAMP_SELECT_START;
  new_back.origin_y = new_camp_start_btn.origin_y + 48;
  new_camp_start_btn.drawme = TRUE;
};


void() click_newg_novice={
  cvar_set("skill", "0");
  click_newg_info();
};

void() click_newg_regular={
  cvar_set("skill", "1");
  click_newg_info();
};

void() click_newg_veteran={
  cvar_set("skill", "2");
  click_newg_info();
};

void() click_newg_elite={
  cvar_set("skill", "3");
  click_newg_info();
};

void() click_newg_campaign={
  newgame_substate = NEWGAME_SKILL;
  newgame_back_cacheOrg = new_back.origin;
  new_back.origin =  MENU_ORG + '36 160';
  
  cacheGlobalString(CAMP_SELECT_START, CAMP_START[self.data_bind])
  cacheGlobalString(CAMP_SELECT_NAME, CAMP_NAME[self.data_bind])
  cacheGlobalString(CAMP_SELECT_MECHS, CAMP_MECHS[self.data_bind])
  cacheGlobalString(CAMP_SELECT_ITEMS, CAMP_ITEMS[self.data_bind])
  cacheGlobalString(CAMP_SELECT_INFO, CAMP_INFO[self.data_bind])
};


void() click_newg_skill={
  newgame_substate = NEWGAME_SKILL;
  newgame_back_cacheOrg = new_back.origin;
  new_back.origin = MENU_ORG + '36 160 0';

};

/*
  Game Difficulty Rollovers
*/
void(vector labelOrg) newmgame_text_rookie={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + 100;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "Casual mode - A relaxing romp as a giant robot.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 16', "+ You have extra energy.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 32', "+ AI deals less damage.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 48', "+ AI has less health.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};
void(vector labelOrg) newmgame_text_regular={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + 100;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "First Mech game? Welcome to the genre.",'14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 16', "+ You have slight more energy.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 32', "+ AI deals balanced damage.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 48', "+ AI has balanced health.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 64', "+ Overall a good starting point.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};
void(vector labelOrg) newmgame_text_veteran={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + 100;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "Something of a Mech-pilot yourself, eh?", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 16', "+ You have standard energy amounts.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 32', "+ AI Damage output just a bit under your own.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 48', "+ AI health slightly under yours.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 64', "+ You've played a few other mech games.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};
void(vector labelOrg) newmgame_text_ace={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + 100;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "AWAKE, IRON.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 16', "+ AI mechs equal your own.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 32', "+ AI accuracy is higher.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 48', "+ Additional mission objectives.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + '0 64', "+ can't get enough of battleMETAL's quirks.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};

// ini functions
void() m_newg_i={
  local vector start;
  local float itr;
  local float actual;
  local entity list;
  local vector next;
  
  menu_parent_setup(VIEW_ORG + '0 70', '416 240');
  
  newgame_substate = NEWGAME_CAMPAIGN;
  
  //SUB-MENU: SKILL SELECT
  new_title = lbl_img(MENU_ORG + menu_parent_center_width(5), '1 1 0', IMG_NEW_TITLE, '1 1 1', VIEW_CTX, M_NEWGAME, 1, UI_FLAG_SIZE_IMG );
  
  new_novice = btn_text_callback(MENU_ORG + '16 45', '16 16', "NOVICE", 0, M_NEWGAME, click_newg_novice, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_BLUE, 1, UI_FLAG_SIZE_IMG);
  new_novice.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  new_regular = btn_text_callback(MENU_ORG + '16 64', '16 16', "REGULAR", 0, M_NEWGAME, click_newg_regular, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  new_regular.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  new_veteran = btn_text_callback(MENU_ORG + '16 83', '16 16', "VETERAN", 0, M_NEWGAME, click_newg_veteran, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_ARM_THREEQ, 1, UI_FLAG_SIZE_IMG);
  new_veteran.fontId = FONT_NUM_XOLONIUM_BOLD;
  
  new_elite = btn_text_callback(MENU_ORG + '16 102', '16 16', "ELITE", 0, M_NEWGAME, click_newg_elite, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_RED, 1, UI_FLAG_SIZE_IMG);
  new_elite.fontId = FONT_NUM_XOLONIUM_BOLD;

  new_novice.subid = NEWGAME_SKILL;
  new_regular.subid = NEWGAME_SKILL;
  new_veteran.subid = NEWGAME_SKILL;
  new_elite.subid = NEWGAME_SKILL;
  
  //SUB-MENU: TRAINING SELECT
  new_camp_lbl = lbl_text(MENU_ORG + '10 45', '14 14', CAMP_SELECT_NAME, '1 1 1', 0, M_NEWGAME, 1, 0);
  new_camp_lbl.subid = NEWGAME_BRIEF;
  
  //new_camp_train_lbl = lbl_text(MENU_ORG + '10 64', '12 12', CAMP_SELECT_INFO, CLR_DEF_ARM_THREEQ, 0, M_NEWGAME, 1, 0);
  //new_camp_train_lbl.subid = NEWGAME_BRIEF;
  //new_camp_train_lbl.drawme = FALSE;
  
  new_camp_start_lbl = lbl_text(MENU_ORG + '10 83', '12 12', "Otherwise click START to skip training and begin the game:", CLR_DEF_ARM_THREEQ, 0, M_NEWGAME, 1, 0);
  new_camp_start_lbl.subid = NEWGAME_BRIEF;
  new_camp_start_lbl.drawme = FALSE;
  
  new_camp_start_btn = btn_text_callback(MENU_ORG + menu_parent_center_width(121), '14 14', ">START CAMPAIGN<", VIEW_CTX, M_NEWGAME, click_newg_launch_map, CLR_DEF_TXT_GRAY_SMOOTH, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  new_camp_start_btn.fontId = FONT_NUM_XOLONIUM_BOLD;
  new_camp_start_btn.subid = NEWGAME_BRIEF;
  new_camp_start_btn.drawme = FALSE;
  new_camp_start_btn.data_text = CAMP_SELECT_START;
  
  //SUB-MENU: CAMPAIGN SELECT
  itr = 1;
  if(CAMP_NAME[itr] != ""){
    start = MENU_ORG + '16 59';
    while (itr < CAMP_TOTAL ){
      if( CAMP_NAME[itr] != "" ){
        next = start;
        next_y = next_y + ( (itr-1) * 20);
        list = btn_text_callback(next, '14 14', CAMP_NAME[itr], 0, M_NEWGAME, click_newg_campaign, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
        list.data_bind = itr; //databind
        list.subid = NEWGAME_CAMPAIGN;
        actual = actual + 1;
      }
      itr = itr + 1;
    }
  }
  new_back = btn_text_callback(next + '20 24', '16 16', "BACK", VIEW_CTX, M_NEWGAME, click_newg_back,CLR_DEF_TXT_GRAY_SMOOTH, '0 1 0', 1, UI_FLAG_SIZE_IMG);
  new_back.fontId = FONT_NUM_XOLONIUM_BOLD;
};
/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_newg_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_NEWGAME;
  setkeydest(KEY_MENU);
  m_newg_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_newg_d={
  local entity widget;
  
  gui_renderPatch9_1_32(MENU_ORG, MENU_SIZE, '0.35 0.35 0.55', 0.85, 0);
  
  if( newgame_substate == NEWGAME_SKILL ){
    if( menu_checkMouseInBounds(VIEW_MPOS, MENU_ORG + '10 45', new_novice.drawSize)){
      newmgame_text_rookie(MENU_ORG + '10 45');
    }
    else if( menu_checkMouseInBounds(VIEW_MPOS, MENU_ORG + '10 64', new_regular.drawSize)){
      newmgame_text_regular(MENU_ORG + '10 64');
    }
    else if( menu_checkMouseInBounds(VIEW_MPOS, MENU_ORG + '10 83', new_veteran.drawSize)){
      newmgame_text_veteran(MENU_ORG + '10 83');
    }
    else if( menu_checkMouseInBounds(VIEW_MPOS, MENU_ORG + '10 102', new_elite.drawSize)){
      newmgame_text_ace(MENU_ORG + '10 102');
    }
  }
  else if( newgame_substate == NEWGAME_BRIEF){
    new_camp_start_lbl.origin_y = MENU_ORG_y + gui_wrapText(MENU_ORG + '10 64', '400 300', CAMP_SELECT_INFO, '12 12', CLR_DEF_ARM_THREEQ, 1) + 78;
    //cons_logAFloat
  }
  else{
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
      drawstring(MENU_ORG + '10 40', "Select a Campaign", '14 14', '1 1 1', 1, 0);
    drawfont = drawfont_prev;
  }
  
  for( widget = findchainfloat(menuId, M_NEWGAME); widget != null_entity; widget = widget.chain){
    if( widget.subid == FALSE){
      widget.draw(widget);
    }
    else if( widget.subid == newgame_substate){
      widget.draw(widget);
      if( widget.subid == NEWGAME_CAMPAIGN && widget.data_bind > 0 ){
        
        if( menu_checkMouseInBounds(VIEW_MPOS, widget.drawOrg, widget.drawSize)){
          drawfont_prev = drawfont;
          drawfont = FONT_NUM_ROBOT_REGULAR;
            drawstring(MENU_ORG + '150 40', strcat("Author: ", CAMP_AUTH[widget.data_bind]), '12 12', '1 1 1', 1, 0);
          drawfont = FONT_NUM_ROBOT_LIGHT;
            gui_wrapText(MENU_ORG + '150 54', '350 300', CAMP_DESC[widget.data_bind], '14 14', '1 1 0.1', 1);
          drawfont = drawfont_prev;
        }
      }
    }
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_newg_k={
  switch(key){
    case K_ESCAPE:
      if(newgame_substate == NEWGAME_SKILL){
        newgame_substate = NEWGAME_CAMPAIGN;
        new_back.origin = newgame_back_cacheOrg;
      }
      if(newgame_substate == NEWGAME_BRIEF ){
        newgame_substate = NEWGAME_CAMPAIGN;
        new_back.origin = newgame_back_cacheOrg;
      }
      else{
        localsound("sound/misc/menu2.wav");
        menu_clear_items(M_STATE);
        m_camp_f();
        freeGlobalString(TRAINING_LABEL)
      }
      break;
  }
};