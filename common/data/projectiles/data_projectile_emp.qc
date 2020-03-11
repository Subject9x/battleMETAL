/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Projectile
    EMP projetile 
      AoE radius.
      
*/
#ifndef CSQC
void() data_prj_emp_touch;
void() data_projectile_emp_think_;
void() data_prj_emp_explode;

float DAT_PRJ_EMP_PROXYRAD    = 200;
float DAT_PRJ_EMP_EXPRAD      = 300;

#endif CSQC
void() data_projectile_ini_emp_={
  self.classname = "missile";
  self.data_velocity = 1500;
  self.data_lifetime = 1.43;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_emp.md3";
    self.effects = (EF_ADDITIVE | EF_NOSHADOW);
    self.modelflags = 0;
    self.alpha = 0.75;
    self.traileffectnum = particleeffectnum("TE_EMP_TRAIL");
  #endif
  
  #ifndef CSQC
    self.model = "q3mdl/testball.md3";
    self.touch = data_prj_emp_touch;
    self.think = data_projectile_emp_think_;
  #endif CSQC
};
#ifndef CSQC
void() data_projectile_emp_think_={

  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  local float explode;
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
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  local entity lst;
  for(lst = findradius(self.origin, DAT_PRJ_EMP_EXPRAD); lst != world; lst = lst.chain){
    if(lst.takedamage <= 0){
      continue;
    }
    traceline(self.origin, lst.origin, FALSE, self.owner);
    if(trace_ent == world){
      continue;
    }
    local float ln;
    ln = vlen(trace_endpos - self.origin);
    if(ln > DAT_PRJ_EMP_EXPRAD){
      continue;
    }
    t_damage(lst, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
  }
  client_send_particle( particleeffectnum("TE_EMP_EXPL"), self.origin, '0 0 0', 1);
  remove(self);
};

void() data_prj_emp_touch={

	if( pointcontents(self.origin) == CONTENT_SKY ){
    remove(self);
    return;
	}
 
  self.traileffectnum = FALSE;
  
  if(other.takedamage){
    if( other.shield > 0 ){
      client_send_particle( particleeffectnum("TE_EMP_EXPL"), self.origin, '0 0 0', 1);
    }
    else{
      client_send_particle( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
    }
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    remove(self);
    return;
  }
 
  self.nextthink = time + 0.01;
  self.think = data_prj_emp_explode;
};
#endif CSQC