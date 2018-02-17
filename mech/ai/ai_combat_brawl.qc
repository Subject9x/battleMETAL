/*
mech Mod
Author: Peter Roohr
Date: 2/15/2018
Overview: ai combat state sub function
  basically moving these functions to their own files because of
  their complexity
 
BRAWLER FUNCTIONS
*/

/*
  They stay at close range, and hammer away at the target.
  float distClose = range that is 'too close';
  float distFar = range that is 'too far';
*/
void(float targDist, float distClose, float distFar) ai_combat_adjustBrawler={
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
