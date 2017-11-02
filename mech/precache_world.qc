/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: precache the resources
called at world.qc
*/
void() mh_precache_world={ 
};

void() mh_precache_sound={
  //sfx
  precache_sound ("sound/cdtracks/rush.ogg");
  precache_sound ("sound/weapons/laser_3.ogg");
  precache_sound ("weapons/rocket1i.wav");
  precache_sound ("weapons/sgun1.wav");
  precache_sound ("sound/ac5.ogg");
  precache_sound ("sound/llaser.ogg");
  precache_sound ("sound/laser_test.ogg");
  precache_sound ("sound/gauss.ogg");
  
  precache_sound ("sound/mech_stomp.ogg");
  
  //voice
  precache_sound ("sound/comp/online.ogg");
};

void() mh_precache_models={

  precache_model("progs/v_dpshot.mdl");
  
  //buildings
  precache_model("q3mdl/buildings/mdl_bld_h_hangar_l.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_power.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_radar.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_shield.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_fuel.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_ltur.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_ltur_base.md3");
  
  //mech model
  precache_model ("q3mdl/testball.md3");
  //nu outlaw
  precache_model ("q3mdl/mechs/notl/mdl_blk_cpt.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_t_cent.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_t_left.md3");  
  precache_model ("q3mdl/mechs/notl/mdl_blk_t_right.md3");  
  precache_model ("q3mdl/mechs/notl/mdl_blk_legs.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_l_arm.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_r_arm.md3");

  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_legs.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_t_cent.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_t_left.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_t_right.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_l_arm.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_r_arm.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_cpt.md3");
  
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_legs.md3");
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_t_cent.md3");
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_t_left.md3");
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_t_right.md3");
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_l_arm.md3");
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_r_arm.md3");
  precache_model ("q3mdl/mechs/hvd/mdl_hvd_cpt.md3");
   
  //weapon models
  precache_model ("q3mdl/weapons/w_arh.md3");
  precache_model ("q3mdl/weapons/w_atc.md3");
  precache_model ("q3mdl/weapons/w_emp.md3");
  precache_model ("q3mdl/weapons/w_esr.md3");
  precache_model ("q3mdl/weapons/w_laser.md3");
  precache_model ("q3mdl/weapons/w_lgm.md3");
  precache_model ("q3mdl/weapons/w_mis.md3");
  precache_model ("q3mdl/weapons/w_pac.md3");
  precache_model ("q3mdl/weapons/w_qrf.md3");
  precache_model ("q3mdl/weapons/w_rpc.md3");
  precache_model ("q3mdl/weapons/w_sfga.md3");
  
  //weapon projectiles
  precache_model ("q3mdl/proj_emp.md3");
  precache_model ("q3mdl/proj_mis.md3");
  precache_model ("progs/casing.mdl");
  precache_model ("q3mdl/fx_shield.md3");
  precache_model ("progs/plasmashot.spr32");
  precache_model ("progs/muzzleflash.spr32");
  
  
  precache_file ("maps/t_train0.bsp");
};
