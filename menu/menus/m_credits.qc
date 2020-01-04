/*
battleMETAL
Author: Peter Roohr
Date: 4/17/2018
mod: 07/19/2019
Overview: 
  credits menu class file.
  + Personnel Credits

  + Website Credits
    -> iD Software
    -> LordHavoc / Darkplaces
    -> InsideQC
    -> QuakeOne
    -> Trenchbroom / Krsistian Duske
  +Info Links
    -> game website
    -> 
*/

//credits Globals
entity credits_title;
entity credits_back;

//credits constants
string IMG_CREDITS_TITLE = "gfx/menu/help/credits_title.png";

//credits callbacks
void() click_credits_back={
  menu_clear_items(M_STATE);
  m_main_f();
};

// ini function, called by '_f' function as a setup func
void() m_credits_i={
  credits_title = lbl_img('10 30', '1 1 0', IMG_CREDITS_TITLE, '1 1 1', (VIEW_CTX | VIEW_CTY), M_CREDITS, 1, (UI_FLAG_SIZE_IMG) );
  credits_back = btn_img_callback('10 81 0', '1 1 0', IMG_BTN_BACK, (VIEW_CTX | VIEW_CTY), M_CREDITS, click_credits_back, '1 1 1', '0 1 0', 1, (UI_FLAG_NOLABEL | UI_FLAG_SIZE_IMG));
};

/*
  menu_f functions are like state-transition functions, preparing the menu for the next menu to load
*/
void() m_credits_f={
  DRAW_MOUSE = TRUE;
  M_STATE = M_CREDITS;
  setkeydest(KEY_MENU);
  m_credits_i();
};

/*
  menu_d functions are the render functions, inside m_draw, there's a select case
  running on M_STATE to determine which menu_d to execute.
*/
void() m_credits_d={
  local float centerLineX;
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  centerLineX = gui_percentXRaw(180);
  
  local float menuTitleLen;
  local vector menuTitleOrg;
  menuTitleLen = stringwidth( "battleMETAL Design Team", 0, '16 16 0');
  menuTitleOrg_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( menuTitleLen / 2);
  menuTitleOrg_y = gui_percentYRaw(100);
  
  gui_renderString("battleMETAL Design Team", menuTitleOrg, CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
  
  local float leadTitleLen;
  local vector leadTitleOrg;
  leadTitleLen = stringwidth( "Producer | Lead Coder | Principal Artist | Level Designer | Game Designer", 0, '12 12 0');
  leadTitleOrg_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( leadTitleLen / 2);
  leadTitleOrg_y = gui_percentYRaw(119);
  gui_renderString("Producer | Lead Coder | Principal Artist | Level Designer | Game Designer", leadTitleOrg, CLR_DEF_IIF_FRIEND_BLD, '12 12 0', 1, 0);
   
    local float authorLen;
    local vector authorOrg;
    authorLen = stringwidth( "Peter Roohr", 0, '16 16 0');
    authorOrg_x = 0 + gui_percentXRaw( centerLineX ) - gui_percentXRaw( authorLen / 2 );
    authorOrg_y = gui_percentYRaw(135);
    gui_renderString("Peter Roohr", authorOrg, '0 0.8 0.6', '16 16 0', 1, 0);
    
    local float authsiteLen;
    local vector authsiteOrg;
    authsiteLen = stringwidth( "http://www.roohrorbitalyards.com/", 0, '10 10 0');
    authsiteOrg_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( authsiteLen / 2 );
    authsiteOrg_y = gui_percentYRaw(155);
    gui_renderString("http://www.roohrorbitalyards.com/", authsiteOrg, CLR_DEF_WHITE, '10 10 0', 1, 0);
    
    local float team1Len;
    local vector team1Org;
    team1Len = stringwidth( "Music | SFX | Design Consultant", 0, '12 12 0' );
    team1Org_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( team1Len / 2 );
    team1Org_y = gui_percentYRaw(180);
    gui_renderString("Music | SFX | Design Consultant", team1Org, CLR_DEF_IIF_FRIEND_BLD, '12 12 0', 1, 0);
    
    local float author2Len;
    local vector author2Org;
    author2Len = stringwidth( "Eamonn McHugh-Roohr", 0, '16 16 0');
    author2Org_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( author2Len / 2 );
    author2Org_y = gui_percentYRaw(192);
    gui_renderString("Eamonn McHugh-Roohr", author2Org, '0.27 0.95 0.25', '16 16 0', 0.65, 0);
    
    local float website2Len;
    local vector website2Org;
    website2Len = stringwidth( "http://eamonnmr.com/", 0, '10 10 0');
    website2Org_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( website2Len / 2 );
    website2Org_y = gui_percentYRaw(206);
    gui_renderString("http://eamonnmr.com/", website2Org, CLR_DEF_WHITE, '10 10 0', 1, 0);
   
  local float resourceLen;
  local vector resourceOrg;
  resourceLen = stringwidth( "Voice Talent", 0, '16 16 0' );
  resourceOrg_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( resourceLen / 2 );
  resourceOrg_y = gui_percentYRaw(230);
  gui_renderString("Voice Talent", resourceOrg, CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
  gui_renderString("Peter Roohr - Eamonn McHugh-Roohr - Sabrina Farley", gui_percentToPixelRawVec('67 250'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  local float toolsLen;
  local vector toolsOrg;
  toolsLen = stringwidth( "Tools and Tech", 0, '16 16 0' );
  toolsOrg_x = gui_percentXRaw( centerLineX ) - gui_percentXRaw( toolsLen / 2 );
  toolsOrg_y = gui_percentYRaw(275);
  gui_renderString("Tools and Tech", toolsOrg, CLR_DEF_ARM_THREEQ, '16 16 0', 1, 0);
    
  gui_renderString("Darkplaces              https://icculus.org/twilight/darkplaces/", gui_percentToPixelRawVec('75 290'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  gui_renderString("Blender                   https://www.blender.org/", gui_percentToPixelRawVec('75 306'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    
  gui_renderString("Trenchbroom          https://kristianduske.com/trenchbroom/", gui_percentToPixelRawVec('75 322'), CLR_DEF_WHITE, '12 12 0', 1, 0);
    
  gui_renderString("Ultimate Unwrap    https://www.unwrap3d.com/u3d/index.aspx", gui_percentToPixelRawVec('75 338'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  gui_renderString("Audacity                 https://www.audacityteam.org/", gui_percentToPixelRawVec('75 354'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  gui_renderString("Milkshape                http://www.milkshape3d.com/", gui_percentToPixelRawVec('75 370'), CLR_DEF_WHITE, '12 12 0', 1, 0);
  
  gui_renderString("Easygen                   Quake III terrain tool", gui_percentToPixelRawVec('75 386'), CLR_DEF_WHITE, '12 12 0', 1, 0);
      
  drawfont = drawfont_prev;
  
  local entity widget;
  widget = findchainfloat(menuId, M_CREDITS);
  while(widget){
    widget.draw(widget);
    widget = widget.chain;
  }
};

/*
  menu_k functions are the 'listener' functions
*/
void(float key, float ascii) m_credits_k={
  //cons_logAFloat("m_join_k.key", key);  //DEBUG
  //cons_logAFloat("m_join_k.ascii", ascii);  //DEBUG   
  
  switch(key){
    case K_ESCAPE:
      localsound("sound/misc/menu2.wav");
      menu_clear_items(M_STATE);
      M_STATE = M_MAIN;
      m_main_f();
      break;
  }
};