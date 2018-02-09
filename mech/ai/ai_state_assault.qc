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


void() ai_assault_findNode={
  local entity e;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_defend_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_assault_gotoNode);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand); 
};


void() ai_assault_gotoNode={
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact, dNode;
      contact = ai_target_radarTarget();
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
          ai_state_control(ai_assault_gotoNode);
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
  }
  if(self.node != world){
    if(vlen(self.node.origin - self.origin) <= AI_DEFEND_DIST_MIN){
      ai_state_control(ai_assault_atNode);
      ai_move_controller(ai_move_stand, 1);
      return;
    }
    ai_state_control(ai_assault_gotoNode);
    ai_move_controller(ai_move_run_goal, 1);
    return;
  }
  ai_state_control(ai_misc_stand);
  ai_move_controller(ai_move_stand, 1);
  return;
};


void() ai_assault_atNode={
  //similiar to standing but slightly different,
  //should only switch to combat if enemy is within a 
  //certain range of the assault point.
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
    if(self.trigger_field == world){
      local entity contact;
      contact = ai_target_radarTarget();
      if(contact){
        self.trigger_field = contact;
        self.enemy = self.trigger_field;
        self.goalentity = self.trigger_field;
        if(ai_target_canSee(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        //TODO - only hunt target if target is still in defense radius
        self.delay = time + ai_pilot_rating_patience(); //TODO - patience mod
        ai_state_control(ai_combat_huntTarget);
        return;
      }
    }
  }
  ai_state_control(ai_assault_atNode);
  ai_move_controller(ai_move_stand, 0.05);
  return;
};