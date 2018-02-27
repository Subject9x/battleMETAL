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
  local float isClose, isFar, isEnemy, isTarget, distOptimal, blockDist, amt;
  isClose = FALSE;
  isFar = FALSE;
  isEnemy = FALSE;
  isTarget = FALSE;
  distOptimal = FALSE;
  
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
  if(targDist > distFar){
    isFar = TRUE;
  }
  if(targDist <= self.ai_minrange){
    distOptimal = TRUE;
  }
  if(self.trigger_field.enemy == self){
    if(ai_target_isInFront(self.trigger_field)){
      isTarget = TRUE;
    }
  }
//==================================================

//CASE: target is blocked by something else
  if((eBlocker != world) && (eBlocker != self.trigger_field)){
    local float blockDir;
    blockDir = ai_util_calcTargetMoveDir(eBlocker, self);
    if(eBlocker.i_faction == self.i_faction){
      //oops, friendly is in the way, try to move around
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD)){
        ai_move_randomTwo(1, ai_move_walkmove_strafeleft, ai_move_walkmove_straferight);
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
        if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD)){
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
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD)){
        ai_move_randomTwo(1, ai_move_runmove_slideleft, ai_move_runmove_slideright);
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
    if(tMovedir == AI_TARG_FWD){
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = self.p_damage + 1;
        ai_move_randomTwo(amt, ai_move_runmove_backleft, ai_move_runmove_backright);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        amt = self.p_damage + 1;
        ai_move_randomTwo(amt, ai_move_walkmove_backleft, ai_move_walkmove_backright);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomTwo(4, ai_move_runmove_backleft, ai_move_runmove_backright);
        return;
      }
      ai_move_randomThree(6, ai_move_walkmove_backleft, 
                              ai_move_walkmove_backright,
                              ai_move_backward);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_BKD){
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = self.p_damage + 1;
        ai_move_randomTwo(amt, ai_move_runmove_slideleft, ai_move_runmove_slideright);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        amt = self.p_damage + 1;
        ai_move_randomTwo(amt, ai_move_walkmove_backleft, ai_move_walkmove_backright);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomTwo(2, ai_move_runmove_backleft, ai_move_runmove_backright);
        return;
      }
      ai_move_randomThree(4, ai_move_walkmove_backleft, 
                              ai_move_walkmove_backright,
                              ai_move_backward);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          ai_move_randomTwo(1, ai_move_runmove_slideright, ai_move_runmove_backright);
          return;
        }
        ai_move_controller(ai_move_runmove_backright, 1);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_randomTwo(self.p_damage + 3, ai_move_backward, ai_move_walkmove_backright);
        return;
      }
      ai_move_randomTwo(self.p_damage + 1, ai_move_backward, ai_move_walkmove_backright);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          ai_move_randomTwo(1, ai_move_runmove_slideright, ai_move_runmove_backleft);
          return;
        }
        ai_move_controller(ai_move_runmove_backleft, 1);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_randomTwo(self.p_damage + 3, ai_move_backward, ai_move_walkmove_backleft);
        return;
      }
      ai_move_randomTwo(self.p_damage + 1, ai_move_backward, ai_move_walkmove_backleft);
      return;
    }
    //--------------------------
    if(self.ai_type == AI_TYPE_AGGRO){
    
    }
    if(self.ai_type == AI_TYPE_COWRD){
      amt = self.p_damage + 4;
      ai_move_randomThree(amt, ai_run_backward,
                                ai_move_runmove_backright,
                                ai_move_runmove_backleft);
      return;
    }
    if(self.p_damage <= AI_RANK_VET){
      if(isTarget){
        ai_move_randomFour(util_roll_dice(2), ai_move_runmove_slideleft,
                                                ai_move_runmove_slideright,
                                                ai_move_runmove_backright,
                                                ai_move_runmove_backleft);
        return;
      }
    }
    ai_move_randomThree(self.p_damage, ai_run_backward,
                                        ai_move_walkmove_backleft,
                                        ai_move_walkmove_backright);
    return;
  }
//=================================================
  
