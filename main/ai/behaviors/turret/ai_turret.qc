/*
battleMETAL 
Author: Peter Roohr
Date: 7/16/2018
Overview: ai unit
  Stock Turret Unit
  an on-ground, static vehicle
*/

void() ai_turret={
  self.effects = self.effects | EF_LOWPRECISION;
  
  ai_unit_ini_var();
  
  initialize_data_turret_( self.nextVecChoice );
  
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, self.trigOnSpawn); //event interface

  self.th_pain = ai_turret_react;
  self.th_die = ai_turret_die;
  self.touch = ai_turret_touch;
  
  self.SendEntity = ctrl_send_turret;
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_UPDATE_FULL);
  
  self.ai_movewait = 0;
  
  self.ai_unit_update = ctrl_updateTank;
  
  //self.position3 = self.origin;
  self.position2 = self.origin;
  self.position1 = self.origin;

  self.think = ai_state_turret_frame;
  self.nextthink = time + (random() * 0.5);
};

void() ai_turret_touch={
  
  if( time < self.ai_react_buffer ){
    return;
  }
  if( other.faction != self.faction ){
    if( ai_valid_target(self.enemy)){
      if((self.enemy.flags & FL_CLIENT)){
        if(ai_check_vis(self.enemy) == VIS_FRAC){
          self.ai_react_buffer = time + (self.ai_react_time * 2);
          return;
        }
      }
    }
    self.oldenemy = self.enemy;
    self.enemy = other;
    self.ai_react_buffer = time + (self.ai_react_time * 1.5);
  }
};

/*
  TH_PAIN
    what to do when hit by fire
*/
void( entity newAttacker ) ai_turret_react={  
  local float vischeck;
  
  if( time < self.ai_react_buffer ){
    return;
  }
  
  //AI has taken friendly fire
  if( newAttacker.faction == self.faction ){
    return;
  }
  
  if( (self.flags & FL_DISARMED) ){
    self.ai_react_buffer = time + self.ai_react_time * 4;
    ai_call_for_help(newAttacker);
    return;
  }
  
  if( newAttacker == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time;
    return;
  }
  //AI currently has target
  if( ai_valid_target(self.enemy) ){
    vischeck = ai_check_vis(self.enemy);
    if( vischeck == VIS_FRAC){
      self.ai_react_buffer = time + self.ai_react_time * 1.25;
      return;
    }
  }
  
  self.ai_react_buffer = time + self.ai_react_time * 2;
  
  self.enemy = newAttacker;
};