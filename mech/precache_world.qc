/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: precache the resources
called at world.qc
*/

void() mh_precache_sound={
  //sfx
  precache_sound ("sound/weapons/mis_fire.ogg");
  precache_sound ("sound/weapons/atc_fire.ogg");
  precache_sound ("sound/weapons/qrfl_fire.ogg");
  precache_sound ("sound/weapons/emp_fire.ogg");
  precache_sound ("sound/weapons/laser_fire.ogg");
  precache_sound ("sound/weapons/pac_fire.ogg");
  precache_sound ("sound/weapons/esr_fire.ogg");
  
  precache_sound ("sound/mech_stomp.ogg");
  
  precache_sound ("sound/fx_boom.ogg");
  precache_sound ("sound/fx_shieldhit.ogg");
  precache_sound ("sound/fx_armorhit.ogg");
};

void() mh_precache_models={
  
  //terrains
  precache_model("models/terrain/t1m3_exp2.obj");
  
  //buildings
  precache_model("q3mdl/base_small.obj");
  precache_model("q3mdl/base_med.obj");
  precache_model("q3mdl/base_large.obj");
  
  precache_model("q3mdl/buildings/mdl_bld_h_hangar_l.md3");
  precache_model("q3mdl/buildings/repair_bay/mdl_repair_bay.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_power.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_radar.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_shield.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_fuel.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_ltur.md3");
  precache_model("q3mdl/buildings/mdl_bld_h_ltur_base.md3");
  
  //mech model
  precache_model ("q3mdl/testball.md3");
  //balaket
  precache_model ("q3mdl/mechs/notl/mdl_blk_cpt.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_cpt.obj");
  precache_model ("q3mdl/mechs/notl/mdl_blk_t_cent.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_t_left.md3");  
  precache_model ("q3mdl/mechs/notl/mdl_blk_t_right.md3");  
  precache_model ("q3mdl/mechs/notl/mdl_blk_legs.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_l_arm.md3");
  precache_model ("q3mdl/mechs/notl/mdl_blk_r_arm.md3");

  //matok
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_legs.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_t_cent.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_t_left.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_t_right.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_l_arm.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_r_arm.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_mtk_cpt.md3");
  //koblen
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_legs.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_t_cent.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_t_left.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_t_right.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_l_arm.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_r_arm.md3");
  precache_model ("q3mdl/mechs/mnt/mdl_mnt_cpt.md3");
 
  //test tank
  
  //Foslage Medium Tank
  precache_model ("q3mdl/vecs/foslager/mdl_foslager_chas.md3");
  precache_model ("q3mdl/vecs/foslager/mdl_foslager_tur.md3"); 
  
  //Onnek Tank Destroyer
  precache_model ("q3mdl/vecs/onnek/mdl_onnek_chas.md3");
  
  //Dunerunner GEV
  precache_model ("q3mdl/vecs/dunerunner/mdl_dunrun_chas.md3");
  precache_model ("q3mdl/vecs/dunerunner/mdl_dunrun_tur.md3"); 
  
  precache_model ("q3mdl/vecs/mdl_tank_chas.md3");
  precache_model ("q3mdl/vecs/mdl_tank_tur.md3");
  
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
  precache_model ("q3mdl/weapons/w_ion.md3");
  precache_model ("q3mdl/weapons/w_flk.md3");
  precache_model ("q3mdl/weapons/w_swrm.md3");
  
  precache_model ("q3mdl/weapons/e_atgm.md3");
  precache_model ("q3mdl/weapons/e_enbat.md3");
  precache_model ("q3mdl/weapons/e_hsem.md3");
  precache_model ("q3mdl/weapons/e_recap.md3");
  precache_model ("q3mdl/weapons/e_scap.md3");
  precache_model ("q3mdl/weapons/e_lsar.md3");
  
  //weapon projectiles
  precache_model ("q3mdl/proj_emp.md3");
  precache_model ("q3mdl/proj_mis.md3");
  
  precache_model ("q3mdl/proj/mdl_proj_swrm.md3");
  precache_model ("q3mdl/proj/mdl_proj_lgm.md3");
  precache_model ("q3mdl/proj/mdl_proj_mis.md3");
  precache_model ("q3mdl/proj/mdl_proj_marh.md3");
  precache_model ("q3mdl/proj/mdl_proj_sfga.md3");
  precache_model ("q3mdl/proj/mdl_proj_rpc.md3");
  precache_model ("q3mdl/proj/mdl_proj_qrfl.md3");
  precache_model ("q3mdl/proj/mdl_proj_emp.md3");
  precache_model ("q3mdl/proj/mdl_proj_ion.md3");
  
  precache_model ("progs/casing.mdl");
  precache_model ("q3mdl/fx_shield.md3");
  precache_model ("progs/plasmashot.spr32");
  precache_model ("progs/muzzleflash.spr32");
  precache_model ("q3mdl/muzzle_laser.spr32");
  precache_model ("progs/s_explod.spr");
  
  //maps
  precache_file ("maps/t1m1.bsp");
  precache_file ("maps/t1m2.bsp");
  precache_file ("maps/start.bsp");
  precache_file ("maps/c1m1.bsp");
  precache_file ("maps/t1m3.bsp");
};
