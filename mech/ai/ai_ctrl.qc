/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/

void( float estate ) ai_turret_set_state={
  if( (self.torsoCenter) ) {
    self.torsoCenter.attack_state = estate;
  }
};

/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .torsoCenter is the AI's turret ent.
*/
void() ai_turret_control={
  local entity turretOwner;
  local float turMax, turMin;
  if( (self.torsoCenter) ){
    turretOwner = self;
    self = self.torsoCenter;
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
      //run check to see if ideal_yaw is within unit's max rotation limits.
      self.ideal_yaw = ai_check_turret_yaw( self.ideal_yaw, turretOwner.angles_y, turretOwner.ai_angleLimits_x, turretOwner.ai_angleLimits_y);
      ChangeYaw(); 
      self.v_angle = self.angles;
    self = turretOwner;
  }
};

float(float angleOfTarget, float facingAngle, float limitMin, float limitMax) ai_check_turret_yaw={
  local float angleMin, angleMax;
  angleMin = anglemod(facingAngle + limitMin);
  angleMax = anglemod(facingAngle + limitMax);
  
  if( angleMax > angleMin ){
    if( (angleMin <= angleOfTarget) && (angleOfTarget <= angleMax) ){
      return angleOfTarget;
    }
    return angleMin; //turret rotation lockout.
  }
  else {
    if( (angleMin <= angleOfTarget) || (angleOfTarget <= angleMax) ){
      return angleOfTarget;
    }
    return angleMax; //turret rotation lockout.
  }
  
};

void() ai_leg_control={
  local entity legOwner;
  local vector am;
  legOwner = self;
  if( (self.legs) ){
      self = self.legs;
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
    if( self.torsoCenter.attack_state != TR_YAW ){
      ai_turret_set_state( TR_NORM );
    }
  }
  ai_ranged_attack();
  self.button0 = 0;
};

/*
  Primary Generic touch function for AI.
*/
void() ai_touch={

  if( (other.flags & FL_NODE) ){
    //ignore nodes straight away, logic for these touches are in ai_nodes
    return;
  }

  if( other.faction == self.faction ){
    return;
  }
  
  if( ai_valid_target(other) ){
    if( !self.enemy ){
      self.enemy = other;
      self.th_missile();
      return;
    }
    if( self.ai_rank < AI_RANK_VET ){
      self.enemy = other;
      self.th_missile();
      return;
    }
  }
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
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
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

/*
	Yaw moves use the AI's ideal_yaw
	stat when turning
*/
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
    fspd = (self.data_speed_forward / 2) * AI_RUN_SPD;
    sspd = (self.data_speed_strafe / 2) * AI_RUN_SPD;
    bspd = (self.data_speed_backward * AI_RUN_SPD) * fdir;
    
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
    //unit is moving, increase spread factor
    rate = rate - self.accuracyMod;
    self.accuracy = self.accuracy + rate;
    if( self.accuracy > self.spreadDefault_y ){
      self.accuracy = self.spreadDefault_y;
    }
  }
  else{
    //standing still, lessen the spread
    rate = rate + self.accuracyMod;
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
  
  
  if( (self.flags & FL_TURRET) ){
    vang = self.torsoCenter.angles;
  }
  else{
    vang = self.angles;
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
      vang = self.torsoCenter.angles;
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
    if( trace_ent.faction == self.faction ){
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

/*
  Rebuild of ai_walk_setup using AI macro frame functions
*/
void() ai_setup_patrol={
  local entity spot, spot2;
  local vector org;
  local float angl, px, py;
  
  if( self.target ){
    if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
      spot = ai_node_pick_rand();     
      angl = self.angles_y * DEG2RAD;
      px = cos(angl);
      py = sin(angl);
      org_z = self.origin_z + 1;
      org_x = spot.origin_x - px * (random() * self.maxs_x * 3);
      org_y = spot.origin_y - py * (random() * self.maxs_y * 3);
      
      if( (pointcontents(org) != CONTENT_SOLID) && (pointcontents(org) != CONTENT_EMPTY) && (pointcontents(org) != CONTENT_SKY) ){
        setorigin( self, org );
      }
      else{
        setorigin( self, spot.origin);
      }
    }
    else{
      spot = self;
      setorigin( self, spot.origin);
    }
    if( spot ){
      droptofloor();
      if( (self.flags & FL_TURRET) ){
        util_setOffsetOrigin(self.torsoCenter, self, self.torsoCenter.c_ofs);
      }
      if( self.legs ){
        util_setOffsetOrigin(self.legs, self, self.legs.c_ofs);
      }  
    }
    if( spot.target ){
      spot2 = find(world, targetname, spot.target);
      if( spot2 ){
        self.goalentity = self.movetarget = spot2;
        self.ideal_yaw = vectoyaw( spot2.origin - self.origin);
        macro_ai_frame(self.th_walk)
        if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
          self.nextthink = time + (7 + random() * 1); //spread out thinks
        }
        else{
          self.nextthink = time + (random() * 0.1);
        }
        return;
      }
    }
  }
  self.pausetime = 99999999;
  macro_ai_frame(self.th_stand)
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random() * 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random() * 0.1);
  }
};