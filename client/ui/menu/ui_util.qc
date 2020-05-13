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
  Renders the weapon icon, and a highlight box for a selected hardpoint in
  the Arming Menu.
*/
void(string imageIcon, vector org, float selected, float allow) ui_renderHardPointGraphic={
  local vector iorg;
  local vector noEditColorAdj;
  local float allowAlpha;
  
  if( imageIcon != ""){
    if(selected){
      iorg = org - gui_percentToPixelRawVec('2 2');
      gui_renderTintImage(selected, iorg, UI_DEF_BOX_256, gui_percentToPixelRawVec('32 32'), CLR_DEF_ARM_THREEQ + '0.1 0.1 0.1' , 1, 0);
    }
    allowAlpha = 0.45;
    if( allow ){
      allowAlpha = 1;
    }
    drawpic( org, imageIcon,  gui_percentToPixelRawVec('28 28'), '1 1 1' - noEditColorAdj, allowAlpha, 0);
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
  drawpic( org, pic, gui_percentToPixelRawVec(imgSize), highColor, 1, 0);
};

/*
  Renders 1 row in the Hangar Menu.
  Displays Hardpoint data for the selected Mech.
*/
void(vector org, float hpt_num, float types, float sz) ui_renderHardpointRow={
  local vector pofs, hptNumOrg, hptSizeOrg;
  local string hardpointLabel;
  local float drawfontLocal;
  
  drawfontLocal = drawfont;
  drawfontLocal = FONT_NUM_ROBOT_REGULAR;
  
  pofs = org + gui_percentToPixelRawVec('-10 -15');
  pofs_y = pofs_y + gui_percentYRaw(((hpt_num + 1) * 20));
  
  hardpointLabel = strcat(ftos(hpt_num + 1),")");
  
  hptNumOrg = pofs;
  hptNumOrg_x = hptNumOrg_x + gui_percentXRaw(25 / 2) - gui_percentXRaw(stringwidth(hardpointLabel, 0, '12 12 0') / 2);
  
  drawstring(hptNumOrg, hardpointLabel, '12 12 0', CLR_DEF_RET_HASLOCK, 1, 0);
  
  local float itr;
  local float hpointVal;
  local vector itemColor;
  
  hptSizeOrg = hptNumOrg;
  hptSizeOrg_x = hptSizeOrg_x + gui_percentXRaw(11);
  hpointVal = 1;
  for( itr = 0; itr < 16; itr = itr + 1 ){
    if( (sz & hpointVal) ){
      itemColor = '1 1 1';
    }
    else{
      itemColor = '0.33 0.33 0.33';
    }
    ui_renderHardpoint_class_pair( hptSizeOrg, '14 14', hpointVal, itemColor);
    
    hptSizeOrg_x = hptSizeOrg_x + gui_percentXRaw(15);
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
  width = stringwidth(hardpointLabel, 0, gui_percentToPixelRawVec('16 14'));
  numberOrg = org;
  numberOrg_x = numberOrg_x - gui_percentXRaw(width / 2);
  drawstring(numberOrg, hardpointLabel, gui_percentToPixelRawVec('16 14'), CLR_DEF_RET_HASLOCK, 1, 0);
  
  drawfont = drawfontLocal;
};

/*
float SPRITE_deploy_point_FRAME;
float SPRITE_deploy_point_FRAME_MAX;
string SPRITE_deploy_point_FRAMES[3];
*/
void(vector org, vector imageSize, vector imageColor, float imageAlpha ) ui_renderSprite_DeployPoint={
  local vector screenImageSize;
  
  screenImageSize = gui_percentToPixelRawVec( imageSize );
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
  local float t, sec, min, hr;
  local float endTime;
  endTime = getstatf(STAT_TIMELIMIT) * 60;
  if( getstatf(STAT_TIMELIMIT) > 0  || cvar("gamemode") == GAMEMODE_COOP ){
    if( cvar("gamemode") == GAMEMODE_COOP) {
      t = servertime + (servertime - time);
    }
    else{
      endTime = endTime + SV_STARTTIME;
      t = servertime + (servertime - time);
      t = endTime - t ;
    }
    
    sec = t - floor( t / 60 ) * 60 ;
    sec = rint(sec);
    
    min = (t - floor( t / 3600) * 3600) / 60;
    min = rint(min);
    
    hr = t / 3600;
    hr = rint(hr);
    val = sprintf("%02d:%02d:%02d", hr, min, sec);
  }else{
    val = "No Limit";
  }
  
  return val;
};

string(float timeVal ) ui_calculate_time_string={
  local string val;
  local float t, sec, min, hr;
  
  t = timeVal + (servertime - time);
  sec = t - floor( t / 60 ) * 60 ;
  sec = rint(sec);
  
  min = (t - floor( t / 3600) * 3600) / 60;
  min = rint(min);
  
  hr = t / 3600;
  hr = rint(hr);
  val = sprintf("%02d:%02d:%02d", hr, min, sec);
  
  return val;
};

string() ui_label_mission_status={
  local string val;
//TODO fix 
 switch( SV_MISSIONSTATUS ){
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
  SCOREBOARD[]; <k, v> = itr, .entId
  SCORETABLE[]; <k, v> = .entId, .kills
*/
void() scoreboard_sort={
  local float i, j, key, key2;
  local float entScore1, entScore2;
  local entity player, nextPlayer;
  
  for( i=1; i < SCOREBOARDMAX; i=i+1){
    // entId from scoreboard
    key = SCOREBOARD[i];
    j = i - 1;
    while( ((j >= 0) && (SCORETABLE[key2] < SCORETABLE[key])) ){
      key2 = SCOREBOARD[j];
      SCOREBOARD[j+1] = SCOREBOARD[j];
      j = j - 1;
    }
    SCOREBOARD[j + 1] = key;
  }
};

/*
  sendent_handle_player()-> SENDFLAG_NEWENT && isNew
  scope: self == player data ent
*/
void( float scoreId, float score ) scoreboard_push={
  local float i, j;
  local float exist;
  
  exist = FALSE;
  
  for( i = 0; i < SCOREBOARDMAX; i = i + 1){
    if( SCOREBOARD[i] == scoreId ){
      exist = TRUE;
      SCORESTACK = i;
    }
    else{
      if( (i + 1) <= SCOREBOARDMAX ){
        j = i + 1;
        if( SCOREBOARD[i] != 0 && SCOREBOARD[j] == 0 ){
          SCORESTACK = j;
          break;
        }
      }
    }
  }
  if( !exist ){
    SCOREBOARD[SCORESTACK] = scoreId;
  }
  SCORETABLE[scoreId] = score;
};

void( entity newScore ) scoreboard_sort_push={

};

void( entity removed ) scoreboard_stitch={
  local float i;
  local float exist;
  
  exist = -1;
  
  for( i = 0; i < SCOREBOARDMAX; i = i + 1){
    if( SCOREBOARD[i] == removed.entId ){
      exist = i;
    }
  }
  if( exist > -1){
    SCOREBOARD[exist] = 0;
    SCORETABLE[removed.entId] = 0;
    SCORESTACK = SCORESTACK - 1;
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
  

