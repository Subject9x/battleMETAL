/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Missile - Swarm
      Range: short
      3rnd burst
      Arcing
      3mis per up-to 3 targets
      
      NEW IDEA - 5/7/2020
      big clip,
      hold-trigger-down fire,
      long reload
      proxy-det
      long-range
      slight arc
*/
#ifdef SSQC
void() data_ini_attack_missile_swarm_;
#endif

#ifdef CSQC
void() te_muzzle_swrm={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  sound7(self, CHAN_AUTO, "sound/weapons/arh_fire.ogg", 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 165, 0 );
  
  pointparticles( particleeffectnum("TE_SWRM_MUZZLE"), startOrg, normalize( endOrg - startOrg ) * 3, 1);
}
#endif
void() data_ini_missile_swarm_={

  self.data_idx = UID_ITEM_missile_swarm;
  
  self.w_clipsize = 9;
  self.reloadRate = 0.13;
  self.reloadMax = 7;
  self.energyRate = 0;
  
  self.w_range = 1500;
  self.damageValue = 10;
  self.damageType = DMG_EXP | EFF_ARC | EFF_PTR | EFF_LOK;
 
  self.techLevel = 3;
  self.equipSize = MIS2;

  self.spreadDefault = '0.01 0.01 0';
  self.wepFireOffset = '0 0 1';
  self.burstRate = 1;
  
#ifdef CSQC
  self.w_name = "Missile - Swarm";
  self.fire_sound = "sound/weapons/arh_fire.ogg";
  self.model = "q3mdl/weapons/w_swrm.md3";
  self.abbrev = "SWRM";
  self.description = "+ target <shields> reduce damage. + Burst-fire. + Missiles will either lock-on to your Target | OR | Fire straight forward.";
  self.icon = "gfx/ui/wep_icons/wi_swrm.png"; 
  self.itemMuzzleFlash = te_muzzle_swrm;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_missile_swarm_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_missile_swarm_;
#endif
};

#ifdef SSQC
void() data_ini_attack_missile_swarm_={
  local entity hold;
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );
   
  self.owner.punchangle_x = -0.1 + crandom() * -0.1;
  self.owner.punchangle_y = -0.1 + crandom() * -0.1;
  
  ctrl_weapon_make_projectile( -1 );
  
  if( ai_valid_target(self.owner.enemy) ){
    hold = self;
    self = hold.owner;
    if( util_checkPointAngleImpl(self.enemy.origin) ){
      NEWSHOT.enemy = self.enemy;
      NEWSHOT.stat_rdr_mode = NEWSHOT.enemy.stat_rdr_mode;
    }
    self = hold;
  }
  NEWSHOT = world;
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif