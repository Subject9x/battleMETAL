/*
mech Mod
Author: Peter Roohr
Date: 10/31/2016
Overview: header for mech hud functions
*/


void() cs_removeEnt={
  remove(self);
};

void() cs_precache={

  //cockpit models
  precache_model ("q3mdl/mechs/notl/mdl_blk_cpt.md3");
  precache_model ("q3mdl/mechs/mtmk/mdl_mtk_cpt.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_cpt.md3");

  //cockpit images 
  HUD_BLK_IMG_B = precache_pic("gfx/hud/hud_blk_bck.png", 0);
  HUD_MTK_IMG_B = precache_pic("gfx/hud/hud_mtk_bck.png", 0);
  HUD_MNT_IMG_B = precache_pic("gfx/hud/hud_mnt_bck.png", 0);
  
  HUT_RET_PIP_HRZ = precache_pic("gfx/hud/ret_pip_hrz.png", 0);
  HUT_RET_PIP_VRT = precache_pic("gfx/hud/ret_pip_vrt.png", 0);
  HUT_RET_LOK = precache_pic("gfx/hud/ret_lock.png", 0);
  HUD_RET_HIT = precache_pic("gfx/hud/ret_hit.png", 0);
  HUD_RAD_PIP_BLD = precache_pic("gfx/hud/rad_bld.png", 0);
  HUD_RAD_PIP_MCH = precache_pic("gfx/hud/rad_mch.png", 0);
  HUD_RAD_PIP_NAV = precache_pic("gfx/hud/rad_nav.png", 0);
  HUD_RAD_PIP_VEC = precache_pic("gfx/hud/rad_vec.png", 0);
  
  HUD_TRG_PIP_L = precache_pic("gfx/hud/trg_pip_lft.png", 0);
  HUD_TRG_PIP_R = precache_pic("gfx/hud/trg_pip_rgt.png", 0);
  HUD_TRG_PIP_B = precache_pic("gfx/hud/trg_pip_bot.png", 0);
  
  HUD_DMG_PIP_H = precache_pic("gfx/hud/dmg_pip_hrz.png", 0);
  
  //hangar splash images
  precache_pic("gfx/ui/hgr_otl.png", 0);
  precache_pic("gfx/ui/hgr_mtk.png", 0);
  precache_pic("gfx/ui/hgr_mnt.png", 0);
  
  //cockpit voice
  SND_MCH_SFX_REACT = precache_sound2("sound/mech_react.ogg");
  SND_HUD_VFX_ONLINE = precache_sound2("sound/comp/online.ogg");
  SND_HUD_VFX_ENELOW = precache_sound2("sound/comp/en_low.ogg");
  SND_HUD_VFX_SHDLOW = precache_sound2("sound/comp/sh_low.ogg");
  SND_HUD_VFX_RDRACTIVE = precache_sound2("sound/comp/rdr_active.ogg");
  SND_HUD_VFX_RDRPASSIVE = precache_sound2("sound/comp/rdr_passive.ogg");
  SND_HUD_VFX_CRITARM = precache_sound2("sound/comp/crt_arm.ogg");
  SND_HUD_VFX_CRITTOR = precache_sound2("sound/comp/crt_torso.ogg");
  SND_HUD_VFX_CRITLEG = precache_sound2("sound/comp/crt_legs.ogg");
  SND_HUD_VFX_CRITTONE = precache_sound2("sound/comp/crt_warn.ogg");
  SND_HUD_VFX_NAVRECH = precache_sound2("sound/comp/nav_reach.ogg");
  SND_HUD_VFX_TARGKILL = precache_sound2("sound/comp/trg_kill.ogg");
  SND_HUD_VFX_OBJ_PRIME = precache_sound2("sound/comp/obj_prime.ogg");
  SND_HUD_VFX_OBJ_SECON = precache_sound2("sound/comp/obj_secon.ogg");
  SND_HUD_VFX_OBJ_THIRD = precache_sound2("sound/comp/obj_terti.ogg");
  SND_HUD_VFX_MSN_WIN = precache_sound2("sound/comp/msn_success.ogg");
  SND_HUD_VFX_MSN_FAL = precache_sound2("sound/comp/msn_fail.ogg");
  
  precache_sound("sound/weapons/atc_reload.ogg");
  
  //ui sounds
  precache_sound("sound/misc/menu1.wav");
  precache_sound("sound/misc/menu2.wav");
  precache_sound("sound/misc/menu3.wav");
  
  //cursor
  UI_CURSOR_IMG = precache_pic("gfx/ui/ui_cursor.png",0);
  UI_DEF_BOX_512 = precache_pic("gfx/ui/box_512.png",0);
  UI_DEF_BOX_256 = precache_pic("gfx/ui/box_256.png",0);
  UI_DEF_BOX_256_TALL = precache_pic("gfx/ui/box_256_tall.png",0);
  UI_DEF_BOX_64 = precache_pic("gfx/ui/box_64.png",0);
  UI_DEF_REC_64 = precache_pic("gfx/ui/box_64_rec.png",0);
  HUD_TARGET_BOX = precache_pic("gfx/hud/target_box.png",0);
  UI_DEF_NAVPOINT = precache_pic("gfx/ui/hud_navpoint.png",0);
  UI_DEF_DEPLOYPOINT = precache_pic("gfx/ui/hud_deploypoint.png", 0);
  UI_HANGAR_BOX = precache_pic("gfx/ui/hangar_portrait.png",0);
  UI_BOX_SELECT = precache_pic("gfx/ui/box_select.png",0);
  
  UI_WEP_ENE = precache_pic("gfx/ui/wep_icons/wep_ene.png",0);
  UI_WEP_BAL = precache_pic("gfx/ui/wep_icons/wep_bal.png",0);
  UI_WEP_EXP = precache_pic("gfx/ui/wep_icons/wep_exp.png",0);
  UI_WEP_MSC = precache_pic("gfx/ui/wep_icons/wep_msc.png",0);
  
  UI_WEP_LAS = precache_pic("gfx/ui/wep_icons/wi_las.png",0);
  UI_WEP_ESR = precache_pic("gfx/ui/wep_icons/wi_esr.png",0);
  UI_WEP_PAC = precache_pic("gfx/ui/wep_icons/wi_pac.png",0);
  UI_WEP_EMP = precache_pic("gfx/ui/wep_icons/wi_emp.png",0);
  UI_WEP_RCK = precache_pic("gfx/ui/wep_icons/wi_rck.png",0);
  UI_WEP_MLGD = precache_pic("gfx/ui/wep_icons/wi_mlgd.png",0);
  UI_WEP_MARH = precache_pic("gfx/ui/wep_icons/wi_marh.png",0);
  UI_WEP_ATC = precache_pic("gfx/ui/wep_icons/wi_atc.png",0);
  UI_WEP_QRF = precache_pic("gfx/ui/wep_icons/wi_qrf.png",0);
  UI_WEP_RPC = precache_pic("gfx/ui/wep_icons/wi_rpc.png",0);
  UI_WEP_SFG = precache_pic("gfx/ui/wep_icons/wi_sfg.png",0);
  UI_WEP_FLAK = precache_pic("gfx/ui/wep_icons/wi_flak.png",0);
  UI_WEP_ION = precache_pic("gfx/ui/wep_icons/wi_ion.png",0);
  UI_WEP_SWRM = precache_pic("gfx/ui/wep_icons/wi_swrm.png",0);
  UI_WEP_ABT = precache_pic("gfx/ui/wep_icons/wi_abt.png",0);
  
  UI_EQP_ATGM = precache_pic("gfx/ui/wep_icons/eqp_atgm.png",0);
  UI_EQP_ENBAT = precache_pic("gfx/ui/wep_icons/eqp_enbat.png",0);
  UI_EQP_HSEM = precache_pic("gfx/ui/wep_icons/eqp_hsem.png",0);
  UI_EQP_LSAR = precache_pic("gfx/ui/wep_icons/eqp_lsar.png",0);
  UI_EQP_SCAP = precache_pic("gfx/ui/wep_icons/eqp_lscap.png",0);
  UI_EQP_RECAP = precache_pic("gfx/ui/wep_icons/eqp_recap.png",0);
  
  //UI - mechs
   DAT_OTL_UI_IMG = precache_pic("gfx/ui/hgr_otl.png",0);
   DAT_MNT_UI_IMG = precache_pic("gfx/ui/hgr_MNT.png",0);
   DAT_MTK_UI_IMG = precache_pic("gfx/ui/hgr_mtk.png",0);
  
  //buildings
  building_power();
  building_shield();
  building_radar();
  building_hangar_l();
  building_fuel();
  building_ltur();
  building_repair();
  
  //mech data
  data_mech_mtk();
  data_mech_otl();
  data_mech_MNT();
  
  //vehicles
  data_TNK_hmn();
  
  //wep data
  data_wep_latc();
  data_wep_emp();
  data_wep_mis();
  data_wep_las();
  data_wep_mlgd();
  data_wep_marh();
  data_wep_qrfl();
  data_wep_esr();
  data_wep_pac();
  data_wep_rplas();
  data_wep_sfga();
  data_wep_flak();
  data_wep_ion();
  data_wep_swrm();
  //data_wep_abt();
  
  //equip data
  data_eqp_atgm_ini();
  data_eqp_enbat_ini();
  data_eqp_recap_ini();
  data_eqp_lsar_ini();
  data_eqp_hsem_ini();
  data_eqp_scap_ini();
};

entity(float id, float dat_type) m_findData={
  local entity data_chain;
  data_chain = findchain(classname, "data");
  while(data_chain){
    local float idx;
    idx = data_chain.data_idx;
    if(data_chain.data_type == dat_type){
      if(id == idx){
        return data_chain;
      }
    }
    data_chain = data_chain.chain;
  }
  return data_chain;
};

entity(float id) m_findMechData={
  local entity data_chain;
  data_chain = findchain(classname, "data_mech");
  while(data_chain){
    if(data_chain.data_type == DATA_MECH){
      local float idx;
      idx = data_chain.data_idx;
      if(id == idx){
        return data_chain;
      }
    }
    data_chain = data_chain.chain;
  }
  return data_chain;
};
