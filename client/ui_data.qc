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
        if(idx <= GAME_TOTAL_MECHS){
          MECH_DATA_NAMES[idx] = strzone(ln);
        }
        idx = idx + 1;
      }
      ln = fgets(f);
    } 
  } 
  fclose(f); 
};

void() ui_data_load_hudnames={
  local float f, idx;
  local string ln;
  idx = 1;
  f = fopen("ui/hud/dir.meta", FILE_READ);
  if (f != -1){ 
    ln = fgets(f);
    while( ln != "" ){
      if( strstrofs(ln, "//", 0) == -1 ){
        if(idx <= GAME_TOTAL_MECHS){
          HUD_DATA_NAMES[idx] = strzone(ln);
        }
        idx = idx + 1;
      }
      ln = fgets(f);
    } 
  } 
  fclose(f); 
};


void() ui_data_load_itemnames={
  local float f, idx;
  local string ln;
  idx = 1;
  f = fopen("ui/item/dir.meta", FILE_READ);
  if (f != -1){ 
    ln = fgets(f);
    while( ln != "" ){
      if( strstrofs(ln, "//", 0) == -1 ){
        if(idx <= GAME_TOTAL_ITEMS){
          ITEM_DATA_NAMES[idx] = strzone(ln);
        }
        idx = idx + 1;
      }
      ln = fgets(f);
    } 
  } 
  fclose(f); 
};

void() ui_data_load_itemicons={
  local float count;
  count = 1;
  while( count <= GAME_TOTAL_ITEMS) {
    local string file, filename;
    local float flannel;
    filename = ITEM_DATA_NAMES[count];
    if(filename != ""){
      file = strcat("ui/item/", filename,".dat");
      flannel = fopen(file, FILE_READ);
      if(flannel != -1){
        local string line, ico;
        line = fgets(flannel);
        while( (line != "") ){
          if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
            tokenizebyseparator(line, "  '","'"," : ", ",");
            local string token, value;
            token = argv(1);
            value = argv(3);
            if( token == "icon" ){
              ico = value;
            }
          }
          line = fgets(flannel);
        }
        
        if( ico != "" ){
          ITEM_DATA_ICONS[count] = strzone(ico);
        }
        else{
          ITEM_DATA_ICONS[count] = strzone("");
        }
        fclose(flannel);
      }
      else{
        ITEM_DATA_ICONS[count] = "";
      }
    }
    count = count + 1;
  }
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

void() ui_data_clear_huddata={
  local float itr;
  itr = 1;
  while( itr <= 32 ){
    UI_DATA_UIDS[itr] = 0;
    UI_DATA_POS[itr] = '0 0 0';
    UI_DATA_SIZE[itr] = '0 0 0';
    UI_DATA_ALIGN[itr] = 0;
    UI_DATA_LABEL_FLAG[itr] = 0;
    UI_DATA_LABEL_ALIGN[itr] = 0;
    UI_DATA_AXIS_FLAG[itr] = 0;
    UI_DATA_LABEL_OFS[itr] = '0 0 0';
    UI_DATA_COLOR1[itr] = '0 0 0';
    UI_DATA_COLOR2[itr] = '0 0 0';
    if( UI_DATA_IMG[itr] != "" ){
      strunzone( UI_DATA_IMG[itr] );
    }
    UI_DATA_IMG[itr] = ""; //background image if needed
    itr = itr + 1;
  }
};

void() ui_data_clear_item1={

  if( ITEM1_DATA_ID <= 0 ){
    return;
  }
 
  ITEM1_DATA_ID = 0;
  if( ITEM1_DATA_ABBR != "" ){
    strunzone(ITEM1_DATA_ABBR);
  }

  if( ITEM1_DATA_NAME != "" ){
    strunzone(ITEM1_DATA_NAME);
  }
  
  if( ITEM1_DATA_ICON != "" ){
    strunzone(ITEM1_DATA_ICON);
  }
  ITEM1_DATA_DMG = 0;
  ITEM1_DATA_TYPE = 0;
  ITEM1_DATA_EN = 0;
  ITEM1_DATA_RANGE = 0;
  ITEM1_DATA_CLIP = 0;
  ITEM1_DATA_SIZE = 0;
  ITEM1_DATA_TECH = 0;
  if( ITEM1_DATA_DESC != "" ){
    strunzone(ITEM1_DATA_DESC);
  }
};

