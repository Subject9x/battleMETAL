/*
mech Mod
Author: Peter Roohr
Date: 01/28/2018
Overview: implementation
*/

void() data_ini_arrays={
  //Weapon Names
  data_WeaponNames[ID_WEP_LATC] = DAT_LATC_NAME;
  data_WeaponNames[ID_WEP_LAS] = DAT_LAS_NAME;
  data_WeaponNames[ID_WEP_EMP] = DAT_EMP_NAME;
  data_WeaponNames[ID_WEP_MIS] = DAT_MIS_NAME;
  data_WeaponNames[ID_WEP_QRF] = DAT_QRF_NAME;
  data_WeaponNames[ID_WEP_RPC] = DAT_RPC_NAME;
  data_WeaponNames[ID_WEP_PAC] = DAT_PAC_NAME;
  data_WeaponNames[ID_WEP_ESR] = DAT_ESR_NAME;
  data_WeaponNames[ID_WEP_MLGD] = DAT_MLGD_NAME;
  data_WeaponNames[ID_WEP_MARH] = DAT_MARH_NAME;
  data_WeaponNames[ID_WEP_SFGA] = DAT_SFGA_NAME;
  data_WeaponNames[ID_WEP_FLAK] = DAT_FLAK_NAME;
  data_WeaponNames[ID_WEP_ION] = DAT_ION_NAME;
  data_WeaponNames[ID_WEP_SWRM] = DAT_SWRM_NAME;
  
  data_WeaponNames[ID_EQP_ATGM] = DAT_EQP_ATGM_NAME;
  data_WeaponNames[ID_EQP_ENBAT] = DAT_EQP_ENBAT_NAME;
  data_WeaponNames[ID_EQP_HSEM] = DAT_EQP_HSEM_NAME;
  data_WeaponNames[ID_EQP_LSAR] = DAT_EQP_LSAR_NAME;
  data_WeaponNames[ID_EQP_SCAP] = DAT_EQP_SCAP_NAME;
  data_WeaponNames[ID_EQP_RECAP] = DAT_EQP_RECAP_NAME;

  //Weapon Icons
  data_WeaponIcons[ID_WEP_LATC] = DAT_LATC_ICON;
  data_WeaponIcons[ID_WEP_LAS] = DAT_LAS_ICON;
  data_WeaponIcons[ID_WEP_EMP] = DAT_EMP_ICON;
  data_WeaponIcons[ID_WEP_MIS] = DAT_MIS_ICON;
  data_WeaponIcons[ID_WEP_QRF] = DAT_QRFL_ICON;
  data_WeaponIcons[ID_WEP_RPC] = DAT_RPLAS_ICON;
  data_WeaponIcons[ID_WEP_PAC] = DAT_PAC_ICON;
  data_WeaponIcons[ID_WEP_ESR] = DAT_ESR_ICON;
  data_WeaponIcons[ID_WEP_MLGD] = DAT_MLGD_ICON;
  data_WeaponIcons[ID_WEP_MARH] = DAT_MARH_ICON;
  data_WeaponIcons[ID_WEP_SFGA] = DAT_SFGA_ICON;
  data_WeaponIcons[ID_WEP_FLAK] = DAT_FLAK_ICON;
  data_WeaponIcons[ID_WEP_ION] = DAT_ION_ICON;
  data_WeaponIcons[ID_WEP_SWRM] = DAT_SWRM_ICON;
  
  data_WeaponIcons[ID_EQP_ATGM] = DAT_EQP_ATGM_ICON;
  data_WeaponIcons[ID_EQP_ENBAT] = DAT_EQP_ENBAT_ICON;
  data_WeaponIcons[ID_EQP_HSEM] = DAT_EQP_HSEM_ICON;
  data_WeaponIcons[ID_EQP_LSAR] = DAT_EQP_LSAR_ICON;
  data_WeaponIcons[ID_EQP_SCAP] = DAT_EQP_SCAP_ICON;
  data_WeaponIcons[ID_EQP_RECAP] = DAT_EQP_RECAP_ICON;
  
  //hey arrays are fast, right?
  data_WeaponType[ID_WEP_LATC] = 1;
  data_WeaponType[ID_WEP_LAS] = 2;
  data_WeaponType[ID_WEP_EMP] = 2;
  data_WeaponType[ID_WEP_MIS] = 4;
  data_WeaponType[ID_WEP_QRF] = 1;
  data_WeaponType[ID_WEP_RPC] = 1;
  data_WeaponType[ID_WEP_PAC] = 2;
  data_WeaponType[ID_WEP_ESR] = 2;
  data_WeaponType[ID_WEP_MLGD] = 4;
  data_WeaponType[ID_WEP_MARH] = 4;
  data_WeaponType[ID_WEP_SFGA] = 1;
  data_WeaponType[ID_WEP_FLAK] = 1;
  data_WeaponType[ID_WEP_ION] = 2;
  data_WeaponType[ID_WEP_SWRM] = 4;
  
  data_WeaponType[ID_EQP_ATGM] = 128;
  data_WeaponType[ID_EQP_ENBAT] = 128;
  data_WeaponType[ID_EQP_HSEM] = 128;
  data_WeaponType[ID_EQP_LSAR] = 128;
  data_WeaponType[ID_EQP_SCAP] = 128;
  data_WeaponType[ID_EQP_RECAP] = 128;

  data_WeaponSize[ID_WEP_LATC] = DAT_LATC_WSIZE;
  data_WeaponSize[ID_WEP_LAS] = DAT_LAS_WSIZE;
  data_WeaponSize[ID_WEP_EMP] = DAT_EMP_WSIZE;
  data_WeaponSize[ID_WEP_MIS] = DAT_MIS_WSIZE;
  data_WeaponSize[ID_WEP_QRF] = DAT_QRFL_WSIZE;
  data_WeaponSize[ID_WEP_RPC] = DAT_RPLAS_WSIZE;
  data_WeaponSize[ID_WEP_PAC] = DAT_PAC_WSIZE;
  data_WeaponSize[ID_WEP_ESR] = DAT_ESR_WSIZE;
  data_WeaponSize[ID_WEP_MLGD] = DAT_MLGD_WSIZE;
  data_WeaponSize[ID_WEP_MARH] = DAT_MARH_WSIZE;
  data_WeaponSize[ID_WEP_SFGA] = DAT_SFGA_WSIZE;
  data_WeaponSize[ID_WEP_FLAK] = DAT_FLAK_WSIZE;
  data_WeaponSize[ID_WEP_ION] = DAT_ION_WSIZE;
  data_WeaponSize[ID_WEP_SWRM] = DAT_SWRM_WSIZE;
  
  data_WeaponSize[ID_EQP_ATGM] = DAT_EQP_ATGM_WSIZE;
  data_WeaponSize[ID_EQP_ENBAT] = DAT_EQP_ENBAT_WSIZE;
  data_WeaponSize[ID_EQP_HSEM] = DAT_EQP_HSEM_WSIZE;
  data_WeaponSize[ID_EQP_LSAR] = DAT_EQP_LSAR_WSIZE;
  data_WeaponSize[ID_EQP_SCAP] = DAT_EQP_SCAP_WSIZE;
  data_WeaponSize[ID_EQP_RECAP] = DAT_EQP_RECAP_WSIZE;
  
  data_WeaponEne[ID_WEP_LATC] = DAT_LATC_EN_RATE;
  data_WeaponEne[ID_WEP_LAS] = DAT_LAS_EN_RATE;
  data_WeaponEne[ID_WEP_EMP] = DAT_EMP_EN_RATE;
  data_WeaponEne[ID_WEP_MIS] = DAT_MIS_EN_RATE;
  data_WeaponEne[ID_WEP_QRF] = DAT_QRFL_EN_RATE;
  data_WeaponEne[ID_WEP_RPC] = DAT_RPLAS_EN_RATE;
  data_WeaponEne[ID_WEP_PAC] = DAT_PAC_EN_RATE;
  data_WeaponEne[ID_WEP_ESR] = DAT_ESR_EN_RATE;
  data_WeaponEne[ID_WEP_MLGD] = DAT_MLGD_EN_RATE;
  data_WeaponEne[ID_WEP_MARH] = DAT_MARH_EN_RATE;
  data_WeaponEne[ID_WEP_SFGA] = DAT_SFGA_EN_RATE;
  data_WeaponEne[ID_WEP_FLAK] = DAT_FLAK_EN_RATE;
  data_WeaponEne[ID_WEP_ION] = DAT_ION_EN_RATE;
  data_WeaponEne[ID_WEP_SWRM] = DAT_SWRM_EN_RATE;
  
  data_WeaponEne[ID_EQP_ATGM] = 0;
  data_WeaponEne[ID_EQP_ENBAT] = DAT_EQP_ENBAT_EN_RATE * -1;
  data_WeaponEne[ID_EQP_HSEM] = 0;
  data_WeaponEne[ID_EQP_LSAR] = 0;
  data_WeaponEne[ID_EQP_SCAP] = 0;
  data_WeaponEne[ID_EQP_RECAP] = DAT_EQP_RECAP_EN_RATE * -1;
};

