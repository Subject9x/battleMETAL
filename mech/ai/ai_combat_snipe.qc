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

};
