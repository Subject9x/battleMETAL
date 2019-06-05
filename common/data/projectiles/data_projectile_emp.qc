/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Projectile
    EMP projetile 
      AoE radius.
      
*/
void() data_prj_emp_touch;
void() data_projectile_emp_think_;
void() data_prj_emp_explode;

float DAT_PRJ_EMP_PROXYRAD    = 200;
float DAT_PRJ_EMP_EXPRAD      = 300;

void() data_projectile_ini_emp_={
  self.classname = "prj_emp";
  self.touch = data_prj_emp_touch;
  self.data_idx = 0;
  self.p_velocity = 1500;
  self.model = "q3mdl/proj/mdl_proj_emp.md3";
  self.p_lifetime = 1.43;
  
  //cosmetics
  self.effects = (EF_ADDITIVE | EF_NOSHADOW);
  self.modelflags = 0;
  self.alpha = 0.75;
  self.traileffectnum = particleeffectnum("TE_EMP_TRAIL");
  self.think = data_projectile_emp_think_;
};

void() data_projectile_emp_think_={

  local float dist;
  local float explode;
  explode = FALSE;
  if(time > self.w_firetime){
    local entity proxy;
    proxy = findradius(self.origin, DAT_PRJ_EMP_PROXYRAD);
    while(proxy){
      if(proxy.takedamage){
        traceline(self.origin, proxy.origin, FALSE, self.owner);
        if(trace_ent){
          local entity f;
          if(trace_ent.partTypeId > 0){
            f = trace_ent.owner;
          }
          else{
            f = trace_ent;
          }
          local float ln;
          ln = vlen(trace_endpos - self.origin);
          if(ln <= DAT_PRJ_EMP_PROXYRAD){
            explode = TRUE;
          }
        }
      }
    
      proxy = proxy.chain;
    }
  }
  
  if(time > self.p_lifetime){
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
  
  local entity lst;
  lst = findradius(self.origin, DAT_PRJ_EMP_EXPRAD);
  while(lst){
    if(lst.takedamage){
      traceline(self.origin, lst.origin, FALSE, self.owner);
      if(trace_ent){
        local float ln;
        ln = vlen(trace_endpos - self.origin);
        if(ln <= DAT_PRJ_EMP_EXPRAD){
          t_damage(lst, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
        }
      }
    }
    lst = lst.chain;
  }
  pointparticles( particleeffectnum("TE_EMP_EXPL"), self.origin, '0 0 0', 1);
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

void() data_prj_emp_touch={
	if( pointcontents(self.origin) == CONTENT_SKY ){
		remove(self);
		return;
	}
 
  self.traileffectnum = FALSE;
  
  if(other.takedamage){
    if( other.shield > 0 ){
      pointparticles( particleeffectnum("TE_EMP_EXPL"), self.origin, '0 0 0', 1);
    }
    else{
      pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
    }
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    remove(self);
    return;
  }
 
  self.nextthink = time + 0.01;
  self.think = data_prj_emp_explode;
};