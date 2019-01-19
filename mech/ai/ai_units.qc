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
  self.i_faction = FACTION_SURVEST;
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
  self.i_faction = FACTION_SURVEST;
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
  self.i_faction = FACTION_SURVEST;
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
  self.i_faction = FACTION_SURVEST;
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
  self.i_faction = FACTION_SURVEST;
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
  self.i_faction = FACTION_SURVEST;
  self.ai_rank = AI_RANK_ROK;
  self.spreadDefault = '0 0 0';
  ai_unit_setup( ai_noncom_tank );
};

/*
  UNIT: DUNERUNNER
  TYPE: GEV
  SIZE: SMALL
  --------------------------------
*/
void() unit_dunerunner_h={
  
  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_dunerunner;
  self.i_faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      //FLAK | ATC
      ai_ini_weapons( 12, 1, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //LATC | LAS
      ai_ini_weapons( 3, 3, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      //ATC | ATC
      ai_ini_weapons( 1, 1, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
      
  if( ai_unit_setup( ai_gev ) ){
    ai_gev();
  }
};

void() unit_dunerunner_m={
  
  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_dunerunner;
  self.i_faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //LAS | LAS
      ai_ini_weapons( 3, 3, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //LAS | QRFL
      ai_ini_weapons( 3, 5, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      //LAS | ATC
      ai_ini_weapons( 3, 1, -1, -1, -1, -1, -1, -1, -1);
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

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_foslager;
  self.i_faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //MLG | LAS | LATC 
      ai_ini_weapons( 9, 3, 1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //ION | LAS | FLAK
      ai_ini_weapons( 13, 3, 12, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      //MIS | LAS | LATC 
      ai_ini_weapons( 4, 3, 1, -1, -1, -1, -1, -1, -1);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};

void() unit_foslager_m={

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_foslager;
  self.i_faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //PAC | LATC | FLAK
      ai_ini_weapons( 7, 1, 12, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      // ION | RPC | FLAK
      ai_ini_weapons( 13, 6, 12, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //ESR | LATC | LAS
      ai_ini_weapons( 8, 1, 3, -1, -1, -1, -1, -1, -1);
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

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_trowel;
  self.i_faction = FACTION_MILITAR;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //ESR | SFGA
      ai_ini_weapons( 8, 11, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      //PAC | SFGA
      ai_ini_weapons( 7, 11, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //ESR | ESR
      ai_ini_weapons( 8, 8, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};

void() unit_trowel_h={

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_trowel;
  self.i_faction = FACTION_SURVEST;
   
  self.flags = self.flags | FL_TURRET;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //RPC | ION
      ai_ini_weapons( 6, 13, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      //SFGA | EMP
      ai_ini_weapons( 11, 2, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //MIS | ION
      ai_ini_weapons(4, 13, -1, -1, -1, -1, -1, -1, -1);
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

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_onnek;
  self.i_faction = FACTION_SURVEST;
   
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //EMP
      ai_ini_weapons(13, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //ESR
      ai_ini_weapons( 2, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      //ION
      ai_ini_weapons( 8, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};

void() unit_onnek_m={

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_onnek;
  self.i_faction = FACTION_MILITAR;
   
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      //EMP
      ai_ini_weapons( 3, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      //SFGA
      ai_ini_weapons( 11, -1, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //PAC
      ai_ini_weapons( 7, -1, -1, -1, -1, -1, -1, -1, -1);
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

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_sorcerer;
  self.i_faction = FACTION_SURVEST;
   
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      // MIS | MLG
      ai_ini_weapons( 4, 9, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //MLG | MLG
      ai_ini_weapons( 9, 9, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      //MIS | MIS
      ai_ini_weapons( 4, 4, -1, -1, -1, -1, -1, -1, -1);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};


void() unit_sorcerer_m={

  self.style = TYPE_BRAWL;
  self.nextVecChoice = ID_VEC_sorcerer;
  self.i_faction = FACTION_MILITAR;
   
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      // MLG | MLG
      ai_ini_weapons( 9, 9, -1, -1, -1, -1, -1, -1, -1);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      //SWRM | SWRM
      ai_ini_weapons( 14, 14, -1, -1, -1, -1, -1, -1, -1);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      //ARH | ARH
      ai_ini_weapons( 10, 10, -1, -1, -1, -1, -1, -1, -1);
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

  self.style = TYPE_SNIPER;
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = ID_MCH_balaket;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

void() unit_balaket_sniper_h={
  self.i_faction = FACTION_SURVEST;
  
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
  self.i_faction = FACTION_MILITAR;
  
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

  self.style = TYPE_BRAWL;
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = ID_MCH_balaket;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

    
  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

void() unit_balaket_brawl_h={
  self.i_faction = FACTION_SURVEST;
  
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
  self.i_faction = FACTION_MILITAR;
  
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
  self.i_faction = FACTION_PSC;
  
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

  self.style = TYPE_BRAWL;
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = ID_MCH_matok;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};

void() unit_matok_sniper={

  self.style = TYPE_BRAWL;
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = ID_MCH_matok;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

void() unit_matok_sniper_h={
  self.i_faction = FACTION_SURVEST;
  
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
  self.i_faction = FACTION_MILITAR;
  
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
  self.i_faction = FACTION_PSC;
  
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
  self.i_faction = FACTION_SURVEST; 

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
  self.i_faction = FACTION_MILITAR;

  ai_promote();
  switch( self.ai_rank ){
    case 2:
      ai_ini_weapons(  ID_WEP_QRF, ID_WEP_FLAK, ID_WEP_ESR, ID_WEP_RPC, ID_WEP_MLGD, -1, -1, -1, -1);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( ID_WEP_QRF, ID_WEP_LAS, ID_WEP_RPC, ID_WEP_RPC, ID_WEP_EMP -1, -1, -1, -1);
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

  self.style = TYPE_BRAWL;
  self.flags = FL_TURRET;  //enforced for a mech
   
  self.nextVecChoice = ID_MCH_monitor;
  
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
   
  self.nextVecChoice = ID_MCH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_sniper ) ){
    ai_mech_sniper();
  }
};

void() unit_monitor_brawl_h={
  self.i_faction = FACTION_SURVEST;
  
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
  self.i_faction = FACTION_MILITAR;
  
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
  self.i_faction = FACTION_PSC;
  
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
  self.i_faction = FACTION_MILITAR;
  
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
  self.next_wepn1 = 1;
  self.next_wepn2 = 1;
  self.flags = FL_TURRET;  //enforced for a mech
  self.i_faction = 1;
  self.skin = 1;
  self.spreadDefault = ACCURACY_LOWTECH;
  
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
  self.i_faction = 4;
  ai_unit_setup( ai_vtol );
};