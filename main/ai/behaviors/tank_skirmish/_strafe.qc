/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Strafe
    Tank pivots to face angle to strafe.
    
  Setup
    self.ideal_yaw = 90deg to enemy_yaw - set before move
    self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_tank_sk_enter_strafe={
  
  if( random() < 0.33 )
    self.lefty = self.lefty * -1;
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod( self.ideal_yaw + ( self.lefty * ( 30 + (random() * 30))));
  if( self.ideal_yaw > self.angles_y){
    self.ai_dir = 1;
  }
  else{
    self.ai_dir = 0;
  }
  
  macro_ai_frame(ai_tank_sk_strafe1)
};

//rotate to ideal_yaw, is loopable
void() ai_tank_sk_strafe1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
   
  ChangeYaw();
  ai_attack();
 
  if( self.ai_dir == TRUE ){
    if( self.angles_y >= self.ideal_yaw ){
      macro_ai_frame(ai_tank_sk_strafe2)
      return;
    }
  }
  else{
    if( self.angles_y <= self.ideal_yaw ){
      macro_ai_frame(ai_tank_sk_strafe2)
      return;
    }
  }

  macro_ai_frame(ai_tank_sk_strafe1)
};
//move in direction of ideal_yaw
void() ai_tank_sk_strafe2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
   
  ChangeYaw();
  ai_attack();
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.1;}

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe3)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_enter_reverse)
};  
void() ai_tank_sk_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
    
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.2;}
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe4)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
      
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.3;
  }
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe5)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
    
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
    
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.4;}
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe6)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
      
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.5;}
  
  ai_attack();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe7)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
      
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.6;}
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe8)
    return;
  }
  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
      
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.7;}
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe9)
    return;
  }
  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
      
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.8;}
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_strafe10)
    return;
  }
  macro_ai_frame(ai_tank_sk_enter_reverse)
};
void() ai_tank_sk_strafe10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
    
  ChangeYaw();
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.9;}
  
  if( walkmove( self.angles_y, dampen ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_tank_sk_strafe2)
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  macro_ai_frame(ai_tank_sk_enter_reverse)
};