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

float DAT_QRFL_QBITS = 10; 
vector DAT_QRFL_SPREAD = '0.085 0.085 0';
#ifndef CSQC
void() data_ini_attack_quantum_;
#endif

void() data_ini_quantum_={

  self.data_idx = 5;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 5;
  self.energyRate = 0;
  
  self.w_range = 1000;
  self.damageValue = 15;
  self.damageType = DMG_BAL;
  
  self.techLevel = 2;
  self.equipSize = BAL1;
 
  self.spreadDefault = '0 0 0';
  self.wepFireOffset = '0 0 2';
  
  #ifdef CSQC
    self.w_name = "Quantum Rifle";
    self.fire_sound = "sound/weapons/qrfl_fire.ogg";
    self.model = "q3mdl/weapons/w_qrf.md3";
    self.damageValue = (DAT_QRFL_QBITS * self.damageValue) / 3 + 15;
    self.abbrev = "QRF";
    self.description = "+ Instant-impact weapon. + Initial damage on-hit. + 8 sub-munitions. + sub-munitions home on impact spot.";
    self.icon = "gfx/ui/wep_icons/wi_qrf.png"; 
  #endif 
  
  #ifndef CSQC
    self.w_isburst = FALSE;
    self.burstRate = 0;
    self.model = "q3mdl/weapons/w_qrf.md3";
    self.w_attack = data_ini_attack_quantum_;
    self.think = default_weapon_think;
    self.data_ini_projectile = data_projectile_ini_quantum_bit_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_quantum_={
  local float qbits;
  local vector dir;
  local vector qbdir;
  local float qdmgShield;
  local float qdmgShieldTotal;
  local float qdmg;
  
  ctrl_weapon_fireOffset();  
  
  ctrl_weapon_updateAmmo( FALSE );
 
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, 0);
  
  dir = normalize(FIRE_ENDPOINT - FIRE_ORIGIN);

  if( (self.owner.flags & FL_CLIENT) ){
    qbits = DAT_QRFL_QBITS;
  }
  else{
    qbits = rint(DAT_QRFL_QBITS * 0.5);
  }
 
  while( qbits > 0 ){
    qbdir = dir + crandom()*DAT_QRFL_SPREAD_x*v_right + crandom()*DAT_QRFL_SPREAD_y*v_up;
    traceline(self.origin, self.origin + qbdir*self.w_range, FALSE, self);
    if( trace_fraction != 1.0 ){
      qdmg = self.damageValue;
      if(trace_ent.shield > 0 ){
        qdmgShield = min((trace_ent.shield/trace_ent.shieldMax), 0.5);
        qdmgShieldTotal = qdmgShieldTotal + (self.damageValue * qdmgShield);
        qdmg = qdmg - (self.damageValue * qdmgShield);
      }
      t_damage(trace_ent, self, self.owner, qdmg, trace_endpos, '0 0 0');
    }
    trailparticles(world, particleeffectnum("TE_QRFL_QBIT_TRAIL"), FIRE_ORIGIN, trace_endpos);
    qbits = qbits - 1;
  }
  if(trace_ent.health > 0 ){
    trace_ent.shield = trace_ent.shield - qdmgShieldTotal;
  }
};
#endif