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
        ai_update_switchToTarget(contact);
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
  //defend stat override
  if(self.stat_trg_dist > AI_DEFEND_DIST){
    ai_state_control(ai_combat_endFight);
    if(self.delay > time){
      self.delay = time;
    }
    return;
  }
  if(ai_target_isValid(self.trigger_field)){
    //AI lost patience, will try a new target
    if(time > self.delay){
      if(ai_target_isValid(self.oldenemy)){
        ai_state_control(ai_combat_findTarget);
        return;
      }
      else{
        //AI had no old target, so end fight
        ai_state_control(ai_combat_endFight);
        return;
      }
    }
    else{
      //check to see if AI can see target
      if(ai_target_canSee(self.enemy)){
        self.delay = self.delay - time; //caching remaining patience
        ai_state_control(ai_combat_adjustPosition);
        return;
      }
      else{
        //AI's patience is still holding, attempt to get 
        //optical view of target to engage
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
        ai_state_control(ai_combat_endFight);
        return;
      }
    }
    //AI didnt have an old enemy to go after
    //so clear the targets, and end the fight phase
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
  if(self.state_1 == AI_ORDER_DEFEND){
    if(self.stat_trg_dist > AI_DEFEND_DIST){
      ai_state_control(ai_combat_endFight);
      return;
    }
  }
  if(ai_target_canSee(self.trigger_field)){
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
    //AI will make an attack on the next frame
    self.button0 = 1;
  }
  else{
    //maybe the AI has an old enemy that's visible?
    if(self.oldenemy != world){
      if(ai_target_isValid(self.oldenemy)){
        if(ai_target_visualPing(self.oldenemy)){
          self.trigger_field = self.oldenemy;
          self.oldenemy = world;
          self.enemy = self.trigger_field;
          self.goalentity = self.trigger_field;
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
      }
    }
    //no LoS and no old enemy, attempt to hunt
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
  local float tDist, isTooClose, isTooFar, isBlockedFriend, isBlockedEnemy;
  local entity eBlocker;
  tDist = vlen(self.enemy.origin - self.origin);
  isTooClose = FALSE;
  isTooFar = FALSE;
  isBlockedFriend = FALSE;
  isBlockedEnemy = FALSE;
  if(tDist <= AI_RANGE_M){
    isTooClose = TRUE;
  }
  if(tDist > AI_RANGE_L){
    isTooFar = TRUE;
  }
  eBlocker = ai_target_checkBlock(self.trigger_field);
  if(eBlocker != world){
    if(eBlocker.i_faction == self.i_faction){
      isBlockedFriend = TRUE;
    }
    else{
      isBlockedEnemy = TRUE;
    }
  }
  
  if(self.ai_type == AI_TYPE_NORML){
    if(isTooClose){
      ai_move_controller(ai_move_backward, 0.75);
      return;
    }
    if(isTooFar){
      ai_move_controller(ai_move_forward, 0.75);
      return;
    }
    if(isBlockedFriend){
      ai_move_controller(ai_move_walkmove_strafeleft, 1);
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
  //tooClose = 50 game units
  //tooFar = 1200 game units
  //stubbing out with comments
  local float tDist, isTooClose, isTooFar, isBlockedFriend, isBlockedEnemy, isTargetCharge;
  local entity eBlocker;
  tDist = vlen(self.enemy.origin - self.origin);
  isTooClose = FALSE;
  isTooFar = FALSE;
  isBlockedFriend = FALSE;
  isBlockedEnemy = FALSE;
  if(tDist < (AI_RANGE_S / 5 )){
    isTooClose = TRUE;
  }
  if(tDist > AI_RANGE_S){
    isTooFar = TRUE;
  }
  eBlocker = ai_target_checkBlock(self.trigger_field);
  if(eBlocker != world){
    if(eBlocker.i_faction == self.i_faction){
      isBlockedFriend = TRUE;
    }
    else{
      isBlockedEnemy = TRUE;
    }
  }
  if(self.ai_type == AI_TYPE_AGGRO){
    /*
      stay very close to target
      strafe with target (keeps attention)
      always be running
    */
    if(isBlockedEnemy){
      if( ai_target_isInFront(eBlocker) ){
        //aggro enemies blast through everything O.o
        self.button0 = 1;
      }
      else{
        //attempt to rush around obstacle
        ai_state_control(ai_combat_huntTarget);
        ai_move_controller(ai_move_run_goal, 1);
        self.delay = time + 10;
        return;
      }
    }
    if(isBlockedFriend){
      //attempt to rush around obstacle
      ai_state_control(ai_combat_huntTarget);
      ai_move_controller(ai_move_run_goal, 1);
      self.delay = time + 10;
      return;
    }
    if(isTooFar){
      if(ai_target_isInFront(self.trigger_field)){
        //take a swipe
        self.button0 = 1; 
        ai_move_controller(ai_run_forward, 2);
      }
      else{
        if(crandom() == TRUE){
          ai_move_controller(ai_move_runmove_slideleft, 0.5);
        }
        else{
          ai_move_controller(ai_move_runmove_slideright, 0.5);
        }
      }
      ai_state_control(ai_combat_adjustPosition);
      return;
    }
    
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    /*
      if not near designated friendly
        move to friendly
      else
        switch to enemy,
        execute normal brawling
    */
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    /*
      take pulse on health, hp, and shields
      
    */
  }
  else{
    /*
      normal brawling:
        enemy coming at bot -> move back and slide left/right
        enemy moving away -> charge and slide left/right
        enemy strafe -> counter strafe
        random movement -> 
    */
    
    if(isBlockedEnemy){
      //brawlers gonna brawl
      if(eBlocker.data_type != DATA_BLD){
        ai_update_switchToTarget(eBlocker);
        ai_state_control(ai_combat_adjustPosition);
        return;
      }
      else{
        ai_state_control(ai_combat_huntTarget);
        ai_move_controller(ai_move_run_goal, 2);
        self.delay = time + 20;
        return;
      }
    }
    
    //will attempt to maneuver around friends;
    if(isBlockedFriend){
      ai_state_control(ai_combat_huntTarget);
      ai_move_controller(ai_move_run_goal, 2);
      self.delay = time + 20;
      return;
    }
    
    local float tVel, scopeLeft, scopeRight;
    scopeLeft = anglemod(self.ideal_yaw - 15);
    scopeRight = anglemod(self.ideal_yaw + 15);
    tVel = vectoyaw(self.trigger_field.velocity);
    //check if target is facing this AI
    if( ai_target_isFacingThis(self.trigger_field) ){
      if( (tVel > scopeLeft) && (tVel < scopeRight) ){
        //target is coming towards the bot
        if(crandom() == TRUE){
          ai_move_controller(ai_move_charge_left, 4);
          return;
        }
        else{
          ai_move_controller(ai_move_charge_right, 4);
          return;
        }
      }
    } 
    
  }

};

/*
  Skirmishers are the default, they engage in their optimal range bracket
  and have the most all-round movement profile. 
*/
void() ai_combat_adjustSkirmish={
  if(self.ai_type == AI_TYPE_AGGRO){
  
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    
  }
  else{
    /*
      'normal' mode
    */
    
  }
};

/*
  As the name suggests, flankers are obsessed with circling around
  the target to get back shots, and also strafe a lot too.
*/
void() ai_combat_adjustFlanker={
  /*
    Aggro flankers - 
      will circle strafe aggressively at full speed
      have a higher chance of switching strafe direction
    
    Rescue flanker - 
      
    
    Coward flanker -
      if behind the target, aggressively stay behind this target
  */
  if(self.ai_type == AI_TYPE_AGGRO){
  
  }
  else if(self.ai_type == AI_TYPE_RESCU){
    
  }
  else if(self.ai_type == AI_TYPE_COWRD){
    
  }
  else{
    /*
      'normal' mode
    */
  }
};

/*
  fight with target has ended, and there are no other targets in sight,
  so AI goes back to its current 'order' which is stored under 'self.state_1'
  and resumes that operation.
  AI should have stashed its last node in self.node before fighting...
*/
void() ai_combat_endFight={
  ai_target_clearBuffers();
  //clear out the delay var so that it can be reused by nodes
  if(time < self.delay){
    self.delay = time;
  }
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