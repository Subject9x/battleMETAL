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
  
  self.nextVecChoice = UID_VEHICLE_dunerunner;
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
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
      
  if( ai_unit_setup( ai_gev ) ){
    ai_gev();
  }
};

void() unit_dunerunner_m={
  
  self.nextVecChoice = UID_VEHICLE_dunerunner;
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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

  self.nextVecChoice = UID_VEHICLE_foslager;
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
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};

void() unit_foslager_m={

  self.nextVecChoice = UID_VEHICLE_foslager;
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
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_rotary_plasma, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  
  self.nextVecChoice = UID_VEHICLE_trowel;
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
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
  
  if( ai_unit_setup( ai_tank_skirmish ) ){
    ai_tank_skirmish();
  }
};

void() unit_trowel_h={

  self.nextVecChoice = UID_VEHICLE_trowel;
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
      ai_ini_weapons( UID_ITEM_rotary_plasma, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_emp, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_SURVEST;

  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};

void() unit_onnek_m={

  self.nextVecChoice = UID_VEHICLE_onnek;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_MARKSMAN;
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SNIPER;
      ai_ini_weapons( UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_SURVEST;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_rocket_launcher, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
  }
    
  if( ai_unit_setup( ai_vec_dest ) ){
    ai_vec_dest();
  }
};


void() unit_sorcerer_m={

  self.nextVecChoice = UID_VEHICLE_sorcerer;
  self.faction = FACTION_MILITAR;
   
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  ai_promote();
  switch( self.ai_rank ){
    case 2:
      self.spreadDefault = ACCURACY_LOWTECH;
      ai_ini_weapons( UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    case 3:
      self.spreadDefault = ACCURACY_SKIRMISH;
      ai_ini_weapons( UID_ITEM_missile_swarm, UID_ITEM_missile_swarm, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      break;
    default:
      self.spreadDefault = ACCURACY_PRIMITVE;
      ai_ini_weapons( UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  self.nextVecChoice = UID_MECH_balaket;
  
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_quantum_rifle, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
  }
  unit_balaket_sniper();
};


//        BRAWLER VARIANTS
void() unit_balaket_brawl={

  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_balaket;
  
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_electro_repeater, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  self.nextVecChoice = UID_MECH_matok;
  
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
  self.nextVecChoice = UID_MECH_matok;
  
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
      ai_ini_weapons( UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_light_laser,  UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_flak, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_light_autocannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_flak, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_flak, UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_light_autocannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_quantum_rifle, UID_ITEM_flak, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_missile_laserguide, UID_ITEM_rocket_launcher, UID_ITEM_snub_artillery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_ion_coil, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_flak, UID_ITEM_light_laser, UID_ITEM_rocket_launcher, UID_ITEM_ion_coil, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
      ai_ini_weapons(  UID_ITEM_quantum_rifle, UID_ITEM_flak, UID_ITEM_electro_repeater, UID_ITEM_rotary_plasma, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_quantum_rifle, UID_ITEM_light_laser, UID_ITEM_rotary_plasma, UID_ITEM_rotary_plasma, UID_ITEM_emp, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_electro_repeater, UID_ITEM_ion_coil, UID_ITEM_rocket_launcher, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
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
  self.nextVecChoice = UID_MECH_monitor;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  if( ai_unit_setup( ai_mech_skirmish ) ){
    ai_mech_skirmish();
  }
};
//        SNIPER VARIANTS
void() unit_monitor_sniper={

  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_monitor;
  
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
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_electro_repeater,UID_ITEM_emp,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_snub_artillery,UID_ITEM_snub_artillery,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher,UID_ITEM_rocket_launcher);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_light_autocannon,UID_ITEM_flak,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_rocket_launcher,UID_ITEM_missile_activeradar,UID_ITEM_rocket_launcher);
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_emp, UID_ITEM_electro_repeater, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser, UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_energy_battery, UID_ITEM_energy_battery, UID_ITEM_recharge_capacitor);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_rotary_plasma, UID_ITEM_emp, UID_ITEM_rocket_launcher, UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar);
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
      ai_ini_weapons( UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_light_laser, UID_ITEM_light_autocannon, UID_ITEM_emp, UID_ITEM_electro_repeater, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser, UID_ITEM_electro_repeater, UID_ITEM_electro_repeater, UID_ITEM_energy_battery, UID_ITEM_energy_battery, UID_ITEM_recharge_capacitor);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_flak,UID_ITEM_rotary_plasma, UID_ITEM_emp, UID_ITEM_rocket_launcher, UID_ITEM_missile_activeradar, UID_ITEM_missile_activeradar);
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
      ai_ini_weapons(UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_light_autocannon,UID_ITEM_particle_cannon,UID_ITEM_particle_cannon,UID_ITEM_target_module,UID_ITEM_energy_battery,UID_ITEM_shield_emitter);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_light_laser,UID_ITEM_missile_laserguide,UID_ITEM_missile_laserguide,UID_ITEM_energy_battery,UID_ITEM_target_module,UID_ITEM_shield_emitter);
      self.spreadDefault = ACCURACY_SNIPER;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_light_laser,UID_ITEM_light_autocannon,UID_ITEM_particle_cannon,UID_ITEM_quantum_rifle,UID_ITEM_missile_activeradar,UID_ITEM_energy_battery,UID_ITEM_target_module);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  unit_monitor_sniper();
};


/*
  UNIT: BASE TURRET
  TYPE: BUILDING
  --------------------------------
*/

void() building_turret_ini={
  self.nextVecChoice = UID_TURRET_light_turret; //DEBUG
  self.flags = FL_TURRET;  //enforced for a mech
  self.skin = self.faction;
  ai_promote();
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }
  
  if( ai_unit_setup( ai_turret ) ){
    ai_turret();
  }
};

void() building_turret_light_s={
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_flak, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_light_laser, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_autocannon, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

void() building_turret_light_m={
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_flak, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_flak, UID_ITEM_quantum_rifle, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_flak, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_light_laser, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

void() building_turret_missile_s={
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_light_laser, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_missile_laserguide, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

void() building_turret_missile_m={
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_target_module, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_missile_activeradar, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

void() building_turret_heavy_s={
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons(UID_ITEM_ion_coil, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons(UID_ITEM_ion_coil, UID_ITEM_flak, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons(UID_ITEM_emp, UID_ITEM_energy_battery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons(UID_ITEM_ion_coil, UID_ITEM_light_autocannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

void() building_turret_heavy_m={
  switch( self.ai_rank ){
    case 1:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_large_sensors, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_energy_battery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      ai_ini_weapons( UID_ITEM_particle_cannon, UID_ITEM_particle_cannon, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      ai_ini_weapons( UID_ITEM_emp, UID_ITEM_energy_battery, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY, UID_ITEM_EMPTY);
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

void() unit_psc_vtol_l={
  self.nextVecChoice = -0;
  self.faction = 4;
  //ai_unit_setup( ai_vtol );
};