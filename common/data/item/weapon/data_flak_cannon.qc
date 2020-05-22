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
float DAT_FLAK_SHRAP_TOTAL  = 4;
#ifndef CSQC
vector DAT_FLAK_SHRAP_SPREAD  = '0.2 0.2 64';
void() data_ini_attack_flak_;
#endif

void() data_ini_flak_cannon_={

  self.data_idx = 12;  
  
  self.w_clipsize = 4;
  self.reloadRate = 0.15;
  self.reloadMax = 2;
  self.energyRate = 0;
  
  self.w_range = 500;
  self.damageValue = 2.5; //2
  self.damageType = DMG_BAL;
  
  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '0.07 0.07 0';
  self.wepFireOffset = '0 0 5';
  
  #ifdef CSQC
    self.w_name = "Flak Cannon";
    self.fire_sound = "sound/weapons/flak_fire.ogg";
    self.model = "q3mdl/weapons/w_flk.md3";
    self.damageValue = self.damageValue * DAT_FLAK_SHRAP_TOTAL;
    self.abbrev = "FLAK";
    self.description = "+ Instant-impact weapon. +4-rnd burst. +  shotgun damage pattern. + 4 sub-munitions.";
    self.icon = "gfx/ui/wep_icons/wi_flak.png";
  #endif
  
  #ifndef CSQC
    self.burstRate = 1;
    self.w_isburst = FALSE;
    self.model = "q3mdl/weapons/w_flk.md3";
    self.w_attack = data_ini_attack_flak_;
    self.think = default_weapon_think;
  #endif
};

#ifndef CSQC
void() data_ini_attack_flak_={
  local float impactStyle;
  local vector cacheSpread;
  local vector direction;
  local vector src;
  local vector dir;
  local float hit;
  local float totes;
      
  cacheSpread = self.spreadDefault;
  self.spreadDefault = '0 0 0';
  
  ctrl_weapon_fireOffset();

  self.spreadDefault = cacheSpread;

  ctrl_weapon_updateAmmo( TRUE );
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }  
  totes = DAT_FLAK_SHRAP_TOTAL;
  
  src = self.origin + v_forward*2;
  dir = normalize(FIRE_ENDPOINT - src);
  while (totes > 0){
    direction = dir + crandom()*self.spreadDefault_x*v_right + crandom()*self.spreadDefault_y*v_up;
    traceline (src, src + direction*self.w_range, FALSE, self.owner);
    if( (random() * 1) <= 0.3 ){
      client_send_particle_rail( num_for_edict(self), particleeffectnum("TE_FLK_TRAIL"), src, src + direction*self.w_range );
    }
    if( trace_ent.takedamage ){
      if( trace_ent.shield > 0){
        impactStyle = IMPACT_SHIELD;
        t_damage_shield(trace_ent, self,self.owner, (self.damageValue * 0.85), trace_endpos, FALSE);
        client_send_particle( particleeffectnum("TE_SHIELD_HIT_HIGH"), trace_endpos, '0 0 0', 1 );
      }
      else{
        impactStyle = IMPACT_ARMOR;
        t_damage(trace_ent, self, self.owner, self.damageValue, trace_endpos, '0 0 0');
        client_send_particle( particleeffectnum("TE_FLK_IMPACT"), trace_endpos, normalize(trace_endpos - self.origin) * 2, 1 );
      }
    }
    else{
      client_send_particle( particleeffectnum("TE_FLK_DIRT"), trace_endpos, normalize(trace_endpos - self.origin) * 2, 1 );
    }
    totes = totes - 1;
  }
  
  client_send_muzzle_flash( self.data_idx, FIRE_ORIGIN, FIRE_ENDPOINT, 0);
};
#endif