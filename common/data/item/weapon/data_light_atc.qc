/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Item - Weapon
    Light Autocannon
      Range: Long
      Rapid fire
      low accuracy
*/
#ifndef CSQC
void() data_ini_attack_latc_;
#endif

void() data_ini_light_atc_={

  self.data_idx = 1;  
  self.w_name = "Light Autocannon";
  
  self.w_clipsize = 3;
  self.reloadRate = 0.075;
  self.reloadMax = 1.15;
  self.energyRate = 0;
  
  self.w_range = 1800;
  self.damageValue = 6.67;
  self.damageType = DMG_BAL;

  self.techLevel = 1;
  self.equipSize = 1;
  
  #ifdef CSQC  
  self.abbrev = "ATC";
  self.description = "+ Instant-impact weapon. + 3-round burst.";
  self.icon = "gfx/ui/wep_icons/wi_atc.png";
  #endif
  
  #ifndef CSQC  
  self.spreadDefault = '0.025 0.025 0';
  self.w_attack = data_ini_attack_latc_;
  self.think = default_weapon_think;
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.wepFireOffset = '0 0.5 5';
  self.fire_sound = "sound/weapons/atc_fire.ogg";
  self.model = "q3mdl/weapons/w_atc.md3";
  #endif
};

#ifndef CSQC
void() data_ini_attack_latc_={
  local float impactStyle;
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( TRUE );

  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }
  else{
    if( !trace_ent.takedamage ){
      if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) ){
        impactStyle = 3;
      }
    }
    else{
      if( trace_ent ){
        t_damage(trace_ent, self, FIRE_ENT, self.damageValue, DMG_BAL, FIRE_ENDPOINT, '0 0 0');    
        if( trace_ent.shield <= 0 ){
          impactStyle = 2;
        }
      }
    }
    
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle);  
};
#endif