/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
    rotate in place to self.ideal_yaw
  Setup
    
*/
void() ai_tank_sk_enter_rotate={
  ai_face_targ();
  self.torsoCenter.attack_state = TR_TARG;
  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_rotate1={
  local float tempYaw;

  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = tempYaw * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  macro_ai_frame(ai_tank_sk_rotate2)
};
void() ai_tank_sk_rotate2={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;

  macro_ai_frame(ai_tank_sk_rotate3)
};
void() ai_tank_sk_rotate3={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  macro_ai_frame(ai_tank_sk_rotate4)
};
void() ai_tank_sk_rotate4={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  macro_ai_frame(ai_tank_sk_rotate5)
};
void() ai_tank_sk_rotate5={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  macro_ai_frame(ai_tank_sk_rotate6)
};
void() ai_tank_sk_rotate6={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_rotate7)
};
void() ai_tank_sk_rotate7={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;

  ai_attack();
  
  macro_ai_frame(ai_tank_sk_rotate8)
};
void() ai_tank_sk_rotate8={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_rotate9)
};
void() ai_tank_sk_rotate9={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;

  ai_attack();
  
  macro_ai_frame(ai_tank_sk_rotate10)
};
void() ai_tank_sk_rotate10={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.85;
  ai_face_targ();
  self.yaw_speed = tempYaw;

  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_fight_prep)
};