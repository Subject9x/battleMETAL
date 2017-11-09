/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/


/*
  Core controller for any AI unit
*/
void() ai_control={
  if(self.deadflag >= DEAD_DYING){
    self.health = 0;
    if(self.th_die){
      self.th_die();
    }
    else{
      self.th_die = SUB_Remove;
      self.th_die();
    }
    return;
  }
  if(self.ai_unit_update){
    self.ai_unit_update();
  }
  
  if(self.ai_next_state){
    self.ai_next_state();
  }
  if(self.th_missile){
    self.th_missile();
  }
  if(self.button0){
    self.button0 = 0;
  }
  self.prev_pos = self.origin;
  if(self.m_fspeed > -1){
    if(self.e_legs.walkframe > 9){
      self.e_legs.walkframe = 2;
    }
    self.ai_next_move();
    self.prev_angle = normalize(self.origin - self.prev_pos);
    if(self.enemy != world){
      self.e_legs.v_angle_y = vectoangles(self.enemy.origin - self.origin) + self.p_velocity;
    }
    else{
      self.e_legs.v_angle_y = self.v_angle_y;
    }
  }
  self.think = ai_control;
  self.nextthink = time + 0.05;
  self.e_cam.SendFlags = 1;
};

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
  if(self.enemy != world){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
};

void() ai_turret_update={
  local entity oself,wep_chain;
  
  ctrl_updateTurret();

  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_wpn_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }  
  if(self.enemy != world){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
};

void() ai_turret_touch={
  if(self.ai_first_order != ai_order_test){
    if(other.p_class != P_OBS){
      local float infront;
      infront = ai_target_infront(other);
      if(other.i_faction != self.i_faction){
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
        }
      }
    }
  }
};

void() ai_turret_die={
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }

  setmodel(self, self.e_legs.c_model);
  setsize(self, '-1 -1 -10', '1 1 1');
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.angles = self.e_legs.prev_angle;
  droptofloor();
  
  mech_player_compdie(self.e_legs);
  mech_player_compdie(self.e_cam);
 
  self.think = ai_mech_cleanup;
  self.nextthink = time + 100;
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
  if(self.ai_first_order != ai_order_test){
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
            self.ai_next_move = ai_move_runmove_slide;
            return;
          }
          else{
            self.ai_next_move = ai_move_backward;
            return;
          } 
        }
      }
    }
  }
};


/*
the controller function is a state controller
for move states. Instantly changing directons may work
for classic Quake, but battleMETAL needs a more refined
system for controlling the movements of AI. this is
really just important during the ai_sub_fight() func.

entity ai - the ai to act upon
void() move - the desired move function
float frames - how many server think frames to run movement for
*/
void(void() move, float frames) ai_move_controller={
  ChangeYaw();
  //if(self.w_isready <= self.w_clipsize){
    //hold the present course
    self.w_isready = self.w_isready + 1;
  //}
  //else{
    //set new course and duration
    //self.w_isready = 0;
    //self.w_clipsize = frames;
    if(move == ai_move_stand){
      self.ai_next_move = ai_move_stand;
    }
    else if(move == ai_move_walk_goal){
      if(self.ai_prev_state != ai_sub_fight){
        self.ai_next_move = ai_move_walk_goal;
      }
      else{
        self.ai_next_move = ai_move_stand;
      }
    }
    else if(move == ai_move_run_goal){
      if(self.ai_prev_state != ai_sub_fight){
        self.ai_next_move = ai_move_walk_goal;
      }
      else{
        self.ai_next_move = ai_move_stand;
      }
    }
    else if(move == ai_move_walkmove_strafeleft){
      if(self.ai_prev_move == ai_move_walkmove_straferight){
        self.ai_next_move = ai_move_stand;
      }
      else{
        self.ai_next_move = ai_move_walkmove_strafeleft;
      }
    }
    else if( move == ai_move_walkmove_straferight){
      if(self.ai_prev_move == ai_move_walkmove_strafeleft){
        self.ai_next_move = ai_move_stand;
      }
      else{
        self.ai_next_move = ai_move_walkmove_straferight;
      }
    }
    else if(move == ai_move_forward){
      if(self.ai_prev_move == ai_move_backward){
        self.ai_next_move = ai_move_stand;
      }
      else{
        self.ai_next_move = ai_move_forward;
      }
    }
    else if(move == ai_move_backward){
      if(self.ai_prev_move == ai_move_forward){
        self.ai_next_move = ai_move_stand;
      }
      else{
        self.ai_next_move = ai_move_backward;
      }
    }
    else if(move == ai_move_charge){
      if(self.ai_prev_move == ai_move_backward){
        self.ai_next_move = ai_move_stand;
      }
      else{
        self.ai_next_move = ai_move_charge;
      }
    }
    else{
      self.ai_next_move = ai_move_stand;
    }
  //}
};

