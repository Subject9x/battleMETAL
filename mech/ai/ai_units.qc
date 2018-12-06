/*
battleMETAL 
Author: Peter Roohr
Date: 8/9/2018
Overview: AI Unit impl
  used by map and spawn functions
  new unit? register its spawn functions here.
*/

/*
==============================
  FACTION - NONE - WORLD
==============================
*/

/*
==============================
  FACTION - HUMAN - SURVIVOR
==============================
*/
void() unit_hs_truck_cargo={
  self.nextVecChoice = 1;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_hab={
  self.nextVecChoice = 2;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_const={
  self.nextVecChoice = 3;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_dozer={
  self.nextVecChoice = 4;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_loader={
  self.nextVecChoice = 5;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_excavat={
  self.nextVecChoice = 6;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_tank_l={
  self.nextVecChoice = 7;
  self.i_faction = 2;
  self.flags = self.flags | FL_TURRET;
  self.spreadDefault = ACCURACY_SKIRMISH;
  ai_unit_setup( ai_tank_skirmish );
};

void() unit_hs_tank_h={
  self.nextVecChoice = 8;
  self.i_faction = 2;
};

void() unit_hs_tnkdest_l={
  self.nextVecChoice = 9;
  self.i_faction = 2;
  self.spreadDefault = ACCURACY_SNIPER;
  ai_unit_setup( ai_vec_dest );
};

void() unit_hs_tnkdest_h={
  self.nextVecChoice = 10;
  self.i_faction = 2;
};

void() unit_hs_scout={
  self.flags = self.flags | FL_MONSTER;  //enforced for a mech
  self.nextVecChoice = 11;
  self.i_faction = 2;
  self.spreadDefault = ACCURACY_LOWTECH;
  ai_unit_setup( ai_gev );
};

void() unit_hs_mech_sk={
  self.flags = self.flags | FL_TURRET | FL_MONSTER;  //enforced for a mech
  self.i_faction = 2;
  self.mskin = 2;
  self.spreadDefault = ACCURACY_SKIRMISH;
  ai_unit_setup( ai_mech_skirmish );
};

void() unit_hs_mech_sniper={
  self.flags = self.flags | FL_TURRET | FL_MONSTER;  //enforced for a mech
  self.i_faction = 2;
  self.mskin = 2;
  self.spreadDefault = ACCURACY_SNIPER;
  ai_unit_setup( ai_mech_sniper );
};

/*
==============================
  FACTION - HUMAN - RAIDERS
==============================
*/

void() unit_hr_tank_l={};
void() unit_hr_tank_m={};
void() unit_hr_tank_h={};
void() unit_hr_tank_mis={};
void() unit_hr_tankdest={};

void() unit_hr_gev_l={};
void() unit_hr_gev_m={};

void() unit_hr_arty_m={};
void() unit_hr_arty_c={};

/*
==============================
  FACTION - SYNTH - WARLORDS
==============================
*/


/*
==============================
  FACTION - PSC
==============================
*/
void() unit_psc_vtol_l={
  self.nextVecChoice = ID_VEC_PSC_VTOL_L;
  self.i_faction = 4;
  ai_unit_setup( ai_vtol );
};