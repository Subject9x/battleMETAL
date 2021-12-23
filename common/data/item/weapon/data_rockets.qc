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
#ifdef SSQC
void() data_ini_attack_rockets_;
#endif

#ifdef CSQC
void() te_muzzle_rck={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  pointsound( startOrg, "sound/weapons/rckt_fire.ogg", 1, ATTN_NORM);
  sound7(self, CHAN_AUTO, "sound/weapons/rckt_fire.ogg", 1, ATTN_NORM, (0.25 + (random() * 0.75)) * 133, 0 );
  
  pointparticles( particleeffectnum("TE_MIS_MUZZLE"), startOrg, normalize(endOrg - startOrg), 1);
}
#endif
void() data_ini_rockets_={

  self.data_idx = UID_ITEM_rocket_launcher;  
  
  self.w_clipsize = 1;
  self.reloadRate = 1.25;
  self.reloadMax = 1.25;
  self.energyRate = 0;
  
  self.w_range = 1800;
  self.damageValue = 55;  //pre-release 67
  self.damageType = DMG_EXP;
  
  self.techLevel = 1;
  self.equipSize = MIS1;
  
  self.wepFireOffset = '0 0 3';
  self.spreadDefault = '0.02 0.025 0';
  self.burstRate = 1.75;
  
#ifdef CSQC
  self.w_name = "Rocket Launcher";
  self.fire_sound = "sound/weapons/rckt_fire.ogg";
  self.model = "q3mdl/weapons/w_mis.md3";
  self.abbrev = "RCK";
  self.description = "+ target <shields> reduce damage. + Does NOT require <Active Radar>. + Does NOT require <Target Lock>.";
  self.icon = "gfx/ui/wep_icons/wi_rck.png";
  self.itemMuzzleFlash = te_muzzle_rck;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_rockets_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_rocket_;
#endif
};

#ifdef SSQC
void() data_ini_attack_rockets_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
   
  self.owner.punchangle_x = -1 + crandom() * -1;
  self.owner.punchangle_y = -1 + crandom() * -1;

  ctrl_weapon_make_projectile( 0.01 );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif