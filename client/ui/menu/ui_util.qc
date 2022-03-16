/*
battleMETAL
Author: Peter Roohr
Date: 05/17/2019
Overview:
  Utility functions for the UI system.
  These are non-menu specific functions that I couldn't find a better
  place to put.
  
*/

/*
  UI_BRIEF and UI_ARMING, show all players and their status.
*/
void(vector ofs, vector pnlSize, vector colorBack) ui_render_coop_player_status={
  local vector org;
  local float itr;
  local entity player;
  local string nameCheck;
  
  local vector nameOrg;
  local vector statusOrg;
  local vector mechOrg;
  
  local vector playerColor;
  
  local string playerStatus;
  local vector statusColor;
  
  local float marginX;
  
  //320 80
  gui_renderPatch9_1_32(ofs, pnlSize, colorBack, 1, DRAWFLAG_NORMAL);
  
  org = ofs + [pnlSize_x / 6.67, 42];
  
  marginX = pnlSize_x / 4;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  for( itr = 0; itr < 4; itr = itr + 1){
    nameCheck = getplayerkeyvalue(itr, "name");
    if( strlen(nameCheck) > 0 ){
      player = findfloat(world, clientServerNum, itr + 1);
      if( player ){
        if( strlen(nameCheck) > 14 ){
          nameCheck = substring(nameCheck, 0, 14);
        }
        
        nameOrg = [org_x + ( itr * marginX), org_y];
        nameOrg_x = nameOrg_x - stringwidth(nameCheck, 0, '12 12') / 2;
        
        if( itr == player_localnum ){
          playerColor = CLR_DEF_IIF_FRIEND_BLD;
        }
        else{
          playerColor = CLR_DEF_TXT_NONSELECT;
        }
        
        drawstring(nameOrg, nameCheck, '12 12', playerColor, 1.0, 0);
        
        if( (ENT_SERVER_INFO.serverFlags & SVFLAG_NOSTATUS) && (ENT_SERVER_INFO.gameType != GAMEMODE_COOP) ){
          playerStatus = "<hidden>";
          statusColor = CLR_DEF_ARM_THREEQ;
        }
        else{
          if( player.deadflag == DEAD_DEAD ){
            playerStatus = "Dead";
            statusColor = CLR_DEF_RED * 0.9;
          }
          else{
            if( player.data_type == DATA_POBS || player.data_type == 0 ){
              playerStatus = "In Menu";
              statusColor = CLR_DEF_ARM_THREEQ * 0.9;
            }
            else{
              playerStatus = "Deployed";
              statusColor = CLR_DEF_IIF_FRIEND_BLD * 0.9;
            }
          }
        }
        
        statusOrg_y = org_y + 12;
        statusOrg_x = org_x - stringwidth(playerStatus, 0, '10 10') / 2;
        drawstring(statusOrg, playerStatus, '10 10', statusColor, 1.0, 0);
        
        if(player.nextVecChoice > 0 ){
          mechOrg_y = org_y + 24;
          mechOrg_x = org_x - stringwidth(MECH_DATA_NAMES[player.nextVecChoice], 0, '12 12') / 2;
          drawstring(mechOrg, MECH_DATA_NAMES[player.nextVecChoice], '12 12', CLR_DEF_GREEN, 1.0, 0);
        }
      }
    }
    else{
      nameOrg = [org_x + ( itr * marginX), org_y];
      nameOrg_x = nameOrg_x - stringwidth("Disconnected", 0, '12 12') / 2;
        
      drawstring(nameOrg, "Disconnected", '12 12', '0.67 0.25 0.25', 1.0, 0);
    }
  }
  drawfont = drawfont_prev;
};

/*
  Renders the weapon icon, and a highlight box for a selected hardpoint in
  the Arming Menu.
*/
void(vector org, float selected, float allow) ui_renderHardPointGraphic={
  local vector iorg;
  local float allowAlpha;
  
  if(selected){
    iorg = org - '2 2';
    gui_renderTintImage(selected, iorg, UI_DEF_REC_64, '32 32', CLR_DEF_YELLOW * 2, 0.5, 0);
    //drawfill( iorg, '32 32', CLR_DEF_YELLOW * 2, 0.33, 0);
  }
  else{
    allowAlpha = 0.45;
    if( allow ){
      allowAlpha = 0.85;
    }
    drawpic( org, UI_DEF_REC_64,  '28 28', '1 1 1', allowAlpha, 0);
  }

};

