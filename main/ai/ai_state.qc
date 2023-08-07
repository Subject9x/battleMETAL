/*
battleMETAL
Author: Peter Roohr
Date: 07/02/2020
Overview: 
  state machine for all AI
  
  my goals for this current AI death ride
    + make sure bots can maintain their set paths (think being ordered to do something)
    + dont get stuck while fighting the player
*/

/*
  atomic state solution, per-frame updates are run as small header funcs inside a state
*/
void() ai_frame_update={
  self.ai_unit_update();
  if( !self.deadflag ){
    makevectors(self.angles);
    self.cameraOrigin = self.origin + (v_forward * self.cameraOffset_z) + (v_right * self.cameraOffset_x) + (v_up * self.cameraOffset_y);
    
    if( ai_valid_target(self.enemy) ){
      ai_turret_set_state(TR_TARG);
      self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
      ai_lock_on();
    }
    else{ 
      self.button0 = FALSE;
    }
    self.attackFlag = 0;
    ai_ranged_attack();
    self.button0 = FALSE;
    if( (self.flags&FL_TURRET) ){
      ai_turret_control();
    }
    if( self.legs_mdl ){
      ai_leg_control();
    }
    if( time > self.posFadeTimer ){
      self.posFadeTimer = time + POSITION_FADE_TIME;
      self.position2 = self.position1;
      self.position1 = self.origin;
    }
  }
};

/*
  Tear-down and rebuild of AI.
    things got overcomplicated (see the commit history, haha)
    
    ty EMR for helping me think through it.
    
  Lowest energy AI behavior.
    Only chases target while target is actually visible,
    will return to normal behavior without target.
*/
void() ai_state_lurker_frame={
  local float visCheck;
  
  if( !self.ai_freeze ){
    ai_frame_update();
    if( ai_valid_target(self.enemy) ){
    //has enemy -> combat stuff
      visCheck = ai_check_vis(self.enemy);
      if( visCheck == VIS_FRAC ){
      //enemy is visible, 
        if( self.ai_lastVis == VIS_FAIL ){
          ai_nodegraph_clear_path();
        }
        ai_attack();
        //is enemy reachable from my firing position?
        if( self.ai_minrange < self.stat_trg_dist || !self.combatFlags ){
          ai_nodegraph_combat_frame();
        }
        else if( self.stat_trg_dist <= self.ai_minrange ){
          //stop-to-shoot vs dont stop-to-shoot
          ai_face_targ();
        }
        else{
          //bare minimum
          ai_face_targ();
        }
      }
      else if( visCheck == VIS_FRN ){
        if( trace_ent.think == ai_state_lurker_frame ){
          ai_nodegraph_combat_frame();
        }
      }
      else{
        if( self.ai_lastVis != VIS_FAIL ){
          self.ai_timer_checkTargFade = time + (1 + (self.ai_rank * 1.25));
          self.ai_fadePos = self.enemy.origin;
        }
        self.enemy = world;
      }
      self.ai_lastVis = visCheck;
    }
    else{
      if( (self.flags&FL_TURRET) ){
        self.torC_attackState = TR_NORM;
      }
    //No ENEMY, what was I doing before?
      if( time < self.ai_timer_checkTargFade ){
        //complete the fade turn; game is mostly single player :P
        ai_face_targ_fade();
      }
      else{
        if( !ai_check_scan( self.stat_rdr_mode ) ){
          if( self.tether == TETHER_PATROL ){
            if( self.patrolNode ){
              ai_nodegraph_patrol_frame( self.data_speed_strafe, self.data_speed_forward * 0.75 );
            }
            else{
              self.tether = TETHER_NONE;
              self.moveState = MOVE_STAND;
            }
          }
          else{
            self.tether = TETHER_NONE;
            self.moveState = MOVE_STAND;
          }
        }
      }
    }
  }
  
  //network delta
  ai_frame_net_send();
  
  self.think = ai_state_lurker_frame;
  self.nextthink = time + AI_RATE;
};

