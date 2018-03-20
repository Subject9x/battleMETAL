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
void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustBrawler={
  local float isClose, isFar, distOptimal, blockDist, amt;
  isClose = FALSE;
  isFar = FALSE;
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
  if( !(isClose) && (targDist <= self.ai_minrange)){
    distOptimal = TRUE; //maybe disregard?
  }
//==================================================
//CASE: target is blocked by something else
  if((eBlocker != world) && (eBlocker != self.trigger_field)){
    local float blockDir;
    blockDir = ai_util_calcTargetMoveDir(eBlocker, self);
    if(eBlocker.i_faction == self.i_faction){
      //oops, friendly is in the way, try to move around
      local float amt;
      amt = ceil(0.25 + self.p_damage);  //worse pilots are badly aggressive
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD)){
        if(self.ai_type == AI_TYPE_AGGRO){
          ai_move_randomSix(amt, ai_move_walkmove_strafeleft, 
                      ai_move_walkmove_straferight, 
                      ai_move_runmove_slideleft, 
                      ai_move_runmove_slideright,
                      ai_move_charge_left, 
                      ai_move_charge_right);
          return;
        }
        ai_move_randomSix(1.5, ai_move_backward, 
                              ai_run_backward, 
                              ai_move_walkmove_backleft, 
                              ai_move_walkmove_backleft,
                              ai_move_walkmove_backright, 
                              ai_move_walkmove_backright);
        return;
      }      
      if(self.ai_type == AI_TYPE_AGGRO){
        //AGGRO overrides nuance
        ai_move_randomThree(amt, ai_move_charge_left,
                                  ai_move_charge_right,
                                  ai_move_backward);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        //COWARDS aren't great
        ai_move_controller(ai_move_stand, 1);
        return;
      }
      if(blockDir == AI_TARG_RGT){
        ai_move_randomSix(1, ai_move_walkmove_strafeleft, 
                                ai_move_runmove_slideleft, 
                                ai_move_backward,
                                ai_move_walkmove_backleft,
                                ai_move_walkmove_strafeleft,
                                ai_move_runmove_slideleft);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        ai_move_randomSix(1, ai_move_walkmove_straferight, 
                                ai_move_runmove_slideright, 
                                ai_move_backward,
                                ai_move_walkmove_backright,
                                ai_move_walkmove_straferight,
                                ai_move_runmove_slideright);
        return;
      }
    }
    else{
      //enemy is in the way
      //AI is super aggressive
      if(self.ai_type == AI_TYPE_AGGRO){
        if(vlen(eBlocker.origin - self.origin) <= isClose){
          //blocker is in AI's aggressive face
          if(self.p_damage >= 1){
            //low rank, aggressive AI's will attack the blocker
            ai_update_switchToTarget(eBlocker);
          }
        }
        if(blockDir == AI_TARG_FWD ){
          ai_move_randomSix(1, ai_move_runmove_slideleft,
                                ai_move_runmove_slideright, 
                                ai_move_charge_left, 
                                ai_move_charge_right,
                                ai_move_runmove_slideright, 
                                ai_move_runmove_slideleft);
          return;
        }
        if(blockDir == AI_TARG_BKD){
          ai_move_randomThree(1.5, ai_move_charge_left,
                                  ai_move_charge_right,
                                  ai_move_forward);
          return;
        }
        if(blockDir == AI_TARG_RGT){
          ai_move_randomThree(2, ai_move_walkmove_strafeleft, 
                                  ai_move_runmove_slideleft, 
                                  ai_move_walkmove_backleft);
          return;
        }
        if(blockDir == AI_TARG_LFT){
          ai_move_randomThree(2, ai_move_walkmove_straferight, 
                                  ai_move_runmove_slideright, 
                                  ai_move_walkmove_backright);
          return;
        }
      }
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD)){
        ai_move_randomSix(1.5, ai_move_backward, 
                              ai_run_backward, 
                              ai_move_walkmove_backleft, 
                              ai_move_walkmove_backleft,
                              ai_move_walkmove_backright, 
                              ai_move_walkmove_backright);
        return;
      }
      if(self.ai_type == AI_TYPE_AGGRO){
        //AGGRO overrides nuance
        ai_move_randomThree(amt, ai_move_charge_left,
                                  ai_move_charge_right,
                                  ai_move_backward);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        //COWARDS aren't great
        ai_move_controller(ai_move_stand, 1);
        return;
      }
      if(blockDir == AI_TARG_RGT){
        ai_move_controller(ai_move_runmove_slideleft, 0.5);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        ai_move_controller(ai_move_runmove_slideright, 0.5);
        return;
      }
      return;
    }
  }
//==================================================
  
