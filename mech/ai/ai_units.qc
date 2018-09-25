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
  self.ai_rank = AI_RANK_ROK;
  ai_noncom_tank();
};

void() unit_hs_truck_hab={
  self.nextVecChoice = 2;
  self.ai_rank = AI_RANK_ROK;
  ai_noncom_tank();
};

void() unit_hs_truck_const={
  self.nextVecChoice = 3;
  self.ai_rank = AI_RANK_ROK;
  ai_noncom_tank();

};

void() unit_hs_dozer={
  self.nextVecChoice = 4;
  self.ai_rank = AI_RANK_ROK;
  ai_noncom_tank();
};

void() unit_hs_loader={
  self.nextVecChoice = 5;
  self.ai_rank = AI_RANK_ROK;
  ai_noncom_tank();
};

void() unit_hs_excavat={
  self.nextVecChoice = 6;
  self.ai_rank = AI_RANK_ROK;
  ai_noncom_tank();
};

void() unit_hs_tank_l={
  self.nextVecChoice = 7;
  ai_tank_skirmish();
};

void() unit_hs_tank_h={
  self.nextVecChoice = 8;
};

void() unit_hs_tnkdest_l={
  self.nextVecChoice = 9;
  ai_vec_dest();
};

void() unit_hs_tnkdest_h={
  self.nextVecChoice = 10;
};

void() unit_hs_scout={
  self.nextVecChoice = 11;
};

void() unit_hs_mech_sk={
  ai_mech_skirmish();
};

void() unit_hs_mech_snipe={
  
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