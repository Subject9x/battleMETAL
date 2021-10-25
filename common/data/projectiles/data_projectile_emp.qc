/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Projectile
    EMP projetile 
      AoE radius.
      
*/
#ifdef SSQC
void() data_prj_emp_touch;
void() data_projectile_emp_think_;
void() data_prj_emp_explode;

float DAT_PRJ_EMP_PROXYRAD    = 30;  //200
float DAT_PRJ_EMP_EXPRAD      = 300;
#endif

#ifdef CSQC
void() projectile_emp_expl={
  switch(self.impactType){
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_EMP_EXPL"), self.origin, '0 0 0', 1);
      return;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
      return;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
      self.angles = vectoangles(self.velocity);
      makevectors(self.angles);
      traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
      pointparticles(PTC_HIT_DIRT_ENE_MED, trace_endpos, trace_plane_normal * -1, 1);
      return;
  }
};
#endif

void() data_projectile_ini_emp_={
  self.classname = "missile";
  self.data_velocity = 3000;
  self.data_lifetime = 1;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_emp.md3";
    self.effects = (EF_ADDITIVE | EF_NOSHADOW);
    self.modelflags = 0;
    self.alpha = 0.75;
    self.traileffectnum = particleeffectnum("TE_EMP_TRAIL");
    self.pcl_explode = projectile_emp_expl;
  #endif
  
  #ifdef SSQC
    self.model = "q3mdl/testball.md3";
    self.touch = data_prj_emp_touch;
    self.think = data_projectile_emp_think_;
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};
#ifdef SSQC
void() data_projectile_emp_think_={
  local float explode;

  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  explode = FALSE;
  if(time > self.w_firetime){
    local entity proxy;
    for(proxy = findradius(self.origin, DAT_PRJ_EMP_PROXYRAD); proxy != world; proxy = proxy.chain){
      if( explode ){
        continue;
      }
      if(proxy.takedamage <= 0){
        continue;
      }
      if( (proxy.data_type != DATA_MECH) && (proxy.data_type != DATA_VEHC) ){
        continue;
      }
      if( proxy.faction == self.owner.faction ){
        continue;
      }
      traceline(self.origin, proxy.origin, FALSE, self.owner);
      if(trace_ent == world){
        continue;
      }
      local entity f;
      if(trace_ent.partTypeId > 0){
        f = trace_ent.owner;
      }
      else{
        f = trace_ent;
      }
      local float ln;
      ln = vlen(trace_endpos - self.origin);
      if(ln > DAT_PRJ_EMP_PROXYRAD){
        continue;
      }
      explode = TRUE;
    }
  }
  
  if(time > self.data_lifetime){
    explode = TRUE;
  }
  
  if(explode){
    self.think = data_prj_emp_explode;
  }else{
    self.think = data_projectile_emp_think_;
  }
  self.nextthink = time + 0.01;
};

void()data_prj_emp_explode={
  local float damage;
  local entity lst;
  local float ln;
  
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.touch = SUB_Null;
  
  for(lst = findradius(self.origin, DAT_PRJ_EMP_EXPRAD); lst != world; lst = lst.chain){
    if(lst.takedamage <= 0){
      continue;
    }
    traceline(self.origin, lst.origin, FALSE, self.owner);
    if(trace_ent == world){
      continue;
    }
    ln = vlen(trace_endpos - self.origin);
    if(ln > DAT_PRJ_EMP_EXPRAD){
      continue;
    }
    //make sure primary contact target takes the damage
    if(ln > DAT_PRJ_EMP_PROXYRAD){
      if( lst.shield > 0 ){
        damage = (self.damageValue * 0.25) * (ln / DAT_PRJ_EMP_EXPRAD);
        t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, TRUE);
        self.impactType = IMPACT_SHIELD;
      }
      else{        
        self.impactType = IMPACT_ARMOR;
      }
    }
    else{
      if( lst.shield > 0 ){
        damage = self.damageValue;
        t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, TRUE);
        self.impactType = IMPACT_SHIELD;
      }
      else{        
        self.impactType = IMPACT_ARMOR;
      }
    }

  }
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  self.impactType = IMPACT_SKY;
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};

void() data_prj_emp_touch={
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;
  
  if( other.takedamage ){
    self.traileffectnum = FALSE;
    if(other.takedamage){
      if( other.shield > 0 ){
        t_damage_shield(other, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, TRUE);
        self.impactType = IMPACT_SHIELD;
      }
      else{
        t_damage_shield(other, self, FIRE_ENT, self.damageValue * 0.1, FIRE_ENDPOINT, TRUE);
        self.impactType = IMPACT_ARMOR;
      }
      self.targetEntId = num_for_edict(other);
    }
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