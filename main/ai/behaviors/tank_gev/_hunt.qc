/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Skirmish
  
  Setup
    
*/
/*
  HUNT
  attempt to walkmove to target for a little bit
*/
void() ai_gev_hunt1={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt2)
};
void() ai_gev_hunt2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt3)
};
void() ai_gev_hunt3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
 
  macro_ai_frame(ai_gev_hunt4)
};
void() ai_gev_hunt4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt5)
};
void() ai_gev_hunt5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt6)
};
void() ai_gev_hunt6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt7)
};
void() ai_gev_hunt7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt8)
};
void() ai_gev_hunt8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis( self.enemy ) ){
      ai_sfx_spotted();
      macro_ai_frame(ai_gev_fight_prep)
      return;
    }
  }
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt9)
};
void() ai_gev_hunt9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt10)
};
void() ai_gev_hunt10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt11)
};
void() ai_gev_hunt11={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt12)
};
void() ai_gev_hunt12={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame_count(ai_gev_hunt1)

  ai_sfx_huntEnd();
  
  if( self.movetarget ){
    ai_turret_set_state( TR_NORM );
    local float dist1, dist2;
    dist1 = vlen( self.movetarget.origin - self.origin );
    dist2 = vlen( self.ai_node_recall.origin - self.origin );
    if( dist1 < dist2 ){
      self.goalentity = self.movetarget;
      macro_ai_frame(ai_gev_patrol1)
      remove(self.ai_node_recall);
      return;
    }
  }
  //the recall portion of hunting
  if( self.ai_node_recall && self.goalentity != self.ai_node_recall ){
    ai_turret_set_state( TR_NORM );
    self.goalentity = self.ai_node_recall;
    self.ai_action_time = (0 - self.ai_action_mod) * -1;
    self.ai_action_time = ceil(self.ai_action_time * 4);
    macro_ai_frame(ai_gev_hunt1)
    return;
  }
  remove(self.ai_node_recall);
  self.ai_node_recall = world;
  self.enemy = world;
  macro_ai_frame(ai_gev_stand1)
};