/*
mech Mod
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
    cons_logAString("Anim file", strcat(fileToOpen," was not found!"));
  }
};

void(string fileToOpen) anm_parseFile={
  local float flannel, argc, line_tag, line_val, frame_count;
  local string contents, line;
  flannel = fopen(fileToOpen, FILE_READ);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{", ",", "}");
  line = fgets(flannel);
  frame_count = 0;
  while( (line != "") ){
    if( (line != "{") && (line != "}") ){
      line_tag = tokenizebyseparator(line, "'", "'", ": ", "[", ";", "]", ",");
      //meta data tags
      if( argv(1) == ANM_FILE_META_MUS ){
        ANM_META_DATA[0] = precache_sound2(strzone(argv(3)));
      }
      if( argv(1) == ANM_FILE_META_MUS_NO ){
        ANM_META_DATA[1] = strzone(argv(3));
      }
      if( argv(1) == ANM_FILE_META_BACK ){
        ANM_META_DATA[2] = strzone(argv(3));
      }
      if( argv(1) == ANM_FILE_META_TRANS ){
        ANM_META_DATA[3] = strzone(argv(3));
      }
      //===================
      //frame data
      if( (argv(1) == ANM_FILE_TAG_IMG) ){
        ANM_FRAME_IMG[frame_count] = argv(3);
        ANM_FRAME_IMG[frame_count] = strzone(ANM_FRAME_IMG[frame_count]);
      }
      if( (argv(1) == ANM_FILE_TAG_POS) ){
        local vector org;
        org_x = stof(argv(4));
        org_y = stof(argv(5));
        ANM_FRAME_POS[frame_count] = org;
      }
      if( (argv(1) == ANM_FILE_TAG_SIZE) ){
        local vector siz;
        siz_x = stof(argv(4));
        siz_y = stof(argv(5));
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
    }
    if( line == "}"){
      frame_count = frame_count + 1;
    }
    line = fgets(flannel);
  }
  fclose(flannel);
  if(frame_count > 0){
    self.ANM_FRAME_TOTAL = frame_count;
    self.ANM_FRAME_TIME = time + ANM_FRAME_TIM[self.ANM_FRAME_CUR];
    self.ANM_FRAME_CUR = 0;
    self.ANM_FILE_STATUS = 1;
  }
};

/*
  //meta tags
string ANM_FILE_META_MUS = "music";
string ANM_FILE_META_MUS_NO = "nomusic";
string ANM_FILE_META_BACK = "backimg";
string ANM_FILE_META_TRANS = "trans";
*/

void() anm_execute_frame={
  if(time > self.ANM_FRAME_TIME){
    if(self.ANM_FRAME_CUR == 0){
      //first frame, handle meta data
      if(ANM_META_DATA[1] == "1"){
        localcmd("cd pause");
      }
      if(ANM_META_DATA[0] != ""){
        cons_logAString("ANM_META_DATA[0]", ANM_META_DATA[0]);  //DEBUG
        sound7(self, CHAN_WEAPON, ANM_META_DATA[0], 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
      }
    }
    self.ANM_FRAME_CUR = self.ANM_FRAME_CUR + 1;
    if(self.ANM_FRAME_CUR > self.ANM_FRAME_TOTAL){
      anm_cleanup();
      localcmd("cd resume");
      sound7(self, CHAN_WEAPON, "", 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
      return;
    }
    if(ANM_FRAME_SND[self.ANM_FRAME_CUR] != ""){
      sound7(self, CHAN_VOICE, ANM_FRAME_SND[self.ANM_FRAME_CUR], 1, ATTN_NORM, 100, SOUNDFLAG_RELIABLE);
    }
    self.ANM_FRAME_TIME = time + ANM_FRAME_TIM[self.ANM_FRAME_CUR];
  }
  else{
    if(ANM_META_DATA[2] != ""){
      drawpic('0 0', ANM_META_DATA[2] , VIEW_MAX, '1 1 1', 1, 0); 
    }
    local vector siz, org;
    org = ANM_FRAME_POS[self.ANM_FRAME_CUR];
    org_x = org_x * VIEW_MAX_x;
    org_y = org_y * VIEW_MAX_y;
    if(ANM_FRAME_IMG[self.ANM_FRAME_CUR] != ""){
      siz = ANM_FRAME_SIZE[self.ANM_FRAME_CUR];
      siz_x = siz_x * VIEW_MAX_x;
      siz_y = siz_y * VIEW_MAX_y;
      
      drawpic(org, ANM_FRAME_IMG[self.ANM_FRAME_CUR], siz, '1 1 1', HUD_ALPHA, 0);
    } 
    if(ANM_FRAME_MSG[self.ANM_FRAME_CUR] != ""){
      local vector txtpos, txtstart;
      local string line;
      local float tokens, tcnt;
      tcnt = 0;
      line = ANM_FRAME_MSG[self.ANM_FRAME_CUR];
      tokens = tokenizebyseparator(line, "|");
      txtstart_x = VIEW_CTR_x;
      txtstart_y = VIEW_MAX_y - (tokens * 10);
      while( tcnt <= tokens){
        local float width;
        local vector linepos;
        width = stringwidth(argv(tcnt), 0, '8 8 0');
        linepos_x = txtstart_x - (width / 2);
        linepos_y = txtstart_y + gui_percentYRaw(tcnt * 10);
        drawstring(linepos, argv(tcnt), '8 8 0', '1 1 1', 0.85, 0);
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
  while(clean <= self.ANM_FRAME_TOTAL){
    ANM_FRAME_IMG[clean] = "";
    ANM_FRAME_SND[clean] = "";
    ANM_FRAME_TIM[clean] = 0 ;
    clean = clean + 1;
  }
  self.ANM_FILE_STATUS = -1; 
};