string(float data_idx) data_get_weapon_name={
  local float idx;
  idx = 0;
  while(idx < UI_TOTAL_WEAPONS){
    if(idx == data_idx){
      return data_WeaponNames[idx];
    }
    idx = idx + 1;
  }
};

string(float data_idx) data_get_weapon_icon={
  local float idx;
  idx = 0;
  while(idx < UI_TOTAL_WEAPONS){
    if(idx == data_idx){
      return data_WeaponIcons[idx];
    }
    idx = idx + 1;
  }
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
          local float idx;
          idx = stof(argv(1));
          DATA_CONFIG_BUFFER_WEPS[idx] = stof(value);
        }
        if( strstrofs(token, "group",0) != -1 ){
          tokenizebyseparator(token, "_");
          local float idx;
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
      wtype = data_WeaponType[wepid];
      wsize = data_WeaponSize[wepid];
      hpttype = MECH_DATA_H_TYPE[itr];
      hptsize = MECH_DATA_H_SIZE[itr];
      if( !(hpttype & wtype) ){
        cons_logAString("data_mech_config_valid", "FAILED - Hardpoint Type mismatch");  //DEBUG
        return FALSE;
      }
      if( wsize > hptsize ){
        cons_logAString("data_mech_config_valid", "FAILED - Hardpoint Size mismatch");  //DEBUG
        return FALSE;
      }
    }
    itr = itr + 1;
  }
  return TRUE;
};
