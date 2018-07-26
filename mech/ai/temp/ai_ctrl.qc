/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/


void(void() next_action, float next_time, float time_mod) ai_action_next={
  self.th_action = next_action;
  self.ai_action_time = time + (next_time - time_mod);
};

void( float nex_state ) ai_next_state={
  self.attack_state = nex_state;
  self.ai_action_time = time + self.ai_action_mod;
  droptofloor();
};

void() ai_hunt_target={
  //only applies to ai that can actually move
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.goalentity = self.enemy;
  ai_next_state( ST_RUN );
};

void(float ifaction, float datatype) ai_sfx_spotted={
  cons_logAString("Bot says", "I'VE SEEN YOU!");  //DEBUG
};

void() ai_found_target={
  ai_sfx_spotted(self.i_faction, self.data_type);
  ai_hunt_target();
};

void() ai_walk_setup={
	if (self.target){
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if( !self.movetarget ){
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    ai_action_next( self.th_walk, 1.2, self.ai_action_mod );
    ai_leg_frame( leg_walk1 );
    return;
	}
	else{
		self.pausetime = 99999999;
    ai_action_next( self.th_stand, 0.9, self.ai_action_mod );
    ai_leg_frame( leg_stand1 );
    return;
	}
};

//simple handler function to push state changes down to legs
void(void() macro) ai_leg_frame={
  if( self.e_legs ){
    local entity this;
    this = self;
    self = this.e_legs;
      macro();
    self = this;
  }
};

void() ai_make_attack={
  if( self.currentWeaponGroup > 0 ){
    if( random() <= self.ai_attack_chance ){
      self.button0 = 1;
    }
  }
};

void() ai_face_targ={
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

void(float dist) ai_forward={
  q1_ai_forward(dist);
};

void(float dist) ai_back={
  q1_ai_back(dist);
};

void() ai_stand={
  //q1_ai_stand() ;
  if( time > self.patience && !self.enemy){  
    //self.patience  = time + self.ai_viewcheck;
    self.patience  = time + 1; //DEBUG1
    cons_logAString("Bot Here", "Having a look around"); //DEBUG
    if( ai_find_target_visual() ){
      cons_logAString("Bot Here", "found target!"); //DEBUG
      return;
    }
  }
  if( time > self.pausetime ){
    self.th_walk();
  }
};

void(float dist) ai_walk={
  q1_ai_walk(dist) ;
};

void() ai_turn={
  q1_ai_turn() ;
};

void(float dist) ai_run={
  
  q1_ai_run(dist) ;
};

void() ai_run_slide={
  q1_ai_run_slide() ;
};

void() ai_run_attack={
  q1_ai_run_attack() ;
};

void() ai_charge_side={
	local	vector	dtemp;
	local	float	heading, t;
	
// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
  t = self.lefty * 55;
	makevectors (self.angles);
	dtemp = self.enemy.origin - ( t * v_right );
	heading = vectoyaw(dtemp - self.origin);
	
	walkmove(heading, self.m_fspeed * AI_RUN_SPD);
};

void( float angl, float dist ) ai_move_forward={
  walkmove( angl, dist );
};

void( float angl, float dist ) ai_move_backward={
  walkmove( (angl + 180), dist );
};

void( float angl, float dist ) ai_move_left={
  walkmove( (angl + 90), dist );
};

void( float angl, float dist ) ai_move_right={
  walkmove( (angl - 90), dist );
};

void() ai_move_turn={
  ChangeYaw();
};
