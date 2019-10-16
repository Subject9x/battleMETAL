/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
    turns to face target
    tries to line up shot when accurate.
    Accuracy is given a slight boost to simulate 'getting lock'.
    
  Setup
    
*/
void() ai_spg_snipe1={
  ai_sfx_kill();
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe2)
};
void() ai_spg_snipe2={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe3)
};
void() ai_spg_snipe3={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe4)
};
void() ai_spg_snipe4={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe5)
};
void() ai_spg_snipe5={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe6)
};
void() ai_spg_snipe6={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe7)
};
void() ai_spg_snipe7={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe8)
};
void() ai_spg_snipe8={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe9)
};
void() ai_spg_snipe9={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe10)
};
void() ai_spg_snipe10={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe11)
};
void() ai_spg_snipe11={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe12)
};
void() ai_spg_snipe12={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe13)
};
void() ai_spg_snipe13={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
 
  macro_ai_frame(ai_spg_snipe14)
};
void() ai_spg_snipe14={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe15)
};
void() ai_spg_snipe15={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe16)
};
void() ai_spg_snipe16={
  self.accuracyMod = self.spreadDefault_z * 0.67;
  ai_update_accuracy( FALSE );
  self.accuracyMod = 0;
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};