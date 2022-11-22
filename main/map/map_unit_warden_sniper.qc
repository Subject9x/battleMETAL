/*
battleMETAL 
Author: Peter Roohr
Date: 09/03/202
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: WARDEN
  TYPE: METAL
  SIZE: LIGHT
  --------------------------------
  
  1 - M_TOR_CENTER (BAL2|BAL3|BAL4|ENE2|ENE3|ENE4|MIS1|MIS2|MIS3|MIS4|MSC2|MSC3|MSC4));
  2 - M_TOR_CENTER (BAL1|ENE1));
  3 - M_TOR_CENTER (BAL1|ENE1));
  4 - M_TOR_RIGHT, (BAL1|ENE1|MIS1|MSC1));
  5 - M_TOR_LEFT,  (MIS1|MIS2|MIS3|MIS4|MSC2|MSC3|MSC4));
  
*/
void() unit_warden_survest_sniper={
  self.faction = FACTION_SURVEST;
  self.flags = FL_TURRET;  //enforced for a mech   
  self.nextVecChoice = UID_MECH_warden;
  self.subType = AI_UTYPE_DIR;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  trigger_ext_check();
  switch( self.ai_rank ){
    default:
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_EMPTY;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 1:
      self.next_wepn1 = UID_ITEM_missile_laserguide;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_snub_artillery;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.next_wepn5 = UID_ITEM_shield_emitter;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_missile_swarm;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.next_wepn5 = UID_ITEM_missile_swarm;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

void() unit_warden_militar_sniper={
  self.faction = FACTION_MILITAR;
  self.flags = FL_TURRET;  //enforced for a mech   
  self.nextVecChoice = UID_MECH_warden;
  self.subType = AI_UTYPE_ENE;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  trigger_ext_check();
  switch( self.ai_rank ){
    default:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_EMPTY;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 1:
      self.next_wepn1 = UID_ITEM_quantum_rifle;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_adv_reload;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_missile_swarm;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_particle_cannon;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_recharge_capacitor;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};

void() unit_warden_psc_sniper={
  self.faction = FACTION_PSC;
  self.flags = FL_TURRET;  //enforced for a mech   
  self.nextVecChoice = UID_MECH_warden;
  self.subType = AI_UTYPE_ENE;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  ai_promote();
  trigger_ext_check();
  switch( self.ai_rank ){
    default:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_missile_laserguide;
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.spreadDefault = ACCURACY_SKIRMISH;
      break;
    case 1:
      self.next_wepn1 = UID_ITEM_emp;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_light_laser;
      self.next_wepn5 = UID_ITEM_missile_activeradar;
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 2:
      self.next_wepn1 = UID_ITEM_electro_repeater;
      self.next_wepn2 = UID_ITEM_light_laser;
      self.next_wepn3 = UID_ITEM_light_laser;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_shield_capacitor;
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.spreadDefault = ACCURACY_MARKSMAN;
      break;
    case 3:
      self.next_wepn1 = UID_ITEM_quantum_rifle;
      self.next_wepn2 = UID_ITEM_light_autocannon;
      self.next_wepn3 = UID_ITEM_light_autocannon;
      self.next_wepn4 = UID_ITEM_heatsink;
      self.next_wepn5 = UID_ITEM_missile_swarm;
      self.spreadDefault = ACCURACY_SKIRMISH;
      self.spreadDefault = ACCURACY_SNIPER;
      break;
  }
  macro_ai_setup(ai_mech_sniper)
};