/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Missile - Active Radar
      Range: Long
      10rnd burst
      Arcing
      Needs radar lock
*/
#ifdef SSQC
void() data_ini_attack_missile_activeradar_;
#endif 

#ifdef CSQC
void() te_muzzle_marh={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  sound7(self, CHAN_AUTO, "sound/weapons/arh_fire.ogg", 1, ATTN_NORM, (0.65 + (random() * 0.35)) * 90, 0 );
  
  pointparticles( particleeffectnum("TE_ARH_MUZZLE"), startOrg, normalize( startOrg - endOrg ) * 1, 1);
};
#endif
void() data_ini_missile_activeradar_={

  self.data_idx = UID_ITEM_missile_activeradar;
  
  self.w_clipsize = 1;
  self.reloadRate = 8;
  self.reloadMax = 8;
  self.energyRate = 0;
  
  self.w_range = 4000;
  self.damageValue = 150; //125
  self.damageType = (DMG_EXP | EFF_ARC | EFF_LOK);
 
  self.techLevel = 2;
  self.equipSize = MIS3;
  
  self.spreadDefault = '0.03 0.03 0';
  self.wepFireOffset = '0 0 2';
  self.burstRate = 1;
  
#ifdef CSQC  
  self.w_name = "Missile - Active Radar";
  self.fire_sound = "sound/weapons/arh_fire.ogg";
  self.model = "q3mdl/weapons/w_arh.md3";
  self.abbrev = "MARH";
  self.description = "+ Requires <Active Radar> on. + Requires target acquired. + You must be facing target. + stronger against [small] targets.";
  self.icon = "gfx/ui/wep_icons/wi_marh.png";
  self.itemMuzzleFlash = te_muzzle_marh;
#endif

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_missile_activeradar_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_missile_active_radar_;
#endif
};

#ifdef SSQC
void() data_ini_attack_missile_activeradar_={
  local vector arc; //calculate the initial arc value before lock-on adjustment
  local vector start;
  local float canFire;
  local entity hold;
  
  canFire = FALSE;
  
  if( self.w_isburst == TRUE ){
    canFire = TRUE;
  }
  else{
    if( ai_valid_target(self.owner.enemy) ){
      hold = self;
      self = hold.owner;
      if( util_checkPointAngleImpl(self.enemy.origin) && self.stat_rdr_mode == TRUE){
        canFire = TRUE;
      }
      self = hold;
    }
  }
  
  if( canFire ){
    ctrl_weapon_updateAmmo( FALSE );
  
    ctrl_weapon_fireOffset();
    
    arc = FIRE_ORIGIN + (v_forward * (600 + (crandom() * 20)));
    arc = arc + (v_up * (600 + (crandom() * 20)));
    arc = arc + (v_right * (crandom() * 20));
   
    start = FIRE_ORIGIN + (v_forward * 0.75) + ((crandom() * 1.25) * v_right) + (v_up * (crandom() * 1.5));
 
    ctrl_weapon_make_projectile( -1 );
    NEWSHOT.compOffset = start;
    NEWSHOT.enemy = self.owner.enemy;
    NEWSHOT.velocity = '0 0 0';
    NEWSHOT.velocity = normalize( arc - start );
    NEWSHOT.velocity = NEWSHOT.velocity * NEWSHOT.data_velocity;
    NEWSHOT.avelocity = '0 0 45';
    NEWSHOT.w_isburst = time + 0.65; //use to track curving behavior
    NEWSHOT.stat_rdr_mode = self.owner.enemy.stat_rdr_mode;
    NEWSHOT.isActive =  self.owner.enemy.stat_rdr_mode;
    NEWSHOT.last_origin = self.owner.enemy.origin;
    NEWSHOT.dest = FIRE_ENDPOINT;
    setorigin(NEWSHOT, start);
    NEWSHOT = world;
    self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  }
};
#endif