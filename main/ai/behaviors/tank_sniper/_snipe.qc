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
  turns to face target
  tries to line up shot when accurate
*/
void() ai_spg_snipe1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe2)
};
void() ai_spg_snipe2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe3)
};
void() ai_spg_snipe3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe4)
};
void() ai_spg_snipe4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe5)
};
void() ai_spg_snipe5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe6)
};
void() ai_spg_snipe6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe7)
};
void() ai_spg_snipe7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe8)
};
void() ai_spg_snipe8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe9)
};
void() ai_spg_snipe9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe10)
};
void() ai_spg_snipe10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe11)
};
void() ai_spg_snipe11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe12)
};
void() ai_spg_snipe12={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe13)
};
void() ai_spg_snipe13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 
  macro_ai_frame(ai_spg_snipe14)
};
void() ai_spg_snipe14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe15)
};
void() ai_spg_snipe15={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe16)
};
void() ai_spg_snipe16={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};