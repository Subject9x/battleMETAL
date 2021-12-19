/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: 
  Main Impl for AI API
*/

/*
  Go through spawn flags
  Check Game Mode and Difficulty Skill
  remove AI if they're flagged to not be in a category; 
*/
float() ai_can_spawn={

  if( self.netname ){
    self.netname = strzone(self.netname);
  }

  if( self.nextVecChoice < 1 ){
    return FALSE;
  }
  
  if( (skill == 0) && (self.spawnflags & NO_NOVICE) ){
    return FALSE;
  }
  if( (skill == 1) && (self.spawnflags & NO_REGULAR) ){
    return FALSE;
  }
  if( (skill == 2) && (self.spawnflags & NO_VETERAN) ){
    return FALSE;
  }
  if( (skill == 3) && (self.spawnflags & NO_ELITE) ){
    return FALSE;
  }
  
  if( (self.spawnflags & NO_CAMPAIGN) ){
    if( cvar("gamemode") == GAMEMODE_CAMPAIGN ){
      return FALSE;
    }
  }
  
  if( (self.spawnflags & NO_COOP) ){
    if( cvar("gamemode") == GAMEMODE_COOP ){
      return FALSE;
    }
  }

  if( (self.spawnflags & NO_DM) ){
    if( cvar("gamemode") == GAMEMODE_DM  ){
      return FALSE;
     }
  }
  
  if( (self.spawnflags & NO_TDM) ){
    if( cvar("gamemode") == GAMEMODE_TEAMDM ){
      return FALSE;
    }
  }

  return TRUE;
};

void( entity t ) ai_call_for_help={
  local float allies;
  local entity ally;
  
  if( time < self.helpTime ){
    return;
  }
  self.helpTime = time + self.helpTimeDelay;
  
  allies = 0;
  
  if((t.flags&FL_CLIENT)){
    ai_sfx_help();
  }
  for(ally=nextent(world); ally != world; ally = nextent(ally)){
    if( !ai_valid_target(ally) ){
      continue;
    }
    if( !(ally.flags & FL_MONSTER) ){
      continue;
    }
    if( (ally.flags & FL_DISARMED) ){
      continue;
    }
    if( ally.faction != self.faction ){
      continue;
    }
    if( vlen( ally.origin - self.origin ) > self.ai_view ){
      continue;
    }
    if(alarm_ent != world){
      if( ally == alarm_ent ){
        continue;
      }
    }
    ai_give_target( ally, t, ((t.flags&FL_CLIENT) && !(ally.enemy.flags & FL_CLIENT)));
    allies = allies + 1;
  }
}; 

float(entity t) ai_valid_target={
  if( !t ){
    return FALSE;
  }
  if( t != self ){
    if( (t.flags & (FL_UNIT|FL_MONSTER)) && (t.deadflag == DEAD_NO) ){
      return t.canTarget;
    }
  }
  return FALSE;
};

entity( float radiius) ai_find_friend={
  local entity ally, friend;
  local float dist, rad;
  
  rad = radiius;
  
  for(ally = findchainfloat(faction,self.faction); ally != world; ally = ally.chain){
    if( !ai_valid_target(ally) ){
      continue;
    }
    dist = vlen( ally.origin - self.origin );
    if( dist > rad ){
      continue;
    }
    rad = dist;
    friend = ally;
  }
  return friend;
};

void( entity t) ai_alert_close={
  
  local entity ally;
  local float rng;
  local float fog;
  local float fogLen;
  local float alertMax;
  
  if( alarm_ent == world ){
    alarm_ent = self;
  }
  
  if((t.flags&FL_CLIENT)){
    ai_sfx_help();
  }
  if(!self.ai_view || self.ai_view < 1){
    self.ai_view = AI_RANGE_M;
  }
  
  rng =  self.ai_view;
  if( self.fog_alpha && self.fog_dist_x <= AI_RANGE_L){
    fogLen = self.fog_dist_y - self.fog_dist_x;
    fogLen = max(self.ai_view, fogLen);
   // cons_logAFloat("fogLen", fogLen); //debug
    fog = bound(0.1, self.fog_alpha + self.fog_density / 2, 1.0);
    fog = fog * fogLen;
    rng = max(256, self.ai_view - fogLen);
    //cons_logAFloat("fog range", rng); //debug
  }
  
  alertMax = self.ai_rank + 2;
  for(ally = findradius(self.origin, rng); ally != world; ally = ally.chain){
    if( ally.faction != self.faction ){
      continue;
    }
    if( !ai_valid_target(ally) ){
      continue;
    }
    ai_give_target( ally, t, ((t.flags&FL_CLIENT) && !(ally.enemy.flags & FL_CLIENT)));
  }      
  if(alarm_ent == self){
    alarm_ent = world;
  }
};


float() ai_find_target_visual={
  local entity targ, found;
  local float rng, fog, fogLen, ndist;

  if( ai_valid_target(self.enemy) ){
    return FALSE;
  }
    
  rng =  self.ai_view;
  if( self.fog_alpha && self.fog_dist_x <= AI_RANGE_L){
    fogLen = self.fog_dist_y - self.fog_dist_x;
    fogLen = max(self.ai_view, fogLen);
    //cons_logAFloat("fogLen", fogLen); //debug
    fog = bound(0.1, self.fog_alpha + self.fog_density / 2, 1.0);
    fog = fog * fogLen;
    rng = max(256, self.ai_view - fogLen);
    //cons_logAFloat("fog range", rng); //debug
  }
  selfSensorOrg_x = self.origin_x;
  selfSensorOrg_y = self.origin_y;
  selfSensorOrg_z = 0;
  
  for(targ = findradius(self.origin, rng); targ != world; targ = targ.chain){ 
    if( (targ.flags & FL_NOTARGET) ){
      continue;
    }
    if( targ.faction == self.faction ){
      continue;
    }
    if( !ai_valid_target(targ) ){
      continue;
    }
    enemySensorOrg_x = targ.origin_x;
    enemySensorOrg_y = targ.origin_y;
    enemySensorOrg_z = 0;
    ndist = vlen(enemySensorOrg - selfSensorOrg);
    if(ndist > rng){
      continue;
    }
    if( ai_check_vis(targ) != VIS_FRAC ){
      continue;
    }
    if( (self.flags & FL_TURRET) ){
      if( !ai_check_targ_infront( targ, self.ai_fov, TRUE)){
        continue;
      }
    }
    else{
      if( !ai_check_face(targ, self.ai_fov, FALSE) ){
        continue;
      }
    }
    rng = ndist;
    found = targ;
  }

  if( found != world ){
    if( (self.flags & FL_DISARMED) ){
      if((found.flags&FL_CLIENT)){
        ai_sfx_help();
      }
      ai_alert_close(found);
      return FALSE;
    }
    else{
      self.enemy = found;
      ai_sfx_spotted();
      return TRUE;
    }
  }
  return FALSE;
};

float() ai_find_target_radar={
  if( ai_valid_target(self.enemy) ){
    return FALSE;
  }
  local entity targ, found;
  local float rng, ndist;
  
  selfSensorOrg_x = self.origin_x;
  selfSensorOrg_y = self.origin_y;
  selfSensorOrg_z = 0;
  
  rng = self.ai_view;
  for(targ = findradius(self.origin, self.ai_view); targ != world; targ = targ.chain){
    if( (targ.flags & FL_NOTARGET) ){
      continue;
    }
    if( !ai_valid_target(targ) ){
      continue;
    }
    if( targ.faction == self.faction ){
      continue;
    }
    enemySensorOrg_x = targ.origin_x;
    enemySensorOrg_y = targ.origin_y;
    enemySensorOrg_z = 0;
    ndist = vlen(enemySensorOrg - selfSensorOrg);
    if( ndist > rng ){
      continue;
    }
    if( (targ.flags & FL_CLIENT) && (targ.stat_rdr_mode == FALSE) ){
      if( ndist > (rng / 2) ){
        continue;
      }
    }
    if( (ai_check_vis(targ) != VIS_FRAC) && (ai_check_vis(targ) != VIS_FRN)){
      continue;
    }
    rng = ndist;
    found = targ;
  }
  if( found ){
    if( (self.flags & FL_DISARMED) ){
      if((found.flags&FL_CLIENT)){
        ai_sfx_help();
      }
      ai_alert_close(found);
      return FALSE;
    }
    else{
      self.enemy = found;
      ai_sfx_spotted();
      return TRUE;
    }
  }
  return FALSE;
};

void( entity ally, entity targ, float override ) ai_give_target={
  local entity this;
  
  this = self;
  //validTarg = ai_valid_target(ally.enemy);  note: every other func calling this one already involes ai_valid_target()
  self = ally;
  //providing clause where ally has no target
    if( override ){
      self.enemy = targ;
    }
    else{
      if( self.th_pain ){
        self.th_pain(targ);
      }
    }
    if( self.enemy == targ ){
      if( (targ.flags & FL_CLIENT) ){
        ai_sfx_roger();
      }
    }
  self = this;
};

void() ai_unit_make_trigger={
  self.spawnflags = self.spawnflags - TRIGGER_ME;
  self.use = SUB_Null;  //triggered
  self.think = self.unit_ini;
  self.nextthink = time + self.wait + (random() * 1);
  self.unit_ini = SUB_Null;
};

/*
  Inspired by the original SUB_CalcMoved
    Unit gives a requested destination, and a wishspeed.
    
    Algo then runs a tracebox to make sure the unit will fit and arrive at the point.
    Then, as part of some 'rounding' effort - we find a point that's actually
      endpoint - AI bbox size. 
      
    This comes out to kinda always leave a unit-sized gap after the AI moves, like a 
    primitive avoidance system. By increasing the gaps of units during moves, this
    should free up any given volume, allowing more bots to move easier.
*/
float(vector destOrg, float wishSpeed) ai_calc_move={
  local vector distDiff;
  local float len;
  local float travel;
  local vector tMins;
  local vector tMaxs;
  
  distDiff = destOrg - self.origin;
  len = vlen (distDiff);
  tMaxs = self.maxs;
  tMins = self.mins;
  tMins_z = tMins_z * 0.75; //adjust for slope
  
  tracebox(self.origin + (v_forward * (tMaxs_x / 2)), tMins, tMaxs, destOrg + (v_forward * (tMins_x / 2)), MOVE_NORMAL, self);
  
  if( trace_fraction <= 0.1 ){
    return 0;
  }
  distDiff = trace_endpos + (v_forward * (tMins_x * 2));
  len = vlen(distDiff - self.origin);
  
  // divide by speed to get time to reach dest
  travel = len / wishSpeed;
  travel = travel / 35; //AI runs at about time + 0.04 so adjust travel time 
  
  return travel * 0.9;  
};

/*
  DEPRECATED - release v1.0.0
  WHEN: AI are set to TETHER_PATROL, they can query their patrol nodes for better positioning data.
    This checks to see if patrolNode.partNext or patrolNode.partPrev are CLOSER to the desired target.
    If they are, then the AI executes MOVE_NODE_TACTICAL to get there.
*/
/*entity(entity targ) ai_node_to_target={
  local entity hold;
  local entity found;
  local float dist;
  local float distComp;
  
  dist = ai_check_node_radius(targ);
  
  if(self.patrolNode.partNext){
    hold = self.patrolNode;
    self.patrolNode = hold.partNext;
      distComp = ai_check_node_radius(targ);
    self.patrolNode = hold;
    if( distComp <= dist ){
      found = self.patrolNode.partNext;
    }
  }
  if( !found ){
    if(self.patrolNode.partPrev){
      hold = self.patrolNode;
      self.patrolNode = hold.partPrev;
        distComp = ai_check_node_radius(targ);
      self.patrolNode = hold;
      if( distComp <= dist ){
        found = self.patrolNode.partPrev;
      }
    }
  }
  if( !found ){
    found = self.patrolNode;
  }
  return found;
};*/

/*
  Simply moves up/down the AI's patrolNode chain (if possible)
*/
entity(float checkDir) ai_get_next_node={
  local entity foundNode;
  
  foundNode = world;
  if( checkDir ){
    if( self.patrolNode.partNext ){
      foundNode = self.patrolNode.partNext;
    }
  }
  else{
    if( self.patrolNode.partPrev ){
      foundNode = self.patrolNode.partPrev;
    }
  }
  return foundNode;
};

//OLD NODE CODE=========================================

/*
  DEPRECATED - release v1.0.0
  Check if entity <toCheck> is outside of 
  
  AI's current patrolNode.ai_view radius.
  
  returns a percentage of distance to node.
  
  a value > 1 is out of node radius
*/
/*float(entity toCheck) ai_check_node_radius={
  local float distance;
  distance = vlen(toCheck.origin - self.patrolNode.origin);
  if( self.patrolNode.ai_view != 0 ){
    distance = max(distance / self.patrolNode.ai_view, 0.01);
  }
  else{
    distance = max(distance / AI_RANGE_S, 0.01);
  }
  return distance;
};*/

/*
  DEPRECATED - release v1.0.0
  A soft-wrapper for ai_check_node_radius();
    this converts self.stat_trg_dst (target distance to self)
    in a percentage of node radius.
*/
/*float() ai_check_node_radius_targdist={
  local float distance;
  if( self.patrolNode.ai_view != 0 ){
    distance = max(self.stat_trg_dist / self.patrolNode.ai_view, 0.01);
  }
  else{
    distance = 1.0;
  }
  return distance;
};*/

/*
  Attempts to find the closest allowable <ai_node_tether> entity.
*/
entity() ai_node_tether_find={
  local entity findNode;
  local entity found;
  local float dist;
  local float testDist;
  local vector tMins;
  local vector ang;
  dist = AI_RANGE_L;
  
  tMins = self.mins;
  tMins_z = tMins_z * 0.5;
  //first query existing nodes to see if a tether exists nearest the AI.
  for(findNode = nextent(world); findNode != world; findNode = nextent(findNode)){
    if( findNode.classname != "ai_node_tether" ){
      continue;
    }
    ang = vectoangles(findNode.origin - (self.origin + '0 0 5'));
    if( ang_x <= 67 || ang_x >= 275) {
      //tether nodes need to be on relatively flat planes because a bot cannot climb a wall or slope to reach a tether node.
      testDist = vlen(findNode.origin - (self.origin + '0 0 5'));
      if( testDist <= dist ){
        traceline( self.origin, findNode.origin, MOVE_NORMAL, self);
        if( trace_fraction == 1 ){
          dist = testDist;
          found = findNode;
        }
        else{
          if( (trace_ent.flags & FL_UNIT) ){
            if( trace_ent.patrolNode && !trace_ent.patrolNode.target ){
              dist = testDist;
              found = findNode;
            }
            else{
              tracebox((trace_ent.origin + '0 0 5'), tMins, self.maxs * 0.75, findNode.origin, MOVE_NORMAL, self);
              if( trace_fraction == 1 ){
                dist = testDist;
                found = findNode;
              }
            }
          }
        }
      }
    }
  }
  return found;
};


/*
  Checks end-of-think change values for sending data to the client
*/
void() ai_frame_net_send={
  
  //physical move check
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  }
  
  //angle change
  if( self.last_angle != self.angles ){
    self.SendFlags = self.SendFlags | SENDFLAG_ANGLE;
    self.last_angle = self.angles;
  }
  
  //turret angles check
  if( (self.flags & FL_TURRET) ){
    if( self.torsoCenter.last_angle != self.torsoCenter.angles ){
      self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
    }
    self.torsoCenter.last_angle = self.torsoCenter.angles;
  }
  
  //target check
  if( self.oldenemy != self.enemy ){
    self.SendFlags = self.SendFlags | SENDFLAG_TARGET;
    self.oldenemy = self.enemy;
  }
  
  //send shield delta
  if( self.last_shield != self.stat_client_shield ){
    self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
    self.last_shield = self.stat_client_shield;
  }
  
  //attack delta
  if( self.attackFlag != 0 ){
    self.SendFlags = self.SendFlags | SENDFLAG_ATTACK;
  }
  
  if( self.last_crit != self.critBits ){
    self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
    self.last_crit = self.critBits;
  }
  
  if( self.last_burn != self.burnBits ){
    self.SendFlags = self.SendFlags | SENDFLAG_BURN;
    self.last_burn = self.burnBits;
  }
  
};

/*
  See sv_playermovement.
  
  This mirrors player slope friction speed checks.
*/
float(float wishAngl, float wishspeed) ai_check_slope={
  local vector wishDir;
  local vector stepOne, stepTwo, stepAngles;
  local float outSpeed;
//actual terrain test
  wishDir = '0 0 0';
  wishDir_y = wishAngl;
  makevectors(wishDir);
  traceline(self.origin, self.origin + (v_forward * -128) + (v_up * -1024), MOVE_NORMAL, self);
  stepOne = trace_endpos;
  
  traceline(self.origin, self.origin + (v_forward * 256) + (v_up * -1024), MOVE_NORMAL, self);
  stepTwo = trace_endpos;
  
  stepAngles = vectoangles(stepTwo - stepOne);
  if( stepAngles_x > 1 && stepAngles_x <= 90 ) {
    //walking up-hill.
    stepAngles = vectoangles((stepTwo + (v_up * 2)) - stepOne);  //relish factor
    outSpeed = wishspeed * (1.0 - (stepAngles_x / 90));
  }
  else if( stepAngles_x > 90 ){
    //going dowhill
    outSpeed = wishspeed + (wishspeed * (1.0 - (stepAngles_x / 360)));
  }
  else{
    outSpeed = wishspeed;
  }
  outSpeed = max(0.1, outSpeed, wishspeed * 0.1);
  return outSpeed;
};


/*
  Very similar to ext_world.world_nodegraph_export_edgelink()
  
  this bad boi scans the underlying terrain in addition to checking normal tracelines for possible move,
    and for finding the closest valid node.
*/
float( vector source, vector trgdst ) ai_check_terrain_move={
  local vector edgeAngle;
  local float edgeLen;
  local float edgeLenquant;
  local float edgeLenItr;
  
  local vector edgeSegA;
  local vector edgeSegB;
  
  local vector trEdgeApos;
  local vector trEdgeBpos;
  
  local vector trEdgeAngl;
  
  local float edgeCheck;
  
  traceline( source,trgdst, FALSE, self );
  
  if( trace_fraction == 1.0 ){
    edgeAngle = vectoangles(trgdst - source);
    if( edgeAngle_x < NODEGRAPH_EDGE_ANGLE_MAX ){
      edgeAngle_x = 360 - edgeAngle_x;  //makevectors is not the same as vectoangles, it is not pitch-corrected
    }
    if( edgeAngle_x > NODEGRAPH_EDGE_ANGLE_MIN && edgeAngle_x < NODEGRAPH_EDGE_ANGLE_MAX){
      //rule out steep inclines right away.
      //cons_logAString(ftos(node.data_idx), strcat("fail ", ftos(targNode.data_idx), " pitch ", ftos(edgeAngle_x)));//debug
      return FALSE;
    }
    
    //clear Los, get more granular.
    edgeLen = vlen(trgdst - source);
    edgeLenquant = ceil(edgeLen / (NODEGRAPH_EDGE_GRID * 1.5)); //inflate the edge grid * 2; we don't need that much precision.
    //now run the terrain poller
    edgeSegA = source;
    makevectors(edgeAngle);
    edgeCheck = TRUE;
    for(edgeLenItr = 0; edgeLenItr < edgeLenquant; edgeLenItr = edgeLenItr + 1){
      if( !edgeCheck ){
        continue;
      }
      edgeSegB = edgeSegA + (v_forward * (NODEGRAPH_EDGE_GRID * 1.5));
      
      traceline(edgeSegA, edgeSegA + (v_up * -512), TRUE, self);
      trEdgeApos = trace_endpos;
      
      traceline(edgeSegB, edgeSegB + (v_up * -512), TRUE, self);
      trEdgeBpos = trace_endpos;
      
      //trailparticles(world, particleeffectnum("TE_LAS_RAIL"), edgeSegA, trEdgeApos);  //debug
      //trailparticles(world, particleeffectnum("TE_LAS_RAIL"), edgeSegB, trEdgeBpos);  //debug
      
      trEdgeAngl = vectoangles(trEdgeBpos - trEdgeApos);
      /*if(node.data_idx == NODEGRAPH_DBG_ID1 && targNode.data_idx == NODEGRAPH_DBG_ID2){
        trailparticles(world, particleeffectnum("TE_ESR_RAIL"), node.origin, targNode.origin);  //debug
        trailparticles(world, particleeffectnum("TE_REPAIR_RAIL"), edgeSegA, trEdgeApos);  //debug
        trailparticles(world, particleeffectnum("TE_REPAIR_RAIL"), edgeSegB, trEdgeBpos);  //debug
        trailparticles(world, particleeffectnum("TE_LAS_RAIL"), trEdgeApos, trEdgeBpos);  //debug
        cons_logAFloat("trEdgeAngl_x", trEdgeAngl_x);  //debug
      }*/
      
      if( trEdgeAngl_x > NODEGRAPH_EDGE_ANGLE_MIN && trEdgeAngl_x < NODEGRAPH_EDGE_ANGLE_MAX){
        //cons_logAString(ftos(node.data_idx), strcat("fail ", ftos(targNode.data_idx), " pitch ", ftos(trEdgeAngl_x), "| seg ", ftos(edgeLenItr)));//debug
        edgeCheck = FALSE;
      }
      edgeSegA = edgeSegB;
    }
    return edgeCheck;
  }
  else{
    //no proper Los based on 
    //self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP | DPCONTENTS_BODY);
    //cons_logAString(ftos(node.data_idx), strcat(ftos(targNode.data_idx), " fail trace fraction ", ftos(trace_fraction)));//debug
    return FALSE;
  }
};