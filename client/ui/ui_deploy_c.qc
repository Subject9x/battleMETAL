/*
mech Mod
Author: Subject9x
Date: 3/26/2017
    mod 4/9//2017
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_deployDrawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG + '2 12';
  drawpic(topleftroot, UI_DEF_BOX_512, (VIEW_MAX - '4 24'), '1 1 1', HUD_ALPHA, 0);
  menu_deploy_mechInfoPanel(topleftroot);
  menu_deploy_mapOverviewPanel(topleftroot);
};

//hook for input system
void() menu_deployListener={
  navSelectListener();
};

//Listener hooks calle by menu_briefListener
void() navSelectListener={
  local entity nav;
  nav = findchain(classname, "data");
  while(nav){
    if(nav.data_type == DATA_NAVP){
      if(menu_checkMouseInBounds(cursorpos, nav.ui_org, nav.ui_size)){
        centerprint(ftos(nav.nav_name));
        PLAYER_HELPER.plr_nav_pnt = nav.nav_name;
      }
    }
    nav = nav.chain;
  }
};


//panels
void(vector ofs) menu_deploy_mechInfoPanel={};
void(vector ofs) menu_deploy_mapOverviewPanel={
  local vector mpos;
  mpos_x = mpos_x + (VIEW_CTR_x - 97);
  mpos_y = ofs_y + 44;
  drawpic(mpos, UI_DEF_BOX_256, '405 405', '1 1 1', HUD_ALPHA, 0);
  
  local vector iofs;
  iofs = mpos + '12 12';
  
  drawpic(iofs, "maps/t_train0_over.png", '381 381', '1 1 1', HUD_ALPHA, 0);
  
  
  local vector map_size, cprc;
  map_size_x = (world.mins_x*-1) + world.maxs_x;
  map_size_y = (world.mins_y*-1) + world.maxs_y;

  cprc_x = ((world.mins_x*-1)/map_size_x);
  cprc_y = ((world.mins_y*-1)/map_size_y);
  
  local entity nav;
  nav = findchain(classname, "data");
  while(nav){
    if(nav.data_type == DATA_NAVP){
      local vector nofs;
      nofs = gui_mapCoordToImgCoord(map_size, cprc, nav.origin, '381 381 0');
      local float nlen;
      nlen = stringwidth(nav.w_name, 0, '6 6 0');
      nofs = iofs+nofs;
      nofs_x = nofs_x - (nlen/2);
      nofs_y = nofs_y - 3;
      nav.ui_org = nofs; 
      nav.ui_size_x = nav.ui_size_x + nlen;
      nav.ui_size_y = nav.ui_size_y + 6;
      drawstring(nofs, nav.w_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    }
    nav = nav.chain;
  }
};