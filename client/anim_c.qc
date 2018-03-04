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
      line_tag = tokenizebyseparator(line, "'", "'");
      if( (argv(1) == ANM_FILE_TAG_IMG) ){
        tokenizebyseparator(line, ":",",");
        cons_logAString("img", argv(1));  //DEBU
        ANM_FRAME_IMG[frame_count] = strzone(argv(1));
      }
      if( (argv(1) == ANM_FILE_TAG_POS) ){
        tokenizebyseparator(line, ":",",");
        local vector siz;
        siz_x = stof(argv(1));
        siz_y = stof(argv(2));
        ANM_FRAME_POS[frame_count] = siz;
      }
      if( (argv(1) == ANM_FILE_TAG_SIZE) ){
        tokenizebyseparator(line, ":",",");
        local vector siz;
        siz_x = stof(argv(1));
        siz_y = stof(argv(2));
        ANM_FRAME_SIZE[frame_count] = siz;
      }
      if( (argv(1) == ANM_FILE_TAG_SND) ){
        tokenizebyseparator(line, ":");
        ANM_FRAME_SND[frame_count] = strzone(argv(1));
      }
      if( (argv(1) == ANM_FILE_TAG_TIM) ){
        tokenizebyseparator(line, ":");
        ANM_FRAME_TIM[frame_count] = stof(argv(1));
      }
      if( (argv(1) == ANM_FILE_TAG_TIM) ){
        tokenizebyseparator(line, ":");
        ANM_FRAME_MSG[frame_count] = strzone(argv(1));
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

void() anm_execute_frame={
  if(time > self.ANM_FRAME_TIME){
    self.ANM_FRAME_CUR = self.ANM_FRAME_CUR + 1;
    if(self.ANM_FRAME_CUR > self.ANM_FRAME_TOTAL){
      anm_cleanup();
      return;
    }
    if(ANM_FRAME_SND[self.ANM_FRAME_CUR] != ""){
      cons_logAString("play sound", ANM_FRAME_SND[self.ANM_FRAME_CUR]);//DEBUG
    }
    self.ANM_FRAME_TIME = time + ANM_FRAME_TIM[self.ANM_FRAME_CUR];
  }
  else{
    if(ANM_FRAME_IMG[self.ANM_FRAME_CUR] != ""){
      local vector siz, pos;
      
      pos = ANM_FRAME_POS[self.ANM_FRAME_CUR];
      pos_x = pos_x * VIEW_MAX_x;
      pos_y = pos_y * VIEW_MAX_y;
      
      siz = ANM_FRAME_SIZE[self.ANM_FRAME_CUR];
      siz_x = siz_x * VIEW_MAX_x;
      siz_y = siz_y * VIEW_MAX_y;
      
      drawpic(pos, ANM_FRAME_IMG[self.ANM_FRAME_CUR], siz, '1 1 1', HUD_ALPHA, 0);
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
