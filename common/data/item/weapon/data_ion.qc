/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Weapon
    Ion
      range: medium
      Shield breaking.
      Small AoE.
      Consumes Energy.
*/
#ifdef SSQC
void() data_ini_attack_ion_;
#endif

#ifdef CSQC
void() te_muzzle_ion={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  sound7(self, CHAN_AUTO, "sound/weapons/emp_fire.ogg", 1, ATTN_NORM, (1.0 + (random() * 0.4)) * 100, 0 );
  pointparticles( particleeffectnum("TE_ION_MUZZLE"), startOrg, normalize( endOrg - startOrg) * 4, 1);
};
#endif
void() data_ini_ion_={

  self.data_idx = UID_ITEM_ion_coil;
  
  self.w_clipsize = 3;
  self.reloadRate = 0.15;
  self.reloadMax = 4;
  self.energyRate = 125;
  
  self.w_range = 1500;
  self.damageValue = 75;
  self.damageType = (DMG_ENE | EFF_STX | EFF_ENE);

  self.techLevel = 1;
  self.equipSize = ENE2;
  
  self.spreadDefault = '0.025 0.05 0';
  self.wepFireOffset = '0 0 4';
  self.burstRate = 1;
  
#ifdef CSQC
  self.w_name = "Ion Coil";
  self.fire_sound = "sound/weapons/emp_fire.ogg";
  self.model = "q3mdl/weapons/w_ion.md3";
  self.abbrev = "ION";
  self.description = "+ Anti-shield. + Armor damage greatly reduced. +3-rnd burst fire.";
  self.icon = "gfx/ui/wep_icons/wi_ion.png";
  self.itemMuzzleFlash = te_muzzle_ion;
#endif

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_ion_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_ion_;
#endif
};

#ifdef SSQC
void() data_ini_attack_ion_={

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
  
  ctrl_weapon_make_projectile( 0.01 );
  if( NEWSHOT ){
    NEWSHOT.w_firetime = time + 0.5;
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif
