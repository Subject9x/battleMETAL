/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Panic/React
  
  Setup
    
*/
/*
  th_pain == 'panic'
  unit runs to its nearest node or ally
  if either are lacking, it'll just run in a rando direction
*/
void(entity attacker) ai_mech_sniper_panic1={
  local entity friend;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  self.ai_dir = self.angles_y;
  friend = ai_find_friend_farthest( self.ai_view * 0.5 );
  if( friend ){
    self.goalentity = friend;
  }
  else if( self.movetarget ){
    self.goalentity = self.movetarget;
  }
  else{
    self.th_react( attacker );
    return;
  }
  
  self.legs.attack_state = TR_NORM;
  macro_ai_frame( ai_mech_sniper_panic2 )
};
void() ai_mech_sniper_panic2={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )

  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic3 )
};
void() ai_mech_sniper_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic4 )
};
void() ai_mech_sniper_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic5 )
};
void() ai_mech_sniper_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic6 )
};
void() ai_mech_sniper_panic6 ={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
 
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );

  macro_ai_frame( ai_mech_sniper_panic7 )
};
void() ai_mech_sniper_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic8 )
};
void() ai_mech_sniper_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic9 )
};
void() ai_mech_sniper_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic10 )
};
void() ai_mech_sniper_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic11 )
};
void() ai_mech_sniper_panic11={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic12 )
};
void() ai_mech_sniper_panic12={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic13 )
};
void() ai_mech_sniper_panic13={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic14 )
};
void() ai_mech_sniper_panic14={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic15 )
};
void() ai_mech_sniper_panic15={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic16 )
};
void() ai_mech_sniper_panic16={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  macro_ai_frame_count( ai_mech_sniper_panic1 )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( ai_valid_target(self.enemy) ){
    macro_ai_frame( ai_mech_sniper_fight_prep )
    return;
  }
  
  if( self.movetarget ){
    macro_ai_frame( ai_mech_sniper_patrol1 )
    return;
  }
  
  macro_ai_frame( ai_mech_sniper_stand1 )
};

/*
  TH_REACT
*/
void( entity attacker ) ai_mech_sniper_react1={
  local float enemyvis;
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
  
  self.ai_react_buffer = time + self.ai_react_time;
  
  //AI currently has no target
  if( ai_valid_target(self.enemy) == FALSE ){
    self.ai_react_buffer = time + self.ai_react_time * 1.25;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov, TRUE) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
};