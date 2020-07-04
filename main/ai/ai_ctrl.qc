/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/

void( float estate ) ai_turret_set_state={
  if( (self.torsoCenter) ){
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
  local float ang;
  local float oldAng;
  if( (self.torsoCenter) ){
    turretOwner = self;
    self = self.torsoCenter;
      oldAng = self.angles_y;
      macro_set_offset(turretOwner, self.compOffset)
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
    self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
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
  self = self.legs;
    macro_set_offset(self.owner, self.compOffset)
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
  local float enemyFront;
  local float otherFront;
  local entity thisEnemy;
    //ignore environment
  if( !(other.flags & FL_UNIT) ){
    return;
  }
  
  enemyFront = ai_check_targ_infront( self.enemy, self.ai_fov, (self.flags & FL_TURRET) ); 
  otherFront = ai_check_targ_infront( other, self.ai_fov, (self.flags & FL_TURRET) );
  if( other.faction != self.faction ){
    if( ai_valid_target(self.enemy) ){
      if( !enemyFront && otherFront ){
        thisEnemy = other;
      }
    }
    else{
      thisEnemy = other;
    }
    if( time > self.ai_react_buffer ){
      self.enemy = other;
      if( (self.flags & FL_TURRET) ){
        self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
        self.torsoCenter.attack_state = TR_TARG;
      }
      self.ai_react_buffer = time + self.ai_react_time * 2;
      return;
    }
  }
};

/*
  processes 1 frame of AI logic for moving towards a patrol node;
  the return value is used to check if entire frame should return early.
  
  turned into macro_ai_patrol in ai_api.qh - Roohr
  
float( float moveSpeed, void() pauseFrameFunc, void() nextFrameFunc ) ai_patrol_logic={
macro_ai_patrol(speed,pauseFunc,nextFunc) 
  
  local entity nextNode;
  
  if( (self.goalentity.flags&FL_NODE) ){
    ai_face_goal();
    
    if( walkmove(self.angles_y,max(speed,65*AI_WALK_SPD))==FALSE ){
      movetogoal(max(self.data_speed_forward,65*AI_WALK_SPD));
      ai_patrol_turn();
    }
    if(vlen(self.goalentity.origin-self.origin)<=(random()*AI_NODE_DISTANCE)){
      if(self.goalentity.pausetime){
        self.pausetime=self.goalentity.pausetime;
        self.pausetime=self.pausetime+(self.pausetime*(self.ai_action_mod/10));
        self.pausetime = self.pausetime+time;
      }
      if(self.goalentity.target){
        nextNode=find(world,targetname,self.goalentity.target);
        self.movetarget=nextNode;
      }
      else{
        if(self.goalentity.ai_rank>0){
          self.movetarget=world;
          self.goalentity.think=SUB_Remove;
          self.goalentity.nextthink=time+0.1;
        }
        else{
          self.movetarget=ai_goal_offset_node();
        }
      } 
      self.goalentity=self.movetarget;
      if(time<self.pausetime){
        macro_ai_frame(pauseFunc) 
        return;
      }
    } 
    macro_ai_frame(nextFunc) 
    return;
  } 
  macro_ai_frame(pauseFunc)
};
*/

/*
  Not exactly sure why I converted this to macro except cutting down on stack size?
  reports back a status

  float PATROL_PAUSE        = 1;
  float PATROL_WALKING      = 2;
  float PATROL_ARRIVE       = 3
  float PATROL_ADJUST       = 4;

*/
float(void() nextFunc, void() pauseFunc) ai_patrol_frame={
  local entity nextNode;
  local float distLeft;
  local vector blockCheck;
  local vector orgCheck;
  local vector norms;
  
  local float walkSpeed, cornerSpeed, useSpeed;
  walkSpeed = max(self.data_speed_forward*AI_WALK_SPD,65*AI_WALK_SPD);
  cornerSpeed = max((self.data_speed_forward/4)*AI_WALK_SPD,24*AI_WALK_SPD);
  
  //paused at node
  if( time < self.pausetime ){
    //pauseFunc();
    return PATROL_PAUSE;
  }

  self.lastorigin = self.origin;
  if( (self.goalentity.flags&FL_NODE) ){
    distLeft = vlen(self.tetherOrg - self.origin);
    //Going to node
    if( distLeft > AI_RANGE_S ){
      //cons_logAFloat("distLeft > AI_RANGE_S", distLeft);  //debug
      ai_face_goal();
      if( (self.flags & FL_TURRET) ){
        self.torsoCenter.attack_state = TR_NORM;
      }
      if( (self.legs) ){
        self.legs.attack_state = TR_NORM;
      }
      if( ai_check_face(self.goalentity, 0.75) ){
        if( !walkmove(self.angles_y, walkSpeed) ){
          movetogoal( walkSpeed );
        }
        useSpeed = walkSpeed;
      }
      else{
        if( !walkmove(self.angles_y, walkSpeed) ){
          movetogoal( cornerSpeed );
        }
        useSpeed = cornerSpeed;
      }
      //stuck check
      if( !util_movedelta( self.lastorigin, self.origin, useSpeed * 0.5 ) ){
        self.movetype = MOVETYPE_FLY;
      }
      else{
        self.movetype = MOVETYPE_STEP;
      }
      //macro_ai_frame(nextFunc)
      return PATROL_WALKING;
    }
    
    //Arriving at node
    if( distLeft < AI_RANGE_S && self.tetherStatus == TETHER_PATROL ){
      //cons_logAFloat("distLeft > (AI_RANGE_S * 0.5)", distLeft);  //debug
      self.tetherStatus = TETHER_NODE;
      self.tetherOrg = util_find_random_farpoint(self.goalentity.origin, self.goalentity, 96, 32);
      if( (self.flags & FL_TURRET) ){
        self.torsoCenter.attack_state = TR_NORM;
      }
      if( (self.legs) ){
        self.legs.attack_state = TR_NORM;
      }
      if( ai_check_face(self.goalentity, 0.85) ){
        if( !walkmove(self.angles_y, walkSpeed) ){
          movetogoal( walkSpeed );
        }
        useSpeed = walkSpeed;
      }
      else{
        if( !walkmove(self.angles_y, walkSpeed) ){
          movetogoal( cornerSpeed );
        }
        useSpeed = cornerSpeed;
      }
      //stuck check
      if( !util_movedelta( self.lastorigin, self.origin, useSpeed * 0.5 ) ){
        self.movetype = MOVETYPE_FLY;
      }
      else{
        self.movetype = MOVETYPE_STEP;
      }
      //macro_ai_frame(nextFunc)
      return PATROL_ARRIVE;
    }
    if( distLeft > AI_NODE_DISTANCE ){
      //cons_logAFloat("distLeft > AI_NODE_DISTANCE", distLeft);  //debug
      ai_face_origin(self.tetherOrg);
      
      if( (self.flags & FL_TURRET) ){
        self.torsoCenter.attack_state = TR_NORM;
      }
      if( (self.legs) ){
        self.legs.attack_state = TR_NORM;
      }
      if( ai_check_face(self.goalentity, 0.85) ){
        if( !walkmove(self.angles_y, walkSpeed) ){
          movetogoal( walkSpeed );
        }
        useSpeed = walkSpeed;
      }
      else{
        if( !walkmove(self.angles_y, walkSpeed) ){
          movetogoal( cornerSpeed );
        }
        useSpeed = cornerSpeed;
      }
      //stuck check
      if( !util_movedelta( self.lastorigin, self.origin, useSpeed * 0.5 ) ){
        self.movetype = MOVETYPE_FLY;
      }
      else{
        self.movetype = MOVETYPE_STEP;
      }
      if( orgCheck != self.origin ){
        //macro_ai_frame(nextFunc)
        return PATROL_ADJUST;
      }
    }
    
    //arrived, set pause and next node
    if( self.goalentity.partNext != world ){
      nextNode = self.goalentity.partNext;
      self.movetarget = nextNode;
      self.tetherStatus = TETHER_PATROL;
      self.tetherOrg = self.movetarget.origin;
      makevectors(self.angles);
      blockCheck = self.origin;
      if( self.legs ){
        blockCheck = blockCheck + (v_up * (self.mins_z * 0.5));
      }
      
      traceline(blockCheck, self.tetherOrg, MOVE_NORMAL, self);
      self.dphitcontentsmask = 0;
      norms = util_trace_norm_angle();
      //trailparticles(self, particleeffectnum("TE_LAS_RAIL"), blockCheck, self.tetherOrg); //debug
      //cons_logAVector("(v_up * (self.mins_z * 0.5))", (v_up * (self.mins_z * 0.5)));  //debug
      //cons_logAVector("trace_plane_normal angle", norms);  //debug
      //cons_logAFloat("trace_fraction", trace_fraction);  //debug
      if( trace_fraction < 0.26 && norms_x <= 0.5) {
        self.movetarget = self.goalentity;
        self.tetherOrg = self.movetarget.origin;
      }
    }
    else{
      self.movetarget = world;
      self.tetherStatus = TETHER_NODE;
      //cons_logAFloat("self.movetarget = world;", 1);  //debug
    }
    if( self.goalentity.pausetime ){
      self.pausetime = self.goalentity.pausetime;
      self.pausetime = min(1, self.pausetime - (self.ai_rank / 2));
      self.pausetime = self.pausetime+time;
      self.goalentity = self.movetarget;
     // macro_ai_frame(pauseFunc)
      return PATROL_PAUSE;
    }
    else{
      self.goalentity = self.movetarget;
      //macro_ai_frame(nextFunc)
      return PATROL_WALKING;
    }
  }
  else{
    //macro_ai_frame(pauseFunc)
    return PATROL_PAUSE;
  }
  return PATROL_WALKING;
};

void() ai_tether_frame={
  if( self.tetherOrg == '0 0 0' ){
    //ai lacks a tether node at this time;
    self.tetherStatus = TETHER_SELF;
    self.think = self.th_stand;
    self.nextthink = time + 0.05;
    return;
  }
  if( vlen(self.tetherOrg - self.origin) > 32 ){
    //travelling to node
    ai_face_origin(self.tetherOrg);
    self.legs.attack_state = TR_NORM;
    if( self.enemy ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    else{
      self.torsoCenter.attack_state = TR_NORM;
    }
    if( ai_check_face_origin(self.tetherOrg, 0.75) ){
      walkmove(self.angles_y, 65*AI_WALK_SPD);
    }
    else{
      walkmove(self.angles_y, 15*AI_WALK_SPD);
    }
  }
  else{
    //reached the node
    self.think = self.th_stand;
    self.nextthink = time + 0.05;
  }
};

void() ai_face_goal={
  self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
  ChangeYaw();
};


void(vector v) ai_face_origin={
  self.ideal_yaw = vectoyaw(v - self.origin);  
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
    if( walkmove(self.angles_y, moveSpeed) == FALSE ){
      movetogoal( moveSpeed );
    }
    //check for closest patrol node
    if( self.movetarget != world && self.movetarget.classname != "ai_node" ){
      if( vlen(self.movetarget.origin - self.origin) < vlen(self.goalentity.origin - self.origin) ){
        if( ai_check_vis(self.movetarget) != VIS_FAIL ){
          self.goalentity = world;
          handOff = self.ai_node_recall;
          self.ai_node_recall = world;
          strunzone(handOff.targetname);
          remove(handOff);
        }
      }
    }
    //reached the recall node
    if( vlen(self.goalentity.origin - self.origin) <= AI_NODE_DISTANCE ){
      self.goalentity = world;
      handOff = self.ai_node_recall;
      self.ai_node_recall = world;
      strunzone(handOff.targetname);
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
  local float enemyVis;
  enemyVis = ai_check_vis(self.enemy);
  if( enemyVis == VIS_FAIL ){
    return FALSE;
  }
  if( self.stat_trg_dist < AI_RANGE_M ){
    strunzone(self.ai_node_recall.targetname);
    remove(self.ai_node_recall);
    self.ai_node_recall = world;
    self.attack_state = 0;
    macro_ai_frame(frameFuncOnSpot)
    return TRUE;
  }
  if( self.stat_trg_dist >= AI_RANGE_M ){
    self.attack_state = 0;
    macro_ai_frame(frameFuncRangeOut)
    return TRUE;
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

float(vector v, float ang_limit) ai_check_face_origin={
  local vector vang, vec;
  local float dot;
  
  if( (self.flags & FL_TURRET) ){
    vang = self.torsoCenter.angles;
  }
  else{
    vang = self.angles;
  }
  
  makevectors ( vang );
  vec = normalize (v - self.origin);
  dot = vec * v_forward;

  if ( dot >= ang_limit){
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
  if( useTurret ){
    vang = self.torsoCenter.angles;
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
  local vector spot1, spot2;
  local float targDist;
  local float blockZ;
  
  spot1 = self.cockpit.origin;
  if( targ.data_type == DATA_BLD ){
    spot2 = targ.hitOffset;
  }
  else{
    spot2 = targ.cockpit.origin;
  }
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY);
  traceline (spot1, spot2, FALSE, self);

  //case: los crossed content - ported q1
  if ( trace_inopen && trace_inwater ){
    return VIS_FAIL;     // sight line crossed contents
  }

  //case: los hit desired target
  if( trace_ent == targ ){
    return VIS_FRAC;
  }
  
  //case: los length is 1.0, ie a clear line
  if ( trace_fraction == 1.0 ){
    return VIS_FRAC;
  }

  //case: los hit a friendly entity, who is blocking los
  if( trace_ent.faction == self.faction ){
    friend_blocker = trace_ent;
    friend_blocker_dist = vlen(friend_blocker.origin - spot1);
    return VIS_FRN;
  }
  
  return VIS_FAIL;
};

float() ai_attack={
  self.button0 = 1;
  return 1;
};

void() ai_patrol_turn={
  if( self.ideal_yaw < anglemod(self.angles_y-90) || self.ideal_yaw > anglemod(self.angles_y+90) ){
    macro_ai_frame(self.th_rotate)
  }
};

void() ai_rotate_mech={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ChangeYaw();
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame_count(ai_rotate_mech)
    macro_ai_frame(self.th_stand)
    return;
  }
  macro_ai_frame(ai_rotate_mech)
};


void() ai_rotate_tank={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame_count(ai_rotate_tank)
    macro_ai_frame(self.th_stand)
    return;
  }
  macro_ai_frame(ai_rotate_tank)
};

/*
===================================================
*/

/*
  Rebuild of ai_walk_setup using AI macro frame functions,
  allows for random node to spawn at.
*/
void() ai_setup_patrol={
  local entity node;
  local vector newOrg;
  local vector traceAngle;
  local vector newOrgTop;
  local float angl, px, py, dlen;
  
  //make a single call reference here, instead of in every ai_setup func.
  trigger_event( find(world, classname, "player"), self.trigOnSpawn ); //event interface
  
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
      node = ai_node_pick_rand();  //make sure that nodes have a .group set 
      if( node == lastNode ){
        self.think = ai_setup_patrol;
        self.nextthink = time + 0.1;
        return;
      }
      node.ai_dir = node.ai_dir + 1;
      angl = anglemod( (node.ai_dir * 45) + (crandom() * 15)) * DEG2RAD;
      node.angles_y = angl;
      makevectors(node.angles);
      self.dphitcontentsmask = 0;
      self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_BOTCLIP | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER);
      traceline( node.origin, node.origin + (v_up * (self.maxs_z * 4)), MOVE_NORMAL, self);
      traceline( trace_endpos, trace_endpos + (v_forward * (self.maxs_x * 4)), MOVE_HITMODEL, self);
      //traceline( trace_endpos, trace_endpos + (v_up * -1024), MOVE_NORMAL, self);
      tracebox(trace_endpos, self.mins, self.maxs, trace_endpos + (v_up * -1024), MOVE_NORMAL, self);  
      newOrg = trace_endpos;
      newOrg = newOrg + (v_up * self.maxs_z);
      newOrg = newOrg - (v_up * self.mins_z);
      traceline( node.origin, newOrg, MOVE_NORMAL, self);
      traceAngle = vectoangles(newOrg - node.origin);
      
      if( trace_fraction <= 0.33 && traceAngle_x >= 75 ){
        node.ai_dir = node.ai_dir + 1;
        self.think = ai_setup_patrol;
        self.nextthink = time + 0.1;
        return;
      }
      if( pointcontents(newOrg) != CONTENT_EMPTY ){
        node.ai_dir = node.ai_dir + 1;
        self.think = ai_setup_patrol;
        self.nextthink = time + 0.1;
        return;
      }
      if( trace_ent != world && trace_ent.classname != "map_terrain_model" && (trace_ent.flags & FL_UNIT)){
        node.ai_dir = node.ai_dir + 1;
        self.think = ai_setup_patrol;
        self.nextthink = time + 0.1;
        return;
      }
      self.spawnflags = self.spawnflags - self.spawnflags & RANDOM_START;
      setorigin( self, newOrg);
    }
    self.target = node.targetname;
    self.movetarget = node;
    self.goalentity = node;
    self.ideal_yaw = vectoyaw( node.origin - self.origin );
    
    if( (self.spawnflags & NO_DROP) ){
      self.flags = self.flags - (self.flags & FL_ONGROUND);
    }
    else{
        droptofloor();
    }
    if( (self.flags & FL_TURRET) ){
      util_setOffsetOrigin(self.torsoCenter, self, self.torsoCenter.compOffset);
    }
    if( self.legs != world ){
      util_setOffsetOrigin(self.legs, self, self.legs.compOffset);
    }
    self.think = self.th_walk;
    if( (self.spawnflags & DEBUG_MODE) ){
      self.think = SUB_Null;
      return;
    }
    self.tetherStatus = TETHER_PATROL;  //debug
    self.tetherOrg = self.movetarget.origin;
    self.nextthink = time + (random() * 2);
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - COLD_START;
      self.think = self.th_stand;
      self.nextthink = self.nextthink + 7;
      return;
    }
  }
  else{
    if( (self.spawnflags & DEBUG_MODE) ){
      self.think = SUB_Null;
      return;
    }
      //debug
    //check for tether node
    ai_node_tether_find();
    if( self.tetherStatus == TETHER_NODE ){
      self.think = self.th_walk;
    }
    else{
      self.think = self.th_stand;
    }
    self.nextthink = time + (random() * 2);
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - (self.spawnflags & COLD_START);
      self.nextthink = self.nextthink + 7;
    } 
  }
};

