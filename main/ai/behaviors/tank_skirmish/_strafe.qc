/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - MBT
  Behavior - Skirmish
  
  Setup
    
*/
/*
  STRAFE
  self.ideal_yaw = 90deg to enemy_yaw - set before move
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
//rotate to ideal_yaw, is loopable
void() ai_tank_sk_strafe1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  ChangeYaw();
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame(ai_tank_sk_strafe2)
    return;
  }
  macro_ai_frame(ai_tank_sk_strafe1)
};
//move in direction of ideal_yaw
void() ai_tank_sk_strafe2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  ai_attack();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe3)
};  
void() ai_tank_sk_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe4)
};
void() ai_tank_sk_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe5)
};
void() ai_tank_sk_strafe5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe6)
};
void() ai_tank_sk_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe7)
};
void() ai_tank_sk_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe8)
};
void() ai_tank_sk_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame_count(ai_tank_sk_strafe1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};
