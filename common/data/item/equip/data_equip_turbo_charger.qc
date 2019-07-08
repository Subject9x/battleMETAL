/*
battleMETAL
Author: Peter Roohr
Date: 07/02/2019
Overview: 
  Data File - Item - Equipemnt
    Turbo Charger
      increases Unit's EVADE speed, but increases EVADE cost;
*/
#ifndef CSQC
void() turbo_charger_upgrade_;
void() turbo_charger_remove_;
#endif

void() data_ini_equip_turbo_charger_={

  self.data_idx = UID_ITEM_turbo_charger;  
  self.w_name = "Turbo Charger";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  
  self.energyRate = 0.2;
  self.energyMax = 0; //will hold Unit's previous drain value;
  self.data_speed_accel = 0;  //will hold Unit's previous accel value.
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
 
  self.techLevel = 2;
  self.i_size = 3;
  
  #ifdef CSQC
  self.abbrev = "TCHR";
  self.description = "Increase Evasion speed by 20%. | | Increase Evasion cost  by 13%~";
  self.icon = "gfx/ui/wep_icons/eqp_tchr.png"; //TODO - new icon
  #endif
  
  #ifndef CSQC
  self.evasionDrain = 0.13;
  self.model = "q3mdl/weapons/e_atgm.md3";  //TODO - new model
  self.w_attack = turbo_charger_upgrade_;
  self.think = SUB_Null;
  self.unit_wep1 = turbo_charger_remove_;
  self.w_isburst = FALSE; 
  #endif
};

#ifndef CSQC
void() turbo_charger_upgrade_={
  local entity module;
  
  self.energyMax = self.owner.evasionDrain;
  self.owner.evasionDrain = self.evasionDrain + self.owner.evasionDrain;
  self.data_speed_accel = self.owner.data_speed_accel;
  self.owner.data_speed_accel = self.owner.data_speed_accel + (self.owner.data_speed_accel * self.energyRate);
  if( (self.owner.flags & FL_CLIENT) ){
    module = self;
    self = module.owner;
      client_update_moveSpeed( self.owner.data_speed_forward, self.owner.data_speed_strafe, self.owner.data_speed_backward, ftos(self.owner.data_speed_accel), self.owner.hud_rollangle);  
    self = module;
  }
};

void() turbo_charger_remove_={
  local entity module;
  self.owner.evasionDrain = self.energyMax;
  self.owner.data_speed_accel = self.data_speed_accel;
  if( (self.owner.flags & FL_CLIENT) ){
    module = self;
    self = module.owner;
      client_update_moveSpeed( self.owner.data_speed_forward, self.owner.data_speed_strafe, self.owner.data_speed_backward, ftos(self.owner.data_speed_accel), self.owner.hud_rollangle);  
    self = module;
  }
};
#endif
