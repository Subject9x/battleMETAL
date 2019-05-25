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
  self.faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  //ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_hab={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 2;
  self.faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  //ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_truck_const={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 3;
  self.faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  //ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_dozer={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 4;
  self.faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  //ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_loader={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 5;
  self.faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  //ai_unit_setup( ai_noncom_tank );
};

void() unit_hs_excavat={
  if( !ai_can_spawn() ){
    remove(self);
    objerror ("ai_unit - outside of game mode");
    return;
  }

  self.nextVecChoice = 6;
  self.faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  //ai_unit_setup( ai_noncom_tank );
};

/*
  UNIT: DUNERUNNER
  TYPE: GEV
  SIZE: SMALL
  --------------------------------
*/
void() unit_dunerunner_h={
  
  self.nextVecChoice = 11;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( 12, ID_WEP_LATC, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
      
  if( ai_unit_setup( ai_gev ) ){
    ai_gev();
  }
};

void() unit_dunerunner_m={
  
  self.nextVecChoice = 11;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_QRF, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LATC, -1, -1, -1, -1, -1, -1, -1);
      break;
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

  self.nextVecChoice = 7;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_MLGD, ID_WEP_LAS, ID_WEP_LATC, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_ION, ID_WEP_LAS, ID_WEP_FLAK, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( ID_WEP_MIS, ID_WEP_LAS, ID_WEP_LATC, -1, -1, -1, -1, -1, -1);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};

void() unit_foslager_m={

  self.nextVecChoice = 7;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_PAC, ID_WEP_LATC, ID_WEP_FLAK, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( ID_WEP_ION, ID_WEP_RPC, ID_WEP_FLAK, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_ESR, ID_WEP_LATC, ID_WEP_LAS, -1, -1, -1, -1, -1, -1);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};


