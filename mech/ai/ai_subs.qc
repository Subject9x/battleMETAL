/*
mech Mod
Date: 6/18/2017
Overview: sub-states or subs are intermediary states of behavior that
link the main ai_order states together, sometimes actings as a go-between;
*/

/*================================================================
[Fight]
AI has a target in open-sights and will move to engage 
================================================================*/
void() ai_sub_fight={
  if(ai_core_targetstate()){
    if(self.ai_prev_state == ai_sub_hunt){
      if(!ai_target_visible(self.enemy)){
        self.enemy = world;
        self.ai_prev_state = self.ai_next_state;
        self.ai_next_state = self.ai_first_order;
        return;
      }
    }
    if(ai_target_visible(self.enemy)){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      if(self.stat_trg_dist > self.ai_minrange){
        ai_move_controller(ai_move_forward, 4);
      }
      else if(self.stat_trg_dist <= 100){
        if(ai_target_insights(self.enemy)){
          if(ai_target_facingideal()){
            ai_move_controller(ai_move_charge, 6);
          }
          else{
            ai_move_random();
          }
        }
        else{
          ai_move_controller(ai_move_backward, 4);
        } 
      }
      else{
        if(self.stat_trg_dist > self.ai_minrange/2){
          ai_move_controller(ai_move_forward, 2);
        }
        else{
          if(ai_target_insights(self.enemy)){
            ai_move_controller(ai_move_walkmove_straferight, 6);
          }
          else{
            ai_move_controller(ai_move_stand, 2);
          }
        }
      }
      if(ai_target_facingideal()){
        self.button0 = 1;
      }
      return;
    }
    else{
      self.patience = self.patience + 1;
      if(self.patience >= self.maxpatience){
        self.patience = 0;
        self.ai_prev_state = self.ai_next_state;
        self.ai_next_state = ai_sub_hunt;
        return;
      }
      self.ai_prev_state = self.ai_next_state;
      self.ai_next_state = ai_sub_fight;
      return;
    }
  }
  else{
    if(self.enemy != world){
      self.enemy = world;
    }
    self.goalentity = self.oldgoal;
    self.ai_next_state = self.ai_prev_state;
    self.ai_prev_state = ai_sub_fight;
    return;
  }
};

/*================================================================
  condition: AI had a target but lost Line of sight,
  attempt to use the movetogoal functionality to find the target again;
  
================================================================*/
void() ai_sub_hunt={
  if(ai_core_targetstate()){
    //target is still valid
    if(ai_target_visible(self.enemy)){
      //target is visible
      //bprint("-> ai_sub_fight\n"); //DEBUG
      self.goalentity = self.oldgoal;
      self.oldgoal = world;
      self.ai_prev_state = self.ai_next_state;
      self.ai_next_state = ai_sub_fight;
      return;
    }
    else{
      //bprint("hunting non-visible\n"); //DEBUG
      self.oldgoal = self.goalentity;
      self.goalentity = self.enemy;
      if(self.stat_trg_dist >= AI_RANGE_L){
        //self.ai_next_move = ai_move_run_goal;
        ai_move_controller(ai_move_run_goal, 1);
      }
      else{
        //self.ai_next_move = ai_move_walk_goal;
        ai_move_controller(ai_move_walk_goal, 1);
      }
      self.patience = self.patience + 1;
      if(self.patience >= self.maxpatience){
        if(self.ai_first_order == ai_order_defend){
          if(self.stat_trg_dist >= AI_RANGE_S){
            self.enemy = world;
            self.ai_prev_state = self.ai_next_state;
            self.ai_next_state = self.ai_first_order;
            return;
          }
        }
        if(self.ai_first_order == ai_order_patrol){
          local float p;
          p = vlen(self.oldgoal.origin - self.origin);
          if(p >= AI_RANGE_S){
            self.enemy = world;
            self.ai_prev_state = self.ai_next_state;
            self.ai_next_state = self.ai_first_order;
            return;
          }
        }
        //bprint("patience hit!\n"); //DEBUG
        self.patience = 0;
        local float nd, ng;
        local entity node, nodeg;
        nd = vlen(self.origin - self.enemy.origin);
        node = ai_core_nodetogoal(self, self.enemy);
        if(node){
          //bprint("enemy close to node\n"); //DEBUG
          self.ai_prev_state = self.ai_next_state;
          if(node.node_id){
            //node is a node_graph node
            self.node_id = node.node_id;
            self.oldgoal = node;
            self.ai_prev_state = self.ai_next_state;
            self.ai_next_state = ai_sub_trynode;
            return;
          }
          else{
            self.goalentity = node;
            self.ai_prev_state = self.ai_next_state;
            self.ai_next_state = ai_sub_tonode;
            return;
          }
        }
        else{
         // bprint("enemy not close to node\n"); //DEBUG
          self.goalentity = self.oldgoal;
          self.oldgoal = world;
          self.ai_next_state = self.ai_prev_state;
          return;
        }
      }
    }
  }
  else{
    if(self.ai_prev_state == self.ai_first_order){
     // bprint("-> first order\n"); //DEBUG
      self.goalentity = self.oldgoal;
      self.oldgoal = world;
      self.ai_next_state = self.ai_first_order;
      return;
    }
    else{
      //bprint("prev state\n"); //DEBUG
      self.goalentity = self.oldgoal;
      self.oldgoal = world;
      self.ai_next_state = self.ai_prev_state;
      return;
    }
  }
};

