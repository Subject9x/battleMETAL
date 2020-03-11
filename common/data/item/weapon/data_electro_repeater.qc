/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Electro-Static Repeater
      Range - Short
      Consumes Energy
      hit scan
      Inaccurate
      spin up and cooldown
*/
float DATA_ESR_BEAM_COUNT = 3;
float DATA_ESR_COOLDOWN_MAX = 2;

#ifndef CSQC
void() data_ini_attack_electro_repeater_;
#endif 

void() data_ini_electro_repeater_={
  
  self.data_idx = 8;
  self.w_name = "ESR";
  
  self.w_clipsize = 1;
  self.reloadRate = 0.23;
  self.reloadMax = 0.23;
  self.energyRate = 18;
  
  self.w_range = 450;
  self.damageValue = 7;
  self.damageType = DMG_ENE;

  self.techLevel = 2;
  self.equipSize = 2;

  #ifdef CSQC  
  self.abbrev = "ESR";
  self.description = "+ 3 beams per trigger pull. + Instant-impact weapon. + Inaccurate.";
  self.icon = "gfx/ui/wep_icons/wi_esr.png";
  #endif
  
  #ifndef CSQC
  self.spreadDefault = '0.15 0.2 0';
  self.w_isburst = FALSE;
  self.burstRate = 0;
  self.wepFireOffset = '0 0 6'; 
  self.fire_sound = "sound/weapons/esr_fire.ogg";
  self.model = "q3mdl/weapons/w_esr.md3";
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_electro_repeater_;
  #endif
  
};

#ifndef CSQC
void() data_ini_attack_electro_repeater_={
  local float impactStyle;
  
  if( !ctrl_weapon_checkEnergy() ){
    
    return;
  }
  //ctrl_weapon_updateAmmo( FALSE );
  
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.reloadValue = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
  }
  else{
    if( (FIRE_ENT.flags & FL_MONSTER) ){
      self.w_firetime = time + (self.reloadRate / self.burstRate) * 1.67;
    }
    else{
      self.w_firetime = time + self.reloadRate / self.burstRate;
    }
    self.w_state = RECOIL;
    self.w_isburst = FALSE;
  }
  ctrl_weapon_fireOffset();


  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, FIRE_ENT, self.damageValue, DMG_ENE, FIRE_ENDPOINT, '0 0 0');
    if( trace_ent.shield > 0 ){
      impactStyle = 1;
      client_send_particle( particleeffectnum("TE_ESR_IMPACT_SHIELD"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
    else{
      impactStyle = 2;
      client_send_particle( particleeffectnum("TE_ESR_IMPACT_ARMOR"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
    }
  }
  else{
    impactStyle = 3;
    client_send_particle( particleeffectnum("TE_ESR_IMPACT_DIRT"), FIRE_ENDPOINT + v_up * 1, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1, 1);
  }
  
  
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle);
};
#endif