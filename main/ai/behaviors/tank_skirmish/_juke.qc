/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - MBT
  Behavior - Skirmish
  
  Setup
    
*/
/*
  tank attempts to quickly turn around if enemy is behind it
*/
void() ai_tank_sk_juke1={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke2)
};
void() ai_tank_sk_juke2={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke3)
};
void() ai_tank_sk_juke3={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_juke4)
};
void() ai_tank_sk_juke4={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke5)
};
void() ai_tank_sk_juke5={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_juke6)
};
void() ai_tank_sk_juke6={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke7)
};
void() ai_tank_sk_juke7={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke8)
};
void() ai_tank_sk_juke8={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_juke9)
};
void() ai_tank_sk_juke9={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_juke10)
};
void() ai_tank_sk_juke10={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  ai_attack();
  
  if( ai_check_targ_infront(self.enemy, self.ai_fov, FALSE) ){
    macro_ai_frame(ai_tank_sk_fight_prep)
  }
  
  macro_ai_frame_count(ai_tank_sk_juke1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};