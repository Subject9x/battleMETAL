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

#ifndef CSQC
void() data_ini_attack_quantum_;
#endif

void() data_ini_quantum_={

  self.data_idx = 5;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 3;
  self.energyRate = 0;
  
  self.w_range = 2000;
  self.damageValue = 4;
  self.damageType = DMG_BAL;
  
  self.techLevel = 2;
  self.equipSize = 1;
 
  self.spreadDefault = '0.005 0.005 0';
  self.wepFireOffset = '0 0 2';
  
  #ifdef CSQC
    self.w_name = "Quantum Rifle";
    self.fire_sound = "sound/weapons/qrfl_fire.ogg";
    self.model = "q3mdl/weapons/w_qrf.md3";
    self.damageValue = (DAT_QRFL_QBITS * self.damageValue) / 3 + 15;
    self.abbrev = "QRF";
    self.description = "+ Instant-impact weapon. + Initial damage on-hit. + 8 sub-munitions. + sub-munitions home on impact spot.";
    self.icon = "gfx/ui/wep_icons/wi_qrf.png"; 
    setmodel(self, self.model);
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
  local vector hitZone;
  local vector hitMin;
  local vector hitMax;
  local vector rando;

  ctrl_weapon_fireOffset();  
  
  ctrl_weapon_updateAmmo( FALSE );
 
  hitZone = FIRE_ENDPOINT;
  hitMax = '25 25 25';
  hitMin = '-25 -25 -25';
  
  if( trace_ent.takedamage ){
    hitZone = trace_ent.origin;
    hitMax = trace_ent.maxs * 3;
    if( (self.owner.flags & FL_CLIENT) ){
      t_damage(trace_ent, self, FIRE_ENT, 15, self.damageType, FIRE_ENDPOINT, '0 0 0');
    }
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, 0);
  
  if( self.data_ini_projectile ){
    if( (self.owner.flags & FL_CLIENT) ){
      qbits = DAT_QRFL_QBITS;
    }
    else{
      qbits = rint(DAT_QRFL_QBITS * 0.33);
    }
    
    for( qbits = DAT_QRFL_QBITS; qbits > 0; qbits = qbits - 1){
      rando = randomvec();
      rando_x = hitZone_x + (hitMax_x * crandom()) * 3;
      rando_y = hitZone_y + (hitMax_y * crandom()) * 2;
      rando_z = hitZone_z + (hitMax_z * crandom()) * 3;
      if(pointcontents(rando) < CONTENT_EMPTY){
        continue;
      }
      ctrl_weapon_make_projectile( 6 );
      NEWSHOT.velocity = normalize(hitZone - rando);
      NEWSHOT.velocity = NEWSHOT.velocity * NEWSHOT.data_velocity;
      NEWSHOT.angles = vectoangles(NEWSHOT.velocity);
      setsize(NEWSHOT, '0 0 0', '0 0 0');
      setorigin(NEWSHOT, rando);
    }
  }
};
#endif