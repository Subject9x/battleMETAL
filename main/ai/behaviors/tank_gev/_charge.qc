/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Charge
    GEV charges straight-forward or backwards physically,
      but will turn chassis to face enemy
      
  Setup
    self.ideal_yaw = enemy_yaw
    self.ai_dir = charge yaw
    self.lefty = 1 FORWARD || -1 BACKWARD
*/

void() ai_gev_enter_charge={
  self.ai_dir = self.angles_y;
  if( self.lefty == -1 ){
    self.ai_dir = anglemod( self.ai_dir + 180 );
  }
  macro_ai_frame(ai_gev_charge1)
};

void() ai_gev_charge1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.1;}
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge2)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.2;}

  ai_face_targ();

  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge3)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.3;}

  ai_face_targ();

  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge4)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.4;}
  
  ai_face_targ();

  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge5)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.5;}

  ai_face_targ();  
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge6)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.6;}

  ai_face_targ();     
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge7)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.7;}

  ai_face_targ();
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge8)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.8;}

  ai_face_targ();
  ai_attack();
  
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_gev_charge9)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};
void() ai_gev_charge9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.9;}

  ai_face_targ();
  
  if( walkmove( self.ai_dir, dampen ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_gev_charge1)
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  macro_ai_frame(ai_gev_rotate1)
};