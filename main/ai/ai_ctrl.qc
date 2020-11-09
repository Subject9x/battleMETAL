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
      self.tether = TETHER_NODE;
      return TRUE;
    }
    else{
      if( self.patrolNode ){
        if( self.patrolNode.partPrev ){
          self.tetherOrg = util_find_random_farpoint(self.patrolNode.partPrev.origin, self.patrolNode.partPrev, max(self.patrolNode.partPrev.ai_view*0.15,32), 24);
          self.tether = TETHER_NODE;
        }
        else{
          self.tetherOrg = util_find_random_farpoint(self.patrolNode.origin, self.patrolNode, max(self.patrolNode.ai_view*0.15,32), 24);
          self.tether = TETHER_NODE;
          
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
    //self.ai_move_next = MOVE_STAND_FACE;
    //self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
  
  //AI DOES have a current enemy
  enemyFront = ai_check_targ_infront( self.enemy, self.ai_fov, (self.flags & FL_TURRET) );
  //distanc = ai_check_node_radius(self.enemy);
  vis = ai_check_vis(self.enemy);
  
  if( !enemyFront && otherFront ){
    if( distanc > 1.0 || vis != VIS_FRAC){
      self.enemy = other;
    }
  }
};

void(entity atk) ai_react={
  if( !(atk.flags & FL_MONSTER) && !(atk.flags & FL_CLIENT)){
    return;
  }
  
  //AI has taken friendly fire
  if( atk.faction == self.faction ){
    return;
  }
  
  if( atk == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    return;
  }

  //AI currently has target
  if( ai_check_vis(self.enemy) == VIS_FRAC ){
    if( ai_check_node_radius(self.enemy) > 1.0 ){
      return;
    }
  }
  if( ai_check_vis(self.enemy) == VIS_FRN ){
    if( ai_check_node_radius(self.enemy) <= 1.0 ){
      return;
    }
  }
  self.enemy = atk;
  self.ai_react_buffer = time + self.ai_react_time * 5;
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

void() ai_face_targ_fade={
	self.ideal_yaw = vectoyaw(self.enemy.position3 - self.origin);
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
  local vector vang, vec;
  local float dot;
  
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
  return vlen( t.origin - self.origin);
};

float( entity targ ) ai_check_vis={
  local vector spot1, spot2;
  local float contentBuffer;
  
  makevectors(self.angles);
  spot1 = self.cockpit.origin + (v_forward * 10) + (v_up * 3);
  if( targ.data_type == DATA_BLD ){
    spot2 = targ.hitOffset;
  }
  else{
    spot2 = targ.origin + '0 0 3';
  }
  contentBuffer = self.dphitcontentsmask;
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_OPAQUE | DPCONTENTS_SKY);
  
  traceline (spot1, spot2, MOVE_NORMAL, self);
  
  self.dphitcontentsmask = rint(contentBuffer);

  //case: los crossed content - ported q1
  if ( trace_inopen && trace_inwater ){
    return VIS_FAIL;  // sight line crossed contents
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
    //friend_blocker = trace_ent;
    //friend_blocker_dist = vlen(friend_blocker.origin - spot1);
    return VIS_FRN;
  }
  
  if( trace_ent.faction != self.faction && trace_ent.faction > 0){
    if(trace_ent.data_type != DATA_BLD){
      return VIS_ENEMY;
    }
  }
  
  return VIS_FAIL;
};

float() ai_attack={
  self.button0 = 1;
  return self.button0;
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
  local float nodeFail;
  
  //make a single call reference here, instead of in every ai_setup func.
  trigger_event( find(world, classname, "player"), self.trigOnSpawn ); //event interface
  
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
  
  //Check for spawnflag: DEBUG_MODE
  if( (self.spawnflags & DEBUG_MODE) ){
    self.ai_state_next = ST_STAND;
  }
  else{
    //validate the proposed tether type coming in from AI
    if( self.tether ){
      if( self.tether == TETHER_NODE ){
        //AI wants to be anchored to a spot.
        if( self.target || self.target != "" ){
          //AI is an area-tethered type
          node = find(world, targetname, self.target);
        }
        if( node != world ){
          self.tether = TETHER_NODE;
          self.patrolNode = node;
          if( cvar("developer") ){
            cons_logAVector(self.classname, self.origin);
            cons_logAVector(self.patrolNode.classname, self.patrolNode.origin); //debug
            cons_logAString(self.patrolNode.classname, self.patrolNode.targetname);
            cons_logAString("-------------------", "-------------");
          }
        }
        else{
          nodeFail = TRUE;
        }
      }
      else if( self.tether == TETHER_PATROL ){
        //AI wants to run a patrol route.
        if( self.target || self.target != "" ){
          if( lastNode && lastNode.targetname == self.target ){
            node = lastNode;
          }
          else{
            node = find(world, targetname, self.target);
          }
          if( node != world ){
            self.tetherOrg = node.origin;
            self.patrolNode = node;
            lastNode = node;
            if( cvar("developer") ){
              cons_logAVector(node.classname, node.origin); //debug
              cons_logAString(node.classname, node.targetname);
              cons_logAString("///////////////////", "////////////");
            }
          }
          else{
            nodeFail = TRUE;
          }
        }
      }
      else if( self.tether == TETHER_SELF ){
        self.tetherOrg = self.origin;
      }
    }
    else{
      self.ai_state_next = ST_STAND;
    }
  }
  
  if( nodeFail ){
    self.tether = TETHER_NONE;
    self.patrolNode = world;
    self.goalentity = world;
  }
  
  if( (self.spawnflags & COLD_START) ){
    self.spawnflags = self.spawnflags - (self.spawnflags&COLD_START);
    self.nextthink = (random() * 0.5) + 7;
  }
  else{
    self.nextthink = 1.0 + (random() * 2);
  }

  if( self.ai_set_state ){
    self.think = self.ai_set_state;
  }
  else{
    self.think = ai_state_lurker_frame;
  }

  ai_nodegraph_clear_path();
  self.ai_timer_tracepath = time + self.ai_timer_tracepath;
  
  self.nextthink = self.nextthink + time;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
};