/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

float(entity ai, entity goal) ai_core_trynode={
  local entity e, near;
  local float prox;
  prox = vlen(goal.origin - ai.origin);
  e = findchain(classname, "ai_node");
  while(e){
    local float d;
    traceline(e.origin, goal.origin, FALSE, goal);
    if(trace_fraction == 1){
      d = vlen(e.origin - goal.origin);
      if( d < prox){
        prox = d;
        near = e;
      }
    }
    e = e.chain;
  }
  return near.node_id;
};

entity(entity ai, entity goal) ai_core_nodetogoal={
  local entity e, near;
  local float prox;
  prox = vlen(goal.origin - ai.origin);
  e = findchain(classname, "ai_node");
  while(e){
    local float d;
    traceline(e.origin, goal.origin, FALSE, goal);
    if(trace_fraction == 1){
      d = vlen(e.origin - goal.origin);
      if( d < prox){
        prox = d;
        near = e;
      }
    }
    e = e.chain;
  }
  return near;
};

//galaxy forgive me
entity(entity node, float id) ai_query_graphnode={
  local entity n;
  local float idx;
  if(id == 1){
    idx = node.nexnode1;
  }
  else if(id == 2){
    idx = node.nexnode2;
  }
  else if(id == 3){
    idx = node.nexnode3;
  }
  else if(id == 4){
    idx = node.nexnode4;
  }
  else if(id == 5){
    idx = node.nexnode5;
  }
  else if(id == 6){
    idx = node.nexnode6;
  }
  else if(id == 7){
    idx = node.nexnode7;
  }
  else if(id == 8){
    idx = node.nexnode8;
  }
  else if(id == 9){
    idx = node.nexnode9;
  }
  else if(id == 10){
    idx = node.nexnode10;
  }
  else if(id == 11){
    idx = node.nexnode11;
  }
  else if(id == 12){
    idx = node.nexnode12;
  }
  else if(id == 13){
    idx = node.nexnode13;
  }
  else if(id == 14){
    idx = node.nexnode14;
  }
  else if(id == 15){
    idx = node.nexnode15;
  }
  else if(id == 16){
    idx = node.nexnode16;
  }
  else if(id == 17){
    idx = node.nexnode17;
  }
  else if(id == 18){
    idx = node.nexnode18;
  }
  else if(id == 19){
    idx = node.nexnode19;
  }
  else if(id == 20){
    idx = node.nexnode20;
  }
  else if(id == 21){
    idx = node.nexnode21;
  }
  else if(id == 22){
    idx = node.nexnode22;
  }
  else if(id == 23){
    idx = node.nexnode23;
  }
  else if(id == 24){
    idx = node.nexnode24;
  }
  else if(id == 25){
    idx = node.nexnode25;
  }
  else if(id == 26){
    idx = node.nexnode26;
  }
  else if(id == 27){
    idx = node.nexnode27;
  }
  else if(id == 28){
    idx = node.nexnode28;
  }
  else if(id == 29){
    idx = node.nexnode29;
  }
  else if(id == 30){
    idx = node.nexnode30;
  }
  else if(id == 31){
    idx = node.nexnode31;
  }
  else if(id == 32){
    idx = node.nexnode32;
  }
  n = findfloat(world, node_id, idx);
  return n;
};

entity(vector org, float start_dist) ai_core_findgraphnode={
  local entity e, near;
  local float prox;
  prox = start_dist;
  e = findchain(classname, "ai_node");
  while(e){
    local float d;
    if(self.node_id){
      traceline(e.origin, org, FALSE, self);
      if(trace_fraction == 1){
        d = vlen(e.origin - org);
        if( d < prox){
          prox = d;
          near = e;
        }
      }
    }
    e = e.chain;
  }
  return near;
};

entity() ai_core_findnode={
  local entity node, f;
  local float d;
  d = self.radar_range;
  node = findchain(classname, "ai_node");
  while(node){
    local float len;
    if(ai_target_visible(node)){
      if(node.target){
        len = vlen(node.origin - self.origin);
        if(len < d){
          d = len;
          f = node;
        }
      }
    }
    node = node.chain;
  }
  return f;
};

