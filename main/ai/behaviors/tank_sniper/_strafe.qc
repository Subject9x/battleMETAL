/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
  
  Setup
    
*/
/*
  turn perpendicular and move for a tad
  
*/
void() ai_spg_strafe1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = self.ai_dir;
  //ok now its getting silly
  self.ai_action_time = ceil(self.ai_action_time * 1.5);
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_spg_strafe2)
};
void() ai_spg_strafe2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_spg_strafe3)
};
void() ai_spg_strafe3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_strafe4)
};
void() ai_spg_strafe4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  
  macro_ai_frame(ai_spg_strafe5)
};
void() ai_spg_strafe5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  
  macro_ai_frame(ai_spg_strafe6)
};
void() ai_spg_strafe6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  
  macro_ai_frame(ai_spg_strafe7)
};
void() ai_spg_strafe7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  walkmove( self.angles_y, self.data_speed_forward);
  macro_ai_frame_count(ai_spg_strafe7)
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 
  macro_ai_frame(ai_spg_strafe8)
};
void() ai_spg_strafe8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};