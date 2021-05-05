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

string TRAINING_LABEL;

//Main Menu Constants
float NEWGAME_CAMPAIGN = 1;
float NEWGAME_SKILL = 2;
float NEWGAME_BRIEF = 3;

string IMG_NEW_TITLE  = "gfx/menu/newgame/new_title.png";
string IMG_NEW_NOVICE  = "gfx/menu/newgame/new_novice.png";
string IMG_NEW_REGULAR  = "gfx/menu/newgame/new_regular.png";
string IMG_NEW_VETERAN = "gfx/menu/newgame/new_veteran.png";
string IMG_NEW_ELITE  = "gfx/menu/newgame/new_elite.png";

float NEWGAME_ROLL_ROK = 1;
float NEWGAME_ROLL_REG = 2;
float NEWGAME_ROLL_VET = 3;
float NEWGAME_ROLL_ACE = 4;


//Campaign Maps
float TRAIN_MAP_LIST_TOTAL;
entity new_camp_lbl;
entity new_camp_train_lbl;
entity new_camp_train_btn;
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
  }
};


void() click_newg_launch_map={
  local float mapCount;
  mapCount = 0;
  while( mapCount < TRAIN_MAP_LIST_TOTAL ){
    
  }
  
  menu_write_new_save();
  menu_clear_items(M_STATE);
  menu_exit_togame();
  cmd("deathmatch 0\n");
  cmd("teamplay 0\n");
  cmd("coop 0\n");
  cmd("cd stop\n");
  cmd("maxplayers 1\n");
  cvar_set("cl_ismenu","0");
  cmd(strcat("map ", self.data_text,"\n")); 
  
  freeGlobalString(CAMP_SELECT_START)
  freeGlobalString(CAMP_SELECT_TRAINING)
  freeGlobalString(CAMP_SELECT_NAME)
  freeGlobalString(CAMP_SELECT_MECHS)
  freeGlobalString(CAMP_SELECT_ITEMS)
};

/*
  Sub-Menu: Campaign Briefing
  allow player to skip training here.
*/
//cleans up training maps
void() newgame_clean_train_maps={
  local entity map;
  
  if( CAMP_SELECT_TRAINING != "" ){
    map = findchainfloat( menuId, M_NEWGAME);
    while( map ){
      if( map.classname == "button" && map.subid == NEWGAME_BRIEF ){
        freeGlobalString(map.label);
        freeGlobalString(map.data_text)
      }
      map = map.chain;
    }
  }
};