/*================================
        ai_core_findtarget

================================*/
entity() ai_core_findtarget={
  local entity t_opt, t_rdr;
  if(self.enemy == world){
    if(self.oldenemy != world){
      //an old grudge
      return self.oldenemy;
    }
    t_opt = ai_core_opticaltarget();
    if(t_opt != world){
      return t_opt;
    }
    t_rdr = ai_core_radartarget();
    if(t_rdr != world){
      return t_rdr;
    }
  }
  return world;
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

void(void() nex_state, float cache_state) ai_update_state={
  /*if(cache_state == TRUE){
    self.ai_state_cache = self.ai_next_state;
  }*/
  if(self.ai_prev_state != self.ai_next_state){
    self.ai_prev_state = self.ai_next_state;
  }
  self.ai_next_state = nex_state;
};

//gets convergence factor for pilot rating
float() ai_pilot_rating_converg={
  if(self.p_damage == 0){
    return AI_CNV_ACE;
  }
  else if(self.p_damage == 1){
    return AI_CNV_VET;
  }
  else if(self.p_damage == 2){
    return AI_CNV_REG;
  }
  else{
    return AI_CNV_ROK;
  }
};

//gets range modifier for pilot rating
float() ai_pilot_rating_range={
  if(self.p_damage == 0){
    return AI_RNG_ACE;
  }
  else if(self.p_damage == 1){
    return AI_RNG_VET;
  }
  else if(self.p_damage == 2){
    return AI_RNG_REG;
  }
  else if(self.p_damage == 3){
    return AI_RNG_ROK;
  }
  else{
    return 1;
  }
};

float() ai_pilot_yaw_mod={
  if(self.p_damage == 0){
    return AI_ROT_ACE;
  }
  else if(self.p_damage == 1){
    return AI_ROT_VET;
  }
  else if(self.p_damage == 2){
    return AI_ROT_REG;
  }
  else if(self.p_damage == 3){
    return AI_ROT_ROK;
  }
  else{
    return 1;
  }
};

//armor is modified based on skill level
float() ai_pilot_armor_mod={
  if(skill == 0){
    return AI_ARMOR_EASY;
  }
  else if(skill == 1){
    return AI_ARMOR_MEDM;
  }
  else if(skill == 2){
    return AI_ARMOR_HARD;
  }
  else if(skill == 3){
    return AI_ARMOR_NIGHT;
  }
  else{
    return AI_ARMOR_EASY;
  }
}

float() ai_pilot_rating_leading={
  if(self.p_damage == 0){
    return AI_LEAD_ACE;
  }
  else if(self.p_damage == 1){
    return AI_LEAD_VET;
  }
  else if(self.p_damage == 2){
    return AI_LEAD_REG;
  }
  else if(self.p_damage == 3){
    return AI_LEAD_ROK;
  }
  else{
    return AI_LEAD_ROK;
  }
};

void() ai_core_calcranges={
  local entity w;
  w = self.w_slot;
  while(w){
    if(w.deadflag <= DEAD_NO){
      local float dmg;
      dmg = w.p_damage * w.w_clipsize;
      if(w.w_range <= AI_RANGE_S){ 
        self.ai_dmg_s = self.ai_dmg_s + dmg;
      }
      if(w.w_range > AI_RANGE_S){
        if(w.w_range <= AI_RANGE_M){
          self.ai_dmg_m = self.ai_dmg_m + dmg;
          self.ai_dmg_s = self.ai_dmg_s + dmg;
        }
      }
      if(w.w_range > AI_RANGE_M){
        self.ai_dmg_m = self.ai_dmg_m + dmg;
        self.ai_dmg_s = self.ai_dmg_s + dmg;
        self.ai_dmg_l = self.ai_dmg_l + dmg;
      }
    }
    w = w.w_slot;
  }
  if((self.ai_dmg_l > self.ai_dmg_s) && (self.ai_dmg_l  > self.ai_dmg_s)){
    self.ai_minrange = AI_RANGE_L;
  }
  else if((self.ai_dmg_m > self.ai_dmg_l) && (self.ai_dmg_m  > self.ai_dmg_s)){
    self.ai_minrange = AI_RANGE_M;
  }
  else if((self.ai_dmg_s > self.ai_dmg_l) && (self.ai_dmg_s  > self.ai_dmg_m)){
    self.ai_minrange = AI_RANGE_S;
  }
  else{
    self.ai_minrange = AI_RANGE_S;
  }
};