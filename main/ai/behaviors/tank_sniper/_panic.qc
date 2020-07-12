/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Panic
    th_pain == 'panic'
    unit runs to its nearest node or ally
    if either are lacking, it'll just run in a rando direction
    
  Setup

*/
/*
  TH_REACT
*/
void( entity attacker ) ai_spg_react1={
  local float enemyvis;
  
  if( !attacker ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    return;
  }
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
  if( attacker == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    return;
  }

  //AI currently has no target
  if( ai_valid_target(self.enemy) == FALSE ){
    self.enemy = attacker;
    self.ai_react_buffer = time + self.ai_react_time * 2;
    //Enemy fire is coming 'out of nowhere'
    if( vlen(attacker.origin - self.origin) > self.ai_view ){
      return;
    }
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov, (self.flags & FL_TURRET)) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    self.ai_state_next = ST_COMBAT;
    return;
  }
};
void(entity attacker) ai_spg_panic1={
  local entity friend;
  
  ai_update_accuracy( TRUE );
  
  self.ai_dir = self.angles_y;
  friend = ai_find_friend_farthest( self.ai_view * 0.5 );
  if( friend ){
    self.goalentity = friend;
  }
  else if( self.movetarget ){
    self.goalentity = self.movetarget;
  }
  else{
    return;
  }
  
};
