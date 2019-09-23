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
  STRAFE
  self.ideal_yaw = 90deg to enemy_yaw -> locked on pre-state
  self.ai_dir = self.ideal_yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_strafe1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = self.data_speed_strafe * 0.67;
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe - dampen );
  ai_attack();
    
  macro_ai_frame(ai_gev_strafe2)
};
void() ai_gev_strafe2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = self.data_speed_strafe * 0.57;
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe - dampen );
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  
  macro_ai_frame(ai_gev_strafe3)
};
void() ai_gev_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = self.data_speed_strafe * 0.57;
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe - dampen );
  
  macro_ai_frame(ai_gev_strafe4)
};
void() ai_gev_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = self.data_speed_strafe * 0.47;
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe - dampen );
  
  macro_ai_frame(ai_gev_strafe5)
};
void() ai_gev_strafe5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = self.data_speed_strafe * 0.37;
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe - dampen );
  ai_attack();
  
  macro_ai_frame(ai_gev_strafe6)
};
void() ai_gev_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty )
    dampen = self.data_speed_strafe * 0.27;
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe - dampen );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_strafe7)
};
void() ai_gev_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe );
  
  macro_ai_frame(ai_gev_strafe8)
};
void() ai_gev_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe );

  macro_ai_frame(ai_gev_strafe9)
};
void() ai_gev_strafe9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe );
  ai_attack();
  
  macro_ai_frame(ai_gev_strafe10)
};
void() ai_gev_strafe10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_strafe11)
};
void() ai_gev_strafe11={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe );
  
  macro_ai_frame(ai_gev_strafe12)
};
void() ai_gev_strafe12={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_strafe );
  
  self.speed = self.lefty;
  macro_ai_frame_count(ai_gev_strafe1)
  macro_ai_frame(ai_gev_fight_prep)
};
