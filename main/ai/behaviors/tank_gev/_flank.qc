/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Skirmish
  
  Setup
    
*/
/*
  FLANK
  self.ideal_yaw = rand45 to  enemy yaw
  self.ai_dir = enemy yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_flank1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.9;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  ai_attack();
  
  macro_ai_frame(ai_gev_flank2)
};
void() ai_gev_flank2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.8;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_flank3)
};
void() ai_gev_flank3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.7;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  
  macro_ai_frame(ai_gev_flank4)
};
void() ai_gev_flank4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.6;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  
  macro_ai_frame(ai_gev_flank5)
};
void() ai_gev_flank5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.5;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  ai_attack();
  
  macro_ai_frame(ai_gev_flank6)
};
void() ai_gev_flank6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.4;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_gev_flank7)
};
void() ai_gev_flank7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.3;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_flank8)
};
void() ai_gev_flank8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.2;

  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_flank9)
};
void() ai_gev_flank9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  local float vel;
  vel = (self.data_speed_strafe + self.data_speed_forward)/2;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = vel * 0.1;


  ai_face_targ();
  ai_yaw_move( self.ai_dir, vel - dampen);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  self.speed = self.lefty;
  macro_ai_frame_count(ai_gev_strafe1)
  macro_ai_frame(ai_gev_fight_prep)
};