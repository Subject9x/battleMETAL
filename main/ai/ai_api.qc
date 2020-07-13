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
  ai_sfx_help();
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
    ai_give_target( ally, t, (self.ai_rank <= ally.ai_rank) );
    allies = allies + 1;
  }
  
  if( self.th_pain ){
    self.th_pain( t );
  }
}; 

float(entity t) ai_valid_target={  
  if( t != self ){
    if( (t.flags & (FL_UNIT|FL_MONSTER)) && (t.deadflag == DEAD_NO) ){
      return TRUE;
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
  ai_sfx_help();
  for(ally = findradius(self.origin, self.ai_view); ally != world; ally = ally.chain){
    if( ally.faction != self.faction ){
      continue;
    }
    if( !ai_valid_target(ally) ){
      continue;
    }
    ai_give_target( ally, t, (self.ai_rank >= ally.ai_rank) );
  }
};

/*
  ai_find_friend() but we look for the friend furthest away.
*/
entity( float startSmallRadius ) ai_find_friend_farthest={
  local entity ally, friend;
  local float dist, rad;
  
  rad = startSmallRadius;

  for(ally=findchainfloat(faction, self.faction); ally != world; ally = ally.chain){
    if( !ai_valid_target(ally) ){
      continue;
    }
    //oh and the potential friend needs to offer something in protection.
    if( (ally.flags & FL_DISARMED) ){
      continue;
    }
    dist = vlen( ally.origin - self.origin );
    if( dist < rad ){
      continue;
    }
    rad = dist;
    friend = ally;
  }
  return friend;
};

float() ai_find_target_visual={
  local entity targ, found;
  local entity ally; 
  local float rng, fog, fogLen, ndist;

  if( ai_valid_target(self.enemy) ){
    return FALSE;
  }
    
  rng =  self.ai_view;
  if( self.fog_alpha ){
    fogLen = self.fog_dist_y - self.fog_dist_x;
    fog = self.fog_alpha * self.fog_density;
    fog = fog * fogLen;
    rng = self.ai_view - fogLen;
    if( rng < AI_RANGE_M ){
      rng = AI_RANGE_M;
    }
    rng = rng + fog;
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
    if( ai_check_vis(targ) != VIS_FRAC && ai_check_vis(targ) != VIS_FRN ){
      continue;
    }
    if( (self.flags & FL_TURRET) ){
      if( !ai_check_targ_infront( targ, self.ai_fov, TRUE)){
        continue;
      }
    }
    else{
      if( ai_check_face(targ, self.ai_fov, (self.flags&FL_TURRET)) == FALSE){
        continue;
      }
    }
    rng = ndist;
    found = targ;
  }

  if( found != world ){
    if( (self.flags & FL_DISARMED) ){
      if( self.stat_rdr_mode ){       
        ai_sfx_help();
        ally = ai_find_friend( self.ai_view );
        if( ally ){
          ai_give_target( ally, found, (ally.ai_rank <= self.ai_rank));
        }
      }
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
  local entity ally; 
  
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
      if( self.stat_rdr_mode ){       
        ai_sfx_help();
        ally = ai_find_friend( self.ai_view );
        if( ally ){
          ai_give_target( ally, found, (ally.ai_rank <= self.ai_rank));
        }
      }
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
  local float validTarg;
  
  if( !ally.th_missile ){
    return;
  }
  
  this = self;
  //validTarg = ai_valid_target(ally.enemy);  note: every other func calling this one already involes ai_valid_target()
  //if( validTarg ){
  self = ally;
  //providing clause where ally has no target
  if( override || !ai_valid_target(ally.enemy) ){
    self.enemy = ally.enemy;
    macro_ai_frame(self.th_missile)
    if( (this.enemy.flags & FL_CLIENT) ){
      ai_sfx_roger();
    }
  }
  else{
    if( self.th_pain ){
      self.th_pain(ally.enemy);
    }
  }
  //}
  self = this;
};



/*
  Only used for RANDOM_START
*/
entity() ai_node_pick_rand={
  local entity anode;
  local float clr, total, pick;
  local string grpid;
  
  if( self.target ){
    anode = find(world, targetname, self.target);
    if( anode && anode.group ){
      grpid = anode.group;
      total = 0;
      clr = 0;
      while( clr <= 128 ){
        AI_NODES[clr] = world;
        clr = clr + 1;
      }
      
      anode = findchain( group, grpid);
      if( anode && (anode.flags & FL_NODE) ){  
        while( anode ){
          AI_NODES[total] = anode;
          total = total + 1;
          anode = anode.chain;
        }
        pick = rint(random() * total );
        anode = AI_NODES[pick];
      }
    }
    else{
      self.spawnflags = self.spawnflags - self.spawnflags & RANDOM_START;
    }
  }
  return anode;
};


/*
  finds a random spot offset from goalentity to move to,
  this alleviates issue of bots traffic jamming at terminal patrol nodes.
*/
entity() ai_goal_offset_node={
  local vector angl;
  local float incr;
  local float tests;
  local float testLen;
  local float checkLen;
  local vector offsetNodeOrg;
  local entity offsetNode;
  angl = self.angles;
  angl_y = anglemod(self.angles_y - 99);
  incr = 33;
  tests = 1;
  checkLen = 250;
  while( tests < 7 ){
    angl_y = anglemod( angl_y + (incr * tests) );
    makevectors(angl);
    //traceline(self.origin, self.origin + (v_forward * 200), FALSE, self);
    tracebox(self.origin, self.mins, self.maxs, self.origin + (v_forward * 200), MOVE_NORMAL, self);
    if( pointcontents(trace_endpos) == 0 || pointcontents(trace_endpos) == CONTENT_WATER){
      testLen = vlen(trace_endpos - self.origin);
      if( testLen < checkLen && testLen > 33 ){
        checkLen = testLen;
        offsetNodeOrg = trace_endpos;
      }
    }
    tests = tests + 1;
  }
  if( checkLen == 250 ){
    return world;
  }
  offsetNode = spawn();
  offsetNode.classname = "ai_node";
  offsetNode.ai_rank = (random() * 50) + (random() * 33);
  offsetNode.faction = self.faction;
  offsetNode.isActive = TRUE;
  setsize(offsetNode, '-16 -16 -32', '16 16 32');
  setorigin(offsetNode, offsetNodeOrg);
  return offsetNode;
};


//AI MAP FUNCS
/*
  called by any AI unit that needs to spawn onto the map.
  This function delegates HOW the AI should be spawned based on its starting parameters.
  
  if the AI is to be triggered by another object, then postpone full ini into the use() function
  else
  fall-through and create the ai

  now macro_ai_setup - Roohr

float( void() ai_ini ) ai_unit_setup={
  
  self.wait = 1;
  if( self.delay > 0 ){
    //defaults the wait value in case map didnt specify
    self.wait = self.delay;
  }
  if( (!self.nextVecChoice) ){
    //safety check
    self.think = SUB_Remove;
    self.nextthink = time + 0.05;
    return TRUE;
  }
  
  if( (self.spawnflags & TRIGGER_ME) && (self.targetname) ){
    //checking the targetname is mostly for validation
    self.use = ai_unit_make_trigger;
    self.think = ai_ini;
    self.spawnflags = self.spawnflags - (self.spawnflags & TRIGGER_ME);
    return TRUE;
  }
  //fall-through, AI is cleared to happen
  self.use = multi_trigger;
  return FALSE;
};
*/

void() ai_unit_make_trigger={
  self.spawnflags = self.spawnflags - TRIGGER_ME;
  self.use = SUB_Null;  //triggered
  self.think = self.unit_ini;
  self.nextthink = time + self.wait + (random() * 1);
  self.unit_ini = SUB_Null;
};

/*
  Inspired by the original SUB_CalcMoved
*/
float(vector destOrg, float wishSpeed) ai_calc_move={
  local vector startOrg;
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
  
  tracebox(self.origin + (v_forward * (tMaxs_x / 2)), tMins, tMaxs, destOrg + (v_forward * (tMaxs_x / 2)), MOVE_NORMAL, self);
  //big debug 
   // trailparticles(self, particleeffectnum("TE_PAC_RAIL"), self.origin + (v_forward * (tMaxs_x / 2)) + (v_right * tMaxs_x) + (v_up * tMaxs_z), destOrg + (v_right * tMaxs_x) + (v_up * tMaxs_z));  //debug
    //trailparticles(self, particleeffectnum("TE_PAC_RAIL"), self.origin + (v_forward * (tMaxs_x / 2)) + (v_right * tMins_x) + (v_up * tMaxs_z), destOrg + (v_right * tMins_x) + (v_up * tMaxs_z));  //debug
    //trailparticles(self, particleeffectnum("TE_PAC_RAIL"), self.origin + (v_forward * (tMaxs_x / 2)) + (v_right * tMaxs_x) + (v_up * tMins_z), destOrg + (v_right * tMaxs_x) + (v_up * tMins_z));  //debug
    //trailparticles(self, particleeffectnum("TE_PAC_RAIL"), self.origin + (v_forward * (tMaxs_x / 2)) + (v_right * tMins_x) + (v_up * tMins_z), destOrg + (v_right * tMins_x) + (v_up * tMins_z));  //debug
  //

  if( trace_fraction < 0.1 ){
    return 0;
  }
  len = len * trace_fraction;
  
  // divide by speed to get time to reach dest
  travel = len / wishSpeed;
  
  return travel / 24;  //AI runs at about time + 0.04 so adjust travel time 
};

/*
  Find the closest node to the target entity that the AI 
  can feasibly reach.
*/
entity(entity targ) ai_node_to_target={
  local entity checkNode;
  local entity found;
  local entity parnt;
  local float link;
  local float dist;
  local float distComp;
  
  if( self.patrolNode.owner == world ){
    parnt = self.patrolNode;
  }
  else{
    parnt = self.patrolNode.owner;
  }
  
  dist = vlen(targ.origin - parnt.origin);

  for(checkNode = parnt; checkNode != world; checkNode = checkNode.partNext){
    distComp = vlen(checkNode.origin - targ.origin);
    if(checkNode == parnt ){
      distComp = distComp - 1;  //hackfrauds
    }
    
    checkNode.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
    tracebox(checkNode.origin, self.mins, self.maxs, self.origin, MOVE_NOMONSTERS, self);
    if( trace_fraction >= 0.9 || trace_ent == targ || (trace_ent.flags&FL_UNIT)){
      if( distComp < dist ){
        dist = distComp;
        found = checkNode;
      }
      checkNode.dphitcontentsmask = 0;
    }    
    if( checkNode.partNext && checkNode.owner == checkNode.partNext ){
      break;
    }
  }
  if( found ){
    if( found.partTypeId < self.patrolNode.partTypeId ){
      tracebox(targ.origin, targ.mins, targ.maxs, self.patrolNode.partPrev.origin, MOVE_NOMONSTERS, targ);
      if( trace_fraction == 1.0 ){
        return self.patrolNode.partPrev;
      }
    }
    if( found.partTypeId > self.patrolNode.partTypeId ){
      tracebox(targ.origin, targ.mins, targ.maxs, self.patrolNode.partNext.origin, MOVE_NOMONSTERS, targ);
      if( trace_fraction == 1.0 ){
        return self.patrolNode.partNext;
      }
    }
    return found;
  }
  else{
    if( vlen(parnt.origin - targ.origin) <= AI_RANGE_L ){
      return parnt;
    }
  }
  return world;
};

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

/*
  Check if entity <toCheck> is outside of 
  
  AI's current patrolNode.ai_view radius.
  
  returns a percentage of distance to node.
  
  a value > 1 is out of node radius
*/
float(entity toCheck) ai_check_node_radius={
  local float distance;
  distance = vlen(toCheck.origin - self.patrolNode.origin);
  if( self.patrolNode.ai_view != 0 ){
    distance = max(distance / self.patrolNode.ai_view, 0.01);
  }
  else{
    distance = max(distance / AI_RANGE_S * 1.25, 0.01);
  }
  return distance;
};

/*
  A soft-wrapper for ai_check_node_radius();
    this converts self.stat_trg_dst (target distance to self)
    in a percentage of node radius.
*/
float() ai_check_node_radius_targdist={
  local float distance;
  if( self.patrolNode.ai_view != 0 ){
    distance = max(self.stat_trg_dist / self.patrolNode.ai_view, 0.01);
  }
  else{
    distance = 1.0;
  }
  return distance;
};

/*
  initialize weapon loadout default IF
  the weapon slot is not overridden -
  ie the map spawn call can override any and all weapon
  choices.
*/
void( float wep1, float wep2, float wep3, float wep4, float wep5, float wep6, float wep7, float wep8, float wep9) ai_ini_weapons={
  if( !self.next_wepn1 ){
    self.next_wepn1 = wep1;
  }
  if( !self.next_wepn2 ){
    self.next_wepn2 = wep2;
  }
  if( !self.next_wepn3 ){
    self.next_wepn3 = wep3;
  }
  if( !self.next_wepn4 ){
    self.next_wepn4 = wep4;
  }
  if( !self.next_wepn5 ){
    self.next_wepn5 = wep5;
  }
  if( !self.next_wepn6 ){
    self.next_wepn6 = wep6;
  }
  if( !self.next_wepn7 ){
    self.next_wepn7 = wep7;
  }
  if( !self.next_wepn8 ){
    self.next_wepn8 = wep8;
  }
  if( !self.next_wepn9 ){
    self.next_wepn9 = wep9;
  }
}; 

/*
  Attempts to find the closest allowable <ai_node_tether> entity.
*/
void() ai_node_tether_find={
  local entity findNode;
  local entity found;
  local float dist;
  local float testDist;
  local vector tMins;
  local vector ang;
  dist = AI_RANGE_L;
  
  //first query existing nodes to see if a tether exists nearest the AI.
  for(findNode = nextent(world); findNode != world; findNode = nextent(findNode)){
    if( findNode.classname != "ai_node_tether" ){
      continue;
    }
    if( findNode.faction && findNode.faction != self.faction ){
      continue;
    }
    ang = vectoangles(findNode.origin - self.origin);
    if( ang_x <= 67 || ang_x >= 293) {
      //tether nodes need to be on relatively flat planes because a bot cannot climb a wall or slope to reach a tether node.
      testDist = vlen(findNode.origin - self.origin);
      if( testDist < dist ){
        tMins = self.mins;
        tMins_z = tMins_z * 0.75;
        tracebox(findNode.origin, tMins, self.maxs, self.origin, MOVE_NORMAL, self);
        cons_logAFloat("ai_node_tether_find()-trace_fraction", trace_fraction);
        if( trace_fraction == 1 ){
          dist = testDist;
          found = findNode;
        }
      }
    }
  }
  if( found ){
    self.tetherStatus = TETHER_NODE;
    self.tetherOrg = util_find_random_farpoint(found.origin, found, random() * found.ai_view/1.25, 64);
    self.tetherNode = found;
    self.patrolNode = found;
  }
  else{
    //no tether nodes found,
    self.tetherStatus = TETHER_SELF;
  }
};

/*
  Tries to keep the AI leashed to its tether node, making sure not to exceed
  the radius of the node.
*/
float() ai_node_tether_check={
  if( self.tetherStatus == TETHER_NODE || self.tetherStatus == TETHER_PATROL ){
    if( vlen(self.tetherNode.origin - self.origin) > self.tetherNode.ai_view){
      //ai is out of bounds
      return FALSE;
    }
    return TRUE;
  }
  if( vlen(self.tetherOrg - self.origin) > AI_RANGE_M ){
    return FALSE;
  }
  return TRUE;
};


/*
  Traffic adjuster:
    called in ai_patrol_state_frame() when the WALKMOVE() call is blocked.
    This finds the trace along the AI's current facing, and freezes itself
    IF there's a friendly unit in front of it.
    
    returns TRUE IF traffic was handled,
    return FALSE if trace_ent wasn't a unit.
*/
float() ai_patrol_traffic_adjust={
  local vector tMins;
  local vector tMaxs;
  local entity oldthat;
  local float counter;
  local vector newOrg;
  
  tMins = self.mins * 0.75;
  tMaxs = self.maxs * 0.75;
  makevectors(self.angles);
  tracebox(self.origin, tMins, tMaxs, self.origin + (v_forward * (self.maxs_x * 2)), MOVE_NORMAL, self);
  
  if( trace_ent ){
    if( trace_ent.faction == self.faction ){
      if( trace_ent.data_type != DATA_BLD && trace_ent.movetype != MOVETYPE_FLYMISSILE ){
        oldthat = self;
        self = trace_ent;
        counter = ai_check_targ_infront(oldthat, 0.9, FALSE);
        self = oldthat;
        //blocked unit is patrolling.
        self.ai_blockflag = time + 10;
        self.ai_state_next = ST_PTR_PAUSE;
        self.pausetime = 3;
        return TRUE;
      }
      return FALSE;
    }
    else{
      if( trace_ent.data_type != DATA_BLD && trace_ent.movetype != MOVETYPE_FLYMISSILE ){
        //combat?
        self.ai_move_next = MOVE_STAND_FACE;
        self.ai_movewait = 5;
        self.ai_state_next = ST_COM_MOVE_START;
       
        oldthat = self;
        self = trace_ent;
        counter = ai_check_targ_infront(oldthat, 0.85, FALSE);
        self = oldthat;
        if( counter ){
          trace_ent.ai_move_next = MOVE_BACK;
          trace_ent.ai_movedist = 10;
          trace_ent.ai_state_next = ST_COM_MOVE_START;
        }
        return TRUE;
      }
      return FALSE;
    }
  }
  return FALSE;
};