/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Particle Cannon
      Range - Long
      Consumes Energy
      High Damage
      Single shot
      hit scan
*/
#ifndef CSQC
void() data_ini_attack_particle_cannon_;
#endif

void() data_ini_particle_cannon_={
  
  self.data_idx = 7;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 7.5;
  self.energyRate = 300;

  self.w_range = 3000;
  self.damageValue = 200;
  self.damageType = DMG_ENE;
 
  self.techLevel = 3;
  self.equipSize = ENE3;
  
  self.spreadDefault = '0.0025 0.0025 0';
  self.wepFireOffset = '0 0 6.75'; 
  
  #ifdef CSQC
    self.w_name = "PAC";
    self.fire_sound = "sound/weapons/pac_fire.ogg";
    self.model = "q3mdl/weapons/w_pac.md3";
    self.abbrev = "PAC";
    self.description = "+ Instant-impact weapon. + Bypasses a % of target shields. + Lower shields on target yields higher armor damage.";
    self.icon = "gfx/ui/wep_icons/wi_pac.png"; 
  #endif 
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.model = "q3mdl/weapons/w_pac.md3";
    self.think = default_weapon_think;
    self.w_attack = data_ini_attack_particle_cannon_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_particle_cannon_={
  local vector strikePoint;
  local float oldShields;
  local entity thisTarget;
  local float impactStyle;
  local float dmgArmor, dmgShield;
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );

  strikePoint = FIRE_ENDPOINT + (v_forward * -5);
  
  if( trace_ent.takedamage ){
    dmgArmor = self.damageValue;
    dmgShield = self.damageValue;
    if( trace_ent.shield > 0 ){
      if( trace_ent.shield <= (trace_ent.shieldMax * 0.25) ){
        dmgShield = dmgShield * 0.25;
      }
      else if( trace_ent.shield > (trace_ent.shieldMax * 0.25) ){
        dmgShield = dmgShield * 0.5;
      }
      trace_ent.shield = trace_ent.shield - dmgShield;
      if( trace_ent.shield < 0 ){
        trace_ent.shield = 0;
      }
      dmgArmor = dmgArmor - dmgShield;
      impactStyle = IMPACT_SHIELD;
    }
    else{
     impactStyle = IMPACT_ARMOR;
    }
    
    thisTarget = trace_ent;
    oldShields = thisTarget.shield;
    thisTarget.shield = 0;
    t_damage(trace_ent, self, FIRE_ENT, dmgArmor, FIRE_ENDPOINT + (v_forward*3), '0 0 0');
    if( oldShields > 0 &&  thisTarget.deadflag <= DEAD_NO ){
      thisTarget.shield = oldShields;
    }
  }
  else{
    impactStyle = IMPACT_DIRT;
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle);
};
#endif