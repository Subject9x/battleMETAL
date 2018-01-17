/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//EMP CANNON SHOT=======================
float DAT_PRJ_EMP_IDX = ID_PRJ_EMP;
float DAT_PRJ_EMP_PROXYRAD = 150;
float DAT_PRJ_EMP_EXPRAD = 300;

void() data_prj_emp_touch;
void() data_prj_emp_think;
void() data_prj_emp_explode;

void() data_prj_emp_ini={
  self.classname = "missile";
  self.touch = data_prj_emp_touch;
  self.data_idx = DAT_PRJ_EMP_IDX;
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
  self.glow_trail = DAT_PRJ_EMP_GLOWTRAIL;
};

void()data_prj_emp_think={

  local float dist;
  local float explode;
  explode = FALSE;
  if(time > self.w_firetime){
    local entity proxy;
    proxy = findradius(self.origin, DAT_PRJ_EMP_PROXYRAD);
    while(proxy){
      if(proxy!=world){
        if(proxy.classname!="missile"){
          traceline(self.origin, proxy.origin, FALSE, self.owner);
          if(trace_ent){
            local entity f;
            if(trace_ent.classname == MECH_PIECE){
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
    if(lst!=world){
      if(lst.classname!="missile"){
        traceline(self.origin, lst.origin, FALSE, self.owner);
        if(trace_ent){
          local float ln;
          ln = vlen(trace_endpos - self.origin);
          if(ln <= DAT_PRJ_EMP_EXPRAD){
            t_damage(lst, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
          }
        }
      }
    }
    lst = lst.chain;
  }
  te_tarexplosion(self.origin);
  self.think = SUB_Remove;
  self.nextthink = time + 0.001;
};

void() data_prj_emp_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    te_tarexplosion(self.origin);
    self.nextthink = time + 0.01;
    self.think = data_prj_emp_explode;
    return;
  }

  if(other == self.owner){
    return;
  }
  
  if(other.owner == self.owner){
    return;
  }
  
  if(other.classname == "missile"){
    return;
  }
  te_tarexplosion(self.origin);
  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  
  remove(self);
};