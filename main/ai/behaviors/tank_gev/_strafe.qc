/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Strafe
    AI moves at a perpendicular angle to initial enemy_yaw,
      kinda like the charge but 90D instead of forward/backward.
      
  Setup
    self.ideal_yaw = 90deg to enemy_yaw -> locked on pre-state
    self.ai_dir = self.ideal_yaw
    self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_enter_strafe={
  self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
  self.lefty = self.lefty * -1;
  self.ai_dir = anglemod( self.ai_dir + (self.lefty * 90) );
  
  macro_ai_frame(ai_gev_strafe1)
};

void() ai_gev_strafe1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = self.data_speed_strafe * 0.4;}
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_strafe2)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = self.data_speed_strafe * 0.5;}
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();}

  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_strafe3)
    return;
  }
  
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = self.data_speed_strafe * 0.6;}
  
  ai_face_targ();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_strafe4)
    return;
  }
  
 macro_ai_frame(ai_gev_rotate1) 
};
void() ai_gev_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = self.data_speed_strafe * 0.7;}
  
  ai_face_targ();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_strafe5)
    return;
  }
  
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = self.data_speed_strafe * 0.8;}
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_strafe6)
    return;
  }
  
  macro_ai_frame(ai_gev_rotate1)};
void() ai_gev_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = self.data_speed_strafe * 0.9;}
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_strafe7)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    macro_ai_frame(ai_gev_strafe8)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    macro_ai_frame(ai_gev_strafe9)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    macro_ai_frame(ai_gev_strafe10)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    macro_ai_frame(ai_gev_strafe11)
    return;
  }
  
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe11={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    macro_ai_frame(ai_gev_strafe12)
    return;
  }
  
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_strafe12={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_gev_strafe1)
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_gev_rotate1)
};
