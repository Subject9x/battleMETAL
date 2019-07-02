/*
battleMETAL
Author: Peter Roohr
Date: 07/02/2019
Overview: 
  Data File - Item - Equipemnt
    Super Charger
      increases Unit's EVADE speed, but increases EVADE cost;
      
*/
void() super_charger_upgrade_;
void() super_charger_remove_;

void() data_ini_equip_super_charger_={

  self.data_idx = UID_ITEM_super_charger;  
  self.w_name = "Super Charger";
  
  self.w_clipsize = 1;
  self.reloadRate = 0;
  self.reloadMax = 0;
  
  self.energyRate = 0.2;
  self.evasionDrain = 0.13;
  
  self.w_range = 0;
  self.damageValue = 0;
  self.damageType = (DMG_MSC);
  
  self.w_attack = super_charger_upgrade_;
  self.think = SUB_Null;

  self.model = "q3mdl/weapons/e_atgm.md3";
  self.techLevel = 2;
  self.i_size = 3;
  
  self.unit_wep1 = super_charger_remove_;
  
  self.w_isburst = FALSE; 

  self.abbrev = "SCHR";
  self.description = "Increase Evasion speed by 20%. | | Increase Evasion cost  by 13%~";
  self.icon = "gfx/ui/wep_icons/eqp_atgm.png";
};

void() super_charger_upgrade_={
  if( (self.owner.flags & FL_CLIENT) ){
    
    client_update_moveSpeed( self.owner.data_speed_forward, self.owner.data_speed_strafe, self.owner.data_speed_backward, "TODO", self.owner.hud_rollangle);
  }
};

void() super_charger_remove_={
  self.owner.w_firetime = self.w_firetime;
  self.owner.spreadDefault = self.w_fire_ofs;
  self.owner.accuracyMod = self.owner.accuracyMod - self.accuracyMod;
};
