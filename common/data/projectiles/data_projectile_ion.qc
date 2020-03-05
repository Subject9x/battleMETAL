/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Projectile
    EMP projetile 
      AoE radius.
      
*/
void() data_projectile_ion_touch;
void() data_projectile_ion_think_;
void() data_projectile_ion_explode;

float DAT_PRJ_ION_PROXYRAD    = 200;
float DAT_PRJ_ION_EXPRAD      = 300;

void() data_projectile_ini_ion_={
  self.classname = "missile";
  self.touch = data_projectile_ion_touch;
  self.data_velocity = 4000;
  self.model = "q3mdl/proj/mdl_proj_ion.md3";
  self.data_lifetime = 2.57;
  
  //cosmetics
  self.effects = (EF_ADDITIVE | EF_NOSHADOW);
  self.modelflags = 0;
  self.alpha = 0.75;
  self.traileffectnum = particleeffectnum("TE_ION_TRAIL");
  self.think = data_projectile_ion_think_;
};

void() data_projectile_ion_think_={

  local float explode;
  explode = FALSE;
  if(time > self.w_firetime){
    local entity proxy;
    for(proxy = findradius(self.origin, DAT_PRJ_ION_PROXYRAD); proxy != world; proxy = proxy.chain){
      if( explode ){
        continue;
      }
      if(proxy.takedamage <= 0){
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
      if(ln > DAT_PRJ_ION_PROXYRAD){
        continue;
      }
      explode = TRUE;
    }
  }
  
  if(time > self.data_lifetime){
    explode = TRUE;
  }
  
  if(explode){
    self.think = data_projectile_ion_explode;
  }else{
    self.think = data_projectile_ion_think_;
  }
  self.nextthink = time + 0.01;
};

void()data_projectile_ion_explode={
  local entity lst;
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
    t_damage(lst, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
  }
  client_send_particle( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
  remove(self);
};

void() data_projectile_ion_touch={
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
	if (pointcontents(self.origin) == CONTENT_SKY){
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
		return;
	}
  self.traileffectnum = FALSE;
  
  if(other.takedamage){
    if( other.shield > 0 ){
      client_send_particle( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
    }
    else{
      client_send_particle( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
    }
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }
  
  self.nextthink = time + 0.01;
  self.think = data_projectile_ion_explode;
};