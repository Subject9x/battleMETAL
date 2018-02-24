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
        ai_update_switchToNode(self.node);
        ai_state_control(ai_defend_gotoNode);
        return;
      }
    }
  }
  dNode = ai_node_searchGroup_checkActive (self.group);
  if(dNode){
    ai_update_switchToNode(dNode);
    ai_state_control(ai_defend_gotoNode);
    return;
  }
  ai_move_controller(ai_move_stand, 0.25);
};

/*
  very similar to patrol node goto
  difference is, bot should run, and ignore enemies unless
  they're too close to thing to guard
*/
void() ai_defend_gotoNode={
/*
  case A: goto node normally
  case B: goto node during defense - ie use defense nodes to track target
  case C: at node -> implicit check in CASES A and B
  case D: fail, just stand -> implicit check in CASES A and B
*/
  //CASE A
  if( (self.node != world) && (self.trigger_field == world) ){
    local float nDist;
    nDist = vlen(self.node.origin - self.origin);
    if(nDist > AI_DEFEND_DIST_MIN){
      if(ai_target_canSee(self.node)){
        ai_state_control(ai_defend_gotoNode);
        ai_move_controller(ai_move_walk_goal, 1);
        return;
      }
      else{
        //defenders aren't picky on positioning.
        local entity n;
        local float nDistt;
        n = ai_findNode_searchGroup(self.node);
        if(n){
          ai_update_switchToNode(n);
          nDistt = vlen(n.origin - self.origin);
          if(nDist <= AI_DEFEND_DIST_MIN){
            ai_state_control(ai_defend_atNode);
            ai_move_controller(ai_move_stand, 1);
            return;
          }
          else{
            ai_state_control(ai_defend_gotoNode);
            ai_move_controller(ai_move_walk_goal, 1);
            return;
          }
        }
        else{
          ai_state_control(ai_defend_gotoNode);
          ai_move_controller(ai_move_walk_goal, 1);
          return; 
        }
      }
    }
    else{
      ai_state_control(ai_defend_atNode);
      ai_move_controller(ai_move_stand, 1);
      return;
    }
  }
  
  //CASE B
  if( (self.node != world) && (self.trigger_field != world) ){
    if(self.stat_rdr_mode != FALSE){
      self.stat_rdr_mode = FALSE;
    }
    if(ai_target_isValid(self.trigger_field)){
      //minimize the chances of kiting the AI away from its base
      if(ai_node_defenseGroup_nodeToTarget(self.trigger_field, self.group) ){
        //AI can visually spot the target, so jump to combat
        if(ai_target_canSee(self.trigger_field)){
          self.node = world;
          ai_update_switchToTarget(self.trigger_field);
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        else{
          //AI cannot see target, so it tries to find closest
          //defense node, barring that, try to hunt the target
          local entity dNode;
          dNode = ai_node_defenseGroup_setCourse(self.trigger_field, self.group);
          if(dNode){
            ai_state_control(ai_defend_gotoNode);
            ai_move_controller(ai_move_run_goal, 1);
            return;
          }
          else{
            //attempt to hunt the target normally;
            self.patience = time + self.maxpatience;
            ai_update_switchToTarget(self.trigger_field);
            ai_state_control(ai_combat_huntTarget);
            return;
          }
        }
      }
      else{
        //potential target is out of range, try some others
        if(ai_target_isValid(self.oldenemy)){
          self.trigger_field = self.oldenemy;
          self.oldenemy = world;
          ai_state_control(ai_defend_gotoNode);
          ai_move_controller(ai_move_run_goal, 1);
          return;
        }
        else{
          //AI doesn't have an old grudge so return to normal
          local entity dNode;
          dNode = ai_findNode_searchGroup(self.node);
          if(dNode){
            ai_update_switchToNode(dNode);
            ai_state_control(ai_defend_gotoNode);
            return;
          }
          else{
            ai_target_clearBuffers();
            ai_state_control(ai_misc_stand);
            ai_move_controller(ai_move_stand, 1);
            return;
          }
        }
      }
    }
    else{
      //defenders aren't picky on positioning.
      local entity n;
      local float nDistt;
      n = ai_findNode_searchGroup(self.node);
      if(n){
        ai_update_switchToNode(n);
        nDistt = vlen(n.origin - self.origin);
        if(nDistt <= AI_DEFEND_DIST_MIN){
          ai_state_control(ai_defend_atNode);
          ai_move_controller(ai_move_stand, 1);
          return;
        }
        else{
          ai_state_control(ai_defend_gotoNode);
          ai_move_controller(ai_move_walk_goal, 1);
          return;
        }
      }
      else{
        ai_state_control(ai_defend_gotoNode);
        ai_move_controller(ai_move_walk_goal, 1);
        return; 
      }
    }
  }
};

/*
  AI's running a defense state don't really need to shift nodes
  unless a threat is near one of those nodes.
*/
void() ai_defend_atNode={
/*
  case A: arrived at node normally
  case B: arrived at node in active combat
*/

  //CASE A
  if( (self.node != world) && (self.trigger_field == world) ){
    //at node with nuthin to do
    if(self.stat_rdr_mode != TRUE){
      self.stat_rdr_mode = TRUE;
    }
    local entity contact;
    contact = ai_target_radarTarget();
    if(contact){ 
      //cons_logAString("", "contact!"); //DEBUG
      //make sure contact is actually threatening the base
      if( ai_node_defenseGroup_nodeToTarget(contact, self.group) ){
        //cons_logAString("ai_node_defenseGroup_nodeToTarget", "true"); //DEBUG
        //see if any other friendlies have logged this target
        local float friends;
        friends = ai_combat_locksOnTarget(contact, self.i_faction);
        if( friends <= 1 ){
          //cons_logAString("friends<1", "true"); //DEBUG
          //valid LoS? engage
          if(ai_target_canSee(contact)){
            //cons_logAString("ai_target_canSee", "true"); //DEBUG
            ai_update_switchToTarget(contact);
            ai_state_control(ai_combat_adjustPosition);
            return;
          }
          else{
            //see if there's a node that's closer to the contact
            local entity eNode;
            eNode = ai_node_defenseGroup_setCourse(contact, self.group);
            if(eNode){
              //cons_logAString("eNode", "true"); //DEBUG
              ai_update_switchToNode(eNode);
              self.trigger_field = contact;
              ai_state_control(ai_defend_gotoNode);
              return;
            }
            else{
              //cons_logAString("eNode", "false"); //DEBUG
              //no node? darn attempt to hunt 
              self.patience = time + self.maxpatience;
              ai_update_switchToTarget(contact);
              ai_state_control(ai_combat_huntTarget);
              return;
            }
          }
        }
      }
    }
    else{
      //cons_logAString("", "contact not valid"); //DEBUG
      //no contacts, see if node has marching orders
      if(self.node.target){
        local entity next;
        next = find(world, targetname, self.node.target);
        if(next){
          ai_update_switchToNode(next);
          ai_state_control(ai_defend_gotoNode);
          return;
        }
      }
    }
  }
  
  //CASE B
  if( (self.node != world) && (self.trigger_field != world) ){  
    if(ai_target_isValid(self.trigger_field)){
      //minimize the chances of kiting the AI away from its base
      if(ai_node_defenseGroup_nodeToTarget(self.trigger_field, self.group) ){
        //AI can visually spot the target, so jump to combat
        if(ai_target_canSee(self.trigger_field)){
          self.node = world;
          ai_update_switchToTarget(self.trigger_field);
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        else{
          //AI cannot see target, so it tries to find closest
          //defense node, barring that, try to hunt the target
          local entity dNode;
          dNode = ai_node_defenseGroup_setCourse(self.trigger_field, self.group);
          if(dNode){
            ai_state_control(ai_defend_gotoNode);
            return;
          }
          else{
            //attempt to hunt the target normally;
            self.patience = time + self.maxpatience;
            ai_update_switchToTarget(self.trigger_field);
            ai_state_control(ai_combat_huntTarget);
            return;
          }
        }
      }
      else{
        //potential target is out of range, try some others
        if(ai_target_isValid(self.oldenemy)){
          self.trigger_field = self.oldenemy;
          self.oldenemy = world;
          ai_state_control(ai_defend_gotoNode);
          return;
        }
        else{
          //AI doesn't have an old grudge so return to normal
          local entity dNode;
          dNode = ai_findNode_searchGroup(self.node);
          if(dNode){
            ai_update_switchToNode(dNode);
            ai_state_control(ai_defend_gotoNode);
            return;
          }
          else{
            ai_state_control(ai_defend_atNode);
            ai_target_clearBuffers();
            return;
          }
        }
      }
    }
    else{
      //defenders aren't picky on positioning.
      local entity n;
      local float nDistt;
      n = ai_findNode_searchGroup(self.node);
      if(n){
        ai_update_switchToNode(n);
        nDistt = vlen(n.origin - self.origin);
        if(nDistt <= AI_DEFEND_DIST_MIN){
          ai_state_control(ai_defend_atNode);
          ai_move_controller(ai_move_stand, 1);
          return;
        }
      }
    }
  }
  
  ai_state_control(ai_defend_atNode);
  ai_move_controller(ai_move_stand, 1);
  return;
};
