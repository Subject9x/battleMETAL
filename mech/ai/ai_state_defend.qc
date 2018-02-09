/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai state implementation
  state: PATROL
*/

//============================
//   DEFEND STATES          
//============================
/*
  Defense nodes, to cover a large area (say a base) should be a series
  of nodes that either can see each other, or be seen by a central node.
  Give all nodes in the set of Defense nodes a .group id so that the
  AI can query all of them. 
*/
void() ai_defend_startWithNode={
  local entity e;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_defend_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_defend_gotoNode);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand); 
};

/*
  The AI queries the defense node set using groupId,
  make sure to assign a groupId to the AI when it is
  place in the map editor
*/
void() ai_defend_findNode={
  //find a patrol node, usually assigned by spawning in
  //IF NODE
    // TRUE -> ai_patrol_gotoNode
    // FALSE -> ai_misc_stand
  local entity dNode;
  if(self.node != world){
    if(self.node .isActive == TRUE){
      if(self.node .i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(self.node);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_defend_gotoNode);
        return;
      }
    }
  }
  dNode = ai_node_searchGroup_checkActive (self.group);
  if(dNode){
    self.node = dNode;
    self.enemy = self.node;
    self.goalentity = self.node;
    ai_state_control(ai_defend_gotoNode);
    return;
  }
};

/*
  very similar to patrol node goto
  difference is, bot should run, and ignore enemies unless
  they're too close to thing to guard
*/
void() ai_defend_gotoNode={
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact, dNode;
      local float tDist;
      contact = ai_target_radarTarget();
      tDist = vlen(contact.origin - self.origin);
      //AI should only engage inside this radius
      //to make sure it doesn't get kited
      if(tDist <= AI_DEFEND_DIST){
        if(contact){
          self.trigger_field = contact;
          if(ai_target_canSee(self.trigger_field)){
            ai_state_control(ai_combat_adjustPosition);
            return;
          }
          //Defender can't see target, try the defense grid
          //see if there's a node close
          dNode =  ai_node_defenseGroup_setCourse(contact, self.group);
          if(dNode){
            self.node = dNode;
            self.enemy = self.node;
            self.goalentity = self.node;
            ai_state_control(ai_defend_gotoNode);
            ai_move_controller(ai_move_run_goal, 1);
            return;
          }
          //TODO - only hunt target if target is still in defense radius
          self.enemy = self.trigger_field;
          self.goalentity = self.trigger_field;
          self.delay = time + 40; //TODO - patience mod
          ai_state_control(ai_combat_huntTarget);
          ai_move_controller(ai_move_run_goal, 1);
          return;
        }
      }
      else{
        //target is out of engage range, but within engage range of defense node grid
        if( ai_node_defenseGroup_nodeToTarget(self.trigger_field, self.group) ){
          local entity n;
          n = ai_node_defenseGroup_setCourse(self.trigger_field, self.group);
          if(n){
            self.node = n;
            self.enemy = self.node;
            self.goalentity = self.node;
            ai_state_control(ai_defend_gotoNode);
            return;
          }
        }
      }
    }
  }
  if(self.node != world){
    if(vlen(self.node.origin - self.origin) <= AI_DEFEND_DIST_MIN){
      ai_state_control(ai_defend_atNode);
      ai_move_controller(ai_move_stand, 1);
      return;
    }
    ai_state_control(ai_defend_gotoNode);
    ai_move_controller(ai_move_run_goal, 1);
    return;
  }
  ai_state_control(ai_misc_stand);
  ai_move_controller(ai_move_stand, 1);
  return;
};

/*
  AI's running a defense state don't really need to shift nodes
  unless a threat is near one of those nodes.
*/
void() ai_defend_atNode={
  //if node converts the state of the AI, run it here
  if(self.node.state_1){
    if(self.node.target){
      ai_update_entityTarget(self, self.node.target);
    }
    ai_util_firstOrder_nonStatic(self.node.state_1);
    return;
  }
  //similiar to standing but slightly different,
  //should only switch to combat if enemy is within a 
  //certain range of the defense point.
  if(ai_target_isValid(self.trigger_field)){
    self.enemy = self.trigger_field;
    self.goalentity = self.trigger_field;
    if(ai_target_canSee(self.trigger_field)){
      ai_state_control(ai_combat_adjustPosition);
      return;
    }
    ai_state_control(ai_combat_huntTarget);
    return;
  }
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    local entity contact, dNode;
    local float tDist;
    contact = ai_target_radarTarget();
    tDist = vlen(contact.origin - self.origin);
    //AI should only engage inside this radius
    //to make sure it doesn't get kited
    if(tDist <= AI_DEFEND_DIST){
      if(contact){
        self.trigger_field = contact;
        if(ai_target_canSee(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        //Defender can't see target, try the defense grid
        //see if there's a node close
        dNode =  ai_node_defenseGroup_setCourse(contact, self.group);
        if(dNode){
          self.node = dNode;
          self.enemy = self.node;
          self.goalentity = self.node;
          ai_state_control(ai_defend_gotoNode);
          ai_move_controller(ai_move_run_goal, 1);
          return;
        }
        //TODO - only hunt target if target is still in defense radius
        self.enemy = self.trigger_field;
        self.goalentity = self.trigger_field;
        self.delay = time + 40; //TODO - patience mod
        ai_state_control(ai_combat_huntTarget);
        ai_move_controller(ai_move_run_goal, 1);
        return;
      }
    }
    else{
      //target is out of engage range, but within engage range of defense node grid
      if( ai_node_defenseGroup_nodeToTarget(self.trigger_field, self.group) ){
        local entity n;
        n = ai_node_defenseGroup_setCourse(self.trigger_field, self.group);
        if(n){
          self.node = n;
          self.enemy = self.node;
          self.goalentity = self.node;
          ai_state_control(ai_defend_gotoNode);
          return;
        }
      }
    
    }
  }
  ai_state_control(ai_defend_atNode);
  ai_move_controller(ai_move_stand, 0.05);
  return;
};
