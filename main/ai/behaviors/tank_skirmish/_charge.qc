/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - CHARGE
  
  Setup
    self.ideal_yaw = enemy_yaw
    self.ai_dir = charge yaw
    self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_tank_sk_enter_charge={
  self.ai_dir = 0;
  if( self.lefty == -1 ){
    self.ai_dir = 180;
  }
};

void() ai_tank_sk_charge1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_charge2)
};
void() ai_tank_sk_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge3)
};
void() ai_tank_sk_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge4)
};
void() ai_tank_sk_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  ai_attack();

  macro_ai_frame(ai_tank_sk_charge5)
};
void() ai_tank_sk_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge6)
};
void() ai_tank_sk_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge7)
};
void() ai_tank_sk_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  ai_attack();

  macro_ai_frame(ai_tank_sk_charge8)
};
void() ai_tank_sk_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_tank_sk_charge9)
};
void() ai_tank_sk_charge9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge10)
};
void() ai_tank_sk_charge10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  
  macro_ai_frame_count(ai_tank_sk_charge1)
  
  macro_ai_frame(ai_tank_sk_fight_prep)
};
