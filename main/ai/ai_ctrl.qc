/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: AI Controller functions, ported mainly from Quake 1
*/


/*
  Teleport when blocked.
  Simple garbage-collect, place AI either
    NEAR closest ai_node_tether
    OR if they're on a path,
    their last path.
  
  ONLY if the player is far away and obscured!
*/
float() ai_blocked_teleport={
  local entity clients;
  local float canPort;
  local float isSeen;
  isSeen = 0;
  canPort = FALSE;
  for(clients = nextent(find(world, classname, "player")); (clients.classname=="player"); clients = nextent(clients)){
    if( clients.data_idx == 0 ){
      continue;
    }
    if( vlen(clients.origin - self.origin) < AI_RANGE_M * 0.67){
      tracebox(clients.origin, clients.mins, clients.maxs, self.origin, MOVE_NORMAL, clients);
      if( trace_fraction == 1.0 ){
        isSeen = isSeen + 1;
      }
    }
  }
  if( isSeen == 0 ){
    if( self.patrolNode ){
      if( self.patrolNode.partPrev ){
        self.tetherOrg = util_find_random_farpoint(self.patrolNode.partPrev.origin, self.patrolNode.partPrev, max(self.patrolNode.partPrev.ai_view*0.15,32), 24);
        self.tetherStatus = TETHER_NODE;
      }
      else{
        self.tetherOrg = util_find_random_farpoint(self.patrolNode.origin, self.patrolNode, max(self.patrolNode.ai_view*0.15,32), 24);
        self.tetherStatus = TETHER_NODE;
        
      }
      setorigin(self, self.tetherOrg);
      cons_logAFloat("ai_blocked_teleport() - teleporting unit", 1);  //DEBUG
      return TRUE;
    }
  }
  return FALSE;
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

float( float moveAngle, float moveSpeed, void() nextFrameFunc ) ai_move_frame={
  if( walkmove( moveAngle, moveSpeed ) ){
    macro_ai_frame(nextFrameFunc)
    return TRUE;
  }
  return FALSE;
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
      self.ai_react_buffer = time + self.ai_react_time * 2;
      self.ai_state_next = ST_COMBAT;
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


//TODO - knock out func params, these will be deprecated
float(void() nextFunc, void() pauseFunc) ai_patrol_frame={
  //deprecated - remove soon.
  return FALSE;
};

/*
  PATROL SUB STATE
    PATROL_PAUSE        = 1;  //Paused at node because node had .float paustime
    PATROL_WALKING      = 2;  //walking to a node where dist > AI_RANGE_S
    PATROL_ARRIVE       = 3;  //dist <= AI_NODE_DISTANCE
    PATROL_ADJUST       = 4;  //arriving at a node where dist < AI_RANGE_S && dist > AI_NODE_DISTANCE
    PATROL_BLOCK        = 5;  // the walkmove() calls returned FALSE, indicating a blockage
    void() ai_patrol_state_frame;
  .float patrolState;
*/
void() ai_patrol_state_frame={
  local entity nextNode;
  local float distLeft;
  local vector blockCheck;
  local vector cacheOrg;
  local vector norms;
  
  local float walkSpeed, cornerSpeed, useSpeed;
  walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 2;
  walkSpeed = max(walkSpeed, 1);
  cornerSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 4;
  cornerSpeed = max(cornerSpeed, 1);
  
  //cons_logAFloat("ai_patrol_frame().walkSpeed", walkSpeed);//debug
 // cons_logAFloat("ai_patrol_frame().cornerSpeed", cornerSpeed);//debug
  
  //PAUSED AT NODE
  if( time < self.pausetime ){
    self.tetherStatus = TETHER_SELF;
    self.patrolState = PATROL_PAUSE;
    return;
  }

  cacheOrg = self.goalentity.origin;
  self.lastorigin = self.origin;
  if( self.tetherStatus == TETHER_NODE ){
    distLeft = vlen(self.goalentity.origin - self.origin); 
  }
  else{
    distLeft = vlen(self.tetherOrg - self.origin); 
  }
  //GOING TO NODE-----------------------------------
  if( distLeft > self.goalentity.ai_view ){
    cons_logAString("ai_patrol_state_frame()", "distLeft > self.goalentity.ai_view"); //debug
    cons_logAFloat(self.goalentity.targetname, self.goalentity.ai_view); //debug
    cons_logAFloat("distLeft", distLeft); //debug
    ai_face_goal();
    if( ai_check_face(self.goalentity, 0.75, (self.flags&FL_TURRET)) ){
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        movetogoal( walkSpeed );
      }
    }
    else{
      if( walkmove(self.angles_y, cornerSpeed) == FALSE ){
        movetogoal( cornerSpeed );
      }
    }
    self.patrolState = PATROL_WALKING;
    return;
  }
  //------------------------------------------------
  
  //ADJUST NEAR NODE - ADJUST FINAL DESTINATION
  if( distLeft > self.goalentity.ai_view * 0.5 ){
    cons_logAFloat(self.goalentity.targetname, self.goalentity.ai_view); //debug
    self.tetherStatus = TETHER_SELF;
    self.tetherOrg = util_find_random_farpoint(self.goalentity.origin, self.goalentity, max(self.goalentity.ai_view*0.15,32), 24);
    if( (self.flags & FL_TURRET) ){
      self.torsoCenter.ai_dir = vectoyaw(self.tetherOrg - self.origin);
      self.torsoCenter.attack_state = TR_YAW;
    }
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }
    ai_face_goal();
    if( ai_check_face_origin(self.tetherOrg, 0.85, FALSE) ){
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        setorigin(self.patrolNode, self.tetherOrg);
        movetogoal( walkSpeed );
        setorigin(self.patrolNode, cacheOrg);
      }
    }
    else{
      if( walkmove(self.angles_y, cornerSpeed) == FALSE ){
        setorigin(self.patrolNode, self.tetherOrg);
        movetogoal( cornerSpeed );
        setorigin(self.patrolNode, cacheOrg);
      }
    }
    self.patrolState = PATROL_WALKING;
    return;
  }
  
  //PATROL - ARRIVING AT NODE
  if( distLeft <= self.goalentity.ai_view * 0.5 && distLeft > max(self.goalentity.ai_view*0.15,32)){
    if( self.tetherStatus == TETHER_SELF ){
      ai_face_origin(self.tetherOrg);
      setorigin(self.patrolNode, self.tetherOrg);
    }
    else{
      ai_face_goal();
    }
    if( (self.flags & FL_TURRET) ){
      self.torsoCenter.ai_dir = vectoyaw(self.tetherOrg - self.origin);
      self.torsoCenter.attack_state = TR_YAW;
    }
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }
    
    setorigin(self.patrolNode, self.tetherOrg);
    if( ai_check_face(self.goalentity, 0.85, FALSE) ){
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        movetogoal( walkSpeed );
      }
    }
    else{
      if( walkmove(self.angles_y, cornerSpeed) == FALSE ){
        movetogoal( cornerSpeed );
      }
    }
    setorigin(self.patrolNode, cacheOrg);
    self.patrolState = PATROL_ADJUST;
    return;
  }
  
  //PATROL - ARRIVED AT NODE, set pause and next node
  if( self.goalentity.partNext != world ){
    nextNode = self.goalentity.partNext;
    self.patrolNode = nextNode;
    self.tetherStatus = TETHER_PATROL;
    self.tetherOrg = self.patrolNode.origin;
    makevectors(self.angles);
    blockCheck = self.origin;
    if( self.legs ){
      blockCheck = blockCheck + (v_up * (self.mins_z * 0.5));
    }
    
    //traceline(blockCheck, self.tetherOrg, MOVE_NORMAL, self);
    tracebox(self.origin, self.mins, self.maxs, self.tetherOrg, MOVE_NORMAL, self);
    norms = util_trace_norm_angle();
    if( trace_fraction < 0.26 && norms_x <= 0.5) {
      self.patrolNode = self.goalentity;
      self.tetherOrg = self.patrolNode.origin;
    }
  }
  else{
    self.patrolNode = world;
    self.tetherStatus = TETHER_NODE;
  }
  if( self.goalentity.pausetime && nextNode != self.goalentity ){
    self.pausetime = self.goalentity.pausetime;
    self.pausetime = max(5, self.pausetime - (self.ai_rank / 2));
    self.goalentity = self.patrolNode;
    self.patrolState =  PATROL_PAUSE;
    return;
  }
  else{
    self.goalentity = self.patrolNode;
    self.patrolState = PATROL_WALKING;
    return;
  }
  self.patrolState =  PATROL_ARRIVE;
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
  //DEPRECATE ASAP
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
  //DEPRECATE ASAP
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
  //DEPRECATE ASAP
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
float(entity t, float ang, float useTurret) ai_check_face={
	local vector	vang, vec;
	local float		dot;
  
  if( useTurret ){
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

float(vector v, float ang_limit, float useTurret) ai_check_face_origin={
  local vector vang, vec;
  local float dot;
  
  if( useTurret ){
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
  local float contentBuffer;
  
  spot1 = self.cockpit.origin;
  if( targ.data_type == DATA_BLD ){
    spot2 = targ.hitOffset;
  }
  else{
    spot2 = targ.cockpit.origin;
  }
  contentBuffer = self.dphitcontentsmask;
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_DONOTENTER | DPCONTENTS_MONSTERCLIP);
  
    traceline (spot1, spot2, FALSE, self);
  
  self.dphitcontentsmask = contentBuffer;

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

float(float moveDist, float wishSpeed, float interval) ai_move_time_calc={
  
  return 0;
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
      self.ai_state_next = ST_STAND;
      if( (self.spawnflags & DEBUG_MODE) ){
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
    self.patrolNode = node;
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
    if( (self.spawnflags & DEBUG_MODE) ){
      return;
    }
    self.tetherStatus = TETHER_PATROL;  //debug
    self.tetherOrg = self.patrolNode.origin;
    self.nextthink = time + (random() * 2);
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - COLD_START;
      self.nextthink = self.nextthink + 7;
      return;
    }
  }
  else{
    if( (self.spawnflags & DEBUG_MODE) ){
      return;
    }
    self.nextthink = time + (random() * 2);
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - (self.spawnflags & COLD_START);
      self.nextthink = self.nextthink + 7;
    } 
  }
};


/*
===================================================
  AI MOVEMENTS
  I've decided to completely standardize ALL AI movement into a select list of generic possible actions.
    It is up to each bot to determine HOW LONG they will execute a maneuver, and WHEN they will do so,
    but the maneuvers themselves will be described here. 
    
    Movements are chosen by setting .ai_move_next INSIDE any [ST_COM_MOVE_START] state calls.
    these functions are then chosen be a switch-case() operation in ai_combat_move_frame().
    
    Each move will require some inputs for the 'setup' and some will access ai_dampen for simulating velocity.
    Each movement function has a 'header' / 'setup' by comparing current ai_move against ai_move_last.
===================================================
*/
/*
  MOVE-STAND
    AI stands in place, tracking target as needed.
*/
void() ai_move_stand={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    cons_logAFloat("NEW MOVE - MOVE_STAND", MOVE_STAND);  //debug
    self.ai_movewait = time + self.ai_movedist;
    if(self.legs){
      self.legs.attack_state = TR_YAW;
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.ai_clearblock ){
      self.ai_blockflag = 0;
      self.ai_moveflag = rint(0);
      self.ai_moveflag = self.ai_dance_card;
    }
    return;
  }
  ai_attack();
};

