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
        ai_update_switchToNode(ai_findNode_searchGroup(e));
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
  local entity eNode;
  if(self.target){
    eNode = find(world, targetname, self.target);
    if(eNode){
      ai_update_switchToNode(eNode);
      ai_state_control(ai_defend_gotoNode);
      return;
    } 
  }
  if(self.group){
    eNode = ai_node_searchGroup_checkActive (self.group);
    if(eNode){
      ai_update_switchToNode(eNode);
      ai_state_control(ai_defend_gotoNode);
      return;
    }
  }
  if(self.node.group){    
    eNode = ai_node_searchGroup_checkActive (self.group);
    if(eNode){
      ai_update_switchToNode(eNode);
      ai_state_control(ai_defend_gotoNode);
      return;
    }
  }
  ai_move_controller(ai_move_stand, 0.25);
};

/*
  very similar to patrol node goto
  difference is, bot should run, and ignore enemies unless
  they're too close to thing to guard
*/
void() ai_defend_gotoNode={
  local float nDist, cDist;
  local entity contact, nextNode;
/*
  case A: goto node normally
  case B: goto node during defense - ie use defense nodes to track target
  case C: at node -> implicit check in CASES A and B
  case D: fail, just stand -> implicit check in CASES A and B
*/
  //CASE A
  if( (self.node != world) && (self.trigger_field == world) ){
    nDist = vlen(self.node.origin - self.origin);
    if(nDist <= AI_DEFEND_DIST_MIN){
      ai_state_control(ai_defend_atNode);
      ai_move_controller(ai_move_stand, 0.25);
      return;
    }
    if(!ai_target_canSee(self.node)){
      self.target = self.node.targetname;
      nextNode = ai_node_searchGroup_checkActive(self.group);
      if( (nextNode) && (self.node != nextNode) ){
        ai_update_switchToNode(nextNode);
        ai_state_control(ai_defend_gotoNode);
        return;
      }
    }
    contact = ai_target_radarTarget();
    if(contact){
      if( ai_node_defenseGroup_nodeToTarget(contact, self.group) ){
        cDist = vlen(contact.origin - nextNode.origin);
        if(cDist <= (AI_DEFEND_DIST + 5000)){
          nextNode = ai_node_defenseGroup_setCourse(contact, self.group);
          self.trigger_field = contact;
          ai_update_switchToNode(nextNode);
          ai_state_control(ai_defend_gotoNode);
          ai_move_controller(ai_move_run_goal, 2);
          return;
        }
      }
      ai_update_switchToTarget(self.trigger_field);
      self.patience = time + self.maxpatience;
      ai_state_control(ai_combat_huntTarget);
      return;
    }
    self.ideal_yaw = vectoyaw(self.node.origin - self.origin);
    ai_state_control(ai_defend_gotoNode);
    ai_move_controller(ai_move_walk_goal, 0.5);
    return;
  }
  
  //CASE B
  if( (self.node != world) && (self.trigger_field != world) ){
    cDist = vlen(self.trigger_field.origin - self.node.origin);
    if(cDist > AI_RANGE_L){
      self.trigger_field = world;
      ai_update_switchToNode(self.node);
      ai_state_control(ai_defend_gotoNode);
      return;
    }
    nDist = vlen(self.node.origin - self.origin);
    if( nDist <= AI_DEFEND_DIST_MIN ){
      ai_state_control(ai_defend_atNode);
      ai_move_controller(ai_move_stand, 0.25);
      return;
    }
    if( ai_target_canSee(self.trigger_field) ){
      ai_update_switchToTarget(self.trigger_field);
      self.patience = time + self.maxpatience;
      ai_state_control(ai_combat_huntTarget);
      return;
    }
    ai_state_control(ai_defend_gotoNode);
    ai_move_controller(ai_move_run_goal, self.p_damage + 1);
    return;
  }
};

/*
  AI's running a defense state don't really need to shift nodes
  unless a threat is near one of those nodes.
*/
void() ai_defend_atNode={
  local float nDist, cDist;
  local entity contact, nextNode;
/*
  case A: arrived at node normally
  case B: arrived at node in active combat
*/

  //CASE A
  if( (self.node != world) && (self.trigger_field == world) ){
    //AI was transitioning
    if(self.target != self.node.targetname){
      self.node = world;
      ai_state_control(ai_defend_startWithNode);
      ai_move_controller(ai_move_stand, 0.1);
      return;
    }
    if(self.target == self.node.targetname){
      //AI finished transition
      self.target = "";
    }
    contact = ai_target_radarTarget();
    if(contact){
      if( ai_node_defenseGroup_nodeToTarget(contact, self.group) ){
        nextNode = ai_node_defenseGroup_setCourse(contact, self.group);
        cDist = vlen(contact.origin - nextNode.origin);
        if(cDist <= (AI_DEFEND_DIST + 5000) ){
          self.trigger_field = contact;
          ai_update_switchToNode(nextNode);
          ai_state_control(ai_defend_gotoNode);
          ai_move_controller(ai_move_run_goal, 2);
          return;
        }
      }
    }
  }
  
  //CASE B
  if( (self.node != world) && (self.trigger_field != world) ){  
    local entity nodeTest;
    nodeTest = ai_node_defenseGroup_setCourse(self.trigger_field, self.group);
    cDist = self.stat_trg_dist;
    if(nodeTest == self.node){
      ai_update_switchToTarget(self.trigger_field);
      self.patience = time + self.maxpatience;
      ai_state_control(ai_combat_huntTarget);
      return;
    } 
    
    if(ai_target_canSee(self.trigger_field)){
      ai_update_switchToTarget(self.trigger_field);
      ai_state_control(ai_combat_adjustPosition);
      return;
    }
    
  }
  
  ai_state_control(ai_defend_atNode);
  ai_move_controller(ai_move_stand, 1);
  return;
};
