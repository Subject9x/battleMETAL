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
      ai_combat_move_frame();
      break;
    case ST_COM_MOVE_EXEC:
      self.ai_state_combat_moveExec();
      ai_combat_move_frame();
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
  Combat Sub-state; this should only be run by self.ai_state_combat_moveExec();
  important vars:
    .ai_move      -  the current move, usually no need to operate on this.
    .ai_move_last - delta-tracking of AI's move choice, get this for compares.
    .ai_move_next - set/operate on this to create a new move order.
    .ai_movewait  - timer used for [ST_COM_MOVE_EXEC], set this in [ST_COM_MOVE_START], when expired, it goes to [ST_COM_MOVE_END]
    .ai_moveflag  - a collection of currently-possible moves, as moves are executed, remove them from this collection.
    .ai_blockflag - a collection filled up as AI fails at certain moves, usually when blockflag == dance_Card, the bot is truly stuck
    .ai_dance_card  - bitflag collection of all possible moves for THIS AI, usually set at-spawn by unit-type
*/
void() ai_combat_move_frame={
  local float noBlock;
  noBlock = TRUE;
  switch(self.ai_move){
    case MOVE_STAND:
      ai_move_stand();
      break;
    case MOVE_CHARGE:
      noBlock = ai_move_charge();
      break;
    case MOVE_CHARGE_LEFT:
      noBlock = ai_move_charge_left();
      break;
    case MOVE_CHARGE_RIGHT:
      noBlock = ai_move_charge_right();
      break;
    case MOVE_STRAFE_LEFT:
      noBlock = ai_move_strafe_left();
      break;
    case MOVE_STRAFE_RIGHT:
      noBlock = ai_move_strafe_right();
      break;
    case MOVE_CIRCLE_LEFT:
      noBlock = ai_move_circle_left();
      break;
    case MOVE_CIRCLE_RIGHT:
      noBlock = ai_move_circle_right();
      break;
    case MOVE_BACK:
      noBlock = ai_move_back();
      break;
    case MOVE_BACK_LEFT:
      noBlock = ai_move_back_left();
      break;
    case MOVE_BACK_RIGHT:
      noBlock = ai_move_back_right();
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
  }
  if( !noBlock ){
    self.ai_moveflag = self.ai_moveflag - (self.ai_moveflag & self.ai_move);
    self.ai_blockflag = self.ai_blockflag | self.ai_move;
    self.ai_state_next = ST_COM_MOVE_BLOCK;
    cons_logAFloat("ENTER[ST_COM_MOVE_BLOCK]",  self.ai_state_next); //debug
    
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


