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
  local float isClose, isFar, distOptimal, blockDist, isEnemy, isTarget, amt;
  isClose = FALSE;
  isFar = FALSE;
  distOptimal = FALSE;
  if(targDist <= distClose){
    isClose = TRUE;
  }
  if(targDist > distFar){
    isFar = TRUE;
  }
  isEnemy = FALSE;
  isTarget = FALSE;
  if(self.trigger_field.trigger_field == self){
    if(ai_target_isInFront(self.trigger_field)){
      isEnemy = TRUE;
      isTarget = TRUE;
    }
  }
//CASE: target is blocked by something else
  if( (eBlocker != world) && (eBlocker != self.trigger_field) ){
    local float blockDir, blockClose;
    blockDist = vlen(eBlocker.origin - self.origin);
    blockClose = FALSE;
    if(blockDist <= isClose){
      blockClose = TRUE;
    }
    blockDir = ai_util_calcTargetMoveDir(eBlocker, self);
    if(eBlocker.i_faction == self.i_faction){
      amt = 3 + self.p_damage; 
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = amt - floor(amt / 2);
      }
      if(blockDir == AI_TARG_FWD){
        if(blockClose){
          ai_move_randomTwo(amt, ai_move_walkmove_strafeleft, ai_move_walkmove_straferight);
          return;
        }
        ai_move_randomTwo(amt, ai_move_walkmove_backleft, ai_move_walkmove_backright);
        return;
      }
      if(blockDir == AI_TARG_BKD){
        if(blockClose){
          ai_move_randomTwo(amt, ai_move_walkmove_forwardleft, ai_move_walkmove_forwardright);
          return;
        }
        ai_move_randomTwo(amt, ai_move_walkmove_strafeleft, ai_move_walkmove_straferight);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        if(blockClose){
          ai_move_controller(ai_move_walkmove_backright, amt);
          return;
        }
        ai_move_controller(ai_move_walkmove_straferight, amt);
        return;
      }
      if(blockDir == AI_TARG_RGT){
        if(blockClose){
          ai_move_controller(ai_move_walkmove_backleft, amt);
          return;
        }
        ai_move_controller(ai_move_walkmove_strafeleft, amt);
        return;
      }
    }
    else{      
      amt = 2 + self.p_damage; 
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = amt - floor(amt / 2);
      }
      if(blockDir == AI_TARG_FWD){
        if(blockClose){
          amt = amt + 2;
          ai_move_randomTwo(amt, ai_move_runmove_slideleft, ai_move_runmove_slideright);
          return;
        }
        ai_move_randomTwo(amt, ai_move_runmove_backleft, ai_move_runmove_backright);
        return;
      }
      if(blockDir == AI_TARG_BKD){
        if(blockClose){
          amt = amt + 2;
          ai_move_randomTwo(amt, ai_move_charge_left, ai_move_charge_right);
          return;
        }
        ai_move_randomTwo(amt, ai_move_walkmove_forwardleft, ai_move_walkmove_forwardright);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        if(blockClose){
          amt = amt + 2;
          ai_move_controller(ai_move_runmove_backright, amt);
          return;
        }
        ai_move_controller(ai_move_runmove_slideright, amt);
        return;
      }
      if(blockDir == AI_TARG_RGT){
        if(blockClose){
          amt = amt + 2;
          ai_move_controller(ai_move_runmove_backleft, amt);
          return;
        }
        ai_move_controller(ai_move_runmove_slideleft, amt);
        return;
      }
    }
    return;
  }
//=================================================