void( vector org, vector imgSize, float wepType, vector highColor ) ui_renderHardpoint_class_pair={
  local string pic;
  if( wepType < 1 || wepType > MSC4 ){
    //safety valve
    return;
  }
  switch( wepType ){
    default:
      pic = "";
      break;
    case BAL1:
      pic = "gfx/ui/wep_icons/bal1.tga";
      break;
    case BAL2:
      pic = "gfx/ui/wep_icons/bal2.tga";
      break;
    case BAL3:
      pic = "gfx/ui/wep_icons/bal3.tga";
      break;
    case BAL4:
      pic = "gfx/ui/wep_icons/bal4.tga";
      break;
    case ENE1:
      pic = "gfx/ui/wep_icons/ene1.tga";
      break;
    case ENE2:
      pic = "gfx/ui/wep_icons/ene2.tga";
      break;
    case ENE3:
      pic = "gfx/ui/wep_icons/ene3.tga";
      break;
    case ENE4:
      pic = "gfx/ui/wep_icons/ene4.tga";
      break;
    case MIS1:
      pic = "gfx/ui/wep_icons/mis1.tga";
      break;
    case MIS2:
      pic = "gfx/ui/wep_icons/mis2.tga";
      break;
    case MIS3:
      pic = "gfx/ui/wep_icons/mis3.tga";
      break;
    case MIS4:
      pic = "gfx/ui/wep_icons/mis4.tga";
      break;
    case MSC1:
      pic = "gfx/ui/wep_icons/misc1.tga";
      break;
    case MSC2:
      pic = "gfx/ui/wep_icons/misc2.tga";
      break;
    case MSC3:
      pic = "gfx/ui/wep_icons/misc3.tga";
      break;
    case MSC4:
      pic = "gfx/ui/wep_icons/misc4.tga";
      break;
  } 
  if( pic == "" ){
    return;
  }
  drawpic( org, pic, imgSize, highColor, 1, 0);
};

/*
  Renders 1 row in the Hangar Menu.
  Displays Hardpoint data for the selected Mech.
*/
void(vector org, float hpt_num, float types, float sz) ui_renderHardpointRow={
  local vector pofs, hptNumOrg, hptSizeOrg;
  local string hardpointLabel;
  local float drawfontLocal;
  local float itr;
  local float hpointVal;
  local vector itemColor;
  
  drawfontLocal = drawfont;
  drawfontLocal = FONT_NUM_ROBOT_REGULAR;
  
  pofs = org + '-10 -15';
  pofs_y = pofs_y + ((hpt_num + 1) * 20);
  
  hardpointLabel = strcat(ftos(hpt_num + 1),")");
  
  hptNumOrg = pofs;
  hptNumOrg_x = hptNumOrg_x + (25 / 2) - stringwidth(hardpointLabel, 0, '12 12 0') / 2;
  
  drawstring(hptNumOrg, hardpointLabel, '12 12 0', CLR_DEF_RET_HASLOCK, 1, 0);
  
  hptSizeOrg = hptNumOrg;
  hptSizeOrg_x = hptSizeOrg_x + 11;
  hpointVal = 1;
  for( itr = 0; itr < 16; itr = itr + 1 ){
    if( (sz & hpointVal) ){
      itemColor = '1 1 1';
    }
    else{
      itemColor = '0.33 0.33 0.33';
    }
    ui_renderHardpoint_class_pair( hptSizeOrg, '14 14', hpointVal, itemColor);
    
    hptSizeOrg_x = hptSizeOrg_x + 15;
    hpointVal = hpointVal * 2;
  }
  drawfont = drawfontLocal;
};

/*

*/
void(float num, vector org) ui_renderHardPointNumber={
  local vector numberOrg;
  local float width;
  local string hardpointLabel;
  local float drawfontLocal;
  
  drawfontLocal = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  hardpointLabel = ftos(num);
  width = stringwidth(hardpointLabel, 0, '16 14');
  numberOrg = org;
  numberOrg_x = numberOrg_x - (width / 2);
  drawstring(numberOrg, hardpointLabel, '16 14', CLR_DEF_RET_HASLOCK, 1, 0);
  
  drawfont = drawfontLocal;
};

/*
float SPRITE_deploy_point_FRAME;
float SPRITE_deploy_point_FRAME_MAX;
string SPRITE_deploy_point_FRAMES[3];
*/
void(vector org, vector imageSize, vector imageColor, float imageAlpha ) ui_renderSprite_DeployPoint={
  local vector screenImageSize;
  
  screenImageSize = imageSize;
  if( SPRITE_deploy_point_FRAMES[SPRITE_deploy_point_FRAME] != "" ){
    drawpic( org, SPRITE_deploy_point_FRAMES[SPRITE_deploy_point_FRAME], screenImageSize, imageColor, imageAlpha, 0);
  }
  
  if( time > SPRITE_deploy_point_FRAME_TIMER ){
    SPRITE_deploy_point_FRAME = SPRITE_deploy_point_FRAME + 1;
    if( SPRITE_deploy_point_FRAME > SPRITE_deploy_point_FRAME_MAX ){
      SPRITE_deploy_point_FRAME = 1;
    }
    SPRITE_deploy_point_FRAME_TIMER = time + 0.15;
  }
};

