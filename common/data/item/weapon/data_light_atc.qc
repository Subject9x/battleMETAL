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
  
  self.w_clipsize = 3;
  self.reloadRate = 0.12;
  self.reloadMax = 1.5;
  self.energyRate = 0;
  
  self.w_range = 3200;
  self.damageValue = 12;
  self.damageType = DMG_BAL;

  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '0.025 0.025 0';
  self.wepFireOffset = '0 0.5 5'; 
  
  #ifdef CSQC  
    self.w_name = "Light Autocannon";
    self.abbrev = "ATC";
    self.description = "+ Instant-impact weapon. + 3-round burst. + Better against <Armor>.";
    self.icon = "gfx/ui/wep_icons/wi_atc.png";
    self.model = "q3mdl/weapons/w_atc.md3";
    self.fire_sound = "sound/weapons/atc_fire.ogg";
    self.wepFireOffset = '0 0.5 5';
  #endif
  
  #ifndef CSQC  
    self.w_attack = data_ini_attack_latc_;
    self.think = default_weapon_think;
    self.w_isburst = FALSE;
    self.burstRate = 1;
    self.model = "q3mdl/weapons/w_atc.md3"; //todo - move client side only
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
        impactStyle = IMPACT_DIRT;
      }
    }
    else{
      if( trace_ent ){
        if( trace_ent.shield > 0 ){
          t_damage_shield(trace_ent, self,self.owner, self.damageValue, trace_endpos, FALSE); 
          impactStyle = IMPACT_SHIELD;
        }
        else{
          t_damage(trace_ent, self, FIRE_ENT, self.damageValue * 1.75, FIRE_ENDPOINT, '0 0 0');
          impactStyle = IMPACT_ARMOR;
        } 
      }
    }
    
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle);  
};
#endif