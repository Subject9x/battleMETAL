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
#ifndef CSQC
void() data_ini_attack_missile_activeradar_;
#endif 

#ifdef CSQC
void() te_muzzle_marh={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.origin + v_forward * self.wepFireOffset_z;
  traceline(startOrg, startOrg + (v_forward * self.w_range), FALSE, self.owner);
  endOrg = trace_endpos;
  pointsound( startOrg, "sound/weapons/arh_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ARH_MUZZLE"), startOrg, normalize( startOrg - endOrg ) * 1, 1);
};
#endif
void() data_ini_missile_activeradar_={

  self.data_idx = 10;  
  
  self.w_clipsize = 1;    //4
  self.reloadRate = 5; //0.18
  self.reloadMax = 5;     //5
  self.energyRate = 0;
  
  self.w_range = 4000;
  self.damageValue = 99;  //33
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
  self.description = "+ target <shields> reduce damage. + Requires <Active Radar> on. + Minimum Range of 300m. + stronger against [small] targets.";
  self.icon = "gfx/ui/wep_icons/wi_marh.png";
  self.itemMuzzleFlash = te_muzzle_marh;
#endif

#ifndef CSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_missile_activeradar_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_missile_active_radar_;
#endif
};

#ifndef CSQC
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
      if( util_checkPointAngleImpl(self.enemy.origin) ){
        if( (self.targLockState & LOCK_TARG_HAS) ){
          canFire = TRUE;
        }
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
    NEWSHOT.lastorigin = self.owner.enemy.origin;
    NEWSHOT.dest = FIRE_ENDPOINT;
    setorigin(NEWSHOT, start);
    NEWSHOT = world;
    self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  }
};
#endif