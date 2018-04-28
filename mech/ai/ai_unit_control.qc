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
  if(self.deadflag == DEAD_DYING){
    self.health = 0;
    self.deadflag = DEAD_DEAD;
    self.nextthink = time + 0.1;
    return;
  }
  //give server chance to update 
  if(self.deadflag == DEAD_DEAD){
    if(!self.th_die){
      self.th_die = SUB_Remove;
    }
    self.th_die();
    return;
  }
  self.e_tor_c.angles_y = self.ideal_yaw;  //sync the center torso to the bot
  
  if(self.ai_unit_update){
    self.ai_unit_update();
  }
  
  if(self.ai_next_state){
    self.ai_next_state();
  }  

  if(self.m_fspeed > -1){
    local float moveFlag, moveDelta;
    self.prev_pos = self.origin;

    moveFlag = self.ai_next_move();
    moveDelta = vlen(self.prev_pos - self.origin);
    
    if(self.ai_next_move != ai_move_stand){
      self.e_legs.v_angle_y = self.p_velocity;
    }
    else{
      self.e_legs.v_angle_y = self.v_angle_y;
    }
  }
  self.think = ai_control;
  self.nextthink = time + 0.075;
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
    local entity contact;
    if(!self.stat_rdr_mode){
      self.stat_rdr_mode = TRUE;
    }
    if(self.stat_rdr_mode){
      if(self.trigger_field == world){
        local entity contact;
        contact = ai_target_radarTarget();
        if(contact){
          ai_update_switchToTarget(contact);
          self.patience = time + self.maxpatience ;
        }
      }
      else{
        if( time > self.maxpatience){
          local entity contact;
          contact = ai_target_radarTarget();
          if(contact){
            ai_update_switchToTarget(contact);
            self.patience = time + self.maxpatience ;
          }
        }
      }
    }
    if( ai_target_isValid(self.trigger_field) ){
      self.patience = 0;
      self.ideal_yaw = vectoyaw(self.trigger_field.origin - self.origin);
      ChangeYaw();
      changepitch(self);
      if( ai_target_canSee(self.trigger_field) ){
        self.patience = 0;
        if( time > self.attack_finished){
          if(ai_target_facingideal()){
            self.attack_finished = time + ai_core_attackInterval();
            self.button0 = 1; 
          }
        }
      }
      else{
        self.patience = time + self.maxpatience;
      }
    }
    else{
      ai_target_clearBuffers();
      self.patience = 0;
    } 
  }

  if(self.button0){  
    if(self.th_missile){
      self.th_missile();
    }
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
  
  if(self.trigger_field != world){
    self.stat_trg_dist = vlen(self.trigger_field.origin - self.origin);
  }
  
  local entity wep_chain;
  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_wpn_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }
  
  if(self.th_missile){
    self.th_missile();
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
  if(self.trigger_field != world){
    self.stat_trg_dist = vlen(self.trigger_field.origin - self.origin);
  }
};

void() ai_turret_touch={
  if(self.ai_first_order != AI_ORDER_DEBUG){
    if(other.data_type != DATA_POBS){
      if(other.i_faction != self.i_faction){
        //bumped a baddy!
        if((ai_target_inForwardArc(other)) || (self.enemy == world)){  
          self.oldenemy = self.enemy;
          ai_update_switchToTarget(other);
        }
      }
    }
  }
};

void() ai_turret_die={
  local entity w_chain, debris, this;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  setmodel(self, self.e_legs.model);
  setorigin(self, self.e_legs.origin);
  self.angles = self.e_legs.angles;  
  self.solid = SOLID_CORPSE;
  self.movetype = MOVETYPE_BOUNCE;
  
  mech_player_compdie(self.e_tor_c);
  mech_player_compdie(self.e_legs);
  mech_player_compdie(self.e_cam);

  //fire triggers when dead
  if(self.target_die){
    self.target = self.target_die;
    self.enemy = self.ladder_entity;
    activator = self.enemy;
    SUB_UseTargets ();
  }
 
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
  
  setmodel(self, self.e_tor_c.model);
  mech_player_compdie(self.e_tor_c);
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_arm_l);
  mech_player_compdie(self.e_arm_r);
  mech_player_compdie(self.e_legs);
  mech_player_compdie(self.e_cam);
  
  ctor_die1();
  
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_CORPSE;
  
  //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
	SUB_UseTargets ();
  
  self.think = ai_mech_cleanup;
  self.nextthink = time + 100;
};

void() ai_mech_cleanup={
  mech_cleanupMech();
  self.think = SUB_Remove;
  self.nextthink = time + 1;
};

void() ai_mech_touch={
  //TODO - refactor and fill out this stub
  if(other.data_type == DATA_BLD){
  }
};