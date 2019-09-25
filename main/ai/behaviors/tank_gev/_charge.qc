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
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
  
  ai_face_targ();
  ai_attack();
  
  walkmove( self.ai_dir, dampen );

  macro_ai_frame(ai_gev_charge2)
};
void() ai_gev_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;

  ai_face_targ();

  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  walkmove( self.ai_dir, dampen );
  
  macro_ai_frame(ai_gev_charge3)
};
void() ai_gev_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;

  ai_face_targ();


  walkmove( self.ai_dir, dampen );
  
  macro_ai_frame(ai_gev_charge4)
};
void() ai_gev_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;
  
  ai_face_targ();
  
  walkmove( self.ai_dir, dampen );

  macro_ai_frame(ai_gev_charge5)
};
void() ai_gev_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;

  ai_face_targ();  
  ai_attack();
  
  walkmove( self.ai_dir, dampen );
  

  macro_ai_frame(ai_gev_charge6)
};
void() ai_gev_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;

  ai_face_targ();     
  ai_attack();
  
  walkmove( self.ai_dir, dampen );
  
  macro_ai_frame(ai_gev_charge7)
};
void() ai_gev_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;

  ai_face_targ();
  ai_attack();
  
  walkmove( self.ai_dir, dampen );

  macro_ai_frame(ai_gev_charge8)
};
void() ai_gev_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;

  ai_face_targ();
  ai_attack();
  
  walkmove( self.ai_dir, dampen );

  macro_ai_frame(ai_gev_charge9)
};
void() ai_gev_charge9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;

  ai_face_targ();
  
  walkmove( self.ai_dir, dampen );
  
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