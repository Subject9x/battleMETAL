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
  data_WeaponNames[ID_WEP_MAPR] = "";
  //data_WeaponNames[ID_WEP_MCRK] = "";
  data_WeaponNames[ID_WEP_RAM] = "";
  data_WeaponNames[ID_WEP_BLD] = "";
  data_WeaponNames[ID_WEP_SFGA] = DAT_SFGA_NAME;
  data_WeaponNames[ID_WEP_FLAK] = DAT_FLAK_NAME;
  data_WeaponNames[ID_WEP_ION] = DAT_ION_NAME;
  data_WeaponNames[ID_WEP_SWRM] = DAT_SWRM_NAME;
  
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
  data_WeaponIcons[ID_WEP_MAPR] = "";
  //data_WeaponNames[ID_WEP_MCRK] = "";
  data_WeaponIcons[ID_WEP_RAM] = "";
  data_WeaponIcons[ID_WEP_BLD] = "";
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
 0 name
 1 size
 2 speed forward
 3 speed strafe
 4 speed back
 5 energy max
 6 energy rate
 7 shield max
 8 shield rate
 9 armor ct
 10 armor torso
 11 armor arm
 12 armor leg
 13 radar range
*/
//MECHS
void(float data_idx, float vsize) data_get_mech={

  if(vsize == 1){
    if(data_idx == ID_MCH_BALAKET){
      buffer_MechInfo[0] = MCH_NAME_BLK;
      buffer_MechInfo[1] = ftos(SZ_MCH_BALAKET);
      buffer_MechInfo[2] = ftos(DAT_OTL_M_FSPEED);
      buffer_MechInfo[3] = ftos(DAT_OTL_M_SSPEED);
      buffer_MechInfo[4] = ftos(DAT_OTL_M_BSPEED);
      buffer_MechInfo[5] = ftos(DAT_OTL_ENERGY_MAX);
      buffer_MechInfo[6] = ftos(DAT_OTL_ENERGY_RATE);
      buffer_MechInfo[7] = ftos(DAT_OTL_SHIELD_MAX);
      buffer_MechInfo[8] = ftos(DAT_OTL_SHIELD_RATE);
      buffer_MechInfo[9] = ftos(DAT_OTL_CTOR_HP);
      buffer_MechInfo[10] = ftos(DAT_OTL_LTOR_HP);
      buffer_MechInfo[11] = ftos(DAT_OTL_LARM_HP);
      buffer_MechInfo[12] = ftos(DAT_OTL_LEG_HP);
      buffer_MechInfo[13] = ftos(DAT_OTL_RADAR_RANGE);
    }
  }
  else if(vsize == 2){
    if(data_idx == ID_MCH_MATOK){ 
      buffer_MechInfo[0] = MCH_NAME_MTK;
      buffer_MechInfo[1] = ftos(SZ_MCH_MATOK);
      buffer_MechInfo[2] = ftos(DAT_MTK_M_FSPEED);
      buffer_MechInfo[3] = ftos(DAT_MTK_M_SSPEED);
      buffer_MechInfo[4] = ftos(DAT_MTK_M_BSPEED);
      buffer_MechInfo[5] = ftos(DAT_MTK_ENERGY_MAX);
      buffer_MechInfo[6] = ftos(DAT_MTK_ENERGY_RATE);
      buffer_MechInfo[7] = ftos(DAT_MTK_SHIELD_MAX);
      buffer_MechInfo[8] = ftos(DAT_MTK_SHIELD_RATE);
      buffer_MechInfo[9] = ftos(DAT_MTK_CTOR_HP);
      buffer_MechInfo[10] = ftos(DAT_MTK_LTOR_HP);
      buffer_MechInfo[11] = ftos(DAT_MTK_LARM_HP);
      buffer_MechInfo[12] = ftos(DAT_MTK_LEG_HP);
      buffer_MechInfo[13] = ftos(DAT_MTK_RADAR_RANGE);
    }
  
  }
  else if(vsize == 3){
    if(data_idx == ID_MCH_MONITOR){  
      buffer_MechInfo[0] = MCH_NAME_MNT;
      buffer_MechInfo[1] = ftos(SZ_MCH_MONITOR);
      buffer_MechInfo[2] = ftos(DAT_MNT_M_FSPEED);
      buffer_MechInfo[3] = ftos(DAT_MNT_M_SSPEED);
      buffer_MechInfo[4] = ftos(DAT_MNT_M_BSPEED);
      buffer_MechInfo[5] = ftos(DAT_MNT_ENERGY_MAX);
      buffer_MechInfo[6] = ftos(DAT_MNT_ENERGY_RATE);
      buffer_MechInfo[7] = ftos(DAT_MNT_SHIELD_MAX);
      buffer_MechInfo[8] = ftos(DAT_MNT_SHIELD_RATE);
      buffer_MechInfo[9] = ftos(DAT_MNT_CTOR_HP);
      buffer_MechInfo[10] = ftos(DAT_MNT_LTOR_HP);
      buffer_MechInfo[11] = ftos(DAT_MNT_LARM_HP);
      buffer_MechInfo[12] = ftos(DAT_MNT_LEG_HP);
      buffer_MechInfo[13] = ftos(DAT_MNT_RADAR_RANGE);
    }
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
