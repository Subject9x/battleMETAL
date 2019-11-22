/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Snipe
  
  Setup
    
*/
void() ai_mech_sniper_snipe1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  
  self.legs.attack_state = TR_YAW;
  self.legs.think = bot_leg_stand1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sniper_snipe2)
};
void() ai_mech_sniper_snipe2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_snipe3)
};
void() ai_mech_sniper_snipe3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_snipe4)
};
void() ai_mech_sniper_snipe4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe5)
};
void() ai_mech_sniper_snipe5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe6)
};
void() ai_mech_sniper_snipe6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe7)
};
void() ai_mech_sniper_snipe7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe8)
};
void() ai_mech_sniper_snipe8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame_count(ai_mech_sniper_snipe1)
  macro_ai_frame(ai_mech_sniper_fight_prep)
};