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

float newgame_rollover;

float newgame_substate;

vector newgame_back_cacheOrg;

//Main Menu Constants
float NEWGAME_CAMPAIGN = 1;
float NEWGAME_SKILL = 2;

string IMG_NEW_TITLE  = "gfx/menu/newgame/new_title.png";
string IMG_NEW_NOVICE  = "gfx/menu/newgame/new_novice.png";
string IMG_NEW_REGULAR  = "gfx/menu/newgame/new_regular.png";
string IMG_NEW_VETERAN = "gfx/menu/newgame/new_veteran.png";
string IMG_NEW_ELITE  = "gfx/menu/newgame/new_elite.png";

float NEWGAME_ROLL_ROK = 1;
float NEWGAME_ROLL_REG = 2;
float NEWGAME_ROLL_VET = 3;
float NEWGAME_ROLL_ACE = 4;
//button callbacks
//because we define these right before the menu functions are defined, we 
//don't have to put them in a header, and they can be 'somewhat' flexibily generated
void() click_newg_back={
  if( newgame_substate == NEWGAME_SKILL ){
    newgame_substate = NEWGAME_CAMPAIGN;
    new_back.origin = newgame_back_cacheOrg;
  }
  else{
    menu_clear_items(M_STATE);
    m_newsave_f();
    localsound("sound/misc/menu2.wav");
  }
};

void() click_newg_launch={
  menu_write_new_save(CAMP_SELECT_MAP, "...", "...", CAMP_SELECT_NAME);
  menu_clear_items(M_STATE);
  cmd("deathmatch 0\n");
  cmd("coop 0\n");
  cmd("cd stop\n");
  menu_exit_togame();
  cmd("map", strcat(" ", CAMP_SELECT_MAP,"\n"));
  strunzone(CAMP_SELECT_MAP);
  strunzone(CAMP_SELECT_NAME);
};

void() click_newg_novice={
  cvar_set("skill", "0");
  click_newg_launch();
};

void() click_newg_regular={
  cvar_set("skill", "1");
  click_newg_launch();
};

void() click_newg_veteran={
  cvar_set("skill", "2");
  click_newg_launch();
};

void() click_newg_elite={
  cvar_set("skill", "3");
  click_newg_launch();
};

void() click_newg_campaign={
  newgame_substate = NEWGAME_SKILL;
  newgame_back_cacheOrg = new_back.origin;
  new_back.origin = gui_percentToPixelRawVec('10 230 0');
  if(CAMP_SELECT_MAP != "" ){
    strunzone(CAMP_SELECT_MAP);
  }
  CAMP_SELECT_MAP = strzone(CAMP_MAP[self.data_bind]);

  if(CAMP_SELECT_NAME != "" ){
    strunzone(CAMP_SELECT_NAME);
  }
  CAMP_SELECT_NAME = strzone(CAMP_NAME[self.data_bind]);
};

void(vector labelOrg) newmgame_text_rookie={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + gui_percentXRaw(100);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "Casual mode - A relaxing romp as a giant robot.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 16'), "+ You have extra energy.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 32'), "+ AI deals less damage.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 48'), "+ AI has less health.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};
void(vector labelOrg) newmgame_text_regular={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + gui_percentXRaw(100);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "First Mech game? Welcome to the genre.",'14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 16'), "+ You have slight more energy.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 32'), "+ AI deals balanced damage.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 48'), "+ AI has balanced health.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 64'), "+ Overall a good starting point.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};
void(vector labelOrg) newmgame_text_veteran={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + gui_percentXRaw(100);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "Something of a Mech-pilot yourself, eh?", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 16'), "+ You have standard energy amounts.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 32'), "+ AI Damage output just a bit under your own.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 48'), "+ AI health slightly under yours.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 64'), "+ You've played a few other mech games.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};
void(vector labelOrg) newmgame_text_ace={
  local vector thisOrg;
  
  thisOrg = labelOrg;
  thisOrg_x = thisOrg_x + gui_percentXRaw(100);
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  drawstring(thisOrg, "AWAKE, IRON.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 16'), "+ AI mechs equal your own.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 32'), "+ AI accuracy is higher.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 48'), "+ Additional mission objectives.", '14 14 0', '1 1 0.1', 1, 0);
  drawstring(thisOrg + gui_percentToPixelRawVec('0 64'), "+ can't get enough of battleMETAL's quirks.", '14 14 0', '1 1 0.1', 1, 0);
  
  drawfont = drawfont_prev;
};

