/*
mech Mod
Date: 6/18/2017
Overview: ai orders, these are the top-level states
that the AI moves between, with the original order being stored as a fallback behavior
*/

/*================================================================
[Attack]
AI has a entity it must Attack
================================================================*/
void() ai_order_attack={
  if(self.ai_prev_state != ai_order_attack){
    self.patience = 0;
  }
  if(ai_core_targetstate()){
    //target is still valid
    if(ai_target_visible(self.enemy)){
      //target is visible
      if(self.ai_first_order == ai_order_attack){
        self.ai_prev_state = self.ai_first_order;
      }
      else{
        self.ai_prev_state = self.ai_next_state;
      }
      self.ai_next_state = ai_sub_fight;
      return;
    }
    else{
      //target has become invisible
      if(self.ai_first_order == ai_order_attack){
        self.ai_prev_state = self.ai_first_order;
      }
      else{
        self.ai_prev_state = self.ai_next_state;
      }
      self.ai_next_state = ai_sub_hunt;
      return;
    }
  }
  else{
    //target is no longer valid
    self.ai_prev_state = ai_order_attack;
    if(self.ai_first_order != ai_order_attack){
      self.ai_next_state = self.ai_first_order;
    }
    else{
      self.ai_next_state = ai_order_stand;
    }
  }
};


/*================================================================
[Defend]
AI has a entity it must defend
================================================================*/
void() ai_order_defend={
  if(self.ai_prev_state != ai_order_defend){
    local entity restore;
    restore = find(world, targetname, self.target);
    if(restore != self.goalentity){
      if(restore != world){
        //bprint("restoring entity\n");
        self.goalentity = restore;
      }
    }
  }
};

/*================================================================
[Patrol]

================================================================*/
void() ai_order_patrol={
  if(self.ai_prev_state != ai_order_patrol){
    local entity restore;
    restore = find(world, targetname, self.target);
    if(restore != self.goalentity){
      //bprint("restoring entity\n");
      self.goalentity = restore;
    }
  } 

  //bprint("ai_order_stand\n"); //DEBUG
  local entity t;
  t = ai_core_findtarget();
  if(t){
    //bprint("target!\n"); //DEBUG
    //bprint("-> ai_sub_fight\n"); //DEBUG
    self.enemy = t;
    self.ai_prev_state = ai_order_stand;
    self.ai_next_state = ai_sub_fight;
    return;
  }
  if(self.goalentity != world){
    self.dest2 = self.origin;
    self.ai_next_state = ai_sub_tonode;
    self.ai_prev_state = self.ai_first_order;
  }
  else{
    self.ai_next_state = ai_order_stand;
    self.ai_prev_state = self.ai_first_order;
  }
};

/*================================================================
[Stand]
AI is ordered to stand around and generally do nothing
================================================================*/
void() ai_order_stand={
  if(self.ai_prev_state != ai_order_stand){
    local entity restore;
    restore = find(world, targetname, self.target);
    if(restore != self.goalentity){
      //bprint("restoring entity\n");
      self.goalentity = restore;
    }
  }
  local float d;
  d = vlen(self.goalentity.origin - self.origin);
  if(d <= AI_RANGE_S){
    self.ai_next_move = ai_move_stand;
  }
  else{
    self.ai_prev_state = self.ai_first_order;
    self.ai_next_state = ai_sub_tonode;
    return;
  }
  //bprint("ai_order_stand\n"); //DEBUG
  local entity t;
  t = ai_core_findtarget();
  if(t){
    //bprint("target!\n"); //DEBUG
    //bprint("-> ai_sub_fight\n"); //DEBUG
    self.enemy = t;
    self.ai_prev_state = ai_order_stand;
    self.ai_next_state = ai_sub_fight;
    return;
  }
};
