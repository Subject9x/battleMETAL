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
  THE BRAIN of all AI's - the top-level state controller.
  important vars:
    .ai_state       - the current state, usually no need to operate on this
    .ai_state_next  - set/operate on this to send the AI into a NEW state.
    .ai_state_last  - delta-tracking of AI's state choice, get this for compares.
*/
void() ai_state_frame={
  //run unit frame updates
  self.ai_unit_update();
  if( !(self.spawnflags&DEBUG_MODE) ){
    if( !self.deadflag ){
      ai_update();
    }
  }
  
  //State update
  self.ai_state_last = self.ai_state;
  self.ai_state = self.ai_state_next;
  
  //Move tracker update
  self.ai_move_last = self.ai_move;
  self.ai_move = self.ai_move_next;
  
  //state machine
  switch(self.ai_state){
    case ST_STAND:
      self.ai_run_state_now = self.ai_state_stand;
      break;
    case ST_PTR:
      self.ai_run_state_now = self.ai_state_patrol;
      break;
    case ST_PTR_PAUSE:
      self.ai_run_state_now = self.ai_state_patrol_pause;
      break;
    case ST_PTR_TRAVEL_NODE:
      self.ai_run_state_now = self.ai_state_patrol_travel_node;
      break;
    case ST_PTR_TRAVEL_NODEBLOCK:
      self.ai_run_state_now = self.ai_state_patrol_travel_blocked;
      break;
    case ST_THR:
      self.ai_run_state_now = self.ai_state_tether;
      break;
    case ST_THR_PAUSE:
      self.ai_run_state_now = self.ai_state_tether_pause;
      break;
    case ST_THR_TRAVEL:
      self.ai_run_state_now = self.ai_state_tether_travel;
      break;
    case ST_THR_TRAVEL_BLOCK:
      self.ai_run_state_now = self.ai_state_tether_travel_block;
      break;
    case ST_COMBAT:
      self.ai_run_state_now = self.ai_state_combat;
      break;
    case ST_COM_MOVE_START:
      self.ai_run_state_now = self.ai_state_combat_moveStart;
      break;
    case ST_COM_MOVE_EXEC:
      self.ai_run_state_now = self.ai_state_combat_moveExec;
      break;
    case ST_COM_MOVE_END:
      self.ai_run_state_now = self.ai_state_combat_moveEnd;
      break;
    case ST_COM_MOVE_BLOCK:
      self.ai_run_state_now = self.ai_state_combat_blocked;
      break;
  }
  
  if( self.ai_run_state_now ){
    self.ai_run_state_now();
  }
  
  if( self.ai_state == ST_COM_MOVE_START || self.ai_state == ST_COM_MOVE_EXEC ){
    //optimization to reduce nesting of switch/case calls
    ai_combat_move_frame();
  }
  
  if( (self.flags&FL_TURRET) ){
    ai_turret_control();
  }
  if( self.legs ){
    ai_leg_control();
  }
  
  self.think = ai_state_frame;
  self.nextthink = time + 0.07;
};

/*
  Combat Sub-state; this should only be run by self.ai_state_combat_moveExec();
  important vars:
    .ai_move      -  the current move, usually no need to operate on this.
    .ai_move_last - delta-tracking of AI's move choice, get this for compares.
    .ai_move_next - set/operate on this to create a new move order.
    .ai_movewait  - timer used for [ST_COM_MOVE_EXEC], set this in [ST_COM_MOVE_START], when expired, it goes to [ST_COM_MOVE_END]
*/
void() ai_combat_move_frame={
  local float moveStatus;
  moveStatus = TRUE;
  switch(self.ai_move){
    case MOVE_STAND:
      ai_move_stand();
      break;
    case MOVE_CHARGE:
      moveStatus = ai_move_charge();
      break;
    case MOVE_CHARGE_LEFT:
      moveStatus = ai_move_charge_left();
      break;
    case MOVE_CHARGE_RIGHT:
      moveStatus = ai_move_charge_right();
      break;
    case MOVE_STRAFE_LEFT:
      moveStatus = ai_move_strafe_left();
      break;
    case MOVE_STRAFE_RIGHT:
      moveStatus = ai_move_strafe_right();
      break;
    case MOVE_CIRCLE_LEFT:
      moveStatus = ai_move_circle_left();
      break;
    case MOVE_CIRCLE_RIGHT:
      moveStatus = ai_move_circle_right();
      break;
    case MOVE_BACK:
      moveStatus = ai_move_back();
      break;
    case MOVE_BACK_LEFT:
      moveStatus = ai_move_back_left();
      break;
    case MOVE_BACK_RIGHT:
      moveStatus = ai_move_back_right();
      break;
    case MOVE_PATROLNODE:
      moveStatus = ai_move_patrol_node( AI_RANGE_S, AI_NODE_DISTANCE, 0);
      break;
    case MOVE_SNAPSHOT:
      ai_move_snapshot();
      break;
    case MOVE_SNIPESHOT:
      ai_move_snipeshot();
      break;
    case MOVE_STAND_FACE:
      ai_move_standface();
      break;
    case MOVE_NODE_HIDE:
      ai_move_node_hide();
      break;
    case MOVE_NODE_CLEAR:
      ai_move_node_clear();
      break;
    case MOVE_NODE_REVERSE:
      ai_move_node_reverse();
      break;
    case MOVE_NODE_RADIUS:
      ai_move_node_radius();
      break;
  }
  if( moveStatus == FALSE ){
    if( self.ai_state_combat_blocked ){
      self.ai_state_next = ST_COM_MOVE_BLOCK;
    }
  }
};

/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .torsoCenter is the AI's turret ent.
*/
void() ai_turret_control={
  local entity turretOwner;
  local float ang;
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
  ai_ranged_attack();
  self.button0 = FALSE;
};