/*
  MOVE-CHARGE
    AI charges forwar at target, maintaining direction TO target
*/
float() ai_move_charge={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = self.data_speed_forward * 0.3;
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_CHARGE", MOVE_CHARGE);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_CHARGE", MOVE_CHARGE);  //debug
    self.ai_movewait = time + status;
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = self.ai_dir;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return 1;
  }
  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
    cons_logAFloat("self.ai_dampen", self.ai_dampen); //debug
  }
  if( self.angles_y == self.ai_dir ){
    status = walkmove( self.angles_y, self.ai_wishSpeed * self.ai_dampen );
  }
  else{
    ChangeYaw();
  }
  ai_attack();
  return status;
};

/*
  MOVE-CHARGE/LEFT
    AI charges at target but along angle (A)
*/
float() ai_move_charge_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward / 2 )+ (self.data_speed_strafe / 2)  * 0.3;
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ai_dir = anglemod(self.ai_dir + 45);
  
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_CHARGE_LEFT", MOVE_CHARGE_LEFT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_CHARGE_LEFT", MOVE_CHARGE_LEFT);  //debug
    self.ai_movewait = time + status;
    cons_logAFloat("self.ideal_yaw", self.ideal_yaw); //debug
    cons_logAFloat("self.ai_dir", self.ai_dir); //debug
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = self.ai_dir;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
    cons_logAFloat("self.ai_dampen", self.ai_dampen); //debug
  }

  if( self.angles_y == self.ideal_yaw ){
    status = walkmove( self.angles_y, self.ai_wishSpeed * self.ai_dampen );
  }
  else{
    ChangeYaw();
  }
  ai_attack();
  return status;
};