/*
  UNIT: TROWEL
  TYPE: TANK
  SIZE: HEAVY
  --------------------------------
*/
void() unit_trowel_m={
  
  self.nextVecChoice = 8;
  self.faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_ESR, ID_WEP_SFGA, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( ID_WEP_PAC, ID_WEP_SFGA, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_ESR, ID_WEP_ESR, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};

void() unit_trowel_h={

  self.nextVecChoice = 8;
  self.faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_RPC, ID_WEP_ION, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( ID_WEP_SFGA, ID_WEP_EMP, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_MIS, ID_WEP_ION, -1, -1, -1, -1, -1, -1, -1);
      break;
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

  self.nextVecChoice = 9;
  self.faction = FACTION_SURVEST;

  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_ION, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_EMP, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( ID_WEP_QRF, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( ID_WEP_LAS, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};

void() unit_onnek_m={

  self.nextVecChoice = 9;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( ID_WEP_EMP, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( ID_WEP_SFGA, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_PAC, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};

/*
  UNIT: SORCERER
  TYPE: TANK MISSILE
  SIZE: MEDIUM
  --------------------------------
*/
void() unit_sorcerer_h={

  self.nextVecChoice = 10;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( ID_WEP_MIS, ID_WEP_MLGD, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_MLGD, ID_WEP_MLGD, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( ID_WEP_MIS, ID_WEP_MIS, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};


void() unit_sorcerer_m={

  
  self.nextVecChoice = 10;
  self.faction = FACTION_MILITAR;
   
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( ID_WEP_MLGD, ID_WEP_MLGD, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( ID_WEP_SWRM, ID_WEP_SWRM, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( ID_WEP_MARH, ID_WEP_MARH, -1, -1, -1, -1, -1, -1, -1);
      break;
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

  
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = 1;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

void() unit_balaket_sniper_h={
  self.faction = FACTION_SURVEST;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LATC, ID_WEP_FLAK, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_MLGD, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_LAS, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  unit_balaket_sniper();
};

void() unit_balaket_sniper_m={
  self.faction = FACTION_MILITAR;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_MARH, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_QRF, ID_WEP_PAC, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_QRF, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  unit_balaket_sniper();
};


//        BRAWLER VARIANTS
void() unit_balaket_brawl={

  
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = 1;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

void() unit_balaket_brawl_h={
  self.faction = FACTION_SURVEST;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_MIS, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_ESR, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons( ID_WEP_FLAK, ID_WEP_FLAK, ID_WEP_ION, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  unit_balaket_brawl();
};

void() unit_balaket_brawl_m={
  self.faction = FACTION_MILITAR;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_FLAK, ID_WEP_FLAK, ID_WEP_ESR, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_PAC, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_RPC, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  
  unit_balaket_brawl();
};

void() unit_balaket_brawl_p={
  self.faction = FACTION_PSC;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_FLAK, ID_WEP_FLAK, ID_WEP_ESR, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_PAC, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_RPC, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  
  unit_balaket_brawl();
};

/*
  UNIT: MATOK
  TYPE: METAL
  SIZE: MEDIUM
  --------------------------------
*/
//        BRAWLER VARIANTS
void() unit_matok_brawl={

  
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = 2;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

void() unit_matok_sniper={

  
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = 2;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

void() unit_matok_sniper_h={
  self.faction = FACTION_SURVEST;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_FLAK, ID_WEP_FLAK, ID_WEP_ION, ID_WEP_LAS, ID_WEP_QRF, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_LAS, ID_WEP_LAS, ID_WEP_LAS,  -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_FLAK, ID_WEP_FLAK, ID_WEP_ION, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  unit_matok_sniper();
};

void() unit_matok_sniper_m={
  self.faction = FACTION_MILITAR;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_QRF, ID_WEP_FLAK, ID_WEP_MARH, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_QRF, ID_WEP_LATC, ID_WEP_PAC, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_QRF, ID_WEP_FLAK, ID_WEP_ION, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  unit_matok_sniper();
};

void() unit_matok_sniper_p={
  self.faction = FACTION_PSC;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_QRF, ID_WEP_FLAK, ID_WEP_MARH, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_QRF, ID_WEP_LATC, ID_WEP_PAC, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_QRF, ID_WEP_FLAK, ID_WEP_ION, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  unit_matok_sniper();
};

void() unit_matok_brawl_h={ 
  self.faction = FACTION_SURVEST; 

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_MLGD, ID_WEP_MIS, ID_WEP_SFGA, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LAS, ID_WEP_ION, ID_WEP_LAS, ID_WEP_RPC, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_FLAK, ID_WEP_LAS, ID_WEP_MIS, ID_WEP_ION, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }

  unit_matok_brawl();
};
void() unit_matok_brawl_m={  
  self.faction = FACTION_MILITAR;

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(  ID_WEP_QRF, ID_WEP_FLAK, ID_WEP_ESR, ID_WEP_RPC, ID_WEP_MLGD, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_QRF, ID_WEP_LAS, ID_WEP_RPC, ID_WEP_RPC, ID_WEP_EMP, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_LATC, ID_WEP_LATC, ID_WEP_ESR, ID_WEP_ION, ID_WEP_MIS, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
  }
  unit_matok_brawl();
};



/*
  UNIT: MONITOR
  TYPE: METAL
  SIZE: HEAVY
  --------------------------------
*/
//        BRAWLER VARIANTS
void() unit_monitor_brawl={

  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = 3;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

void() unit_monitor_sniper={

  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = 3;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

void() unit_monitor_brawl_h={
  self.faction = FACTION_SURVEST;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(ID_WEP_LATC,ID_WEP_FLAK,ID_WEP_LATC,ID_WEP_FLAK,ID_WEP_ESR,ID_WEP_EMP,ID_WEP_MIS,ID_WEP_MIS,ID_WEP_MIS);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      ai_ini_weapons(ID_WEP_LAS,ID_WEP_LATC,ID_WEP_LAS,ID_WEP_LATC,ID_WEP_SFGA,ID_WEP_SFGA,ID_WEP_MIS,ID_WEP_MIS,ID_WEP_MIS);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons(ID_WEP_LATC,ID_WEP_FLAK,ID_WEP_LATC,ID_WEP_FLAK,ID_WEP_LAS,ID_WEP_LAS,ID_WEP_MIS,ID_WEP_MARH,ID_WEP_MIS);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  unit_monitor_brawl();
};

void() unit_monitor_brawl_m={
  self.faction = FACTION_MILITAR;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LATC, ID_WEP_LAS, ID_WEP_LATC, ID_WEP_EMP, ID_WEP_ESR, ID_WEP_MLGD, ID_WEP_MLGD, ID_WEP_MLGD);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS,ID_WEP_LAS,ID_WEP_LAS,ID_WEP_LAS, ID_WEP_ESR, ID_WEP_ESR, ID_EQP_ENBAT, ID_EQP_ENBAT, ID_EQP_RECAP);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_FLAK,ID_WEP_FLAK,ID_WEP_FLAK,ID_WEP_FLAK,ID_WEP_RPC, ID_WEP_EMP, ID_WEP_MIS, ID_WEP_MARH, ID_WEP_MARH);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  unit_monitor_brawl();
};

void() unit_monitor_brawl_p={
  self.faction = FACTION_PSC;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons( ID_WEP_LAS, ID_WEP_LATC, ID_WEP_LAS, ID_WEP_LATC, ID_WEP_EMP, ID_WEP_ESR, ID_WEP_MLGD, ID_WEP_MLGD, ID_WEP_MLGD);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_LAS,ID_WEP_LAS,ID_WEP_LAS,ID_WEP_LAS, ID_WEP_ESR, ID_WEP_ESR, ID_EQP_ENBAT, ID_EQP_ENBAT, ID_EQP_RECAP);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( ID_WEP_FLAK,ID_WEP_FLAK,ID_WEP_FLAK,ID_WEP_FLAK,ID_WEP_RPC, ID_WEP_EMP, ID_WEP_MIS, ID_WEP_MARH, ID_WEP_MARH);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  unit_monitor_brawl();
};

void() unit_monitor_sniper_m={  
  self.faction = FACTION_MILITAR;
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(ID_WEP_LATC,ID_WEP_LATC,ID_WEP_LATC,ID_WEP_LATC,ID_WEP_PAC,ID_WEP_PAC,ID_EQP_ATGM,ID_EQP_ENBAT,ID_EQP_HSEM);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons(ID_WEP_LAS,ID_WEP_LAS,ID_WEP_LAS,ID_WEP_LAS,ID_WEP_MLGD,ID_WEP_MLGD,ID_EQP_ENBAT,ID_EQP_ATGM,ID_EQP_HSEM);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons(ID_WEP_LAS,ID_WEP_LATC,ID_WEP_LAS,ID_WEP_LATC,ID_WEP_PAC,ID_WEP_QRF,ID_WEP_MARH,ID_EQP_ENBAT,ID_EQP_ATGM);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  unit_monitor_sniper();
};



void() building_turret_light={
  self.nextVecChoice = 1; //DEBUG
  self.flags = FL_TURRET;  //enforced for a mech
  self.skin = self.faction;
  
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(ID_WEP_LAS, ID_WEP_LAS, -1, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(ID_WEP_FLAK, ID_WEP_LAS, -1, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(ID_WEP_LAS, ID_WEP_QRF, -1, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(ID_WEP_LATC, ID_WEP_LATC, -1, -1, -1, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_turret ) ){
    ai_turret();
  }
};

void() unit_psc_vtol_l={
  self.nextVecChoice = ID_VEC_PSC_VTOL_L;
  self.faction = 4;
  //ai_unit_setup( ai_vtol );
};