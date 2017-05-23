/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

/*

*/
void() ai_state_hunt={
  if(self.enemy != world){
    if(ai_core_targetstate()){
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
      if(self.stat_trg_dist > (self.radar_range / 2)){
        self.ai_next_move = ai_move_run;
      }
      else{
        self.ai_next_move = ai_move_walk;
      }
      if(!ai_target_visible(self.enemy)){
        self.oldenemy = self.enemy;
        self.enemy = world;
        return;
      }
      if(!ai_target_infront(self.enemy)){
        self.ai_patience = self.ai_patience + 1;
        return;
      }
      if(!ai_target_facingideal()){
        self.ai_patience = self.ai_patience + 1;
        return;
      }
      self.th_missile();
    } 
    else{
      self.goalentity = self;
      self.enemy = world;
      self.ai_next_state = ai_state_ready;
      self.ai_next_move = ai_move_stand;
      //default out of hunting
    }
  }
  else{
    self.ai_next_state = ai_state_ready;
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
  if(self.goalentity != world){
    if(self.goalentity != self){
      if(self.ai_next_state == ai_state_tonode){
        self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
      }
    }
  }
};

/*

*/
void() ai_state_defend={
  
};

void() ai_state_ready={
  if(ai_core_findtarget()){
    self.ai_next_state = ai_state_hunt;
  }
};