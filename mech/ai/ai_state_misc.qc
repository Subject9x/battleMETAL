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
  if(!self.stat_rdr_mode){
    self.stat_rdr_mode = TRUE;
  }
  if(self.stat_rdr_mode){
    if(self.trigger_field == world){
      local entity contact;
      contact = ai_target_radarTarget();
      if(contact){
        ai_update_switchToTarget(contact);
        if(ai_target_canSee(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        self.delay = time + self.maxpatience;
        ai_state_control(ai_combat_huntTarget);
        return;
      }
    }
    else{
      if(ai_target_isValid(self.trigger_field)){
        if(ai_target_canSee(self.trigger_field)){
          ai_state_control(ai_combat_adjustPosition);
          return;
        }
        self.delay = time + self.maxpatience;
        ai_state_control(ai_combat_huntTarget);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand);
  ai_move_controller(ai_move_stand, 1);
  return;
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