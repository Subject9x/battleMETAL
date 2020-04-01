/*
battleMETAL
Author: Peter Roohr
Date: 4/1/2020
  Tactical map feature - covers player's whole view, but shows the satellite map with relevant
  data
*/

/*
  Render - HUD tactical map frame
*/
void() hud_render_tactical_map={
  local vector mapOrg, mapImgSize;
  local float unavailableLen;
  local vector unavailableOrg;
  local vector map_size;
  // render satellite view
  mapOrg = VIEW_ORG + gui_percentToPixelRawVec('2 2');
  mapImgSize = gui_percentToPixelRawVec('200 200');
  
  if( MSN_MAPPIC != "" ){
    drawpic(mapOrg, MSN_MAPPIC, mapImgSize, '1 1 1', 1, 0);
  }
  else{
    unavailableLen = stringwidth( "!- Satellite Data unavailable -!", 0 ,'16 16 0');
    unavailableOrg = mapOrg;
    unavailableOrg_x = unavailableOrg_x + gui_percentXRaw(380 / 2) - gui_percentXRaw( unavailableLen / 2 );
    unavailableOrg_y = unavailableOrg_y + gui_percentYRaw(380 / 2) - gui_percentYRaw( 8 );
    gui_wrapText(unavailableOrg, '210 32', "!- Satellite Data unavailable -!", '16 16 0', '1 0 0', 1);
  }
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  local entity mapKey;
  local vector keyOrg;
  mapKey = mapKeyObject;
  for( mapKey = mapKeyObject; mapKey != world; mapKey = mapKey.w_slot ){
    keyOrg = gui_mapCoordToImgCoord(world.mins, map_size, mapKey.origin, mapOrg, mapImgSize);
    switch( mapKey.data_type ){
      case DATA_MAP_DMG:
        drawpic( keyOrg - gui_percentToPixelRawVec('2 2'), UI_DEF_BOX_64, gui_percentToPixelRawVec('4 4'), CLR_DEF_RED * 1.15, 0.85, 0);
        break;
      case DATA_BLD:
        gui_renderTintImage2((CLIENT_faction == mapKey.faction), keyOrg - gui_percentToPixelRawVec('4 4'), HUD_RAD_PIP_BLD, gui_percentToPixelRawVec('8 8'), CLR_DEF_IIF_FRIEND_BLD, CLR_DEF_IFF_ENEMY_BLD + '0.15 0.15 0.15', 1, 0);
        break;
    }
  }
  
  local vector renderColor;
  local entity nav;
  //render nav points
  renderColor = CLR_DEF_GREEN - '0.1 0.1 0.1';
  
  //Render Nav points
  local entity nav;
  local vector navOfs;
  local vector navImgOfs;
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( nav.faction != CLIENT_faction && nav.faction != FACTION_ALL ){
      continue;
    }
    
    local float nactive, nlen;
    local string navname;
    navImgOfs = navOfs = gui_mapCoordToImgCoord(world.mins, map_size, nav.origin, mapOrg, mapImgSize);
    
    drawfont_prev = drawfont;
    drawfont = FONT_NUM_ROBOT_REGULAR;
    navname = NAVNAMES[nav.data_idx];
    nlen = stringwidth(navname, 0, '8 8 0');
    navOfs_x = navOfs_x - gui_percentXRaw( (nlen/2) );
    navOfs_y = navOfs_y - gui_percentYRaw(11);
    gui_renderTintImage(TRUE, navImgOfs - gui_percentToPixelRawVec('5 5'), UI_DEF_NAVPOINT, '10 10', renderColor, 1, 0) ;
    
    drawstring(navOfs, navname, '8 8 0', renderColor, 1, 0);
    
    drawfont = drawfont_prev;
  }
  
  //render allies
    local entity player;
    for( player = nextent(world); player != world; player = nextent(player) ){
      if( !(player.flags & FL_CLIENT) ){
        continue;
      }
      if(player.data_type != DATA_MECH){
        continue;
      }
      if(player.faction != CLIENT_faction){
        continue;
      }
      local vector friend_org;
      friend_org = gui_mapCoordToImgCoord(world.mins, map_size, player.origin, mapOrg, mapImgSize);
      gui_renderTintImage2((player.entId == player_localentnum), friend_org, HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('10 10'), CLR_DEF_IIF_FRIEND, CLR_DEF_IIF_FRIEND_BLD * 1.25, 1, 0 );
      
      if( player.entId != player_localentnum ){
        local vector nameOrg;
        local float nameLen;
        nameOrg = friend_org + gui_percentToPixelRawVec('0 -10');
        
        drawfont_prev = drawfont;
        drawfont = FONT_NUM_ROBOT_REGULAR;
        
        nameLen = stringwidth( player.netname, 0, '10 10 0');
        nameOrg_x = nameOrg_x - gui_percentXRaw( nameLen / 2 );
        drawstring( nameOrg, player.netname, '10 10 0', CLR_DEF_IIF_FRIEND_BLD, 1, 0);
        
        drawfont = drawfont_prev;
      }
      
      if( player.targetEntId <= 0 ){continue;}
      if( player.enemy.deadflag != DEAD_NO ){continue;}
        
      local vector target_org;
      target_org = gui_mapCoordToImgCoord(world.mins, map_size, player.enemy.origin, mapOrg, mapImgSize);
      drawpic(target_org, HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('10 10'), CLR_DEF_IFF_ENEMY, 1, 0);
    }
  
  //render allied contacts
};