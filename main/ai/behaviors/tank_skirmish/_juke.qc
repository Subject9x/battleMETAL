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
  tank attempts to quickly turn around if enemy is behind it
*/

void() ai_tank_sk_enter_juke={
  ai_face_targ();
  self.ai_dir = self.ideal_yaw;
  macro_ai_frame(ai_tank_sk_juke1)
};

void() ai_tank_sk_juke1={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke2)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke2={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke3)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke3={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke4)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke4={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke5)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke5={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke6)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke6={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke7)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke7={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke8)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke8={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;

  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke9)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke9={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
    
  local float dampen;
  dampen = self.data_speed_forward * AI_RUN_FACTOR;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;

  ai_attack();

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_tank_sk_juke10)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_juke10={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_tank_sk_juke1)
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_reverse1)
};