/*
  MOVE-CHARGE/RIGHT
    AI charges at target but along angle (A)
*/
float() ai_move_charge_right={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward / 2 )+ (self.data_speed_strafe / 2) * 0.3;
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ai_dir = anglemod(self.ai_dir - 45);
  
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_CHARGE_RIGHT", MOVE_CHARGE_RIGHT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_CHARGE_RIGHT", MOVE_CHARGE_RIGHT);  //debug
    self.ai_movewait = time + status;
    cons_logAFloat("self.ideal_yaw", self.ideal_yaw); //debug
    cons_logAFloat("self.ai_dir", self.ai_dir); //debug
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = self.ai_dir;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
    cons_logAFloat("self.ai_dampen", self.ai_dampen); //debug
  }
  if( self.angles_y == self.ideal_yaw ){
    status = walkmove( self.angles_y, self.ai_wishSpeed * self.ai_dampen );
  }
  else{
    ChangeYaw();
  }
  ai_attack();
  return status;
};


/*
  MOVE-STRAFE/LEFT
    AI moves at a 85-110 deg perpendicular angle(initially)  to the target, and does not rotate to track target.
*/
float() ai_move_strafe_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = anglemod(self.angles_y - 90);
    self.ai_wishSpeed = self.data_speed_strafe * 0.5;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_STRAFE_LEFT", MOVE_STRAFE_LEFT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_STRAFE_LEFT", MOVE_STRAFE_LEFT);  //debug
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.ai_dir = self.ai_dir;
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  if(self.angles_y == self.ideal_yaw){
    status = walkmove( self.ai_dir, (self.data_speed_strafe * self.ai_dampen) );
  }
  else{
    ChangeYaw();
  }

  ai_attack();
  return status;
};
/*
  MOVE-STRAFE/RIGHT
    AI moves at a 85-110 deg perpendicular angle(initially)  to the target, and does not rotate to track target.
*/
float() ai_move_strafe_right={
  local float status;
  
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = anglemod(self.angles_y + 90);
    self.ai_wishSpeed = self.data_speed_strafe * 0.5;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_STRAFE_RIGHT", MOVE_STRAFE_RIGHT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_STRAFE_RIGHT", MOVE_STRAFE_RIGHT);  //debug
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.ai_dir = self.ai_dir;
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  if( self.angles_y == self.ai_dir ){
    status = walkmove( self.ai_dir, self.data_speed_strafe * self.ai_dampen);
  }
  else{
    ChangeYaw();
  }
  ai_attack();
  return status;
};