void() click_newg_info={
  local float mapTotal;
  local float mapCount;
  local entity mapButton;
  
  local vector mapOrg;
  local string subMapName;
  
  newgame_substate = NEWGAME_BRIEF;
  new_camp_lbl.label = CAMP_SELECT_NAME;
  
  if( CAMP_SELECT_TRAINING != "" ){
    mapTotal = tokenizebyseparator(CAMP_SELECT_TRAINING, ",");
  
    if( mapTotal != 0 ){
      new_camp_train_lbl.drawme = TRUE;
    
      mapCount = 0;
      mapOrg = '32 170 0';
      while( mapCount < mapTotal ){
        subMapName = argv(mapCount);
        mapButton = btn_text_callback( mapOrg, '12 12 0', subMapName, 0, M_NEWGAME, click_newg_launch_map, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
        
        mapButton.label = "";
        cacheGlobalString( mapButton.label, newg_format_map(subMapName) )
        cacheGlobalString( mapButton.data_text, subMapName )
        
        mapButton.data_bind = NEWGAME_BRIEF;
        mapButton.subid = NEWGAME_BRIEF;
        if( mapOrg_x < gui_percentXRaw(512) ){
          mapOrg_x = mapOrg_x + stringwidth(mapButton.label, 0, mapButton.size) + gui_percentXRaw(10);
        }
        else{
          mapOrg_y = mapOrg_y + gui_percentYRaw( 14 );
        }
        mapCount = mapCount + 1;
      }
      new_camp_start_lbl.drawme = TRUE;
      new_camp_start_lbl.origin_y = mapOrg_y + gui_percentYRaw(32);
      
      new_camp_start_btn.origin_y = new_camp_start_lbl.origin_y + gui_percentYRaw(16);
    }
  }
  new_camp_start_btn.data_text = CAMP_SELECT_START;
  new_back.origin_y = new_camp_start_btn.origin_y + gui_percentYRaw(48);
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
  new_back.origin = gui_percentToPixelRawVec('10 230 0');
  
  cacheGlobalString(CAMP_SELECT_START, CAMP_START[self.data_bind])
  cacheGlobalString(CAMP_SELECT_NAME, CAMP_NAME[self.data_bind])
  cacheGlobalString(CAMP_SELECT_MECHS, CAMP_MECHS[self.data_bind])
  cacheGlobalString(CAMP_SELECT_ITEMS, CAMP_ITEMS[self.data_bind])
  cacheGlobalString(CAMP_SELECT_TRAINING, CAMP_TRAINING[self.data_bind])
};


void() click_newg_skill={
  newgame_substate = NEWGAME_SKILL;
  newgame_back_cacheOrg = new_back.origin;
  new_back.origin = gui_percentToPixelRawVec('10 230 0');

};

/*
  Game Difficulty Rollovers
*/
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
  local vector start;
  local float itr;
  local float actual;
  local entity list;
  local vector next;
  
  newgame_substate = NEWGAME_CAMPAIGN;
  
  //SUB-MENU: SKILL SELECT
  new_title = lbl_img('10 100', '1 1 0', IMG_NEW_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_NEWGAME, 1, (UI_FLAG_SIZE_IMG) );
  new_novice = btn_img_callback('10 132 0', '1 1 0', IMG_NEW_NOVICE, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_novice, '1 1 1', CLR_DEF_BLUE, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_regular = btn_img_callback('10 151 0', '1 1 0', IMG_NEW_REGULAR, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_regular, '1 1 1', CLR_DEF_GREEN, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_veteran = btn_img_callback('10 170 0', '1 1 0', IMG_NEW_VETERAN, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_veteran, '1 1 1', CLR_DEF_ARM_THREEQ, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
  new_elite = btn_img_callback('10 189 0', '1 1 0', IMG_NEW_ELITE, (VIEW_CTX | VIEW_CTY), M_NEWGAME, click_newg_elite, '1 1 1', CLR_DEF_RED, 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));

  new_novice.subid = NEWGAME_SKILL;
  new_regular.subid = NEWGAME_SKILL;
  new_veteran.subid = NEWGAME_SKILL;
  new_elite.subid = NEWGAME_SKILL;
  
  //SUB-MENU: TRAINING SELECT
  new_camp_lbl = lbl_text('10 132 0', '14 14 0', CAMP_SELECT_NAME, '1 1 1', (VIEW_LFT | VIEW_TOP), M_NEWGAME, 1, 0);
  new_camp_lbl.subid = NEWGAME_BRIEF;
  
  new_camp_train_lbl = lbl_text('10 151 0', '12 12 0', "This Campaign has training maps, New Players are encouraged to play them before the campaign:", CLR_DEF_ARM_THREEQ, (VIEW_LFT | VIEW_TOP), M_NEWGAME, 1, 0);
  new_camp_train_lbl.subid = NEWGAME_BRIEF;
  new_camp_train_lbl.drawme = FALSE;
  
  new_camp_start_lbl = lbl_text('10 151 0', '12 12 0', "Otherwise click START to skip training and begin the game:", CLR_DEF_ARM_THREEQ, (VIEW_LFT | VIEW_TOP), M_NEWGAME, 1, 0);
  new_camp_start_lbl.subid = NEWGAME_BRIEF;
  new_camp_start_lbl.drawme = FALSE;
  
  new_camp_start_btn = btn_text_callback('32 170 0', '14 14 0', "[START CAMPAIGN]", 0, M_NEWGAME, click_newg_launch_map, CLR_DEF_WHITE, CLR_DEF_GREEN, 1, UI_FLAG_SIZE_IMG);
  new_camp_start_btn.subid = NEWGAME_BRIEF;
  new_camp_start_btn.drawme = FALSE;
  new_camp_start_btn.data_text = CAMP_SELECT_START;
  
  //SUB-MENU: CAMPAIGN SELECT
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
  else if( newgame_substate == NEWGAME_BRIEF){
    
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
        newgame_clean_train_maps();
      }
      break;
  }
};