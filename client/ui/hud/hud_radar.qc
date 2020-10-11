/*
battleMETAL
Author: Peter Roohr
Date: 3/30/2020
  broke main hud file down for maintainability
  radar - deals with all radar hud stuff
*/
/*
  RENDER ENTIRE RADAR PANEL
*/
void(vector vorg, float algn, float plrFaction, vector radarOrg, float radarRange, float radarMode, vector siz) hud_renderRadar={
  local vector map_size;
  local vector radarLineLeft, radarLineRight;
  local entity blip;
  
  RADAR_ORG = radarOrg;
  
  map_size = '0 0';
  map_size_x = ((world.mins_x*-1) + world.maxs_x);
  map_size_y = ((world.mins_y*-1) + world.maxs_y);
  
  RADAR_VSIZE = gui_percentToPixelRawVec(siz);
  RADAR_VORG = gui_percentToPixelRawVec(vorg);
  RADAR_VORG = gui_calcAlign(RADAR_VORG, algn);
  
  RADAR_VCENTER_x = RADAR_VORG_x + (RADAR_VSIZE_x / 2);
  RADAR_VCENTER_y = RADAR_VORG_y + (RADAR_VSIZE_y / 2);
  
  
  //nice background image for visibility
  drawpic(RADAR_VORG, UI_DEF_BOX_256, RADAR_VSIZE, '0.25 0.25 0.25', max(0.75, HUD_ALPHA - 0.5), 0);
  //drawpic(RADAR_VCENTER - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec('6 6'), CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  radarLineLeft_x = RADAR_VSIZE_x / 2.25;
  radarLineLeft_x = radarLineLeft_x * -1;
  radarLineLeft_y = RADAR_VSIZE_x / 2.25;
  radarLineLeft_y = radarLineLeft_y * -1;
  
  radarLineRight = radarLineLeft;
  radarLineRight_x = radarLineRight_x * -1;
  drawline(1, RADAR_VCENTER + gui_percentToPixelRawVec('-3 0'), RADAR_VCENTER + radarLineLeft, CLR_DEF_WHITE, HUD_ALPHA, 0);
  drawline(1, RADAR_VCENTER + gui_percentToPixelRawVec('3 0'), RADAR_VCENTER + radarLineRight, CLR_DEF_WHITE, HUD_ALPHA, 0);
  
  for( blip = nextent(world); blip != world; blip = nextent(blip)){
    local entity test;
    local vector testOrg;
    local float testCheck;
    if( !(blip.flags & FL_UNIT) && !(blip.flags & FL_MONSTER) ){
      continue;
    }
    if( blip.deadflag > DEAD_NO ){
      continue;
    }
    if( vlen(blip.origin - RADAR_ORG) > radarRange ){
      continue;
    }
    if( !blip.canTarget ){
      continue;
    }
    testCheck = TRUE;
    //passive radar cannot see through walls or buildings
    if( CLIENT_stat_rdr_mode == FALSE ){
      traceline(RADAR_ORG, blip.origin, FALSE, entitybyindex(player_localentnum));
      if( trace_fraction != 1.0 ){
        if( vlen(blip.origin - RADAR_ORG) > (radarRange * 0.5) ){
          continue;
        }
        if( (blip.flags & FL_CLIENT) ){
          if( blip.stat_rdr_mode == FALSE ){
            continue;
          }
        }
      }
    }
    hud_renderRadarContact( blip, plrFaction, radarRange );
  }
  
  local entity nav;
  for( nav = MENU_NAV_LIST; nav != world; nav = nav.partPrev ){
    if( (nav.faction != FACTION_ALL) && (nav.faction != CLIENT_faction) ){
      continue;
    }
    if( nav.isActive == FALSE ){
      continue;
    }
    hud_renderRadarNav( nav.origin, nav.isActive, radarRange );
  }
};

/*
  RENDER SINGLE RADAR CONTACT
*/
void( entity blip, float plrFaction, float radRange) hud_renderRadarContact={
  local vector hudorg;
  local float ang, entAngle, entAngleRadian, radDist;

  radDist = vlen(blip.origin - RADAR_ORG) / radRange * 1.5;
  
  ang = vectoyaw(blip.origin - RADAR_ORG);

  entAngle = anglemod( 90 + (input_angles_y - ang)); //go figure this works
  entAngleRadian = entAngle * DEG2RAD;
  hudorg_x = cos(entAngleRadian);
  hudorg_y = sin(entAngleRadian);
  hudorg_x = RADAR_VCENTER_x - (hudorg_x * ( RADAR_VSIZE_x * radDist));
  hudorg_y = RADAR_VCENTER_y - (hudorg_y * ( RADAR_VSIZE_y * radDist));

  local float draw;
  draw = TRUE;
  if( (hudorg_x < RADAR_VORG_x) || (hudorg_x > (RADAR_VORG_x + RADAR_VSIZE_x) ) ){
    draw = FALSE;
  }
  if( (hudorg_y < RADAR_VORG_y) || (hudorg_y > (RADAR_VORG_y + RADAR_VSIZE_y) ) ){
    draw = FALSE;
  }
  if( draw ){
    switch( blip.data_type ){
      case DATA_BLD:
        if( blip.faction != FACTION_ALL ){
          hud_RenderRadar_Building(hudorg, blip.vec_size, blip.faction, 0.85 );  
        }
        break;
      case DATA_VEHC:
        hud_RenderRadar_Vehc(hudorg, blip.vec_size, blip.faction, 0.9);
        break;
      case DATA_MECH:
        if( blip.entId != player_localentnum ){
          hud_RenderRadar_Mech(hudorg, blip.vec_size, blip.faction, 1); 
        }
        break;
    }
  }
};

