/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

//TODO - move this stuff to own file
void() ai_mech_update={
  local entity oself,wep_chain;
  
  ctrl_updateCenterTorso();
  
  if(self.e_legs){
    if(self.e_legs != world && oself.e_legs.owner == self){
      oself = self;
      self = oself.e_legs;
        ctrl_updateLegs();
      self = oself;
    }
  }
  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_wpn_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }
  
  /*if(self.ai_next_move == ai_move_stand){
    self.stat_spr_x = self.stat_spr_x - (self.conv_min_z / 100);
    if(self.stat_spr_x < self.conv_min_x){
      self.stat_spr_x =  self.conv_min_x;
    }
    self.stat_spr_y = self.stat_spr_y - (self.conv_min_z  / 100);
    if(self.stat_spr_y < self.conv_min_y){
      self.stat_spr_y =  self.conv_min_y;
    }
  }
  else{
    self.stat_spr_x = self.stat_spr_x + (self.conv_max_z * 10);
    if(self.stat_spr_x > self.conv_max_x){
      self.stat_spr_x =  self.conv_max_x;
    }
    self.stat_spr_y = self.stat_spr_y + (self.conv_max_z * 10);
    if(self.stat_spr_y > self.conv_max_y){
      self.stat_spr_y =  self.conv_max_y;
    }
  }*/
    
  if(self.enemy != world){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
};


void() ai_mech_die={
  local entity w_chain;
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
  mech_player_compdie(self.e_cam);
  
  ctor_die1();
  
  self.think = ai_mech_cleanup;
  self.nextthink = time + 100;
};

void() ai_mech_cleanup={
  mech_cleanupMech();
  self.think = SUB_Remove;
  self.nextthink = time + 1;
};

void() ai_mech_touch={
  if(other.p_class != P_OBS){
    local float infront;
      infront = ai_target_infront(other);
    if(other.i_faction == self.i_faction){
      //bumped an ally!
      if(infront){
        self.ai_next_move = ai_move_backward;
      }
      else{
        self.ai_next_move = ai_move_forward;
      } 
    }
    else{
      //bumped a baddy!
      if(self.enemy == world){
        if(other.p_class == P_MECH){
          if(self.enemy == world){
            self.enemy = other;
          }
          else{
            self.oldenemy = self.enemy;
            self.enemy = other;
          }
        }
        if(infront){
          self.ai_next_move = ai_move_run_goal_slide;
          return;
        }
        else{
          self.ai_next_move = ai_move_backward;
          return;
        } 
      }
    }
  }
};

//this is run after the unit spawns in
void() ai_spawn_start={
  if(self.target){
    self.goalentity = find(world, targetname, self.target);
  }
};

/*
  Core controller for any AI unit
*/
void() ai_control={
  if(self.deadflag >= DEAD_DYING){
    self.health = 0;
    self.th_die();
    return;
  }
  self.ai_unit_update();
  if(self.health <= (self.max_health /3)){
    if(self.en_cur <= 0){
      if(self.ai_next_state != ai_state_panic){
        self.ai_next_state =ai_state_panic;
      } 
    }
  }
  self.ai_next_state();
  self.ai_next_move();
  self.think = ai_control;
  self.nextthink = time + 0.05;
  self.e_cam.SendFlags = 1;
};

//move directives
void() ai_move_stand={
  if(ai_core_targetstate()){
    ChangeYaw();
  }
};

void() ai_move_walk_goal={
  self.e_legs.movetype = MOVETYPE_NONE;
  self.e_legs.angles = self.angles;
  self.e_legs.movetype = MOVETYPE_FOLLOW;
  movetogoal(self.m_fspeed * AI_WALK_SPD);
};

void() ai_move_walk_goal_slide={
  local float ofs;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  if (self.lefty){
		ofs = 90;
	}
  else{
		ofs = -90;
	}
	if (walkmove (self.ideal_yaw + ofs,  self.m_fspeed * AI_WALK_SPD)){
    self.e_legs.angles_y = self.ideal_yaw + ofs;
		return;
  }
	self.lefty = 1 - self.lefty;
  walkmove( self.ideal_yaw, self.m_fspeed * AI_WALK_SPD);
  self.e_legs.angles = self.v_angle;
};

void() ai_move_run_goal={  
  movetogoal(self.m_fspeed * AI_RUN_SPD);
  self.e_legs.angles = self.angles;
};

void() ai_move_run_goal_slide={  
  local float ofs;
  ChangeYaw();
  if (self.lefty){
		ofs = 90;
	}
  else{
		ofs = -90;
	}
	if (walkmove (self.ideal_yaw + ofs,  self.m_fspeed * AI_RUN_SPD)){
      self.e_legs.angles_y = self.angles_y + ofs;
		return;
  }
	self.lefty = 1 - self.lefty;
  walkmove( self.ideal_yaw, self.m_fspeed * AI_RUN_SPD);
  self.e_legs.angles_y = self.ideal_yaw;
};

void() ai_move_forward={  
  self.e_legs.angles_y = self.angles_y;
  walkmove (self.angles_y, self.m_fspeed * AI_WALK_SPD);
};

void() ai_move_backward={  
  self.e_legs.angles_y = self.angles_y + 180;
  walkmove ((self.angles_y+180), self.m_fspeed * AI_WALK_SPD);
};

