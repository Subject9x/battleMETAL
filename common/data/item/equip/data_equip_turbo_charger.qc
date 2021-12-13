/*
battleMETAL
Author: Peter Roohr
Date: 07/02/2019
Overview: 
  Data File - Item - Equipemnt
    Turbo Charger
      increases Unit's EVADE speed, but increases EVADE cost;
*/
#ifdef SSQC
void() turbo_charger_upgrade_;
void() turbo_charger_remove_;
#endif

void() data_ini_equip_turbo_charger_={

  self.data_idx = UID_ITEM_turbo_charger; 
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  
  self.energyRate = 0.2;
  self.energyMax = 0; //will hold Unit's previous drain value;
  self.data_speed_accel = 0;  //will hold Unit's previous accel value.
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = DMG_MSC;
 
  self.techLevel = 2;
  self.equipSize = MSC4;
  
  #ifdef CSQC     
    self.w_name = "Turbo Charger";
    self.model = "q3mdl/testball.md3";  //TODO - new model
    self.w_clipsize = -1;
    self.reloadRate = -1;
    self.reloadMax = -1;
    self.energyRate = -1;
    self.w_range = -1;
    self.damageValue = -1;
    self.techLevel = -1;
    self.abbrev = "TCHR";
    self.description = "+ This module will absorb 1 critical leg hit. + increase FORWARD speed by 15% + Proportional Increase <Evasion> speed by 20%. + Proportional Increase <Evasion> energy cost  by 20%.";
    self.icon = "gfx/ui/wep_icons/eqp_tchr.png";
    self.alpha = 0.01;
    self.scale = 0.01;
  #endif
  
  #ifdef SSQC
    self.item_run_upgrade = turbo_charger_upgrade_;
    self.think = SUB_Null;
    self.item_remove_upgrade = turbo_charger_remove_;
    self.w_isburst = FALSE; 
  #endif
};

#ifdef SSQC
void() turbo_charger_upgrade_={
  local entity module;
  local float perc;
  
  //save old values here
  self.evasionDrain = self.owner.evasionDrain;
  self.data_speed_accel = self.owner.data_speed_accel;
  
  self.evasionDrain = self.owner.vec_size / 10;
  perc = 0.4 - self.evasionDrain;
  self.owner.evasionDrain =  self.owner.evasionDrain + (self.owner.evasionDrain * self.evasionDrain);
  self.owner.data_speed_accel = self.owner.data_speed_accel + perc;
  
  self.data_speed_forward = self.owner.data_speed_forward;
  
  if( (self.owner.flags & FL_CLIENT) ){
    module = self;
    self = module.owner;
      self.ramUpMax = 4 - self.vec_size;
      self.ramUpMax = self.ramUpMax / 10;
      self.ramUpMax = self.data_speed_forward * self.ramUpMax;
      self.ramUpMax = self.data_speed_forward - self.ramUpMax;
      self.ramUpMax = self.ramUpMax / 24;
    self = module;
  }
};

void() turbo_charger_remove_={
  local entity module;
  self.owner.evasionDrain = self.evasionDrain;
  self.owner.data_speed_accel = self.data_speed_accel;
  self.owner.data_speed_forward = self.data_speed_forward;
  if(self.clientData != world ){
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_EFLAGS;
  }
  if( (self.owner.flags & FL_CLIENT) ){
    module = self;
    self = module.owner;
      self.data_speed_accel = module.data_speed_accel;
      self.ramUpMax = 4 - self.vec_size;
      self.ramUpMax = self.ramUpMax / 10;
      self.ramUpMax = self.data_speed_forward * self.ramUpMax;
      self.ramUpMax = self.data_speed_forward - self.ramUpMax;
      self.ramUpMax = self.ramUpMax / 33;
    self = module;
  }
};
#endif
