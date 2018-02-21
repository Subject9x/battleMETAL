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
  local float isClose, isFar, distOptimal, blockDist;
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
      local float amt;
      amt = ceil(1 + self.p_damage);  //worse pilots are badly aggressive
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
        ai_move_randomSix(3, ai_move_backward, 
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
        ai_move_controller(ai_move_stand, 2);
        return;
      }
      if(blockDir == AI_TARG_RGT){
        ai_move_randomSix(2, ai_move_walkmove_strafeleft, 
                                ai_move_runmove_slideleft, 
                                ai_move_backward,
                                ai_move_walkmove_backleft,
                                ai_move_walkmove_strafeleft,
                                ai_move_runmove_slideleft);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        ai_move_randomSix(2, ai_move_walkmove_straferight, 
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
          if(self.p_damage >= 2){
            //low rank, aggressive AI's will attack the blocker
            ai_update_switchToTarget(eBlocker);
          }
        }
        if(blockDir == AI_TARG_FWD ){
          ai_move_randomSix(2, ai_move_runmove_slideleft,
                                ai_move_runmove_slideright, 
                                ai_move_charge_left, 
                                ai_move_charge_right,
                                ai_move_runmove_slideright, 
                                ai_move_runmove_slideleft);
          return;
        }
        if(blockDir == AI_TARG_BKD){
          ai_move_randomThree(3, ai_move_charge_left,
                                  ai_move_charge_right,
                                  ai_move_forward);
          return;
        }
        if(blockDir == AI_TARG_RGT){
          ai_move_randomThree(4, ai_move_walkmove_strafeleft, 
                                  ai_move_runmove_slideleft, 
                                  ai_move_walkmove_backleft);
          return;
        }
        if(blockDir == AI_TARG_LFT){
          ai_move_randomThree(4, ai_move_walkmove_straferight, 
                                  ai_move_runmove_slideright, 
                                  ai_move_walkmove_backright);
          return;
        }
      }
      if((blockDir == AI_TARG_FWD) || (blockDir == AI_TARG_BKD)){
        ai_move_randomSix(3, ai_move_backward, 
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
        ai_move_controller(ai_move_stand, 2);
        return;
      }
      if(blockDir == AI_TARG_RGT){
        ai_move_controller(ai_move_runmove_slideleft, 1);
        return;
      }
      if(blockDir == AI_TARG_LFT){
        ai_move_controller(ai_move_runmove_slideright, 1);
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
        
        }
        //else
      }
      if(self.ai_type == AI_TYPE_COWRD){
      }
      //else
    }
    if(tMovedir == AI_TARG_BKD){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
        
        }
        //else
      }
      if(self.ai_type == AI_TYPE_COWRD){
      }
      //else
    }
    if(tMovedir == AI_TARG_LFT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
        
        }
        //else
      }
      if(self.ai_type == AI_TYPE_COWRD){
      }
      //else
    }
    if(tMovedir == AI_TARG_RGT){
      if(self.ai_type == AI_TYPE_AGGRO){
        if(self.p_damage <= AI_RANK_VET){
        
        }
        //else
      }
      if(self.ai_type == AI_TYPE_COWRD){
      }
      //else
    }
  }
//=================================================
  
//CASE: Target is too far away
  if(isFar){
    //layer 1 - tMovedir
      //layer 2 - ai type
        //layer 3 - ai rank
          //layer 4 - target facing
  
  }
//=================================================
  
//CASE: Target is in engagement range
  //target is in the optimal range for AI

    //layer 1 - tMovedir
      //layer 2 - ai type
        //layer 3 - ai rank
          //layer 4 - target facing
};
