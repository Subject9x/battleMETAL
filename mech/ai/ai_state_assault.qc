/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai state implementation
  state: ASSAULT
*/

//============================
//   ASSAULT STATES          
//============================
/*
  Assault nodes, to cover a large area (say a base) should be a series
  of nodes that either can see each other, or be seen by a central node.
  Give all nodes in the set of Defense nodes a .group id so that the
  AI can query all of them. 
*/
void() ai_assault_startWithNode={
  local entity e;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_assault_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        ai_update_switchToNode(self.node);
        ai_state_control(ai_assault_gotoNode);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand); 
};

void() ai_assault_findNode={
  local entity e, aNode;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_assault_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        ai_update_switchToNode(self.node);
        ai_state_control(ai_assault_gotoNode);
        return;
      }
    }
  }
  aNode = ai_node_searchGroup_checkActive (self.group);
  if(aNode){
    ai_update_switchToNode(aNode);
    ai_state_control(ai_assault_gotoNode);
    return;
  }
  ai_move_controller(ai_move_stand, 0.25);
};

/*
  AI is traveling to an assault node
  could be from other types of nodes
*/
void() ai_assault_gotoNode={
/*
  case A: goto node normally
  case B: goto node during assault
  case C: at node -> implicit check in CASES A and B
  case D: fail, just stand -> implicit check in CASES A and B
*/
  //CASE A
  if( (self.node != world) && (self.trigger_field == world) ){
    local float nDist;
    nDist = vlen(self.node.origin - self.origin);
    if(nDist > AI_ASSAULT_DIST_MIN){
      local entity contact;
      //really only fight other targets if they're near the node or in the way
      contact = ai_node_closestTargNearNode(self.node);
      if(contact){
        self.trigger_field = contact;
        ai_update_switchToTarget(self.trigger_field);
        self.patience = time + self.maxpatience;
        ai_state_control(ai_combat_huntTarget);
        return;
      }
      ai_state_control(ai_assault_gotoNode);
      ai_move_controller(ai_move_walk_goal, 0.5);
      return;
    }
    else{
      ai_state_control(ai_assault_atNode);
      ai_move_controller(ai_move_stand, 0.5);
      return;
    }
  }
};

/*
  AI is at the designated assault node
*/
void() ai_assault_atNode={
  /*
    case A: at node, no targets
    case B: have target, moving through node
    case C: do nothing.
  */
  //CASE A
  if( (self.node != world) && (self.trigger_field == world) ){
    local entity contact;
    //really only fight other targets if they're near the node or in the way
    contact = ai_node_closestTargNearNode(self.node);
    if(contact){
      self.trigger_field = contact;
      ai_update_switchToTarget(self.trigger_field);
      self.patience = time + self.maxpatience;
      ai_state_control(ai_combat_huntTarget);
      return;
    }
    //no targets, and node has target
    if(self.node.target){
      local entity nexNode;
      nexNode = find(world, targetname, self.node.target);
      if(nexNode){
        self.node = nexNode;
        ai_update_switchToNode(self.node);
        ai_state_control(ai_assault_gotoNode);
        return;
      }
    }
  }
  ai_move_controller(ai_move_stand, 0.25);
};