void() ui_data_clear_item2={

  if( ITEM2_DATA_ID <= 0 ){
    return;
  }
  ITEM2_DATA_ID = 0;
  if( ITEM2_DATA_ABBR != "" ){
    strunzone(ITEM2_DATA_ABBR);
  }
  if( ITEM2_DATA_NAME != "" ){
    strunzone(ITEM2_DATA_NAME);
  }
  if( ITEM2_DATA_ICON != "" ){
    strunzone(ITEM2_DATA_ICON);
  }
  ITEM2_DATA_DMG = 0;
  ITEM2_DATA_TYPE = 0;
  ITEM2_DATA_EN = 0;
  ITEM2_DATA_RANGE = 0;
  ITEM2_DATA_CLIP = 0;
  ITEM2_DATA_SIZE = 0;
  ITEM2_DATA_TECH = 0;
  
  if( ITEM2_DATA_DESC != "" ){
    strunzone(ITEM2_DATA_DESC);
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

float( float id ) ui_data_load_hud={
  ui_data_clear_huddata();
  local float flannel, line_tag, uid;
  local string file, contents, line;
  file = strcat(PATH_DATA_UI, "/hud/", HUD_DATA_NAMES[id], ".dat");
  flannel = fopen(file, FILE_READ);
  if(flannel == -1){
    cons_logAString("ERROR", strcat("File[", file,"] NOT FOUND"));  
    return FALSE;
  }
  contents = fgets(flannel);
  //tokenizebyseparator(contents, "{", ",", "}");
  uid = 0;
  line = fgets(flannel);
  while( (line != "") ){ 
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      local string token, value;
      line_tag = tokenizebyseparator(line, "  '","'",": ", ",");
      token = argv(1);
      value = argv(3);
      if( token != ""){
        if( token == "uid"){
          UI_DATA_UIDS[uid] = stof(value);
        }
        if( token == "pos"){
          UI_DATA_POS[uid] = stov(value);
        }
        if( token == "size"){
          UI_DATA_SIZE[uid] = stov(value);
        }
        if( token == "icon"){
          UI_DATA_IMG[uid] = strzone(value);
        }
        if( token == "valign"){
          UI_DATA_ALIGN[uid] = stof(value);
        }
        if( token == "color1"){
          UI_DATA_COLOR1[uid] = stov(value);
        }
        if( token == "color2"){
          UI_DATA_COLOR2[uid] = stov(value);
        }
        if( token == "label"){
          UI_DATA_LABEL[uid] = strzone(value);
        }
        if( token == "lalign"){
          UI_DATA_LABEL_ALIGN[uid] = stof(value);
        }
        if( token == "axis"){
          UI_DATA_AXIS_FLAG[uid] = stof(value);
        }
        if( token == "lblofs"){
          UI_DATA_LABEL_OFS[uid] = stov(value);
        }
        if( token == "wbit"){
          UI_DATA_WEPBIT[uid] = stof(value);
        }
        if( token == "lflag"){
          UI_DATA_LABEL_FLAG[uid] = stof(value);
        }
      }
    }
    if( line == "{" ){
      uid = uid + 1;
    }
    line = fgets(flannel);
  }
  fclose(flannel);
  return TRUE;
};


float(float id) ui_date_load_item1={
  ui_data_clear_item1();
  local float flannel, line_tag, line_val;
  local string file, contents, line;
  file = strcat(PATH_DATA_UI, "/item/", ITEM_DATA_NAMES[id],".dat");
  flannel = fopen(file, FILE_READ);
  if(flannel == -1){
    cons_logAString("ERROR", strcat("File[", file,"] NOT FOUND"));  
    return FALSE;
  }
  contents = fgets(flannel);
  line = fgets(flannel);
  while( (line != "") ){
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "  '","'",": ", ",");
      local string token, value;
      token = argv(1);
      value = argv(3);
      if( token != ""){
        if( token == "id" ){
          ITEM1_DATA_ID = stof(value);
        }
        if( token == "abbr" ){
          ITEM1_DATA_ABBR = strzone(value);
        }
        if( token == "name" ){
          ITEM1_DATA_NAME = strzone(value);
        }
        if( token == "icon" ){
          ITEM1_DATA_ICON = strzone(value);
        }
        if( token == "dmg" ){
          ITEM1_DATA_DMG = stof(value); 
        }
        if( token == "type" ){
          ITEM1_DATA_TYPE = stof(value);
        }
        if( token == "energy" ){
          ITEM1_DATA_EN = stof(value);
        }
        if( token == "range" ){
          ITEM1_DATA_RANGE = stof(value);
        }
        if( token == "clipsize" ){
          ITEM1_DATA_CLIP = stof(value);
        }
        if( token == "size" ){
          ITEM1_DATA_SIZE = stof(value);
        }
        if( token == "tech" ){
          ITEM1_DATA_TECH = stof(value);
        }
        if( token == "note" ){          
          tokenizebyseparator(line, ": ", "~");
          ITEM1_DATA_DESC = strzone(argv(1));
        }
      }
    }
   line = fgets(flannel);
  }
  fclose(flannel);
  return TRUE;
};