/*
  Designed to pursue player up till lost line of sight.
  these brawl with players constantly.
  
*/
void() ai_state_brawler_frame={
  local float visCheck;
  
  if( !self.ai_freeze ){
    ai_frame_update();
    if( ai_valid_target(self.enemy) ){
      visCheck = ai_check_vis(self.enemy);
      if( visCheck == VIS_FRAC){
        //set via ai_check_pause() in ai_nodegraph_combat_brawler_frame();
        if( self.ai_fight_pause == TRUE && time > self.ai_timer_breathe ){
          ai_state_set_pause();
          self.ai_lastVis = visCheck;
          return;
        }
        
        //enemy is visible, 
        ai_attack();
        //is enemy reachable from my firing position?
        ai_nodegraph_combat_brawler_frame();
      }
      else{
        if( visCheck == VIS_FAIL && self.ai_lastVis != VIS_FAIL ){
          //go to last reported position
          self.ai_timer_checkTargFade = time + (1 + (self.ai_rank * 2));
          switch(self.ai_rank){
            default:
              self.ai_fadePos = self.enemy.position2;
              break;
            case AI_RANK_VET:
              self.ai_fadePos = self.enemy.position1;
              break;
            case AI_RANK_ACE:
              self.ai_fadePos = self.enemy.origin;
              break;
          }
          ai_nodegraph_frame( self.ai_fadePos, self.ai_fadePos, self.data_speed_forward * 0.75, self.data_speed_forward * 0.9 );
        }
        self.enemy = world;
      }
      self.ai_lastVis = visCheck;
    }
    else{
      if( (self.flags&FL_TURRET) ){
        self.torC_attackState = TR_NORM;
      }
    //No ENEMY, what was I doing before?
      if( time < self.ai_timer_checkTargFade ){
        if(self.nq1 == -1 ){
          ai_face_targ_fade();
        }
        else{
          ai_nodegraph_frame( self.ai_fadePos, self.ai_fadePos, self.data_speed_forward * 0.67, self.data_speed_forward * 0.85 );
        }
      }
      else{
        //do_patrol?
        if( !ai_check_scan( self.stat_rdr_mode ) ){
          if( self.tether == TETHER_PATROL ){
            if( self.patrolNode ){
              ai_nodegraph_patrol_frame( self.data_speed_strafe, self.data_speed_forward * 0.75 );
            }
            else{
              self.tether = TETHER_NONE;
              self.moveState = MOVE_STAND;
            }
          }
          else{
            self.tether = TETHER_NONE;
            self.moveState = MOVE_STAND;
          }
        }
      }
    }
  }
  //network delta
  ai_frame_net_send();
  
  self.think = ai_state_brawler_frame;
  self.nextthink = time + AI_RATE;
};

/*
  like a brawler, but with the ability to chase them around corners.
    -> maybe damage threshold too if under attack while hunting
*/
void() ai_state_hunter_frame={
  local float visCheck;
  
  if( !self.ai_freeze ){
    ai_frame_update();
    if( ai_valid_target(self.enemy) ){
    //has enemy -> combat stuff
      visCheck = ai_check_vis(self.enemy);
      if( visCheck == VIS_FRAC){
        //set via ai_check_pause() in ai_nodegraph_combat_brawler_frame();
        if( self.ai_fight_pause == TRUE && time > self.ai_timer_breathe ){
          ai_state_set_pause();
          self.ai_lastVis = visCheck;
          return;
        }
        //enemy is visible, 
        ai_attack();
        //is enemy reachable from my firing position?
        ai_nodegraph_combat_frame();
      }
      else{
        if( self.ai_lastVis != VIS_FAIL ){
          ai_nodegraph_clear_path();
        }
        ai_nodegraph_frame( self.enemy.origin, self.enemy.position1, self.data_speed_strafe, self.data_speed_forward );
      }
      self.ai_lastVis = visCheck;
    }
    else{
      if( (self.flags&FL_TURRET) ){
        self.torC_attackState = TR_NORM;
      }
      //No ENEMY, what was I doing before?
        //do_patrol?
      if( !ai_check_scan( self.stat_rdr_mode ) ){
        if( self.tether == TETHER_PATROL ){
          if( self.patrolNode ){
            ai_nodegraph_patrol_frame( self.data_speed_strafe, self.data_speed_forward * 0.75 );
          }
          else{
            self.tether = TETHER_NONE;
            self.moveState = MOVE_STAND;
          }
        }
        else{
          self.tether = TETHER_NONE;
          self.moveState = MOVE_STAND;
        }
      }
    }
  }
  //network delta
  ai_frame_net_send();
  
  self.think = ai_state_hunter_frame;
  self.nextthink = time + AI_RATE;
};

