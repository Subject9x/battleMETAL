/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: Main Impl for AI API
*/

/*
  Checks spawnflags to game mode, to make sure bot 
  is allowed to spawn in
*/
float(float mode) ai_spawn_clean={
  local float rem;
  rem = FALSE;
  switch(mode){
    case GAMEMODE_CAMPAIGN:
      if ( (mode & AI_SPAWNFLAG_CAMPAIGN) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_COOP:
      if ( (mode & AI_SPAWNFLAG_COOP) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_DM:
      if ( (mode & AI_SPAWNFLAG_DM) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_TEAMDM:
      if ( (mode & AI_SPAWNFLAG_TDM) ){
        rem = TRUE;
      }
      break;
  }
  return rem;
};

float(entity t) ai_valid_target={
  if(!t){
    //dead simple check
    return FALSE;
  }
  if(t == world){
    return FALSE;
  }
  if(t == self){
    return FALSE;
  }
  if(t.owner == self){
    return FALSE;
  }
  if(t.data_type == DATA_POBS){
    return FALSE;
  }
  if(t.deadflag >= DEAD_DYING){
    return FALSE;
  }
  if(t.health <= 0){
    return FALSE;
  }
  if(t.classname == MECH_PIECE){
    return ai_valid_target(t.owner);
  }
  if(t.i_faction == self.i_faction){
    return FALSE;
  }
  return TRUE;
};

entity() ai_find_target_visual={
  local entity targ, found;
  local float dist, rng;
  targ = findradius(self.origin, self.ai_view);
  dist = self.ai_view;
  rng = dist;
  while( targ ){
    if( (targ.flags & FL_CLIENT) || (targ.flags & FL_MONSTER) ){
      if( targ.deadflag <= DEAD_NO ){
        if( targ.i_faction != self.i_faction ){
          if( (targ.data_type == DATA_MECH) || (targ.data_type == DATA_VEHC) || (targ.data_type == DATA_MECH_AI) || (targ.data_type == DATA_BLD) ){
            if( ai_visible(targ) ){
              if( ai_target_infront(targ, self.ai_fov) ){
                local float ndist;
                ndist = vlen(targ.origin - self.origin);
                if(ndist < rng){
                  rng = ndist;
                  found = targ;
                }
              }
            }
          }
        }
      }
    }
    targ = targ.chain;
  }
  if( found ){
    if( found == self.enemy ){
      return FALSE;
    }
    self.enemy = found;
    ai_found_target();
    return TRUE;
  }
  return FALSE;
};

entity() ai_find_target_radar={

};

/*
  modified Q1's impl by making the view range a variable
*/
float(entity targ, float ang_limit) ai_target_infront={
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	cons_logAFloat("dot", dot);
	cons_logAFloat("ang_limit", ang_limit);
	if ( dot >= ang_limit){
		return TRUE;
	}
	return FALSE;
};


float (entity targ) ai_visible ={
  local vector	spot1, spot2;
  
  spot1 = self.origin + self.view_ofs;
  spot2 = targ.origin + targ.view_ofs;
  traceline (spot1, spot2, TRUE, self); // see through other monsters
  
  if (trace_inopen && trace_inwater){
    return FALSE;     // sight line crossed contents
  }
  if (trace_fraction == 1){
    return TRUE;
  }
  return FALSE;
};

vector() ai_attack_trace={
  local entity cam;
  local vector lead, cam_ofs;
  lead = self.enemy.origin - (self.enemy.velocity * self.ai_leading);
  lead = normalize(lead - self.origin);
  cam = self.e_cam;
  makevectors(self.angles);
  cam_ofs = cam.origin + (v_forward * (self.c_bbx_x_x / 2) );
  traceline(cam_ofs, self.enemy.origin, FALSE, self);
  return trace_endpos;
};

void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  this = self;
  wep_chain = self.w_slot;
  self.w_fire_ofs = ai_attack_trace();
  while(wep_chain){
    if(self.button0){
      if(wep_chain.w_state == READY){
        if( ai_target_facingideal() && (self.stat_trg_dist <= wep_chain.w_range) ){
          if( !ai_attack_blockcheck(wep_chain) ){
            if( ai_attack_checkEne(wep_chain) ){
              self = wep_chain;
                if( (self.p_dmgtype & EFF_STX) ){
                  if (this.enemy.sh_cur >= self.p_damage){
                    fired = fired + 1;
                    self.w_attack();
                  }
                }
                else{
                  fired = fired + 1;
                  self.w_attack();
                }
              self = this; 
            }         
          }
        }
      }
    }
    else{
      if(wep_chain.w_isburst == TRUE){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = this;
        }
      }
    }
    wep_chain = wep_chain.w_slot;
  }
  if( fired > 0 ){
    self.attack_finished = time + ai_core_attackInterval();
  }
};

/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity
  friendlies
*/  
float(entity wep) ai_attack_blockcheck={
  local vector viewpont;
  makevectors(self.angles);
  traceline (self.e_cam.origin + v_forward * 1, self.enemy.origin, FALSE, self);
  viewpont = trace_endpos;
  
  makevectors(wep.angles);
  tracebox(viewpont, '-2 -2 -2', '2 2 2', wep.origin, FALSE, self);
  if(trace_ent == world){
    return TRUE;
  }
  if(trace_ent.i_faction == self.i_faction){
    return TRUE;
  }
  /*if(trace_ent != self.enemy){
    if(self.p_damage <= AI_RANK_VET){
      if(self.ai_type != AI_TYPE_AGGRO){
        return TRUE;
      }
    }
  }*/
  return FALSE;
};