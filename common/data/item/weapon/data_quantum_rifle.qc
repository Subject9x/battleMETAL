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

float DAT_QRFL_QBITS = 8; 

void() data_ini_attack_quantum_;

void() data_ini_quantum_={

  self.data_idx = 5;  
  self.w_name = "Quantum Rifle";
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 5;
  self.energyRate = 10;
  self.spreadDefault = '0.005 0.005 0';
  
  self.w_range = 2000;
  self.p_damage = 10;
  self.p_dmgtype = (DMG_ENE | EFF_STX | EFF_ENE);
  
  self.w_attack = data_ini_attack_quantum_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_quantum_bit_;
  
  self.w_fire_ofs = '0 0 2';
  self.fire_sound = "sound/weapons/qrfl_fire.ogg";
  self.model = "q3mdl/weapons/w_qrf.md3";
  self.techLevel = 2;
  self.i_size = 1;
};

void() data_ini_attack_quantum_={
  local float qbits;
  local vector hitZone;
  local vector hitMin;
  local vector hitMax;
  local vector rando;

  local vector prtclRail_org;
  local vector prtclRail_end;
  local vector prtclSpark_org;
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }
  
  ctrl_weapon_fireOffset();  
  
  ctrl_weapon_updateAmmo( FALSE, 0 );
 
  hitZone = FIRE_ENDPOINT;
  hitMax = '25 25 25';
  hitMin = '-25 -25 -25';
  if( trace_ent.takedamage ){
    hitZone = trace_ent.origin;
    hitMin = trace_ent.mins * 2;
    hitMax = trace_ent.maxs * 2;
  }

  if( self.data_ini_projectile ){
    qbits = DAT_QRFL_QBITS;
    while(qbits > 0){
      ctrl_weapon_make_projectile( -1 );
        rando = randomvec();
        rando_x = hitZone_x + (hitMin_x - rando_x * hitMin_x) + (hitMax_x + random() * hitMax_x);
        rando_y = hitZone_y + (hitMin_y - rando_y * hitMin_y) + (hitMax_y + random() * hitMax_y);
        rando_z = hitZone_z + (hitMin_z - rando_z * hitMin_z) + (hitMax_z + random() * hitMax_z);
        NEWSHOT.velocity = normalize(hitZone - rando);
        NEWSHOT.velocity = NEWSHOT.velocity * NEWSHOT.p_velocity;
        NEWSHOT.angles = vectoangles(NEWSHOT.velocity);
        if(pointcontents(rando) != CONTENT_SOLID){
          setsize(NEWSHOT, '0 0 0', '0 0 0');
          setorigin(NEWSHOT, rando);
          qbits = qbits - 1;
        }
    }
  }

  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  prtclRail_org = FIRE_ORIGIN + (v_forward * 2);
  prtclRail_end = FIRE_ORIGIN + (v_forward * 48);
  prtclSpark_org = FIRE_ORIGIN + (v_forward * 22);
  
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE"), prtclRail_org, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ), 1);
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org + (v_right * 0.5), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 30, 1);
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org - (v_right * 0.5), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 30, 1);
  trailparticles( self, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org + (v_right * 0.5), prtclRail_end + (v_right * 0.5));
  trailparticles( self, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org - (v_right * 0.5), prtclRail_end - (v_right * 0.5));
};
