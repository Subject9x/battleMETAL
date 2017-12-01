/*
mech Mod
Date: 6/18/2017
Overview: sub-states or subs are intermediary states of behavior that
link the main ai_order states together, sometimes actings as a go-between;
*/


/*
new order to ai subs
patrol
  - find node
  - go to node
  - reach node
  
defend
  - go to target
  - stick around target
  - listen on target
  - fight
  - take next order
 
attack
  - go to target
  - fight
  - take next order

*/

/*
  specifically searches for ai_nodes that are made for patrol path
*/
void() ai_find_patrol_node={
  if(!self.goalentity){
    local entity n;
    n = ai_find_patrol_node_recurse(self);
    if(n){
      self.goalentity = n;
      self.ai_next_state = ai_goto_patrol_node;
    }
    else {
      self.ai_first_order = AI_ORDER_STAND;
      self.ai_next_state = ai_sweep_stand;
    }
  }
};

void() ai_goto_patrol_node={
  local float dist;
  local entity f;
  f = ai_core_radar_sweep();
  if(f){
    self.enemy = f;
    self.oldgoal = self.goalentity;
    self.ai_next_state = ai_hunt_target;
    self.ai_prev_state = ai_goto_patrol_node;
  }
  dist = vlen(self.goalentity.origin - self.origin);
  if(dist >= AI_RANGE_L){
    ai_move_controller(ai_move_run_goal, self.w_clipsize);
  }
  else if(dist <= 64){
    self.ai_next_state = ai_at_patrol_node;
    self.delay = time + self.goalentity.pausetime; 
    ai_move_controller(ai_move_stand, 1);
  }
  else{
    ai_move_controller(ai_move_walk_goal, self.w_clipsize);
  }
};

void() ai_at_patrol_node={
  local entity f;
  f = ai_core_radar_sweep();
  if(f){
    self.enemy = f;
    self.oldgoal = self.goalentity;
    self.ai_next_state = ai_hunt_target;
    self.ai_prev_state = ai_at_patrol_node;
  }
  if(time >= self.delay){
    local entity n;
    n = ai_find_patrol_node_recurse(self.goalentity);
    if(n){
      self.goalentity = n;
      self.ai_next_state = ai_goto_patrol_node;
    }
    else{
     self.ai_next_state = ai_sweep_stand; 
    }
  }
  else{
    ai_move_controller(ai_move_stand, 1);
  }
};


void() ai_hunt_target={
  if(ai_core_targetstate()){
    if(ai_target_visible(self.enemy)){
      self.ai_next_state = ai_sub_fight;
    }
    else{
      if(ai_target_insights(self.enemy)){
        
      }
      else{
        if(!self.stat_rdr_mode){
          self.stat_rdr_mode = TRUE;
        }
        traceline(self.origin, self.enemy.origin + '0 0 64', TRUE, self);
        if(trace_fraction <= 0.25){
          self.enemy = world;
          self.goalentity = self.oldgoal;
          self.ai_next_state = self.ai_prev_state;
          self.stat_rdr_mode = FALSE;
        }
        else{
          self.goalentity = self.enemy;
          ai_move_controller(ai_move_walk_goal, 2);
          self.maxpatience = time + 2;
        }  
      }
      if(time > self.maxpatience){
        self.enemy = world;
        self.goalentity = self.oldgoal;
        self.stat_rdr_mode = FALSE;
        if(self.ai_prev_state == ai_at_patrol_node){
          self.ai_next_state = ai_at_patrol_node;
        }
        else if(self.ai_prev_state == ai_goto_patrol_node){
          self.ai_next_state = ai_goto_patrol_node;
        }
      }
    }
  }
  else{
    self.goalentity = self.oldgoal;
    self.enemy = world;
    self.ai_next_state = self.ai_prev_state;
    self.stat_rdr_mode = FALSE;
  }
};

void() ai_sweep_stand={
  local entity f;
  f = ai_core_radar_sweep();
  if(f){
    self.enemy = f;
    self.oldgoal = self.goalentity;
    self.ai_next_state = ai_hunt_target;
  }
  else{
    self.ai_next_state = ai_sweep_stand;
    ai_move_controller(ai_move_stand, self.vec_size);
  }
};


/*================================================================
[Fight]
AI has a target in open-sights and will move to engage 
================================================================*/
void() ai_sub_fight={
  if(ai_core_targetstate()){
    self.stat_rdr_mode = TRUE;
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if(ai_target_visible(self.enemy)){
      if(self.stat_trg_dist < 100){
        if(self.p_damage == 0){
          ai_move_controller(ai_run_backward, self.w_clipsize + self.vec_size);
        }
        else if((self.p_damage == 1) || (self.p_damage == 2)){
          ai_move_controller(ai_run_backward, self.w_clipsize + self.vec_size);
        }
        else{
          ai_move_controller(ai_run_backward, self.w_clipsize + self.vec_size);
        }
      }
      else{
        if(self.stat_trg_dist >= AI_RANGE_L){
          if(self.ai_prev_move == ai_move_forward){
            local float coin;
            coin = (1+crandom() * 2);
            coin = floor(coin);
            if(coin < 0){
              coin = coin *-1;
            }
            if(coin){
              ai_move_controller(ai_move_runmove_slideleft, self.w_clipsize + self.vec_size);            
            }
            else{
              ai_move_controller(ai_move_runmove_slideright, self.w_clipsize + self.vec_size);            
            }
          }
          else{
            ai_move_controller(ai_run_forward, self.w_clipsize);
          }
        }
        else{
          local float dice;
          dice = (1+crandom() * 7);
          dice = floor(dice);
          if(dice < 0){
            dice = dice *-1;
          }
          if(dice == 0){
            //0
            ai_move_controller(ai_run_forward, self.vec_size);
          }
          else if(dice == 1){
            //45
            ai_move_controller(ai_move_charge_right, self.w_clipsize /2 + self.vec_size); 
          }
          else if(dice == 2){
            //90
            ai_move_controller(ai_move_walkmove_straferight, self.w_clipsize/2 + self.vec_size); 
          }
          else if(dice == 3){
             //135
            ai_move_controller(ai_move_walkmove_straferight, self.w_clipsize/2 + self.vec_size); 
          }
          else if(dice == 4){
            //180
            ai_move_controller(ai_move_backward, self.w_clipsize/2 + self.vec_size);
          }
          else if(dice == 5){
             //235
            ai_move_controller(ai_move_walkmove_strafeleft, self.w_clipsize/2 + self.vec_size);
          }
          else if(dice == 6){
             //270
            ai_move_controller(ai_move_walkmove_strafeleft, self.w_clipsize/2 + self.vec_size);
          }
          else if(dice == 7){
             //315
            ai_move_controller(ai_move_charge_left, self.w_clipsize/2 + self.vec_size);
          }
        }
      }
      if(ai_target_facingideal()){
        self.button0 = 1;
      }
    }
    else{
      self.ai_next_state = ai_hunt_target;
      self.maxpatience = time + 10;
    }
  }
};