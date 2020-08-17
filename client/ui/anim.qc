/*
battleMETAL
Author: Peter Roohr
Date: 3/3/2018
Overview: Implementation file for loading anm files

An 'anim' or 'animatic' file is for playing simple
slideshow-esque animatics
*/

void(string fileToOpen) anm_getFile={
  local float flannel;
  flannel = fopen(fileToOpen, FILE_READ);
  if(flannel > -1){
    fclose(flannel);
  }
  else{
    if( cvar("developer") ){
      cons_logAString("Anim file", strcat(fileToOpen," was not found!"));
    }
  }
};

void(string fileToOpen) anm_parseFile={
  local float flannel, argc, line_tag, frame_count;
  local string file, contents, line;
  
  local vector org;
  local vector siz;
  local vector clr;

  file = strcat(PATH_DATA_ANIM, "/", fileToOpen);
  flannel = fopen( file, FILE_READ);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{", ",", "}");
  line = fgets(flannel);
  frame_count = 0;
  while( (line != "") ){
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "'", "'", ": ", ",");
      //meta data tags
      if( argv(1) == ANM_FILE_META_MUS ){
        if( argv(3) != ""){
          ANM_META_DATA[0] = precache_sound2(strzone(argv(3)));
        }
      }
      if( argv(1) == ANM_FILE_META_MUS_NO ){
        ANM_META_DATA[1] = strzone(argv(3));
      }
      if( argv(1) == ANM_FILE_META_BACK ){
        if( argv(3) != ""){
          ANM_META_DATA[2] = strzone(argv(3));
        }
      }
      if( argv(1) == ANM_FILE_META_TRANS ){
        ANM_META_DATA[3] = strzone(argv(3));
      }
      if( argv(1) == ANM_FILE_META_SKIP ){
        ANM_META_DATA[4] = strzone(argv(3));
      }
      //===================
      //frame data
      if( (argv(1) == ANM_FILE_TAG_IMG) ){
        ANM_FRAME_IMG[frame_count] = argv(3);
        ANM_FRAME_IMG[frame_count] = strzone(ANM_FRAME_IMG[frame_count]);
      }
      if( (argv(1) == ANM_FILE_TAG_POS) ){
        org = stov(argv(3));
        ANM_FRAME_POS[frame_count] = org;
      }
      if( (argv(1) == ANM_FILE_TAG_SIZE) ){
        siz = stov(argv(3));
        ANM_FRAME_SIZE[frame_count] = siz;
      }
      if( (argv(1) == ANM_FILE_TAG_SND) ){
        ANM_FRAME_SND[frame_count] = argv(3);
        ANM_FRAME_SND[frame_count] = strzone(ANM_FRAME_SND[frame_count]);
      }
      if( (argv(1) == ANM_FILE_TAG_TIM) ){
        ANM_FRAME_TIM[frame_count] = stof(argv(3));
      }
      if( (argv(1) == ANM_FILE_TAG_MSG) ){
        ANM_FRAME_MSG[frame_count] = argv(3);
        ANM_FRAME_MSG[frame_count] = strzone(ANM_FRAME_MSG[frame_count]);
      }
      if( (argv(1) == ANM_FILE_TAG_ALPHA) ){
        ANM_FRAME_ALPHA[frame_count] = stof(argv(3));
      }
      if( (argv(1) == ANM_FILE_TAG_COLOR) ){
        clr = stov(argv(3));
        ANM_FRAME_COLOR[frame_count] = clr;
      }
      if( (argv(1) == ANM_FILE_TAG_TXT_CLR) ){
        clr = stov(argv(3));
        ANM_FRAME_TXT_CLR[frame_count] = clr;
      }
      if( (argv(1) == ANM_FILE_TAG_FADE) ){
        ANM_FRAME_FADE[frame_count] =  stof(argv(3));
      }
      
    }
    if( line == "}"){
      frame_count = frame_count + 1;
    }
    line = fgets(flannel);
  }
  fclose(flannel);
  if(frame_count > 0){
    ANM_FRAME_TOTAL = frame_count;
    ANM_FRAME_TIME = time + ANM_FRAME_TIM[ANM_FRAME_CUR];
    ANM_FRAME_CUR = 0;
    ANM_FILE_STATUS = 1;
    ANM_FRAME_ALPHA_CUR = 0;
  }
};


