/*
battleMETAL
Author: Peter Roohr
Date: 07/23/2019
Overview: 
  Debriefing screen -
  this is generally triggered by player death or mission end.
  used only for campaign missions.
  
  playerState = PLAYER_DEBRIEF
*/

//menu hooks
void() menu_debriefListener_onClick={
  //next/retry mission button
  if( servertime > MENU_button_delay ){
    if( menu_checkMouseInBounds(cursorpos, MENU_DEBRIEF_BUTTON_ORG_mission, gui_percentToPixelRawVec('128 24'), TRUE) ){
      //Single player 
      if( cvar("gamemode") == GAMEMODE_CAMPAIGN ){
        setpause( 0 );
        cl_set_mission( MENU_DEBRIEF_status );
        return;
      }
      //DEATHMATCH AND COOP
      cl_set_mission( 2 );
      CLIENT_MENU_menu_choice = MENU_BRIEF_ACTIVE;
      LAUNCH_VALIDATION = LAUNCH_VALIDATION - (LAUNCH_VALIDATION & (VALID_MECH | VALID_GRPS | VALID_NODE | VALID_LAUNCH));
    }
  }
};

void() menu_debriefListener_onHover={

};
//void() menu_debriefListener_onDrag; unused

//menu rendering
void() menu_debrief_drawFrame={
      cons_logAFloat("MENU_button_delay", MENU_button_delay);  //debug
      cons_logAFloat("servertime", time);  //debug
  local vector topleftroot;
  topleftroot = VIEW_ORG;

  if( cvar("gamemode") != GAMEMODE_CAMPAIGN ){
    if( SV_MISSIONSTATUS == MISSION_STATUS_ACTIVE ){
      if( CLIENT_player_deadflag > DEAD_NO ){
        MENU_DEBRIEF_status = 0;
      }
    }
  }

  gui_renderTintImage2(MENU_DEBRIEF_status, topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_DEPLOY, CLR_DEF_ARM_HALF - '0.15 0.15 0.15', 1, 0) ;  
  menu_debrief_header( topleftroot );
  menu_debrief_objectives_primary( topleftroot + gui_percentToPixelRawVec('10 32') );
  menu_debrief_objectives_secondary( topleftroot + gui_percentToPixelRawVec('10 272') );
  menu_debrief_stats( topleftroot + gui_percentToPixelRaw(VIEW_CTR_x, 32) );
  //menu_debrief_unlocks( topleftroot + gui_percentToPixelRaw(VIEW_CTR_x, 160) );
};

