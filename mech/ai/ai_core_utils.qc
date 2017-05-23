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
  local float dist;
  if(!self.enemy){
    if(self.oldenemy){
      //an old grudge
      self.enemy = self.oldenemy;
      return TRUE;
    }
    t_opt = ai_core_opticaltarget();
    if(t_opt){
      //found a target in LoS
      self.enemy = t_opt;
      return TRUE;
    }
    t_rdr = ai_core_radartarget();
    if(t_rdr){
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
  local float stat;
  stat = TRUE;
  if(self.enemy.p_class){
    if(self.enemy.p_class == P_OBS){
      stat = FALSE;
    }
  }
  else{
    stat = FALSE;
  }
  if(self.enemy.deadflag >= DEAD_DYING){
    stat = FALSE;
  }
  if(self.enemy.health <= 0){
    stat = FALSE;
  }
  return stat;
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
      if(ai_target_visible(targ)){
        if(targ.p_class == P_MECH || targ.p_class == P_BULD){
          if(targ != self){
            if(targ.health > 0){
              if(targ.i_faction != self.i_faction){
                if(ai_target_infront(targ)){
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
      if(ai_target_visible(targ)){
        if(targ.p_class == P_MECH || targ.p_class == P_BULD){
          if(targ != self){
            if(targ.health > 0){
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
determins if an entity is in front of calling ent
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


/*================================
        ai_target_visible
determins if an entity is in front of calling ent
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