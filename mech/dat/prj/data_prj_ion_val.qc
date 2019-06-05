/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//Ion Coil shot=======================
void() data_prj_ion_touch;
void() data_prj_ion_think;
void() data_prj_ion_explode;

void() data_prj_ion_ini={
  self.classname = "prj_ion";
  self.touch = data_prj_ion_touch;
  self.data_idx = ID_PRJ_ION;
  self.p_velocity = DAT_PRJ_ION_VELOCITY;
  self.c_model = DAT_PRJ_ION_MODEL;
  self.p_lifetime = DAT_PRJ_ION_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | (EF_ADDITIVE | EF_NOSHADOW);
  self.modelflags = DAT_PRJ_ION_MODELFLAGS;
  self.alpha = DAT_PRJ_ION_ALPHA;
  self.traileffectnum = particleeffectnum("TE_ION_TRAIL");
};

void()data_prj_ion_think={

  local float dist;
  local float explode;
  explode = FALSE;
  if(time > self.w_firetime){
    local entity proxy;
    proxy = findradius(self.origin, DAT_PRJ_ION_PROXYRAD);
    while(proxy){
        if( proxy.takedamage){
          if(proxy.deadflag <= DEAD_NO){
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
              if(ln <= DAT_PRJ_ION_PROXYRAD){
                explode = TRUE;
              }
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
    self.think = data_prj_ion_explode;
  }else{
    self.think = data_prj_ion_think;
  }
  self.nextthink = time + 0.01;
};

void()data_prj_ion_explode={
  
  local entity lst;
  lst = findradius(self.origin, DAT_PRJ_ION_EXPRAD);
  while(lst){
    if(lst.takedamage){
      traceline(self.origin, lst.origin, FALSE, self.owner);
      if(trace_ent){
        local float ln;
        ln = vlen(trace_endpos - self.origin);
        if(ln <= DAT_PRJ_ION_EXPRAD){
          t_damage(lst, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
        }
      }
    }
    lst = lst.chain;
  }
  pointparticles( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
  self.think = SUB_Remove;
  self.nextthink = time + 0.001;
};

void() data_prj_ion_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  self.traileffectnum = FALSE;
  
  if(other.takedamage){
    if( other.shield > 0 ){
      pointparticles( particleeffectnum("TE_ION_EXPL"), self.origin, '0 0 0', 1);
    }
    else{
      pointparticles( particleeffectnum("TE_ION_IMPACT_ARMOR"), self.origin, '0 0 0', 1);
    }
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    remove(self);
    return;
  }
  
  self.nextthink = time + 0.01;
  self.think = data_prj_ion_explode;
};