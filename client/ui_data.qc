/*
mech Mod
Author: Peter Roohr
Date: 6/26/2018
Overview: refactor ui data to file loading, impl
*/


void() ui_data_load_mechnames={
  local float f, idx;
  local string ln;
  idx = 1;
  f = fopen("ui/vec/mech/dir.meta", FILE_READ);
  if (f != -1){ 
    ln = fgets(f);
    while( ln != "" ){
      if( strstrofs(ln, "//", 0) == -1 ){
        if(idx < 257){
          MECH_DATA_NAMES[idx] = strzone(ln);
        }
        idx = idx + 1;
      }
      ln = fgets(f);
    } 
  } 
  fclose(f); 
};

//this is for sorting the mechs by size class in a clean way
void() ui_data_load_mechsizes={
  local float count;
  count = 1;
  while( count <= 256) {
    local string file, filename;
    local float flannel;
    filename = MECH_DATA_NAMES[count];
    if(filename != ""){
      file = strcat("ui/vec/mech/", filename,".dat");
      flannel = fopen(file, FILE_READ);
      if(flannel != -1){
        local string line;
        local float sizzle;
        line = fgets(flannel);
        while( (line != "") ){
          if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
            tokenizebyseparator(line, "  '","'"," : ", ",");
            local string token, value;
            token = argv(1);
            value = argv(3);
            if( token == "size" ){
              sizzle = stof(value);
            }
          }
          line = fgets(flannel);
        }
        MECH_DATA_SIZES[count] = sizzle;
        fclose(flannel);
      }
      else{
        MECH_DATA_SIZES[count] = 0;
      }
    }
    count = count + 1;
  }
};
//the easy part is the clearing function
void() ui_data_clear_mechdata={
  MECH_DATA_ID = 0;
  if( MECH_DATA_ABR != "" ){
    strunzone(MECH_DATA_ABR);
  }
  if( MECH_DATA_NAME != "" ){
    strunzone(MECH_DATA_NAME);
  }
  MECH_DATA_SIZE = 0;
  MECH_DATA_TECH = 0;
  if( MECH_DATA_ICON != "" ){
    strunzone(MECH_DATA_ICON);
  }
  MECH_DATA_ENMAX = 0;
  MECH_DATA_ENRATE = 0;
  MECH_DATA_SHMAX = 0;
  MECH_DATA_SHRATE = 0;
  MECH_DATA_HPOINTS = 0;
  MECH_DATA_SPEEDF = 0;
  MECH_DATA_SPEEDS = 0;
  MECH_DATA_SPEEDB = 0;
  MECH_DATA_ACCEL = 0;
  MECH_DATA_HPCT = 0;
  MECH_DATA_HPST = 0;
  MECH_DATA_HPAR = 0;
  MECH_DATA_HPLG = 0;
  MECH_DATA_RAD = 0;
  if( MECH_DATA_DESC != "" ){
    strunzone(MECH_DATA_DESC);
  }

  local float itr;
  itr = 1;
  while(itr <= 9){
  
    MECH_DATA_H_TYPE[itr] = 0;
    MECH_DATA_H_SIZE[itr] = 0;
    MECH_DATA_H_ARM[itr] = '0 0 0';
    MECH_DATA_H_HNG[itr] = '0 0 0';
    MECH_DATA_STOCK[itr] = 0;
    
    if(itr <= 5){
      MECH_DATA_GRPS[itr] = 0;
    }
    itr = itr + 1;
  }
};

float(float id) ui_data_load_mech={
  ui_data_clear_mechdata();
  local float flannel, line_tag, line_val;
  local string file, contents, line;
  file = strcat(PATH_DATA_UI, "/vec/mech/", MECH_DATA_NAMES[id],".dat");
  flannel = fopen(file, FILE_READ);
  if(flannel == -1){
    cons_logAString("ERROR", strcat("File[", file,"] NOT FOUND"));  
    return FALSE;
  }
  contents = fgets(flannel);
  //tokenizebyseparator(contents, "{", ",", "}");
  line = fgets(flannel);
  while( (line != "") ){
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "  '","'",": ", ",");
      local string token, value;
      token = argv(1);
      value = argv(3);
      if( token != ""){
        if( token == "id"){
          MECH_DATA_ID = stof(value);
        }
        if( token == "abbr"){
          MECH_DATA_ABR = strzone(value);
        }
        if( token == "name"){
          MECH_DATA_NAME = strzone(value);
        }
        if( token == "size"){
          MECH_DATA_SIZE = stof(value);
        }
        if( token == "tech"){
          MECH_DATA_TECH = stof(value);
        }
        if( token == "icon"){
          MECH_DATA_ICON = strzone(value);
        }
        if( token == "en_max"){
          MECH_DATA_ENMAX = stof(value);
        }
        if( token == "en_rate"){
          MECH_DATA_ENRATE = stof(value);
        }
        if( token == "sh_max"){
          MECH_DATA_SHMAX = stof(value);
        }
        if( token == "sh_rate"){
          MECH_DATA_SHRATE = stof(value);
        }
        if( token == "hpoints"){
          MECH_DATA_HPOINTS = stof(value);
        }
        if( token == "fspeed"){
          MECH_DATA_SPEEDF = stof(value);
        }
        if( token == "sspeed"){
          MECH_DATA_SPEEDS = stof(value);
        }
        if( token == "bspeed"){
          MECH_DATA_SPEEDB = stof(value);
        }
        if( token == "accel"){
          MECH_DATA_ACCEL = stof(value);
        }
        if( token == "hp_ct"){
          MECH_DATA_HPCT = stof(value);
        }
        if( token == "hp_st"){
          MECH_DATA_HPST = stof(value);
        }
        if( token == "hp_am"){
          MECH_DATA_HPAR = stof(value);
        }
        if( token == "hp_lg"){
          MECH_DATA_HPLG = stof(value);
        }
        if( token == "radrng"){
          MECH_DATA_RAD = stof(value);
        }
        if( token == "desc"){
          tokenizebyseparator(line, ": ", "~");
          MECH_DATA_DESC = strzone(argv(1));
        }
        if( strstrofs(token, "types",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
          idx = stof(argv(2));
          MECH_DATA_H_TYPE[idx] = stof(value); 
        }
        if( strstrofs(token, "size",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
          idx = stof(argv(2));
          MECH_DATA_H_SIZE[idx] = stof(value);
        }
        if( strstrofs(token, "arm",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
          idx = stof(argv(2));
          MECH_DATA_H_ARM[idx] = stov(value);
        }
        if( strstrofs(token, "hang",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
          idx = stof(argv(2));
          MECH_DATA_H_HNG[idx] = stov(value);
        }
        if( strstrofs(token, "stock",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
          idx = stof(argv(2));
          MECH_DATA_STOCK[idx] = stof(value); 
        }
        if( strstrofs(token, "grps",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
          idx = stof(argv(2));
          MECH_DATA_GRPS[idx] = stof(value); 
        }
      }
    }
    line = fgets(flannel);
  }
  fclose(flannel);
  return TRUE;
};