//CASE: Target is too close - yes its possible to be to close
  if(isClose){
    if( (tMovedir == AI_TARG_FWD) || (tMovedir == AI_TARG_BKD) ){
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = 4;
        if(self.p_damage <= AI_RANK_VET){
          amt = amt + 2;
        }
        if(isEnemy){
          if(isTarget){
            ai_move_randomTwo(amt, ai_move_runmove_backleft, ai_move_runmove_backright);
            return;
          }
        }
        ai_move_controller(ai_run_backward, amt);
        return;
      }
      //rookie snipers freeze
      if(self.ai_type == AI_TYPE_COWRD){
        if(isEnemy){
          if(isTarget){
            if(self.p_damage == AI_RANK_ROK){
              ai_move_randomThree(0.5, ai_move_stand,
                                      ai_move_stand,
                                      ai_run_backward);
              return;
            }
          }
          ai_move_controller(ai_run_backward, 6);
          return;
        }
        ai_move_randomTwo(6, ai_move_backward, ai_run_backward);
        return;
      }
      if(isEnemy){
        if(isTarget){
          ai_move_randomTwo(8, ai_move_charge_left, ai_move_charge_right);
          return;
        }
      }
      ai_move_randomThree(4, ai_run_backward,
                              ai_move_walkmove_backleft,
                              ai_move_walkmove_backright);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = 4;
        if(self.p_damage <= AI_RANK_VET){
          amt = amt + 2;
        }
        if(isEnemy){
          if(isTarget){
            ai_move_controller(ai_move_runmove_slideright, amt);
            return;
          }
        }
        ai_move_controller(ai_move_runmove_backright, amt);
        return;
      }
      ai_move_controller(ai_move_walkmove_backright, 4);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = 4;
        if(self.p_damage <= AI_RANK_VET){
          amt = amt + 2;
        }
        if(isEnemy){
          if(isTarget){
            ai_move_controller(ai_move_runmove_slideleft, amt);
            return;
          }
        }
        ai_move_controller(ai_move_runmove_backleft, amt);
        return;
      }
      ai_move_controller(ai_move_walkmove_backleft, 4);
      return;
    }
    //--------------------------
  }
//=================================================

//CASE: Target is too far away
  if(isFar){
    if( (tMovedir == AI_TARG_FWD) || (tMovedir == AI_TARG_BKD) ){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(isEnemy){
          if(isTarget){
            ai_move_randomTwo(2, ai_move_charge_left, ai_move_charge_right);
            return;
          }
        }
        ai_move_controller(ai_run_forward, 0.5);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        if(isEnemy){
          if(isTarget){
            ai_move_randomTwo(0.5, ai_move_walkmove_strafeleft, ai_move_walkmove_straferight);
            return;
          }
        }
        ai_move_controller(ai_move_forward, 0.5);
        return;
      }
      if(isEnemy){
        if(isTarget){
          ai_move_randomTwo(3, ai_move_walkmove_forwardleft, ai_move_walkmove_forwardright);
          return;
        }
      }
      ai_move_controller(ai_move_forward, 3);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){ 
        amt = self.p_damage + 1;
        if(isEnemy){
          if(isTarget){
            ai_move_controller(ai_move_charge_right, amt);
            return;
          }
        }
        ai_move_controller(ai_run_forward, amt);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        if(isEnemy){
          if(isTarget){
            ai_move_controller(ai_move_forward, 0.5);
            return;
          }
        }
        ai_move_controller(ai_move_walkmove_forwardright, 0.5);
        return;
      }
      if(isEnemy){
        if(isTarget){
          ai_move_controller(ai_move_walkmove_forwardright, 2);
          return;
        }
      }
      ai_move_controller(ai_move_forward, 1);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        amt = self.p_damage + 1;
        if(isEnemy){
          if(isTarget){
            ai_move_controller(ai_move_charge_left, amt);
            return;
          }
        }
        ai_move_controller(ai_run_forward, amt);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        if(isEnemy){
          if(isTarget){
            ai_move_controller(ai_move_forward, 0.5);
            return;
          }
        }
        ai_move_controller(ai_move_walkmove_forwardleft, 0.5);
        return;
      }
      if(isEnemy){
        if(isTarget){
          ai_move_controller(ai_move_walkmove_forwardleft, 2);
          return;
        }
      }
      ai_move_controller(ai_move_forward, 1);
      return;
    }
    //--------------------------
    ai_move_controller(ai_move_forward, 2);
    return;;
  }
//=================================================
  
//CASE: Target is in engagement range
  if(targDist < AI_RANGE_M){
    if(tMovedir == AI_TARG_FWD){
      if(isEnemy){
        if(isTarget){
          amt = 1;
          if(self.ai_type == AI_TYPE_AGGRO){
            amt = 0.5;
          }
          amt = amt + self.p_damage;
          ai_move_randomFour(amt, ai_move_runmove_slideleft, 
                                  ai_move_runmove_slideright, 
                                  ai_move_runmove_backright, 
                                  ai_move_runmove_backleft);
          return;
        }
      }
      if(self.ai_type == AI_TYPE_AGGRO){
        ai_move_controller(ai_run_backward, 0.5);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_controller(ai_move_backward, 2);
        return;
      }
      ai_move_controller(ai_move_backward, 1);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_BKD){
      if(isEnemy){
        if(isTarget){
          amt = 1;
          if(self.ai_type == AI_TYPE_AGGRO){
            amt = 0.5;
          }
          amt = amt + self.p_damage;
          ai_move_randomFour(amt, ai_move_runmove_slideleft, 
                                  ai_move_runmove_slideright, 
                                  ai_move_charge_left, 
                                  ai_move_charge_right);
          return;
        }
      }

      if(self.ai_type == AI_TYPE_AGGRO){
        ai_move_controller(ai_run_forward, 0.5);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_controller(ai_run_forward, 2);
        return;
      }
      ai_move_controller(ai_run_forward, 1);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_LFT){
      if(isEnemy){
        if(isTarget){
          if(self.ai_type == AI_TYPE_AGGRO){
            ai_move_controller(ai_move_runmove_slideright, 2);
            return;
          }
          if(self.ai_type == AI_TYPE_COWRD){
            ai_move_controller(ai_move_walkmove_straferight, 4);
            return;
          }
          ai_move_controller(ai_move_walkmove_straferight, 2);
          return;
        }
      }

      if(self.ai_type == AI_TYPE_AGGRO){
        ai_move_controller(ai_move_runmove_slideleft, 4);
        return;
      }
      ai_move_controller(ai_move_stand, 1);
      return;
    }
    //--------------------------
    if(tMovedir == AI_TARG_RGT){
      if(isEnemy){
        if(isTarget){
          if(self.ai_type == AI_TYPE_AGGRO){
            ai_move_controller(ai_move_runmove_slideleft, 2);
            return;
          }
          if(self.ai_type == AI_TYPE_COWRD){
            ai_move_controller(ai_move_walkmove_strafeleft, 4);
            return;
          }
          ai_move_controller(ai_move_walkmove_strafeleft, 2);
          return;
        }
      }
      if(self.ai_type == AI_TYPE_AGGRO){
        ai_move_controller(ai_move_runmove_slideright, 4);
        return;
      }
      ai_move_controller(ai_move_stand, 1);
      return;
    }
    //--------------------------
  }
 
  if(isEnemy){
    if(isTarget){
      if(self.ai_type == AI_TYPE_AGGRO){
        ai_move_randomFour(self.p_damage + 1, ai_move_charge_left,
                            ai_move_charge_right,
                            ai_move_runmove_slideleft,
                            ai_move_runmove_slideright);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_randomThree(self.p_damage, ai_run_backward,
                              ai_move_runmove_backleft,
                              ai_move_runmove_backright);
        return;
      }
    }
  }
  amt = 1 + self.p_damage;
  if(self.ai_type == AI_TYPE_AGGRO){
    amt = amt / 2;
  }
  if(self.ai_type == AI_TYPE_COWRD){
    amt = amt + 1;
  }
  ai_move_controller(ai_move_stand, amt);
  return;
//=================================================
};
