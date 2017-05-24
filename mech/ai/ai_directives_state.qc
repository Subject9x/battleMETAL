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
    //self.goalentity = self.enemy;
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    if(!ai_target_infront(self.enemy)){
      self.ai_patience = self.ai_patience + 1;
      return;
    }
    if(!ai_target_facingideal()){
      self.ai_patience = self.ai_patience + 1;
      return;
    }
    if(self.stat_trg_dist > (self.radar_range / 2)){
      self.ai_next_move = ai_move_run;
    }
    else{
      self.ai_next_move = ai_move_walk;
      if(self.stat_trg_dist < 200){
        self.ai_next_move = ai_move_run_slide;
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
    self.ai_next_move = ai_move_stand;
  }
};

void() ai_state_panic={
  if(self.goalentity != world){
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    self.ai_next_move = ai_move_run;
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