//CASE: Target is too close - yes its possible to be to close
  if(isClose){
    //layer 1 - tMovedir
      //layer 2 - ai type
        //layer 3 - ai rank
          //layer 4 - target facing
    if(tMovedir == AI_TARG_FWD){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          if(ai_target_isFacingThis(self.trigger_field)){
            if(self.trigger_field.trigger_field == self){
              ai_move_randomFour(2, ai_move_charge_right,
                                    ai_move_charge_left,
                                    ai_move_runmove_slideleft,
                                    ai_move_runmove_slideright);
              return;
            }
          }
          ai_move_randomFour(1, ai_move_runmove_slideleft,
                                  ai_move_runmove_slideright,
                                  ai_move_runmove_backleft,
                                  ai_move_runmove_backright);
          return;
        }
        //else
        ai_move_randomFour(1, ai_move_runmove_slideleft,
                        ai_move_runmove_slideright,
                        ai_move_runmove_backleft,
                        ai_move_runmove_backright);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_randomThree(ceil((self.p_damage * 1.25) / 2), ai_move_walkmove_backleft,
                          ai_move_walkmove_backright,
                          ai_move_backward);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomTwo(1, ai_move_charge_left, ai_move_charge_right);
        return;
      }
      ai_move_randomTwo(0.5, ai_move_runmove_backright,ai_move_runmove_backleft);
      return;
    }
    //------------------------
    if(tMovedir == AI_TARG_BKD){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          //vets and aces - cool under fire
          if(ai_target_isFacingThis(self.trigger_field)){
            if(self.trigger_field.trigger_field == self){
              //target is aiming at the bot
              ai_move_randomSix(2, ai_move_runmove_slideleft,
                                    ai_move_runmove_slideright,
                                    ai_move_charge_left,
                                    ai_move_charge_right,
                                    ai_move_walkmove_strafeleft,
                                    ai_move_walkmove_straferight);
              return;
            }
          }
          ai_move_randomThree(1, ai_move_charge_left,
                                  ai_move_charge_right,
                                  ai_run_backward);
          return;
        }
        //else
        ai_move_randomThree(2, ai_move_walkmove_backleft,
                                ai_move_walkmove_backright,
                                ai_run_backward);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        if(self.p_damage <= AI_RANK_REG){
          ai_move_controller(ai_move_stand, 1);
          return;
        }
        ai_move_randomThree(1.5, ai_move_stand,
                                ai_move_backward,
                                ai_move_backward);
        return;
      }
      //else
      ai_move_randomTwo(1.5, ai_move_runmove_slideleft, ai_move_runmove_slideright);
      return;
    }
    //------------------------
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          ai_move_randomFour(2, ai_move_charge_right, 
                                ai_move_runmove_slideright, 
                                ai_run_backward, 
                                ai_move_runmove_backright);
          return;
        }
        //else
        ai_move_randomTwo(1, ai_move_runmove_backright, ai_move_runmove_slideright);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_randomThree(2, ai_move_stand, 
                                ai_move_walkmove_backright, 
                                ai_move_walkmove_straferight);
        return;
      }
      //else
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomThree(3, ai_move_charge_right,
                                ai_move_runmove_backright,
                                ai_move_runmove_slideright);
        return;
      }
      ai_move_randomTwo(4, ai_move_runmove_backright,
                            ai_move_runmove_slideright);
      return;
    }
    //------------------------
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          ai_move_randomFour(2, ai_move_charge_left, 
                                ai_move_runmove_slideleft, 
                                ai_run_backward, 
                                ai_move_runmove_backleft);
          return;
        }
        //else
        ai_move_randomTwo(1, ai_move_runmove_backleft, ai_move_runmove_slideleft);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_randomThree(2, ai_move_stand, 
                                ai_move_walkmove_backleft, 
                                ai_move_walkmove_strafeleft);
        return;
      }
      //else
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomThree(3, ai_move_charge_left,
                                ai_move_runmove_backleft,
                                ai_move_runmove_slideleft);
        return;
      }
      ai_move_randomTwo(4, ai_move_runmove_backright,
                            ai_move_runmove_slideright);
      return;
    }
    if(self.ai_type == AI_TYPE_AGGRO){
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomFour(2, ai_move_walkmove_backright, 
                              ai_move_walkmove_backleft, 
                              ai_move_runmove_backright, 
                              ai_move_runmove_backleft);
        return;
      }
      //else
      ai_move_randomTwo(1, ai_move_runmove_backleft, ai_move_runmove_backright);
      return;
    }
    if(self.ai_type == AI_TYPE_COWRD){
      ai_move_randomThree(2, ai_move_stand, 
                              ai_move_walkmove_backleft, 
                              ai_move_runmove_backright);
      return;
    }
    //else
    if(self.p_damage <= AI_RANK_VET){
      ai_move_randomThree(3, ai_move_runmove_slideright,
                              ai_move_runmove_slideleft,
                              ai_run_backward);
      return;
    }
    ai_move_controller(ai_run_backward, 4);
    return;
  }