//CASE: Target is too far away
  if(isFar){
    if(tMovedir == AI_TARG_FWD){
      amt = self.p_damage + 2;
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = amt / 2;
        ai_move_randomTwo(amt, ai_move_charge_left,
                                  ai_move_charge_right);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        amt = amt + 2;
      }
      if(self.p_damage <= AI_RANK_VET){
        amt = amt - 2;
        ai_move_randomTwo(amt,  ai_move_charge_left,
                                 ai_move_charge_right);
        return;
      }
      ai_move_randomThree(amt, ai_move_forward,
                                ai_move_walkmove_forwardright,
                                ai_move_walkmove_forwardleft);
      return;
    }
    if(tMovedir == AI_TARG_BKD){
      amt = self.p_damage + 2;
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = amt / 2;
        ai_move_randomThree(amt, ai_run_forward,
                                  ai_move_charge_left,
                                  ai_move_charge_right);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        amt = amt + 2;
      }
      if(self.p_damage <= AI_RANK_VET){
        amt = amt - 2;
        ai_move_randomTwo(amt,  ai_move_charge_left,
                                 ai_move_charge_right);
        return;
      }
      ai_move_randomThree(amt, ai_move_forward,
                                ai_move_walkmove_forwardright,
                                ai_move_walkmove_forwardleft);
      return;
    }
    if(tMovedir == AI_TARG_LFT){
      amt = self.p_damage + 2;
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = amt / 2;
        ai_move_controller(ai_move_charge_left, amt);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        amt = amt + 2;
      }
      if(self.p_damage <= AI_RANK_VET){
        amt = amt - 2;
        ai_move_randomTwo(amt,  ai_run_forward,
                                 ai_move_charge_right);
        return;
      }
      ai_move_randomTwo(amt, ai_move_forward,
                                ai_move_walkmove_forwardright);
      return;
    }
    if(tMovedir == AI_TARG_RGT){
      amt = self.p_damage + 2;
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = amt / 2;
        ai_move_controller(ai_move_charge_right, amt);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        amt = amt + 2;
      }
      if(self.p_damage <= AI_RANK_VET){
        amt = amt - 2;
        ai_move_randomTwo(amt,  ai_run_forward,
                                 ai_move_charge_right);
        return;
      }
      ai_move_randomTwo(amt, ai_move_forward,
                                ai_move_walkmove_forwardright);
      return;
    }
    if(ai_target_isInFront(self.trigger_field)){
      ai_move_controller(ai_run_forward, self.p_damage);
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
      return;
    }
    else if(tMovedir == AI_TARG_BKD){
      if((self.ai_type == AI_TYPE_COWRD) || (self.p_damage <= AI_RANK_REG)){
        ai_move_controller(ai_move_forward, 2);
      }
      else{
        ai_move_controller(ai_run_forward, 1);
      }
      return;
    }
    else if(tMovedir == AI_TARG_LFT){
      if(self.p_damage == AI_RANK_ROK){
        ai_move_randomThree(2, ai_move_walkmove_strafeleft, 
                                ai_move_walkmove_strafeleft, 
                                ai_move_walkmove_straferight);
        return;
      }
      else{
        ai_move_randomTwo(1, ai_move_walkmove_strafeleft, ai_move_walkmove_straferight);
        return;
      }
    }
    else if(tMovedir == AI_TARG_RGT){
      if(self.p_damage == AI_RANK_ROK){
        ai_move_randomThree(2, ai_move_walkmove_straferight, 
                                ai_move_walkmove_straferight, 
                                ai_move_walkmove_strafeleft);
        return;
      }
      else{
        ai_move_randomTwo(1, ai_move_walkmove_strafeleft, ai_move_walkmove_straferight);
        return;
      }
    }
  }
  else{
    //Target is outside optimal range
    if(self.ai_type == AI_TYPE_AGGRO){
      ai_move_randomThree(6, ai_run_forward, 
                            ai_move_charge_right, 
                            ai_move_charge_left);
      return;
    }
    if(self.p_damage >= AI_RANK_REG){
      ai_move_controller(ai_move_forward, 4);
      return;
    }
    ai_move_controller(ai_run_forward, 8);
    return;
  }
  ai_move_randomSix(3, ai_move_runmove_slideleft, 
                        ai_move_charge_left, 
                        ai_move_walkmove_backright, 
                        ai_move_walkmove_backleft, 
                        ai_move_charge_right, 
                        ai_move_runmove_slideright); 
  return;
//=================================================
};
