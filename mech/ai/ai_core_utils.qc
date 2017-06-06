/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/
float() ai_core_findnode={
  local entity node, f;
  local float d;
  if(self.goalentity){
    return FALSE;
  }
  d = self.radar_range;
  node = findradius(self.origin, d);
  while(node){
    local float len;
    if(ai_target_visible(node)){
      if(node.classname == "ai_node"){
        if(node.target){
          len = vlen(node.origin - self.origin);
          if(len < d){
            d = len;
            f = node;
          }
        }
      }
    }
    node = node.chain;
  }
  if(f){
    self.goalentity = f;
    return TRUE;
  }
  return FALSE;
};

/*================================
        ai_core_findtarget

================================*/
float() ai_core_findtarget={
  local entity t_opt, t_rdr;
  if(self.enemy == world){
    if(self.oldenemy != world){
      //an old grudge
      self.enemy = self.oldenemy;
      return TRUE;
    }
    t_opt = ai_core_opticaltarget();
    if(t_opt != world){
      //found a target in LoS
      self.enemy = t_opt;
      return TRUE;
    }
    t_rdr = ai_core_radartarget();
    if(t_rdr != world){
      self.enemy = t_rdr;
      return TRUE;
    }
  }
  return FALSE;
};


float() ai_core_foundtarget={
  if(self.enemy != world){
    self.ai_next_state = ai_state_hunt;
    return TRUE;
  }
  return FALSE;
};

/*================================
        ai_core_targetstate
called whenever [ai_state_hunt] is the
active state. this makes sure the AI's target
is still a valid one, return FALSE if its not.
================================*/
float() ai_core_targetstate={
  if(self.enemy == world){
    return FALSE;
  }
  if(self.enemy.p_class == P_OBS){
    return FALSE;
  }
  if(self.enemy.deadflag >= DEAD_DYING){
    return FALSE;
  }
  if(self.enemy.health <= 0){
    return FALSE;
  }
  return TRUE;
};

/*================================
        ai_core_opticaltarget
finds all valid units (mechs, tanks, buildings)
-must be in front of ent
-must be visible
================================*/
entity() ai_core_opticaltarget={
  local float len;
  local entity t_opt, targ;
  len = self.ai_optical;
  targ = findradius(self.origin, len);
  while(targ){
    if(targ != world){
      if(targ != self){
        if(targ.owner != self){
          if(ai_target_infront(targ)){
            if(ai_target_visible(targ)){
              if((targ.p_class == P_MECH) || (targ.p_class == P_BULD)){
                if(targ.i_faction != self.i_faction){
                  local float d;
                  d = vlen(targ.origin - self.origin);
                  if(d < len){
                    len = d;
                    t_opt = targ;
                  }
                }
              }
            }
          }
        }
      }
    }
    targ = targ.chain;
  }
  return t_opt;
};

/*================================
        ai_core_radartarget
finds all valid units (mechs, tanks, buildings)
-must be visible
================================*/
entity() ai_core_radartarget={
  local float len;
  local entity t_rdr, targ;
  len = self.radar_range;
  targ = findradius(self.origin, len);
  self.stat_rdr_mode = 1;
  while(targ){
    if(targ != world){
      if(targ != self){
        if(targ.owner != self){
          if(ai_target_visible(targ)){
            if(targ.p_class == P_MECH || targ.p_class == P_BULD){
              if(targ.i_faction != self.i_faction){
                local float d;
                d = vlen(targ.origin - self.origin);
                if(d < len){
                  len = d;
                  t_rdr = targ;
                }
              }
            }
          }
        }
      }
    }
    targ = targ.chain;
  }
  return t_rdr;
};

/*================================
        ai_target_infront
determines if an entity is in front of calling ent
-ported from classic qc
================================*/
float(entity targ) ai_target_infront={
  local vector v;
  local float d;
  makevectors(self.angles);
  v = normalize(targ.origin - self.origin);
  d = v * v_forward;
  if( d > 0.3){
    return TRUE;
  }
  return FALSE;
};

//is self in front of a target?
float(entity targ) ai_target_insights={
  local vector v;
  local float d;
  makevectors(targ.angles);
  v = normalize(self.origin - targ.origin);
  d = v * v_forward;
  if( d > 0.3){
    return TRUE;
  }
  return FALSE;
};

/*================================
        ai_target_visible
determins if an entity can be seen by caller
-ported from classic qc
================================*/
float(entity targ) ai_target_visible={
  traceline(self.origin, targ.origin, TRUE, self);
  if(trace_fraction == 1){
    return TRUE;
  }
  return FALSE;
};

float() ai_target_facingideal =
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};

/*

*/
float() ai_core_panicnode={
  local entity node, dst;
  local float len;
  len = self.radar_range;
  node = findradius(self.origin, len);
  while(node){
    if(node.classname == "ai_node"){
      if(self.enemy != world){
        if(node != self.goalentity){
          if(!ai_core_nodelos(self.enemy.origin, node.origin)){
            local float d;
            d = vlen(node.origin - self.origin);
            if(d < len){
              len = d;
              dst = node;
            }
          }
        }
      }
    }
    node = node.chain;
  }
  if(dst != world){
    self.goalentity = dst;
    return TRUE;
  }
  
  return FALSE;
};

float(vector chk, vector node) ai_core_nodelos={
  traceline(node, chk, TRUE, self);
  if(trace_fraction == 1){
    return TRUE;
  }
  return FALSE;
};

void(entity e, entity mask) ai_core_sortranges={
  local entity os, wep;
  os = self;
  self = e;
  wep = self.w_slot;
  while(wep){
    if(mask != wep){
      local float dmg;
      if(wep.w_proj > 0){
        local entity p;
        p = mh_world_findData(wep.w_proj, DATA_PROJ);
        bprint(strcat(ftos(p.p_damage),"\n")); //DEBUG
        dmg = p.p_damage * wep.w_clipsize;
      }
      else{
        dmg = wep.p_damage * wep.w_clipsize;
      }
      if(wep.w_range <= AI_RANGE_S){
        self.ai_dmg_s = self.ai_dmg_s + dmg;
      }
      if((wep.w_range > AI_RANGE_S) && (wep.w_range < AI_RANGE_M)){
        self.ai_dmg_s = self.ai_dmg_s + dmg;
        self.ai_dmg_m = self.ai_dmg_m + dmg;
      }
      if(wep.w_range > AI_RANGE_M){
        self.ai_dmg_s = self.ai_dmg_s + dmg;
        self.ai_dmg_m = self.ai_dmg_m + dmg;
        self.ai_dmg_l = self.ai_dmg_l + dmg;
      }
    }
    wep = wep.w_slot;
  }
  local float s, m, l;
  s = self.ai_dmg_s;
  m = self.ai_dmg_m;
  l = self.ai_dmg_l;
  if(s < l){
    self.ai_minrange = AI_RANGE_L;
  }
  else if( s > l){
    self.ai_minrange = AI_RANGE_S;
  }
  if(m < l){
    self.ai_minrange = AI_RANGE_L;
  }
  else if( m > l){
    self.ai_minrange = AI_RANGE_M;
  }
  if(s < m){
    self.ai_minrange = AI_RANGE_M;
  }
  else if( s > m){
    self.ai_minrange = AI_RANGE_S;
  }
  if(self.ai_minrange == 0){
    self.ai_minrange = 400;
  }
  self = os;
};