// ini functions
void() m_newg_i={
  
  newgame_substate = NEWGAME_CAMPAIGN;
  
  new_title = lbl_img('10 100', '1 1 0', IMG_NEW_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_NEWGAME, 1, (UI_FLAG_SIZE_IMG) );
  new_novice = btn_img_callback('10 132 0', '1 1 0', IMG_NEW_NOVICE, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_novice, '1 1 1', CLR_DEF_BLUE, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_regular = btn_img_callback('10 151 0', '1 1 0', IMG_NEW_REGULAR, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_regular, '1 1 1', CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_veteran = btn_img_callback('10 170 0', '1 1 0', IMG_NEW_VETERAN, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_veteran, '1 1 1', CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_elite = btn_img_callback('10 189 0', '1 1 0', IMG_NEW_ELITE, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_elite, '1 1 1', CLR_DEF_RED, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));

  new_novice.subid = NEWGAME_SKILL;
  new_regular.subid = NEWGAME_SKILL;
  new_veteran.subid = NEWGAME_SKILL;
  new_elite.subid = NEWGAME_SKILL;
  
  local vector start;
  local float itr;
  local float actual;
  local entity list;
  local vector next;
  
  itr = 1;
  
  if(CAMP_NAME[itr] != ""){
    start = gui_percentToPixelRawVec('10 151 0');
    while (itr < CAMP_TOTAL ){
      if( CAMP_NAME[itr] != "" ){
        next = start;
        next_y = next_y + ( (itr-1) * 20);
        list = btn_text_callback(next, '14 14 0', CAMP_NAME[itr], 0, M_NEWGAME, click_newg_campaign, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
        list.data_bind = itr; //databind
        list.subid = NEWGAME_CAMPAIGN;
        actual = actual + 1;
      }
      itr = itr + 1;
    }
  }
  new_back = btn_img_callback(next + gui_percentToPixelRawVec('0 24 0'), '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG)); 
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
            drawstring(gui_percentToPixelRawVec('150 151 0'), strcat("Author: ", CAMP_AUTH[widget.data_bind]), '12 12', '1 1 1', 1, 0);
            gui_wrapText(gui_percentToPixelRawVec('150 165 0'), gui_percentToPixelRawVec('300 300 0'), CAMP_DESC[widget.data_bind], '14 14', '1 1 0.1', 1);
          drawfont = drawfont_prev;
        }
      }
    }
  }
  
  if( newgame_substate == NEWGAME_SKILL ){
    if( menu_checkMouseInBounds(VIEW_MPOS, '10 132 0', new_novice.drawSize)){
      newmgame_text_rookie('10 132 0');
    }
    else if( menu_checkMouseInBounds(VIEW_MPOS, '10 151 0', new_regular.drawSize)){
      newmgame_text_regular('10 151 0');
    }
    else if( menu_checkMouseInBounds(VIEW_MPOS, '10 170 0', new_veteran.drawSize)){
      newmgame_text_veteran('10 170 0');
    }
    else if( menu_checkMouseInBounds(VIEW_MPOS, '10 189 0', new_elite.drawSize)){
      newmgame_text_ace('10 189 0');
    }
  }
  else{
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
      drawstring(gui_percentToPixelRawVec('10 132 0'), "Select a Campaign to play:", '14 14', '1 1 1', 1, 0);
    drawfont = drawfont_prev;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_newg_k={
  //cons_logAFloat("m_newg_k.key", key);  //DEBUG
  //cons_logAFloat("m_newg_k.ascii", ascii);  //DEBUG
  
  switch(key){
    case K_ESCAPE:
      if(newgame_substate == NEWGAME_SKILL){
        newgame_substate = NEWGAME_CAMPAIGN;
        new_back.origin = newgame_back_cacheOrg;
      }
      else{
        localsound("sound/misc/menu2.wav");
        menu_clear_items(M_STATE);
        m_camp_f();
      }
      break;
  }
};