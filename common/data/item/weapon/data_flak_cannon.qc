/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Weapon
    Flak Cannon
      Range: Long
      Rapid fire
      low accuracy
      small AoE when shields are gone
*/
float DAT_FLAK_SHRAP_TOTAL    = 10;
#ifndef CSQC
vector DAT_FLAK_SHRAP_SPREAD  = '0.2 0.2 64';
float DAT_PRJ_FLAK_PROXYRAD   = 45;
float DAT_PRJ_FLAK_EXPRAD     = 50;
void() data_ini_attack_flak_;
#endif

void() data_ini_flak_cannon_={

  self.data_idx = 12;  
  
  self.w_clipsize = 1;
  self.reloadRate = 0.6;
  self.reloadMax = 0.6;
  self.energyRate = 0;
  
  self.w_range = 2000;
  self.damageValue = 2.33;
  self.damageType = DMG_BAL;
  
  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '0.017 0.015 0';
  self.wepFireOffset = '0 0 5';
  
  #ifdef CSQC
    self.w_name = "Flak Cannon";
    self.fire_sound = "sound/weapons/flak_fire.ogg";
    self.model = "q3mdl/weapons/w_flk.md3";
    self.damageValue = self.damageValue * DAT_FLAK_SHRAP_TOTAL;
    self.abbrev = "FLAK";
    self.description = "+ Instant-impact weapon. + Shotgun Damage pattern when Target has no <shields>. + 8 sub-munitions.";
    self.icon = "gfx/ui/wep_icons/wi_flak.png";
  #endif
  
  #ifndef CSQC
    self.burstRate = 2;
    self.w_isburst = FALSE;
    self.model = "q3mdl/weapons/w_flk.md3";
    self.w_attack = data_ini_attack_flak_;
    self.think = default_weapon_think;
  #endif
};

#ifndef CSQC
void() data_ini_attack_flak_={
  local float totes;
  local float shieldDamage;
  local float impactStyle;
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }  
  
  if( !trace_ent.takedamage ){
    if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) ){
      impactStyle = IMPACT_DIRT;
    }
  }
  else{
    if(trace_ent && trace_ent != world){
      totes = DAT_FLAK_SHRAP_TOTAL;
      if(trace_ent.shield > 0){
        shieldDamage = (self.damageValue * totes) / 2;
        t_damage(trace_ent, self, self.owner, shieldDamage, trace_endpos, '0 0 0');
        impactStyle = IMPACT_SHIELD;
      }
      else{
        impactStyle = IMPACT_ARMOR;
        if( trace_ent.data_type == DATA_MECH ){
          local vector shotpoint;
          local vector shrapPoint;
          local vector shotDir;
          local vector shrapDir;
          
          shotpoint = trace_endpos + (v_forward * -32);
          shotDir = normalize(trace_endpos - shotpoint);
          while(totes > 0){
            shrapDir = shotDir + (crandom()*DAT_FLAK_SHRAP_SPREAD_x*v_right) + (crandom()*DAT_FLAK_SHRAP_SPREAD_y*v_up);
            shrapPoint = shotpoint + shrapDir*DAT_FLAK_SHRAP_SPREAD_z;
            traceline( shotpoint, shrapPoint, FALSE, self.owner);
            t_damage(trace_ent, self, self.owner, self.damageValue, trace_endpos, '0 0 0');
            totes = totes - 1;
          }
        }
        else{
          t_damage(trace_ent, self, self.owner, self.damageValue * totes, trace_endpos, '0 0 0');
        }
      }
    }
  }
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, impactStyle);
};
#endif