/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai state implementation
  state: MISC
*/

//============================
//   MISC STATES          
//============================
/*
  ah, unstucking the bot, this is for edge case
  movement - most likely caused by getting into a
  fight with another thing.
*/
void() ai_misc_unstuck={};

/*
  What it says on the tin, AI will just stand
  in place.
*/
void() ai_misc_stand={
  //
  if(self.ai_prev_state == ai_patrol_gotoNode){
  
  }

};


/*
  Debug Stand means the AI will just stand in place
  and not react to the rest of the game world, no
  matter how many times you shoot it;
  
  this is referenced in t_damage - L64
  tried to avoid tight coupling, but it seemed 
  good enough
*/  
void() ai_misc_stand_debug={
  
  //clear out the AI's normal Touch func
  if(self.touch != SUB_Null){
    self.touch = SUB_Null;
  }
  
  ai_state_control(ai_misc_stand_debug);
  ai_move_controller(ai_move_stand, 1);
};