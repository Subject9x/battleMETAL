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
      if( (argv(1) == ANM_FILE_TAG_FLAGS) ){
        ANM_FRAME_FLAGS[frame_count] =  stof(argv(3));
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


/*
  Frame 0 is always the metadata frame of the anim file - 2020 Roohr
*/
void() anm_execute_metadata={
  //first frame, handle meta data
  if(ANM_META_DATA[1] == "1"){
    localcmd("cd pause");
  }
  if(ANM_META_DATA[0] != ""){
    pointsound(pmove_org, ANM_META_DATA[0], 1, ATTN_NORM); 
  }

  ANM_FRAME_TIME = 0;
  ANM_FRAME_CUR_FADE_STEP = 0;
};

/*
  Loads next frame where
    next frame = ANM_FRAME_CUR + 1;
*/
void(float timeVal) anm_new_frame={
  ANM_FRAME_CUR = rint(ANM_FRAME_CUR + 1);
  
  //check for end-of-anim first
  if( ANM_FRAME_CUR == ANM_FRAME_TOTAL + 1){
    anm_cleanup();
    localcmd("cd resume");
    sound7(self, CHAN_WEAPON, "", 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
    return;
  }
  ANM_FRAME_CUR_FADE_STEP = 0;
  
  ANM_FRAME_ALPHA_CUR = rint(0);
  
  ANM_FRAME_TIME = rint(0);
  ANM_FRAME_TIME = ANM_FRAME_TIM[ANM_FRAME_CUR];
  
  ANM_FRAME_CUR_FADE_RATE = rint(0);
  
  if(ANM_FRAME_SND[ANM_FRAME_CUR] != ""){
    pointsound(pmove_org, ANM_FRAME_SND[ANM_FRAME_CUR], 1, ATTN_NONE);
  }
  
  //fade is pre-baked amount of 2 seconds on fade-in and fade-out, 
  //set 'fade' 1 for just fade in, 2 for just fade out, 4 for both
  ANM_FRAME_CUR_FLAGS = rint(ANM_FRAME_FLAGS[ANM_FRAME_CUR]);
  
  local float frameSlice;
  frameSlice = 0.1 * ANM_FRAME_ALPHA[ANM_FRAME_CUR];
  ANM_FRAME_CUR_FADE_RATE = frameSlice / 2.0;
  
  if( (ANM_FRAME_CUR_FLAGS & 1) || (ANM_FRAME_CUR_FLAGS & 4) ){
    ANM_FRAME_CUR_FADE_START = rint(timeVal + 2);
    ANM_FRAME_TIME = ANM_FRAME_TIME + 2;
  }
  else{
    ANM_FRAME_CUR_FADE_START = FALSE;
    ANM_FRAME_ALPHA_CUR = ANM_FRAME_ALPHA[ANM_FRAME_CUR];
  }
  
  if( (ANM_FRAME_CUR_FLAGS & 2) || (ANM_FRAME_CUR_FLAGS & 4) ){
    ANM_FRAME_CUR_FADE_END = rint(ANM_FRAME_TIME + timeVal);
    ANM_FRAME_TIME = ANM_FRAME_TIME + 2;
  }
  else{
    ANM_FRAME_CUR_FADE_END = FALSE;
    ANM_FRAME_ALPHA_CUR = ANM_FRAME_ALPHA[ANM_FRAME_CUR];
  }
  ANM_FRAME_TIME = ANM_FRAME_TIME + timeVal;
  
  local vector imageSize, frameSize, frameOrg;
  
  /*
    an effort to enhance the image sizing behavior of the animatic system.
    there's a new flag to override image size vs screen size, which will blast an image to fullscreen.
    DEFAULT behavior though is the following:
      image will be scaled to screen as normal UNLESS image is 100%x100% AND the image is smaller than the the view.
      
  */
   
  if( (ANM_FRAME_CUR_FLAGS & ANM_FLAG_FULL_SCR) ){
    //blast image to screen regardless of size ratios
    frameSize = VIEW_MAX;
    frameOrg = '0 0';
  }
  else{
    local vector consoleSize;
    local float aspectRatio;
    local vector imageAspect;
    local vector calcSize;
    
    consoleSize_x = cvar("vid_conwidth");
    consoleSize_y = cvar("vid_conheight");
    
    imageSize = draw_getimagesize(ANM_FRAME_IMG[ANM_FRAME_CUR]);
    frameSize = ANM_FRAME_SIZE[ANM_FRAME_CUR];
    frameOrg = ANM_FRAME_POS[ANM_FRAME_CUR];
    
    imageAspect_x = consoleSize_x / imageSize_x;
    imageAspect_y = consoleSize_y / imageSize_y;
    aspectRatio = min(imageAspect_x, imageAspect_y);
    
    calcSize_x = imageSize_x * aspectRatio;
    calcSize_y = imageSize_y * aspectRatio;
    
    frameSize_x = min(frameSize_x, (calcSize_x / consoleSize_x));
    frameSize_y = min(frameSize_y, (calcSize_y / consoleSize_y));
    
    frameSize_x = calcSize_x * frameSize_x;
    frameSize_y = calcSize_y * frameSize_y;
    
    
    if( (ANM_FRAME_CUR_FLAGS & ANM_FLAG_CENTER) ){
      frameOrg_x = 0.5 - ((frameSize_x / 2) / consoleSize_x);
      frameOrg_y = 0.5 - ((frameSize_y / 2) / consoleSize_y);
    }
  }
  frameOrg_x = frameOrg_x * VIEW_MAX_x;
  frameOrg_y = frameOrg_y * VIEW_MAX_y;
  ANM_FRAME_CUR_SIZE = frameSize;
  ANM_FRAME_CUR_ORG = frameOrg;
};


/*
  Render frame text if it is present.
*/
void(string frameText) anm_render_frame_text={
  local vector txtstart;
  local vector txt_color;
  local string line;
  local float tokens, tcnt;
  
  txt_color = '1 1 1';
  if(ANM_FRAME_TXT_CLR[ANM_FRAME_CUR] != '0 0 0'){
    txt_color = ANM_FRAME_TXT_CLR[ANM_FRAME_CUR];
  }
  tcnt = 0;
  line = frameText;
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
};

/*
  Renders the current frame where
    current = ANM_FRAME_CUR global
*/
void(float timeVal) anm_render_frame_current={
  local vector siz, org, frm_color, txt_color;
  
  if(ANM_FRAME_IMG[ANM_FRAME_CUR] != ""){
    if(ANM_FRAME_CUR_FADE_START > FALSE && timeVal <= ANM_FRAME_CUR_FADE_START){
      if(ANM_FRAME_ALPHA_CUR <= ANM_FRAME_ALPHA[ANM_FRAME_CUR] ){
        if( timeVal > ANM_FRAME_CUR_FADE_STEP ){
          ANM_FRAME_CUR_FADE_STEP = timeVal + ANM_FRAME_SLICE;
          ANM_FRAME_ALPHA_CUR = ANM_FRAME_ALPHA_CUR + ANM_FRAME_CUR_FADE_RATE;
        }
      }
    }
    if( ANM_FRAME_CUR_FADE_END != FALSE && timeVal > ANM_FRAME_CUR_FADE_END ){
      if(ANM_FRAME_ALPHA_CUR > 0){
        if( timeVal >= ANM_FRAME_CUR_FADE_STEP ){
          ANM_FRAME_CUR_FADE_STEP = timeVal + ANM_FRAME_SLICE;
          ANM_FRAME_ALPHA_CUR = fabs(ANM_FRAME_ALPHA_CUR - ANM_FRAME_CUR_FADE_RATE);
        }
      }
    }
    
    frm_color = '1 1 1';
    if(ANM_FRAME_COLOR[ANM_FRAME_CUR] != '0 0 0'){
      frm_color = ANM_FRAME_COLOR[ANM_FRAME_CUR];
    }
    
    drawpic(ANM_FRAME_CUR_ORG, ANM_FRAME_IMG[ANM_FRAME_CUR], ANM_FRAME_CUR_SIZE, frm_color, ANM_FRAME_ALPHA_CUR, 0);
  } 
  if(ANM_FRAME_MSG[ANM_FRAME_CUR] != ""){
    anm_render_frame_text( ANM_FRAME_MSG[ANM_FRAME_CUR] );
  }
};

/*
  API hook to client_main.CSQC_UpdateView();
  
*/
void() anm_execute_frame={
  local float frameTime;
  //frameTime = servertime + (servertime - time);
  frameTime = time;
  if(ANM_META_DATA[2] != ""){
    drawpic('0 0', ANM_META_DATA[2] , VIEW_MAX, '1 1 1', 1, 0); 
  }
  if(frameTime > ANM_FRAME_TIME){
    anm_new_frame(frameTime);
  }
  else{
    anm_render_frame_current(frameTime);
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
    ANM_FRAME_POS[clean] = '0 0 0';
    ANM_FRAME_COLOR[clean] = '0 0 0';
    ANM_FRAME_ALPHA[clean] = 0;
    clean = clean + 1;
  }
  ANM_FRAME_CUR_FLAGS = rint(0);
  ANM_FRAME_CUR_SIZE = '0 0';
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
    fadeFlag = ANM_FRAME_FLAGS[itr];
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