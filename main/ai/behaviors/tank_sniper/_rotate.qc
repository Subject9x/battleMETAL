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
  rotate in place,
  SPG's can dial their accuracy in when rotating
*/
void() ai_spg_rotate1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate2)
};
void() ai_spg_rotate2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate3)
};
void() ai_spg_rotate3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate4)
};
void() ai_spg_rotate4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate5)
};
void() ai_spg_rotate5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_rotate6)
};
void() ai_spg_rotate6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_rotate7)
};
void() ai_spg_rotate7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_rotate8)
};
void() ai_spg_rotate8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  Turn in place, to ideal_yaw
*/
void() ai_spg_turn1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  
  macro_ai_frame(ai_spg_turn2)
};
void() ai_spg_turn2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  
  macro_ai_frame(ai_spg_turn3)
};
void() ai_spg_turn3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_turn4)
};
void() ai_spg_turn4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  
  ai_attack();
  
  macro_ai_frame_count(ai_spg_turn1)
  
  macro_ai_frame(ai_spg_fight_prep)
};