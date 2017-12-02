/*
mech Mod
Date: 6/18/2017
Overview: ai orders, these are the top-level states
that the AI moves between, with the original order being stored as a fallback behavior
*/


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
        self.goalentity = restore;
      }
    }
  }
  local entity t;
  if(t){
    self.enemy = t;
    self.ai_prev_state = ai_order_defend;
    self.ai_next_state = ai_sub_fight;
    return;
  }
  local float d;
  d = vlen(self.goalentity.origin - self.origin);
  if(d <= AI_RANGE_S){
    self.ai_next_move = ai_move_stand;
  }
  else{
    //self.ai_prev_state = self.ai_first_order;
    //self.ai_next_state = ai_sub_tonode;
    return;
  }
};


/*================================================================
[Dummy]
AI is ordered to stand around and generally do nothing, literally nothing
but stand there and look pretty
================================================================*/
void() ai_order_test={
};
