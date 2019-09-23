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
  CHARGE
  self.ideal_yaw = enemy_yaw
  self.ai_dir = charge yaw
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_gev_charge1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = 0.1;
  if( self.speed == self.lefty )
    dampen = 1;
  
  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen ) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
  ai_attack();

  macro_ai_frame(ai_gev_charge2)
};
void() ai_gev_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.2;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  macro_ai_frame(ai_gev_charge3)
};
void() ai_gev_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.3;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
  
  macro_ai_frame(ai_gev_charge4)
};
void() ai_gev_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.4;
  if( self.speed == self.lefty )
    dampen = 1;
  
  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }

  macro_ai_frame(ai_gev_charge5)
};
void() ai_gev_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.5;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
    
  ai_attack();

  macro_ai_frame(ai_gev_charge6)
};
void() ai_gev_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.6;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
    
  ai_attack();

  macro_ai_frame(ai_gev_charge7)
};
void() ai_gev_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.7;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
    
  ai_attack();

  macro_ai_frame(ai_gev_charge8)
};
void() ai_gev_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.8;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
    
  ai_attack();

  macro_ai_frame(ai_gev_charge9)
};
void() ai_gev_charge9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = 0.9;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.data_speed_forward * dampen) ;
  }
  else{
    ai_yaw_move( 180, self.data_speed_backward * dampen) ;
  }
  
  self.speed = self.lefty;
  macro_ai_frame_count(ai_gev_charge1)
  
  if( ai_check_face( self.enemy, self.ai_fov )){
    if( (self.lefty > 0) && (self.ai_rank > AI_RANK_REG )){
      if( random() < 0.45){
        macro_ai_frame(ai_gev_charge1)
        return;
      }
    }
  }
  
  macro_ai_frame(ai_gev_fight_prep)
};