/*
  AI takes a bit of a breather, easing the pace of combat and giving the player a break too.
*/
void() ai_state_pause={
  local float visCheck;
  
  ai_frame_update();
  
  if( ai_valid_target(self.enemy) ){
    visCheck = ai_check_vis(self.enemy);
    if( visCheck != VIS_FAIL ){
      ai_face_targ();
      if( (random() * 1.0) > 0.8 ){
        ai_attack();
      }
    }
    else{
      self.think = self.ai_set_state;
      self.nextthink = time + AI_RATE;
      return;
    }
  }
  
  if( time > self.ai_timer_breathe ){
    self.think = self.ai_set_state;
  }
  else{
    self.think = ai_state_pause;
  }
  //network delta
  ai_frame_net_send();
  
  self.nextthink = time + AI_RATE;
};


/*
  Transition AI to the PAUSE state
*/
void() ai_state_set_pause={
  ai_nodegraph_clear_path();
  self.ai_timer_breathe = time + self.ai_pauseTime_wait;
  self.think = ai_state_pause;
  self.nextthink = time + AI_RATE;
  self.ai_fight_pause = FALSE;
  self.moveState = MOVE_STAND;
  if( (self.flags&FL_TURRET) ){
    self.torC_attackState = TR_NORM;
  }
  if( self.legs_hp ){
    self.legs_attackState = TR_NORM;
  }
};

/*
  Atomic, less-stateful turret behavior frame func.
*/
void() ai_state_turret_frame={
  local float visCheck;
  
  //turrets are wonky edge cases
  self.ai_unit_update();
  if( !self.deadflag ){
    if( ai_valid_target(self.enemy) ){
      ai_turret_set_state(TR_TARG);
      self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
      ai_lock_on();
    }
    else{ 
      self.button0 = FALSE;
    }
    self.attackFlag = 0;
    ai_ranged_attack();
    self.button0 = FALSE;
    if( (self.flags&FL_TURRET) ){
      ai_turret_control();
    }
  }
  //---------------------------
  
  if( ai_valid_target(self.enemy) ){
    //has enemy -> combat stuff
    visCheck = ai_check_vis(self.enemy);
    if( visCheck == VIS_FRAC ){
      //enemy is visible, 
      ai_attack();
      //is enemy reachable from my firing position?
      if( self.stat_trg_dist > self.ai_minrange ){
        self.enemy = world;
      }
      else{
      //stop-to-shoot vs dont stop-to-shoot
        ai_face_targ();
      }
    }
    else{
      //TODO - yes drop the enemy for now
      self.torC_aiDir = vectoyaw(self.enemy.position1 - self.origin);
      self.torC_attackState = TR_YAW;
      self.ai_movewait = time + ((self.ai_rank + 1) * 2);
      self.enemy = world;
    }
  }
  else{
    //No ENEMY, what was I doing before?
    //do_patrol?
    if( !ai_check_scan( self.stat_rdr_mode ) ){
      if( self.torC_angl_y == self.torC_aiDir ){
        //self.torsoCenter.ai_dir = self.torsoCenter.angles_y + (crandom() * (25 + random() * 75));
        //self.torsoCenter.attack_state = TR_YAW;
        if( time > self.ai_movewait ){
          self.ai_movewait = time + 10;
        }
        else{
          
        }
      }
    }
    else{
      self.torC_attackState = TR_TARG;
    }
  }
  //network delta
  ai_frame_net_send();
  
  self.ai_lastVis = visCheck;
  self.think = ai_state_turret_frame;
  self.nextthink = time + 0.05;
};

