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
  drawpic(ofs + '10 18', UI_DEF_BOX_256_TALL, '96 400', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '8 8', "[MISSION INFO]", '6 6 0', '1 1 1', HUD_ALPHA, 0);

};
void(vector ofs) menu_briefMissionText={

};
void(vector ofs) menu_briefMapPanel={


};
void(vector ofs) menu_briefObjectivePanel={



};
void(vector ofs) menu_briefIntelPanel={



};