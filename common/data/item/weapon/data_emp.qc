/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Item - Weapon
    EMP
      Short range.
      Shield breaking.
      Small AoE.
      Consumes Energy
*/
#ifndef CSQC
void() data_ini_attack_emp_;
#endif

void() data_ini_emp_={

  self.data_idx = 2;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 6; //
  self.energyRate = 300;  //250
  
  self.w_range = 3000;
  self.damageValue = 600; //400
  self.damageType = (DMG_ENE | EFF_STX | EFF_ENE);
  
  self.techLevel = 2;
  self.equipSize = ENE3;
  
  self.wepFireOffset = '0 0.1 7';
  self.spreadDefault = '0 0 0';
  
  #ifdef CSQC
    self.w_name = "EMP Cannon";
    self.fire_sound = "sound/weapons/emp_fire.ogg";
    self.model = "q3mdl/weapons/w_emp.md3";
    self.abbrev = "EMP";
    self.description = "+ Damages <shields> ONLY. + Enemy shield regen slowed down. + Small proximity detonation.";
    self.icon = "gfx/ui/wep_icons/wi_emp.png";
  #endif
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.model = "q3mdl/weapons/w_emp.md3";
    self.w_attack = data_ini_attack_emp_;
    self.think = default_weapon_think;
    self.data_ini_projectile = data_projectile_ini_emp_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_emp_={

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  ctrl_weapon_make_projectile( 0.01 );
  if( NEWSHOT ){
    NEWSHOT.w_firetime = time + 0.5;
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN + v_forward * 3 + v_up * 0.1, FIRE_ENDPOINT, 0);
};
#endif
