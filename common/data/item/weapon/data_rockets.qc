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
void() data_ini_attack_rockets_;

void() data_ini_rockets_={

  self.data_idx = 4;  
  self.w_name = "Rocket Launcher";
  
  self.w_clipsize = 6;
  self.reloadRate = 0.22;
  self.reloadMax = 8;
  self.energyRate = 0;
  self.spreadDefault = '0.02 0.02 0';
  
  self.w_range = 400;
  self.p_damage = 75;
  self.p_dmgtype = (DMG_EXP);
  
  self.w_attack = data_ini_attack_rockets_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_rocket_;
  
  self.w_fire_ofs = '0 0 3';
  self.fire_sound = "sound/weapons/mis_fire.ogg";
  self.model = "q3mdl/weapons/w_mis.md3";
  self.techLevel = 1;
  self.i_size = 1;
  
  self.w_isburst = FALSE;
};

void() data_ini_attack_rockets_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE, 1.75 );
   
  self.owner.punchangle_x = -2 + crandom() * -2;
  self.owner.punchangle_y = -3 + crandom() * -4;
  pointparticles( particleeffectnum("TE_MIS_MUZZLE"), FIRE_ORIGIN + (v_forward * 1), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ), 1);
  
  ctrl_weapon_make_projectile( 0.01 );
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};
