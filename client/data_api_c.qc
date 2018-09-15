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
  
  //hey arrays are fast, right?
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

/*
  data id
  data type
  vec size
*/

void(float dtype, float data_idx, float vsize) data_get_target={
  if(dtype == DATA_MECH){
    data_get_target_mech(data_idx, vsize);
  }
  else if(dtype == DATA_VEHC){
    data_get_target_vec(data_idx, vsize);
  }
  else if(dtype == DATA_BLD){
    data_get_target_bld(data_idx);
  }
};
void(float data_idx, float vsize) data_get_target_mech={
  if(vsize == 1){
    if(data_idx == ID_MCH_BALAKET){
      buffer_TargetInfo[0] = MCH_NAME_BLK;
    }
  }
  else if(vsize == 2){
    if(data_idx == ID_MCH_MATOK){
      buffer_TargetInfo[0] = MCH_NAME_MTK;
    }
  } 
  else if(vsize == 3){
    if(data_idx == ID_MCH_MONITOR){
      buffer_TargetInfo[0] = MCH_NAME_MNT;
    }
  }
};
void(float data_idx, float vsize) data_get_target_vec={

};
void(float data_idx) data_get_target_bld={

};
