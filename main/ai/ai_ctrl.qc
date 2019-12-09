/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/

void( float estate ) ai_turret_set_state={
  if( (self.torsoCenter) )
    self.torsoCenter.attack_state = estate;
};

/*
  scope = self is AI making the call.
  called every frame if the AI Unit has FL_TURRET
  flag, this  assumes .torsoCenter is the AI's turret ent.
*/
void() ai_turret_control={
  local entity turretOwner;
  local float ang;
  if( (self.torsoCenter) ){
    turretOwner = self;
    self = self.torsoCenter;
      util_setOffsetOrigin(self, turretOwner, self.compOffset);
      switch( self.attack_state ){
        case TR_NORM:
          self.ideal_yaw = turretOwner.angles_y;
          break;
        case TR_TARG:
          self.ideal_yaw = vectoyaw( turretOwner.enemy.origin - self.owner.origin );
          break;
        case TR_GOAL:
          self.ideal_yaw = vectoyaw( turretOwner.goalentity.origin - self.owner.origin );
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
  
  legOwner = self;
  if( (self.legs) ){
      self = self.legs;
      util_setOffsetOrigin(self, self.owner, self.compOffset);
      switch( self.attack_state ){
        case TR_NORM:
          self.ideal_yaw = self.owner.angles_y;
          break;
        case TR_TARG:
          self.ideal_yaw = self.ai_dir;
          break;
        case TR_GOAL:
          self.ideal_yaw = vectoyaw(self.owner.goalentity.origin - self.origin);
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

float( float moveAngle, float moveSpeed, void() nextFrameFunc ) ai_move_frame={
  if( walkmove( moveAngle, moveSpeed ) ){
    macro_ai_frame(nextFrameFunc)
    return TRUE;
  }
  return FALSE;
};

/*
  refer to macro macro_ai_
*/
void() ai_update={
  if( ai_valid_target( self.enemy ) ){
    ai_turret_set_state( TR_TARG );
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

/*
  Primary Generic touch function for AI.
*/
void() ai_touch={
    //ignore nodes straight away, logic for these touches are in ai_nodes
  if( (other.flags & FL_NODE) ){
    return;
  }
  if( other.faction != self.faction ){
    if( ai_check_targ_infront( other, self.ai_fov, FALSE) ){
      if( time > self.ai_react_buffer ){
        self.oldenemy = self.enemy;
        self.enemy = other;
        if( (self.flags & FL_TURRET) ){
          self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
          self.torsoCenter.attack_state = TR_TARG;
        }
        self.ai_react_buffer = time + self.ai_react_time * 3;
        macro_ai_frame(self.th_missile)
        return;
      }
    }
  }
};

/*
  processes 1 frame of AI logic for moving towards a patrol node;
  the return value is used to check if entire frame should return early.
  
  turned into macro_ai_patrol in ai_api.qh - Roohr
  
float( float moveSpeed, void() pauseFrameFunc, void() nextFrameFunc ) ai_patrol_logic={
  local entity nextNode;
  
  if( self.goalentity.classname == "ai_node" ){
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    ChangeYaw();
    if( walkmove( self.angles_y, self.data_speed_forward) == FALSE ){
      movetogoal( self.data_speed_forward );
    }
    //AI has reached node
    if( vlen(self.goalentity.origin - self.origin) <= (random() * AI_NODE_DISTANCE) ){
      if( self.goalentity.pausetime ){
        self.pausetime = self.goalentity.pausetime;
        self.pausetime = self.pausetime + (self.pausetime * (self.ai_action_mod / 10));
        self.pausetime = self.pausetime + time;
      }
      if( self.goalentity.target ){
        nextNode = find(world, targetname, self.goalentity.target);
        self.movetarget = nextNode;
      }
      else{
        self.movetarget = world;
      }
      self.goalentity = self.movetarget;
      if( time < self.pausetime ){
        macro_ai_frame(pauseFrameFunc)
        return TRUE;
      }
    }
    macro_ai_frame(nextFrameFunc)
    return TRUE;
  }
  macro_ai_frame(pauseFrameFunc)
  return FALSE;
};
*/

void() ai_face_goal={
  self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
  ChangeYaw();
};

/*
  processes 1 frame of AI logic for moving towards recall node;
  the return value is used to check if entir frame should return early.
  
*/
float( float moveSpeed, void() nextFrameFunc ) ai_recall_logic={
  local entity handOff;
  //moving to recall node
  if( self.goalentity && self.goalentity != world ){
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin );
    ChangeYaw();
    if( !walkmove(self.angles_y, moveSpeed) ){
      movetogoal( moveSpeed );
    }
    //reached the recall node
    if( vlen(self.goalentity.origin - self.origin) <= AI_NODE_DISTANCE ){
      self.goalentity = world;
      handOff = self.ai_node_recall;
      self.ai_node_recall = world;
      remove(handOff);
    }
    else{
      //keep moving to node
      macro_ai_frame(nextFrameFunc)
      return TRUE;
    }
  }
  return FALSE;
};

/*
  in 1 AI frame of hunting, check to see if AI can spot its target.
*/
float( void() frameFuncOnSpot, void() frameFuncRangeOut ) ai_hunt_logic_enemy_vis={
  if( ai_check_vis(self.enemy) == VIS_FRAC ){
    if( ai_check_range(self.enemy) < AI_RANGE_M / 2 ){
      remove(self.ai_node_recall);
      self.ai_node_recall = world;
      self.attack_state = 0;
      macro_ai_frame(frameFuncOnSpot)
      return TRUE;
    }
    if( ai_check_range(self.enemy) > AI_RANGE_L ){
      self.attack_state = 0;
      macro_ai_frame(frameFuncRangeOut)
      return TRUE;
    }
  }
  return FALSE;
};

/*
  a single frame of hunting logic,
  moveSpeed = self.<speed> to move at.
  nextFrameFunc = the AI frame to do.
  pauseFrameFunc = the end / fail frame to go to.
*/
void( float moveSpeed, void() nextFrameFunc, void() pauseFrameFunc ) ai_hunt_logic={
  self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
  ChangeYaw();
  if( !walkmove( self.angles_y, moveSpeed ) ){
    movetogoal( moveSpeed );
  }
  if( vlen(self.goalentity.origin - self.origin) > AI_NODE_DISTANCE ){
    macro_ai_frame(nextFrameFunc)
    return;
  }
  macro_ai_frame(pauseFrameFunc)
};

/*
===================================================
  AI Actions
  actions are the atomic functions of any AI state;
===================================================
*/
float( float scan_mode) ai_check_scan={
  local float scanned;
  scanned = FALSE;
  if( time > self.ai_viewtime ){
    self.ai_viewtime = time + self.ai_viewcheck;
    if( scan_mode ){
      scanned = ai_find_target_radar();
      return scanned;
    }
    scanned = ai_find_target_visual();
    return scanned;
  }
  return scanned;
};

void() ai_face_targ={
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
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
    self.accuracy = self.accuracy - (rate * 2);
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
  traceline (spot1, spot2, FALSE, self);
  
  if( trace_ent == targ ){
    return VIS_FRAC;
  }
  
  if ( trace_inopen && trace_inwater ){
    return VIS_FAIL;     // sight line crossed contents
  }
  
  if ( trace_fraction == 1 ){
    return VIS_FRAC;
  }
  
  if( trace_ent.faction == self.faction ){
    friend_blocker = trace_ent;
    friend_blocker_dist = vlen(friend_blocker.origin - self.origin);
    return VIS_FRN;
  }
  
  if( trace_fraction >= 0.9 && (trace_ent.flags & FL_UNIT) ){
    return VIS_FRAC;
  }
  
  return VIS_FAIL;
};

float() ai_attack={
  self.button0 = 1;
  return 1;
};

/*
===================================================
*/

/*
  Rebuild of ai_walk_setup using AI macro frame functions
*/
void() ai_setup_patrol={
  local entity node;
  local vector newOrg;
  local float angl, px, py, dlen;
  
  if( (self.target) && self.target != "" ){
    if( lastNode.targetname != self.target ){
      node = find(world, targetname, self.target);
    }
    if( !node ){
      lastNode = node;
      //error handling - target but missing the entity.
      self.think = self.th_stand;
      if( (self.spawnflags & DEBUG_MODE) ){
        self.think = SUB_Null;
        return;
      }
      self.nextthink = time + (random() * 2);
      if( (self.spawnflags & COLD_START) ){
        self.spawnflags = self.spawnflags - COLD_START;
        self.nextthink = self.nextthink + 7;
      }
      return;
    }
    if( (self.spawnflags & RANDOM_START) ){
      self.spawnflags = self.spawnflags - RANDOM_START;
      node = ai_node_pick_rand();  //make sure that nodes have a .group set   
      angl = anglemod(random() * 360) * DEG2RAD;
      px = cos(angl);
      py = sin(angl);
      dlen = crandom() * self.maxs_x * 4;
      newOrg_z = self.origin_z + self.maxs_z * 2;
      newOrg_x = node.origin_x - px * dlen;
      newOrg_y = node.origin_y - py * dlen;
      if( (pointcontents(newOrg) == CONTENT_SOLID) || (pointcontents(newOrg) == CONTENT_EMPTY) && (pointcontents(newOrg) == CONTENT_SKY) ){
        setorigin( self, node.origin);
      }
      else{
        setorigin( self, newOrg );
      }
    }
    self.target = node.targetname;
    self.movetarget = node;
    self.goalentity = node;
    self.ideal_yaw = vectoyaw( node.origin - self.origin );
    dropToFloorCorners();
    if( (self.flags & FL_TURRET) ){
      util_setOffsetOrigin(self.torsoCenter, self, self.torsoCenter.compOffset);
    }
    if( self.legs ){
      util_setOffsetOrigin(self.legs, self, self.legs.compOffset);
    }
    self.think = self.th_walk;
    if( (self.spawnflags & DEBUG_MODE) ){
      self.think = SUB_Null;
      return;
    }
    self.nextthink = time + (random() * 2);
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - COLD_START;
      self.think = self.th_stand;
      self.nextthink = self.nextthink + 7;
      return;
    }
  }
  else{
    self.think = self.th_stand;
    if( (self.spawnflags & DEBUG_MODE) ){
      self.think = SUB_Null;
      return;
    }
    self.nextthink = time + (random() * 2);
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - COLD_START;
      self.nextthink = self.nextthink + 7;
    } 
  }
};