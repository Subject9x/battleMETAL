/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Pivot
    Mech attempts to pivot to its ideal_yaw   
  Setup
    
*/
void() ai_mech_sk_pivot1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_pivot1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_pivot2)
};
void() ai_mech_sk_pivot2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_pivot3)
};
void() ai_mech_sk_pivot3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();}
  
  macro_ai_frame(ai_mech_sk_pivot4)
};
void() ai_mech_sk_pivot4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();

  macro_ai_frame(ai_mech_sk_pivot5)
};
void() ai_mech_sk_pivot5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
 
  macro_ai_frame(ai_mech_sk_pivot6)
};
void() ai_mech_sk_pivot6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();

  macro_ai_frame(ai_mech_sk_pivot7)
};
void() ai_mech_sk_pivot7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();}
  
  macro_ai_frame(ai_mech_sk_pivot8)
};
void() ai_mech_sk_pivot8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sk_pivot9)
};
void() ai_mech_sk_pivot9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sk_pivot10)
};
void() ai_mech_sk_pivot10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_pivot11)
};
void() ai_mech_sk_pivot11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();

  macro_ai_frame_count(ai_mech_sk_pivot1)
  macro_ai_frame(ai_mech_sk_fight_prep)
};

void() ai_mech_sk_rotate1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ChangeYaw();
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame_count(ai_mech_sk_rotate1)
    macro_ai_frame(ai_mech_sk_stand1)
    return;
  }
  macro_ai_frame(ai_mech_sk_rotate1)
};
