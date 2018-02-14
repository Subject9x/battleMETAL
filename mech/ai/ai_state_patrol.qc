/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai state implementation
  state: PATROL
*/

//============================
//   PATROL STATES          
//============================
//this is a special case, invoked at unit spawn
void() ai_patrol_startWithNode={
  local entity e;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_patrol_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_patrol_gotoNode);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand); 
};

void() ai_patrol_findNode={
  //find a patrol node, usually assigned by spawning in
  //IF NODE
    // TRUE -> ai_patrol_gotoNode
    // FALSE -> ai_misc_stand
  if(self.node != world){
    if(self.node .isActive == TRUE){
      if(self.node .i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(self.node);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_patrol_gotoNode);
        return;
      }
    }
  }
  if(self.target){
    ai_state_control(ai_patrol_startWithNode);
    return;
  }
};

void() ai_patrol_gotoNode={
  //NODE STILL VALID
    // TRUE -> ai_patrol_gotoNode
    // FALSE -> ai_misc_stand
    
  //is node within 'stop' range
    // TRUE -> ai_patrol_atNode
    // FALSE -> ai_patrol_gotoNode
  
  //detect a bad guy
    //TRUE -> 
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact;
      contact = ai_target_radarTarget();
      if(contact){
        ai_update_switchToTarget(contact);
        if(ai_target_visualPing(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          ai_move_controller(ai_move_stand, 0.05);
          return;
        }
        self.delay = time + ai_pilot_rating_patience(); //TODO - patience mod
        ai_state_control(ai_combat_huntTarget);
        return;
      }
    }
  }
  if(self.node != world){
    if(vlen(self.node.origin - self.origin) <= AI_PATROL_DIST){
      //AI has reached the node
      if(self.node.delay){
        self.delay = time + self.node.delay;
      }
      ai_state_control(ai_patrol_atNode);
      ai_move_controller(ai_move_stand, 1);
      return;
    }
    //still traveling to a valid node
    ai_state_control(ai_patrol_gotoNode);
    ai_move_controller(ai_move_walk_goal, 1);
    return;
  }
  //ruh roh, node no longer valid
  ai_state_control(ai_misc_stand);
  ai_move_controller(ai_move_walk_goal, 1);
  return;
};

/*
  AI has reached the min distance to its desired patrol node entity,
  if the ai has a delay value, it waits at the node for that length
  of time before moving onto the next node (if there is one). As
  usual, the AI makes a radar sweep at the top of this function to
  detect enemies early and switch states to combat.
*/
void() ai_patrol_atNode={
  //make a sweep for targets
    // TRUE -> ai_combat_findTarget
    // FALSE -> nothing
  //wait on delay
  //if delay done
    //if new node
      //TRUE -> assign new node, ai_patrol_gotoNode
   //flip on RADAR, and run a sweep

  //if node converts the state of the AI, run it here
  if(self.node.state_1){
    if(self.node.target){
      ai_update_entityTarget(self, self.node.target);
    }
    ai_util_firstOrder_nonStatic(self.node.state_1);
    return;
  }
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact;
      contact = ai_target_radarTarget();
      if(contact){
        ai_update_switchToTarget(contact);
        if(ai_target_canSee(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        self.delay = time + ai_pilot_rating_patience(); //TODO - patience mod
        ai_state_control(ai_combat_huntTarget);
        return;
      }
    }
  }
  if(time > self.delay){
    if(self.node.target){
      local entity e;
      e = find(world, targetname, self.node.target);
      if(e){
        if(e.isActive == TRUE){
          if(e.i_faction == self.i_faction){
            //no need to search for next node, right?
            self.node = e;
            self.enemy = self.node;
            self.goalentity = self.node;
            ai_state_control(ai_patrol_gotoNode);
            return;
          }
        }
      }
    }
    //end of patrol path
    self.node = world;
    self.enemy = self.node;
    self.goalentity = self.node;
    ai_state_control(ai_patrol_atNode);
    ai_move_controller(ai_move_stand, 0.5);
    return;
  }
  ai_state_control(ai_patrol_atNode);
  ai_move_controller(ai_move_stand, 0.5);
  return;
};