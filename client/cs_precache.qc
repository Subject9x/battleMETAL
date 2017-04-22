/*
mech Mod
Author: Subject9x
Date: 10/31/2016
Overview: header for mech hud functions
*/

void() cs_removeEnt={
  remove(self);
};

void() cs_precache={

  //cockpit models
  precache_model ("q3mdl/mechs/notl/mdl_notl_cpt.md3");
  precache_model ("q3mdl/mechs/mtmk/mdl_tmk_cpit.md3");
  precache_model ("q3mdl/mechs/col/mdl_col_cpit.md3");

  //cockpit images 
  HUT_RET_PIP_HRZ = precache_pic("gfx/hud/ret_pip_hrz.png", 0);
  HUT_RET_PIP_VRT = precache_pic("gfx/hud/ret_pip_vrt.png", 0);
  HUT_RET_LOK = precache_pic("gfx/hud/ret_lock.png", 0);
  
  
  precache_pic("gfx/hud/otl/otl_am.png", 0);
  precache_pic("gfx/hud/otl/otl_hd.png", 0);
  precache_pic("gfx/hud/otl/otl_en.png", 0);
  precache_pic("gfx/hud/otl/otl_en_cvr.png", 0);
  precache_pic("gfx/hud/otl/otl_rd.png", 0);
  precache_pic("gfx/hud/otl/otl_rd_cvr.png", 0);
  precache_pic("gfx/hud/otl/otl_sl.png", 0);
  precache_pic("gfx/hud/otl/otl_sp.png", 0);
  precache_pic("gfx/hud/otl/otl_wp.png", 0);
  
  precache_pic("gfx/hud/navbar.png", 0);
  
  //hangar splash images
  precache_pic("gfx/ui/hgr_otl.png", 0);
  precache_pic("gfx/ui/hgr_mtk.png", 0);
  precache_pic("gfx/ui/hgr_hvd.png", 0);
  
  //cockpit voice
  SND_HUD_VFX_ONLINE = precache_sound2("sound/comp/online.ogg");
  SND_HUD_VFX_ENELOW = precache_sound2("sound/comp/en_low.ogg");
  SND_HUD_VFX_SHDLOW = precache_sound2("sound/comp/sh_low.ogg");
  SND_HUD_VFX_RDRACTIVE = precache_sound2("sound/comp/rdr_active.ogg");
  SND_HUD_VFX_RDRPASSIVE = precache_sound2("sound/comp/rdr_passive.ogg");
  SND_HUD_VFX_TARGKILL = precache_sound2("sound/comp/trg_kill.ogg");
  
  //ui sounds
  precache_sound("sound/misc/menu1.wav");
  precache_sound("sound/misc/menu2.wav");
  precache_sound("sound/misc/menu3.wav");
  
  //cursor
  precache_pic("gfx/ui/ui_cursor.png",0);
  UI_DEF_BOX_512 = precache_pic("gfx/ui/box_512.png",0);
  UI_DEF_BOX_256 = precache_pic("gfx/ui/box_256.png",0);
  UI_DEF_BOX_256_TALL = precache_pic("gfx/ui/box_256_tall.png",0);
  UI_DEF_BOX_64 = precache_pic("gfx/ui/box_64.png",0);
  precache_pic("gfx/hud/target_box.png",0);
  UI_DEF_NAVPOINT = precache_pic("gfx/ui/hud_navpoint.png",0);
  //buildings
  building_power();
  building_shield();
  building_radar();
  
  //mech data
  data_mech_mtk();
  data_mech_otl();
  data_mech_hvd();
  
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
  
  //hud data
  otl_hud_ini();
  mtk_hud_ini();
  hvd_hud_ini();
  
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