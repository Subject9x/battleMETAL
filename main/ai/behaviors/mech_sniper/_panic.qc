/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Panic/React
    TH_REACT, TH_PAIN
  Setup
    
*/
void( entity attacker ) ai_mech_sk_react1={
  local float enemyvis;
  local entity ally;
  
  if( !attacker ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    return;
  }
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
  
  if( (self.flags & FL_DISARMED) ){
    if( self.stat_rdr_mode ){       
      ai_sfx_help();
      ally = ai_find_friend( self.ai_view );
      if( ally ){
        ai_give_target( ally, attacker, (ally.ai_rank <= self.ai_rank));
      }
    }
    return;
  }
  
  if( attacker == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    return;
  }
  //AI currently has no target
  if( !ai_valid_target(self.enemy) ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    self.enemy = attacker;
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.ai_react_buffer = time + self.ai_react_time * 10;
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.enemy = attacker;
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( (attacker.flags & FL_CLIENT) ){
    if( vlen(attacker.origin - self.origin) <= AI_RANGE_L ){
      self.oldenemy = self.enemy;
      self.enemy = attacker;
      self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
      self.torsoCenter.attack_state = TR_TARG;
      self.ai_react_buffer = time + self.ai_react_time * 5;   
      self.enemy = attacker;
      self.ai_state_next = ST_COMBAT;
      return;
    }
  }
  if( ai_check_targ_infront( attacker, self.ai_fov, TRUE) && (enemyvis != VIS_FRAC) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 5;    
    self.enemy = attacker;
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  self.ai_react_buffer = time + self.ai_react_time;
};