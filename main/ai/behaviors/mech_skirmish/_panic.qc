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

  if( !attacker ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    return;
  }
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction )
    return;
  
  if( attacker == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    if( self.attack_state != ST_HUNT ){
      macro_ai_frame(ai_mech_sk_fight_prep)
    }
    return;
  }
  //AI currently has no target
  if( !ai_valid_target(self.enemy) ){
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
  
  if( ai_check_targ_infront( attacker, self.ai_fov, TRUE) && (enemyvis != VIS_FRAC) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_react_buffer = time + self.ai_react_time * 5;
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  self.ai_react_buffer = time + self.ai_react_time;
};
void(entity attacker) ai_mech_sk_panic1={
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
  self.torsoCenter.attack_state = TR_NORM;
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  macro_ai_frame( ai_mech_sk_panic2 )
  
};
void() ai_mech_sk_panic2={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic3 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic4 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic5 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic6 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic6 ={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic7 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic8 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic9 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic10 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic11 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic11={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic12 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic12={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic13 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic13={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic14 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic14={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic15 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic15={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_panic16 ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
void() ai_mech_sk_panic16={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  macro_ai_frame_count( ai_mech_sk_panic1 )

  local float moveCheck;
  moveCheck = ai_patrol_logic( self.data_speed_forward / 2, ai_mech_sk_fight_prep, ai_mech_sk_enter_stand ); 
  if( !moveCheck ){
    macro_ai_frame( ai_mech_sk_enter_stand )
  }
};
