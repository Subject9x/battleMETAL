/*
battleMETAL
Author: Peter Roohr
Date: 4/11/2018
Overview: utility functions for menu
*/


void(string msg, float val) cons_logAFloat={
  print(strcat(msg,":", ftos(val)," \n"));
};
void(string msg, vector v1) cons_logAVector={
  print(strcat(msg,":", vtos(v1),"\n"));
};
void(string msg, string s1) cons_logAString={
  print(strcat(msg,":", s1,"\n"));
};

void(string msg, float val, string split, float val2) cons_log2Float={
  print(strcat(msg,":", ftos(val),"| ", split,":", ftos(val2),"\n"));
};
void(string msg, vector v1, string split, vector v2) cons_log2Vectors={
  print(strcat(msg,":", vtos(v1),"| ", split,":", vtos(v2),"\n"));
};
void(string msg, string s1, string split, string s2) cons_log2Strings={
  bprint(strcat(msg," : ",s1," | ", split," : ",s2,"\n"));
};

void(string nextMap, string startItems, string startMechs, string campaignName) menu_write_new_save={
  local float flannel;
  local string file;
  file = strcat(PATH_DATA_SAVE, "/", SAVE_FILE_NAME, cvar_string("saveslot"), SAVE_FILE_EXT);
  flannel = fopen(file, FILE_WRITE);
    fputs(flannel, "{\n");
    fputs(flannel, strcat("  'save' : ", cvar_string("saveslot"), ",\n"));
    fputs(flannel, strcat("  'mission' : ", nextMap, ",\n"));
    fputs(flannel, strcat("  'points' : ", ftos(1), ",\n"));
    fputs(flannel, strcat("  'skill' : ", ftos(cvar("skill")), ",\n"));
    fputs(flannel, strcat("  'campaign' : ", campaignName, ",\n"));
    if(startMechs != ""){
      fputs(flannel, strcat("  'mechs' : ", startMechs, ",\n"));
    }
    else{
      fputs(flannel, "  'mechs' : ,\n");
    }
    
    if(startItems != ""){
      fputs(flannel, strcat("  'items' : ", startItems, ",\n"));
    }
    else{
      fputs(flannel, "  'items' : ,\n");
    }
    
    fputs(flannel, "}");
  fclose(flannel);
};