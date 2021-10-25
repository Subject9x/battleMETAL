/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Projectile
   Missile - Laser Guided
    Explodes on touch
    follows player reticle
*/

#ifdef SSQC
void() data_projectile_missile_swarm_touch;
void() data_projectile_missile_swarm_think;
void() data_projectile_missile_swarm_delay;
#endif

#ifdef CSQC
void() projectile_swarm_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 1.25 0.67';
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
    pointparticles(PTC_HIT_DIRT_EXP_SML, trace_endpos, trace_plane_normal * -1, 1);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom );
};
#endif

void() data_projectile_ini_missile_swarm_={
  self.classname = "missile";
  self.data_velocity = 1750;
  self.data_lifetime = 1;
 
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_lgm.md3";
    self.effects = EF_NOSHADOW;
    self.traileffectnum = particleeffectnum("TE_SWRM_TRAIL"); 
    self.pcl_explode = projectile_swarm_expl;
    self.scale = 1.5;
    self.effects = self.effects | EF_FULLBRIGHT;
  #endif 
  
  #ifdef SSQC
    self.think = data_projectile_missile_swarm_think;
    self.touch = data_projectile_missile_swarm_touch;      
    self.gravity = 0.04;
    self.movetype = MOVETYPE_TOSS;
    self.effects = self.effects | EF_FULLBRIGHT;
    self.isActive = TRUE;
  #endif
};
#ifdef SSQC
void() data_projectile_missile_swarm_touch={
  local float debris;
  local float damage;
  local entity hitLocation;
  
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;

  if(other.takedamage){
    damage = self.damageValue;
    if( other.shield > 0 ){
      if( other.shield > (other.shieldMax * 0.25) ){
        damage = damage * 0.33;
      }
      else{
        damage = damage * 0.75;
      }
      t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, FALSE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      hitLocation = t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');
      if( hitLocation.partTypeId && !(self.owner.statTargetHitParts & hitLocation.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | hitLocation.partTypeId;
      } 
      te_debris_armor( self.origin, vectoangles(self.velocity) * 0.33, self.velocity, 3, 1 );
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
      debris = ceil( 1 + random() * 3);
    }
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, 1 );
  } 
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.01;
};

void() data_projectile_missile_swarm_think={
  local vector  dir, vtemp;
  
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  if(time > self.data_lifetime){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.1;
  }
  else{
    if( ai_valid_target( self.enemy ) ){
      if( (self.enemy.flags & FL_CLIENT) ){
        if( self.stat_rdr_mode == TRUE && self.owner.enemy.stat_rdr_mode == FALSE ){
          //target went passive
          vtemp = self.last_origin;
        }
        else if( self.stat_rdr_mode == TRUE && self.owner.enemy.stat_rdr_mode == TRUE ){
          vtemp = self.enemy.origin + '0 0 10';
          vtemp = randompos(vtemp + (self.enemy.mins * 0.75), vtemp + (self.enemy.maxs * 0.75));
          dir = normalize(vtemp - self.origin) * 0.75;
          self.last_origin = self.enemy.origin;
        }
        else{
          makevectors(self.angles);
          dir = normalize((self.origin + (v_forward * 10)) - self.origin) * 0.75;
        }
      }
      else{
        vtemp = self.enemy.origin + '0 0 10';
        vtemp = randompos(vtemp + (self.enemy.mins * 0.75), vtemp + (self.enemy.maxs * 0.75));
        self.last_origin = self.enemy.origin;
        dir = normalize(vtemp - self.origin) * 0.75;
      }
      self.velocity = dir * self.data_velocity;
      self.angles = vectoangles(self.velocity);
      self.SendFlags = self.SendFlags | SENDFLAG_VELOCITY;
    }
    self.nextthink = time + 0.075;
    self.think = data_projectile_missile_swarm_think;
  }
};

void() data_projectile_missile_swarm_delay_int={
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  if( time > self.ai_action_time ){
    self.think = data_projectile_missile_swarm_think;
    self.nextthink = time + 0.01;
    return;
  }
  self.think = data_projectile_missile_swarm_delay_int;
  self.nextthink = time + 0.025;
};

void() data_projectile_missile_swarm_delay={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.velocity = normalize( self.origin - self.compOffset);
  self.velocity = self.velocity * (self.data_velocity * 0.50);
  self.angles = vectoangles(self.velocity);
 
  self.ai_action_time = time + 1;
  self.think = data_projectile_missile_swarm_delay_int; 
  self.nextthink = time + 0.05;
};
#endif

