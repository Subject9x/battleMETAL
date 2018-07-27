/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/


void(void() next_action, float next_time, float time_mod) ai_action_next={
  //self.th_action = next_action;
  self.ai_action_time = time + (next_time - time_mod);
};

void( float nex_state ) ai_next_state={
  self.attack_state = nex_state;
  self.ai_action_time = time + self.ai_action_mod;
};

/*
  called every frame by the AI unit think.
  make sure to call ai_pilot_validate_states() before
  using this
*/
void( float state ) ai_state_control={
  switch( state ){
    case ST_STAND:
      self.th_stand();
      break;
    case ST_WALK:
      self.th_walk();
      break;
    case ST_FLYDIR:
      self.th_fly();
      break;
    case ST_RUN:
      self.th_run();
      break;
    case ST_RUN_STRAFE:
      self.th_run_strafe();
      break;
    case ST_RUN_CHARGE:
      self.th_run_charge();
      break;
    case ST_ATTACK:
      self.th_missile();
      break;
    case ST_ATTACK_WALK:
      self.th_melee();
      break;
    case ST_ATTACK_WALK_STRAFE:
      self.th_missile_strafe();
      break;
    case ST_HUNT:
      self.th_hunt();
      break;
  }
};
/*
===================================================
  Generic State impl's
  use these if unit doesn't need any custom state code
  if no code is needed, ai_pilot_validate_states() will cover
  the null check
===================================================
*/
//generic state function
void() ai_generic_stand={
  cons_logAString(ftos(self.attack_state), "ai_generic_stand");
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    return;
  }
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};
void() ai_generic_walk={
  cons_logAString(ftos(self.attack_state), "ai_generic_walk");
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    return;
  }
  ai_walkgoal( self.m_fspeed * AI_WALK_SPD );
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};
void() ai_generic_fly={

};
void() ai_generic_run={
  cons_logAString(ftos(self.attack_state), "ai_generic_run");
  
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    if( enemy_vis ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          
        }
      }
    }
  }
};
void() ai_generic_run_strafe={

};
void() ai_generic_run_charge={

};
void() ai_generic_missile={
  cons_logAString(ftos(self.attack_state), "ai_generic_missile");
  ai_face_targ();
  if( ai_check_face( self.enemy, 0.97 ) ){
    if( ai_attack() ){
      ai_next_state( ST_ATTACK );
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};
void() ai_generic_melee={

};
void() ai_generic_missile_strafe={

};
void() ai_generic_hunt={

};
/*
===================================================
  AI Actions
  actions are the atomic functions of any AI state;
===================================================
*/
float( float scan_mode) ai_check_scan={
  if( time > self.ai_viewtime ){
    self.ai_viewtime = time + self.ai_viewcheck;
    if( scan_mode ){
      //TODO - radar
    }
    return ai_find_target_visual();
  }
  return FALSE;
};

void(float dist) ai_walkgoal={
  movetogoal(self.m_fspeed * AI_RUN_SPD);
};

void() ai_move_turn={
  ChangeYaw();
};

void() ai_face_targ={
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

float( float angmod, float dist) ai_move={
  return walkmove( angmod, dist );
};

float(entity t, float ang) ai_check_face={
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (t.origin - self.origin);
	dot = vec * v_forward;
  
	if ( dot >= ang){
		return TRUE;
	}
	return FALSE;
};

float(entity t) ai_check_range={
  local float v;
  v = vlen( self.origin - t.origin );
  if( (v > self.ai_minrange) || (v > AI_RANGE_L) ){
    return FALSE;
  }
  return TRUE;
};

float( entity targ ) ai_check_vis={
  local vector	spot1, spot2;
  
  spot1 = self.origin;
  spot2 = targ.origin;
  traceline (spot1, spot2, TRUE, self); // see through other monsters

  if ( trace_inopen && trace_inwater ){
    return FALSE;     // sight line crossed contents
  }
  if ( trace_fraction == 1 ){
    return TRUE;
  }
  return FALSE;
};

float() ai_attack={
  if( self.enemy ){
    if( self.currentWeaponGroup > 0 ){
      if( random() <= self.ai_attack_chance ){
        self.button0 = 1;
      }
    }
  }
};
/*
===================================================
*/


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
    ai_next_state( ST_WALK );
    //ai_leg_frame( leg_walk1 );
    return;
	}
	else{
		self.pausetime = 99999999;
    ai_next_state( ST_WALK );
    //ai_leg_frame( leg_stand1 );
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
