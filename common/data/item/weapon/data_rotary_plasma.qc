/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Rotary Plasma Chamber
      Range: Medium
      8rnd Burst.
      medium accuracy.
      projectiles burn unshielded targets.
*/
#ifdef SSQC
void() data_ini_attack_plasma_;
#endif
#ifdef CSQC
void() te_muzzle_rpc={
  local vector startOrg;
  local vector endOrg;
  
  startOrg =self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  sound7(self, CHAN_AUTO, "sound/weapons/rpls_fire.ogg", 1, ATTN_NORM, (0.65 + (random() * 0.35)) * 125, 0 );
  pointparticles( particleeffectnum("TE_RPC_MUZZLE"), startOrg, normalize(endOrg - startOrg) * 2, 1);
}
#endif
void() data_ini_plasma_={

  self.data_idx = UID_ITEM_rotary_plasma;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.55; //0.45
  self.reloadMax = 0.55; //0.45
  self.energyRate = 0;
  
  self.w_range = 1800;
  self.damageValue = 18;
  self.damageType = DMG_BAL;
  
  self.techLevel = 3;
  self.equipSize = BAL2;
  
  self.wepFireOffset = '0 0 6';
  self.spreadDefault = '0.0075 0.0075 0';
  self.burstRate = 1.5;
  
#ifdef CSQC  
  self.w_name = "Rotary Plasma Chamber";
  self.fire_sound = "sound/weapons/rpls_fire.ogg";
  self.model = "q3mdl/weapons/w_rpc.md3";
  self.abbrev = "RPC";
  self.description = "+ Will burn over time on unshielded hit. + inhibits target shield regen when burning.";
  self.icon = "gfx/ui/wep_icons/wi_rpc.png";
  self.itemMuzzleFlash = te_muzzle_rpc;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_plasma_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_plasma_;
  self.spreadCache = self.spreadDefault;
#endif
};

#ifdef SSQC
void() data_ini_attack_plasma_={

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
  
  ctrl_weapon_make_projectile( -1 );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif