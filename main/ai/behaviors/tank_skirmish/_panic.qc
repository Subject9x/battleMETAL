/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
    th_pain == 'panic'
    unit runs to its nearest node or ally
    if either are lacking, it'll just run in a rando direction
  
  Setup
    
*/
/*
  TH_REACT - react to damage
*/
void( entity attacker ) ai_tank_sk_react1={
  local float enemyvis;
  
  if( (!attacker) ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    return;
  }
  //AI has taken friendly fire
  if( attacker.faction == self.faction )
    return;
  
  self.ai_react_buffer = time + self.ai_react_time;
  
  //AI currently has no target
  if( !ai_valid_target(self.enemy) ){
    self.ai_react_buffer = time + self.ai_react_time * 3;
    self.enemy = attacker;
    self.torsoCenter.attack_state = TR_TARG;
    //macro_ai_frame(ai_tank_sk_enter_rotate)
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    //macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov, TRUE) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    //macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  self.ai_react_buffer = time + self.ai_react_time * 2;
};