/*
  MOVE-CIRCLE/LEFT
    AI moves in an oblique direction to target, using target-facing angle a it moves, 'circle-strafing' essentially.
*/
float() ai_move_circle_left={
  local float status;
  status = TRUE;
  self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
  self.ai_dir = anglemod(self.ai_dir - 70);
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward / 2 )+ (self.data_speed_strafe / 2) * 0.3;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_CIRCLE_LEFT", MOVE_CIRCLE_LEFT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_CIRCLE_LEFT", MOVE_CIRCLE_LEFT);  //debug
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }
  if( self.legs ){
    self.legs.ai_dir = self.ai_dir;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );

  ai_attack();
  return status;
};
/*
  MOVE-CIRCLE/right
    AI moves in an oblique direction to target, using target-facing angle a it moves, 'circle-strafing' essentially.
*/
float() ai_move_circle_right={
  local float status;
  status = TRUE;
  self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
  self.ai_dir = anglemod(self.ai_dir + 70);
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward / 2 )+ (self.data_speed_strafe / 2) * 0.3;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_CIRCLE_RIGHT", MOVE_CIRCLE_RIGHT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_CIRCLE_RIGHT", MOVE_CIRCLE_RIGHT);  //debug
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }
  if( self.legs ){
    self.legs.ai_dir = self.ai_dir;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  self.angles_y = self.ai_dir;
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );
  ai_attack();
  return status;
};


/*
  MOVE-BACK
    AI moves straight back along move-starting angle.
*/
float() ai_move_back={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = anglemod(self.angles_y - 180);
    self.ai_wishSpeed = self.data_speed_backward * 0.3;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_BACK", MOVE_BACK);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_BACK", MOVE_BACK);  //debug
    self.ai_movewait = time + status;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = anglemod(self.ai_dir + 180);
      self.legs.think = bot_leg_back1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
    cons_logAFloat("self.ai_dampen", self.ai_dampen); //debug
  }
  ai_face_targ();
  ai_attack();
  status = walkmove( self.ai_dir,  self.ai_wishSpeed * self.ai_dampen  );
  return status;
};
/*
  MOVE-BACK/LEFT
    AI moves straight back along move-starting angle.
*/
float() ai_move_back_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = self.angles_y - 180;
    self.ai_dir = self.ai_dir + (25 + (random() * 35));
    self.ai_dir = anglemod(self.ai_dir);
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    self.ai_wishSpeed = (self.data_speed_forward / 2 )+ (self.data_speed_strafe / 2) * 0.3;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      cons_logAFloat("!BLOCKED! MOVE_BACK_LEFT", MOVE_BACK_LEFT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_BACK_LEFT", MOVE_BACK_LEFT);  //debug
    self.ai_movewait = time + status;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = anglemod(self.ai_dir + 180);
      self.legs.think = bot_leg_back1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
    cons_logAFloat("self.ai_dampen", self.ai_dampen); //debug
  }
  ai_face_targ();
  ai_attack();
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );
  return status;
};
/*
  MOVE-BACK/RIGHT
    AI moves straight back along move-starting angle.
*/
float() ai_move_back_right={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = self.angles_y - 180;
    self.ai_dir = self.ai_dir - (25 + (random() * 35));
    self.ai_dir = anglemod(self.ai_dir);
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    self.ai_wishSpeed = (self.data_speed_forward / 2 )+ (self.data_speed_strafe / 2) * 0.3;
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 1 ){
      cons_logAFloat("!BLOCKED! MOVE_BACK", MOVE_BACK_RIGHT);  //debug
      return FALSE;
    }
    cons_logAFloat("NEW MOVE - MOVE_BACK", MOVE_BACK_RIGHT);  //debug
    cons_logAFloat("-------------------- self.ai_movewait",  self.ai_movewait);  //debug
    self.ai_movewait = time + status;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = anglemod(self.ai_dir + 180);
      self.legs.think = bot_leg_back1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return status;
  }  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
    cons_logAFloat("self.ai_dampen", self.ai_dampen); //debug
  }
  ai_face_targ();
  ai_attack();
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );
  return status;
};

/*
  MOVE-SNAP-SHOT
    
*/
void() ai_move_snapshot={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    cons_logAFloat("NEW MOVE - MOVE_SNAPSHOT", MOVE_SNAPSHOT);  //debug
    self.ai_movewait = time + self.ai_movedist;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.legs.ai_dir = anglemod(self.angles_y);
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return;
  }
  ai_face_targ();
  ai_attack();
};

/*
  MOVE-SNIPER SHOT
    AI remains stationary but charges up for a full, super accurate blast.
*/
void() ai_move_snipeshot={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){    
    cons_logAFloat("NEW MOVE - MOVE_SNIPESHOT", MOVE_SNIPESHOT);  //debug
    self.ai_movewait = time + self.ai_movedist;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.legs.ai_dir = anglemod(self.angles_y);
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return;
  }
  ai_face_targ();
  ai_attack();
};

/*
  MOVE-STAND-FACE
    AI remains stationary but turns whole body to face target.
*/
void() ai_move_standface={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    cons_logAFloat("NEW MOVE - MOVE_STAND_FACE", MOVE_STAND_FACE);  //debug
    self.ai_movewait = time + self.ai_movedist;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.legs.ai_dir = anglemod(self.angles_y);
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return;
  }
  ai_face_targ();
  ai_attack();
};

/*
  Special move for AI that have a patrol route.
  If they're attacked on a patrol route, they first try to find the closest patrol node to their target.
  IF! this condition is true, they execute this particular maneuver to get closer to the enemy
  
  biggest difference between this and AI_PATROL_FRAME() is that the bot can track its target while
  moving to that node, and make attacks.
*/
float(float outRadius, float innerRadius, float proxRadius) ai_move_patrol_node={
  local entity nextNode;
  local float distLeft;
  local float walkSpeed, cornerSpeed;
  
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.patrolState = 0;
    self.tetherStatus = TETHER_NODE;
    self.tetherOrg = self.goalentity.origin;
    self.ai_dampen = 1;
    
    if( self.legs ){
      self.legs.attack_state = TR_GOAL;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    return -1;
  }
  walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 2;
  cornerSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 3;
  
  self.lastorigin = self.origin;
  distLeft = vlen(self.tetherOrg - self.origin);
  //Going to node
  if( distLeft > outRadius ){
    //cons_logAFloat("distLeft > AI_RANGE_S", distLeft);  //debug
    ai_face_goal();
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }
    if( ai_check_face(self.goalentity, 0.75, FALSE) ){
      if( !walkmove(self.angles_y, walkSpeed) ){
        movetogoal( walkSpeed );
      }
    }
    else{
      if( !walkmove(self.angles_y, cornerSpeed) ){
        movetogoal( cornerSpeed );
      }
    }
    
    ai_attack();
    return PATROL_WALKING;
  }
  
  //Arriving at node    
  if( distLeft > innerRadius){
    //cons_logAFloat("distLeft > AI_NODE_DISTANCE", distLeft);  //debug
    ai_face_origin(self.tetherOrg);
    
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }
    if( ai_check_face(self.goalentity, 0.85, FALSE) ){
      if( !walkmove(self.angles_y, walkSpeed) ){
        movetogoal( walkSpeed );
      }
    }
    else{
      if( !walkmove(self.angles_y, walkSpeed) ){
        movetogoal( cornerSpeed );
      }
    }
    ai_attack();
    return PATROL_WALKING;
  }
  return PATROL_ARRIVE;
};

void() ai_move_node_radius={
  local entity node;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.patrolState = 0;
    self.ai_dampen = 0;
    self.goalentity = self.patrolNode;
    
    self.patrolState = ai_move_patrol_node( self.goalentity.ai_view, self.goalentity.ai_view * 0.33, 0);
    if( self.patrolState == PATROL_ARRIVE ){
      self.ai_state_next = ST_COM_MOVE_END;
      cons_logAFloat("MOVE HEADER - ai_move_node_radius() self.patrolState == PATROL_ARRIVE-> ST_COM_MOVE_END",  self.ai_state_next); //debug
      return;
    }
    
    self.ai_movewait = time + 30;
    return;
  }
  
  ai_attack();
  cons_logAFloat("PRE------->",self.patrolState); //debug
  self.patrolState = ai_move_patrol_node( self.goalentity.ai_view, self.goalentity.ai_view * 0.33, 0);
  cons_logAFloat("POST------->",self.patrolState); //debug
  if( self.patrolState == PATROL_ARRIVE ){
    self.ai_state_next = ST_COM_MOVE_END;
      cons_logAFloat("ai_move_node_radius() self.patrolState == PATROL_ARRIVE-> ST_COM_MOVE_END",  self.ai_state_next); //debug
    return;
  }
  
};

void() ai_move_node_hide={
  
};

void() ai_move_node_clear={

};

void() ai_move_node_reverse={

};