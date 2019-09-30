/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Panic/React
  
  Setup
    
*/
/*
  TH_REACT
*/
void( entity attacker ) ai_mech_sk_react1={
  local float enemyvis;
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction )
    return;
  
  if( attacker == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    return;
  }
  //AI currently has no target
  if( ai_valid_target(self.enemy) == FALSE ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 5;
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov, TRUE) && enemyvis != VIS_FRAC ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 5;
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  self.ai_react_buffer = time + self.ai_react_time * 2;
};

/*
  th_pain == 'panic'
  unit runs to its nearest node or ally
  if either are lacking, it'll just run in a rando direction
*/
void(entity attacker) ai_mech_sk_panic1={
  local entity friend;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  self.ai_dir = self.angles_y;
  friend = ai_find_friend( self.ai_view );
  if( friend ){
    self.goalentity = friend;
  }
  else if( self.movetarget ){
    self.goalentity = self.movetarget;
  }
  else{
    if( !ai_valid_target(self.enemy) ){
      if( ai_valid_target(attacker) ){
        self.enemy = attacker;
        macro_ai_frame(ai_mech_sk_fight_prep)
        return;
      }
    }
    if( ai_valid_target(attacker) ){
      self.enemy = attacker;
      macro_ai_frame(ai_mech_sk_fight_prep)
      return;
    }
  }
  
  macro_ai_frame( ai_mech_sk_panic2 )
};
void() ai_mech_sk_panic2={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )

  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic3 )
};
void() ai_mech_sk_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic4 )
};
void() ai_mech_sk_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic5 )
};
void() ai_mech_sk_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic6 )
};
void() ai_mech_sk_panic6 ={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
 
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );

  macro_ai_frame( ai_mech_sk_panic7 )
};
void() ai_mech_sk_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic8 )
};
void() ai_mech_sk_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic9 )
};
void() ai_mech_sk_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic10 )
};
void() ai_mech_sk_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic11 )
};
void() ai_mech_sk_panic11={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic12 )
};
void() ai_mech_sk_panic12={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic13 )
};
void() ai_mech_sk_panic13={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic14 )
};
void() ai_mech_sk_panic14={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic15 )
};
void() ai_mech_sk_panic15={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sk_panic16 )
};
void() ai_mech_sk_panic16={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  macro_ai_frame_count( ai_mech_sk_panic1 )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( ai_valid_target(self.enemy) ){
    macro_ai_frame( ai_mech_sk_fight_prep )
    return;
  }
  
  if( self.movetarget ){
    macro_ai_frame( ai_mech_sk_patrol1 )
    return;
  }
  
  macro_ai_frame( ai_mech_sk_stand1 )
};
