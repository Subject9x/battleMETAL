/*
mech Mod
Author: Subject9x
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
  local float flannel, argc;
  local string contents;
  flannel = fopen(MSN_FILENAME, FILE_READ);
  contents = fgets(flannel);
  argc = tokenizebyseparator(contents, "{",":",";","}");
  //MSN_NAME
  MSN_NAME = strzone(argv(2));
  //MSN_TYPE
  MSN_TYPE = strzone(argv(4));
  //MSN_SECTOR
  MSN_SECTOR = strzone(argv(6));
  //MSN_LOCATION
  MSN_LOCATION = strzone(argv(8));
  //MSN_LOCALTIME
  MSN_LOCALTIME = strzone(argv(10));
  //MSN_BRIEF
  MSN_BRIEF = strzone(argv(12));
  //MSN_INTEL
  MSN_INTEL = strzone(argv(14));
  fclose(flannel);
  


};