/*
  RENDER A NAV POINT PIP ON THE RADAR
*/
void( vector navOrg, float navState, float radRange ) hud_renderRadarNav={
  local vector hudorg, colr;
  local float ang, entAngle, entAngleRadian, radDist, draw;
  local float alph;

  radDist = vlen( navOrg - RADAR_ORG) / radRange * 1.5;
  
  ang = vectoyaw(navOrg - RADAR_ORG);

  entAngle = anglemod( 90 + (input_angles_y - ang)); //go figure this works
  entAngleRadian = entAngle * DEG2RAD;
  hudorg_x = cos(entAngleRadian);
  hudorg_y = sin(entAngleRadian);
  hudorg_x = RADAR_VCENTER_x - (hudorg_x * ( RADAR_VSIZE_x * radDist));
  hudorg_y = RADAR_VCENTER_y - (hudorg_y * ( RADAR_VSIZE_y * radDist));

  draw = TRUE;
  if( (hudorg_x < RADAR_VORG_x) || (hudorg_x > (RADAR_VORG_x + RADAR_VSIZE_x) ) ){
    draw = FALSE;
  }
  if( (hudorg_y < RADAR_VORG_y) || (hudorg_y > (RADAR_VORG_y + RADAR_VSIZE_y) ) ){
    draw = FALSE;
  }
  if( draw ){
    colr = CLR_DEF_ARM_OK;
    alph = HUD_ALPHA;
    if( navState == 2 ){
      colr = CLR_DEF_TXT_NONSELECT;
      alph = 0.33;
    }
    drawpic(hudorg - gui_percentToPixelRawVec('3 3'), UI_DEF_NAVPOINT, gui_percentToPixelRawVec('10 10'), colr, alph, 0);
  }
};

/*
  RENDER A MECH ICON ON THE RADAR
*/
void(vector post, float e_size, float e_fact, float e_alpha) hud_RenderRadar_Mech={
  local vector clr;
  local vector blipSize;
  
  clr = CLR_DEF_IFF_ENEMY;
  if( e_fact != FACTION_ALL ){
    if(CLIENT_faction == e_fact){
      clr = CLR_DEF_IIF_FRIEND;
    }
  }
  blipSize = e_size * '4 4 4';
  drawpic(post - gui_percentToPixelRawVec(blipSize * 0.5), HUD_RAD_PIP_MCH, gui_percentToPixelRawVec(blipSize), clr, e_alpha, 0);
};

/*
  RENDER A VEHICLE ICON ON THE RADAR
*/
void(vector post, float e_size, float e_fact, float e_alpha) hud_RenderRadar_Vehc={
  local vector clr;
  local vector blipSize;
  
  clr = CLR_DEF_IFF_ENEMY;
  if(CLIENT_faction == e_fact){
    clr = CLR_DEF_IIF_FRIEND;
  }
  blipSize = e_size * '5 5 5';
  
  drawpic(post - gui_percentToPixelRawVec(blipSize * 0.5), HUD_RAD_PIP_VEC, gui_percentToPixelRawVec(blipSize), clr, e_alpha, 0);
};

/*
  RENDER A BUILDING ICON ON THE RADAR
*/
void(vector post,float e_size, float e_fact, float e_alpha) hud_RenderRadar_Building={
  local vector clr;
  local vector blipSize;
  
  clr = CLR_DEF_IFF_ENEMY_BLD;
  if(CLIENT_faction == e_fact){
    clr = CLR_DEF_IIF_FRIEND_BLD;
  }
  blipSize = (e_size * 0.75) * '4 4 4';
  drawpic(post - gui_percentToPixelRawVec(blipSize * 0.5), HUD_RAD_PIP_BLD,  gui_percentToPixelRawVec(blipSize), clr, e_alpha, 0);
};

/*
  RENDER A NAV POINT ICON ON THE RADAR
*/
void(vector post, float isOn, vector fac_clr) hud_RenderRadar_Nav={
  if(isOn){
    drawpic(post - gui_percentToPixelRawVec('3 3'), HUD_RAD_PIP_NAV,  gui_percentToPixelRawVec('6 6'), fac_clr, HUD_ALPHA, DRAWFLAG_NORMAL);
  }
};
