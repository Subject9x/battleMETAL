/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rotary Plasma projectile 
    burns-over-time on unshielded targets.
*/

#ifdef SSQC
#define DATA_PROJECTILE_PLASMA_BURN_TIME 0.75
#define DATA_PROJECTILE_PLASMA_BURN_DMG 3.0
//was 5.0

void() data_projectile_plasma_touch;
void() data_projectile_plasma_think_;
#endif

#ifdef CSQC
void() projectile_plasma_expl={
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  
  if( self.impactType == IMPACT_ARMOR ){
    pointparticles( particleeffectnum("TE_RPC_BURN"), self.origin, '0 0 0', 1);
    self.deadflag = DEAD_NO;  //flips the projectile render back on.'
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
    return;
  }
  self.angles = vectoangles(self.velocity);
  makevectors(self.angles);
  traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
  pointparticles( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
  pointparticles( particleeffectnum("TE_RPC_HIT_DIRT"), trace_endpos, trace_plane_normal * -1, 1);
};
#endif

void() data_projectile_ini_plasma_={
  self.classname = "missile";
  //self.data_velocity = 1200;  //vel = Range / lifetime || vel * lifetime = Range / lifetime * lifetime
  self.data_velocity = 1400;  //toss velocity
  self.data_lifetime = 1.5;
  self.scale = 1.25;
  
  self.effects = self.effects | EF_FULLBRIGHT | EF_NOSHADOW;
  #ifdef CSQC
    //cosmetics
    self.alpha = 0.75;
    self.scale = 1.5;
    precache_model("models/proj/mdl_proj_rpc.md3");
    self.model = "models/proj/mdl_proj_rpc.md3";
    self.data_traileff = particleeffectnum("TE_RPC_TRAIL");
    self.predraw_projectile = predraw_plasma;
    self.pcl_explode = projectile_plasma_expl;
  #endif
  
  #ifdef SSQC
    self.touch = data_projectile_plasma_touch;
    self.think = data_projectile_plasma_think_;
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};
#ifdef SSQC


void() data_projectile_plasma_burn_th={
  if(time > self.data_lifetime){
    remove(self);
    return;
  }
  if( self.enemy.deadflag > DEAD_NO ){
    remove(self);
    return;
  }
  
  util_getPartFromName( self.partParentId, self.enemy );

  if( T_PART_HP <= 0){
    remove(self);
    return;
  }


  setorigin(self, T_PART_PARENT_ORG + randomvec2() * 5);

  self.SendFlags = self.SendFlags | SENDFLAG_MOVE | SENDFLAG_IMPACT | SENDFLAG_VELOCITY;
  if(self.enemy.shield > 0){
    t_damage_shield(self.enemy, self, self.owner, self.damageValue, T_PART_PARENT_ORG, FALSE);
  }
  else{
    if( time > self.enemy.shieldHitRegenStart && time < self.enemy.shieldHitRegen){
      self.enemy.shieldHitRegen = self.enemy.shieldHitRegen + 0.1;
    }
    t_damage(self.enemy, self, self.owner, self.damageValue * 0.1, self.origin, 0);
  }

  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.1;
};

void() data_projectile_plasma_burn_ini_={
  self.movetype = MOVETYPE_NONE;
  self.impactType = IMPACT_ARMOR;
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_IMPACT);
  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.01;

  
  util_getPartFromName( self.partParentId, self.enemy );

  if( T_PART_HP <= 0){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }

  self.damageValue = DATA_PROJECTILE_PLASMA_BURN_DMG;
  self.data_lifetime = time + DATA_PROJECTILE_PLASMA_BURN_TIME;
};


void() data_projectile_plasma_touch={
  local float damage;
  
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;
  self.solid = SOLID_NOT;
  
  if(other.takedamage){
    damage = self.damageValue;
    if(other.shield > 0){
      damage = damage * 0.45;
      t_damage_shield(trace_ent, self, self.owner, damage, FIRE_ENDPOINT, FALSE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      self.partParentId = t_damage(other, self, self.owner, damage, self.origin, '0 0 0');
      if(self.count){
        self.targetEntId = num_for_edict(other);
        self.enemy = other;
        self.think = data_projectile_plasma_burn_ini_;
        self.nextthink = time + 0.01;
      }

      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
      self.SendFlags = self.SendFlags | SENDFLAG_MOVE | SENDFLAG_IMPACT;
      self.impactType = IMPACT_ARMOR;
      
      if( self.partParentId && !(self.owner.statTargetHitParts & self.partParentId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | self.partParentId;
      } 
      return;
    }
	}
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
    }
  }
  
  self.movetype = MOVETYPE_NONE;
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
 
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.01;
};

void() data_projectile_plasma_think_={
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  if( time > self.data_lifetime ){
    client_send_particle( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
    self.touch = SUB_Null;
    self.think = ctrl_missile_lastframe;
    self.nextthink = time + 0.05;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
    return;
  }
  self.think = data_projectile_plasma_think_;
  self.nextthink = time + 0.01;
};
#endif