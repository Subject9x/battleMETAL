/*
mech Mod
Date: 5/3/2017
Overview: ai extension funcs
*/

void() ai_control={
  local float astate, move, qrk;
  astate = self.ai_state;
  move = self.ai_move;
  qrk = self.ai_quirks;

  if(self.deadflag >= DEAD_DEAD){
    self.health = 0;
    self.th_die();
    return;
  }
  
  
  if(self.enemy){
    if(self.enemy.health <= 0){
      self.enemy = world;
    }
    if(self.enemy.p_class == P_OBS){
      self.enemy = world;
    }
    if(self.enemy != world){
      q_ai_face();
    }
  }
  
  if(self.p_class == P_MECH){
    ai_mech_update();
  }

  ai_weapon_update();
  ai_conv_update();
  
  if(astate == AI_STATE_WANDER){
    
  }
  else if(astate == AI_STATE_TOPOINT){
    self.goalentity = ai_find_node();
    if(self.goalentity != world){
      //bprint("found nav\n"); //DEBUG
      self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
      if(self.ai_move != AI_MOVE_WALK){
        self.ai_move = AI_MOVE_WALK;
      }
    }
    else{
      ai_update_state(AI_STATE_HUNT);
      self.ai_move = AI_MOVE_STAND;
    }
  }
  else if(astate == AI_STATE_HUNT){
    if(self.enemy == world){
      if(!ai_find_target()){
        //bprint(strcat(ftos(self.ai_state_prev)," to nav\n")); //DEBUG
        ai_update_state(AI_STATE_TOPOINT);
        self.ai_move = AI_MOVE_WALK;
      }
    }
    else{
      q_HuntTarget();
      self.th_missile();
    }
  }
 
  if(move == AI_MOVE_STAND){
    self.th_stand();
  }
  else if(move == AI_MOVE_WALK){
    self.th_walk();
  }
  else if(move == AI_MOVE_RUN){
    self.th_run();
  }

  self.think = ai_control;
  self.nextthink = time + 0.005;
};


void() ai_mech_walk={
  local float spd, dist;
  spd = self.m_fspeed / 500;
  dist = vlen(self.enemy.origin - self.origin);
  q_ai_walk(spd);
};

void() ai_mech_run={
  
  local float spd, dist;
  spd = self.m_fspeed / 500;
  spd = spd + (spd/3);
  dist = vlen(self.enemy.origin - self.origin);
  if(dist <= 200){
    self.ai_move = AI_MOVE_STAND;
  }
  else{
    q_ai_run(spd);
  }
};

void() ai_mech_attack={
  local entity ai, wep_chain, oself;
  local float dist;
  ai = self;
  if(self.enemy == world){
    //bprint("was world\n"); //DEBUG
    return;
  }
  
  if(!q_infront(self.enemy)){
    return;
  }
  if(!q_FacingIdeal()){
    return;
  }
  wep_chain = self.w_slot;
  dist = vlen(self.enemy.origin - self.origin);
  traceline(self.origin, self.enemy.origin, FALSE, self);
  if(trace_ent != self.enemy){
    //only fire on a clear shot.
    return;
  }
  while(wep_chain){
      if(wep_chain.w_isready){
        if( dist <= wep_chain.w_range){
          oself = self;
          self = wep_chain;
          if((self.p_dmgtype & EFF_STX)){
            if(ai.enemy.sh_cur >= (ai.enemy.sh_max/3)){
              self.w_attack();
            }
          }
          else{
            self.w_attack();
          }   
          self = oself;
        }
      }
    wep_chain = wep_chain.w_slot;
  }
};


void() ai_mech_stand={
  q_ai_stand();
};


void() ai_weapon_update={
  local entity wep_chain;
  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_wpn_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }
};


entity() ai_find_node={

  local entity node, f;
  local float d;
  if(self.goalentity == world){
    d = self.radar_range;
    node = findradius(self.origin, self.radar_range);
    while(node){
      local float len;
      if(node.classname == "ai_node"){
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
    //bprint("ai_find_node\n"); //DEBUG
    return f;
  }
  else{
    return self.goalentity;
  }
}

//quake c builtin wasn't getting the job done
float() ai_find_target={
  if(self.enemy){
    //already found a target
    return FALSE;
  }
  //make optical check first
  local entity targ, t_opt, t_rdr;
  local float len;
  t_opt = world;
  t_rdr = world;
  len = self.ai_optical;
  targ = findradius(self.origin, self.ai_optical);
  while(targ){
    if(targ != world){
      if(targ.p_class == P_MECH || targ.p_class == P_BULD){
        if(targ != self){
          if(targ.health > 0){
            if(targ.i_faction != self.i_faction){
              if(q_visible(targ)){
                if(q_infront(targ)){
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
  if(t_opt != world){
    //bprint(strcat("optical target: ", t_opt.classname,"\n"));//DEBUG
    //found a target in LoS
    self.enemy = t_opt;
    return TRUE;
  }
  
  //couldnt find a target in front?
  //TODO - stealth bots
  len = self.radar_range;
  targ = findradius(self.origin, self.radar_range);
  while(targ){
    if(targ != world){
      if(targ.p_class == P_MECH || targ.p_class == P_BULD){
        if(targ != self){
          if(targ.health > 0){
            if(targ.i_faction != self.i_faction){
              if(q_visible(targ)){
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
  if(t_rdr != world){
    //bprint(strcat("radar target: ", t_rdr.classname,"\n"));//DEBUG
    //found one on sensors;
    self.enemy = t_rdr;
    return TRUE;
  }
  return FALSE;
};

void() ai_mech_update={
  local entity oself;
  oself = self;
  ctrl_updateCenterTorso();
  if(oself.e_legs){
    if(oself.e_legs != world && oself.e_legs.owner == oself){
      self = oself.e_legs;
        ctrl_updateLegs();
      self = oself;
    }
  }
};

void() ai_mech_die={
  local entity w_chain, next;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_arm_l);
  mech_player_compdie(self.e_arm_r);
  mech_player_compdie(self.e_legs);
  
  ctor_die1();
  
  self.think = ai_mech_cleanup;
  self.nextthink = time + 1;
};

void() ai_mech_cleanup={
  mech_cleanupMech();
};

void() ai_conv_update={
  if(self.ai_move == AI_MOVE_STAND){
    self.stat_spr_x = self.stat_spr_x - self.conv_min_z;
    if(self.stat_spr_x < self.conv_min_x){
      self.stat_spr_x =  self.conv_min_x;
    }
    self.stat_spr_y = self.stat_spr_y - self.conv_min_z;
    if(self.stat_spr_y < self.conv_min_y){
      self.stat_spr_y =  self.conv_min_y;
    }
  }
  else{
    self.stat_spr_x = self.stat_spr_x + self.conv_max_z;
    if(self.stat_spr_x > self.conv_max_x){
      self.stat_spr_x =  self.conv_max_x;
    }
    self.stat_spr_y = self.stat_spr_y + self.conv_max_z;
    if(self.stat_spr_y > self.conv_max_y){
      self.stat_spr_y =  self.conv_max_y;
    }
  }
};

void(float new_state) ai_update_state={
  if(self.ai_state_prev != self.ai_state){
    //only cache the difference
    self.ai_state_prev = self.ai_state;
  }
  self.ai_state = new_state;
};