//move directives
void() ai_move_random={
  local float r;
  r = random();
  if(r < 0.25){
    ai_move_controller(ai_move_backward, r*2);
  }
  else if((r >= 0.25) && (r < 0.5)){
    ai_move_controller(ai_move_forward, r*2);
  }
  else if((r >= 0.5) && (r < 0.75)){
    ai_move_controller(ai_move_walkmove_strafeleft, r*2);
  }
  else if(r >= 0.75){
    ai_move_controller(ai_move_walkmove_straferight, r*2);
  }
};

void() ai_move_stand={

  self.e_legs.walkframe = 1;
  if(self.ai_prev_move == ai_move_walkmove_strafeleft){
    self.ai_next_move = ai_move_walkmove_straferight;
  }
  else if(self.ai_prev_move == ai_move_walkmove_straferight){
    self.ai_next_move = ai_move_walkmove_strafeleft;
  }
  else{
    self.ai_prev_move = ai_move_stand;
  }
};

void() ai_move_walk_goal={
  movetogoal(self.m_fspeed * AI_WALK_SPD);
  self.ai_prev_move = ai_move_walk_goal;
  self.p_velocity = 0;
};

void() ai_move_run_goal={
  movetogoal(self.m_fspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_move_run_goal;
  self.p_velocity = 0;
};

void() ai_move_walkmove_slide={
  local float ofs;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  if (self.lefty){
		ofs = 90;
	}
  else{
		ofs = -90;
	}
	if (walkmove (self.ideal_yaw + ofs,  self.m_fspeed * AI_WALK_SPD)){
    self.ai_prev_move = ai_move_walkmove_slide;
    self.p_velocity = ofs;
		return;
  }
	self.lefty = 1 - self.lefty;
  walkmove( self.ideal_yaw, self.m_sspeed * AI_WALK_SPD);
  self.ai_prev_move = ai_move_walkmove_slide;
  self.p_velocity = ofs;
};

void() ai_move_runmove_slide={  
  local float ofs;
  if (self.lefty){
		ofs = 90;
	}
  else{
		ofs = -90;
	}
	if (walkmove (self.ideal_yaw + ofs,  self.m_sspeed * AI_RUN_SPD)){
		self.ai_prev_move = ai_move_runmove_slide;
    self.p_velocity = ofs;
    return;
  }
	self.lefty = 1 - self.lefty;
  walkmove( self.ideal_yaw, self.m_sspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_move_runmove_slide;
  self.p_velocity = ofs;
};

void() ai_move_forward={
  walkmove (self.angles_y, self.m_fspeed * AI_WALK_SPD);
  self.ai_prev_move = ai_move_forward;
  self.p_velocity = 0;
};

void() ai_move_backward={
  walkmove ((self.angles_y+180), self.m_bspeed * AI_WALK_SPD);
  self.p_velocity = self.angles_y+180;
  self.ai_prev_move = ai_move_backward;
  self.p_velocity = 0;
};

void() ai_move_walkmove_strafeleft={
  if(walkmove (self.ideal_yaw - 90,  self.m_sspeed * AI_WALK_SPD)){
    self.p_velocity = -90;
    self.ai_prev_move = ai_move_walkmove_straferight;
  }
  else{
    self.ai_next_move = ai_move_walkmove_strafeleft;
    self.p_velocity = 0;
  }
};

void() ai_move_walkmove_straferight={
  if(walkmove (self.ideal_yaw + 90,  self.m_sspeed * AI_WALK_SPD)){
    self.p_velocity = 90;
    self.ai_prev_move = ai_move_walkmove_straferight;
  }
  else{
    self.ai_next_move = ai_move_walkmove_strafeleft;
    self.p_velocity = 0;
  }
};

void() ai_move_charge={
  if not(walkmove (self.ideal_yaw - 60,  self.m_fspeed * AI_RUN_SPD)){
    ai_move_stand();
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = 0;
  }
  else{
    self.ai_prev_move = ai_move_charge;
    self.p_velocity = -60;
  }
};
