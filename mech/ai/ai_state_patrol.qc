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
        //self.enemy = contact;
        //self.goalentity = contact;
        //cons_logAString("CONTACT!", "found a baddy");
        self.trigger_field = contact;
        self.enemy = self.trigger_field;
        self.goalentity = self.trigger_field;
        if(ai_target_canSee(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        self.delay = time + 40; //TODO - patience mod
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

void() ai_patrol_atNode={
  //make a sweep for targets
    // TRUE -> ai_combat_findTarget
    // FALSE -> nothing
  //wait on delay
  //if delay done
    //if new node
      //TRUE -> assign new node, ai_patrol_gotoNode
   //flip on RADAR, and run a sweep
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact;
      contact = ai_target_radarTarget();
      if(contact){
        self.trigger_field = contact;
        //self.enemy = contact;
        //self.goalentity = contact;
        cons_logAString("CONTACT!", "found a baddy");
        //TODO switch to combat
        return;
      }
    }
  }
  
  //cons_logAFloat("self.node.delay", self.node.delay); //DEBUG
  if(time > self.delay){
    if(self.node.target){
      //cons_logAString("self.node.target", self.node.target); //DEBUG
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