/*
  MOVE-STAND
    AI stands in place, tracking target as needed.
*/
void(float waitTime, float clearMove ) ai_move_stand={
  if( self.ai_move == MOVE_STAND && self.ai_move_last != MOVE_STAND ){
    //entered this move state.
    self.ai_movewait = time + waitTime;
    self.ai_clearblock = clearMove;
  }
  else{
    if( time > self.ai_movewait ){
      //time expired, return to top of combat state;
      self.ai_state_next = ST_COMBAT;
      if( self.ai_clearblock ){
        self.ai_blockflag = 0;
        self.ai_moveflag = self.ai_dance_card;
      }
    }
  }
};

/*
  MOVE-CHARGE
    AI charges forwar at target, maintaining direction TO target
*/

void() ai_move_charge={
  if( self.ai_move == MOVE_CHARGE && self.ai_move_last != MOVE_CHARGE ){
    //entered this move state.
  }
  else{
  
  }
};

/*
  MOVE-CHARGE/LEFT
    AI charges at target but along angle (A)
*/
void() ai_move_charge_left={
  if( self.ai_move == MOVE_CHARGE_LEFT && self.ai_move_last != MOVE_CHARGE_LEFT ){
    //entered this move state.
  }
  else{
  
  }
};

/*
  MOVE-CHARGE/RIGHT
    AI charges at target but along angle (A)
*/
void() ai_move_charge_right={
  if( self.ai_move == MOVE_CHARGE_RIGHT && self.ai_move_last != MOVE_CHARGE_RIGHT ){
    //entered this move state.
  }
  else{
  
  }
};


/*
  MOVE-STRAFE/LEFT
    AI stands in place, tracking target as needed.
*/
void() ai_move_strafe_left={

};

void() ai_move_strafe_right={

};

void() ai_move_circle_left={

};

void() ai_move_circle_right={

};

void() ai_move_back={

};
void() ai_move_back_left={

};
void() ai_move_back_right={

};
void() ai_move_snapshot={

};
void() ai_move_snipeshot={

};