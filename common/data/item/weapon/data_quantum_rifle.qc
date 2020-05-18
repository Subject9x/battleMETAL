/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Item - Weapon
    Quantum Rifle
      Range: Long
      Hitscan
      Submunitions
      Affects shields only
*/
#ifndef CSQC
void() data_ini_attack_quantum_;
#endif

void() data_ini_quantum_={

  self.data_idx = UID_ITEM_quantum_rifle;  
  
  self.w_clipsize = 4;
  self.reloadRate = 0.15;
  self.reloadMax = 5;
  self.energyRate = 0;
  
  self.w_range = 1500;
  self.damageValue = 50;
  self.damageType = DMG_BAL;
  
  self.techLevel = 2;
  self.equipSize = BAL2;  //BAL1 || BAL3
 
  self.spreadDefault = '0.09 0.09 0';
  self.wepFireOffset = '0 0 2';
  
  #ifdef CSQC
    self.w_name = "Quantum Rifle";
    self.fire_sound = "sound/weapons/qrfl_fire.ogg";
    self.model = "q3mdl/weapons/w_qrf.md3";
    self.abbrev = "QRF";
    self.description = "+ Single-fire projectile. + will home on your target when facing them. + Anti-Shield. + reduced damage on Armor.";
    self.icon = "gfx/ui/wep_icons/wi_qrf.png"; 
  #endif 
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0.67;
    self.model = "q3mdl/weapons/w_qrf.md3";
    self.w_attack = data_ini_attack_quantum_;
    self.think = default_weapon_think;
    self.data_ini_projectile = data_projectile_ini_quantum_bit_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_quantum_={
  local entity hold;
  
  ctrl_weapon_fireOffset();  
  
  ctrl_weapon_updateAmmo( TRUE );
 
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, 0);

  ctrl_weapon_make_projectile( -1 );

  if( ai_valid_target(self.owner.enemy) ){
    hold = self;
    self = hold.owner;
    if( util_checkPointAngleImpl(self.enemy.origin) ){
      NEWSHOT.enemy = self.enemy;
    }
    self = hold;
  }
  NEWSHOT.avelocity = '0 0 300';
  NEWSHOT = world;
};
#endif