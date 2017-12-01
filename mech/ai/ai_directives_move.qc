/*
mech Mod
Date: 5/22/2017
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
void(void() move, float frames) ai_move_controller={
  ChangeYaw();
  if(time > self.w_isready){
    self.w_isready = time + frames;
    self.ai_next_move = move;
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

void() ai_move_stand={
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

void() ai_move_runmove_slideright={  
  walkmove( self.ideal_yaw + 90, self.m_sspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_move_runmove_slideright;
  self.p_velocity = 90;
};

void() ai_move_runmove_slideleft={  
  walkmove( self.ideal_yaw + -90, self.m_sspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_move_runmove_slideleft;
  self.p_velocity = -90;
};

void() ai_move_forward={
  walkmove (self.angles_y, self.m_fspeed * AI_WALK_SPD);
  self.ai_prev_move = ai_move_forward;
  self.p_velocity = 0;
};

void() ai_run_forward={
  walkmove (self.angles_y, self.m_fspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_move_forward;
  self.p_velocity = 0;
};

void() ai_run_backward={
  walkmove (self.angles_y+180, self.m_fspeed * AI_RUN_SPD);
  self.ai_prev_move = ai_run_backward;
  self.p_velocity = 180;
};

void() ai_move_backward={
  walkmove ((self.angles_y+180), self.m_bspeed * AI_WALK_SPD);
  self.ai_prev_move = ai_move_backward;
  self.p_velocity = 180;
};

void() ai_move_walkmove_strafeleft={
  if(walkmove (self.ideal_yaw - 90,  self.m_sspeed * AI_WALK_SPD)){
    self.p_velocity = -90;
    self.ai_prev_move = ai_move_walkmove_straferight;
  }
};

void() ai_move_walkmove_straferight={
  if(walkmove (self.ideal_yaw + 90,  self.m_sspeed * AI_WALK_SPD)){
    self.p_velocity = 90;
    self.ai_prev_move = ai_move_walkmove_straferight;
  }
};

void() ai_move_charge_left={
  if (walkmove (self.ideal_yaw - 60,  self.m_fspeed * AI_RUN_SPD)){
    ai_move_stand();
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = -60;
  }
};

void() ai_move_charge_right={
  if(walkmove (self.ideal_yaw + 60,  self.m_fspeed * AI_RUN_SPD)){
    ai_move_stand();
    self.ai_prev_move = ai_move_stand;
    self.p_velocity = 60;
  }
};