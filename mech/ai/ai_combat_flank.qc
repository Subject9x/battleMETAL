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
