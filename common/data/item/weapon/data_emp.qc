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
  
  traceline(self.wepFireOffset, self.owner.laser_sight_org, FALSE, self.owner);
  
  Sound7_Dynamic(self, CHAN_AUTO, self.fire_sound, 1.0, ATTN_NORM, (0.67 + (random() * 0.33)) * 100, SOUNDFLAG_DYNAMIC_INT);
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_EMP_MUZZLE"), self.wepFireOffset, normalize( self.wepFireOffset - trace_endpos ) * 4, 1);
  }
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
  precache_sound("sound/weapons/emp_fire.ogg");
  precache_sound("sound/weapons/emp_fire_int.ogg");
  precache_sound("sound/weapons/emp_reload.ogg");
  precache_model("models/weapons/w_emp.md3");
  precache_file( "gfx/ui/wep_icons/wi_emp.png");
  self.w_name = "EMP Cannon";
  self.fire_sound = "sound/weapons/emp_fire%s.ogg";
  self.reload_sound = "sound/weapons/emp_reload.ogg";
  self.model = "models/weapons/w_emp.md3";
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
