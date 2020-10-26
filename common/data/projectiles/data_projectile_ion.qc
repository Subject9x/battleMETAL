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

float DAT_PRJ_ION_EXPRAD = 100;
#endif CSQC

#ifdef CSQC
void() projectile_ion_expl={
  if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
  }
  else if( self.impactType == IMPACT_SKY ){
    pointparticles( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
  }
  else{
    pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
  } 
};
#endif
void() data_projectile_ini_ion_={
  self.classname = "missile";
  self.data_velocity = 3000;
  self.data_lifetime = 0.49;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_ion.md3";
    self.effects = (EF_ADDITIVE | EF_NOSHADOW);
    self.alpha = 0.75;
    self.traileffectnum = particleeffectnum("TE_ION_TRAIL");
    self.pcl_explode = projectile_ion_expl;
  #endif
    
  #ifdef SSQC
    self.think = data_projectile_ion_think_;
    self.touch = data_projectile_ion_touch;
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};
#ifdef SSQC
void() data_projectile_ion_think_={

  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  
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
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  self.impactType = IMPACT_SKY;
  for(lst = findradius(self.origin, DAT_PRJ_ION_EXPRAD); lst != world; lst = lst.chain){
    if(lst.takedamage <= 0){
      continue;
    }
    traceline(self.origin, lst.origin, FALSE, self.owner);
    if(trace_ent == world){
      continue;
    }
    local float ln;
    ln = vlen(trace_endpos - self.origin);
    if(ln > DAT_PRJ_ION_EXPRAD){
      continue;
    }
    if( other.shield > 0 ){
      t_damage_shield(trace_ent, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, TRUE);
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
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
	self.impactType = IMPACT_SKY;
  self.traileffectnum = FALSE;

  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  
  if(other.takedamage){
    if( other.shield > 0 ){
      t_damage_shield(trace_ent, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, TRUE);
      self.impactType = IMPACT_SKY;
    }
    else{
      self.impactType = IMPACT_ARMOR;
    }
    self.stat_trg_ent_id = num_for_edict(other);
  }
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};
#endif CSQC