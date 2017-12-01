/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

/*
  6/15/2017
  established states
  [hunt]
    context
      goalentity = enemy
      
  [fight]
    goalentity = dump to world
    
  
  [tonode]  
    goalentity = desired node
    
  [trynode]
    goalentity = current desired node
    oldgoal = original goal
    
  [ready]
  
  -----triggers----
  hunt -> fight = AI can traceline enemy || enemy dead
  hunt -> trynode = AI lost traceline enemy || enemy dead
  
  fight -> hunt = AI lost traceline
  fight -> tonode = enemy dead, move to original node
  
  trynode -> trynode = not at goal node yet
  trynode -> hunt = hunt was cached
  trynode -> tonode = tonode was cached
  
  ready -> fight = found enemy in line of sight
  
  tonode -> fight = saw enemy, cache to node
  
  ----patience threshholds ---
  hunt = 10;
  fight = 5
  trynode = 10
  
  

*/

/*

*/
void() ai_state_hunt={
  if(ai_core_targetstate()){
    if(ai_target_visible(self.enemy)){
      //ai_update_statemove(ai_state_fight, ai_move_run_goal, FALSE);
      return;
    }
    else{
      self.patience = self.patience + 1;
      if(self.patience > self.maxpatience){
        self.patience = 0;
        //ai_update_statemove(ai_state_trynode, ai_move_walk_goal, TRUE);
      }
    }
  }
  else{
  
  }
};

/*void() ai_state_fight={
  if(ai_core_targetstate()){
    self.goalentity = self.enemy;
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if(!ai_target_visible(self.enemy)){
      self.ai_next_state = ai_state_hunt;
      return;
    }
    if(ai_target_insights(self.enemy)){
      if(self.stat_trg_dist > AI_RANGE_L){
        self.ai_next_move = ai_move_run_goal;
      }
      if(self.stat_trg_dist <= AI_RANGE_S){
        self.ai_next_move = ai_move_runmove_slide;
      }
    }
    else{
      if(ai_target_infront(self.enemy)){
        if(self.stat_trg_dist > AI_RANGE_M){
          self.ai_next_move = ai_move_run_goal;
        }
        if(self.stat_trg_dist <= 50){
          self.ai_next_move = ai_move_backward;
        }
        if((self.stat_trg_dist > 50) && (self.stat_trg_dist <= AI_RANGE_M)){
          self.ai_next_move = ai_move_walk_goal;
        }
      }
    }
    //self.th_missile();
  }
  else{
    if(self.oldenemy != world){
      self.enemy = self.oldenemy;
      self.oldenemy = world;
    }
  }
};*/

/*

*/
void() ai_state_wander={

};

/*

*/
void() ai_state_tonode={
  if(self.goalentity.classname == "ai_node"){
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    
    local entity contact;
    contact = ai_core_findtarget();
    if(contact != world){
      self.enemy = contact;
      self.oldgoal = self.goalentity;
      return;
    }
    
    traceline(self.origin, self.goalentity.origin, FALSE, self);
    if(trace_fraction < 1){
      self.movetarget = world;
      return;
    }
    self.ai_next_move = ai_move_walk_goal;
  }
};

/*

*/
void() ai_state_defend={
  
};

void() ai_state_ready={

  if(self.enemy != world){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  }
  else{
    local entity contact;
    contact = ai_core_findtarget();
    if(contact != world){
    }
  }
};

void() ai_state_panic={

};

void() ai_state_trynode={
  if(self.movetarget != world){
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    self.ai_next_move = ai_move_walk_goal;
  }
  else{
    self.oldgoal = self.goalentity;
    self.node_id = ai_core_trynode(self, self.oldgoal);
    local entity node;
    node = ai_core_findgraphnode(self.origin, self.ai_optical);
    if(node != world){
      self.goalentity = node;
      self.movetarget = self.goalentity; 
    }
    else{
      self.goalentity = self.oldgoal;
      self.oldgoal = world;
    }
  }
};
