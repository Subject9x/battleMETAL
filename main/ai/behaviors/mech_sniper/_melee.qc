/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Melee
    melee for veterans, tries to shoot some,
    then strafes.
    self.ai_dir = strafe dir, rotate first
    
  Setup
*/
void() ai_mech_sniper_enter_melee={
  self.lefty = self.lefty * -1;
  self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
  
  macro_ai_frame(ai_mech_sniper_melee1)
};

void() ai_mech_sniper_melee1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  self.ideal_yaw = self.ai_dir;
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ChangeYaw();    
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  macro_ai_frame(ai_mech_sniper_melee3)
};
void() ai_mech_sniper_melee3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)

  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_melee4)
};
void() ai_mech_sniper_melee4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_melee5)
};
void() ai_mech_sniper_melee5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee6)
};
void() ai_mech_sniper_melee6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee7)
};
void() ai_mech_sniper_melee7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
    
  self.legs.attack_state = TR_TARG;
  self.legs.ai_dir = self.ai_dir;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee8 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee9 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee10 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;
  
  ai_attack();
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee11 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
       
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;
  
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee12 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee12={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee13 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;
  
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee14 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;
  
  ai_attack();
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee15 ); 
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee15={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;
  
  ai_attack();
  local float moveCheck;
  moveCheck = ai_move_frame( self.ai_dir, dampen, ai_mech_sniper_melee16 );
  if( moveCheck ){
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
void() ai_mech_sniper_melee16={
  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( self.ai_dir, self.data_speed_strafe ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_mech_sniper_melee1)
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  macro_ai_frame(ai_mech_sniper_rotate1)
};