void() anm_execute_frame={
  if(time > ANM_FRAME_TIME){
    ANM_FRAME_TIME = 0;
    ANM_FRAME_CUR_FADE_STEP = 0;
    ANM_FRAME_ALPHA_CUR = ANM_FRAME_ALPHA[ANM_FRAME_CUR];
    
    if(ANM_FRAME_CUR == 0){
      //first frame, handle meta data
      if(ANM_META_DATA[1] == "1"){
        localcmd("cd pause");
      }
      if(ANM_META_DATA[0] != ""){
        pointsound(pmove_org, ANM_META_DATA[0], 1, ATTN_NORM); 
      }
    }
    
    ANM_FRAME_CUR = ANM_FRAME_CUR + 1;
    
    if( ANM_FRAME_CUR == ANM_FRAME_TOTAL ){
      anm_cleanup();
      localcmd("cd resume");
      sound7(self, CHAN_WEAPON, "", 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
      return;
    }
    
    if(ANM_FRAME_SND[ANM_FRAME_CUR] != ""){
      pointsound(pmove_org, ANM_FRAME_SND[ANM_FRAME_CUR], 1, ATTN_NONE);
    }
    
    ANM_FRAME_TIME = time + ANM_FRAME_TIM[ANM_FRAME_CUR];
    
    if(ANM_META_DATA[2] != ""){
      drawpic('0 0', ANM_META_DATA[2] , VIEW_MAX, '1 1 1', 1, 0); 
    }
    
    //fade is pre-baked amount of 2 seconds on fade-in and fade-out, 
    //set 'fade' 1 for just fade in, 2 for just fade out, 4 for both
    local float fadeFlag;
    fadeFlag = ANM_FRAME_FADE[ANM_FRAME_CUR];
    
    local float frameSlice;
    frameSlice = 0.1 * ANM_FRAME_ALPHA[ANM_FRAME_CUR];
    ANM_FRAME_CUR_FADE_RATE = frameSlice / 2;
    
    if( (fadeFlag & 1) || (fadeFlag & 4) ){
      ANM_FRAME_ALPHA_CUR = 0;
      ANM_FRAME_CUR_FADE_START = time + 2;
      ANM_FRAME_TIME = ANM_FRAME_TIME + 2;
    }
    else{
      ANM_FRAME_CUR_FADE_START = 0;
    }
    
    if( (fadeFlag & 2) || (fadeFlag & 4) ){
      ANM_FRAME_CUR_FADE_END = time + ANM_FRAME_TIM[ANM_FRAME_CUR] + 2;
      ANM_FRAME_TIME = ANM_FRAME_TIME + 2;
    }
    else{
      ANM_FRAME_CUR_FADE_END = 0;
    }
  }
  else{
    local vector siz, org, frm_color, txt_color;
    
    if(ANM_META_DATA[2] != ""){
      drawpic('0 0', ANM_META_DATA[2] , VIEW_MAX, '1 1 1', 1, 0); 
    }
    
    org = ANM_FRAME_POS[ANM_FRAME_CUR];
    org_x = org_x * VIEW_MAX_x;
    org_y = org_y * VIEW_MAX_y;
    
    if(ANM_FRAME_IMG[ANM_FRAME_CUR] != ""){
      if(time < ANM_FRAME_CUR_FADE_START){
        if( time > ANM_FRAME_CUR_FADE_STEP ){
          ANM_FRAME_CUR_FADE_STEP = time + ANM_FRAME_SLICE;
          if(ANM_FRAME_ALPHA_CUR < ANM_FRAME_ALPHA[ANM_FRAME_CUR] ){
            ANM_FRAME_ALPHA_CUR = ANM_FRAME_ALPHA_CUR + ANM_FRAME_CUR_FADE_RATE;
          }
        }
      }
      if( time >= ANM_FRAME_CUR_FADE_END ){
        if( time > ANM_FRAME_CUR_FADE_STEP ){
          ANM_FRAME_CUR_FADE_STEP = time + ANM_FRAME_SLICE;
          if(ANM_FRAME_ALPHA_CUR > 0){
            ANM_FRAME_ALPHA_CUR = ANM_FRAME_ALPHA_CUR - ANM_FRAME_CUR_FADE_RATE;
          }
        }
      }
      
      frm_color = '1 1 1';
      if(ANM_FRAME_COLOR[ANM_FRAME_CUR] != '0 0 0'){
        frm_color = ANM_FRAME_COLOR[ANM_FRAME_CUR];
      }
      
      siz = ANM_FRAME_SIZE[ANM_FRAME_CUR];
      siz_x = siz_x * VIEW_MAX_x;
      siz_y = siz_y * VIEW_MAX_y;
      cons_logAFloat( ANM_FRAME_IMG[ANM_FRAME_CUR], ANM_FRAME_CUR); //debug
      
      drawpic(org, ANM_FRAME_IMG[ANM_FRAME_CUR], siz, frm_color, ANM_FRAME_ALPHA_CUR, 0);
    } 
    if(ANM_FRAME_MSG[ANM_FRAME_CUR] != ""){
      local vector txtstart;
      local string line;
      local float tokens, tcnt;
      txt_color = '1 1 1';
      if(ANM_FRAME_TXT_CLR[ANM_FRAME_CUR] != '0 0 0'){
        txt_color = ANM_FRAME_TXT_CLR[ANM_FRAME_CUR];
      }
      tcnt = 0;
      line = ANM_FRAME_MSG[ANM_FRAME_CUR];
      tokens = tokenizebyseparator(line, "|");
      txtstart = '0 0';
      txtstart_x = VIEW_CTR_x;
      txtstart_y = VIEW_MAX_y - (tokens * 10);
      while( tcnt <= tokens){
        local float width;
        local vector linepos;
        width = stringwidth(argv(tcnt), 0, '8 8 0');
        linepos_x = txtstart_x - (width / 2);
        linepos_y = txtstart_y + gui_percentYRaw(tcnt * 10);
        drawstring(linepos, argv(tcnt), '8 8 0', txt_color, 0.85, 0);
        tcnt = tcnt + 1;
      }
    }
  }
};

/*
  strunzones the animation frame strings
*/
void() anm_cleanup={
  local float clean;
  clean = 0;
  while(clean <= ANM_FRAME_TOTAL){
    ANM_FRAME_IMG[clean] = "";
    ANM_FRAME_SND[clean] = "";
    ANM_FRAME_TIM[clean] = 0 ;
    clean = clean + 1;
  }
  ANM_FILE_STATUS = -1; 
};

/*
  Calculates the total run time of the animation in seconds
*/
float() anm_total_runtime={
  local float total, itr, fadeFlag;
  itr = 0;
  while( itr <= ANM_FRAME_TOTAL){
    total = total + ANM_FRAME_TIM[itr];
    fadeFlag = ANM_FRAME_FADE[itr];
    if( (fadeFlag & 1) || (fadeFlag & 4) ){
      
      total = total + 2;
    }
    if( (fadeFlag & 2) || (fadeFlag & 4) ){
      total = total + 2;
    }
    itr = itr + 1;
  }
  return total;
};
