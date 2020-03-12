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

void() data_ini_missile_activeradar_={

  self.data_idx = 10;  
  
  self.w_clipsize = 10;
  self.reloadRate = 0.24;
  self.reloadMax = 5.5;
  self.energyRate = 0;
  
  self.w_range = 1500;
  self.damageValue = 15;
  self.damageType = (DMG_EXP | EFF_ARC | EFF_LOK);
 
  self.techLevel = 2;
  self.equipSize = 3;
  
  self.spreadDefault = '0.03 0.03 0';
  self.wepFireOffset = '0 0 2';
  
  #ifdef CSQC  
    self.w_name = "Missile - Active Radar";
    self.fire_sound = "sound/weapons/mis_fire.ogg";
    self.model = "q3mdl/weapons/w_arh.md3";
    self.abbrev = "MARH";
    self.description = "+ Requires <Active Radar> on. + Requires <Target Lock> on target. + Minimum Range of 300m.";
    self.icon = "gfx/ui/wep_icons/wi_marh.png";
    setmodel(self, self.model);
  #endif
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 1;
    self.model = "q3mdl/weapons/w_arh.md3";
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
  
  canFire = FALSE;
  
  if( self.w_isburst == TRUE ){
    canFire = TRUE;
  }
  else{
    if( (self.owner.stat_lck_stt & LOCK_TARG_HAS) ){
      //check to see if owner has a target lock
      canFire = TRUE;
    }  
  }
  
  if( canFire ){
    ctrl_weapon_updateAmmo( TRUE );
  
    ctrl_weapon_fireOffset();
    
    arc = FIRE_ORIGIN + (v_forward * (300 + (crandom() * 20)));
    arc = arc + (v_up * (300 + (crandom() * 20))) + (v_right * (crandom() * 20));
    arc = arc + (v_right * (crandom() * 20));
   
    start = FIRE_ORIGIN + (v_forward * 0.75) + ((crandom() * 1.25) * v_right) + (v_up * (crandom() * 1.5));
 
    ctrl_weapon_make_projectile( 0.15 );
    NEWSHOT.compOffset = start;
    NEWSHOT.enemy = self.owner.enemy;
    NEWSHOT.velocity = '0 0 0';
    NEWSHOT.velocity = normalize( arc - start );
    NEWSHOT.velocity = NEWSHOT.velocity * 50;
    NEWSHOT.angles = vectoangles( NEWSHOT.velocity );
    NEWSHOT.w_isburst = time + 4; //use to track curving behavior
    setorigin(NEWSHOT, start);
    NEWSHOT = world;
    
    client_send_muzzle_flash( self.data_idx, start, arc, 0 );
  }
};
#endif