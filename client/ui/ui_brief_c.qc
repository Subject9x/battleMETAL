/*
mech Mod
Author: Subject9x
Date: 3/26/2017
Overview: class file for the deployment ui
*/

//main hook for menu system
void() menu_briefDrawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG + '2 12';
  drawpic(topleftroot, UI_DEF_BOX_512, (VIEW_MAX - '4 24'), '1 1 1', HUD_ALPHA, 0);
  menu_briefMissionInfo(topleftroot);
  menu_briefMissionText(topleftroot);
  menu_briefMapPanel(topleftroot);
  if(INFO_SWITCH){
    menu_briefObjectivePanel(topleftroot);
  }
  else{
    menu_briefIntelPanel(topleftroot);
  }
};

//hook for input system
void() menu_briefListener={};

//Listener hooks calle by menu_briefListener
void() navpointListener={
  local float lst_idx;
  lst_idx = 0;
  while(lst_idx <= NAVPOINTS_CNT){
    
    lst_idx = lst_idx + 1;
  }  

};


//panels
void(vector ofs) menu_briefMissionInfo={
  drawpic(ofs + '10 42', UI_DEF_BOX_256, '242 70', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION INFO]", 0, '8 8 0');
  tpos = ofs + '0 44';
  tpos_x = (tpos_x + 121) - (tlen/2);
  drawstring(tpos, "[MISSION INFO]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //mission name
  drawstring(ofs+'14 56', strcat("[NAME]:            ", MSN_NAME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //mission type
  drawstring(ofs+'14 64', strcat("[TYPE]:            ",MSN_TYPE), '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  //reserves
  drawstring(ofs+'14 72', strcat("[RESOURCE POINTS]: ", ftos(AVAILABLE_RESERVE)), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //sector
  drawstring(ofs+'14 80', strcat("[SECTOR]:          ", MSN_SECTOR), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //location
  drawstring(ofs+'14 88', strcat("[LOCATION]:        ", MSN_LOCATION ), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  //local time
  drawstring(ofs+'14 96', strcat("[LOCAL TIME]:      ", MSN_LOCALTIME), '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_briefMissionText={
  local vector bpos;
  bpos = ofs + '10 112';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '242 256', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION BRIEF]", 0, '8 8 0');
  tpos = bpos + '82 0';
  drawstring(tpos, "[MISSION BRIEF]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_briefMapPanel={
  local vector mpos;
  mpos_x = mpos_x + (VIEW_CTR_x - 66);
  mpos_y = ofs_y + 44;
  drawpic(mpos, UI_DEF_BOX_256, '375 225', '1 1 1', HUD_ALPHA, 0);
  
  local vector iofs;
  iofs = mpos + '64 6';
  
  drawpic(iofs, "maps/t_train0_over.png", '212 212', '1 1 1', HUD_ALPHA, 0);
  
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
      nofs = gui_mapCoordToImgCoord(map_size, cprc, nav.origin, '212 212 0');
      local float nlen;
      nlen = stringwidth(nav.w_name, 0, '6 6 0');
      nofs = iofs+nofs;
      nofs_x = nofs_x - (nlen/2);
      nofs_y = nofs_y - 3;
      drawstring(nofs, nav.w_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    }
    nav = nav.chain;
  }
};

void(vector ofs) menu_briefObjectivePanel={
  local vector bpos,tpos;
  local float tlen;
  tlen = stringwidth("[OBJECTIVES]", 0 , '8 8 0');
  bpos = VIEW_CTR + '-66 40';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '375 182', '1 1 1', HUD_ALPHA, 0);
  tpos = bpos;
  tpos_x = (tpos_x + 187.5) - (tlen/2);
  tpos_y = tpos_y + 6;
  drawstring(tpos, "[OBJECTIVES]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  local entity obj;
  local float lst_idx;
  local vector lofs;
  lofs = bpos + '12 24';
  obj = findchain(classname, "data");
  lst_idx = 0;
  while(obj){
    if(obj.data_type == DATA_OBJT){
      local vector oofs;
      oofs = lofs;
      oofs_y = oofs_y + (lst_idx *12);
      drawstring(oofs, strcat("Objective ", ftos(obj.nav_name)), '6 6 0', '1 1 1', HUD_ALPHA,0);
      lst_idx = lst_idx + 1;
    }
    obj = obj.chain;
  }
};

void(vector ofs) menu_briefIntelPanel={
  local vector bpos;
  bpos = VIEW_CTR + '-66 40';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '375 182', '1 1 1', HUD_ALPHA, 0);
};