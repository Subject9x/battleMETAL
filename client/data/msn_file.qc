/*
battleMETAL
Author: Peter Roohr
Date: 04/02/2017
Overview: header for the mission file handler.
*/

void() msn_getfile={
  local float flannel;
  local string file;
  
  file = strcat(PATH_DATA_MAP, MAP_NAME, "/", MSN_FILENAME, ".msn");
  
  if( cvar("developer") ){
    cons_logAString("loading file:", file);
  }
  
  flannel = fopen(file, FILE_READ);
  if(flannel > -1){
    MSN_FILEFOUND = TRUE;
    fclose(flannel);
  }
  else{
    /*MSN_NAME = "FILE NOT FOUND";
    MSN_TYPE = "FILE NOT FOUND";
    MSN_SECTOR = "FILE NOT FOUND";
    MSN_LOCATION = "FILE NOT FOUND";
    MSN_LOCALTIME ="FILE NOT FOUND";
    MSN_BRIEF = "FILE NOT FOUND";
    MSN_INTEL = "FILE NOT FOUND";*/
  }
};

void() msn_parsefile={
  local float tobj, flannel, argc, line_tag, token;
  local string file, contents, line;
  file = strcat(PATH_DATA_MAP, MAP_NAME, "/", MSN_FILENAME, ".msn");
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
          msn_setmappic( strcat("data/maps/",argv(token)));
        }
      }
      if (argv(1) == MSN_FILE_NAME){
        cacheGlobalString( MSN_NAME, argv(token))
      }
      if (argv(1) == MSN_FILE_TYPE){
        cacheGlobalString( MSN_TYPE, argv(token))
      }
      if (argv(1) == MSN_FILE_POINTS){
        cacheGlobalString( MSN_RESERVETOTAL, argv(token))
      }
      if (argv(1) == MSN_FILE_SECTOR){
        cacheGlobalString( MSN_SECTOR, argv(token))
      }
      if (argv(1) == MSN_FILE_LOCUS){
        cacheGlobalString( MSN_LOCATION, argv(token))
      }
      if (argv(1) == MSN_FILE_TIME){
        cacheGlobalString( MSN_LOCALTIME, argv(token))
      }
      if (argv(1) == MSN_FILE_BRIEF){
        cacheGlobalString( MSN_BRIEF, argv(token))
      }
      if (argv(1) == MSN_FILE_INTEL){
        cacheGlobalString( MSN_INTEL, argv(token))
      }
      if (argv(1) == MSN_FILE_OBJS){
        MSN_OBJ = stof(argv(token));
      }
      if (argv(1) == MSN_FILE_ANIM){
        cacheGlobalString( MSN_ANIM, argv(token))
      }
      if (argv(1) == MSN_FILE_DISP){
        cacheGlobalString( MSN_DISP, argv(token))
      }
      if( argv(1) == MSN_FILE_NOSAVE ){
        MSN_SAVE = stof(argv(token));
      }
      else{
        MSN_SAVE = TRUE;
      }

      //objectives section
      tobj = msn_mapobjid(tobj, argv(1), argv(token));  //somehow reading this second works
      msn_setobjdesc(tobj, argv(1), argv(token));
      msn_setobj_type(tobj, argv(1), argv(token));
      msn_setobj_mechs(tobj, argv(1), argv(token));
      msn_setobj_items(tobj, argv(1), argv(token));
    }
    //checks for end-of-objective struct
    if( (tobj > 0) && (line =="}")){
      tobj = 0;
    }
    line = fgets(flannel);
  }
  //always close a file :3
  fclose(flannel);
};

void(string val) msn_setmappic={
  local string s;
  if(val != ""){
    cacheGlobalString( MSN_MAPPIC, val)
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


float(float currentObjId, string line, string val) msn_mapobjid={
  local float obj_id;
  if(line == MSN_FILE_OBJ_ID){
    obj_id = stof(val);
    if(obj_id > 0){
      return obj_id;
    }
    else{
      return currentObjId;
    }
  }
  else{
    return currentObjId;
  }
};
void(float obj_id, string line, string val) msn_setobjdesc={
  if(line == MSN_FILE_OBJ_DESC){
    if(obj_id != 0){
      MSN_OBJ_DESC[obj_id] = strzone(val);
    }
  }
};

void( float obj_id, string line, string val) msn_setobj_type={
  if(line == MSN_FILE_OBJ_TYPE){
    if(obj_id != 0){
      MSN_OBJ_TYPES[obj_id] = strzone(val);
    }
  }
};

void( float obj_id, string line, string val) msn_setobj_mechs={
  if(line == MSN_FILE_OBJ_MECH){
    if(obj_id != 0){
      MSN_OBJ_MECHS[obj_id] = strzone(val);
    }
  }
};

void( float obj_id, string line, string val) msn_setobj_items={
  if(line == MSN_FILE_OBJ_ITEM){
    if(obj_id != 0){
      MSN_OBJ_ITEMS[obj_id] = strzone(val);
    }
  }
};

//ops
void() msn_unlock_stuff={
  local string unlockMechs;
  local string unlockItems;
  local entity obj;
  unlockMechs = "";
  unlockItems = "";
  
  for( obj = nextent(world); obj != world; obj = nextent(obj) ){
    if( obj.data_type != DATA_OBJT ){
      continue;
    }
    if( obj.faction != CLIENT_faction ){
      continue;
    }
    if( obj.isActive != OBJECTIVE_WIN ){
      continue;
    }
    if( MSN_OBJ_MECHS[obj.data_idx] != "" ){
      unlockMechs = strcat(unlockMechs, MSN_OBJ_MECHS[obj.data_idx], " ");
    }
    if( MSN_OBJ_ITEMS[obj.data_idx] != "" ){
      unlockItems = strcat(unlockMechs, MSN_OBJ_ITEMS[obj.data_idx], " ");
    }
  }
  cacheGlobalString(MENU_DEBRIEF_unlocks_mechs, unlockMechs )
  cacheGlobalString(MENU_DEBRIEF_unlocks_equip, unlockItems )
  cl_savefile_append();
};

/*
  Timely call to clean up Mission strings AFTER player has gone to 
    mission - they can't reference the Briefing screen until they die,
    so we can clean them out here.
*/
void() msn_free_strings={
  //mission file cleanup
  freeGlobalString(MSN_FILENAME)
  freeGlobalString(MSN_SFX)
  freeGlobalString(MSN_MAPPIC)
  freeGlobalString(MSN_NAME)
  freeGlobalString(MSN_DISP)
  freeGlobalString(MSN_TYPE)
  freeGlobalString(MSN_RESERVETOTAL)
  freeGlobalString(MSN_SECTOR)
  freeGlobalString(MSN_LOCATION)
  freeGlobalString(MSN_LOCALTIME)
  freeGlobalString(MSN_BRIEF)
  freeGlobalString(MSN_INTEL)
  freeGlobalString(MSN_ANIM)
};


