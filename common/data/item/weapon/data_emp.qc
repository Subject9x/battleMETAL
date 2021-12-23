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
#ifdef SSQC
void() data_ini_attack_emp_;
#endif
#ifdef CSQC
void() te_muzzle_emp={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  sound7(self, CHAN_AUTO, "sound/weapons/emp_fire.ogg", 1, ATTN_NORM, (0.67 + (random() * 0.33)) * 100, 0 );
  pointparticles( particleeffectnum("TE_EMP_MUZZLE"), startOrg, normalize( startOrg - endOrg ) * 4, 1);
};
#endif
void() data_ini_emp_={

  self.data_idx = UID_ITEM_emp;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 6;
  self.energyRate = 250;
  
  self.w_range = 3000;
  self.damageValue = 475;
  self.damageType = (DMG_ENE | EFF_STX | EFF_ENE);
  
  self.techLevel = 2;
  self.equipSize = ENE3;
  
  self.wepFireOffset = '0 0.1 7';
  self.spreadDefault = '0 0 0';
  self.burstRate = 0;
  
#ifdef CSQC
  self.w_name = "EMP Cannon";
  self.fire_sound = "sound/weapons/emp_fire.ogg";
  self.model = "q3mdl/weapons/w_emp.md3";
  self.abbrev = "EMP";
  self.description = "+ Anti-shield. + Small proximity detonation. + Armor damage greatly reduced.";
  self.icon = "gfx/ui/wep_icons/wi_emp.png";
  self.itemMuzzleFlash = te_muzzle_emp;
#endif

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_emp_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_emp_;
#endif
};

#ifdef SSQC
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
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif
