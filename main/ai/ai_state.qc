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
    if( self.legs ){
      ai_leg_control();
    }
    if( time > self.posFadeTimer ){
      self.posFadeTimer = time + POSITION_FADE_TIME;
      self.position3 = self.position2;
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
  
  ai_frame_update();
  if( ai_valid_target(self.enemy) ){
  //has enemy -> combat stuff
    visCheck = ai_check_vis(self.enemy);
    if( visCheck == VIS_FRAC ){
    //enemy is visible, 
      if( self.ai_lastVis == VIS_FAIL){
        ai_nodegraph_clear_path();
      }
      ai_attack();
      //is enemy reachable from my firing position?
      if( self.ai_minrange < self.stat_trg_dist || !self.combatFlags ){
        //dprint(sprintf("mirange ------------- %f\n", self.ai_minrange));  //debug
        ai_nodegraph_combat_frame();
      }
      else if( self.stat_trg_dist <= self.ai_minrange ){
        //stop-to-shoot vs dont stop-to-shoot
        ai_face_targ();
        if( self.legs ){
          self.legs.attack_state = TR_YAW;
          self.moveState = MOVE_STAND;
        }
      }
      else{
        //bare minimum
        ai_face_targ();
        if( self.legs ){
          self.legs.attack_state = TR_YAW;
          self.moveState = MOVE_STAND;
        }
      }
    }
    else if( visCheck == VIS_FRN ){
      ai_nodegraph_frame( self.enemy.origin, self.enemy.origin, self.data_speed_strafe, self.data_speed_forward, 5);
    }
    else{
      if( self.ai_lastVis == VIS_FRN || self.ai_lastVis == VIS_FRAC ){
        self.ai_timer_checkTargFade = time + (1 + (self.ai_rank * 1.25));
        self.ai_fadePos = self.enemy.origin;
        self.enemy = world;
      }
    }
  }
  else{
  //No ENEMY, what was I doing before?
    if( time < self.ai_timer_checkTargFade ){
      //complete the fade turn; game is mostly single player :P
      ai_face_targ_fade();
    }
    else{
      if( !ai_check_scan( self.stat_rdr_mode ) ){
        if( self.tether == TETHER_PATROL ){
          ai_nodegraph_patrol_frame( self.data_speed_strafe, self.data_speed_forward * 0.75, 8 );
        }
      }
    }
  }
  self.ai_lastVis = visCheck;
  self.SendFlags = self.SendFlags | (SENDFLAG_IMPACT | SENDFLAG_MOVE);
  self.think = ai_state_lurker_frame;
  self.nextthink = time + 0.05;
};

/*
  Designed to pursue player up till lost line of sight.
  these brawl with players constantly.
  
*/
void() ai_state_brawler_frame={
  local float visCheck;
  
  ai_frame_update();
  if( ai_valid_target(self.enemy) ){
  //has enemy -> combat stuff
    visCheck = ai_check_vis(self.enemy);
    if( visCheck == VIS_FRAC){
      //dprint(sprintf("VIS ------------- %f\n", visCheck));  //debug
      //dprint(sprintf("combatFlags ------------- %f\n", self.combatFlags));  //debug
    //enemy is visible, 
      ai_attack();
      //dprint(sprintf("enemy_range ------------- %f\n", self.stat_trg_dist));  //debug
      //is enemy reachable from my firing position?
      ai_nodegraph_combat_frame();
      //ai_nodegraph_frame( self.enemy.origin, self.enemy.origin, self.data_speed_strafe, self.data_speed_forward, 5);
      self.moveState = MOVE_NORM;
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
      }
    }
    else{
      //TODO - yes drop the enemy for now
      self.enemy = world;
      //dprint(sprintf("LOST TARGET------------- %f\n", visCheck));  //debug
    }
  }
  else{
  //No ENEMY, what was I doing before?
    //do_patrol?
    if( !ai_check_scan( self.stat_rdr_mode ) ){
      if( self.tether == TETHER_PATROL ){
        ai_nodegraph_patrol_frame( self.data_speed_strafe, self.data_speed_forward * 0.75, 8 );
      }
    }
    //timer -> track last position
    
  }
  self.ai_lastVis = visCheck;
  self.SendFlags = self.SendFlags | (SENDFLAG_IMPACT | SENDFLAG_MOVE);
  self.think = ai_state_brawler_frame;
  self.nextthink = time + 0.05;
};

