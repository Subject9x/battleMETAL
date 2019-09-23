/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Skirmish
  
  Setup
    
*/
void() ai_gev_rotate1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  
  macro_ai_frame(ai_gev_rotate2)
};
void() ai_gev_rotate2={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();

  macro_ai_frame(ai_gev_rotate3)
};
void() ai_gev_rotate3={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  
  macro_ai_frame(ai_gev_rotate4)
};
void() ai_gev_rotate4={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_gev_rotate5)
};
void() ai_gev_rotate5={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_gev_rotate6)
};
void() ai_gev_rotate6={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_fight_prep)
};