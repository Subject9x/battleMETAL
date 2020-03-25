/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Hunt
    attempt to walkmove to target for a little bit
    
  Setup
    
*/
void() ai_gev_enter_hunt={
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
  
  macro_ai_frame(ai_gev_hunt1)
};

void() ai_gev_hunt1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt2, ai_gev_enter_recall );
};
void() ai_gev_hunt2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt3, ai_gev_enter_recall );
};
void() ai_gev_hunt3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt4, ai_gev_enter_recall );
};
void() ai_gev_hunt4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt5, ai_gev_enter_recall );
};
void() ai_gev_hunt5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt6, ai_gev_enter_recall );
};
void() ai_gev_hunt6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt7, ai_gev_enter_recall );
};
void() ai_gev_hunt7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt8, ai_gev_enter_recall );
};
void() ai_gev_hunt8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt9, ai_gev_enter_recall );
};
void() ai_gev_hunt9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt10, ai_gev_enter_recall );
};
void() ai_gev_hunt10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt11, ai_gev_enter_recall );
};
void() ai_gev_hunt11={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
  if( huntVisCheck == TRUE ){
    return;
  }
  
  ai_hunt_logic( self.speed, ai_gev_hunt12, ai_gev_enter_recall );
};
void() ai_gev_hunt12={
  macro_ai_frame_count(ai_gev_hunt1)
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  local float huntVisCheck;
  huntVisCheck = ai_hunt_logic_enemy_vis( ai_gev_fight_prep, ai_gev_enter_recall );
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
  
  macro_ai_frame(ai_gev_enter_recall)
};