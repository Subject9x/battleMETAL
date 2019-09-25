/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - flank
    tank attempts to move around the target
    can rotate in motion
  
  Setup
    self.ai_dir setup before running this with the offset
    self.lefty = 1 LEFT || -1 RIGHT
    
*/
void() ai_tank_sk_enter_flank={
  self.lefty = self.lefty * -1;
  self.ai_dir = self.lefty * ( 25 + (random() * 30));
  
  macro_ai_frame(ai_tank_sk_flank1)
};

void() ai_tank_sk_flank1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = 0.1;
  if( self.speed != self.lefty )
    dampen = 1;
  
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  
  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank2)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
  
};
void() ai_tank_sk_flank2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = 0.2;
  if( self.speed != self.lefty )
    dampen = 1;
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank3)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = 0.3;
  if( self.speed != self.lefty )
    dampen = 1;
  
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank4)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = 0.4;
  if( self.speed != self.lefty )
    dampen = 1;
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank5)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = 0.5;
  if( self.speed != self.lefty )
    dampen = 1;
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank8)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = 0.6;
  if( self.speed != self.lefty )
    dampen = 1;
  
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank7)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = 0.7;
  if( self.speed != self.lefty )
    dampen = 1;
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank8)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = 0.8;
  if( self.speed != self.lefty )
    dampen = 1;
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank9)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = 0.8;
  if( self.speed != self.lefty )
    dampen = 1;
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward * dampen ) ){
    macro_ai_frame(ai_tank_sk_flank10)
    return;
  }
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_flank10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  self.speed = self.lefty;
  
  macro_ai_frame_count(ai_tank_sk_flank1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};