//TODO - fix me 
/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .torsoCenter is the AI's turret ent.
*/
void() ai_turret_control={
  local vector oldAngle;
  local float oldYaw;
  local float oldYawSpeed;
  
  makevectors(self.angles);
  self.torC_org = self.origin + (v_up*self.torC_compOffset_y)+(v_right*self.torC_compOffset_x)+(v_forward*self.torC_compOffset_z);
  
  switch( self.torC_attackState ){
    case TR_NORM:
      self.torC_idealYaw = self.angles_y;
      break;
    case TR_TARG:
      self.torC_idealYaw = vectoyaw( self.enemy.origin - self.origin );
      break;
    case TR_GOAL:
      self.torC_idealYaw = vectoyaw( self.goalentity.origin - self.origin );
      break;
    case TR_YAW:
      self.torC_idealYaw = self.torC_aiDir;
      break;
    case TR_LEFT:
      self.torC_idealYaw = vectoyaw( self.enemy.origin - self.origin ) - 75;
      break;
    case TR_RIGHT:
      self.torC_idealYaw = vectoyaw( self.enemy.origin - self.origin ) + 75;
      break;
  }
  //run check to see if ideal_yaw is within unit's max rotation limits.
  self.torC_idealYaw = anglemod(self.torC_idealYaw);
  self.torC_idealYaw = ai_check_turret_yaw( self.torC_idealYaw, self.angles_y, self.ai_angleLimits_x, self.ai_angleLimits_y);
  
  oldYaw = self.ideal_yaw;
  oldYawSpeed = self.yaw_speed;
  oldAngle = self.angles;
  
  self.ideal_yaw = self.torC_idealYaw;
  self.yaw_speed = self.turret_yaw_speed;
  self.angles = self.torC_angl;
    
    ChangeYaw();
    self.torC_vAngles = self.torC_angl = self.angles;
  
  self.angles = oldAngle;
  self.yaw_speed = oldYawSpeed;
  self.ideal_yaw = oldYaw;
    
  
  self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
};


void() ai_leg_control={
  
  local vector oldAngle;
  local float oldYaw;
  local float oldYawSpeed;
  
  makevectors(self.angles);
  self.legs_org = self.origin + (v_up*self.legs_compOffset_y)+(v_right*self.legs_compOffset_x)+(v_forward*self.legs_compOffset_z);

  switch( self.legs_attackState ){
    case TR_NORM:
      self.legs_idealYaw = self.angles_y;
      break;
    case TR_TARG:
      self.legs_idealYaw = self.legDir;
      break;
    case TR_GOAL:
      self.legs_idealYaw = vectoyaw(self.goalentity.origin - self.origin);
      break;
    case TR_YAW:
      self.legs_idealYaw = self.angles_y;
      break;
  }
  self.legs_idealYaw = anglemod(self.legs_idealYaw);
    
  oldAngle = self.angles;
  oldYaw = self.ideal_yaw;
  oldYawSpeed = self.yaw_speed;
  
  self.angles = self.legs_angl;
  self.ideal_yaw = self.legs_idealYaw;
  self.yaw_speed = self.legs_yawSpeed;
    ChangeYaw();
  self.legs_angl = self.angles;
  self.angles = oldAngle;
  self.ideal_yaw = oldYaw;
  self.yaw_speed = oldYawSpeed;
};

void( float estate ) ai_turret_set_state={
  self.torC_attackState = estate;
};

/*
  refer to macro macro_ai_
*/
void() ai_update={
  if( ai_valid_target(self.enemy) ){
    ai_turret_set_state(TR_TARG);
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
    ai_lock_on();
  }
  else{ 
    self.enemy = world;
    self.button0 = FALSE;
  }
  self.attackFlag = 0;
  ai_ranged_attack();
  self.button0 = FALSE;
};