//=================================================
  
//CASE: Target is too far away
  if(isFar){
    //layer 1 - tMovedir
      //layer 2 - ai type
        //layer 3 - ai rank
          //layer 4 - target facing
    if(tMovedir == AI_TARG_FWD){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          if(ai_target_isFacingThis(self.trigger_field)){
            ai_move_randomThree(1, ai_move_charge_left, 
                                    ai_move_charge_right, 
                                    ai_run_forward);
            return;
          }
          ai_move_randomThree(1.5, ai_move_forward,
                                  ai_move_walkmove_forwardleft,
                                  ai_move_walkmove_forwardright);
          return;
        }
        ai_move_controller(ai_run_forward, 0.5);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_controller(ai_move_forward, 1.5);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomThree(0.5, ai_move_forward,
                                ai_move_walkmove_forwardleft,
                                ai_move_walkmove_forwardright);
        return;
      }
      ai_move_randomThree(1, ai_run_forward,
                              ai_move_walkmove_forwardleft,
                              ai_move_walkmove_forwardright);
      return;
    }
    //------------------------
    if(tMovedir == AI_TARG_BKD){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          if(ai_target_isFacingThis(self.trigger_field)){
            ai_move_randomThree(1.5, ai_move_charge_left, 
                                    ai_move_charge_right, 
                                    ai_run_forward);
            return;
          }
          ai_move_randomThree(2, ai_move_forward,
                                  ai_move_walkmove_forwardleft,
                                  ai_move_walkmove_forwardright);
          return;
        }
        if(self.p_damage == AI_RANK_ACE){
          ai_move_controller(ai_run_forward, 0.5);
          return;
        }
        ai_move_controller(ai_run_forward, 1.5);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomThree(2, ai_run_forward,
                                ai_move_charge_left,
                                ai_move_charge_right);
        return;
      }
      ai_move_randomThree(3, ai_run_forward,
                              ai_move_charge_left,
                              ai_move_charge_right);
      return;
    }
    //------------------------
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          ai_move_randomTwo(2, ai_move_charge_left, ai_run_forward);
          return;
        }
        ai_move_randomTwo(1, ai_move_charge_left, ai_run_forward);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_controller(ai_move_forward, 2);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomThree(1, ai_move_charge_left, 
                                ai_move_walkmove_forwardleft, 
                                ai_move_walkmove_forwardright);
        return;
      }
      ai_move_randomTwo(2, ai_run_forward, ai_move_walkmove_forwardright);
      return;
    }
    //------------------------
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
          ai_move_randomTwo(2, ai_move_charge_right, ai_run_forward);
          return;
        }
        ai_move_randomTwo(1, ai_move_charge_right, ai_run_forward);
        return;
      }
      if(self.ai_type == AI_TYPE_COWRD){
        ai_move_controller(ai_move_forward, 2);
        return;
      }
      if(self.p_damage <= AI_RANK_VET){
        ai_move_randomThree(1, ai_move_charge_left, 
                                ai_move_walkmove_forwardleft, 
                                ai_move_walkmove_forwardright);
        return;
      }
      ai_move_randomTwo(2, ai_run_forward, ai_move_walkmove_forwardright);
      return;
    }
    //------------------------
  }
//=================================================
  
//CASE: Target is in engagement range
  //target is in the optimal range for AI
    //layer 1 - tMovedir
      //layer 2 - ai type
        //layer 3 - ai rank
          //layer 4 - target facing
  if(tMovedir == AI_TARG_FWD){
    if(self.ai_type == AI_TYPE_AGGRO){
      if(self.p_damage <= AI_RANK_ACE){
        if(targDist <= AI_RANGE_S / 2){
          ai_move_randomTwo(1, ai_move_charge_left, ai_move_charge_right);
          return;
        }
        ai_move_randomFour(1, ai_move_walkmove_forwardleft,
                                ai_move_walkmove_forwardright,
                                ai_move_runmove_slideleft,
                                ai_move_runmove_slideright);
        return;
      }
      if(targDist <= AI_RANGE_S / 2){
        ai_move_randomTwo(2, ai_move_charge_left, ai_move_charge_right);
        return;
      }
      ai_move_randomFour(1, ai_move_walkmove_forwardleft,
                              ai_move_walkmove_forwardright,
                              ai_move_runmove_slideleft,
                              ai_move_runmove_slideright);
      return;
    }
    if(self.ai_type == AI_TYPE_COWRD){
      //TODO - coward
      return;
    }
    if(self.p_damage <= AI_RANK_VET){
      ai_move_randomFour(0.5, ai_move_runmove_backleft,
                              ai_move_runmove_backright,
                              ai_move_runmove_slideleft,
                              ai_move_runmove_slideright);
      return;
    }
    ai_move_randomFour(1.5, ai_move_walkmove_backleft,
                            ai_move_walkmove_backright,
                            ai_move_runmove_slideleft,
                            ai_move_runmove_slideright);
    return;
  }
  //------------------------
  if(tMovedir == AI_TARG_BKD){
    if(self.ai_type == AI_TYPE_AGGRO){
      if(self.p_damage <= AI_RANK_ACE){
        if(targDist <= AI_RANGE_S / 2){
          ai_move_randomTwo(1, ai_move_charge_left, ai_move_charge_right);
          return;
        }
        ai_move_randomFour(1, ai_move_walkmove_forwardleft,
                                ai_move_walkmove_forwardright,
                                ai_move_runmove_slideleft,
                                ai_move_runmove_slideright);
        return;
      }
      if(targDist <= AI_RANGE_S / 2){
        ai_move_randomTwo(2, ai_move_charge_left, ai_move_charge_right);
        return;
      }
      ai_move_randomFour(1, ai_move_walkmove_forwardleft,
                              ai_move_walkmove_forwardright,
                              ai_move_runmove_slideleft,
                              ai_move_runmove_slideright);
      return;
    }
    if(self.ai_type == AI_TYPE_COWRD){
      //TODO - coward
      return;
    }
    if(self.p_damage <= AI_RANK_VET){
      ai_move_randomFour(0.5, ai_move_charge_left,
                              ai_move_charge_right,
                              ai_move_runmove_slideleft,
                              ai_move_runmove_slideright);
      return;
    }
    ai_move_randomFour(1.5, ai_move_walkmove_forwardleft,
                            ai_move_walkmove_forwardright,
                            ai_move_runmove_slideleft,
                            ai_move_runmove_slideright);
    return;
  }
  //------------------------
  if(tMovedir == AI_TARG_LFT){
    if(self.ai_type == AI_TYPE_AGGRO){
      amt = 2;
      if(self.p_damage <= AI_RANK_VET){
        amt = 1;
      }
      ai_move_randomFour(amt, ai_run_forward,
                              ai_move_charge_left,
                              ai_move_runmove_backleft,
                              ai_move_runmove_slideleft);
      return;
    }
    if(self.ai_type == AI_TYPE_COWRD){
      amt = 1.5;
      if(self.p_damage <= AI_RANK_VET){
        amt = 0.5;
      }
      ai_move_randomFour(amt, ai_move_stand,
                                ai_move_backward,
                                ai_move_forward,
                                ai_move_walkmove_forwardright);
      return;
    }
    if(self.p_damage == AI_RANK_ACE){
      amt = 0.5;
      ai_move_randomSix(amt, ai_run_forward,
                              ai_run_backward,
                              ai_move_charge_right,
                              ai_move_runmove_backright,
                              ai_move_runmove_slideright,
                              ai_move_charge_left);
      return;
    }
    amt = 2;
    if(self.p_damage >= AI_RANK_REG){
      amt = 1;
    }
    ai_move_randomFour(amt, ai_run_backward,
                              ai_move_charge_right,
                              ai_move_runmove_backright,
                              ai_move_runmove_slideright);
    return;
  }
  //------------------------
  if(tMovedir == AI_TARG_RGT){
    if(self.ai_type == AI_TYPE_AGGRO){
      amt = 2;
      if(self.p_damage <= AI_RANK_VET){
        amt = 1;
      }
      ai_move_randomFour(amt, ai_run_forward,
                              ai_move_charge_right,
                              ai_move_runmove_backright,
                              ai_move_runmove_slideright);
      return;
    }
    if(self.ai_type == AI_TYPE_COWRD){
      amt = 1.5;
      if(self.p_damage <= AI_RANK_VET){
        amt = 0.5;
      }
      ai_move_randomFour(amt, ai_move_stand,
                                ai_move_backward,
                                ai_move_forward,
                                ai_move_walkmove_forwardright);
      return;
    }
    if(self.p_damage == AI_RANK_ACE){
      amt = 0.5;
      ai_move_randomSix(amt, ai_run_forward,
                              ai_run_backward,
                              ai_move_charge_left,
                              ai_move_runmove_backleft,
                              ai_move_runmove_slideleft,
                              ai_move_charge_right);
      return;
    }
    amt = 2;
    if(self.p_damage >= AI_RANK_REG){
      amt = 1;
    }
    ai_move_randomFour(amt, ai_run_backward,
                              ai_move_charge_right,
                              ai_move_runmove_backright,
                              ai_move_runmove_slideright);
    return;
  }
  //------------------------
};
