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
  if( ai_can_spawn() == FALSE ){
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
  if( ai_can_spawn() == FALSE ){
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
  if( ai_can_spawn() == FALSE ){
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
  if( ai_can_spawn() == FALSE ){
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
  if( ai_can_spawn() == FALSE ){
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
  if( ai_can_spawn() == FALSE ){
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
  UNIT: BASE TURRET
  TYPE: BUILDING
  --------------------------------
*/

void() building_turret_ini={
  self.flags = FL_TURRET;  //enforced for a mech
  self.skin = 1;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.think = ai_turret;
  self.nextthink = time + 0.05;
};

/*QUAKED building_turret_light_s (0.0 0.0 1.0) (-20 -20 -6) (20 20 13) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Light Turret, Survest Faction
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_light_s={
  self.nextVecChoice = UID_TURRET_light_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.spreadDefault = ACCURACY_LOWTECH;
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_flak;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_autocannon;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

/*QUAKED building_turret_light_m (0.0 0.0 1.0) (-20 -20 -6) (20 20 13) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Light Turret, MILITAR Faction
NOTE: auto promotion x1 on-spawn!
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_light_m={
  self.nextVecChoice = UID_TURRET_light_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_quantum_rifle;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

/*QUAKED building_turret_light_p (0.0 0.0 1.0) (-20 -20 -6) (20 20 13) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Light Turret, PSC Faction
NOTE: auto promotion x2 on-spawn!
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_light_p={
  self.nextVecChoice = UID_TURRET_light_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_quantum_rifle;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_flak;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_light_laser;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};



/*QUAKED building_turret_missile_s (0.0 0.0 1.0) (-20 -20 -13) (20 20 20) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Missile Turret, Survest Faction
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_missile_s={
  self.nextVecChoice = UID_TURRET_missile_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_missile_laserguide;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};

/*QUAKED building_turret_missile_m (0.0 0.0 1.0) (-20 -20 -13) (20 20 20) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Missile Turret, MILITAR Faction
NOTE: auto promotion x1 on-spawn!
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_missile_m={
  self.nextVecChoice = UID_TURRET_missile_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};


/*QUAKED building_turret_missile_p (0.0 0.0 1.0) (-20 -20 -13) (20 20 20) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Missile Turret, PSC Faction
NOTE: auto promotion x2 on-spawn!
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_missile_p={
  self.nextVecChoice = UID_TURRET_missile_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_adv_reload;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_heatsink;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_missile_activeradar;
      self.next_wepn2 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};



/*QUAKED building_turret_heavy_s(0.0 0.0 1.0) (-28 -28 -16) (28 28 28) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Heavy Turret, Survest Faction
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls

HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_heavy_s={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_SURVEST;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_flak;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_ion_coil;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};



/*QUAKED building_turret_heavy_m (0.0 0.0 1.0) (-28 -28 -16) (28 28 28) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Heavy Turret, MILITAR Faction
NOTE: auto promotion x1 on-spawn!
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls
HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_heavy_m={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_MILITAR;
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_particle_cannon;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.spreadDefault = ACCURACY_PRIMITVE;
      break;
  }
  building_turret_ini();
};


/*QUAKED building_turret_heavy_p (0.0 0.0 1.0) (-28 -28 -16) (28 28 28) NO_CAMPAIGN NO_COOP NO_DM NO_TDM COLD_START - - PROMOTE DEMOTE NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NO_DROP TRIGGER_ME DEBUG_MODE UNARMED
{ model("models/buildings/turret/turret.md3"); }
Heavy Turret, PSC Faction
NOTE: auto promotion x2 on-spawn!
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
COLD_START 16: countdown before activating, on-spawn, bot will ignore friendly help calls
HAS_RADAR 64: radar is expensive to use, use sparingly
PROMOTE 128: AI rank is set by skill, this spawnflag bumps it up by 1
DEMOTE 256: AI rank is set by skill, this spawnflag debuffs it up by 1
NO_NOVICE 512: remove from Novice Difficulty
NO_REGULAR 1024: remove from Regular Difficulty
NO_VETERAN 2048: remove from Veteran Difficulty
NO_ELITE 4096: remove from Elit Difficulty
NO_DROP 8192: don't drop bot to the floor onspawn
TRIGGER_ME 16384: ai only spawns when triggered
DEBUG_MODE 32768: spawns but will not react to anything
MUTE_ME 65536: ai doesn't use voice/radio
*/
void() building_turret_heavy_p={
  self.nextVecChoice = UID_TURRET_heavy_turret;
  self.faction = FACTION_PSC;
  ai_promote();
  ai_promote();
  switch( self.ai_rank ){
    case 1:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.spreadDefault = ACCURACY_LOWTECH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_energy_battery;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_particle_cannon;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    default:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_autocannon;
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