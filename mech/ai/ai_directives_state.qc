/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

/*

*/
void() ai_state_hunt={
  if(ai_core_targetstate()){
    if(!ai_target_visible(self.enemy)){
      if(self.oldenemy != world){
        self.oldenemy = self.enemy;
        return;
      }
      else{
        self.ai_patience = self.ai_patience + 10;
      }
    }
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    ChangeYaw();
    if(!ai_target_infront(self.enemy)){
      self.ai_patience = self.ai_patience + 1;
      return;
    }
    if(!ai_target_facingideal()){
      self.ai_patience = self.ai_patience + 1;
      return;
    }
    if(self.stat_trg_dist < AI_RANGE_S / 6){
      self.ai_next_move = ai_move_backward;
    }
    else if(self.stat_trg_dist > AI_RANGE_L){
      self.ai_next_move = ai_move_run;
    }
    else if(self.stat_trg_dist <=  AI_RANGE_S){
      if(self.enemy.enemy == self){
        local entity t, os;
        os = self;
        self = self.enemy;
          if(ai_target_infront(os)){
            os.ai_next_move = ai_move_run_slide;
          }
          else{
           os.ai_next_move = ai_move_walk;
          } 
        self = os;
      }
    }
    self.th_missile();
  } 
  else{
    self.goalentity = world;
    self.enemy = world;
    self.ai_next_state = ai_state_ready;
    self.ai_next_move = ai_move_stand;
  }
};

/*

*/
void() ai_state_wander={

};

/*

*/
void() ai_state_tonode={
  if(self.goalentity.classname == "ai_node"){
    local float d;
    d = vlen(self.goalentity.origin - self.origin);
    if(d <= 10){
      if(self.health <= (self.max_health /3)){
        self.ai_next_state = ai_state_panic;
        self.ai_next_move = ai_move_run;
      }
    }
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    self.ai_next_move = ai_move_walk;
  }
  else{
    if(ai_core_findnode()){
      self.ai_next_move = ai_move_walk;
    }
    else{
      self.ai_next_state = ai_state_ready;
      self.ai_next_move = ai_move_stand;
    }
  }
};

/*

*/
void() ai_state_defend={
  
};

void() ai_state_ready={
  if(ai_core_findtarget()){
    if(self.ai_next_state != ai_state_hunt){
      self.ai_next_state = ai_state_hunt;
      self.ai_next_move = ai_move_run;
    }
  }
  else{
    if(ai_core_findnode()){
      self.ai_next_state = ai_state_tonode;
      self.ai_next_move = ai_move_run;
    }
    else{
      self.ai_next_move = ai_move_stand;
    }
  }
};

void() ai_state_panic={
  if(self.goalentity != world){
    local float d;
    d = vlen(self.goalentity.origin - self.origin);
    if(d <= 15){
      if(ai_core_panicnode()){
        return;
      }
      else{
        self.ai_next_state = ai_state_ready;
        self.ai_next_move = ai_move_stand;
      }
    }
    else{
      self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
      self.ai_next_move = ai_move_run;
    }    
  }
  else{
    if(ai_core_panicnode()){
      self.ai_next_state = ai_state_panic;
      self.ai_next_move = ai_move_run;
    }
    else{
      self.ai_next_state = ai_state_ready;
      self.ai_next_move = ai_move_stand;
    }
  }
};
