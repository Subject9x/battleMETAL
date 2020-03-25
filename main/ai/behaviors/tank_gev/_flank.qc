/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Flank
    AI moves at an angle offset of enemy_yaw in an attempt to get around the target
    
  Setup
    self.ideal_yaw = rand45 to  enemy yaw
    self.ai_dir = enemy yaw
    self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_enter_flank={
  self.ai_dir = self.lefty * ( 50 + (random() * 30));
  macro_ai_frame(ai_gev_flank1)
};

void() ai_gev_flank1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.1;

  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank2)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.2;

  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank3)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.3;

  ai_face_targ();
  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank4)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.4;

  ai_face_targ();  
  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank5)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.5;

  ai_face_targ();
  ai_attack();
 
  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank6)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.6;

  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank7)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.7;

  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank8)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.8;

  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();


  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    macro_ai_frame(ai_gev_flank9)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};
void() ai_gev_flank9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  if( self.speed != self.lefty )
    vel = vel * 0.9;

  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  if( walkmove( anglemod(self.ideal_yaw + self.ai_dir), vel ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_gev_strafe1)
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  self.lefty = -1;
  macro_ai_frame(ai_gev_enter_charge)
};