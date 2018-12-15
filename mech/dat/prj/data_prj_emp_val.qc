/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//EMP CANNON SHOT=======================
void() data_prj_emp_touch;
void() data_prj_emp_think;
void() data_prj_emp_explode;

void() data_prj_emp_ini={
  self.classname = "prj_emp";
  self.touch = data_prj_emp_touch;
  self.data_idx = ID_PRJ_EMP;
  self.p_velocity = DAT_PRJ_EMP_VELOCITY;
  self.c_model = DAT_PRJ_EMP_MODEL;
  self.p_lifetime = DAT_PRJ_EMP_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | (EF_ADDITIVE | EF_NOSHADOW);
  self.modelflags = DAT_PRJ_EMP_MODELFLAGS;
  self.alpha = DAT_PRJ_EMP_ALPHA;
  self.colormod = DAT_PRJ_EMP_COLORMOD;
  self.glow_color = DAT_PRJ_EMP_GLOWCOLOR;
  self.glow_size = DAT_PRJ_EMP_GLOWSIZE;
  self.glow_trail = 0;
  self.traileffectnum = particleeffectnum("TE_EMP_TRAIL");  //DEBUG
};

void()data_prj_emp_think={

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
          if(trace_ent.comp_id > 0){
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
    self.think = data_prj_emp_think;
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
  
  if(other.classname == "worldspawn"){
    self.nextthink = time + 0.01;
    self.think = data_prj_emp_explode;
    return;
  }

  if(other == self.owner){
    return;
  }
  
  if(other.takedamage){
    pointparticles( particleeffectnum("TE_EMP_EXPL"), self.origin, '0 0 0', 1);
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  }
  remove(self);
};