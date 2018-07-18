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

void() ai_hunt_target={
  //only applies to ai that can actually move
  if( self.th_run ){
    if( self.e_legs ){
      local entity temp;
      temp = self;
      self = self.e_legs;
        self.th_walk();
      self = temp;
    }
    self.goalentity = self.enemy;
    self.th_action = self.th_run;
    self.ai_action_time = time + 5;
  }
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
};

void(float ifaction, float datatype) ai_sfx_spotted={
  cons_logAString("Bot Here", "I'VE SEEN YOU!");  //DEBUG
};

void() ai_found_target={
  ai_sfx_spotted(self.i_faction, self.data_type);
  ai_hunt_target();
};

void() ai_walk_setup={
	if (self.target){
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget){
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		//self.th_walk ();
    ai_action_next( self.th_walk, 0, self.ai_action_mod );
	}
	else{
		self.pausetime = 99999999;
    ai_action_next( self.th_stand, 0, self.ai_action_mod );
	}
};

void(float dist) ai_forward={
  q1_ai_forward(dist);
  self.e_cam.SendFlags = 16;
};

void(float dist) ai_back={
  q1_ai_back(dist);
  self.e_cam.SendFlags = 16;
};

void() ai_stand={
  self.e_cam.SendFlags = 16;
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
  self.e_cam.SendFlags = 16;
};

void() ai_turn={
  q1_ai_turn() ;
};

void(float dist) ai_run={
  
  q1_ai_run(dist) ;
  self.e_cam.SendFlags = 16;
};

void() ai_run_slide={
  q1_ai_run_slide() ;
  self.e_cam.SendFlags = 16;
};

void() ai_run_attack={
  q1_ai_run_attack() ;
  self.e_cam.SendFlags = 16;
};

