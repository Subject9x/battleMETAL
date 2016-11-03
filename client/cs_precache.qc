/*
mech Mod
Author: Subject9x
Date: 10/31/2016
Overview: header for mech hud functions
*/

void() cs_precache={

  //cockpit models
  precache_model ("q3mdl/mechs/notl/mdl_notl_cpt.md3");
  precache_model ("q3mdl/mdl_tmk_cpit.md3");
  precache_model ("q3mdl/mechs/col/mdl_col_cpit.md3");

  //hud data
  otl_hud_ini();
};

entity(float id) m_findData={
  local entity found;
  found = findfloat(world, data_idx, id);
  return found;
};