/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/

void( float estate ) ai_turret_set_state={
  self.e_tor_c.attack_state = estate;
};

/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .e_tor_c is the AI's turret ent.
*/
void() ai_turret_control={
  local entity turretOwner;
  local vector am;
  turretOwner = self;
  if( (self.e_tor_c) ){
    self = self.e_tor_c;
      util_setOffsetOrigin(self, turretOwner, self.c_ofs);
      switch( self.attack_state ){
        case TR_NORM:
          self.ideal_yaw = turretOwner.angles_y;
          break;
        case TR_TARG:
          self.ideal_yaw = vectoyaw( turretOwner.enemy.origin - self.origin );
          break;
        case TR_GOAL:
          self.ideal_yaw = vectoyaw( turretOwner.goalentity.origin - self.origin );
          break;
        case TR_YAW:
          self.ideal_yaw = self.ai_dir;
          break;
      }
      ChangeYaw();
      self.v_angle = self.angles;
    self = turretOwner;
  }
};

void() ai_leg_control={
  local entity legOwner;
  local vector am;
  legOwner = self;
  if( (self.e_legs) ){
      self = self.e_legs;
      util_setOffsetOrigin(self, legOwner, self.c_ofs);
      switch( self.attack_state ){
        case TR_NORM:
          self.ideal_yaw = legOwner.angles_y;
          break;
        case TR_GOAL:
          self.ideal_yaw = self.ai_dir;
          break;
        case TR_YAW:
          self.ideal_yaw = self.angles_y;
          break;
      }
      ChangeYaw();
      self.v_angle = self.angles;
    self = legOwner;
  }
};

/*
  refer to macro macro_ai_
*/
void() ai_update={
  if( ai_valid_target( self.enemy ) ){
    ai_turret_set_state( TR_TARG );
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
    ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
    ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
    ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
    ai_lock_on();
  }
  else{ 
    self.enemy = world;
  }
  ai_ranged_attack();
  self.button0 = 0;  
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
      return ai_find_target_radar();
    }
    return ai_find_target_visual();
  }
  return FALSE;
};

void(float moveSpeed) ai_walkgoal={
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
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

/*
  Checks to see if Entity T is in the ANG arc of self
*/
float(entity t, float ang, float useTurret) ai_check_targ_infront={
	local vector	vang, vec;
	local float		dot;
  
  vang = self.angles;
  if( (self.flags & FL_TURRET) ){
    if( useTurret ){
      vang = self.e_tor_c.angles;
    }
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
        return self.button0;
      }
    }
  }
  return self.button0;
};
/*
===================================================
*/

void() ai_hunt_target={
  //only applies to ai that can actually move
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.goalentity = self.enemy;
  //ai_next_state( ST_RUN );
};

/*
  Rebuild of ai_walk_setup using AI macro frame functions
*/
void() ai_setup_patrol={
	if ( self.target ){
    if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
      ai_node_pick_rand( self.target );
    }
  
		self.goalentity = self.movetarget = find(world, targetname, self.target);
    
    dprint( strcat(self.goalentity.targetname, "\n") );
    
		if( !self.movetarget ){
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    self.th_walk();
    return;
	}
	else{
		self.pausetime = 99999999;
    self.th_stand();
    return;
	}
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
    
    dprint( strcat(self.goalentity.targetname, "\n") );
    
		if( !self.movetarget ){
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    //ai_next_state( ST_WALK );
    return;
	}
	else{
		self.pausetime = 99999999;
    //ai_next_state( ST_STAND );
    return;
	}
};

void() ai_hunt_setup={

  //ai_sfx_huntStart
  ai_sfx_huntStart();
  
  //create hunt node
  node_hunt_setup();  
  
  //set next bot state
  //ai_next_state( ST_HUNT );

  if( (self.flags & FL_TURRET) ){
    ai_turret_set_state( TR_GOAL );
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