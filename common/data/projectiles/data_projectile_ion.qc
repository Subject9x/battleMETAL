/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Projectile
    EMP projetile 
      AoE radius.
      
*/
#ifdef SSQC
void() data_projectile_ion_touch;
void() data_projectile_ion_think_;
void() data_projectile_ion_explode;

#define DAT_PRJ_ION_EXPRAD 100
#endif

#ifdef CSQC
void() projectile_ion_expl={
  self.angles = vectoangles(self.velocity);
  makevectors(self.angles);
  traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
  switch(self.impactType){
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
      return;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
      return;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
      pointparticles(PTC_HIT_DIRT_ENE_MED, trace_endpos, trace_plane_normal * -1, 1);
      return;
  }
};
#endif
void() data_projectile_ini_ion_={
  self.classname = "missile";
  self.data_velocity = 3000;
  self.data_lifetime = 0.49;
  
  #ifdef CSQC
    //cosmetics
    self.model = "models/proj/mdl_proj_ion.md3";
    self.alpha = 0.75;
    self.pcl_explode = projectile_ion_expl;
    self.scale = 2;
    self.data_traileff = particleeffectnum("TE_ION_TRAIL");
  #endif
    
  #ifdef SSQC
    self.model = "models/testball.md3";
    self.think = data_projectile_ion_think_;
    self.touch = data_projectile_ion_touch;
    self.effects = self.effects | EF_FULLBRIGHT | EF_LOWPRECISION;
  #endif
};
#ifdef SSQC
void() data_projectile_ion_think_={

  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  
  if(time > self.data_lifetime){
    self.impactType = IMPACT_SKY;
    self.think = data_projectile_ion_explode;
  }else{
    self.think = data_projectile_ion_think_;
  }
  self.nextthink = time + 0.01;
};

void()data_projectile_ion_explode={
  local entity lst;
  local float ln;
  local float radius;
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  self.impactType = IMPACT_SKY;

  radius = DAT_PRJ_ION_EXPRAD;
  if((self.owner.flags & FL_MONSTER) && cvar("skill") < SKILL_ELT){
    radius = radius * 0.5;
  }

  for(lst = findradius(self.origin, radius); lst != world; lst = lst.chain){
    if(lst.takedamage <= 0){
      continue;
    }
    traceline(self.origin, lst.origin, FALSE, self.owner);
    if(trace_ent == world){
      continue;
    }
    ln = vlen(trace_endpos - self.origin);
    if(ln > radius){
      continue;
    }
    if( other.shield > 0 ){
      t_damage_shield(trace_ent, self, self.owner, self.damageValue, FIRE_ENDPOINT, TRUE);
      self.impactType = IMPACT_SKY;
    }
    else{
      self.impactType = IMPACT_ARMOR;
    }
  }
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

void() data_projectile_ion_touch={
  self.impactType = IMPACT_SKY;
  self.traileffectnum = FALSE;
  self.touch = SUB_Null;
  
  if(other.takedamage){
    if( other.shield > 0 ){
      t_damage_shield(other, self, self.owner, self.damageValue, FIRE_ENDPOINT, TRUE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      t_damage(other, self, self.owner, self.damageValue * 0.15, FIRE_ENDPOINT, '0 0 0');
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
  
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.1;
};
#endif