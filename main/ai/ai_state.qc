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
  The top-level State Controller for all AI brains.
*/
void() ai_state_frame={
  //run unit frame updates
  macro_ai_update(self.ai_unit_update)
  
  //State update
  self.ai_state_last = self.ai_state;
  self.ai_state = self.ai_state_next;
  
  //Move tracker update
  self.ai_move_last = self.ai_move;
  self.ai_move = self.ai_move_next;
  
  //state machine
  switch(self.ai_state){
    case ST_STAND:
      self.ai_state_stand();
      break;
    case ST_PTR:
      self.ai_state_patrol();
      break;
    case ST_PTR_PAUSE:
      self.ai_state_patrol_pause();
      break;
    case ST_PTR_TRAVEL_NODE:
      self.ai_state_patrol_travel_node();
      break;
    case ST_PTR_TRAVEL_NODEBLOCK:
      self.ai_state_patrol_travel_blocked();
      break;
    case ST_PTR_TETHER:
      self.ai_state_patrol_tether();
      break;
    case ST_PTR_TETHER_BLOCK:
      self.ai_state_patrol_tether_blocked();
      break;
    case ST_COMBAT:
      self.ai_state_combat();
      break;
    case ST_COM_MOVE_START:
      self.ai_state_combat_moveStart();
      break;
    case ST_COM_MOVE_EXEC:
      self.ai_state_combat_moveExec();
      break;
    case ST_COM_MOVE_END:
      self.ai_state_combat_moveEnd();
      break;
    case ST_TRAIL_MOVE:
      break;
    case ST_TRAIL_BLOCK:
      break;
    case ST_TRAIL_ROLLBACK:
      break;
    case ST_TRAIL_ROLLBLOCK:
      break;
  }
  
  if( (self.flags&FL_TURRET) ){
    ai_turret_control();
  }
  if( self.legs ){
    ai_leg_control();
  }
  
  self.think = ai_state_frame;
  self.nextthink = time + 0.05;
};

/*
  Combat subsystem, use ai_dance_card to tailor move list
*/
void() ai_combat_move_frame={
  switch(self.ai_move){
    case MOVE_STAND:
      ai_move_stand();
      break;
    case MOVE_CHARGE:
      ai_move_charge();
      break;
    case MOVE_CHARGE_LEFT:
      ai_move_charge_left();
      break;
    case MOVE_CHARGE_RIGHT:
      ai_move_charge_right();
      break;
    case MOVE_STRAFE_LEFT:
      ai_move_strafe_left();
      break;
    case MOVE_STRAFE_RIGHT:
      ai_move_strafe_right();
      break;
    case MOVE_CIRCLE_LEFT:
      ai_move_circle_left();
      break;
    case MOVE_CIRCLE_RIGHT:
      ai_move_circle_right();
      break;
    case MOVE_BACK:
      ai_move_back();
      break;
    case MOVE_BACK_LEFT:
      ai_move_back_left();
      break;
    case MOVE_BACK_RIGHT:
      ai_move_back_right();
      break;
    case MOVE_SNAPSHOT:
      ai_move_snapshot();
      break;
    case MOVE_SNIPESHOT:
      ai_move_snipeshot();
      break;
  }
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


