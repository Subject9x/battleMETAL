/*
battleMETAL 
Author: Peter Roohr
Date: 7/29/2020
Overview: 
  AI Reaction code
    what does the unit do when shot at? ie - the old th_pain() func.
    in battleMETAL, units don't really stagger, instead do 
    some sort of target filtering.
*/

void(entity newAttacker) ai_react_generic={
  local float enemyvis;
  
  self.ai_react_buffer = time + self.ai_react_time * 5;
  
  if( (!(newAttacker.flags & FL_MONSTER) && !(newAttacker.flags & FL_CLIENT)) || (self.flags & FL_DISARMED) ){
    ai_call_for_help(newAttacker);
    return;
  }
  
  //AI has taken friendly fire
  if( newAttacker.faction == self.faction ){
    return;
  }
  
  if( newAttacker == self.enemy ){
    return;
  }

  //AI currently has target
  if( self.enemy ){
    return;
  }
  
  if( ai_check_vis(self.enemy) == VIS_FRAC ){
    if( (self.enemy.flags & FL_CLIENT) ){
      return;
    }
  }
  if( ai_check_vis(self.enemy) == VIS_FRN ){
    if( (self.enemy.flags & FL_CLIENT) ){
      return;
    }
  }
  
  self.enemy = newAttacker;
  if(self.ai_state_next != ST_COMBAT ){
    self.ai_state_next = ST_COMBAT;
  }
};