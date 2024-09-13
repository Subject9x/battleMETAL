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
float DAT_FLAK_SHRAP_TOTAL = 6;

#ifdef SSQC
  vector DAT_FLAK_SHRAP_SPREAD  = '0.15 0.15 64';
  void() data_ini_attack_flak_;
#endif

#ifdef CSQC
void() te_muzzle_flk={
  local vector startOrg;
  local vector endOrg;
  local float impactStyle;
  local float shrap;
  local vector norm;
  local vector ang;
  local vector v;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  norm = normalize(endOrg - startOrg);
  ang = vectoangles(endOrg - startOrg);
  
  sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 175, 0 );
  
  if( particleDraw <= PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_FLK_MUZZLE"), startOrg, normalize(endOrg - startOrg) * 4, 1);
  
    makevectors(ang);
    shrap = DAT_FLAK_SHRAP_TOTAL;
    while( shrap > 0 ){
      v = norm + ((crandom()*self.spreadDefault_x)*v_right) + ((crandom()*self.spreadDefault_y)*v_up);
      
      traceline (startOrg, startOrg + (v * self.w_range), FALSE, self.owner);
      impactStyle = te_impact_type(trace_endpos, trace_ent, trace_dphitcontents);
      
      trailparticles(world, particleeffectnum("TE_FLK_TRAIL"), startOrg, startOrg + (v * 32));
      shrap = shrap - 1;
    }
  }
};
#endif
void() data_ini_flak_cannon_={

  self.data_idx = UID_ITEM_flak;
  
  self.w_clipsize = 1;
  self.reloadRate = 1.5;
  self.reloadMax = 1.5;
  self.energyRate = 0;
  
  self.w_range = 500;
  self.damageValue = 1; //2.5
  if((self.owner.flags & FL_CLIENT)){
    self.damageValue = 3;
    self.w_clipsize = 3;
    self.reloadRate = 0.15;
    self.reloadMax = 3;
  }
  self.damageType = DMG_BAL;
  
  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '0.07 0.07 0';
  self.wepFireOffset = '0 0 5';
  self.burstRate = 1;
  
#ifdef CSQC
  precache_sound("sound/weapons/flak_fire.ogg");
  precache_sound("sound/weapons/flak_reload.ogg");
  precache_model("models/weapons/w_flk.md3");
  precache_file( "gfx/ui/wep_icons/wi_flak.png");
  self.w_name = "Flak Cannon";
  self.fire_sound = "sound/weapons/flak_fire.ogg";
  self.reload_sound = "sound/weapons/flak_reload.ogg";
  self.model = "models/weapons/w_flk.md3";
  self.damageValue = self.damageValue * DAT_FLAK_SHRAP_TOTAL * 3 / 3;
  self.abbrev = "FLAK";
  self.description = "+ Instant-impact weapon. + 3-rnd burst and 6 pellets per shot. + shotgun damage pattern. + Stronger against <shields> AND [small] targets.";
  self.icon = "gfx/ui/wep_icons/wi_flak.png";
  self.itemMuzzleFlash = te_muzzle_flk;
  self.damageValue = 4;
  self.w_clipsize = 3;
  self.reloadRate = 0.15;
  self.reloadMax = 3;
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
      
  cacheSpread = self.spreadDefault;
  self.spreadDefault = '0 0 0';
  
  ctrl_weapon_fireOffset();

  self.spreadDefault = cacheSpread;

  ctrl_weapon_updateAmmo( TRUE );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  
  totes = DAT_FLAK_SHRAP_TOTAL;
  
  src = self.origin + v_forward*2;
  dir = normalize(FIRE_ENDPOINT - src);
  
  while (totes > 0){
    direction = dir + crandom()*self.spreadDefault_x*v_right + crandom()*self.spreadDefault_y*v_up;
    traceline (src, src + direction*self.w_range, FALSE, self.owner);
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