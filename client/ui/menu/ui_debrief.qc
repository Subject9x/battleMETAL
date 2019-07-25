/*
battleMETAL
Author: Peter Roohr
Date: 07/23/2019
Overview: 
  Debriefing screen ( sure, score screen).
  Occurs once the map has sent the PLAYER_INTERMSN.
*/

//menu hooks
void() menu_debriefListener_onClick={
  //next/retry mission button
  
};

void() menu_debriefListener_onHover={

};
//void() menu_debriefListener_onDrag; unused

//menu rendering
void() menu_debrief_drawFrame={
  local vector topleftroot;
  topleftroot = VIEW_ORG;

  drawpic(topleftroot, UI_DEF_BOX_512, VIEW_MAX, CLR_DEF_UI_DEPLOY, 1, 0);
  menu_debrief_header( topleftroot );
  menu_debrief_objectives_primary( topleftroot + gui_percentToPixelRawVec('10 32') );
  menu_debrief_objectives_secondary( topleftroot + gui_percentToPixelRawVec('10 272') );
  menu_debrief_stats( topleftroot + gui_percentToPixelRaw(VIEW_CTR_x, 32) );
  menu_debrief_unlocks( topleftroot + gui_percentToPixelRaw(VIEW_CTR_x, 160) );
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
  local float nextMissionLen;
  
  nextMissionOrg_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw(138);//106 accounts for pesky 10px margin
  nextMissionOrg_y = gui_percentYRaw(6);
  drawpic( nextMissionOrg, UI_DEF_BOX_256, gui_percentToPixelRawVec('128 24'), CLR_DEF_GRAY_H, 1, 0);
  
  //TODO - what to do with FAILED missions?
  nextMissionLen = stringwidth( "[Next Mission]", 0, '18 14');
  nextMissionLabelOrg_x = gui_percentXRaw(VIEW_MAX_x) - gui_percentXRaw( nextMissionLen / 2) - gui_percentXRaw(138/2);  //106 accounts for pesky 10px margin
  nextMissionLabelOrg_y = gui_percentYRaw(10);
  drawstring( nextMissionLabelOrg, "[Next Mission]", '18 14', '1 1 1', 1, 0);
  
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
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
  
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
  endOfLine = TRUE;
  while(endOfLine){
    objectiveOffset = listStartOrg;
    objectiveOffset_y = objectiveOffset_y + gui_percentYRaw(line_return) + ( (list_index - 1) * gui_percentYRaw(18));
    objectiveType = MSN_OBJ_TYPES[list_index];
    
    if( objectiveType == "primary" ){
      objectiveStatus = OBJECTIVES[list_index];
      if( objectiveStatus != FALSE ){
        show_index = show_index + 1;
        objectiveDesc = MSN_OBJ_DESC[list_index];
        
        drawstring( objectiveOffset, strcat(ftos(show_index),")"), '12 12', CLR_DEF_GRAY_H, 1, 0);
        line_return = gui_wrapText(objectiveOffset + gui_percentToPixelRawVec('12 0'), '225 150', objectiveDesc, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
        
        if( objectiveStatus == 2 ){
          objectiveStatusLabel = "Complete";
          objectiveColor = CLR_DEF_ARM_OK;
        }
        else if( objectiveStatus == 1 ){
          objectiveStatusLabel = "Incomplete";
          objectiveColor = CLR_DEF_TXT_NONSELECT;
        }
        else if( objectiveStatus == -1 ){
          objectiveStatusLabel = "Failed";
          objectiveColor = CLR_DEF_ARM_ONEQ;
        }
        objectiveStatusLen = stringwidth( objectiveStatusLabel, 0, '12 12');
        objectiveStatusOrg_x = (objectiveOffset_x + panelImageSize_x) - gui_percentXRaw(54 + (objectiveStatusLen / 2));
        objectiveStatusOrg_y = objectiveOffset_y;
        drawstring(objectiveStatusOrg, objectiveStatusLabel, '12 12', objectiveColor, 1, 0);
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
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
  
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
  
  listStartOrg = thisOrg + gui_percentToPixelRawVec('6 8');
  list_index = 1;
  show_index = 0;
  line_return = 0;
  endOfLine = TRUE;
  while(endOfLine){
    objectiveOffset = listStartOrg;
    objectiveOffset_y = objectiveOffset_y + gui_percentYRaw(line_return) + ( (list_index - 1) * gui_percentYRaw(18));
    objectiveType = MSN_OBJ_TYPES[list_index];
    
    if( objectiveType == "secondary" ){
      objectiveStatus = OBJECTIVES[list_index];
      if( objectiveStatus != FALSE ){
        show_index = show_index + 1;
        objectiveDesc = MSN_OBJ_DESC[list_index];
        
        drawstring( objectiveOffset, strcat(ftos(show_index),")"), '12 12', CLR_DEF_GRAY_H, 1, 0);
        line_return = gui_wrapText(objectiveOffset + gui_percentToPixelRawVec('12 0'), '225 150', objectiveDesc, '12 12 0', CLR_DEF_TXT_GRAY_SMOOTH, 1);
        
        if( objectiveStatus == 2 ){
          objectiveStatusLabel = "Complete";
          objectiveColor = CLR_DEF_ARM_OK;
        }
        else if( objectiveStatus == 1 ){
          objectiveStatusLabel = "Incomplete";
          objectiveColor = CLR_DEF_TXT_NONSELECT;
        }
        else if( objectiveStatus == -1 ){
          objectiveStatusLabel = "Failed";
          objectiveColor = CLR_DEF_ARM_ONEQ;
        }
        objectiveStatusLen = stringwidth( objectiveStatusLabel, 0, '12 12');
        objectiveStatusOrg_x = (objectiveOffset_x + panelImageSize_x) - gui_percentXRaw(64 + (objectiveStatusLen / 2));
        objectiveStatusOrg_y = objectiveOffset_y;
        drawstring(objectiveStatusOrg, objectiveStatusLabel, '12 12', objectiveColor, 1, 0);
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
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);

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
  drawstring( thisOrg + gui_percentToPixelRawVec('96 72'), sprintf("%000.2f",ftos(MENU_DEBRIEF_time_elapsed)), '16 16', '1 1 1', 1, 0);
  
  
  
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
  drawpic(thisOrg, UI_DEF_BOX_512, panelImageSize, CLR_DEF_UI_DEPLOY, 1, 0);
  
  //unlocks label
  local float unlocksLabelLen;
  local vector unlocksLabelOrg;
  unlocksLabelLen = stringwidth( "-New Equipment Unlocked-", 0, '10 10');
  unlocksLabelOrg_x = thisOrg_x + gui_percentXRaw(6);
  unlocksLabelOrg_x = unlocksLabelOrg_x + gui_percentXRaw( panelImageSize_x / 2);
  unlocksLabelOrg_x = unlocksLabelOrg_x - gui_percentXRaw(12);
  unlocksLabelOrg_x = unlocksLabelOrg_x - gui_percentXRaw( unlocksLabelLen / 2 );
  unlocksLabelOrg_y = thisOrg_y + gui_percentYRaw(6);
  drawstring( unlocksLabelOrg, "-New Equipment Unlocked-", '10 10', CLR_DEF_GRAY_H, 1 , 0);
  
  //DEBUG - tokenize overlap with loading mech data!
  local float tokenId;
  local float tokenMax;
  local string token;
  local float tokenValue;
  //New Mechs
  local float mechY;
  local vector mechStartOrg;
  local vector mechOrg;
  mechStartOrg = thisOrg + gui_percentToPixelRawVec('0 220');
  mechY = 0;
  tokenMax = tokenizebyseparator( MENU_DEBRIEF_unlocks_mechs, " " );
  tokenId = 0;
  while( tokenId < tokenMax ){
    token = argv(tokenId);
    if( token != ""){
      tokenValue = stof(token);

      if( tokenValue != 0 ){
        ui_data_load_mech( stof(token) );
        mechOrg = mechStartOrg;
        mechOrg_x = mechOrg_x + gui_percentXRaw( tokenId * 48 );
        if( mechOrg_x > (thisOrg_x + panelImageSize_x) ){
          mechY = mechY + 1;
        }
        mechOrg_y = mechOrg_y + gui_percentYRaw( mechY * 64 );
        drawpic( mechOrg, MECH_DATA_ICON, '60 64', '1 1 1', 1, 0);
      }
    }
    tokenId = tokenId + 1;
  }
    
  //New Weapons
  local float weaponY;
  local vector weaponStartOrg;
  local vector weaponOrg;
  
  weaponStartOrg = thisOrg + gui_percentToPixelRawVec('6 24');
  weaponY = 0;
  tokenMax = tokenizebyseparator( MENU_DEBRIEF_unlocks_equip, " " );
  tokenId = 0;
  while( tokenId < tokenMax ){
    token = argv(tokenId);
    if( token != ""){
      tokenValue = stof(token);
      data_get_client_item_( UI_ARMING_DATA_item_list, stof(token) );
      weaponOrg = weaponStartOrg;
      weaponOrg_x = weaponOrg_x + gui_percentXRaw( tokenId * 32 );
      if( weaponOrg_x > (thisOrg_x + panelImageSize_x) ){
        weaponY = weaponY + 1;
      }
      weaponOrg_y = weaponOrg_y + gui_percentYRaw( weaponY * 32 );
      drawpic( weaponOrg, UI_ARMING_DATA_item_list.icon, '28 28', '1 1 1', 1, 0);
    }
    tokenId = tokenId + 1;
  }
  
  //New Equipment
  
  drawfont = drawfont_prev;
};