/*
mech Mod
Date: 5/22/2017
  refac: 2/17/2018 - changed file name, added more functions
Overview: next draft the ai
this one will focus on move to move
*/

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
void(float() move, float frames) ai_move_controller={
  ChangeYaw();
  if(time > self.w_isready){
    self.w_isready = time + frames;
    self.ai_next_move = move;
  }
  else{
    if(!self.ai_hasmoved){
      local float remain;
      remain = self.w_isready - time;
      /*if(self.ai_next_move == ai_move_forward){
        self.ai_next_move = ai_move_backward;
      }
      else if(self.ai_next_move == ai_move_backward){
        self.ai_next_move = ai_move_backward;
      }
      else if(self.ai_next_move == ai_move_walkmove_strafeleft){
        self.ai_next_move = ai_move_walkmove_straferight;
      }
      else if(self.ai_next_move == ai_move_walkmove_straferight){
        self.ai_next_move = ai_move_walkmove_strafeleft;
      }
      else if(self.ai_next_move == ai_move_runmove_slideleft){
        self.ai_next_move = ai_move_runmove_slideright;
      }
      else if(self.ai_next_move == ai_move_runmove_slideright){
        self.ai_next_move = ai_move_walkmove_strafeleft;
      }
      else if(self.ai_next_move == ai_run_forward){
        self.ai_next_move = ai_move_backward;
      }
      else if(self.ai_next_move == ai_move_backward){
        self.ai_next_move = ai_run_forward;
      }
      else if(self.ai_next_move == ai_move_charge_left){
        self.ai_next_move = ai_move_charge_right;
      }
      else if(self.ai_next_move == ai_move_charge_right){
        self.ai_next_move = ai_move_charge_left;
      }*/
      self.w_isready = remain;
    }
  }
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

float() ai_move_stand={
  if(self.ai_prev_move != ai_move_stand){
    walkmove(self.ideal_yaw, 0);
    self.ai_prev_move = ai_move_stand;
  }
  return TRUE;
};

float() ai_move_walk_goal={
  movetogoal(self.m_fspeed * AI_WALK_SPD);
  self.ai_prev_move = ai_move_walk_goal;
  self.p_velocity = 0;
  return TRUE;
};

float() ai_move_run_goal={
  movetogoal(self.m_fspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_move_run_goal;
  self.p_velocity = 0;
  return TRUE;
};

//arbitrary angle movement
float() ai_move_angle_walk={
  if (walkmove( anglemod(self.angles_y + self.lefty), self.m_sspeed * AI_WALK_SPD)){
    self.ai_prev_move = ai_move_angle_walk;
    self.p_velocity = self.lefty;
    return TRUE;
  }
  return FALSE;
};

//arbitrary angle movement
float() ai_move_angle_run={
  if (walkmove( anglemod(self.angles_y + self.lefty), self.m_sspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_angle_run;
    self.p_velocity = self.lefty;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_runmove_slideright={  
  if (walkmove( self.ideal_yaw + 90, self.m_sspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_runmove_slideright;
    self.p_velocity = self.v_angle_y + 90;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_runmove_slideleft={  
  if (walkmove( self.ideal_yaw + -90, self.m_sspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_runmove_slideleft;
    self.p_velocity = self.v_angle_y + -90;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_forward={
  if (walkmove (self.angles_y, self.m_fspeed * AI_WALK_SPD)){
    self.ai_prev_move = ai_move_forward;
    self.p_velocity = self.v_angle_y;
    return TRUE;
  }
  return FALSE;
};

float() ai_run_forward={
  if (walkmove (self.angles_y, self.m_fspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_forward;
    self.p_velocity = self.v_angle_y;
    return TRUE;
  }
  return FALSE;
};

float() ai_run_backward={
  if (walkmove (self.angles_y + 180, self.m_fspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_run_backward;
    self.p_velocity = self.v_angle_y + 180;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_backward={
  if (walkmove ((self.angles_y + 180), self.m_bspeed * AI_WALK_SPD)){
    self.ai_prev_move = ai_move_backward;
    self.p_velocity = self.v_angle_y + 180;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_walkmove_strafeleft={
  if(walkmove (self.ideal_yaw - 90,  self.m_sspeed * AI_WALK_SPD)){
    self.p_velocity = self.v_angle_y - 90;
    self.ai_prev_move = ai_move_walkmove_straferight;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_walkmove_straferight={
  if(walkmove (self.ideal_yaw + 90,  self.m_sspeed * AI_WALK_SPD)){
    self.p_velocity = self.v_angle_y + 90;
    self.ai_prev_move = ai_move_walkmove_straferight;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_charge_left={
  if (walkmove (self.ideal_yaw - 75,  self.m_fspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = self.v_angle_y - 75;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_charge_right={
  if(walkmove (self.ideal_yaw + 75,  self.m_fspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = self.v_angle_y + 75;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_walkmove_backleft={
  if (walkmove (self.ideal_yaw - 135,  self.m_fspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = self.v_angle_y - 135;
    return TRUE;
  }
  return FALSE;
};

float() ai_move_walkmove_backright={
  if (walkmove (self.ideal_yaw + 135,  self.m_fspeed * AI_RUN_SPD)){
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = 135;
    return TRUE;
  }
  return FALSE;
};

/*
  Random forward movement in the 180 arc towards ideal_yaw
  this is not invoked by the move controller, this is called
  by any given ai_state
*/
void(float isRun, float duration) ai_move_walkmove_forwardRand={
  local float dieRoll;
  dieRoll = util_roll_dice(3);
  if(dieRoll == 1){
    if(isRun){
      ai_move_controller(ai_run_forward, duration);
      return;
    }
    ai_move_controller(ai_move_forward, duration);
  }
  else if(dieRoll == 2){
    ai_move_controller(ai_move_charge_left, duration);
  }
  else if(dieRoll == 3){
    ai_move_controller(ai_move_charge_right, duration);
  }
};


/*
  given 2 possible moves being passed in, roll a die
  and pick one
*/
void(float duration, float() move1, float() move2) ai_move_randomTwo={
  local float dieRoll;
  dieRoll = util_roll_dice(2);
  if(dieRoll == 1){
    ai_move_controller(move1, duration);
  }
  else if(dieRoll == 2){
    ai_move_controller(move2, duration);
  }
};

/*
  given 3 possible moves being passed in, roll a die
  and pick one
*/
void(float duration, float() move1, float() move2, float() move3) ai_move_randomThree={
  local float dieRoll;
  dieRoll = util_roll_dice(3);
  if(dieRoll == 1){
    ai_move_controller(move1, duration);
  }
  else if(dieRoll == 2){
    ai_move_controller(move2, duration);
  }
  else if(dieRoll == 3){
    ai_move_controller(move3, duration);
  }
};

/*
  given 4 possible moves being passed in, roll a die
  and pick one
*/
void(float duration, float() move1, float() move2, float() move3, float() move4) ai_move_randomFour={
  local float dieRoll;
  dieRoll = util_roll_dice(4);
  if(dieRoll == 1){
    ai_move_controller(move1, duration);
  }
  else if(dieRoll == 2){
    ai_move_controller(move2, duration);
  }
  else if(dieRoll == 3){
    ai_move_controller(move3, duration);
  }
  else if(dieRoll == 4){
    ai_move_controller(move4, duration);
  }
};

/*
  given 6 possible moves being passed in, roll a die
  and pick one
*/
void(float duration, float() move1, float() move2, float() move3, float() move4, float() move5, float() move6) ai_move_randomSix={
  local float dieRoll;
  dieRoll = util_roll_dice(6);
  if(dieRoll == 1){
    ai_move_controller(move1, duration);
  }
  else if(dieRoll == 2){
    ai_move_controller(move2, duration);
  }
  else if(dieRoll == 3){
    ai_move_controller(move3, duration);
  }
  else if(dieRoll == 4){
    ai_move_controller(move4, duration);
  }
  else if(dieRoll == 5){
    ai_move_controller(move5, duration);
  }
  else if(dieRoll == 6){
    ai_move_controller(move6, duration);
  }
};


/*
  given a bitflag set of float filterDir, using AI_DIR flags
  produce a randomly chosen bitflag from the incoming set.
  
*/
float(float filterDir) ai_move_rand_walk={
  
};

/*
  like ai_move_rand_walk but with run functions instead
  of walking functions
*/
float(float filterDir) ai_move_rand_run={

};