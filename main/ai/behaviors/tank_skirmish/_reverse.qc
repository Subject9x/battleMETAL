/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
    Less advanced tanks will attempt to reverse turn 
    to face a foe behind them
    
  Setup
    randomized self.lefty
    self.ideal_yaw = target angle, then revese
    
*/
void() ai_tank_sk_enter_reverse={
  self.lefty = self.lefty * -1;
  ai_face_targ();
  self.ai_dir = self.ideal_yaw - 180;
  self.ai_dir = anglemod( self.lefty * ( 180 + (20 + random() * 25)));
  self.ideal_yaw = anglemod(self.angles_y + self.ai_dir);
  macro_ai_frame(ai_tank_sk_reverse1)
};

void() ai_tank_sk_reverse1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.1;
  }
  ChangeYaw();
  ai_attack();
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse2)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse2={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.2;}

  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();}
  
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse3)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse3={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.3;}

  ChangeYaw();
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse4)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse4={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.4;}

  ChangeYaw();
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse5)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse5={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.5;}
 
  ChangeYaw();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse6)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse6={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.6;}

  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse7)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse7={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.7;}

  ChangeYaw();
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse8)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.8;}

  ChangeYaw();
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse9)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse9={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty ){
    dampen = dampen * 0.9;}

  ChangeYaw();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y), dampen )){
    macro_ai_frame(ai_tank_sk_reverse10)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse10={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();}
  
  if( walkmove( anglemod(self.angles_y), self.data_speed_backward )){
    macro_ai_frame(ai_tank_sk_reverse11)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse11={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  ai_face_targ();
  if( walkmove( anglemod(self.angles_y), self.data_speed_backward )){
    macro_ai_frame(ai_tank_sk_reverse12)
    return;
  }

  macro_ai_frame(ai_tank_sk_enter_rotate)
};
void() ai_tank_sk_reverse12={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  ai_face_targ();
  if( walkmove( anglemod(self.angles_y), self.data_speed_backward )){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_tank_sk_reverse1)
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  macro_ai_frame(ai_tank_sk_enter_rotate)
};