/*================================================================
  condition:
================================================================*/
void() ai_sub_tonode={
  if(self.ai_prev_state == ai_sub_trynode){
    if(self.goalentity == self.oldgoal){
      //bprint("exiting tonode - reason: trynode succeed\n"); //DEBUG
      self.oldgoal = world;
      self.ai_prev_state = self.ai_next_state;
      self.ai_next_state = self.ai_first_order;
      return;
    }
  }
  local entity t;
  t = ai_core_findtarget();
  if(t != world){
    //bprint("target!\n"); //DEBUG
    //bprint("-> ai_sub_fight\n"); //DEBUG
    self.enemy = t;
    self.oldgoal = self.goalentity;
    self.ai_prev_state = self.ai_next_state;
    self.ai_next_state = ai_sub_fight;
    return;
  }
  if(self.goalentity != world){
    traceline(self.origin, self.goalentity.origin, FALSE, self);
    if(trace_fraction == 1){
      local float d;
      self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
      d = vlen(self.goalentity.origin - self.origin);
      if(d > AI_RANGE_L){
        ai_move_controller(ai_move_run_goal, 1);
      }
      else{
        ai_move_controller(ai_move_walk_goal, 1);
      }
    }
    else{
      local float v;
      d = vlen(self.dest2 - self.origin);
      if(d <= 1){
        self.patience = self.patience + 1;
        if(self.patience >= self.maxpatience * 10){
          self.patience = 0;
          self.oldgoal = self.goalentity;
          self.node_id = ai_core_trynode(self, self.oldgoal);
          local entity node;
          node = ai_core_findgraphnode(self.origin, self.ai_optical);
          if(node != world){
            self.goalentity = node;
            self.movetarget = self.goalentity; 
          }
          self.ai_prev_state = self.ai_next_state;
          self.ai_next_state = ai_sub_trynode;
          return;
        }
      }
      self.dest2 = self.origin;
    }
  }
  else{
    self.ai_next_state = self.ai_first_order;
    self.ai_prev_state = ai_sub_tonode;
    return;
  }
};

/*================================================================
  condition:
================================================================*/
void() ai_sub_trynode={
  if(self.oldgoal != world){
   // bprint("ai_sub_trynode\n"); //DEBUG
    if(self.goalentity == self.oldgoal){
      //bprint("found goal\n"); //DEBUG
      //have reached goal
      self.ai_next_state = self.ai_prev_state;
      self.ai_prev_state = ai_sub_trynode;
      return;
    }
    else{
      //bprint("execute ai_sub_trynode\n"); //DEBUG
      local float d;
      self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
      d = vlen(self.goalentity.origin - self.origin);
      if(d > AI_RANGE_L){
        ai_move_controller(ai_move_run_goal, 1);
      }
      else{
        ai_move_controller(ai_move_walk_goal, 1);
      }
    }
  }
  else{
    self.ai_next_state = self.ai_prev_state;
    self.ai_prev_state = ai_sub_trynode;
    return;
  }
};

/*================================================================
  condition:
================================================================*/
void() ai_sub_wander={
};