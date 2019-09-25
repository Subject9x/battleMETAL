/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - CHARGE
    tank moves towards or away from target, turning to 
  Setup
    self.ideal_yaw = enemy_yaw
    self.ai_dir = charge yaw
    self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_tank_sk_enter_charge={
  self.ai_dir = 0;
  if( self.lefty == -1 ){
    self.ai_dir = 180;
  }
  macro_ai_frame(ai_tank_sk_charge1)
};

void() ai_tank_sk_charge1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  ai_face_targ();
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge2)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge3)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge4)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  ai_attack();
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge5)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge6)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge7)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  ai_attack();

  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge8)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge9)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
  
};
void() ai_tank_sk_charge9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove(ang, self.data_speed_forward) ){
    macro_ai_frame(ai_tank_sk_charge10)
    return;
  }

  macro_ai_frame(ai_tank_sk_rotate1)
};
void() ai_tank_sk_charge10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  local float ang;
  ang = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove( ang, self.data_speed_forward ) ){
    macro_ai_frame_count(ai_tank_sk_charge1)
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  if( self.lefty != -1 ){
    self.lefty = -1;
    macro_ai_frame_count(ai_tank_sk_enter_charge)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_rotate1)
};
