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
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 1;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_hab={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 2;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_const={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 3;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_dozer={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 4;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_loader={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 5;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_excavat={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 6;
  self.i_faction = 2;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_tank_l={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 7;
  self.i_faction = 2;
  self.flags = self.flags | FL_TURRET;
  self.spreadDefault = ACCURACY_SKIRMISH;
  ai_unit_setup( ai_tank_skirmish );
};

void() unit_hs_tank_h={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 8;
  self.i_faction = 2;
};

void() unit_hs_tnkdest_l={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 9;
  self.i_faction = 2;
  self.spreadDefault = ACCURACY_SNIPER;
  ai_unit_setup( ai_vec_dest );
};

void() unit_hs_tnkdest_h={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 10;
  self.i_faction = 2;
};

void() unit_hs_scout={

  self.flags = 0;
  self.nextVecChoice = 11;
  self.i_faction = 2;
  self.spreadDefault = ACCURACY_LOWTECH;
  
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  if( ai_unit_setup( ai_gev ) ){
    ai_gev();
  }
};
/*
  UNIT: DUNERUNNER
  TYPE: GEV
  SIZE: SMALL
  --------------------------------
*/
void() unit_dunerunner_h={
  
  self.style = TYPE_BRAWL;
  self.nextVecChoice = 11;
  self.i_faction = 2;
  self.flags = self.flags | FL_TURRET;
  self.spreadDefault = ACCURACY_LOWTECH;
  
    if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_gev ) ){
    ai_gev();
  }
  
};

/*
  UNIT: FOSLAGER
  TYPE: TANK
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_foslager_h={

  self.style = TYPE_BRAWL;
  self.nextVecChoice = 7;
  self.i_faction = 2;
  self.flags = self.flags | FL_TURRET;
  self.spreadDefault = ACCURACY_SKIRMISH;
  
    if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};



/*
  UNIT: ONNEK
  TYPE: TANK DESTROYER
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_onnek_h={

  self.style = TYPE_BRAWL;
  self.nextVecChoice = 9;
  self.i_faction = 2;
  self.flags = self.flags;
  self.spreadDefault = ACCURACY_SNIPER;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};

/*
  UNIT: BALAKET
  TYPE: METAL
  SIZE: LIGHT
  --------------------------------
*/
//        SNIPER VARIANTS
void() unit_balaket_sniper={

  self.style = TYPE_SNIPER;

  self.flags = FL_TURRET;  //enforced for a mech
  
  if( !self.i_faction ){
    self.i_faction = 2;
  }
  self.mskin = self.i_faction;
  self.spreadDefault = ACCURACY_SNIPER;
  self.nextVecChoice = 1;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

//        BRAWLER VARIANTS
void() unit_balaket_brawl={

  self.style = TYPE_BRAWL;

  self.flags = FL_TURRET;  //enforced for a mech
  
  if( !self.i_faction ){
    self.i_faction = 2;
  }
  self.mskin = self.i_faction;
  self.spreadDefault = ACCURACY_SKIRMISH;
  self.nextVecChoice = 1;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

/*
  UNIT: MATOK
  TYPE: METAL
  SIZE: MEDIUM
  --------------------------------
*/
//        BRAWLER VARIANTS
void() unit_matok_brawl={

  self.style = TYPE_BRAWL;

  self.flags = FL_TURRET;  //enforced for a mech
  
  if( !self.i_faction ){
    self.i_faction = 2;
  }
  self.mskin = self.i_faction;
  self.spreadDefault = ACCURACY_MARKSMAN;
  self.nextVecChoice = 2;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

/*
  UNIT: MONITOR
  TYPE: METAL
  SIZE: MEDIUM
  --------------------------------
*/
//        BRAWLER VARIANTS
void() unit_monitor_brawl={

  self.style = TYPE_BRAWL;

  self.flags = FL_TURRET;  //enforced for a mech
  
  if( !self.i_faction ){
    self.i_faction = 2;
  }
  self.mskin = self.i_faction;
  self.spreadDefault = ACCURACY_LOWTECH;
  self.nextVecChoice = 3;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};


void() building_turret_light={
  self.nextVecChoice = 1; //DEBUG
  self.next_wepn1 = 1;
  self.next_wepn2 = 1;
  self.flags = FL_TURRET;  //enforced for a mech
  self.i_faction = 1;
  self.mskin = 1;
  self.spreadDefault = ACCURACY_LOWTECH;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_turret ) ){
    ai_turret();
  }
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