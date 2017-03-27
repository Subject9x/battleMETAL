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
  drawpic(ofs + '10 42', UI_DEF_BOX_256, '164 70', '1 1 1', HUD_ALPHA, 0);
  local float tlen;
  local vector tpos;
  tlen = stringwidth("[MISSION INFO]", 0, '8 8 0');
  tpos = ofs + '10 44';
  tpos_x = (tpos_x + 82) - (tlen/2);
  drawstring(tpos, "[MISSION INFO]", '8 8 0', '1 1 1', HUD_ALPHA, 0);
  
  //mission name
  drawstring(ofs+'14 56', "[NAME]: ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  //mission type
  drawstring(ofs+'14 64', "[TYPE]: ", '6 6 0', '1 1 1', HUD_ALPHA, 0); 
  
  //reserves
  drawstring(ofs+'14 72', "[RESOURCE POINTS]: ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  //sector
  drawstring(ofs+'14 80', "[SECTOR]: ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  //location
  drawstring(ofs+'14 88', "[LOCATION]: ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  //location
  drawstring(ofs+'14 96', "[LOCAL TIME]: ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_briefMissionText={
  local vector bpos;
  bpos = ofs + '10 112';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '164 256', '1 1 1', HUD_ALPHA, 0);
};

void(vector ofs) menu_briefMapPanel={
  local vector mpos;
  mpos_x = mpos_x + (VIEW_CTR_x - 66);
  mpos_y = ofs_y + 44;
  drawpic(mpos, UI_DEF_BOX_256, '375 225', '1 1 1', HUD_ALPHA, 0);
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
  
};

void(vector ofs) menu_briefIntelPanel={
  local vector bpos;
  bpos = VIEW_CTR + '-66 40';
  drawpic(bpos, UI_DEF_BOX_256_TALL, '375 182', '1 1 1', HUD_ALPHA, 0);


};