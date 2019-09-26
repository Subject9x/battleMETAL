/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Reverse
  
  Setup
    
*/
void() ai_mech_sniper_reverse1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.attack_state = TR_NORM;
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_reverse2)
};
void() ai_mech_sniper_reverse2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_reverse3)
};
void() ai_mech_sniper_reverse3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_reverse4)
};
void() ai_mech_sniper_reverse4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_reverse5)
};
void() ai_mech_sniper_reverse5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  self.legs.attack_state = TR_YAW;
  self.legs.think = bot_leg_back1;
  self.legs.nextthink = time + 0.1;
  
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse6)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  self.legs.ai_dir = anglemod(self.angles_y + 180);  
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse7)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse8)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse9)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse10)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180); 
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse11)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
 
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse12)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  
  if( walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ){
    macro_ai_frame(ai_mech_sniper_reverse13)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_reverse13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
 
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_reverse14)
};
void() ai_mech_sniper_reverse14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_reverse15)
};
void() ai_mech_sniper_reverse15={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  macro_ai_frame(ai_mech_sniper_reverse16)
};
void() ai_mech_sniper_reverse16={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};
