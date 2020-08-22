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

#ifdef CSQC
void() te_muzzle_pac={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.origin + v_forward * self.wepFireOffset_z;
  traceline(startOrg, startOrg + (v_forward * self.w_range), FALSE, self.owner);
  endOrg = trace_endpos;
  
  pointsound( startOrg, "sound/weapons/pac_fire.ogg", 1, ATTN_NORM);
  
  if( vlen(endOrg - startOrg) >= 1500 ){
    pointsound( endOrg, "sound/weapons/pac_fire.ogg", 0.5, ATTN_NORM);
  }
  
  pointparticles( particleeffectnum("TE_PAC_MUZZLE"), startOrg, normalize(endOrg - startOrg) * 2, 1);
};
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
    self.description = "+ Instant-impact weapon. + Bypasses a % of target shields. + Lower shields on target yields higher armor damage. + better against [large] targets.";
    self.icon = "gfx/ui/wep_icons/wi_pac.png";
    self.itemMuzzleFlash = te_muzzle_pac;
  #endif 
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.think = default_weapon_think;
    self.w_attack = data_ini_attack_particle_cannon_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_particle_cannon_={
  local vector strikePoint;
  local float oldShields;
  local entity thisTarget;
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
      dmgArmor = dmgArmor - dmgShield;
      if( trace_ent.shield < 0 ){
        trace_ent.shield = 0;
      }
      if(trace_ent.vec_size <= 1){
        dmgArmor = dmgArmor * 0.33;
      }
      if(trace_ent.vec_size == 2){
       dmgArmor = dmgArmor * 0.5;
      }
    }
    
    thisTarget = trace_ent;
    oldShields = thisTarget.shield;
    thisTarget.shield = 0;
    t_damage(trace_ent, self, FIRE_ENT, dmgArmor, FIRE_ENDPOINT + (v_forward*3), '0 0 0');
    if( oldShields > 0 &&  thisTarget.deadflag <= DEAD_NO ){
      thisTarget.shield = oldShields;
    }
  }
  client_send_weapon_flash( self.w_group, num_for_edict(self.owner), FIRE_ENDPOINT);
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif