/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
rebuild: 07/12/2020
Overview: 
  AI Controller functions

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
  local entity node;
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
    node = ai_node_to_target(self);
    if( node ){
      self.tetherOrg = util_find_random_farpoint(self.patrolNode.partPrev.origin, self.patrolNode.partPrev, max(self.patrolNode.partPrev.ai_view*0.15,32), 24);
      self.tetherStatus = TETHER_NODE;
      return TRUE;
    }
    else{
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

/*
  Primary Generic touch function for AI.
*/
void() ai_touch={
  local float enemyFront;
  local float otherFront;
  local float vis;
  local float distanc;
  
  if( time < self.ai_react_buffer ){
    return;
  }
  //ignore environment
  if( !(other.flags & FL_MONSTER) || !(other.flags & FL_CLIENT) ){
    return;
  }
  if(self.enemy && other == self.enemy){
    self.ai_react_buffer = time + (self.ai_react_time * 3);
    return;
  }
  self.ai_react_buffer = time + (self.ai_react_time * 2);
  
  //AI lacks an enemy at the moment.
  otherFront = ai_check_targ_infront( other, self.ai_fov, (self.flags & FL_TURRET) );
  if(!self.enemy){
    if(other.faction != self.faction){
      self.enemy = other;
    }
    else if(other.enemy){
      self.enemy = other.enemy;
    }
    self.ai_move_next = MOVE_STAND_FACE;
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
  
  //AI DOES have a current enemy
  enemyFront = ai_check_targ_infront( self.enemy, self.ai_fov, (self.flags & FL_TURRET) );
  distanc = ai_check_node_radius(self.enemy);
  vis = ai_check_vis(self.enemy);
  
  if( !enemyFront && otherFront ){
    if( distanc > 1.0 || vis != VIS_FRAC){
      self.enemy = other;
    }
  }
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
  local vector cacheOrg;
  local float walkSpeed, cornerSpeed;
  
  walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 2;
  walkSpeed = max(walkSpeed, 2);
  cornerSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 4;
  cornerSpeed = max(cornerSpeed, 1);
  
  //PAUSED AT NODE
  if( time < self.pausetime ){
    self.tetherStatus = TETHER_SELF;
    self.patrolState = PATROL_PAUSE;
    return;
  }
  
  cacheOrg = self.goalentity.origin;
  self.lastorigin = self.origin;
  if( self.tetherStatus == TETHER_PATROL ){
    distLeft = vlen(self.goalentity.origin - self.origin); 
  }
  else{
    distLeft = vlen(self.tetherOrg - self.origin); 
  }
  //GOING TO NODE-----------------------------------
  if( distLeft > self.goalentity.ai_view ){
    ai_face_goal();
    if( ai_check_face(self.goalentity, 0.75, (self.flags&FL_TURRET)) ){
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        if( !ai_patrol_traffic_adjust()){
          movetogoal( walkSpeed );
        }
      }
    }
    else{
      if( walkmove(self.angles_y, cornerSpeed) == FALSE ){
        if( !ai_patrol_traffic_adjust()){
          movetogoal( cornerSpeed );
        }
      }
    }
    self.patrolState = PATROL_WALKING;
    return;
  }
  //------------------------------------------------
  
  //ADJUST NEAR NODE - ADJUST FINAL DESTINATION
  if( distLeft > self.goalentity.ai_view * 0.75 ){
    self.tetherStatus = TETHER_SELF;
    self.tetherOrg = util_find_random_farpoint(self.goalentity.origin, self.goalentity, max(self.goalentity.ai_view*0.25,32), 24);
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
        if( !ai_patrol_traffic_adjust()){
          if(!self.legs){
            ChangeYaw();
          }
          movetogoal( walkSpeed );
        }
      }
    }
    else{
      if( walkmove(self.angles_y, cornerSpeed) == FALSE ){
        if( !ai_patrol_traffic_adjust()){
          if(!self.legs){
            ChangeYaw();
          }
          movetogoal( walkSpeed );
        }
      }
    }
    self.patrolState = PATROL_WALKING;
    return;
  }
  
  //PATROL - ARRIVING AT NODE
  if( distLeft > max(self.goalentity.ai_view*0.25,32)){
    ai_face_origin(self.tetherOrg);
    if( (self.flags & FL_TURRET) ){
      self.torsoCenter.ai_dir = vectoyaw(self.tetherOrg - self.origin);
      self.torsoCenter.attack_state = TR_YAW;
    }
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }

    if( ai_check_face_origin(self.tetherOrg, 0.85, FALSE) ){
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        if( !ai_patrol_traffic_adjust()){
          if(!self.legs){
            ChangeYaw();
          }
          movetogoal( walkSpeed );
        }
      }
    }
    else{
      if( walkmove(self.angles_y, cornerSpeed) == FALSE ){
        if( !ai_patrol_traffic_adjust()){
          if(!self.legs){
            ChangeYaw();
          }
          movetogoal( cornerSpeed );
        }
      }
    }
    self.patrolState = PATROL_ADJUST;
    return;
  }
  
  //PATROL - ARRIVED AT NODE, set pause and next node
  if(self.goalentity.pausetime > 0.0){
    self.pausetime = self.goalentity.pausetime;
    self.pausetime = max(5, self.pausetime - (self.ai_rank / 2));
    self.goalentity = self.patrolNode;
    self.patrolState = PATROL_PAUSE;
  }
  else{
    self.pausetime = 0;
    self.patrolState = PATROL_ARRIVE;
  }
  
  nextNode = self.patrolNode;
  if( self.goalentity.partNext != world ){
    //case - there's the next node
    nextNode = self.goalentity.partNext;
  }
  
  if(nextNode != self.patrolNode ){
    self.tetherStatus = TETHER_PATROL;
  }
  else{
    self.tetherStatus = TETHER_NODE;
  }
  self.patrolNode = nextNode;
  self.tetherOrg = self.patrolNode.origin;

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
  local float valu;
  
  valu = ai_check_face_origin(t.origin, ang, useTurret);
  return valu;
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
  local float contentBuffer;
  
  makevectors(self.angles);
  spot1 = self.cockpit.origin + (v_forward * 10) + (v_up * 5);
  if( targ.data_type == DATA_BLD ){
    spot2 = targ.hitOffset;
  }
  else{
    spot2 = targ.cockpit.origin;
  }
  contentBuffer = self.dphitcontentsmask;
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_DONOTENTER | DPCONTENTS_MONSTERCLIP);
  
  tracebox (spot1, targ.mins * 0.5, targ.maxs * 0.5, spot2, MOVE_NORMAL, self);
  
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


