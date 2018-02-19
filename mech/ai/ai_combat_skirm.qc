/*
mech Mod
Author: Peter Roohr
Date: 2/15/2018
Overview: ai combat state sub function
  basically moving these functions to their own files because of
  their complexity
 
SKIRMISHER FUNCTIONS
*/

/*
  Skirmishers are the default, they engage in their optimal range bracket
  and have the most all-round movement profile. 
  float distClose = range that is 'too close';
  float distFar = range that is 'too far';
*/
void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustSkirmish={
  local float isClose, isFar, distOptimal, blockDist;
  /*
    flags
      distClose - target is inside min range
      distFar - target is outside range
      distOptimal - is AI in its own optimal range
      tMovedir - move direction relative to self
      type - the behavior type of AI
      rank - how skilled the AI is
  */
  if(targDist <= distClose){
    isClose = TRUE;
  }
  else{
    isClose = FALSE;
  }
  
  if(targDist > distFar){
    isFar = TRUE;
  }
  else{
    isFar = FALSE;
  }
  if(targDist <= self.ai_minrange){
    distOptimal = TRUE;
  }
//==================================================

//CASE: target is blocked by something else
  if((eBlocker != world) && (eBlocker != self.trigger_field)){
    local float blockDir;
    blockDir = ai_util_calcTargetMoveDir(eBlocker, self);
    if(eBlocker.i_faction == self.i_faction){
      //oops, friendly is in the way, try to move around
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_FWD)){
        local float d2;
        d2 = util_roll_dice(2);
        if(d2 == 1){
          ai_move_controller(ai_move_walkmove_strafeleft, 1);
        }
        else{
          ai_move_controller(ai_move_walkmove_straferight, 1);
        }
        return;
      }
      if(blockDir == AI_TARG_RGT){
        ai_move_controller(ai_move_walkmove_strafeleft, 2);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        ai_move_controller(ai_move_walkmove_straferight, 2);
        return;
      }
    }
    else{
      //enemy is in the way
      //AI is super aggressive
      if(self.ai_type == AI_TYPE_AGGRO){
        if(vlen(eBlocker.origin - self.origin) <= isClose){
          //blocker is in AI's aggressive face
          if(self.p_damage >= 2){
            //low rank, aggressive AI's will attack the blocker
            ai_update_switchToTarget(eBlocker);
          }
        }
        if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_FWD)){
          ai_move_randomSix(2, ai_move_runmove_slideleft,
                                ai_move_runmove_slideright, 
                                ai_move_charge_left, 
                                ai_move_charge_right,
                                ai_move_runmove_slideright, 
                                ai_move_runmove_slideleft);
          return;
        }
        else{
          if(blockDir == AI_TARG_RGT){
            ai_move_controller(ai_move_runmove_slideleft, 2);
            return;
          }
          if(blockDir == AI_TARG_LFT){
            ai_move_controller(ai_move_runmove_slideright, 2);
            return;
          }
        }
      }
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_FWD)){
        local float d2;
        d2 = util_roll_dice(2);
        if(d2 == 1){
          ai_move_controller(ai_move_runmove_slideleft, 1);
        }
        else{
          ai_move_controller(ai_move_runmove_slideright, 1);
        }
        return;
      }
      if(blockDir == AI_TARG_RGT){
        ai_move_controller(ai_move_runmove_slideleft, 2);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        ai_move_controller(ai_move_runmove_slideright, 2);
        return;
      }
      return;
    }
  }
//==================================================
  
//CASE: Target is too close
  if(isClose){
    if(ai_target_isInFront(self.trigger_field)){
      //AI is facing its target
      if(ai_util_compareYawIdeal(vectoyaw(self.trigger_field.origin - self.origin))){
        //AI's yaw is aligned to target
        if(self.ai_type == AI_TYPE_AGGRO){
          ai_move_randomSix(3, ai_move_runmove_slideleft, 
                                ai_move_charge_left, 
                                ai_move_walkmove_backright, 
                                ai_move_walkmove_backleft, 
                                ai_move_charge_right, 
                                ai_move_runmove_slideright); 
          return;
        }
        if(self.ai_type == AI_TYPE_COWRD){
          ai_move_controller(ai_run_backward, 4);
          return;
        }
        ai_move_randomThree(1.5, ai_move_walkmove_backleft, 
                                ai_move_walkmove_backright, 
                                ai_run_backward);
        return;
      }
      ai_move_randomThree(1, ai_move_runmove_slideleft, 
                        ai_move_runmove_slideright, 
                        ai_run_backward);
      return;
    }
    else{
      //AI's target isn't in front
      if(ai_target_isFacingThis(self.trigger_field)){
        //AI is in sight of its target
        
        return;
      }
    }
    return;
  }
//=================================================
  
//CASE: Target is too far away
  if(isFar){
    if(ai_target_isInFront(self.trigger_field)){
      ai_move_controller(ai_run_forward, 2);
      return;
    }
    ai_move_controller(ai_move_stand, 0.5);
    return;
  }
//=================================================
  
//CASE: Target is in engagement range
  //target is in the optimal range for AI
  if(targDist <= distOptimal){
    if(tMovedir == AI_TARG_FWD){
      if((self.ai_type == AI_TYPE_COWRD) || (self.p_damage <= AI_RANK_REG)){
        ai_move_randomThree(1, ai_move_walkmove_backleft, 
                                ai_move_walkmove_backright, 
                                ai_run_backward);
      }
      else{
        ai_move_randomThree(1, ai_move_runmove_slideleft, 
                                ai_move_runmove_slideright, 
                                ai_move_forward);
      }      
    }
    else if(tMovedir == AI_TARG_BKD){
      if((self.ai_type == AI_TYPE_COWRD) || (self.p_damage <= AI_RANK_REG)){
        ai_move_controller(ai_move_forward, 2);
      }
      else{
        ai_move_controller(ai_run_forward, 1);
      }
    }
    else if(tMovedir == AI_TARG_LFT){
      if(self.p_damage == AI_RANK_ROK){
        ai_move_randomThree(2, ai_move_walkmove_strafeleft, 
                                ai_move_walkmove_strafeleft, 
                                ai_move_walkmove_straferight);
      }
      else{
        local float d2;
        d2 = util_roll_dice(2);
        if(d2 == 1){
          ai_move_controller(ai_move_walkmove_strafeleft, 1);
        }
        else{
          ai_move_controller(ai_move_walkmove_straferight, 1);
        }
      }
    }
    else if(tMovedir == AI_TARG_RGT){
      if(self.p_damage == AI_RANK_ROK){
        ai_move_randomThree(2, ai_move_walkmove_straferight, 
                                ai_move_walkmove_straferight, 
                                ai_move_walkmove_strafeleft);
      }
      else{
        local float d2;
        d2 = util_roll_dice(2);
        if(d2 == 1){
          ai_move_controller(ai_move_walkmove_strafeleft, 1);
        }
        else{
          ai_move_controller(ai_move_walkmove_straferight, 1);
        }
      }
    }
    return;
  }
  //target is not in optimal range
  ai_move_randomSix(3, ai_move_runmove_slideleft, 
                        ai_move_charge_left, 
                        ai_move_walkmove_backright, 
                        ai_move_walkmove_backleft, 
                        ai_move_charge_right, 
                        ai_move_runmove_slideright); 
    return;
//=================================================
};
