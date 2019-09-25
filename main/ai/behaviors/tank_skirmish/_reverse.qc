/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
  
  Setup
    
*/
/*
  Less advanced tanks will attempt to reverse turn 
  to face a foe behind them
*/

void() ai_tank_sk_enter_reverse={
  self.lefty = self.lefty * -1;
  ai_face_targ();
  self.ai_dir = anglemod( self.ideal_yaw + (45 * self.lefty));
  
  macro_ai_frame(ai_tank_sk_reverse1)
};

void() ai_tank_sk_reverse1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = anglemod( self.ai_dir + 180);
  ChangeYaw();
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame(ai_tank_sk_reverse2)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_reverse2={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse3)
};
void() ai_tank_sk_reverse3={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse4)
};
void() ai_tank_sk_reverse4={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse5)
};
void() ai_tank_sk_reverse5={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse6)
};
void() ai_tank_sk_reverse6={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse7)
};
void() ai_tank_sk_reverse7={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_reverse8)
};
void() ai_tank_sk_reverse8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_reverse9)
};
void() ai_tank_sk_reverse9={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse10)
};
void() ai_tank_sk_reverse10={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse11)
};
void() ai_tank_sk_reverse11={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)

  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_reverse12)
};
void() ai_tank_sk_reverse12={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  ChangeYaw();
  walkmove( self.ai_dir, self.data_speed_backward  );
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame_count(ai_tank_sk_reverse1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};