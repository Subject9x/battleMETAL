/*
mech Mod
Author: Subject9x
Date: 3/4/2017
Overview: menu file for hangar

main file for the hangar

*/
  
//main hook for menu system
void() menu_hangarDrawFrame={
  
  local vector topleftroot;
  topleftroot = VIEW_ORG + '12 12';
  drawfill(topleftroot, (VIEW_MAX - '24 24'), STATUS_DED, HUD_ALPHA, 0); 
  gui_DrawRect(topleftroot, (VIEW_MAX - '24 24'), '6 4', '1 1 1');

  menu_hangar_DrawNavBar(topleftroot);
  menu_hangar_MechDisplay(topleftroot);
  menu_hangar_MechList(topleftroot + '0 24');
  menu_hangar_MechInfo(topleftroot);
};

void(vector offset) menu_hangar_DrawNavBar={

  gui_DrawRect(offset, '48 16', '6 4', '1 1 1');
  drawstring(offset + '0 4', "[HANGAR]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawRect(offset+'48 0', '64 16', '6 4', '1 1 1');
  drawstring(offset + '48 4', "[BRIEFING]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  
  gui_DrawRect(VIEW_MAX - '88 24', '64 16', '6 4', '1 1 1');
  drawstring(VIEW_MAX - '88 24', "[ACCEPT]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
};

void(vector offset) menu_hangar_MechDisplay={
  local vector ofs, hofs, mpos, i_sz, hpnts;
  ofs = offset + '116 24';
  gui_DrawRect(ofs, (VIEW_MAX - '300 256'), '6 4', '1 1 1');
  local entity dat;
  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  i_sz = draw_getimagesize(dat.c_mdl);
  i_sz = gui_scaleSize(i_sz,VIEW_SCALE);
  i_sz_x = i_sz_x/1.5;
  i_sz_y = i_sz_y/1.5;
  hofs_x = (ofs_x + ((VIEW_MAX_x - 300)/2));
  hofs_y = ofs_y;
  hofs_x = hofs_x - i_sz_x/2;
  hpnts_x = hofs_x + i_sz_x/2;
  hpnts_y = hofs_y + i_sz_y/2;
  drawpic(hofs, dat.c_mdl, i_sz, '1 1 1', HUD_ALPHA, 0);
  dat.menu_renderHardpoints(hpnts);
};

void(vector offset) menu_hangar_MechList={
  local vector ofs,sz;
  local float lst_idx, found;
  ofs = sz = offset;
  drawstring(offset + '24 0', "[MECHS]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  lst_idx = 1;
  while(lst_idx < 4){
    local entity dat;
    local vector lofs;
    dat = m_findData(lst_idx, DATA_MECH);
    lofs_x = ofs_x + 12;
    lofs_y = ofs_y + (lst_idx * 12);
    drawstring(lofs, dat.vec_name, '6 6 0', '1 1 1', HUD_ALPHA, 0);
    if(dat.data_idx == PLAYER_HELPER.plr_sel_mech){
      gui_DrawRect(lofs, '48 12', '4 4', '1 1 1');
    }
    sz_x = sz_x + lofs_x;
    sz_y = sz_y + lofs_y;
    lst_idx = lst_idx + 1;
  }
};


void(vector offset) menu_hangar_MechInfo={
  local vector ofs;
  local entity dat;
  ofs_x = offset_x + 116;
  ofs_y = VIEW_CTR_y + 24;
  gui_DrawRect(ofs, (ofs + '32 8'), '6 4', '1 1 1');

  dat = m_findData(PLAYER_HELPER.plr_sel_mech, DATA_MECH);
  drawstring(ofs + '6 6', "[INFO]", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '6 12', strcat("[NAME] ", dat.vec_name), '6 6 0', '1 1 1', HUD_ALPHA, 0);
  local string type;
  local vector t_color;
  // MECH SIZE
  if(dat.vec_size == 1){
    type = "Light";
    t_color = STATUS_AOK;
  }
  else if(dat.vec_size == 2){
    type = "Medium";
    t_color = STATUS_DMG;
  }
  else if(dat.vec_size == 3){
    type = "Heavy";
    t_color = STATUS_REL;
  }
  drawstring(ofs + '6 18', "[TYPE] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '48 18',  type, '6 6 0', t_color, HUD_ALPHA, 0);
  //MECH SPEED
  if(dat.m_fspeed <= 75){
    type = "Slow";
    t_color = STATUS_REL;
  }
  else if(dat.m_fspeed <= 100){
    type = "Normal";
    t_color = STATUS_DMG;
  }
  else  if(dat.m_fspeed <= 200){
    type = "Fast";
    t_color = STATUS_AOK;
  }
  drawstring(ofs + '6 24', "[SPEED] ", '6 6 0', '1 1 1', HUD_ALPHA, 0);
  drawstring(ofs + '56 24', type, '6 6 0', t_color, HUD_ALPHA, 0);
  
  //
};