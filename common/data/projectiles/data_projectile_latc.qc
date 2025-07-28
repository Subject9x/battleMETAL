/*
battleMETAL
Author: Peter Roohr
Date: 07/14/2025
Overview: 
  Data File - Projectile
    Light Autocannon....maybe it was always better this way
      
*/
#ifdef SSQC
void() data_projectile_latc_touch_;
void() data_projectile_latc_th;
#endif

#ifdef CSQC
void() projectile_latc_hit={
  local float r;
  local string snd;

  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_SHIELD_HIT_HIGH"), self.origin, self.velocity, 1);
  }
  else if( self.impactType == IMPACT_ARMOR ){
    r = random() * 1.0;
    if(r < 0.4){
      snd = "sound/fx_armorhit1.ogg";
    }
    else if(r < 0.8 ){
      snd = "sound/fx_armorhit2.ogg";
    }
    else{
      snd = "sound/fx_armorhit3.ogg";
    }
    sound7(self, CHAN_AUTO, snd, (0.67 + random() * 0.3), ATTN_NORM, (67 + (random() * 33)), 0);
    pointparticles( particleeffectnum("TE_ATC_ARMOR"), self.origin, normalize(self.velocity) * 10, 1);
  }
  else{
    Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_hit_dirt.ogg", (0.67 + random() * 0.33), ATTN_NORM, (67 + (random() * 33)), SOUNDFLAG_DYNAMIC_INT);
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    pointparticles( particleeffectnum("TE_ATC_DIRT"), self.origin + (v_up *1) + (v_forward * -4), normalize( self.velocity) * -20, 1);
    pointparticles( PTC_HIT_DIRT_SHOT_SML, self.origin, normalize(self.velocity) * -1, 1);
  }
};
#endif

void() data_projectile_ini_latc_={
  self.classname = "missile";
  self.data_velocity = 1900;
  self.data_lifetime = 2;
  
  #ifdef CSQC
    //cosmetics
    self.model = "models/proj/mdl_proj_atc.md3";
    self.colormod = '3.0 3.0 3.0';
    self.alpha = 0.75;
    self.data_traileff = particleeffectnum("TE_ATC_BULLET_TRAIL");
    self.pcl_explode = projectile_latc_hit;
    self.scale = 4.0;
    self.effects = self.effects | EF_NOSHADOW;
  #endif
    
  #ifdef SSQC
    self.model = "models/testball.md3";
    self.think = data_projectile_latc_th;
    self.touch = data_projectile_latc_touch_;
    self.gravity = 0.05;
    self.movetype = MOVETYPE_TOSS;
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};

#ifdef SSQC
void() data_projectile_latc_th={
  
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }

  if( time > self.data_lifetime){
    self.velocity = self.velocity * 0.95;
    self.damageValue = max(0, self.damageValue * 0.95);
    if( vlen(self.velocity) <= 100 ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.01;
      return;
    }
  }

  self.think = data_projectile_latc_th;
  self.nextthink = time + 0.01;
};

void() data_projectile_latc_touch_={
  local float dmgVal;
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;
  self.velocity = '0 0 0';
  
  dmgVal = self.damageValue;
  if(other.takedamage){
    if( other.shield > 0 ){
      t_damage_shield(trace_ent, self, self.owner, dmgVal * 0.43, self.origin, FALSE );
      self.impactType = IMPACT_SHIELD;
    }
    else{
      if(other.data_type == DATA_BLD){
        dmgVal = dmgVal * 0.75;
      }
      HIT_LOCATION = t_damage(other, self, self.owner, dmgVal, self.origin, '0 0 0');
      if( HIT_LOCATION && !(self.owner.statTargetHitParts & HIT_LOCATION) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
      }
      self.impactType = IMPACT_ARMOR;
    }
    self.targetEntId = num_for_edict(other);
  }
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
    }
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.01;
};
#endif