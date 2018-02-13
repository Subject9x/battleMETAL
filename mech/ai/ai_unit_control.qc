/*
  battleMETAL
  Author: Peter Roohr
  Date: 11/30/2017
  Overview: impl for all the ai controller functions
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
  
  if(self.button0){
    if(self.th_missile){
      self.th_missile();
    }
  }

  if(self.button0){
    self.button0 = 0;
  }
  
  self.prev_pos = self.origin;
  if(self.m_fspeed > -1){
    self.ai_hasmoved = self.ai_next_move();
    self.prev_angle = normalize(self.origin - self.prev_pos);
    local vector aorg;
    if(self.trigger_field != world){
      aorg = self.trigger_field.origin;
    }
    else if(self.node != world){
      aorg = self.node.origin;
    }
    else{
      aorg = self.origin;
    }
    if(self.enemy != world){
      self.e_legs.v_angle_y = vectoyaw(aorg- self.origin);
    }
    else{
      self.e_legs.v_angle_y = self.v_angle_y;
    }
  }
  self.think = ai_control;
  self.nextthink = time + 0.05;
  self.e_cam.SendFlags = -1;
};

void() ai_turret_control={
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
  
  if(self.ai_next_state != ai_misc_stand_debug){
    if(ai_target_isValid(self.trigger_field)){
      if(ai_target_canSee(self.trigger_field)){
        self.ideal_yaw = vectoyaw(self.trigger_field.origin - self.origin);
        ChangeYaw();
        changepitch(self);
        if(ai_target_facingideal()){
          local float fire;
          fire = (crandom() * (5 - self.p_damage)+ 1);
          if(fire <= self.p_damage){
            self.button0 = 1;
          }        
        }
      }
    }
    else{
      if(self.oldenemy){
        self.trigger_field = self.oldenemy;
        self.enemy = self.trigger_field;
        self.oldenemy = world;
      }
      else{
        self.enemy = world;
      }
    }
  }
  
  if(self.th_missile){
    self.th_missile();
  }
  if(self.button0){
    self.button0 = 0;
  }
  
  local entity this;
  this = self;
  self = this.e_legs;
    makevectors(self.prev_angle);
    local vector adj;
    adj = this.origin + (v_up * self.c_ofs_y) + (v_right * self.c_ofs_x) + (v_forward * self.c_ofs_z);
    setorigin(self, adj);
  self = this;
  
  self.think = ai_turret_control;
  self.nextthink = time + 0.05;
  self.e_cam.SendFlags = -1;
};

//TODO - move this stuff to own file
void() ai_mech_update={
  local entity oself,wep_chain;
  
  ctrl_updateCenterTorso();
  
  if(self.e_legs){
    if(self.e_legs != world && oself.e_legs.owner == self){
      if(self.e_legs.deadflag <= DEAD_NO){
        oself = self;
        self = oself.e_legs;
          ctrl_updateLegs();
        self = oself;
      }
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
  local entity wep_chain;
  
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
  if(self.ai_first_order != AI_ORDER_DEBUG){
    if(other.data_type != DATA_POBS){
      if(other.i_faction != self.i_faction){
        //bumped a baddy!
        if((ai_target_infront(other)) || (self.enemy == world)){  
          self.oldenemy = self.enemy;
          self.enemy = other;
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
  mech_player_compdie(self.e_legs);
  mech_player_compdie(self.e_cam);
 
  ctor_die1();
 
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
  if(self.classname == "ai_node"){
    return;
  }
  if(self.ai_first_order != AI_ORDER_DEBUG){
    if(other.data_type != DATA_POBS){
      local float infront;
      infront = ai_target_infront(other);
      if(other.i_faction == self.i_faction){
        //bumped an ally!
        if(infront){   
          ai_move_controller(ai_move_runmove_slideleft, self.w_clipsize + self.vec_size);
          return;
        }
        else{
          ai_move_controller(ai_move_backward, self.w_clipsize + self.vec_size);
          return;
        } 
      }
      else{
        //bumped a baddy!
        if(self.enemy == world){
          if(other.data_type != DATA_POBS){
            if(self.enemy == world){
              self.enemy = other;
            }
            else{
              self.oldenemy = self.enemy;
              self.enemy = other;
            }
            self.ai_next_state = ai_hunt_target;
          }
          if(infront){   
            ai_move_controller(ai_move_runmove_slideright, self.w_clipsize + self.vec_size);
            return;
          }
          else{
            ai_move_controller(ai_move_backward, self.w_clipsize + self.vec_size);
            return;
          } 
        }
      }
    }
  }
};