/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Item - Weapon
    Rocket Pack
      Range: Short
      6rnd Burst.
      low accuracy.
*/
#ifndef CSQC
void() data_ini_attack_rockets_;
#endif

void() data_ini_rockets_={

  self.data_idx = 4;  
  self.w_name = "Rocket Launcher";
  
  self.w_clipsize = 1;
  self.reloadRate = 1;
  self.reloadMax = 1;
  self.energyRate = 0;
  
  self.w_range = 400;
  self.damageValue = 38;
  self.damageType = DMG_EXP;
  
  self.techLevel = 1;
  self.equipSize = 1;
  
  #ifdef CSQC
  self.abbrev = "RCK";
  //self.description = "+ Burst fires whole clip. + Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
  self.description = "+ Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
  self.icon = "gfx/ui/wep_icons/wi_rck.png";  
  #endif 
  
  #ifndef CSQC
  self.spreadDefault = '0.02 0.025 0';
  self.w_isburst = FALSE;
  self.burstRate = 1.75;
  self.wepFireOffset = '0 0 3';
  self.fire_sound = "sound/weapons/mis_fire.ogg";
  self.model = "q3mdl/weapons/w_mis.md3";
  self.w_attack = data_ini_attack_rockets_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_rocket_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_rockets_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
   
  self.owner.punchangle_x = -1 + crandom() * -1;
  self.owner.punchangle_y = -1 + crandom() * -1;
  client_send_particle( particleeffectnum("TE_MIS_MUZZLE"), FIRE_ORIGIN + (v_forward * 1), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ), 1);
  
  ctrl_weapon_make_projectile( 0.01 );
  
  pointsound( self.origin, self.fire_sound, 1, ATTN_NORM);
};
#endif