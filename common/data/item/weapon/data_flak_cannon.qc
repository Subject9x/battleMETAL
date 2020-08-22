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

#ifdef CSQC
void() te_muzzle_flk={
  local vector startOrg;
  local vector endOrg;
  
  startOrg = self.origin + v_forward * self.wepFireOffset_z;
  traceline(startOrg, startOrg + (v_forward * self.w_range), FALSE, self.owner);
  endOrg = trace_endpos;
  
  if( vlen(endOrg - startOrg) >= 1500 ){
    pointsound( endOrg, "sound/weapons/flak_fire.ogg", 0.5, ATTN_NORM);
  }
  pointsound( startOrg, "sound/weapons/flak_fire.ogg", 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_FLK_MUZZLE"), startOrg, normalize(endOrg - startOrg) * 4, 1);
};
#endif
void() data_ini_flak_cannon_={

  self.data_idx = 12;  
  
  self.w_clipsize = 4;
  self.reloadRate = 0.15;
  self.reloadMax = 2;
  self.energyRate = 0;
  
  self.w_range = 500;
  self.damageValue = 2.5;
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
    self.description = "+ Instant-impact weapon. +4-rnd burst and 4 pellets per shot. + shotgun damage pattern. + Stronger against <shields> AND [small] targets.";
    self.icon = "gfx/ui/wep_icons/wi_flak.png";
    self.itemMuzzleFlash = te_muzzle_flk;
  #endif
  
  #ifndef CSQC
    self.burstRate = 1;
    self.w_isburst = FALSE;
    self.w_attack = data_ini_attack_flak_;
    self.think = default_weapon_think;
  #endif
};

#ifndef CSQC
void() data_ini_attack_flak_={
  local vector cacheSpread;
  local vector direction;
  local vector src;
  local vector dir;
  local float totes;
  local float damage;
  local float damageBuff;
      
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
  damageBuff = 1;
  if( vlen(FIRE_ENDPOINT - src) <= (self.w_range * 0.5)){
    damageBuff = 2;
  }
  while (totes > 0){
    direction = dir + crandom()*self.spreadDefault_x*v_right + crandom()*self.spreadDefault_y*v_up;
    traceline (src, src + direction*self.w_range, FALSE, self.owner);
    if( (random() * 1) <= 0.3 ){
      client_send_weapon_flash( self.w_group, num_for_edict(self.owner), src + direction*self.w_range);
    }
    if( trace_ent.takedamage ){
      if( trace_ent.shield > 0){
        t_damage_shield(trace_ent, self,self.owner, ((self.damageValue * damageBuff)* 0.9), trace_endpos, FALSE);
      }
      else{
        damage = (self.damageValue * damageBuff) * 0.8;
        if( (trace_ent.data_type == DATA_MECH) || (trace_ent.data_type == DATA_VEHC) ){
          if( trace_ent.vec_size == 1){
            damage = self.damageValue;
          }
          else if( trace_ent.vec_size == 3 ){
            damage = self.damageValue * 0.67;
          }
        }
        t_damage(trace_ent, self, self.owner, damage, trace_endpos, '0 0 0');
      }
    }
    totes = totes - 1;
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif