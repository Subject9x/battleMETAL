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
  precache_model ("q3mdl/mdl_tmk_cpit.md3");
  precache_model ("q3mdl/mechs/col/mdl_col_cpit.md3");

  //cockpit images  
  precache_pic("gfx/hud/otl/otl_am.png", 0);
  precache_pic("gfx/hud/otl/otl_hd.png", 0);
  precache_pic("gfx/hud/otl/otl_en.png", 0);
  precache_pic("gfx/hud/otl/otl_rd.png", 0);
  precache_pic("gfx/hud/otl/otl_sl.png", 0);
  precache_pic("gfx/hud/otl/otl_sp.png", 0);
  precache_pic("gfx/hud/otl/otl_wp.png", 0);
  
  //cockpit voice
  precache_sound("sound/comp/online.ogg");
  precache_sound("sound/comp/en_low.ogg");
  
  //buildings
  building_power();
  building_shield();
  building_radar();
  
  //mech data
  data_mech_mtk();
  data_mech_otl();
  
  //wep data
  data_wep_latc();
  data_wep_emp();
  data_wep_mis();
  data_wep_las();
  
  //hud data
  otl_hud_ini();
  tmk_hud_ini();
  
};

entity(float id, float dat_type) m_findData={
  local entity found, data_chain;
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