string() ui_calculate_game_time_string={
  local string val;
  local float t, sec, mint, hr;
  local float endTime;
  endTime = ENT_SERVER_INFO.ruleTimelimit * 60;
  if( ENT_SERVER_INFO.ruleTimelimit > 0  || ENT_SERVER_INFO.gameType == GAMEMODE_COOP ){
    if( ENT_SERVER_INFO.gameType == GAMEMODE_COOP) {
      t = servertime + (servertime - time);
    }
    else{
      endTime = endTime + ENT_SERVER_INFO.timeStart;
      t = servertime + (servertime - time);
      t = endTime - t ;
    }
    t = max(0, t);
    hr = rint(floor(t/3600));
    mint = rint(floor((t - hr*3600) / 60));
    sec = rint(floor(t - (hr*3600) - (mint*60)));
  
    val = sprintf("%02d:%02d:%02d", hr, mint, sec);
  }else{
    val = "No Limit";
  }
  
  return val;
};

string(float timeVal ) ui_calculate_time_string={
  local string val;
  local float t, sec, mint, hr;
  
  t = timeVal + (servertime - time);
  
  t = max(0, t);
  
  hr = rint(floor(t/3600));
  mint = rint(floor((t - hr*3600) / 60));
  sec = rint(floor(t - (hr*3600) - (mint*60)));
  
  val = sprintf("%02d:%02d:%02d", hr, mint, sec);
  
  return val;
};

string() ui_label_mission_status={
  local string val;
  
 switch( ENT_SERVER_INFO.missionStatus ){
    case MISSION_STATUS_READY:
      val = "Ready";
      break;
    case MISSION_STATUS_ACTIVE:
      val = "In Progress";
      break;
    default:
      val = "Complete";
      break;
  }
  return val;
};

/*
  Player scoreboard stuff
*/
/*
  SCOREBOARD[]; <k, v> = itr, .clientServerNum
*/
void() scoreboard_sort={
  local float i, j, key, key2;
  local float scoreI, scoreJ;
  
  SCOREBOARDMAX = maxclients;
  
  for( i=1; i < SCOREBOARDMAX; i=i+1){
    // clientServerNum from scoreboard
    key = SCOREBOARD[i];
    j = i - 1;
    
    if(key > -1){
      scoreI = rint(stof(getplayerkeyvalue(key, "frags")));
    }
    else{
      scoreI = 0;
    }
    
    while( ((j >= 0) && (scoreJ < scoreI)) ){
      key2 = SCOREBOARD[j];
      if(key2 > -1){
        scoreJ = rint(stof(getplayerkeyvalue(key, "frags")));
      }
      else{
        scoreJ = 0;
      }
      SCOREBOARD[j+1] = SCOREBOARD[j];
      j = j - 1;
    }
    SCOREBOARD[j + 1] = key;
  }
};

/*
  sendent_handle_player()-> SENDFLAG_NEWENT && isNew
  scope: self == player data ent
  player data ent's ID at this point IS the player's Server EntID
    therefore scoreId is then decremented to equal player's local entId;
*/


/*
  I'm gating scoreboard thinks to run at a servertime+interval.
  
  its a damn shame that DP doesn't allow access to the internal scoreboard code seeing as how
    everytime you call getplayerkeyvalue(), it also calls SB_SortFrags().
    
    See for yourself:
      VM_CL_getplayerkey() in clvm_cmds.c, Line 570 in xonotic/darkplaces.
      why! why!?
    
  and this doesnt even address the fact that local player ent can be 0
  which does not play nice at all with arrays. :|
*/
void() scoreboard_think={
  local float playerId;
  local string nameCheck;
  
  //(float playernum, string keyname) getplayerkeyvalue
  if( servertime > SCOREBOARD_NEXT_UPDATE ){
    //stand up the scoreboard every cycle to account for players leaving
    for(playerId = 0; playerId < maxclients; playerId = playerId + 1){
      nameCheck = getplayerkeyvalue(playerId, "name");
      if(nameCheck != "" || nameCheck){
        SCOREBOARD[playerId] = playerId;
      }
      else{
        SCOREBOARD[playerId] = -1;
      }
    }
    scoreboard_sort();
    SCOREBOARD_NEXT_UPDATE = servertime + SCOREBOARD_UPDATE_RATE;
  }
};

/*
  Campaign / coop stuff
*/
void( float missionStat ) ui_set_mission_status={
  MENU_DEBRIEF_status = missionStat;
  if( missionStat == MISSION_RESULT_WIN ){
    MENU_DEBRIEF_data_mission_status = "- Mission Successful -";
  }
  else{
    MENU_DEBRIEF_data_mission_status = "!- Mission Failed -!";
  }
};
  

