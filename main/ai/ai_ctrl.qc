/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
rebuild: 07/12/2020
Overview: 
  AI Controller functions
*/

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
    self.ai_react_buffer = time + (self.ai_react_time * 2);
    return;
  }
  self.ai_react_buffer = time + (self.ai_react_time * 1.5);
  
  //AI lacks an enemy at the moment.
  otherFront = ai_check_targ_infront( other, self.ai_fov, (self.flags & FL_TURRET) );
  if(!self.enemy){
    if(other.faction != self.faction){
      self.enemy = other;
    }
    else if(other.enemy){
      self.enemy = other.enemy;
    }
    return;
  }
  
  //AI DOES have a current enemy
  enemyFront = ai_check_targ_infront( self.enemy, self.ai_fov, (self.flags & FL_TURRET) );
  vis = ai_check_vis(self.enemy);
  
  if( !enemyFront && otherFront ){
    if( distanc > 1.0 || vis != VIS_FRAC){
      self.enemy = other;
    }
  }
};

/*
  Generic th_pain reaction filter.
*/
void(entity atk) ai_react={
  if( !(atk.flags & FL_UNIT) ){
    return;
  }
  
  //AI has taken friendly fire
  if( atk.faction == self.faction ){
    return;
  }
  
  if( atk == self.enemy ){
    self.ai_react_buffer = time + (self.ai_react_time * 1);
    return;
  }

  if( atk.data_type == DATA_BLD && self.enemy.data_type != DATA_BLD ){
    //ignore turrets because they're lower priority.
    self.ai_react_buffer = time + (self.ai_react_time * 2);
    return;
  }

  //AI currently has target
  if( ai_valid_target(self.enemy) ){
    if( atk.data_type == DATA_BLD && self.enemy.data_type != DATA_BLD ){
      //buildings are always low priority.
      self.ai_react_buffer = time + (self.ai_react_time * 2);
      return;
    }
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !ai_check_targ_infront(self.enemy, self.ai_fov, (self.flags & FL_TURRET)) ){
        if( !(atk.flags & FL_CLIENT) ){
          self.ai_react_buffer = time + (self.ai_react_time * 2);
          return;
        }
      }
    }
    else{
      if( ai_check_vis(self.enemy) != VIS_FAIL || !ai_check_targ_infront(self.enemy, self.ai_fov, (self.flags & FL_TURRET)) ){
        self.ai_react_buffer = time + (self.ai_react_time * 1);
        return;
      }
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

float() ai_check_pause={
  if( (time - self.ai_timer_breathe) >= self.ai_pauseTime_check ){
    if( (random() * 1.0) >= self.ai_pauseTime_chance ){
      return TRUE;
    }
  }
  return FALSE;
};

void() ai_face_targ={
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

void() ai_face_targ_fade={
	self.ideal_yaw = vectoyaw(self.ai_fadePos - self.origin);
	ChangeYaw ();
};


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
    vang = self.torC_angl;
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
    vang = self.torC_angl;
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

/*
  The main Line of Sight (LoS) calculator for AI.
    returns an ENUM
      VIS_FRAC    comes from trace_fraction == 1
      VIS_FAIL    trace ended in contents, or water.
      VIS_FRN     trace hit a FRIENDLY bbox.
      VIS_ENEMY   trace hit a SECOND enemy bbox.
*/
float( entity targ ) ai_check_vis={
  local vector spot1, spot2;
  
  makevectors(self.angles);
  spot1 = self.cameraOrigin + (v_forward * 10) + (v_up * 3);
  if( targ.data_type == DATA_BLD ){
    spot2 = targ.hitOffset;
  }
  else{
    spot2 = targ.origin + [0, 0, targ.maxs_z * 0.5];
  }

  self.dphitcontentsmask = 0 | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_OPAQUE | DPCONTENTS_SKY);
  
  //traceline (spot1, spot2, , self);
  traceline( [targ.absmax_x, targ.absmax_y, targ.origin_z + targ.maxs_z/2], spot1, MOVE_NORMAL, self);
  VIS_FRAC1 = trace_fraction;
  VIS_ENT1 = trace_ent;

  traceline( [targ.absmax_x, targ.absmin_y, targ.origin_z + targ.maxs_z/2], spot1, MOVE_NORMAL, self);
  VIS_FRAC2 = trace_fraction;
  VIS_ENT2 = trace_ent;

  traceline( [targ.absmin_x, targ.absmin_y, targ.origin_z + targ.maxs_z/2], spot1, MOVE_NORMAL, self);
  VIS_FRAC3 = trace_fraction;
  VIS_ENT3 = trace_ent;

  traceline( [targ.absmin_x, targ.absmax_y, targ.origin_z + targ.maxs_z/2], spot1, MOVE_NORMAL, self);
  VIS_FRAC4 = trace_fraction;
  VIS_ENT4 = trace_ent;

  self.dphitcontentsmask = 0;

  if( VIS_ENT1 == world && VIS_ENT2 == world  && VIS_ENT3 == world  && VIS_ENT4 == world ){
    return VIS_FAIL;  // sight line crossed contents
  }

  if( VIS_FRAC1 < 0.9 && VIS_FRAC2 < 0.9  && VIS_FRAC3 < 0.9  && VIS_FRAC4 < 0.9 ){
    return VIS_FAIL;  // sight line crossed contents
  }

  //case: los crossed content - ported q1
  // if ( trace_inopen && trace_inwater ){
  //   return VIS_FAIL;  // sight line crossed contents
  // }

  //case: los hit desired target
  // if( trace_ent == targ ){
  //   return VIS_FRAC;
  // }
  
  //case: los length is 1.0, ie a clear line
  // if ( trace_fraction >= 1.0 ){
  //   return VIS_FRAC;
  // }
  
  //case: los hit a friendly entity, who is blocking los
  // if( trace_ent.faction == self.faction ){
  //   return VIS_FRN;
  // }
  
  // if( trace_ent.faction != self.faction && trace_ent.faction > 0){
  //   if(trace_ent.data_type != DATA_BLD){
  //     return VIS_ENEMY;
  //   }
  // }
  
  return VIS_FRAC;
};

/*
  Triggers the AI to try an attack next frame, this is THE func to make an AI fire at its target.
*/
float() ai_attack={
  self.button0 = 1;
  return self.button0;
};


/*
  Get flat distance from an origin to a destination. we discard Z
  because AI units vary in their total bbox height - using full coords means
  that some AI could never 'reach' a node unless there were additional hit-box distance
  calculations.
*/
float( vector testA, vector testB ) ai_check_dist_node={
  local float testVal;
  
  local vector flatVecA;
  local vector flatVecB;
  
  flatVecA_x = testA_x;
  flatVecA_y = testA_y;
  flatVecA_z = 0;
  
  flatVecB_x = testB_x;
  flatVecB_y = testB_y;
  flatVecB_z = 0;
  
  testVal = vlen( flatVecB - flatVecA );
  
  return testVal;
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
  local entity entFindTarget;
  local float nodeFail;
  
  //make a single call reference here, instead of in every ai_setup func.
  trigger_event( find(world, classname, "player"), self.trigOnSpawn ); //event interface
  
  if( (self.spawnflags & NO_DROP) ){
    self.flags = self.flags - (self.flags & FL_ONGROUND);
  }
  else{
    droptofloor();
  }
  makevectors(self.angles);
  if( (self.flags & FL_TURRET) ){
    self.torC_org = self.origin + (v_up*self.torC_compOffset_y)+(v_right*self.torC_compOffset_x)+(v_forward*self.torC_compOffset_z);
  }
  if( self.legs_hp ){
    self.legs_org = self.origin + (v_up*self.legs_compOffset_y)+(v_right*self.legs_compOffset_x)+(v_forward*self.legs_compOffset_z);
  }
  //Check for spawnflag: DEBUG_MODE
  if( (self.spawnflags & DEBUG_MODE) ){
    nodeFail = TRUE;
  }
  else{
    //validate the proposed tether type coming in from AI
    //auto-validate so we don't have to set much in the editor.
    if( self.target ){
      entFindTarget = find(world, targetname, self.target);
      if( entFindTarget.classname == "ai_node" ){
        //AI wants to run a patrol route.
        if( lastNode && lastNode.targetname == self.target ){
          entFindTarget = lastNode;
        }
        self.tether = TETHER_PATROL;
        self.patrolNode = entFindTarget;
        self.tetherOrg = entFindTarget.origin;
        lastNode = entFindTarget;
        if( cvar("developer") > 1){
          cons_logAVector(entFindTarget.classname, entFindTarget.origin); //debug
          cons_logAString(entFindTarget.classname, entFindTarget.targetname);
          cons_logAString("///////////////////", "////////////");
        }
      }
      else if( entFindTarget.classname == "ai_node_tether" ){
        self.tether = TETHER_NODE;
        self.patrolNode = entFindTarget;
        self.tetherOrg = entFindTarget.origin;
        if( cvar("developer") > 1 ){
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
    else{
      nodeFail = TRUE;
    }
  }
  
  ai_nodegraph_clear_path();
  ai_nodegraph_mark_start();
  
  if( nodeFail ){
    self.tether = TETHER_NONE;
    self.patrolNode = world;
    self.goalentity = world;
  }
  
  if( (self.spawnflags & COLD_START) ){
    self.spawnflags = self.spawnflags - (self.spawnflags & COLD_START);
    self.nextthink = (random() * 0.5) + 7;
  }
  else if(self.powerup){
    self.nextthink = self.powerup + (random() * 1);
  }
  else{
    self.nextthink = 1.0 + (random() * 1);
  }
  
  if( self.ai_set_state ){
    self.think = self.ai_set_state;
  }
  else{
    self.think = ai_state_lurker_frame; //default
  }
  
  self.ai_timer_tracepath = time + 0.1;
  
  self.nextthink = self.nextthink + time;
  self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
};


//holder-think to make sure deadflag propagates 
void() ai_tank_dead_frame={
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};


/*
  Mech corpse optimization:
    CSQC + SendEnt violates server-side culling, which works against us when doing cosmetic things
    like corpses. So all mechs are reduced to a fun smoking pair of legs, and are copied into a server-only ent.
*/

void() ai_wreck_mech_th={
  
  local vector v;
  
  v = self.origin + [0,0, self.maxs_z + 5] + WeatherDominator.wind;
  pointparticles( particleeffectnum("TE_WRECK_SMOKE"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
  
  if(time > self.ai_timer_breathe){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
  else{
    self.think = ai_wreck_mech_th;
    self.nextthink = time + (random() * 0.5);
  } 
};

entity() ai_wreck_mech={
  local entity corpse;
  
  corpse = spawn();
  if(corpse){
    corpse.vec_size = self.vec_size;
    corpse.skin = 3;
    setmodel(corpse, self.legs_mdl);
    setsize(corpse, corpse.mins, corpse.maxs);
    setorigin(corpse, self.legs_org);
    
    corpse.angles = self.legs_angl;
    
    corpse.movetype = MOVETYPE_NONE;
    corpse.solid = SOLID_NOT;
    corpse.effects = corpse.effects | EF_LOWPRECISION;
    
    corpse.think = ai_wreck_mech_th;
    corpse.nextthink = time + 0.1;
    
    corpse.ai_timer_breathe = time + 600;
    return corpse;
  }
  return world;
};


/*
  rolled together all the flying code to a one-off call.
  this should be made everytime a flyer makes an engine-based move.
  
  DEPRECATED - release version - Roohr
*/
/*void( float alt_low, float alt_max) ai_fly_update={
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
}*/

/*
  DEPRECATED - release v1.0.0
  Teleport when blocked.
  Simple garbage-collect, place AI either
    NEAR closest ai_node_tether
    OR if they're on a path,
    their last path.
  
  ONLY if the player is far away and obscured!
*/
/*float() ai_blocked_teleport={
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
};*/