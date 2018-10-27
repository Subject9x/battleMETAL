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
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_hab={
  self.nextVecChoice = 2;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_const={
  self.nextVecChoice = 3;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_dozer={
  self.nextVecChoice = 4;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_loader={
  self.nextVecChoice = 5;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_excavat={
  self.nextVecChoice = 6;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_tank_l={
  self.nextVecChoice = 7;
  self.i_faction = 2;
  self.flags = self.flags | FL_TURRET;
  ai_unit_setup( ai_tank_skirmish );
};

void() unit_hs_tank_h={
  self.nextVecChoice = 8;
  self.i_faction = 2;
};

void() unit_hs_tnkdest_l={
  self.nextVecChoice = 9;
  self.i_faction = 2;
  ai_unit_setup( ai_vec_dest );
};

void() unit_hs_tnkdest_h={
  self.nextVecChoice = 10;
  self.i_faction = 2;
};

void() unit_hs_scout={
  self.nextVecChoice = 11;
  self.i_faction = 2;
  ai_unit_setup( ai_gev );
};

void() unit_hs_mech_sk={
  self.flags = self.flags | FL_TURRET;  //enforced for a mech
  self.i_faction = 2;
  ai_unit_setup( ai_mech_skirmish );
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
void() unit_psc_vtol_l={
  self.nextVecChoice = ID_VEC_PSC_VTOL_L;
  self.i_faction = 4;
  ai_unit_setup( ai_vtol );
};

float( void() ai_unit_ini ) ai_create_unit={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
    objerror ("ai_unit - outside of game mode");
    remove(self);
    return FALSE;
  }
  
  ai_unit_ini_var();
  ai_unit_ini( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  trigger_event( self, trigOnSpawn); //event interface
  return TRUE;
};