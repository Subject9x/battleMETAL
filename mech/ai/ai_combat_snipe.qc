/*
mech Mod
Author: Peter Roohr
Date: 2/15/2018
Overview: ai combat state sub function
  basically moving these functions to their own files because of
  their complexity
 
SNIPER FUNCTIONS
*/


/*
  Snipers generally try to stay at long range, and will attempt 
  to move away from the target if the target gets too close...
  hopefully you didnt make it a RESCU sniper...
  float distClose = range that is 'too close';
  float distFar = range that is 'too far';
*/
void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustSniper={
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
