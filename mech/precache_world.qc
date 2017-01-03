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
};

void() mh_precache_models={
    //mech model
  precache_model ("q3mdl/testball.md3");
  //nu outlaw
  precache_model ("q3mdl/mechs/notl/mdl_notl_cpt.md3");
  precache_model ("q3mdl/mechs/notl/mdl_notl_t_cent.md3");
  precache_model ("q3mdl/mechs/notl/mdl_notl_t_left.md3");  
  precache_model ("q3mdl/mechs/notl/mdl_notl_legs.md3");
  precache_model ("q3mdl/mechs/notl/mdl_notl_l_arm.md3");
  precache_model ("q3mdl/mechs/notl/mdl_notl_r_arm.md3");
  
  /*precache_model ("q3mdl/mechs/champ/mdl_chp_legs.md3");
  precache_model ("q3mdl/mechs/champ/mdl_chp_t_cent.md3");
  precache_model ("q3mdl/mechs/champ/mdl_chp_t_left.md3");
  precache_model ("q3mdl/mechs/champ/mdl_chp_a_l.md3");
  precache_model ("q3mdl/mechs/champ/mdl_chp_a_r.md3");
  precache_model ("q3mdl/mechs/champ/mdl_chp_t_right.md3");
  */
  precache_model ("q3mdl/mechs/ntmk/mdl_ntmk_legs.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_ntmk_t_cent.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_ntmk_arm_l.md3");
  precache_model ("q3mdl/mechs/ntmk/mdl_ntmk_arm_r.md3");

  precache_model ("q3mdl/mechs/col/mdl_col_legs.md3");
  precache_model ("q3mdl/mechs/col/mdl_col_t_cent.md3");
  precache_model ("q3mdl/mechs/col/mdl_col_t_side.md3");
  
  //mech v_models
  precache_model ("q3mdl/otl_cpit.md3");
  precache_model ("q3mdl/mdl_tmk_cpit.md3");
  precache_model ("q3mdl/mechs/col/mdl_col_cpit.md3");
   
  //weapon models
  precache_model ("q3mdl/weapons/w_atc.md3");
  precache_model ("q3mdl/weapons/w_emp.md3");
  precache_model ("q3mdl/weapons/w_laser.md3");
  precache_model ("q3mdl/weapons/w_mis.md3");
  
  //weapon projectiles
  precache_model ("q3mdl/proj_emp.md3");
  precache_model ("q3mdl/proj_mis.md3");
  precache_model ("progs/casing.mdl");
  
  precache_file ("maps/t_train0.bsp");
};
