/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Missile - Laser Guided
    Explodes on touch
    follows player reticle
*/

#ifdef SSQC
void() data_projectile_missile_laserguide_touch;
void() data_projectile_missile_laserguide_think;
#endif

#ifdef CSQC
void() projectile_mlg_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 0.2 0.67';
    hitBloom = -0.01;
    hitScale = 0.5;
  }
  else{
    hitColor = '0.663 0.886 0.953';
    hitBloom = 0.01;
    hitScale = 1;
    pointsound(self.origin, "sound/fx_boom.ogg",  0.8, ATTN_NORM);
  }
  if(self.impactType == IMPACT_DIRT){
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
    pointparticles(PTC_HIT_DIRT_EXP_MED, trace_endpos, trace_plane_normal * -1, 1);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom ); 
};
#endif

void() data_projectile_ini_missile_laserguide_={
  self.classname = "missile";
  self.data_velocity = 2200;
  self.data_lifetime = 1.1;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_lgm.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_LGM_TRAIL");
    self.pcl_explode = projectile_mlg_expl;
    self.scale = 2;
    self.effects = self.effects | EF_FULLBRIGHT;
  #endif 
  
  #ifdef SSQC
    self.touch = data_projectile_missile_laserguide_touch;
    self.think = data_projectile_missile_laserguide_think;
    self.effects = self.effects | EF_FULLBRIGHT;
  #endif
};
#ifdef SSQC
void() data_projectile_missile_laserguide_touch={
  local float debris;
  local float damage; 
  local entity hitLocation;
  
  self.touch = SUB_Null;
 
  self.impactType = IMPACT_SKY;
  
  if(other.takedamage){
    damage = self.damageValue;
    if( other.shield > 0 ){
      damage = damage * 0.33;
      t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, FALSE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      hitLocation = t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');
      if( hitLocation.partTypeId && !(self.owner.statTargetHitParts & hitLocation.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | hitLocation.partTypeId;
      } 
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, 3, 2 );
      self.impactType = IMPACT_ARMOR;
    }
    self.targetEntId = num_for_edict(other);
    debris = 0;
  }
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
      debris = ceil(2 + random() * 3);
    }
  }
  
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, 2 );
  }

  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.01;
};

void() data_projectile_missile_laserguide_think={
  local vector vtemp;
  
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  
  vtemp = normalize(self.owner.laser_sight_org - self.origin);
  self.velocity = vtemp * 0.5;
  self.velocity = self.velocity * self.data_velocity;
  self.angles = vectoangles(self.velocity);
  self.SendFlags = self.SendFlags | SENDFLAG_VELOCITY;
  
  if(time > self.data_lifetime){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.1;
  }
  else{
    self.nextthink = time + 0.025;
    self.think = data_projectile_missile_laserguide_think;
  }
};
#endif

