/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Rotate
  
  Setup
    
*/
/*
  Mech Sniper rotates to face target
*/  
void() ai_mech_sniper_rotate1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.attack_state = TR_NORM;
  
  macro_ai_frame(ai_mech_sniper_rotate2)
};
void() ai_mech_sniper_rotate2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate3)
};
void() ai_mech_sniper_rotate3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_rotate4)
};
void() ai_mech_sniper_rotate4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_rotate5)
};
void() ai_mech_sniper_rotate5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate6)
};
void() ai_mech_sniper_rotate6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate7)
};
void() ai_mech_sniper_rotate7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate8)
};
void() ai_mech_sniper_rotate8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};

/*
  Turns to face ideal_yaw,
  but not based on target
*/
void() ai_mech_sniper_turn1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_turn2)
};
void() ai_mech_sniper_turn2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_turn3)
};
void() ai_mech_sniper_turn3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_turn4)
};
void() ai_mech_sniper_turn4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
  if( !ai_check_vis(self.enemy) ){
    self.enemy = world;
    macro_ai_frame(ai_mech_sniper_patrol1)
  }
  
  macro_ai_frame_count(ai_mech_sniper_turn1)
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};