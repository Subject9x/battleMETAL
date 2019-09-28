/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Charge
    charges in direction of self.ai_dir
    
  Setup
*/
void() ai_mech_sniper_enter_charge={
  if( random() < 0.6 )
    self.lefty = self.lefty * -1; 
  
  self.ai_dir = (random() * 45) * 2;
  self.ai_dir = self.ai_dir * self.lefty;
  self.ai_dir = anglemod( self.angles_y + self.ai_dir );
  self.ideal_yaw = self.ai_dir;
  
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;

  macro_ai_frame(ai_mech_sniper_charge1)
};

void() ai_mech_sniper_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;

  ChangeYaw(); 

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge2)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;
  
  ChangeYaw();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge3)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;
  
  ChangeYaw();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge4)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;
  
  ChangeYaw();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge5)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;
  
  ChangeYaw();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge6)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;
  
  ChangeYaw();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge7)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;
  
  ChangeYaw();
  ai_attack();
  
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge8)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;
  
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge9)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;
  
  ChangeYaw();
  if( walkmove( self.angles_y, dampen ) ){
    macro_ai_frame(ai_mech_sniper_charge10)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sniper_charge11)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sniper_charge12)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw(); 
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sniper_charge13)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sniper_charge14)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sniper_charge15)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sniper_charge16)
    return;
  }  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
void() ai_mech_sniper_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_mech_sniper_charge1)
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    macro_ai_frame(ai_mech_sniper_rotate1)
    return;
  }
  macro_ai_frame(ai_mech_sniper_reverse1)
};
