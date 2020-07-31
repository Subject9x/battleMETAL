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
    ai_give_target( ally, t, (t.flags&FL_CLIENT) );
    allies = allies + 1;
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
  
  if((t.flags&FL_CLIENT)){
    ai_sfx_help();
  }
  if(!self.ai_view || self.ai_view < 1){
    self.ai_view = AI_RANGE_M;
  }
  for(ally = findradius(self.origin, self.ai_view); ally != world; ally = ally.chain){
    if( ally.faction != self.faction ){
      continue;
    }
    if( !ai_valid_target(ally) ){
      continue;
    }
    ai_give_target( ally, t, (t.flags&FL_CLIENT) );
  }
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
      if(self.ai_state_next != ST_COMBAT ){
        self.ai_state_next = ST_COMBAT;
      }
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
  WHEN: AI are set to TETHER_PATROL, they can query their patrol nodes for better positioning data.
    This checks to see if patrolNode.partNext or patrolNode.partPrev are CLOSER to the desired target.
    If they are, then the AI executes MOVE_NODE_TACTICAL to get there.
*/
entity(entity targ) ai_node_to_target={
  local entity hold;
  local entity found;
  local float dist;
  local float distComp;
  local float checkDist;
  
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
    distance = max(distance / AI_RANGE_S, 0.01);
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