float(float id) ui_date_load_item2={
  ui_data_clear_item2();
  local float flannel, line_tag, line_val;
  local string file, contents, line;
  file = strcat(PATH_DATA_UI, "/item/", ITEM_DATA_NAMES[id],".dat");
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
        if( token == "id" ){
          ITEM2_DATA_ID = stof(value);
        }
        if( token == "abbr" ){
          ITEM2_DATA_ABBR = strzone(value);
        }
        if( token == "name" ){
          ITEM2_DATA_NAME = strzone(value);
        }
        if( token == "icon" ){
          ITEM2_DATA_ICON = strzone(value);
        }
        if( token == "dmg" ){
          ITEM2_DATA_DMG = stof(value); 
        }
        if( token == "type" ){
          ITEM2_DATA_TYPE = stof(value);
        }
        if( token == "energy" ){
          ITEM2_DATA_EN = stof(value);
        }
        if( token == "range" ){
          ITEM2_DATA_RANGE = stof(value);
        }
        if( token == "clipsize" ){
          ITEM2_DATA_CLIP = stof(value);
        }
        if( token == "size" ){
          ITEM2_DATA_SIZE = stof(value);
        }
        if( token == "tech" ){
          ITEM2_DATA_TECH = stof(value);
        }
        if( token == "note" ){          
          tokenizebyseparator(line, ": ", "~");
          ITEM2_DATA_DESC = strzone(argv(1));
        }
      }
    }
   line = fgets(flannel);
  }
  fclose(flannel);
  return TRUE;
};

float( float mechId, float fileNum ) ui_mech_config_switch={
  local float cfg, itr;
  
  if( self.plr_sel_mech > 0 ){
    if( CFG_INDEX_PREV > 0 ){
      //prevents overriding Config 0 - the default config for each mech
      data_mech_config_save( self.plr_sel_mech, CFG_INDEX_PREV );
    }
    data_mech_config_clearBuffer();
  }
  
  ui_data_load_mech( mechId );
  
  //Attempt to load and validate the desired config
  cfg = data_mech_config_load( mechId, fileNum );
  if( cfg ){
    cfg = data_mech_config_valid();
  }
  
  //hm, desired config has errors, try the DEFAULT? you did keep the default around....right?
  if( !cfg ){
    cfg = data_mech_config_load( mechId, 0 );
    cfg = data_mech_config_valid();
    //CFG_INDEX = 0;
  }
  
  //welp, here goes, lets make the switch
  if( cfg ){
    SELECT_MECH = mechId;
    self.plr_sel_mech = SELECT_MECH;
    self.plr_sel_size = MECH_DATA_SIZES[SELECT_MECH];
    cleanHardPoints();
    self.plr_nex_grp1 = data_config_buffer_grps[1];
    self.plr_nex_grp2 = data_config_buffer_grps[2];
    self.plr_nex_grp3 = data_config_buffer_grps[3];
    self.plr_nex_grp4 = data_config_buffer_grps[4];
    self.plr_nex_grp5 = data_config_buffer_grps[5];
    itr = 1;
    while( itr <= MECH_DATA_HPOINTS ){
      local float buffwep, hpt;
      buffwep =  data_config_buffer_weps[itr];
      HARDPOINTS[itr] = buffwep;
      itr = itr + 1;
    }
    GROUP_ENE_1 = calc_energy_draw(self.plr_nex_grp1);
    GROUP_ENE_2 = calc_energy_draw(self.plr_nex_grp2);
    GROUP_ENE_3 = calc_energy_draw(self.plr_nex_grp3);
    GROUP_ENE_4 = calc_energy_draw(self.plr_nex_grp4);
    GROUP_ENE_5 = calc_energy_draw(self.plr_nex_grp5);
  }

};
