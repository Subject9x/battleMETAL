/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Missile - Laser Guided
      Range: Medium
      High Damage
      follow's player reticle
      Arcing
*/
#ifndef CSQC
void() data_ini_attack_missile_laserguide_;
#endif

void() data_ini_missile_laserguide_={

  self.data_idx = 9;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0.22;
  self.reloadMax = 8;
  self.energyRate = 0;
  
  self.w_range = 1800;  //1000
  self.damageValue = 200;
  self.damageType = DMG_EXP | EFF_PTR;

  self.techLevel = 1;
  self.equipSize = MIS1;

  self.spreadDefault = '0.03 0.03 0';
  self.wepFireOffset = '0 0 2';
  
  #ifdef CSQC
    self.w_name = "Missile - Laser Guide";  
    self.fire_sound = "sound/weapons/mis_fire.ogg";
    self.model = "q3mdl/weapons/w_lgm.md3"; 
    self.abbrev = "MLGD";
    self.description = "+ target <shields> reduce damage. + Missile will follow your reticle. + Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
    self.icon = "gfx/ui/wep_icons/wi_mlgd.png"; 
  #endif 
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 1;
    self.model = "q3mdl/weapons/w_lgm.md3";  
    self.w_attack = data_ini_attack_missile_laserguide_;
    self.think = default_weapon_think;
    self.data_ini_projectile = data_projectile_ini_missile_laserguide_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_missile_laserguide_={
  local vector lasOrg;
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
   
  ctrl_weapon_make_projectile( 0.05 );
  
  lasOrg = FIRE_ORIGIN + (v_forward * 2.1) + (v_up * -0.5);
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, lasOrg, 0);
};
#endif