/*
  like a brawler, but with the ability to chase them around corners.

  - todo
    -> IF no-LOS -> moveDest == target.position1/2
    -> set hunt timer
    
    -> have a working hunt timer / state var
    
    -> maybe damage threshold too if under attack while hunting

*/
void() ai_state_hunter_frame={
  local float visCheck;
  
  ai_frame_update();
  if( ai_valid_target(self.enemy) ){
  //has enemy -> combat stuff
    visCheck = ai_check_vis(self.enemy);
    if( visCheck == VIS_FRAC){
      if( self.ai_lastVis != VIS_FRAC ){
        //tee this up to trigger a new path.
        //dprint("VIS_TRUE && prev VIS_FAIL = ai_nodegraph_clear_path()\n"); //debug
        ai_nodegraph_clear_path();
      }
      //enemy is visible, 
      ai_attack();
      //is enemy reachable from my firing position?
      ai_nodegraph_combat_frame();
      //ai_nodegraph_frame( self.enemy.origin, self.enemy.origin, self.data_speed_strafe, self.data_speed_forward, 5);
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
      }
    }
    else{
      if( self.ai_lastVis != VIS_FAIL ){
       //dprint("VIS_FAIL && prev !VIS_FAIL = ai_nodegraph_clear_path()\n"); //debug
       ai_nodegraph_clear_path();
      }
      ai_nodegraph_frame( self.enemy.origin, self.enemy.position1, self.data_speed_strafe, self.data_speed_forward, 2);
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
      }
    }
  }
  else{
  //No ENEMY, what was I doing before?
    //do_patrol?
    if( !ai_check_scan( self.stat_rdr_mode ) ){
      if( self.tether == TETHER_PATROL ){
        ai_nodegraph_patrol_frame( self.data_speed_strafe, self.data_speed_forward * 0.75, 8 );
      }
    }
    //timer -> track last position
    
  }
  self.ai_lastVis = visCheck;
  self.SendFlags = self.SendFlags | (SENDFLAG_IMPACT | SENDFLAG_MOVE);
  self.think = ai_state_hunter_frame;
  self.nextthink = time + 0.05;
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
      self.torsoCenter.ai_dir = vectoyaw(self.enemy.position1 - self.origin);
      self.torsoCenter.attack_state = TR_YAW;
      self.ai_movewait = time + ((self.ai_rank + 1) * 2);
      self.enemy = world;
    }
  }
  else{
    //No ENEMY, what was I doing before?
    //do_patrol?
    if( !ai_check_scan( self.stat_rdr_mode ) ){
      if( self.torsoCenter.angles_y == self.torsoCenter.ai_dir ){
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
      self.torsoCenter.attack_state = TR_TARG;
    }
  }
  self.ai_lastVis = visCheck;
  self.SendFlags = self.SendFlags | (SENDFLAG_IMPACT | SENDFLAG_MOVE);
  self.think = ai_state_turret_frame;
  self.nextthink = time + 0.05;
};

/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .torsoCenter is the AI's turret ent.
*/
void() ai_turret_control={
  local entity turretOwner;
  local float oldAng;
  
  if( self.torsoCenter ){
    turretOwner = self;
    self = self.torsoCenter;
      oldAng = self.angles_y;
      macro_set_offset(turretOwner, self.compOffset)
      switch( self.attack_state ){
        case TR_NORM:
          self.ideal_yaw = turretOwner.angles_y;
          break;
        case TR_TARG:
          self.ideal_yaw = vectoyaw( turretOwner.enemy.origin - self.owner.origin );
          break;
        case TR_GOAL:
          self.ideal_yaw = vectoyaw( turretOwner.goalentity.origin - self.owner.origin );
          break;
        case TR_YAW:
          self.ideal_yaw = self.ai_dir;
          break;
        case TR_LEFT:
          self.ideal_yaw = vectoyaw( turretOwner.enemy.origin - self.owner.origin ) - 75;
          break;
        case TR_RIGHT:
          self.ideal_yaw = vectoyaw( turretOwner.enemy.origin - self.owner.origin ) + 75;
          break;
      }
      //run check to see if ideal_yaw is within unit's max rotation limits.
      self.ideal_yaw = anglemod(self.ideal_yaw);
      self.ideal_yaw = ai_check_turret_yaw( self.ideal_yaw, turretOwner.angles_y, turretOwner.ai_angleLimits_x, turretOwner.ai_angleLimits_y);
      ChangeYaw(); 
      self.v_angle = self.angles;
    self = turretOwner;
    self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
  }
};


void() ai_leg_control={
  local entity legOwner;
  legOwner = self;
  self = self.legs;
    macro_set_offset(self.owner, self.compOffset)
    switch( self.attack_state ){
      case TR_NORM:
        self.ideal_yaw = self.owner.angles_y;
        break;
      case TR_TARG:
        self.ideal_yaw = self.ai_dir;
        break;
      case TR_GOAL:
        self.ideal_yaw = vectoyaw(self.owner.goalentity.origin - self.origin);
        break;
      case TR_YAW:
        self.ideal_yaw = self.angles_y;
        break;
    }
    self.ideal_yaw = anglemod(self.ideal_yaw);
    ChangeYaw();
    self.v_angle = self.angles;
  self = legOwner;
};

void( float estate ) ai_turret_set_state={
  if( (self.torsoCenter) ){
    self.torsoCenter.attack_state = estate;
  }
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