/*
  Title and Next Mission Button
*/
void(vector panelOffset) menu_debrief_header={
  local vector thisOrg;
  local float statusLen;
  local vector statusOrg;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  thisOrg = panelOffset;
  
  //Mission Status Label
  statusLen = stringwidth( MENU_DEBRIEF_data_mission_status, 0, '22 22');
  statusOrg_x = thisOrg_x + gui_percentXRaw( VIEW_MAX_x / 2 ) - gui_percentXRaw( statusLen /2 );
  statusOrg_y = gui_percentYRaw(10);
  gui_renderHighlightString(MENU_DEBRIEF_data_mission_status, statusOrg, CLR_DEF_ARM_OK, CLR_DEF_ARM_THREEQ, MENU_DEBRIEF_status, '22 22', 1, 0);
  
  //Next Mission Button
  local vector nextMissionOrg;
  local vector nextMissionLabelOrg;
  
  nextMissionOrg_x = VIEW_MAX_x - gui_percentXRaw(138);
  nextMissionOrg_y = gui_percentYRaw(6);
  drawpic( nextMissionOrg, UI_DEF_BOX_256_BOX, gui_percentToPixelRawVec('128 24'), CLR_DEF_GRAY_H, 1, 0);
  MENU_DEBRIEF_BUTTON_ORG_mission = nextMissionOrg;
  
  //TODO - what to do with FAILED missions?
  local string missionStatus;
  if( MENU_DEBRIEF_status ){
    missionStatus = "[Next Mission]";
    nextMissionLabelOrg_x = nextMissionOrg_x + gui_percentXRaw(16);
  }
  else{
    missionStatus = "<< Retry ";
    nextMissionLabelOrg_x = nextMissionOrg_x + gui_percentXRaw(32);
  }
  nextMissionLabelOrg_y = gui_percentYRaw(10);
  drawstring( nextMissionLabelOrg, missionStatus, '18 14', '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
};

/*
  Primary Objectives Panel
*/
void(vector panelOffset) menu_debrief_objectives_primary={
  local vector thisOrg;
  local vector panelImageSize;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  //background panel image
  thisOrg = panelOffset;
  panelImageSize_x = gui_percentXRaw(VIEW_CTR_x);
  panelImageSize_y = gui_percentYRaw(240);
  gui_renderTintImage2(MENU_DEBRIEF_status, thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, CLR_DEF_ARM_HALF, 1, 0) ; 
  
  //panel label
  local vector objectivesLabelOrg;
  local float objectivesLabelLen;
  objectivesLabelLen = stringwidth( "-Primary Objectives-", 0, '12 12');
  objectivesLabelOrg_x = thisOrg_x + gui_percentXRaw( panelImageSize_x / 4 );
  objectivesLabelOrg_x = objectivesLabelOrg_x - gui_percentXRaw(10) - gui_percentXRaw( objectivesLabelLen / 2 );
  objectivesLabelOrg_y = thisOrg_y + gui_percentYRaw(4);
  drawstring( objectivesLabelOrg, "-Primary Objectives-", '12 12', CLR_DEF_GRAY_H, 1, 0);
  
  //objective status
  drawstring( thisOrg + gui_percentToPixelRaw(VIEW_CTR_x - (VIEW_CTR_x / 4.5), 4), "- Status -", '12 12', CLR_DEF_GRAY_H, 1, 0);
  
  //Objectives List
  local vector listStartOrg;
  local float endOfLine;
  local float list_index;
  local float show_index;
  local float line_return;
  local vector objectiveOffset;  
  local string objectiveDesc;
  local string objectiveType;
  local string objectiveStatusLabel;
  local float objectiveStatus;
  local vector objectiveColor;
  local vector objectiveStatusOrg;
  local float objectiveStatusLen;
  
  listStartOrg = thisOrg + gui_percentToPixelRawVec('6 20');
  list_index = 1;
  show_index = 0;
  line_return = 0;
  objectiveOffset = listStartOrg;
  objectiveOffset_y = objectiveOffset_y + line_return + (show_index * gui_percentYRaw(16));
  endOfLine = TRUE;
  while(endOfLine){
    objectiveType = MSN_OBJ_TYPES[list_index];

    if( objectiveType == "primary" ){
      objectiveStatus = OBJECTIVES[list_index];
      if( objectiveStatus != OBJECTIVE_DISABLE ){
        show_index = show_index + 1;
        objectiveDesc = MSN_OBJ_DESC[list_index];
        
        drawstring( objectiveOffset, strcat(ftos(show_index),")"), '12 12', CLR_DEF_GRAY_H, 1, 0);
        line_return = gui_wrapText(objectiveOffset + gui_percentToPixelRawVec('12 0'), '225 150', objectiveDesc, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
        
        if( objectiveStatus == OBJECTIVE_WIN ){
          objectiveStatusLabel = "Complete";
          objectiveColor = CLR_DEF_ARM_OK;
        }
        else if( objectiveStatus == OBJECTIVE_ACTIVE ){
          objectiveStatusLabel = "Incomplete";
          objectiveColor = CLR_DEF_TXT_NONSELECT - '0.1 0.1 0.1';
        }
        else if( objectiveStatus == OBJECTIVE_FAIL ){
          objectiveStatusLabel = "Failed";
          objectiveColor = CLR_DEF_ARM_ONEQ;
        }
        objectiveStatusLen = stringwidth( objectiveStatusLabel, 0, '16 16');
        objectiveStatusOrg_x = (objectiveOffset_x + panelImageSize_x) - gui_percentXRaw(54 + (objectiveStatusLen / 2));
        objectiveStatusOrg_y = objectiveOffset_y;
        drawstring(objectiveStatusOrg, objectiveStatusLabel, '16 16', objectiveColor, 1, 0);
        objectiveOffset_y = objectiveOffset_y + line_return + gui_percentYRaw(12);
      }
    }

    if(MSN_OBJ_DESC[(list_index+1)] == ""){
      endOfLine = FALSE;
    }
    list_index = list_index + 1;
  }
  
  drawfont = drawfont_prev;
};

/*
  Secondary Objectives Panel
*/
void(vector panelOffset) menu_debrief_objectives_secondary={
  local vector thisOrg;
  local vector panelImageSize;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  //background panel image
  thisOrg = panelOffset;
  panelImageSize_x = gui_percentXRaw(VIEW_CTR_x);
  panelImageSize_y = gui_percentYRaw(160);
  gui_renderTintImage2(MENU_DEBRIEF_status, thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, CLR_DEF_ARM_HALF, 1, 0) ; 
  
  //panel label
  local vector objectivesLabelOrg;
  local float objectivesLabelLen;
  objectivesLabelLen = stringwidth( "-Secondary Objectives-", 0, '12 12');
  objectivesLabelOrg_x = thisOrg_x + gui_percentXRaw( panelImageSize_x / 4 );
  objectivesLabelOrg_x = objectivesLabelOrg_x - gui_percentXRaw(10) - gui_percentXRaw( objectivesLabelLen / 2 );
  objectivesLabelOrg_y = thisOrg_y + gui_percentYRaw(4);
  drawstring( objectivesLabelOrg, "-Secondary Objectives-", '12 12', CLR_DEF_GRAY_H, 1, 0);
  
  //objective status
  drawstring( thisOrg + gui_percentToPixelRaw(VIEW_CTR_x - (VIEW_CTR_x / 4.5), 4), "- Status -", '12 12', CLR_DEF_GRAY_H, 1, 0);
  
  //Objectives List
  local vector listStartOrg;
  local float endOfLine;
  local float list_index;
  local float show_index;
  local float line_return;
  local vector objectiveOffset;  
  local string objectiveDesc;
  local string objectiveType;
  local string objectiveStatusLabel;
  local float objectiveStatus;
  local vector objectiveColor;
  local vector objectiveStatusOrg;
  local float objectiveStatusLen;
  
  listStartOrg = thisOrg + gui_percentToPixelRawVec('6 20');
  list_index = 1;
  show_index = 0;
  line_return = 0;
  objectiveOffset = listStartOrg;
  objectiveOffset_y = objectiveOffset_y + line_return + (show_index * gui_percentYRaw(16));
  endOfLine = TRUE;
  while(endOfLine){
    objectiveType = MSN_OBJ_TYPES[list_index];
    
    if( objectiveType == "secondary" ){
      objectiveStatus = OBJECTIVES[list_index];
      if( objectiveStatus != OBJECTIVE_DISABLE ){
        show_index = show_index + 1;
        objectiveDesc = MSN_OBJ_DESC[list_index];
        
        drawstring( objectiveOffset, strcat(ftos(show_index),")"), '12 12', CLR_DEF_GRAY_H, 1, 0);
        line_return = gui_wrapText(objectiveOffset + gui_percentToPixelRawVec('12 0'), '225 150', objectiveDesc, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
        
        if( objectiveStatus == OBJECTIVE_WIN ){
          objectiveStatusLabel = "Complete";
          objectiveColor = CLR_DEF_ARM_OK;
        }
        else if( objectiveStatus == OBJECTIVE_ACTIVE ){
          objectiveStatusLabel = "Incomplete";
          objectiveColor = CLR_DEF_TXT_NONSELECT;
        }
        else if( objectiveStatus == OBJECTIVE_FAIL ){
          objectiveStatusLabel = "Failed";
          objectiveColor = CLR_DEF_ARM_ONEQ;
        }
        objectiveStatusLen = stringwidth( objectiveStatusLabel, 0, '16 16');
        objectiveStatusOrg_x = (objectiveOffset_x + panelImageSize_x) - gui_percentXRaw(54 + (objectiveStatusLen / 2));
        objectiveStatusOrg_y = objectiveOffset_y;
        drawstring(objectiveStatusOrg, objectiveStatusLabel, '16 16', objectiveColor, 1, 0);
        objectiveOffset_y = objectiveOffset_y + line_return + gui_percentYRaw(12);
      }
    }

    if(MSN_OBJ_DESC[(list_index+1)] == ""){
      endOfLine = FALSE;
    }
    list_index = list_index + 1;
  }
  
  drawfont = drawfont_prev;
  drawfont = drawfont_prev;
};

/*
  Mission Stats Panel
*/
void(vector panelOffset) menu_debrief_stats={
  local vector thisOrg;
  local vector panelImageSize;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  //background panel image
  thisOrg = panelOffset;
  thisOrg_x = thisOrg_x + gui_percentXRaw(10);
  panelImageSize_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw( VIEW_CTR_x);
  panelImageSize_x = panelImageSize_x - gui_percentXRaw(20);
  panelImageSize_y = gui_percentYRaw( 128 );
  gui_renderTintImage2(MENU_DEBRIEF_status, thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, CLR_DEF_ARM_HALF, 1, 0) ; 

  //stats label
  local float statsLabelLen;
  local vector statsLabelOrg;
  statsLabelLen = stringwidth( "-Mission Results-", 0, '10 10');
  statsLabelOrg_x = thisOrg_x + gui_percentXRaw(6);
  statsLabelOrg_x = statsLabelOrg_x + gui_percentXRaw( panelImageSize_x / 2);
  statsLabelOrg_x = statsLabelOrg_x - gui_percentXRaw(12);
  statsLabelOrg_x = statsLabelOrg_x - gui_percentXRaw( statsLabelLen / 2 );
  statsLabelOrg_y = thisOrg_y + gui_percentYRaw(6);
  drawstring( statsLabelOrg, "-Mission Results-", '10 10', CLR_DEF_GRAY_H, 1 , 0);

  //Kills
  drawstring( thisOrg + gui_percentToPixelRawVec('6 24'), "Kills:", '14 14', CLR_DEF_GRAY_H, 1, 0);
  drawstring( thisOrg + gui_percentToPixelRawVec('96 24'), strcat(ftos(MENU_DEBRIEF_total_kills),"/", ftos(MENU_DEBRIEF_total_monsters)), '16 16', '1 1 1', 1, 0);
  
  //Losses
  drawstring( thisOrg + gui_percentToPixelRawVec('6 48'), "Losses:", '14 14', CLR_DEF_GRAY_H, 1, 0);
  drawstring( thisOrg + gui_percentToPixelRawVec('96 48'), strcat(ftos(MENU_DEBRIEF_total_losses), "/", ftos(MENU_DEBRIEF_total_allies)), '16 16', '1 1 1', 1, 0);
  
  //Time taken
  drawstring( thisOrg + gui_percentToPixelRawVec('6 72'), "Mission Time:", '14 14', CLR_DEF_GRAY_H, 1, 0);
  drawstring( thisOrg + gui_percentToPixelRawVec('96 72'), sprintf("%00.2f",MENU_DEBRIEF_time_elapsed), '16 16', '1 1 1', 1, 0);
  
  drawfont = drawfont_prev;
};

/*
  Inventory Unlocks Panel
*/
void(vector panelOffset) menu_debrief_unlocks={
  local vector thisOrg;
  local vector panelImageSize;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  //background panel image
  thisOrg = panelOffset;
  thisOrg_x = thisOrg_x + gui_percentXRaw(10);
  panelImageSize_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw( VIEW_CTR_x);
  panelImageSize_x = panelImageSize_x - gui_percentXRaw(20);
  panelImageSize_y = gui_percentYRaw( 300 );
  gui_renderTintImage2(MENU_DEBRIEF_status, thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, CLR_DEF_ARM_HALF, 1, 0) ; 
  
  //unlocks label
  local float unlocksLabelLen;
  local vector unlocksLabelOrg;
  unlocksLabelLen = stringwidth( "-New Weapons Unlocked-", 0, '10 10');
  unlocksLabelOrg_x = thisOrg_x + gui_percentXRaw( panelImageSize_x / 2) - gui_percentXRaw( unlocksLabelLen / 2 );
  unlocksLabelOrg_y = thisOrg_y + gui_percentYRaw(6);
  drawstring( unlocksLabelOrg, "-New Weapons Unlocked-", '10 10', CLR_DEF_GRAY_H, 1 , 0);


  local float tokenId;
  local float tokenItr;
  local float tokenMax;
  local string token;
  local float tokenValue;
  local float widthWrapCheck;
  local float widthWrap;
  tokenItr = 0;
  //New Weapons
  local float weaponY;
  local vector weaponStartOrg;
  local vector weaponOrg;
  weaponStartOrg = thisOrg + gui_percentToPixelRawVec('6 24');
  weaponY = 0;
  tokenMax = tokenizebyseparator( MENU_DEBRIEF_unlocks_equip, " " );
  tokenId = 0;
  widthWrap = (weaponStartOrg_x + panelImageSize_x) - gui_percentXRaw(24);
  while( tokenId < tokenMax ){
    token = argv(tokenId);
    if( token != ""){
      tokenValue = stof(token);
      data_get_client_item_( UI_ARMING_DATA_item_list, tokenValue );
      if( !(UI_ARMING_DATA_item_list.damageType & DMG_MSC) ){
        weaponOrg = weaponStartOrg;
        widthWrapCheck = weaponOrg_x + gui_percentXRaw( tokenItr * 32 );
        if( widthWrapCheck < widthWrap ){
          weaponOrg_x = widthWrapCheck;
        }
        else{
          weaponY = weaponY + 1;
          weaponOrg_x = weaponStartOrg_x;
        }
        weaponOrg_y = weaponOrg_y + gui_percentYRaw( weaponY * 32 );
        drawpic( weaponOrg, UI_ARMING_DATA_item_list.icon, '28 28', '1 1 1', 1, 0);
        tokenItr = tokenItr + 1;
      }
    }
    tokenId = tokenId + 1;
  }
  if( weaponY < 1){
    weaponY = weaponY + 1;
  }
 
  weaponY = gui_percentYRaw(weaponY * 32); //lock in y value
  
  //New Equipment
  local vector equipLabelOrg;
  local float equipLabelLen;
  equipLabelLen = stringwidth( "-New Equipment Unlocked-", 0, '10 10 0');
  equipLabelOrg_x = thisOrg_x + gui_percentXRaw(panelImageSize_x / 2) - gui_percentXRaw(equipLabelLen / 2); 
  equipLabelOrg_y = weaponStartOrg_y + gui_percentYRaw(30) + weaponY ;
  drawstring( equipLabelOrg, "-New Equipment Unlocked-", '10 10', CLR_DEF_GRAY_H, 1, 0);
  
  local float equipmentY;
  local vector equipmentStartOrg;
  local vector equipmentOrg;
  equipmentStartOrg_x = thisOrg_x + gui_percentXRaw(6);
  equipmentStartOrg_y = equipLabelOrg_y + gui_percentYRaw(16);
  equipmentY = 0;
  tokenId = 0;
  tokenItr = 0;
  widthWrapCheck = 0;
  widthWrap = (equipmentStartOrg_x + panelImageSize_x) - gui_percentXRaw(24);
  while( tokenId < tokenMax ){
    token = argv(tokenId);
    if( token != ""){
      tokenValue = stof(token);
      data_get_client_item_( UI_ARMING_DATA_item_list, tokenValue );
      if( (UI_ARMING_DATA_item_list.damageType & DMG_MSC) ){
        equipmentOrg = equipmentStartOrg;
        widthWrapCheck = equipmentOrg_x + gui_percentXRaw( tokenItr * 32 );
        if( widthWrapCheck < widthWrap ){
          equipmentOrg_x = widthWrapCheck;
        }
        else{
          equipmentY = equipmentY + 1;
          equipmentOrg_x = equipmentStartOrg_x;
        }
        equipmentOrg_y = equipmentOrg_y + gui_percentYRaw( equipmentY * 32 );
        drawpic( equipmentOrg, UI_ARMING_DATA_item_list.icon, '28 28', '1 1 1', 1, 0);
        tokenItr = tokenItr + 1;
      }
    }
    tokenId = tokenId + 1;
  }
  if( equipmentY < 1){
    equipmentY = equipmentY + 1;
  }
  equipmentY = gui_percentYRaw( equipmentY * 32);
  
  //New Mechs
  local vector mechLabelOrg;
  local float mechLabelLen;
  mechLabelLen = stringwidth( "-New Metal Unlocked-", 0, '10 10 0');
  mechLabelOrg_x = thisOrg_x + gui_percentXRaw(panelImageSize_x / 2) - gui_percentXRaw(mechLabelLen / 2); 
  mechLabelOrg_y = equipmentStartOrg_y + equipmentY + gui_percentYRaw(16);
  drawstring( mechLabelOrg, "-New Metal Unlocked-", '10 10', CLR_DEF_GRAY_H, 1, 0);
  
  local float mechY;
  local vector mechStartOrg;
  local vector mechOrg;
  mechStartOrg_x = thisOrg_x + gui_percentXRaw(-2);
  mechStartOrg_y = mechLabelOrg_y + gui_percentYRaw(16);
  mechY = 0;
  tokenMax = tokenizebyseparator( MENU_DEBRIEF_unlocks_mechs, " " );
  tokenId = 0;
  tokenItr = 0;
  widthWrapCheck = 0;
  widthWrap = (mechStartOrg_x + panelImageSize_x) - gui_percentXRaw(24);
  while( tokenId < tokenMax ){
    token = argv(tokenId);
    if( token != ""){
      tokenValue = stof(token);
      if( tokenValue != 0 ){
        ui_data_load_mech_info( tokenValue, UI_HANGAR_DATA_mech );
        mechOrg = mechStartOrg;
        widthWrapCheck = mechOrg_x + gui_percentXRaw( tokenItr * 46 );
        if( widthWrapCheck < widthWrap ){
          mechOrg_x = widthWrapCheck;
        }
        else{
          mechY = mechY + 1;
          mechOrg_x = mechOrg_x;
        }
        
        mechOrg_y = mechOrg_y + gui_percentYRaw( mechY * 64 );
        drawpic( mechOrg, MECH_DATA_ICON, '60 64', '1 1 1', 1, 0);
        tokenItr = tokenItr + 1;
      }
    }
    tokenId = tokenId + 1;
  }
  
  drawfont = drawfont_prev;
};


