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
#define DAT_FLAK_SHRAP_TOTAL 10

#ifdef SSQC
  vector DAT_FLAK_SHRAP_SPREAD  = '0.15 0.15 64';
  void() data_ini_attack_flak_;
#endif

#ifdef CSQC
void() te_muzzle_flk={
  
  traceline(self.wepFireOffset, self.owner.laser_sight_org, FALSE, self.owner);
  
  Sound7_Dynamic(self, CHAN_AUTO, self.fire_sound, 1.0, ATTN_NORM, (0.5 + (random() * 0.5)) * 125, SOUNDFLAG_DYNAMIC_INT);
  
  if( particleDraw <= PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_FLK_MUZZLE"), self.wepFireOffset, normalize(trace_endpos - self.wepFireOffset) * 4, 1);
  }
};
#endif
void() data_ini_flak_cannon_={

  self.data_idx = UID_ITEM_flak;
  
  self.w_clipsize = 1;
  self.energyRate = 0;
  
  self.w_range = 500;
  if((self.owner.flags & FL_CLIENT)){
    self.damageValue = 7.5;
    self.reloadRate = 3.0;
    self.reloadMax = 3.0;
  }
  else{
    self.damageValue = 2.5;
    self.reloadRate = 4.0;
    self.reloadMax = 4.0;
  }
  self.damageType = DMG_BAL;
  
  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '0.07 0.07 0';
  self.wepFireOffset = '0 0 5';
  self.burstRate = 1;
  
#ifdef CSQC
  precache_sound("sound/weapons/flak_fire.ogg");
  precache_sound("sound/weapons/flak_fire_int.ogg");
  precache_sound("sound/weapons/flak_reload.ogg");
  precache_model("models/weapons/w_flk.md3");
  precache_file( "gfx/ui/wep_icons/wi_flak.png");
  self.w_name = "Flak Cannon";
  self.fire_sound = "sound/weapons/flak_fire%s.ogg";
  self.reload_sound = "sound/weapons/flak_reload.ogg";
  self.model = "models/weapons/w_flk.md3";
  self.damageValue = self.damageValue * DAT_FLAK_SHRAP_TOTAL * 3 / 3;
  self.abbrev = "FLAK";
  self.description = "+ Instant-impact weapon. + shotgun damage pattern. + Stronger against <shields> AND [small] targets.";
  self.icon = "gfx/ui/wep_icons/wi_flak.png";
  self.itemMuzzleFlash = te_muzzle_flk;
#endif

#ifdef SSQC
  self.w_isburst = FALSE;
  self.w_attack = data_ini_attack_flak_;
  self.think = default_weapon_think;
#endif
};

#ifdef SSQC
void() data_ini_attack_flak_={
  local vector cacheSpread;
  local vector direction;
  local vector src;
  local vector dir;
  local float totes;
  local float damage;
  local float contents;
  
  cacheSpread = self.spreadDefault;
  self.spreadDefault = '0 0 0';
  
  ctrl_weapon_fireOffset();

  self.spreadDefault = cacheSpread;

  ctrl_weapon_updateAmmo( TRUE );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  
  totes = DAT_FLAK_SHRAP_TOTAL;
  
  src = self.origin + v_forward * 2;

  dir = normalize(FIRE_ENDPOINT - src);
  
  while (totes > 0){
    direction = dir + ((crandom() * self.spreadDefault_x) * v_right) + ((crandom() * self.spreadDefault_y) *v_up);
    traceline (src, src + direction*self.w_range, FALSE, self.owner);


    if((self.owner.flags & FL_CLIENT) && self.owner.chaseActive){
      
    }
    pointparticles( particleeffectnum("TE_FLK_TRAIL"), src + normalize(trace_endpos - src) * 32, normalize(trace_endpos - src) * 10, 1 );

    if( trace_ent.takedamage ){
      if( trace_ent.shield > 0){
        t_damage_shield(trace_ent, self,self.owner, self.damageValue * 1.5, trace_endpos, FALSE);
      }
      else{
        damage = self.damageValue;
        if( trace_ent.data_type == DATA_MECH || trace_ent.data_type == DATA_VEHC ){
          damage = damage - trace_ent.vec_size;
          if( trace_ent.data_type == DATA_VEHC ){
            damage = self.damageValue * 1.67;
          }
        }
        HIT_LOCATION = t_damage(trace_ent, self, self.owner, damage, trace_endpos, '0 0 0');
        if( HIT_LOCATION && !(self.owner.statTargetHitParts & HIT_LOCATION) ){
          self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
        }
        pointparticles( particleeffectnum("TE_FLK_IMPACT"), trace_endpos + (v_forward * -16), dir * -4, 1);
      }
    }
    else{
      pointparticles( particleeffectnum("TE_FLK_DIRT"), trace_endpos + (v_forward * -4), dir * -8, 1);
    }
    
    totes = totes - 1;
  }
};
#endif