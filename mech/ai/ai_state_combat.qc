/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai state implementation
  state: COMBAT
*/

//============================
//   COMBAT STATES          
//============================
void() ai_combat_findTarget={
  if(self.oldenemy != world){
    self.trigger_field = self.oldenemy;
    self.oldenemy = world;
    self.enemy = self.trigger_field;
    self.goalentity = self.trigger_field;
    if(ai_target_canSee(self.enemy)){
      ai_state_control(ai_combat_adjustPosition);
      return;
    }
    else{
      ai_state_control(ai_combat_huntTarget);
      return;
    }
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
        self.enemy = contact;
        self.goalentity = contact;
        //cons_logAString("CONTACT!", "found a baddy");
        //TODO switch to combat
        ai_state_control(ai_combat_huntTarget);
        return;
      }
    }
  }
  //didn't find anything? end the fight phase
  ai_target_clearBuffers();
  ai_state_control(ai_combat_endFight);
};

/*
  AI can't directly see its target, so it tries to hunt that target
  for a little bit.
  self.delay should timestamped before going into combat mode in another 
  state.
*/
void() ai_combat_huntTarget={
  if(ai_target_isValid(self.enemy)){
    //AI lost patience, will try a new target
    if(time > self.delay){
      if(ai_target_isValid(self.oldenemy)){
        ai_state_control(ai_combat_findTarget);
        return;
      }
      else{
        //AI had no old target, so end fight
        ai_target_clearBuffers();
        ai_state_control(ai_combat_endFight);
        return;
      }
    }
    else{
      //AI's patience is still holding, attempt to get 
      //optical view of target to engage
      ai_state_control(ai_combat_huntTarget);
      ai_move_controller(ai_move_run_goal, 0.02);
      return;
    }
  }
  else{
    if(self.oldenemy != world){
      if(ai_target_isValid(self.oldenemy)){
        ai_state_control(ai_combat_findTarget);
        return;
      }
      else{
        ai_target_clearBuffers();
        ai_state_control(ai_combat_endFight);
        return;
      }
    }
    ai_target_clearBuffers();
    ai_state_control(ai_combat_endFight);
    return;
  }
};

/*
  This function is for adjusting the combat position of the AI.
  It uses AI_QUIRKS, the combat range of all its remaining guns,
  and its orders to move a certain way.
*/
void() ai_combat_adjustPosition={
  
};

/*
  fight with target has ended, and there are no other targets in sight,
  so AI goes back to its current 'order' which is stored under 'self.state_1'
  and resumes that operation.
  AI should have stashed its last node in self.node before fighting...
*/
void() ai_combat_endFight={
  
  if(self.state_1 == AI_ORDER_ATTACK){
    ai_state_control(ai_assault_findNode);
  }
  else if(self.state_1 == AI_ORDER_DEFEND){
    ai_state_control(ai_defend_findNode);
  }
  else if(self.state_1 == AI_ORDER_PATROL){
    ai_state_control(ai_patrol_findNode);
  }
  else if(self.state_1 == AI_ORDER_STAND){
    ai_state_control(ai_misc_stand);
  }
  else if(self.state_1 == AI_ORDER_DEBUG){
    ai_state_control(ai_misc_stand_debug);
  }
  else{
    ai_state_control(ai_misc_stand);
  }
};