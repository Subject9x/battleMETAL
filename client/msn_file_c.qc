/*
mech Mod
Author: Peter Roohr
Date: 04/02/2017
Overview: header for the mission file handler.
*/

void() msn_getfile={
  local float flannel;
  local string file;
  file = strcat(PATH_DATA_MAP, "/", MAP_NAME, "/", MSN_FILENAME, ".msn");
  flannel = fopen(file, FILE_READ);
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
  local float tobj, flannel, argc, line_tag, token;
  local string file, contents, line;
  file = strcat(PATH_DATA_MAP, "/", MAP_NAME, "/", MSN_FILENAME, ".msn");
  flannel = fopen(file, FILE_READ);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{",",","}");
  line = fgets(flannel);
  token = 4; //general pointer inside tokenized msn file value
  while( (line != "") ){
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "'", "'", ": ","'","'");
      if (argv(1) == MSN_FILE_IMG){
        if( argv(token) != "" ){
          msn_setmappic( argv(1), strcat("data/map_scripts/",argv(token)));
        }
      }
      if (argv(1) == MSN_FILE_NAME){
        if( argv(token) != "" ){
          MSN_NAME = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_TYPE){
        if( argv(token) != "" ){
          MSN_TYPE = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_POINTS){
        if( argv(token) != "" ){
          MSN_RESERVETOTAL = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_SECTOR){
        if( argv(token) != "" ){
          MSN_SECTOR = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_LOCUS){
        if( argv(token) != "" ){
          MSN_LOCATION = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_TIME){
        if( argv(token) != "" ){
          MSN_LOCALTIME = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_BRIEF){
        if( argv(token) != "" ){
          MSN_BRIEF = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_INTEL){
        if( argv(token) != "" ){
          MSN_INTEL = strzone(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_OBJS){
        if( argv(token) != "" ){
          MSN_OBJ = stof(argv(token));
        }
      }
      if (argv(1) == MSN_FILE_ANIM){
        if( argv(token) != "" ){
          MSN_ANIM = strzone(argv(token));
        }
      }

      //objectives section
      msn_setobjdesc(tobj, argv(1), argv(token));
      tobj = msn_mapobjid(argv(1), argv(token));  //somehow reading this second works
    }
    line = fgets(flannel);
  }
  //always close a file :3
  fclose(flannel);
};

void(string line, string val) msn_setmappic={
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
  if(line == MSN_FILE_OBJS){
    MSN_OBJ = stof(val);
  }
};

float(string line, string val) msn_mapobjid={
  local float obj_id;
  if(line == MSN_FILE_OBJ_ID){
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
  if(line == MSN_FILE_OBJ_DESC){
    if(obj_id != 0){    
      MSN_OBJ_DESC[obj_id] = strzone(val);
    }
  }
};