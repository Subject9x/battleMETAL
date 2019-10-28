/*
battleMETAL 
Author: Peter Roohr
Date: 10/28/2019
Overview:
  broke unit map instances down by unit for readability.
  
  UNIT: MATOK
  TYPE: METAL
  SIZE: MEDIUM
  --------------------------------
*/
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
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  self.think = ai_mech_sniper;
  self.nextthink = time + 0.05;
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
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  self.think = ai_mech_sniper;
  self.nextthink = time + 0.05;
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
  self.flags = FL_TURRET;  //enforced for a mech
  self.nextVecChoice = UID_MECH_matok;
  
  if( !ai_can_spawn() ){
    remove(self);
    return;
  }

  self.think = ai_mech_sniper;
  self.nextthink = time + 0.05;
};