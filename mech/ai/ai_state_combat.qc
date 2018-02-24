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
/*
  
*/
void() ai_combat_findTarget={
  if(ai_target_isValid(self.oldenemy)){
    self.trigger_field = self.oldenemy;
    self.oldenemy = world;
    ai_update_switchToTarget(self.trigger_field);
    if(ai_target_canSee(self.enemy)){
      ai_state_control(ai_combat_adjustPosition);
      return;
    }
    self.patience = time + self.maxpatience;
    ai_state_control(ai_combat_huntTarget);
    return;
  }
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact;
      contact = ai_target_radarTarget();
      if(contact){
        ai_update_switchToTarget(contact);
        self.patience = time + self.maxpatience;
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

  te_beam_laser(self.origin, self.trigger_field.origin);  //DEBUG
  //defend stat override
  if(self.state_1 == AI_ORDER_DEFEND){ 
    if(self.stat_trg_dist > AI_DEFEND_DIST){
      ai_state_control(ai_combat_endFight);
      return;
    } 
  }
 
  if(ai_target_isValid(self.trigger_field)){
    //AI lost patience, will try a new target
    if(time > self.patience){
      if(ai_target_isValid(self.oldenemy)){
        self.trigger_field = self.oldenemy;
        self.oldenemy = world;
        ai_update_switchToTarget(self.trigger_field);
        ai_state_control(ai_combat_findTarget);
        return;
      }
      ai_state_control(ai_combat_endFight);
      return;
    }
    else{
      //check to see if AI can see target
      if(ai_target_canSee(self.trigger_field)){
        self.patience = 0;
        ai_state_control(ai_combat_adjustPosition);
        return;
      }
      //AI's patience is still holding, attempt to get 
      //optical view of target to engage
      ai_state_control(ai_combat_huntTarget);
      ai_move_controller(ai_move_run_goal, 0.02);
      return;
    }
  }
  if(ai_target_isValid(self.oldenemy)){
    ai_state_control(ai_combat_findTarget);
    return;
  }
  //AI didnt have an old enemy to go after
  //so clear the targets, and end the fight phase
  ai_state_control(ai_combat_endFight);
  return;
  
};

/*
  This function is for adjusting the combat position of the AI.
  It uses .style and .type fields, the combat range of all its remaining guns,
  and its orders to move a certain way.
  it executes a chosen sub state based on the AI's .style field
*/
void() ai_combat_adjustPosition={
  if(ai_target_isValid(self.trigger_field)){
    self.ideal_yaw = vectoyaw(self.trigger_field.origin - self.origin);
    if(self.state_1 == AI_ORDER_DEFEND){
      if(self.stat_trg_dist > AI_DEFEND_DIST){
        ai_state_control(ai_combat_endFight);
        return;
      }
    }
    //prepare combat state flags
    local float tDist, tMoveDir, lowHP;
    local entity eBlocker;
    tDist = vlen(self.trigger_field.origin - self.origin);
    tMoveDir = ai_util_calcTargetMoveDir(self.trigger_field, self);
    lowHP = ai_util_checkSelfHealth();
    eBlocker = ai_target_checkBlock(self.trigger_field);
    
    //enter proper combat stance
    if(ai_target_canSee(self.trigger_field)){
      if(self.ai_style == AI_STYLE_SNIPER){
        ai_combat_adjustSniper(tDist, AI_RANGE_M, AI_RANGE_L, tMoveDir, lowHP, eBlocker);
      }
      else if(self.ai_style == AI_STYLE_BRAWL){
        ai_combat_adjustBrawler(tDist, 250, AI_RANGE_S, tMoveDir, lowHP, eBlocker);
      }
      else if(self.ai_style == AI_STYLE_SKIRM){
        ai_combat_adjustSkirmish(tDist, (AI_RANGE_S - 100), AI_RANGE_L, tMoveDir, lowHP, eBlocker);
      }
      else if(self.ai_style == AI_STYLE_FLANK){
        ai_combat_adjustFlanker(tDist, 200, self.ai_minrange, tMoveDir, lowHP, eBlocker);
      }
      //AI will make an attack on the next frame
      self.button0 = 1;
    }
    else{
      if(ai_target_isValid(self.trigger_field)){
        //attempt to hunt
        self.delay = time + self.maxpatience;
        ai_state_control(ai_combat_huntTarget);
        return;
      }
      //maybe the AI has an old enemy that's visible?
      if(ai_target_isValid(self.oldenemy)){
        if(ai_target_canSee(self.oldenemy)){
          self.trigger_field = self.oldenemy;
          self.oldenemy = world;
          ai_update_switchToTarget(self.trigger_field);
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
      }
      ai_state_control(ai_combat_endFight);
      return;
    }
    ai_state_control(ai_combat_adjustPosition);
    return;
  }
  ai_state_control(ai_combat_endFight);
  return;
};

/*
  fight with target has ended, and there are no other targets in sight,
  so AI goes back to its current 'order' which is stored under 'self.state_1'
  and resumes that operation.
  AI should have stashed its last node in self.node before fighting...
*/
void() ai_combat_endFight={
  self.patience = 0;
  ai_target_clearBuffers();
  if(!ai_target_isValid(self.trigger_field)){
    self.trigger_field = world;
  }
  //clear out combat move
  ai_move_controller(ai_move_stand, 0.5);
  if(self.state_1 == AI_ORDER_ATTACK){
    ai_state_control(ai_assault_findNode);
    ai_move_controller(ai_move_stand, 0.1);
    return;
  }
  else if(self.state_1 == AI_ORDER_DEFEND){
    ai_state_control(ai_defend_findNode);
    ai_move_controller(ai_move_stand, 0.1);
    return;
  }
  else if(self.state_1 == AI_ORDER_PATROL){
    ai_state_control(ai_patrol_findNode);
    ai_move_controller(ai_move_stand, 0.1);
    return;
  }
  else if(self.state_1 == AI_ORDER_STAND){
    ai_state_control(ai_misc_stand);
    ai_move_controller(ai_move_stand, 1);
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