float(float moveDist, float wishSpeed, float interval) ai_move_time_calc={
  
  return 0;
};

/*
===================================================
*/

/*
  SETUP PATROL
    AI must be 1 of 2 allowable types:
      PATROL - AI must have a target set to a valid ai_node.
      or
      AREA - AI has no target, must visually find a close ai_node_tether
    
    if EITHER case fails? AI is flat-out removed via killing it.
      no wiggle room.
*/
void() ai_setup_patrol={
  local entity node;
  local entity near;
  
  //make a single call reference here, instead of in every ai_setup func.
  trigger_event( find(world, classname, "player"), self.trigOnSpawn ); //event interface
  
  //Check for spawnflag: DEBUG_MODE
  if( (self.spawnflags & DEBUG_MODE) ){
    self.ai_state_next = ST_STAND;
  }
  else{
    //AI is a patrol-type
    if( self.target || self.target != "" ){
      if( lastNode && lastNode.targetname == self.target ){
        node = lastNode;
      }
      else{
        node = find(world, targetname, self.target);
      }
      if( node ){
        self.tetherStatus = TETHER_PATROL;
        self.tetherOrg = node.origin;
        self.patrolNode = node;
        self.ai_state_next = ST_PTR;
        lastNode = node;
        if( cvar("developer") ){
          cons_logAVector(node.classname, node.origin); //debug
          cons_logAString(node.classname, node.targetname);
          cons_logAString("///////////////////", "////////////");
        }
      }
      else{
        self.deadflag = DEAD_DYING;
      }
    }
    else{
      //AI is an area-tethered type
      node = ai_node_tether_find();
      if( node ){
        self.patrolNode = node;
        self.ai_state_next = ST_THR;
        if( ai_check_node_radius(self) > 1.0 ){
           //just teleport them
           self.origin = util_find_random_farpoint(self.patrolNode.origin, self.patrolNode, max(self.patrolNode.ai_view*0.85,32), self.maxs_x);
           setorigin(self, self.origin);
        }
        if( cvar("developer") ){
          cons_logAVector(self.classname, self.origin);
          cons_logAVector(self.patrolNode.classname, self.patrolNode.origin); //debug
          cons_logAString(self.patrolNode.classname, self.patrolNode.targetname);
          cons_logAString("-------------------", "-------------");
        }
      }
      else{
        self.deadflag = DEAD_DYING;
      }
    }
  }
  if( self.ai_state_next == ST_STAND || self.deadflag != DEAD_DYING ){
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
  }
  
  if(self.deadflag == DEAD_DYING){
    //AI failed to have either a PATROL NODE or TETHER NODE, so kill it.
    if( cvar("developer") ){
      cons_logAString("///////////////", "----------");
      cons_logAVector(self.classname, self.origin); //debug
      cons_logAString(self.classname, self.vec_name);
      cons_logAString("///////////////", "^ REMOVED ^");
    }
    
    self.th_die();
    self.nextthink = time + 0.1;
  }
  else{
    if( (self.spawnflags & COLD_START) ){
      self.spawnflags = self.spawnflags - (self.spawnflags&COLD_START);
      self.nextthink = 7;
    }
    else{
      self.nextthink = 2;
    }
    self.think = ai_state_frame;
    self.nextthink = self.nextthink + time;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};



void() ai_move_node_hide={
  
};

void() ai_move_node_clear={

};

void() ai_move_node_reverse={

};