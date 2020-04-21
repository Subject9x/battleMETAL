/*
battleMETAL
Author: Peter Roohr
Date: 04/11/2020
Overview: 
  End of Round score screen for DM / TDM / Coop(?) games
  also shown when player dies.
*/

//pseudo interface
void() menu_scoreListener_onClick={
  
  if(menu_checkMouseInBounds(cursorpos, UI_NAVBAR_DISCONNECT_ORG, gui_percentToPixelRawVec(UI_NAVBAR_DISCONNECT_SIZE), TRUE)){
    ui_navbutton_disconnect_click();
  }
  
  
};

//void() menu_scoreListener_onDrag={};

void() menu_scoreListener_onHover={};

//void() menu_scoreListener_onKeyUp={};

void() menu_score_drawFrame={
  local vector topleftroot;
  local vector rulesOrg;
  
  topleftroot = VIEW_ORG;
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '0.85 0.85 0.85', 1, 0);
  
  //Navbar
  menu_score_draw_bar( VIEW_ORG + gui_percentToPixelRawVec('9.984 7.488') );
  
  if( cvar("gamemode") == GAMEMODE_COOP ){
    
  
  }
  else if( cvar("gamemode") == GAMEMODE_TEAMDM ){
  }
  else if( cvar("gamemode") == GAMEMODE_DM ){
    
    //mission info - DM
    menu_serverinfo_basic(topleftroot + gui_percentToPixelRawVec('10 32'));
    
    //server flags - DM
    rulesOrg_x = VIEW_CTR_x;
    rulesOrg_y = VIEW_ORG_y;
    menu_connect_draw_rules_dm( rulesOrg + gui_percentToPixelRawVec('-85 32') );
    
    //Server About - DM
    menu_connect_draw_about_dm( rulesOrg + gui_percentToPixelRawVec('20 32') );
    
    //player list - DM
    menu_draw_players_basic( topleftroot + gui_percentToPixelRawVec('10 182') );
    return; 
  }

};
//------------------

//DEATHMATCH SCORE SCREEN
void( vector menuOrg ) menu_score_dm={};


//-----------------------

//COOP SCORE SCREEN
void( vector menuOrg ) menu_score_tdm={};


//-----------------------

void( vector menuOrg ) menu_score_draw_bar={
  ui_navbutton_disconnect_draw( menuOrg );
};