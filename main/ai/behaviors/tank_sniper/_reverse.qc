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
  maintain yaw to enemy
  move backwards
*/
void() ai_spg_reverse1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
  ai_attack();
  
  macro_ai_frame(ai_spg_reverse2)
};
void() ai_spg_reverse2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_face_targ();
    ai_attack();
  }
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
      
  macro_ai_frame(ai_spg_reverse3)
};
void() ai_spg_reverse3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
  ai_attack();
  
  macro_ai_frame(ai_spg_reverse4)
};
void() ai_spg_reverse4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_face_targ();
    ai_attack();
  }
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );

  macro_ai_frame(ai_spg_reverse5)
};
void() ai_spg_reverse5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );

  macro_ai_frame(ai_spg_reverse6)
};
void() ai_spg_reverse6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_face_targ();
  }
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_reverse7)
};
void() ai_spg_reverse7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_reverse8)
};
void() ai_spg_reverse8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_face_targ();
  }
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );

  macro_ai_frame(ai_spg_reverse9)
};
void() ai_spg_reverse9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_reverse10)
};
void() ai_spg_reverse10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_face_targ();
  }
  walkmove( anglemod(self.angles_y - 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_fight_prep)
};