/*
battleMETAL
Author: Peter Roohr
Date: 04/02/2020
Overview: 
  This menu is shown to DM / TDM players on connect.
  Display
    DM 
      + total players list
      + player scores
      + time limit left
      + map name
      
    TDM
      + total players split into 2 lists
      + player scores
      + team score
      + map name
*/

void() menu_connectListener_onClick={

  return;
};

//void() menu_connectListener_onDrag;

void() menu_connectListener_onHover={
  
  return;
};

//void() menu_connectListener_onKeyUp;

void() menu_connect_drawFrame={
  local vector topleftroot;
  
  //background panel
  topleftroot = VIEW_ORG;
  
  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, '1 1 1', 1, 0);
  //nav bar
    //DM - Disconnect || ENTER
    
    //TDM - Disconnect || Switch Team || ENTER
    
  //mission info
    //Map | time remaining | score
  
  //player list
    //name - score 
    //TDM - mech type - score
  
};

void( vector menuOrg ) menu_connect_draw_bar={

};

void( vector menuOrg ) menu_connect_draw_mission_info={

};

void( vector menuOrg ) menu_connect_draw_players={

};
