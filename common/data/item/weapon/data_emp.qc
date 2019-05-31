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
void() data_ini_attack_emp_;

void() data_ini_emp_={

  self.data_idx = 2;  
  self.w_name = "EMP Cannon";
  
  self.w_clipsize = 1;
  self.rl_rate = 0.1;
  self.rl_max = 6;
  self.en_rate = 266.7;
  self.spreadDefault = '0.009 0.008 0';
  
  self.w_range = 1700;
  self.p_damage = 400;
  self.p_dmgtype = (DMG_ENE | EFF_STX | EFF_ENE);
  
  self.w_attack = data_ini_attack_emp_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_emp_;
  
  self.w_fire_ofs = '0 0.1 7';
  self.fire_sound = "sound/weapons/emp_fire.ogg";
  self.model = "q3mdl/weapons/w_emp.md3";
  self.i_techlvl = 2;
  self.i_size = 3;
};

void() data_ini_attack_emp_={

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE, 0 );
  
  ctrl_weapon_make_projectile( 0.01 );
  if( NEWSHOT ){
    NEWSHOT.w_firetime = time + 0.5;
  }
  
  sound (NEWSHOT, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_EMP_MUZZLE"), FIRE_ORIGIN + v_forward * 3 + v_up * 0.1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 4, 1);
};
