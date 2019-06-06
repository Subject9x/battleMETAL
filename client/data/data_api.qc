/*
battleMETAL
Author: Peter Roohr
Date: 01/28/2018
Overview: implementation
*/

//Wrapping data_system functionalities for cleanliness.
void( entity item, float id ) data_get_client_item_;
void( entity item, float id ) data_get_client_mech_;
void( entity item, float id ) data_get_client_vehicle_;
void( entity item, float id ) data_get_client_turret_;
void( entity item, float id ) data_get_client_building_;

void() data_ini_arrays={

  //TODO - run this weapon-entity chicanery when loading the menu, leverage existing data_Arrays for the job
	
  //Weapon Names
  /*data_WeaponNames[ID_WEP_LATC] = DAT_LATC_NAME;*/

  //Weapon Icons
  /*data_WeaponIcons[ID_WEP_LATC] = DAT_LATC_ICON;*/
  
  //hey arrays are fast, right?
  /*data_WeaponType[ID_WEP_LATC] = 1;*/

  /*data_WeaponSize[ID_WEP_LATC] = DAT_LATC_WSIZE;*/
  
  /*data_WeaponEne[ID_WEP_LATC] = DAT_LATC_EN_RATE;*/
};

string(float dataIdx) data_get_weapon_name={
  local float idx;
  idx = 0;
  while(idx < UI_TOTAL_WEAPONS){
    if(idx == dataIdx){
      return data_WeaponNames[idx];
    }
    idx = idx + 1;
  }
  return "";
};

string(float dataIdx) data_get_weapon_icon={
  local float idx;
  idx = 0;
  while(idx < UI_TOTAL_WEAPONS){
    if(idx == dataIdx){
      return data_WeaponIcons[idx];
    }
    idx = idx + 1;
  }
  return "";
};

void() data_mech_config_clearBuffer={
  local float itr;
  itr = 1;
  DATA_CONFIG_BUFFER_FILENUM = 0;
  if( DATA_CONFIG_BUFFER_NAME != "" ){
    strunzone( DATA_CONFIG_BUFFER_NAME );
  }
  DATA_CONFIG_BUFFER_NAME = "";
  
  while( itr < 10 ){
    DATA_CONFIG_BUFFER_WEPS[itr] = 0;
    if( itr < 6 ){
      DATA_CONFIG_BUFFER_GRPS[itr] = 0;
    }
    itr = itr + 1;
  }
};

void( float mechId, float configNum ) data_mech_config_save={
  local float flannel, itr;
  local string file, line, group;

  itr = 1;
  file = strcat(PATH_DATA_UI, "/loadouts/", ftos(mechId), "/", ftos(configNum),".dat");
 
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'id' : ", ftos(DATA_CONFIG_BUFFER_FILENUM), ",\n"));
  fputs(flannel, strcat("  'name' : ", DATA_CONFIG_BUFFER_NAME, ",\n"));
  
  while( itr <= MECH_DATA_HPOINTS ){
    local string wep;
    local float wepid;
    wepid = HARDPOINTS[itr];
    wep = strcat( "  'hpt_", ftos(itr), "' : ", ftos(wepid), ",\n");
    fputs(flannel, wep);
    itr = itr + 1;
  }
  group = strcat( "  'group_", ftos(1), "' : ", ftos(CLIENT_MENU_nex_grp1), ",\n");
  fputs(flannel, group);
  
  group = strcat( "  'group_", ftos(2), "' : ", ftos(CLIENT_MENU_nex_grp2), ",\n");
  fputs(flannel, group);
 
  group = strcat( "  'group_", ftos(3), "' : ", ftos(CLIENT_MENU_nex_grp3), ",\n");
  fputs(flannel, group);
  
  group = strcat( "  'group_", ftos(4), "' : ", ftos(CLIENT_MENU_nex_grp4), ",\n");
  fputs(flannel, group);
  
  group = strcat( "  'group_", ftos(5), "' : ", ftos(CLIENT_MENU_nex_grp5), ",\n");
  fputs(flannel, group);
  
  fputs(flannel, "}");
  fclose(flannel);
};

float( float mechId, float configNum ) data_mech_config_load={
  local float flannel, line_tag, line_val;
  local float idx;
  local string file, contents, line;
  
  file = strcat(PATH_DATA_UI, "/loadouts/", ftos(mechId), "/", ftos(configNum),".dat");
  flannel = fopen(file, FILE_READ);
  if(flannel == -1){
    if( cvar("developer") ){
      cons_logAString("ERROR", strcat("File[", file,"] NOT FOUND"));
    }
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
          DATA_CONFIG_BUFFER_FILENUM = stof(value);
        }
        if( token == "name"){
          DATA_CONFIG_BUFFER_NAME = strzone(value);
        }
        if( strstrofs(token, "hpt",0) != -1 ){
          tokenizebyseparator(token, "_");
          idx = stof(argv(1));
          DATA_CONFIG_BUFFER_WEPS[idx] = stof(value);
        }
        if( strstrofs(token, "group",0) != -1 ){
          tokenizebyseparator(token, "_");
          idx = stof(argv(1));
          DATA_CONFIG_BUFFER_GRPS[idx] = stof(value);
        }
      }
    }
    line = fgets(flannel);
  }
  fclose(flannel);
  return TRUE;
};

/*
  Validates the Mech Config File against the target mech data.
  We don't really want too much messing around here.
*/
float() data_mech_config_valid={
  local float valid, itr;
  
  itr = 1;
  while( itr <= MECH_DATA_HPOINTS ){
    local float wepid, wtype, wsize, hptsize, hpttype;
    if( itr > MECH_DATA_HPOINTS ){
      wepid = DATA_CONFIG_BUFFER_WEPS[itr];
      if( wepid > 0 ){
        cons_logAString("data_mech_config_valid", "FAILED - too many hardpoints");  //DEBUG
        return FALSE; //Trying to sneak more weapons into the config file?
      }
    }
    if( itr <= MECH_DATA_HPOINTS ){
      wepid = DATA_CONFIG_BUFFER_WEPS[itr];
      if( wepid > 0 ){
        wtype = data_WeaponType[wepid];
        wsize = data_WeaponSize[wepid];
        hpttype = MECH_DATA_H_TYPE[itr];
        hptsize = MECH_DATA_H_SIZE[itr];
        if( (wtype != 0) && !(hpttype & wtype) ){
          cons_logAString("data_mech_config_valid", "FAILED - Hardpoint Type mismatch");  //DEBUG
          return FALSE;
        }
        if( (wsize != 0) && (wsize > hptsize) ){
          cons_logAString("data_mech_config_valid", "FAILED - Hardpoint Size mismatch");  //DEBUG
          return FALSE;
        }
      }
    }
    itr = itr + 1;
  }
  return TRUE;
};