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
  charge forward a little bit
*/
void() ai_spg_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_charge2)
};
void() ai_spg_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();
  
  macro_ai_frame(ai_spg_charge3)
};
void() ai_spg_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_face_targ();
  }
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_spg_charge4)
};
void() ai_spg_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame_count(ai_spg_charge1)
  
  macro_ai_frame(ai_spg_fight_prep)
};