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
#ifdef SSQC
void() data_ini_attack_quantum_;
#endif
#ifdef CSQC
void() te_muzzle_qrf={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  local vector ang;
  local vector prtclRail_org;
  local vector prtclRail_end;
  local vector prtclSpark_org;
  
  ang = vectoangles(endOrg - startOrg);
  makevectors(ang);
  prtclRail_org = startOrg + (v_forward * 2);
  prtclRail_end = startOrg + (v_forward * 48);
  prtclSpark_org = startOrg + (v_forward * 22);
  
  sound7(self, CHAN_AUTO, "sound/weapons/qrfl_fire.ogg", 1, ATTN_NORM, (0.1 + (random() * 0.9)) * 200, 0 );
  
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE"), prtclRail_org, normalize( endOrg - startOrg ), 1 ) ;
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org + (v_right * 0.5), normalize( endOrg - startOrg ) * 30, 1) ;
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org - (v_right * 0.5), normalize( endOrg - startOrg ) * 30, 1) ;
  
  trailparticles( world, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org + (v_right * 0.5), prtclRail_end + (v_right * 0.5) );
  trailparticles( world, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org - (v_right * 0.5), prtclRail_end - (v_right * 0.5) );
}
#endif
void() data_ini_quantum_={

  self.data_idx = UID_ITEM_quantum_rifle;
  
  self.w_clipsize = 1;
  self.reloadRate = 1.33;
  self.reloadMax = 1.33;
  self.energyRate = 0;
  
  self.w_range = 1500;
  self.damageValue = 40;
  self.damageType = DMG_BAL;
  
  self.techLevel = 2;
  self.equipSize = BAL2;
 
  self.spreadDefault = '0.033 0.033 0';
  self.wepFireOffset = '0 0 2';
  self.burstRate = 0;

#ifdef CSQC
  self.w_name = "Quantum Rifle";
  self.fire_sound = "sound/weapons/qrfl_fire.ogg";
  self.model = "q3mdl/weapons/w_qrf.md3";
  self.abbrev = "QRF";
  self.description = "+ Single-fire projectile. + Better against <Armor> + Targets without <Shields> will cause projectile to shatter and deal additional radius damage to nearby targets.";
  self.icon = "gfx/ui/wep_icons/wi_qrf.png"; 
  self.itemMuzzleFlash = te_muzzle_qrf;
#endif 
  
#ifdef SSQC
  self.w_attack = data_ini_attack_quantum_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_quantum_bit_;
  self.w_isburst = FALSE;
#endif
};

#ifdef SSQC
void() data_ini_attack_quantum_={
  
  ctrl_weapon_fireOffset();
  
  ctrl_weapon_updateAmmo( FALSE );

  ctrl_weapon_make_projectile( -1 );
  
  NEWSHOT.avelocity = '0 0 300';
  NEWSHOT = world;
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif