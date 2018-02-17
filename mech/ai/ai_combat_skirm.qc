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
void(float targDist, float distClose, float distFar) ai_combat_adjustSkirmish={
  local float tDir, sDir;
  tDir = ai_util_angleToDir(self.trigger_field.velocity); 
  sDir = ai_util_angleToDir(self.velocity); 
  
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
