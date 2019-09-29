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
void(entity attacker) ai_spg_panic1={
  local entity friend;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  self.ai_dir = self.angles_y;
  friend = ai_find_friend( self.ai_view );
  if( friend ){        
    ai_sfx_help();
    self.goalentity = friend;
  }
  else if( self.movetarget ){
    self.goalentity = self.movetarget;
  }
  else{
    if( !ai_valid_target(self.enemy) ){
      if( ai_valid_target(attacker) ){
        self.enemy = attacker;
        macro_ai_frame(ai_spg_fight_prep)
        return;
      }
    }
    if( ai_valid_target(attacker) ){
      self.enemy = attacker;
      macro_ai_frame(ai_spg_fight_prep)
      return;
    }
  }
  
  macro_ai_frame( ai_spg_panic2 )
};
void() ai_spg_panic2={
  local float low, high, tyaw;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  high = anglemod( self.angles_y + 45 );
  low = anglemod( self.angles_y - 45 );
  tyaw = vectoyaw( self.goalentity.origin - self.origin );
  
  if( (tyaw > high) || (tyaw < low) ){
    self.ideal_yaw = tyaw;
    ChangeYaw();
    macro_ai_frame( ai_spg_panic2 )
    return;
  }
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic3 )
};
void() ai_spg_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic4 )
};
void() ai_spg_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic5 )
};
void() ai_spg_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic6 )
};
void()  ai_spg_panic6 ={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
 
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );

  macro_ai_frame(  ai_spg_panic7 )
};
void() ai_spg_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic8 )
};
void() ai_spg_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic9 )
};
void() ai_spg_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic10 )
};
void() ai_spg_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  macro_ai_frame_count( ai_spg_panic1 )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( ai_valid_target(self.enemy) ){
    macro_ai_frame( ai_spg_fight_prep )
    return;
  }
  
  if( self.movetarget ){
    macro_ai_frame( ai_spg_patrol1 )
    return;
  }
  
  macro_ai_frame( ai_spg_stand1 )
};

/*
  TH_REACT
*/
void( entity attacker ) ai_spg_react1={
  local float enemyvis;

  self.ai_react_buffer = time + self.ai_react_time;
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }

  //AI currently has no target
  if( ai_valid_target(self.enemy) == FALSE ){
    self.enemy = attacker;
    self.ai_react_buffer = time + self.ai_react_time * 2;
    //Enemy fire is coming 'out of nowhere'
    if( vlen(attacker.origin - self.origin) > self.ai_view ){
      self.th_pain(attacker);
      return;
    }
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov, FALSE) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.ai_react_buffer = time + self.ai_react_time * 3;
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
};