/*
battleMETAL
Author: Peter Roohr
Date: 05/05/2021
Overview: 
  Weapon Rebind menu.
    Allows player to rebind their weapon groups 
*/


vector REBIND_ORIGIN;
vector REBIND_SIZE = '150 198';

float REBIND_SEND_TIME;
float REBIND_SEND_TIME_MIN = 0.2;

/*
  Click Listener
*/
void() menu_rebindListener_onClick={
  if(menu_checkMouseInBounds(cursorpos, REBIND_ORIGIN, REBIND_SIZE, TRUE)){
    weaponGroupPanelListener();
  }
};

void() menu_rebind_drawFrame={
  local vector panelOrg;
  
  panelOrg = gui_calcAlignCustom(REBIND_SIZE * -0.5, (VIEW_CTX | VIEW_CTY), VIEW_CTR);
  REBIND_ORIGIN = panelOrg;
  
  menu_arming_WeaponGroupPanel(REBIND_ORIGIN);
};