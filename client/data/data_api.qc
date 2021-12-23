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

void() data_mech_config_clearBuffer={
  local float itr;
  itr = 1;
  DATA_CONFIG_BUFFER_FILENUM = 0;
  freeGlobalString(DATA_CONFIG_BUFFER_NAME)
  
  while( itr < 10 ){
    DATA_CONFIG_BUFFER_WEPS[itr] = 0;
    itr = itr + 1;
  }
  
  itr = 0;
  while( itr < 4 ){
    DATA_CONFIG_BUFFER_GRPS[itr] = 0;
    itr = itr + 1;
  }
};

void( float mechId, float configNum ) data_mech_config_save={
  local float flannel, itr;
  local string file, group;
  
  local entity hardpoint;
  local string writeWeaponLine;
  local float weaponId;
  
  itr = 1;
  file = strcat(PATH_DATA_UI, "/loadouts/", ftos(mechId), "/", ftos(configNum),".dat");
 
  flannel = fopen(file, FILE_WRITE);
  fputs(flannel, "{\n");
  fputs(flannel, strcat("  'id' : ", ftos(DATA_CONFIG_BUFFER_FILENUM), ",\n"));
  fputs(flannel, strcat("  'name' : ", DATA_CONFIG_BUFFER_NAME, ",\n"));
  
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  while( hardpoint ){
    weaponId = hardpoint.data_idx;
    writeWeaponLine = strcat( "  'hpt_", ftos(itr), "' : ", ftos(weaponId), ",\n");
    fputs(flannel, writeWeaponLine);
    itr = itr + 1;
    hardpoint = hardpoint.w_slot;
  }
  group = strcat( "  'group_1' : ", ftos(CLIENT_MENU_nex_grp1), ",\n");
  fputs(flannel, group);
  
  group = strcat( "  'group_2' : ", ftos(CLIENT_MENU_nex_grp2), ",\n");
  fputs(flannel, group);
 
  group = strcat( "  'group_3' : ", ftos(CLIENT_MENU_nex_grp3), ",\n");
  fputs(flannel, group);
  
  group = strcat( "  'group_4' : ", ftos(CLIENT_MENU_nex_grp4), ",\n");
  fputs(flannel, group);
  
  fputs(flannel, "}");
  fclose(flannel);
};

float( float mechId, float configNum ) data_mech_config_load={
  local float flannel, line_tag;
  local float idx;
  local string file, contents, line;
  local string token, value;
  
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
      token = argv(1);
      value = argv(3);
      if( token != ""){
        if( token == "id"){
          DATA_CONFIG_BUFFER_FILENUM = stof(value);
        }
        if( token == "name"){
          cacheGlobalString(DATA_CONFIG_BUFFER_NAME, value)
        }
        if( strstrofs(token, "hpt",0) != -1 ){
          tokenizebyseparator(token, "_");
          idx = stof(argv(1));
          DATA_CONFIG_BUFFER_WEPS[idx] = stof(value);
        }
        if( strstrofs(token, "group",0) != -1 ){
          tokenizebyseparator(token, "_");
          idx = stof(argv(1));
          idx = idx - 1;  //correct for 0 being array start.
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
  local float itr, itemItr, unlocked;
  local entity hardpoint;
  local entity weaponEnt;
  local float weaponId;
  unlocked = FALSE;
  hardpoint = UI_HANGAR_DATA_mech.w_slot;
  weaponEnt = spawn();
  itr = itemItr = 1;
  while( hardpoint ){
    weaponId = DATA_CONFIG_BUFFER_WEPS[itr];
    if( weaponId > 0 ){
      data_get_client_item_(weaponEnt, weaponId);
      //deprecating damage type as a hardpoint property, superseded by equipSize/hardpointSize
      /*if( (weaponEnt.damageType != 0) && !(hardpoint.hardpointType & weaponEnt.damageType) ){
        cons_logAString("data_mech_config_valid", "FAILED - Hardpoint Type mismatch");  //DEBUG
        remove(weaponEnt);
        return FALSE;
      }*/
      if( (weaponEnt.equipSize != 0) && !(weaponEnt.equipSize & hardpoint.hardpointSize) ){
        cons_logAString("data_mech_config_valid", "FAILED - Hardpoint Size mismatch");  //DEBUG
        DATA_CONFIG_BUFFER_WEPS[itr] = UID_ITEM_EMPTY;
      }
      itemItr = 1;
      unlocked = FALSE;
      while( itemItr < UNLOCKED_ITEMS_TOTAL ){
        if( weaponId == UNLOCKED_ITEMS[itemItr] ){
          unlocked = TRUE;
        }
        itemItr = itemItr + 1;
      }
      if( !unlocked ){
        DATA_CONFIG_BUFFER_WEPS[itr] = 0;
      }
    }
    itr = itr + 1;
    hardpoint = hardpoint.w_slot;
  }
  remove(weaponEnt);
  return TRUE;
};