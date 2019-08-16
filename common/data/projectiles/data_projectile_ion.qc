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
    proxy = findradius(self.origin, DAT_PRJ_ION_PROXYRAD);
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
          if(ln <= DAT_PRJ_ION_PROXYRAD){
            explode = TRUE;
          }
        }
      }
    
      proxy = proxy.chain;
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

void() data_projectile_ion_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		//remove(self);
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
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
    //remove(self);
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }
  
  self.nextthink = time + 0.01;
  self.think = data_projectile_ion_explode;
};