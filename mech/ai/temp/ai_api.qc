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
      if ( (self.spawnflags & AI_SPAWNFLAG_CAMPAIGN) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_COOP:
      if ( (self.spawnflags & AI_SPAWNFLAG_COOP) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_DM:
      if ( (self.spawnflags & AI_SPAWNFLAG_DM) ){
        rem = TRUE;
      }
      break;
    case GAMEMODE_TEAMDM:
      if ( (self.spawnflags & AI_SPAWNFLAG_TDM) ){
        rem = TRUE;
      }
      break;
  }
  return rem;
};

float(entity t) ai_valid_target={
  if ( t ){
    if( t.deadflag <= DEAD_NO ){
      if( t.i_faction != self.i_faction ){
        if( t.data_type == DATA_BLD ){
          return TRUE;
        }
        if( t.data_type == DATA_MECH ){
          return TRUE;
        }
        if( t.data_type == DATA_MECH_AI ){
          return TRUE;
        }
        if( t.data_type == DATA_VEHC ){
          return TRUE;
        }
      }
    }
  }
  return FALSE;
};

float() ai_find_target_visual={
  local entity targ, found;
  local float dist, rng;
  targ = findradius(self.origin, self.ai_view);
  dist = self.ai_view;
  rng = dist;
  while( targ ){
    if( ai_valid_target(targ) ){
      if( ai_target_infront(targ, self.ai_fov) ){
        if( ai_visible(targ) ){
          local float ndist;
          ndist = vlen(targ.origin - self.origin);
          if(ndist < rng){
            rng = ndist;
            found = targ;
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
  local entity targ, found;
  local float dist, rng;
  targ = findchainflags(flags, FL_UNIT);
  dist = self.radar_range;
  rng = dist;
  if( self.stat_rdr_mode ){
    rng = rng * 2;
  }
  while( targ ){
    if( ai_valid_target(targ) ){
      local float ndist, nrng;
      nrng = rng;
      ndist = vlen(targ.origin - self.origin);
      if( ndist <= rng ){
        if( (targ.flags & FL_CLIENT) ){
          if( !targ.stat_rdr_mode ){
            if( ndist <= (nrng / 2 ) ){
              nrng = ndist;
              found = targ;
            }
          }
        }
        else{
          if(ndist < nrng){
            nrng = ndist;
            found = targ;
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

/*
  modified Q1's impl by making the view range a variable
*/
float(entity targ, float ang_limit) ai_target_infront={
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
  
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

vector(entity ai) ai_attack_calcSpread={
  local vector hitorg;
  local float rng, cnv, cx, cy;
  //if(ai.stat_trg_dist > ai.ai_minrange){
  //  cnv = cnv * rng;
  //}
  cx = cnv;
  cx = cx + ( cnv / 2 * random() );
  cx = cx * crandom();
  cy = cnv; 
  cy = cy + ( cnv / 2 * random() );
  cy = cy * crandom();
  
  makevectors(ai.angles);
  hitorg = ai.w_fire_ofs + (v_up * cy) + (v_right * cx);
  return hitorg;
};

vector(entity wep) ai_attack_trace={
  local entity cam;
  local vector lead, cam_ofs;
  
  lead = self.enemy.origin - (self.enemy.velocity * self.ai_leading);
  lead = normalize(lead - self.origin);
  cam = self.e_cam;
  
  makevectors(self.angles);
  traceline (self.origin + v_forward * 1, self.origin + lead*wep.w_range, TRUE, self);
  
  return trace_endpos;
};

void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  this = self;
  wep_chain = self.w_slot;
  self.v_angle = self.angles;
  while(wep_chain){
    if(self.button0){
      if(wep_chain.w_state == READY){
        if( self.stat_trg_dist <= wep_chain.w_range ){
          self.w_fire_ofs = ai_attack_trace(wep_chain);
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

  viewpont = normalize(self.enemy.origin - self.e_cam.origin);
  makevectors(self.angles);
  traceline (self.e_cam.origin + v_forward * 1, self.e_cam.origin + viewpont*wep.w_range, FALSE, self);

  if(trace_ent == world){
    return TRUE;
  }
  if( trace_ent.i_faction == self.i_faction ){
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

//AI Nodes
//the patrol node touch 
void() ai_node_t_patrol={
  local entity	temp;
  
  if( other.movetarget != self ){
    return;
  }
  
  if( ai_valid_target( other.enemy ) ){
    return;
  }
  
  temp = self;
	self = other;
	other = temp;

	//if (self.classname == "monster_ogre")
		//sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if ( !self.movetarget ){
		self.pausetime = time + 999999;
    ai_action_next( self.th_stand, 1, self.ai_action_mod );
		return;
	}
};

void() ai_node_t_defend={
  
};
void() ai_node_t_attack={
  
};

/*
  Only used for AI_SPAWNFLAG_RANDDOMSTART
*/
string( string grpid ) ai_node_pick_rand={
  local entity node;
  local float clr, total, pick;
  total = 0;
  clr = 0;
  while( clr <= 128 ){
    AI_NODES[clr] = "";
    clr = clr + 1;
  }
  
  node = findchain( group, grpid);
  if( node ){  
    while( node ){
      AI_NODES[total] = node.targetname;
      total = total + 1;
      node = node.chain;
    }
    pick = crandom() * total;
    return AI_NODES[pick];
  }
  return "false";
};

