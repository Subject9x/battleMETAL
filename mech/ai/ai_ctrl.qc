/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/

/*
  Sets the next STATE enum (yes I know, no native ENUM support)
*/
void( float estate ) ai_next_state={
  self.attack_state = estate;
  self.ai_action_time = time + self.ai_action_mod;
};

void( float estate ) ai_turret_set_state={
  self.e_tor_c.attack_state = estate;
};

/*
  called every frame by the AI unit think.
  make sure to call ai_pilot_validate_states() before
  using this
*/
void( float estate ) ai_state_control={
  switch( estate ){
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
    case ST_MISSILE:
      self.th_missile();
      break;
    case ST_MELEE:
      self.th_melee();
      break;
    case ST_MISSILE_STRAFE:
      self.th_missile_strafe();
      break;
    case ST_HUNT:
      self.th_hunt();
      break;
    case ST_PAIN:
      self.th_pain();
      break;
  }
};

/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .e_tor_c is the AI's turret ent.
*/
void() ai_turret_control={
  local entity this;
  local vector am;
  this = self;
  if( (self.e_tor_c) ){
    self = self.e_tor_c;
      util_setOffsetOrigin(self, this, self.c_ofs);
      switch( self.attack_state ){
        case TR_NORM:
          self.ideal_yaw = this.angles_y;
          break;
        case TR_TARG:
          self.ideal_yaw = vectoyaw( this.enemy.origin - self.origin );
          break;
        case TR_GOAL:
          self.ideal_yaw = vectoyaw( this.goalentity.origin - self.origin );
          break;
        case TR_YAW:
          break;
      }
      ChangeYaw();
      self.v_angle = self.angles;
    self = this;
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
/*
	Generic Stand
	AI will stand around, scanning for targets every time + self.ai_viewcheck seconds
	if AI has a node to go to, it will walk there
*/
void() ai_generic_stand={
  
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
/*
	Generic Walk
	AI will use builtin func MOVETOGOAL to go to its goalentity
	it will scan for targets every time + self.ai_viewcheck seconds
*/
void() ai_generic_walk={
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    return;
  }
  
  ai_walkgoal( AI_WALK_SPD );
  
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      if( self.data_type == DATA_MECH ){
        ai_leg_frame( leg_walk1 );
      }
      return;
    }
    ai_next_state( ST_STAND );
      if( self.data_type == DATA_MECH ){
        ai_leg_frame( leg_stand1 );
      }
    return;
  }
};
/*
  Generic Fly
  VTOL behavior says that this should act like a sub ST_RUN state
  where the VTOL cares about altitude;
*/
void() ai_generic_fly={
  local vector flydir;
  local float fspd, sspd, bspd;

  if( self.enemy ){
    ai_face_targ();
  }
  
  fspd = (self.m_fspeed / 2) * AI_RUN_SPD;
  sspd = (self.m_sspeed / 2) * AI_RUN_SPD;
  bspd = (self.m_bspeed * AI_RUN_SPD) * self.attack_finished;
  
  ChangeYaw();
  makevectors( self.angles );
  
  flydir = self.origin + (v_up * bspd);
  flydir = flydir + (v_right * sspd);
  flydir = flydir + (v_forward * fspd);
  
  setorigin( self, flydir );
  
};
/*
	Generic Run
	this is a bit of a callback to Quake 1, the ST_RUN function is the entry point for all
	AI COMBAT states. the Generic Run state will also delegate the next state along the 
	hierarchy of VISIBILITY > RANGE > FACING
*/
void() ai_generic_run={
  
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    if( enemy_vis ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          if( self.ai_rank <= AI_RANK_REG ){
            ai_next_state( ST_MISSILE );
            return;
          }
          ai_face_targ();
          ai_next_state( ST_RUN_CHARGE );
          return;
        }
        ai_face_targ();
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          //TODO - stub
        }
      }
      
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          //TODO - stub
        }
      }
      
      if( enemy_range > (self.ai_minrange * 2) ){
        if( enemy_infront ){
          //TODO - stub
        }
      }
    }
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};
/*
	Generic Run Strafe
	simply moves the AI 90 deg to its current yaw
	WITHOUT adjusting for ideal_yaw, if the AI cannot complete the move
	it switches signage on the 90deg and strafes the other way.
*/
void() ai_generic_run_strafe={
  
  local float moved;
  moved = ai_walk_left( self.m_sspeed * AI_RUN_SPD );
  if( !moved ){
    moved = ai_walk_right( self.m_sspeed * AI_RUN_SPD );
  }
  if( !moved ){
    ai_next_state( ST_RUN );
    return;
  }

  if( time > self.ai_action_time ){
    ai_next_state( ST_MISSILE );
    return;
  }
};
/*
	Generic Run Charge
	AI will attempt to bypass its target by moving 45 degs to the left or right
	of its current target.
*/
void() ai_generic_run_charge={
  ai_move_turn();
  
  if( ai_check_face(self.enemy, 0.7) ){
    local float moved;
    moved = ai_yaw_move( 75, self.m_fspeed * AI_RUN_SPD);
    if( !moved ){
      moved = ai_yaw_move( -75, self.m_fspeed * AI_RUN_SPD);
    }
    if( !moved ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  else{
    ai_next_state( ST_MISSILE );
    return;
  }  
};
/*
	Generic Missile
	this is the AI's most basic atack.
	The AI will turn to face its intended target, and fire if that target is 
	in front. The AI does not move for this one.
*/
void() ai_generic_missile={
  
  ai_face_targ();
  if( ai_check_face( self.enemy, 0.97 ) ){
    if( ai_attack() ){
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};
/*
	Generic Melee
	a bit ported over from Quake, the melee() here is interpreted as an attack with some mobility.
	The AI will move a little bit while trying to attack.
*/
void() ai_generic_melee={
  
	ai_face_targ();
	//TODO
};
/*
	Generic Missile Strafe
	AI will make an attack while moving to the left or right.
*/
void() ai_generic_missile_strafe={
  local float ang;
  
  ai_face_targ();
  ang = anglemod( self.angles_y + (self.lefty * 90 ) );
  ai_move( ang, self.m_fspeed * AI_WALK_SPD );
  if( ai_check_face( self.enemy, 0.97 ) ){
    if( ai_attack() ){
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};
/*
	Generic Hunt
	called after HUNT_START, AI will head to a temp patrol node based on Target's 
	last known position. if Target is spotted before then, go back to combat, if the
	target is spotted WHEN the AI reaches the node, attack from the node.
*/
void() ai_generic_hunt={
  
  //TODO
};
/*
  Generic Pain
  A AI has taken a 'staggering' amount of damage over a single frame,
  something like losing a piece or taken (DMG > maxhp / 2 )
  the bot then recoils in some manner, maybe making panicked noises
*/
void() ai_generic_pain={
  
  //TODO
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

void(float moveSpeed) ai_walkgoal={
  movetogoal( self.m_fspeed * moveSpeed );
};

void() ai_move_turn={
  ChangeYaw();
};

void() ai_face_targ={
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

float( float dist ) ai_walk_back={
  return ai_move( (self.angles_y + 180), dist );
};

float( float dist ) ai_walk_left={
  return ai_move( (self.angles_y + 90), dist );
};

float( float dist ) ai_walk_right={
  return ai_move( (self.angles_y - 90), dist );
};

float( float angmod, float dist) ai_move={
  return walkmove( angmod, dist );
};

/*
	Yaw moves use the AI's ideal_yaw
	stat when turning
*/
float( float dist ) ai_yaw_back={
  return walkmove( anglemod(self.ideal_yaw + 180), dist );
};

float( float dist ) ai_yaw_left={
  return walkmove( anglemod(self.ideal_yaw + 90), dist );
};

float( float dist ) ai_yaw_right={
  return walkmove( anglemod(self.ideal_yaw - 90), dist );
};

float( float angmod, float dist ) ai_yaw_move={
  return walkmove( anglemod(self.ideal_yaw + angmod), dist );
};

/*
  rolled together all the flying code to a one-off call.
  this should be made everytime a flyer makes an engine-based move.
*/
void( float alt_low, float alt_max) ai_fly_update={
  local vector delta, flydir;
  local float dist, fdir;
  local float fspd, sspd, bspd;
  
  makevectors( self.angles );
  
  delta = self.origin + (v_up * -10000);
  traceline( self.origin, delta, MOVE_NOMONSTERS, self);
  dist = vlen( trace_endpos - self.origin );
  
  if( dist <= alt_low ){
    fdir = 1;
  }
  
  if( fdir == FALSE ){
    delta = self.origin + (v_up * 10000);
    traceline( self.origin, delta, MOVE_NOMONSTERS, self);
    dist = vlen( trace_endpos - self.origin );
    
    if( dist <= alt_max ){
      fdir = -1;
    }
  }
  
  if( fdir != 0 ){
    fspd = (self.m_fspeed / 2) * AI_RUN_SPD;
    sspd = (self.m_sspeed / 2) * AI_RUN_SPD;
    bspd = (self.m_bspeed * AI_RUN_SPD) * fdir;
    
    flydir = self.origin + (v_up * bspd);
    flydir = flydir + (v_right * sspd);
    flydir = flydir + (v_forward * fspd);
    
    setorigin( self, flydir );
  } 
}

/*
  Adjust AI's .accuracy setting based on movement
  TRUE = unit is moving, adjust self.accuracy up to spreadDefault_y (max)
  FALSE = unit is standing still, self.accuracy down to spreadDefault_x (min)
*/
void( float move ) ai_update_accuracy={
  local float rate;
  rate = self.spreadDefault_z;
  if( move ){
    if( self.stat_rdr_mode ){
      rate = rate - ( rate * 0.25 );
    }
    self.accuracy = self.accuracy + rate;
    if( self.accuracy > self.spreadDefault_y ){
      self.accuracy = self.spreadDefault_y;
    }
  }
  else{
    if( self.stat_rdr_mode ){
      rate = rate - ( rate * 0.4 );
    }
    self.accuracy = self.accuracy - rate;
    if( self.accuracy < self.spreadDefault_x ){
      self.accuracy = self.spreadDefault_x;
    }
  }
};

/*
  Checks to see if Entity T is in the ANG arc of self
*/
float(entity t, float ang) ai_check_face={
	local vector	vang, vec;
	local float		dot;
  
  vang = self.angles;
  if( (self.flags & FL_TURRET) ){
    vang = self.e_tor_c.angles;
  }
  
  makevectors ( vang );
	vec = normalize (t.origin - self.origin);
	dot = vec * v_forward;
  
	if ( dot >= ang){
		return TRUE;
	}
	return FALSE;
};

float(entity t) ai_check_range={
  return vlen( self.origin - t.origin );
};

float( entity targ ) ai_check_vis={
  local vector	spot1, spot2;
  
  spot1 = self.origin;
  spot2 = targ.origin;
  traceline (spot1, spot2, TRUE, self); // see through other monsters

  if ( trace_inopen && trace_inwater ){
    return VIS_FAIL;     // sight line crossed contents
  }
  if ( trace_fraction == 1 ){
    return VIS_FRAC;
  }
  
  if( trace_ent != targ ) {
    if( trace_ent.i_faction == self.i_faction ){
      return VIS_FRN;
    }
  }
  return VIS_FAIL;
};

float() ai_attack={
  if( self.enemy ){
    if( self.currentWeaponGroup > 0 ){
      if( random() <= self.ai_attack_chance ){
        self.button0 = 1;
        return TRUE;
      }
    }
  }
  return FALSE;
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

/*
  copy over from Quake's WalkMonsterStart() but
  adapted to battleMETAL
*/
void() ai_walk_setup={
	if ( self.target ){
    if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
      ai_node_pick_rand( self.target );
    }
  
		self.goalentity = self.movetarget = find(world, targetname, self.target);
    
    dprint( strcat(self.goalentity.targetname, "\n") );//DEBUG
    
		if( !self.movetarget ){
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    ai_next_state( ST_WALK );
    return;
	}
	else{
		self.pausetime = 99999999;
    ai_next_state( ST_STAND );
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

void() ai_stand={

  if( time > self.patience && !self.enemy){  
    //self.patience  = time + self.ai_viewcheck;
    self.patience  = time + 1; //DEBUG
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
