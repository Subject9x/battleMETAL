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
  local float vischeck;
  
  if( time < self.ai_react_buffer ){
    return;
  }
  
  //AI has taken friendly fire
  if( newAttacker.faction == self.faction ){
    return;
  }
  
  if( (!(newAttacker.flags & FL_MONSTER) && !(newAttacker.flags & FL_CLIENT)) || (self.flags & FL_DISARMED) ){
    if(alarm_ent == world ){
      alarm_ent = self;
    }
    ai_call_for_help(newAttacker);
    if(alarm_ent == self){
      alarm_ent = world;
    }
    return;
  }
  
  if( newAttacker == self.enemy ){
    return;
  }
  //AI currently has target
  vischeck = ai_check_vis(self.enemy);
  if( (self.enemy.flags & FL_CLIENT) ){
    if( vischeck == VIS_FRAC || vischeck == VIS_FRN){
      return;
    }
  }
  if( (self.enemy.flags & FL_MONSTER) ){
    if( vischeck == VIS_FRAC ){
      return;
    }
  }
  
  self.ai_react_buffer = time + self.ai_react_time * 3.75;
  
  self.enemy = newAttacker;
};