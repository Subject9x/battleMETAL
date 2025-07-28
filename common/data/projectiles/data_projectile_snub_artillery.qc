/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Projectile
    Snub Artillery Shell
      AoE radius.
      
*/
#ifdef SSQC
#define DAT_PRJ_SFGA_RAD 300
void() data_projectile_snub_artillery_radiusDamage;
void() data_projectile_snub_artillery_touch_;
void() data_projectile_snub_artillery_th;
#endif

#ifdef CSQC
void() projectile_sfga_expl={
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_SFGA_IMPACT_SHIELD"), self.origin, self.velocity, 1);
   
    te_missile_explode( self.origin, 2, '0 0 1', -0.05 ); 
  }
  else if( self.impactType == IMPACT_ARMOR ){
    PointSound_Dynamic(self.origin, "sound/fx_boom%s.ogg",  1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
    pointparticles( particleeffectnum("TE_SFGA_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    te_missile_explode( self.origin, 2, '0.99 0.8 0.5', 0.1 ); 
  }
  else{
    PointSound_Dynamic(self.origin, "sound/fx_boom%s.ogg",  1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
    te_missile_explode( self.origin, 2, '0.99 0.8 0.5', 0.05 );
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
    pointparticles(PTC_HIT_DIRT_EXP_LRG, trace_endpos, trace_plane_normal * -1, 1);
  }
};
#endif

void() data_projectile_ini_snub_artillery_={
  self.classname = "missile";
  self.data_velocity = 1300;
  self.data_lifetime = 6;
  
  #ifdef CSQC
    //cosmetics
    self.model = "models/proj/mdl_proj_sfga.md3";
    self.colormod =  '0.85 0.45 0.45';
    self.data_traileff = particleeffectnum("TE_SFGA_TRAIL");
    self.pcl_explode = projectile_sfga_expl;
    self.scale = 1.25;
    self.effects = self.effects | EF_FULLBRIGHT;
  #endif
    
  #ifdef SSQC
    self.model = "models/testball.md3";
    self.think = data_projectile_snub_artillery_th;
    self.touch = data_projectile_snub_artillery_touch_;
    self.gravity = 0.03;
    self.movetype = MOVETYPE_TOSS;
    self.w_range = DAT_PRJ_SFGA_RAD;
    self.effects = self.effects | EF_FULLBRIGHT | EF_LOWPRECISION;
  #endif
};

#ifdef SSQC
void() data_projectile_snub_artillery_th={
  
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  self.think = data_projectile_snub_artillery_th;
  self.nextthink = time + 0.01;
};

void() data_projectile_snub_artillery_touch_={
  local float debris;
  local float damage;
  local float part2;
  
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE | SENDFLAG_IMPACT;
  self.impactType = IMPACT_SKY;
  
  if( other.takedamage ){
    damage = self.damageValue;
    if( other.shield > 0 ){
      if( other.shield > (other.shieldMax * 0.5) ){
        damage = damage * 0.33;
      }
      else{
        damage = damage * 0.67;
      }
      t_damage_shield(trace_ent, self, self.owner, damage, FIRE_ENDPOINT, FALSE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      HIT_LOCATION = t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');

      part2 = FALSE;
      if(other.health > 1 && other.data_type == DATA_MECH){
        if( HIT_LOCATION == M_TOR_LEFT ){
          part2 = M_TOR_CENTER;
        }
        if( HIT_LOCATION == M_TOR_RIGHT ){
          part2 = M_TOR_CENTER;
        }
        if( HIT_LOCATION == M_ARM_LEFT ){
          part2 = M_TOR_LEFT;
        }
        if( HIT_LOCATION == M_ARM_RIGHT ){
          part2 = M_TOR_RIGHT;
        }
        if(part2){
          util_getPartFromName(part2, other); 
          if( T_PART_HP > 0){
            t_damage(other, self, self.owner, self.damageValue * 0.33, T_PART_PARENT_ORG, '0 0 0');
          }
        }
      }
      

      if( HIT_LOCATION && !(self.owner.statTargetHitParts & HIT_LOCATION) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
      } 
      
      debris = ceil(random() * 3);
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, debris, 2 );
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, debris * 2, 1 );
      self.impactType = IMPACT_ARMOR;
    }
    if( other != self.owner ){
      self.owner.targetEntId = num_for_edict(other);
    }
    
    debris = 0;
  }
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
      debris = ceil(random() * 4);
      data_projectile_snub_artillery_radiusDamage();
    }
    else if( (trace_dphitcontents & DPCONTENTS_SKY) || (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) ){
      debris = 0;
    }
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, min(3, rint(0.5+ (random() * 3))) );
    te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, debris * 1.25, min(3, rint(0.5+ (random() * 3))) );
  }
  
  self.movetype = MOVETYPE_NONE;
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.1;
};

void() data_projectile_snub_artillery_radiusDamage={
  local entity radiusTarg;
  local float d, dmg_act;
  
  for(radiusTarg = findradius(self.origin, self.w_range); radiusTarg != world; radiusTarg = radiusTarg.chain){
    if( !ai_valid_target(radiusTarg) ){
      continue;
    }
    d = vlen(radiusTarg.origin - self.origin);
    d = d / self.w_range;
    dmg_act = self.damageValue - (self.damageValue * d);
    dmg_act = dmg_act * 0.75;
    if( radiusTarg.shield > 0 ){
      dmg_act = dmg_act * 0.25;
      t_damage_shield(radiusTarg, self, self.owner, dmg_act, trace_endpos, FALSE);
    }
    else{
      HIT_LOCATION = t_damage(radiusTarg, self, self.owner, dmg_act, trace_endpos, '0 0 0');
      if( HIT_LOCATION && !(self.owner.statTargetHitParts & HIT_LOCATION) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
      } 
    }
  }
};
#endif