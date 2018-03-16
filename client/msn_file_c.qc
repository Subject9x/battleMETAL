/*
mech Mod
Author: Peter Roohr
Date: 04/02/2017
Overview: header for the mission file handler.
*/

void() msn_getfile={
  local float flannel;
  flannel = fopen(MSN_FILENAME, FILE_READ);
  if(flannel > -1){
    MSN_FILEFOUND = TRUE;
    fclose(flannel);
  }
  else{
    MSN_NAME = "FILE NOT FOUND";
    MSN_TYPE = "FILE NOT FOUND";
    MSN_SECTOR = "FILE NOT FOUND";
    MSN_LOCATION = "FILE NOT FOUND";
    MSN_LOCALTIME ="FILE NOT FOUND";
    MSN_BRIEF = "FILE NOT FOUND";
    MSN_INTEL = "FILE NOT FOUND";
  }
};

void() msn_parsefile={
  local float tobj, flannel, argc, line_tag, line_val, frame_count;
  local string contents, line;
  flannel = fopen(MSN_FILENAME, FILE_READ);
  //print(contents);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{",":",";","}");
  line = fgets(flannel);
  
  
  
  while((line!="")){
    if( (line != "{") && (line != "}") && (line != "//") ){
      line_tag = tokenizebyseparator(line, "'", "'", ": ", "[", ";", "]", ",");
      if (argv(1) == MSN_FILE_IMG){
        if( argv(3) != "" ){
          MSN_MAPPIC = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_NAME){
        if( argv(3) != "" ){
          MSN_NAME = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_TYPE){
        if( argv(3) != "" ){
          MSN_TYPE = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_POINTS){
        if( argv(3) != "" ){
          MSN_RESERVETOTAL = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_SECTOR){
        if( argv(3) != "" ){
          MSN_SECTOR = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_LOCUS){
        if( argv(3) != "" ){
          MSN_LOCATION = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_TIME){
        if( argv(3) != "" ){
          MSN_LOCALTIME = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_BRIEF){
        if( argv(3) != "" ){
          MSN_BRIEF = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_INTEL){
        if( argv(3) != "" ){
          MSN_INTEL = strzone(argv(3));
        }
      }
      if (argv(1) == MSN_FILE_OBJS){
        if( argv(3) != "" ){
          MSN_OBJ = stof(strzone(argv(3)));
        }
      }
      if (argv(1) == MSN_FILE_ANIM){
        if( argv(3) != "" ){
          MSN_ANIM = strzone(argv(3));
        }
      }

      //objectives section
      tobj = msn_mapobjid(argv(1), argv(3));
      msn_setobjdesc(tobj, argv(1), argv(3));
    }
    line = fgets(flannel);
  }
  //always close a file :3
  fclose(flannel);
};

void(string line, string val) msn_setmappic={
  if(line == "MSN_PIC"){
    MSN_MAPPIC = strzone(val);
    if(MSN_MAPPIC != ""){
      local string s;
      s = precache_pic(MSN_MAPPIC, 0);
      if(s != ""){
        MSN_MAPPIC = s;
      }
      else{
        MSN_MAPPIC = "";
        print(strcat("MSN File error: Pic ", MSN_MAPPIC, " null or doesnt exist!\n"));
      }
    }
  }
};

void(string line, string val) msn_setsound={
  if(line == "MSN_SFX"){
    if(val != ""){
      MSN_SFX = strzone(val);
      self.MSN_SFX_TIME = soundlength(MSN_SFX);
    }
  }
};
void(string line, string val) msn_setname={
  if(line == "MSN_NAME"){
    MSN_NAME = strzone(val);
  }
};
void(string line, string val) msn_settype={
  if(line == "MSN_TYPE"){
    MSN_TYPE = strzone(val);
  }
};
void(string line, string val) msn_setresrv={
  if(line == "MSN_RSERVE"){
    MSN_RESERVETOTAL = strzone(val);
  }
};
void(string line, string val) msn_setsector={
  if(line == "MSN_SECTOR"){
    MSN_SECTOR = strzone(val);
  }
};
void(string line, string val) msn_setlocation={
  if(line == "MSN_LOCATION"){
    MSN_LOCATION = strzone(val);
  }
};
void(string line, string val) msn_setlocaltime={
  if(line == "MSN_LOCALTIME"){
    MSN_LOCALTIME = strzone(val);
  }
};
void(string line, string val) msn_setbrief={
  if(line == "MSN_BRIEF"){
    MSN_BRIEF = strzone(val);
  }
};
void(string line, string val) msn_setintel={
  if(line == "MSN_INTEL"){
    MSN_INTEL = strzone(val);
  }
};
void(string line, string val) msn_settotalobjectives={
  if(line == "MSN_OBJ"){
    MSN_OBJ = stof(val);
  }
};
float(string line, string val) msn_mapobjid={
  local float obj_id;
  if(line == "MSN_FILE_OBJ_ID"){
    obj_id = stof(val);
    if(obj_id > 0){
      return obj_id;
    }
    else{
      return 0;
    }
  }
  else{
    return 0;
  }
};
void(float obj_id, string line, string val) msn_setobjdesc={
  if(line == "OBJ_DESC"){
    if(obj_id!=0){    
      MSN_OBJ_DESC[obj_id] = strzone(val);
      MSN_OBJ_STATUS[obj_id] = FALSE;
    }
  }
};