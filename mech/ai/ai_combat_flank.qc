/*
mech Mod
Author: Peter Roohr
Date: 2/15/2018
Overview: ai combat state sub function
  basically moving these functions to their own files because of
  their complexity
 
FLANKER FUNCTIONS
*/
/*
  As the name suggests, flankers are obsessed with circling around
  the target to get back shots, and also strafe a lot too.
  float distClose = range that is 'too close';
  float distFar = range that is 'too far';
*/
void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustFlanker={
  local float isClose, isFar, distOptimal, blockDist, amt;
  isClose = FALSE;
  isFar = FALSE;
  distOptimal = FALSE;
  if(targDist <= distClose){
    isClose = TRUE;
  }
  if(targDist > distFar){
    isFar = TRUE;
  }
  
  /*
    Aggro flankers - 
      will circle strafe aggressively at full speed
      have a higher chance of switching strafe direction
    
    Rescue flanker - 
      
    
    Coward flanker -
      if behind the target, aggressively stay behind this target
  */
  //CASE: target is blocked by something else
  if((eBlocker != world) && (eBlocker != self.trigger_field)){
    local float blockDir, prox;
    blockDir = ai_util_calcTargetMoveDir(eBlocker, self);
    prox = vlen(eBlocker.origin - self.origin);
    if(eBlocker.i_faction == self.i_faction){
      if( (blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD) ){
        if(self.ai_type == AI_TYPE_AGGRO){
          amt = 2 + self.p_damage;
          if(prox <= distClose){
            amt = amt + 2;
          }
          if(ai_target_isFacingThis(self.trigger_field)){
            ai_move_randomFour(amt, ai_move_charge_left,
                                      ai_move_charge_right,
                                      ai_move_runmove_slideleft,
                                      ai_move_runmove_slideright);
            return;
          }
          ai_move_randomFour(amt, ai_move_runmove_backright,
                                    ai_move_runmove_backleft,
                                    ai_move_runmove_slideleft,
                                    ai_move_runmove_slideright);
          return;
        }
        amt = 1 + self.p_damage;
        if(prox <= distClose){
          amt = amt + 1;
          ai_move_randomSix(amt,  ai_move_walkmove_forwardleft,
                                  ai_move_walkmove_strafeleft,
                                  ai_move_walkmove_backleft,
                                  ai_move_walkmove_forwardright,
                                  ai_move_walkmove_straferight,
                                  ai_move_walkmove_backright);
          return;
        }
        ai_move_randomFour(amt, ai_move_walkmove_strafeleft,
                                  ai_move_walkmove_straferight,
                                  ai_move_walkmove_forwardleft,
                                  ai_move_walkmove_forwardright);
        return;
      }
      //--------------------------
      if(blockDir == AI_TARG_LFT){
        if(self.ai_type == AI_TYPE_AGGRO){
          amt = 2 + self.p_damage;
          if(prox <= distClose){
            amt = amt + 2;
            ai_move_randomTwo(amt, ai_move_charge_right,
                                    ai_move_runmove_slideright);
            return;
          }
          if(ai_target_isFacingThis(self.trigger_field)){
            amt = amt + 4;
          }
          ai_move_controller(ai_move_runmove_slideright, amt);
          return;
        }
        amt = 1 + self.p_damage;
        if(prox <= distClose){
          amt = amt + 1;
          ai_move_randomThree(amt,  ai_move_walkmove_forwardright,
                                  ai_move_walkmove_straferight,
                                  ai_move_walkmove_backright);
          return;
        }
        ai_move_randomTwo(amt, ai_move_walkmove_straferight,
                                  ai_move_walkmove_forwardright);
        return;
      }
      //--------------------------
      if(blockDir == AI_TARG_RGT){
        if(self.ai_type == AI_TYPE_AGGRO){
          amt = 2 + self.p_damage;
          if(prox <= distClose){
            amt = amt + 2;
            ai_move_randomTwo(amt, ai_move_charge_left,
                                    ai_move_runmove_slideleft);
            return;
          }
          if(ai_target_isFacingThis(self.trigger_field)){
            amt = amt + 4;
          }
          ai_move_controller(ai_move_runmove_slideleft, amt);
          return;
        }
        amt = 1 + self.p_damage;
        if(prox <= distClose){
          amt = amt + 1;
          ai_move_randomThree(amt,  ai_move_walkmove_forwardleft,
                                  ai_move_walkmove_strafeleft,
                                  ai_move_walkmove_backleft);
          return;
        }
        ai_move_randomTwo(amt, ai_move_walkmove_strafeleft,
                                  ai_move_walkmove_forwardleft);
        return;
      }
      //--------------------------
    }
    else{
      if( (blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD) ){
        if(self.ai_type == AI_TYPE_AGGRO){
          amt = self.p_damage;
          if(prox <= distClose){
            amt = amt + 4;
          }
          if(ai_target_isFacingThis(eBlocker)){
            amt = amt + 2;
          }
          ai_move_randomTwo(amt, ai_move_runmove_slideright,
                                  ai_move_runmove_slideleft);
          return;
        }
        amt = self.p_damage;
        if(prox <= distClose){
          amt = amt + 3;
        }
        if(ai_target_isFacingThis(eBlocker)){
          ai_move_randomFour(amt, ai_move_charge_left,
                                    ai_move_runmove_slideleft,
                                    ai_move_charge_right,
                                    ai_move_runmove_slideright);
          return;
        }          
        ai_move_randomFour(amt, ai_move_charge_left,
                                  ai_move_runmove_backleft,
                                  ai_move_charge_right,
                                  ai_move_runmove_backright);
        return;
      }
      //--------------------------
      if(blockDir == AI_TARG_LFT){
        if(self.ai_type == AI_TYPE_AGGRO){
          amt = self.p_damage;
          if(prox <= distClose){
            amt = amt + 2;
            ai_move_randomThree(amt, ai_move_charge_right,
                                      ai_move_runmove_slideright,
                                      ai_move_runmove_backright);
            return;
          }
          amt = amt + 6;
          ai_move_controller(ai_move_charge_right, amt);
          return;
        }
        amt = self.p_damage;
        if(prox <= distClose){
          amt = amt + 1;
          ai_move_randomThree(amt, ai_move_walkmove_forwardright,
                                    ai_move_walkmove_straferight,
                                    ai_move_walkmove_backright);
          return;
        }
        amt = amt + 3;
        ai_move_controller(ai_move_charge_right, amt);
        return;
      }
      //--------------------------
      if(blockDir == AI_TARG_RGT){
        if(self.ai_type == AI_TYPE_AGGRO){
          amt = self.p_damage;
          if(prox <= distClose){
            amt = amt + 2;
            ai_move_randomThree(amt, ai_move_charge_left,
                                      ai_move_runmove_slideleft,
                                      ai_move_runmove_backleft);
            return;
          }
          amt = amt + 6;
          ai_move_controller(ai_move_charge_left, amt);
          return;
        }
        amt = self.p_damage;
        if(prox <= distClose){
          amt = amt + 1;
          ai_move_randomThree(amt, ai_move_walkmove_forwardleft,
                                    ai_move_walkmove_strafeleft,
                                    ai_move_walkmove_backleft);
          return;
        }
        amt = amt + 3;
        ai_move_controller(ai_move_charge_left, amt);
        return;
      }
      //--------------------------
    }
  }
//==================================================
  
//CASE: Target is too close - yes its possible to be to close
  if(isClose){
    local float moveDist;
    moveDist = ai_util_calcMoveDist(self.trigger_field.origin, 0.05);
    if( (tMovedir == AI_TARG_FWD) || (tMovedir == AI_TARG_BKD) ){
      ai_move_randomTwo(2, ai_move_walkmove_backright, ai_move_walkmove_backleft);
                              
      return;
    }
    if(tMovedir == AI_TARG_LFT){
      ai_move_controller(ai_move_walkmove_backright, 2);
      return;
    }
    if(tMovedir == AI_TARG_RGT){
      ai_move_controller(ai_move_walkmove_backleft, 2);
      return;
    }  
  }
//=================================================
  
//CASE: Target is too far away
  if(isFar){
    local float moveDist;
    moveDist = ai_util_calcMoveDist(self.trigger_field.origin, 0.05) -  ai_util_calcMoveLen(distClose + 50, 0.05);
    if( (tMovedir == AI_TARG_FWD) || (tMovedir == AI_TARG_BKD) ){
      if(self.ai_type == AI_TYPE_AGGRO){
        moveDist = ceil((moveDist + self.p_damage + 1) / 2); 
        ai_move_controller(ai_run_forward, moveDist);
        return;
      }
      moveDist = ceil((moveDist + self.p_damage) / 2); 
      ai_move_controller(ai_move_forward, moveDist);
      return;
    } 
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){
        moveDist = ceil((moveDist + self.p_damage + 1) / 2); 
        ai_move_controller(ai_move_walkmove_forwardleft, moveDist);
        return;
      }
      moveDist = ceil((moveDist + self.p_damage) / 2); 
      ai_move_randomTwo(moveDist, ai_move_forward, ai_move_walkmove_forwardleft);
      return;
    }
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        moveDist = ceil((moveDist + self.p_damage + 1) / 2);
        ai_move_controller(ai_move_walkmove_forwardright, moveDist);
        return;
      }
      moveDist = ceil((moveDist + self.p_damage) / 2); 
      ai_move_randomTwo(moveDist, ai_move_forward, ai_move_walkmove_forwardright);
      return;
    }
  }
//=================================================
  
//CASE: Target is in engagement range
  if(tMovedir == AI_TARG_FWD){
    if(self.ai_type == AI_TYPE_AGGRO){
      if(ai_target_isFacingThis(self.trigger_field)){
        amt = self.p_damage;
        if(self.trigger_field.trigger_field == self){
          amt = amt + 4;
        }
        ai_move_randomFour(amt, ai_move_charge_left,
                                ai_move_charge_right,
                                ai_move_runmove_slideleft,
                                ai_move_runmove_slideright);
        return;
      }
      ai_move_controller(ai_move_stand, amt);  
      return;
    }
    
    if(ai_target_isFacingThis(self.trigger_field)){
      amt = 1;
      if(self.trigger_field.trigger_field == self){
        amt = amt + self.p_damage;
      }
      ai_move_randomTwo(amt, ai_move_runmove_slideleft,
                                ai_move_runmove_slideright);
      return;
    }
    ai_move_controller(ai_move_stand, amt);
    return;
  }
  //--------------------------
  if(tMovedir == AI_TARG_BKD){
    if(self.ai_type == AI_TYPE_AGGRO){
      if(ai_target_isFacingThis(self.trigger_field)){
        amt = self.p_damage;
        if(self.trigger_field.trigger_field == self){
          amt = amt + 4;
        }
        ai_move_randomTwo(amt, ai_move_charge_left,
                                ai_move_charge_right);
        return;
      }
      ai_move_controller(ai_move_stand, amt);  
      return;
    }
    if(ai_target_isFacingThis(self.trigger_field)){
      amt = 1;
      if(self.trigger_field.trigger_field == self){
        amt = amt + self.p_damage;
      }
      ai_move_randomTwo(amt, ai_move_runmove_slideleft,
                                ai_move_runmove_slideright);
      return;
    }
    ai_move_controller(ai_move_stand, amt);
    return;
   
  }
  //--------------------------
  if(tMovedir == AI_TARG_LFT){
    //aggro
    if(self.ai_type == AI_TYPE_AGGRO){
      if(ai_target_isFacingThis(self.trigger_field)){
        if(ai_target_isFacingThis(self.trigger_field)){
          if((self.p_velocity >=  self.v_angle_y + 90) && (self.p_velocity <= self.v_angle_y + 135)){
            ai_move_controller(ai_move_walkmove_strafeleft, 2);
            return;
          }
          if((self.p_velocity <=  self.v_angle_y - 90) && (self.p_velocity >= self.v_angle_y - 135)){
            ai_move_controller(ai_move_walkmove_straferight, 2);
            return;                
          }
        }
      }
      ai_move_controller(ai_move_backward, 2);
      return;
    }
    if(ai_target_isFacingThis(self.trigger_field)){
      amt = 1;
      if(self.trigger_field.trigger_field == self){
        amt = amt + self.p_damage;
      }
      ai_move_randomThree(amt, ai_run_forward,
                                ai_move_charge_right,
                                ai_move_runmove_slideright);
      return;
    }
    ai_move_controller(ai_move_stand, amt);
    return;
  }
  //--------------------------
  if(tMovedir == AI_TARG_RGT){
    //aggro
    if(self.ai_type == AI_TYPE_AGGRO){
      if(ai_target_isFacingThis(self.trigger_field)){
        if(ai_target_isFacingThis(self.trigger_field)){
          if((self.p_velocity >=  self.v_angle_y + 90) && (self.p_velocity <= self.v_angle_y + 135)){
            ai_move_controller(ai_move_walkmove_strafeleft, 2);
            return;
          }
          if((self.p_velocity <=  self.v_angle_y - 90) && (self.p_velocity >= self.v_angle_y - 135)){
            ai_move_controller(ai_move_walkmove_straferight, 2);
            return;                
          }
        }
      }
      ai_move_controller(ai_move_backward, 2);
      return;
    }
    if(ai_target_isFacingThis(self.trigger_field)){
      amt = 1;
      if(self.trigger_field.trigger_field == self){
        amt = amt + self.p_damage;
      }
      ai_move_randomThree(amt, ai_run_forward,
                                ai_move_charge_left,
                                ai_move_runmove_slideleft);
      return;
    }
    ai_move_controller(ai_move_stand, amt);
    return;
  }
  if(ai_target_isFacingThis(self.trigger_field)){
    if((self.p_velocity >=  self.v_angle_y + 90) && (self.p_velocity <= self.v_angle_y + 135)){
      ai_move_controller(ai_move_walkmove_straferight, 1);
      return;
    }
    if((self.p_velocity <=  self.v_angle_y - 90) && (self.p_velocity >= self.v_angle_y - 135)){
      ai_move_controller(ai_move_walkmove_strafeleft, 1);
      return;                
    }
  }
  ai_move_controller(ai_move_stand, 1);
  return;
  //--------------------------
//=================================================
};
