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
  return;
};

/*
  AI can't directly see its target, so it tries to hunt that target
  for a little bit.
  self.delay should timestamped before going into combat mode in another 
  state. self.delay should be time + 'patience' where patience is 
  calculated by the ai_core function of similiar name
*/
void() ai_combat_huntTarget={
  if(ai_target_isValid(self.enemy)){
    //AI lost patience, will try a new target
    if(time > self.delay){
      if(ai_target_isValid(self.oldenemy)){
        cons_logAString("ai_combat_huntTarget->", "ai_combat_findTarget"); // DEBUG
        ai_state_control(ai_combat_findTarget);
        return;
      }
      else{
        //AI had no old target, so end fight
        cons_logAString("ai_combat_huntTarget->", "ai_combat_endFight"); // DEBUG
        ai_target_clearBuffers();
        ai_state_control(ai_combat_endFight);
        return;
      }
    }
    else{
      //check to see if AI can see target
      if(ai_target_visualPing(self.enemy)){
        self.delay = self.delay - time; //caching remaining patience
        ai_state_control(ai_combat_adjustPosition);
        cons_logAString("ai_target_visualPing", "true"); // DEBUG
        return;
      }
      else{
        //AI's patience is still holding, attempt to get 
        //optical view of target to engage
        cons_logAString("ai_combat_huntTarget->", "ai_combat_huntTarget"); // DEBUG
        ai_state_control(ai_combat_huntTarget);
        ai_move_controller(ai_move_run_goal, 0.02);
        return;
      }
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
    //AI didnt have an old enemy to go after
    //so clear the targets, and end the fight phase
    ai_target_clearBuffers();
    ai_state_control(ai_combat_endFight);
    return;
  }
};

/*
  This function is for adjusting the combat position of the AI.
  It uses .style and .type fields, the combat range of all its remaining guns,
  and its orders to move a certain way.
  it executes a chosen sub state based on the AI's .style field
*/
void() ai_combat_adjustPosition={
  self.ideal_yaw = vectoyaw(self.trigger_field.origin - self.origin);
  if(ai_target_visualPing(self.trigger_field)){
    if(self.ai_style == AI_STYLE_SNIPER){
      ai_combat_adjustSniper();
    }
    else if(self.ai_style == AI_STYLE_BRAWL){
      ai_combat_adjustBrawler();
    }
    else if(self.ai_style == AI_STYLE_SKIRM){
      ai_combat_adjustSkirmish();
    }
    else if(self.ai_style == AI_STYLE_FLANK){
      ai_combat_adjustFlanker();
    }
    if(ai_target_canSee(self.trigger_field)){
      self.button0 = 1;
    }
  }
  else{
    self.delay = time + (ai_pilot_rating_patience() / 2); //TODO - patience mod
    ai_state_control(ai_combat_huntTarget);
    return;
  }
};

/*
  Snipers generally try to stay at long range, and will attempt 
  to move away from the target if the target gets too close...
  hopefully you didnt make it a RESCU sniper...
*/
void() ai_combat_adjustSniper={
  local float tDist, isTooClose, isTooFar;
  tDist = vlen(self.enemy.origin - self.origin);
  isTooClose = FALSE;
  isTooFar = FALSE;
  if(tDist <= AI_RANGE_M){
    isTooClose = TRUE;
  }
  if(tDist > AI_RANGE_L){
    isTooFar = TRUE;
  }
  if(self.ai_type == AI_TYPE_NORML){
    if(isTooClose){
      ai_move_controller(ai_move_backward, 0.5);
      return;
    }
    if(isTooFar){
      ai_move_controller(ai_move_forward, 0.5);
      return;
    }
    ai_move_controller(ai_move_stand, 1);
    return;
  }
  else if(self.ai_type == AI_TYPE_AGGRO){
    if(isTooClose){
      ai_move_controller(ai_run_backward, 0.05);
      return;
    }
    if(isTooFar){
      ai_move_controller(ai_run_forward, 0.05);
      return;
    }
    ai_move_controller(ai_move_stand, 0.05);
    return;
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    ai_move_controller(ai_move_stand, 0.05);
    return;
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    ai_move_controller(ai_move_stand, 0.05);
    return;
  }
};

/*
  They stay at close range, and hammer away at the target.
*/
void() ai_combat_adjustBrawler={
  if(self.ai_type == AI_TYPE_NORML){
  
  }
  else if(self.ai_type == AI_TYPE_AGGRO){
  
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    
  }

};

/*
  Skirmishers are the default, they engage in their optimal range bracket
  and have the most all-round movement profile. 
*/
void() ai_combat_adjustSkirmish={
  if(self.ai_type == AI_TYPE_NORML){
  
  }
  else if(self.ai_type == AI_TYPE_AGGRO){
  
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    
  }
};

/*
  As the name suggests, flankers are obsessed with circling around
  the target to get back shots, and also strafe a lot too.
*/
void() ai_combat_adjustFlanker={
  if(self.ai_type == AI_TYPE_NORML){
  
  }
  else if(self.ai_type == AI_TYPE_AGGRO){
  
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    
  }
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
    return;
  }
  else if(self.state_1 == AI_ORDER_DEFEND){
    ai_state_control(ai_defend_findNode);
    return;
  }
  else if(self.state_1 == AI_ORDER_PATROL){
    ai_state_control(ai_patrol_findNode);
    return;
  }
  else if(self.state_1 == AI_ORDER_STAND){
    ai_state_control(ai_misc_stand);
    return;
  }
  else if(self.state_1 == AI_ORDER_DEBUG){
    ai_state_control(ai_misc_stand_debug);
    return;
  }
  else{
    ai_state_control(ai_misc_stand);
    return;
  }
};