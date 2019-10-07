/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
    hunting behavior
  Setup
    
*/
void() ai_tank_sk_enter_hunt={
  local entity nodeRecall;
  self.attack_state = ST_HUNT;
  ai_sfx_huntStart();
  nodeRecall = node_recall_setup();
  self.ai_node_recall = nodeRecall;
  self.goalentity = self.enemy;
  
  self.ai_action_time = (0 - self.ai_action_mod) * -1;
  if( self.stat_rdr_mode ){
    self.ai_action_time = ceil(self.ai_action_time * 6);
  }
  else{
    self.ai_action_time = ceil(self.ai_action_time * 4);
  }
  
  self.speed = self.data_speed_forward / 2;
  
  ai_face_targ();
  self.torsoCenter.attack_state = TR_TARG;
  
  macro_ai_frame(ai_tank_sk_hunt1)
};
void() ai_tank_sk_hunt1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_tank_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_tank_sk_hunt2, ai_tank_sk_enter_recall );
};
void() ai_tank_sk_hunt10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_mech_sk_fight_prep, ai_tank_sk_enter_recall );
  if( huntVisCheck ){
    return;
  }

  if( self.goalentity && self.goalentity != world ){
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    ChangeYaw();
    if( !walkmove( self.angles_y, self.speed ) ){
      movetogoal( self.speed  );
    }
  }
  macro_ai_frame_count(ai_tank_sk_hunt1)
  macro_ai_frame(ai_tank_sk_enter_recall)
};