//called whenever we switch mechs.
void(vector showAng, vector colors, float useClientColor) menu_player_MechModel_setup={
  local vector colorCt, colorLt, colorRt, colorLa, colorRa, colorLg;
  local entity hardpoint;
  if(useClientColor){
    colorCt = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR1))] * 1.5;
    colorLt = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR2))] * 1.5;
    colorRt = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR3))] * 1.5;
    colorLa = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR4))] * 1.5;
    colorRa = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR5))] * 1.5;
    colorLg = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR6))] * 1.5;
  }
  else{
    colorCt = colors;
    colorLt = colors;
    colorRt = colors;
    colorLa = colors;
    colorRa = colors;
    colorLg = colors;
  }
  
  UI_HANGAR_DATA_mech.angles            = showAng;
  setmodel(UI_HANGAR_DATA_mech.torsoCenter, UI_HANGAR_DATA_mech.torsoCenter.model);
  UI_HANGAR_DATA_mech.torsoCenter.colormod= colorCt;
  UI_HANGAR_DATA_mech.torsoCenter.angles= showAng;
  UI_HANGAR_DATA_mech.torsoCenter.effects = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
  
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_TOR_L) ){
    setmodel(UI_HANGAR_DATA_mech.torsoLeft, UI_HANGAR_DATA_mech.torsoLeft.model);
    UI_HANGAR_DATA_mech.torsoLeft.colormod  = colorLt;
    UI_HANGAR_DATA_mech.torsoLeft.angles  = showAng;
    UI_HANGAR_DATA_mech.torsoLeft.effects   = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
  }
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_TOR_R) ){
    setmodel(UI_HANGAR_DATA_mech.torsoRight, UI_HANGAR_DATA_mech.torsoRight.model);
    UI_HANGAR_DATA_mech.torsoRight.colormod = colorRt;
    UI_HANGAR_DATA_mech.torsoRight.angles = showAng;
    UI_HANGAR_DATA_mech.torsoRight.effects  = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
  }
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_ARM_L) ){
    setmodel(UI_HANGAR_DATA_mech.armLeft, UI_HANGAR_DATA_mech.armLeft.model);
    UI_HANGAR_DATA_mech.armLeft.colormod    = colorLa;
    UI_HANGAR_DATA_mech.armLeft.angles    = showAng;
    UI_HANGAR_DATA_mech.armLeft.effects     = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
  }
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_ARM_R) ){
    setmodel(UI_HANGAR_DATA_mech.armRight, UI_HANGAR_DATA_mech.armRight.model);
    UI_HANGAR_DATA_mech.armRight.colormod   = colorRa;
    UI_HANGAR_DATA_mech.armRight.angles   = showAng;
    UI_HANGAR_DATA_mech.armRight.effects    = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
  }
  setmodel(UI_HANGAR_DATA_mech.legs, UI_HANGAR_DATA_mech.legs.model);
  UI_HANGAR_DATA_mech.legs.colormod       = colorLg;
  UI_HANGAR_DATA_mech.legs.angles       = showAng;
  UI_HANGAR_DATA_mech.legs.effects        = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
  UI_HANGAR_DATA_mech.legs.frame = 0;
  
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while(hardpoint){
    data_get_client_item_( hardpoint, hardpoint.data_idx );
    setmodel(hardpoint, hardpoint.model);
    hardpoint.colormod = '1.0 1.0 1.0';
    hardpoint.angles = showAng;
    hardpoint.effects = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
    hardpoint  = hardpoint.w_slot;
  }
};

void() menu_player_MechModel_color_update={
  local vector colorCt, colorLt, colorRt, colorLa, colorRa, colorLg;
  
  colorCt = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR1))] * 1.5;
  colorLt = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR2))] * 1.5;
  colorRt = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR3))] * 1.5;
  colorLa = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR4))] * 1.5;
  colorRa = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR5))] * 1.5;
  colorLg = CLR_PLAYER_LIST[stof(infoget(CLIENT_INFO_STRING, KEY_COLOR6))] * 1.5;
  
  UI_HANGAR_DATA_mech.torsoCenter.colormod = colorCt;
  
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_TOR_L) ){
    UI_HANGAR_DATA_mech.torsoLeft.colormod  = colorLt;
  }
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_TOR_R) ){
    UI_HANGAR_DATA_mech.torsoRight.colormod = colorRt;
  }
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_ARM_L) ){
    UI_HANGAR_DATA_mech.armLeft.colormod    = colorLa;
  }
  if( (UI_HANGAR_DATA_mech.unitModFlags & MOD_HAS_ARM_R) ){
    UI_HANGAR_DATA_mech.armRight.colormod   = colorRa;
  }
  UI_HANGAR_DATA_mech.legs.colormod       = colorLg;
};