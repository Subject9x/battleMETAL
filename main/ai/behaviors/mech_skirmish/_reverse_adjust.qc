/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Reverse Adjust
    move straight back, regardless of enemy yaw,
    but randomize angle
    
  Setup
    self.lefty
    self.ai_dir = self.lefty * (45 + random() * 60);
    self.ideal_yaw = enemy yaw + self.ai_dir
*/
void() ai_mech_sk_enter_reverse_adjust={
  local float roll;
  roll = random();
  if( roll < 0.6 ){
    self.lefty = -1;
  }
  else{
    self.lefty = 1;
  }
  self.speed = self.lefty * -1;
  
  self.ai_dir = 180 + (self.lefty * (10 + roll * 30));
  self.ai_dir = anglemod(self.angles_y + self.ai_dir);
  self.ideal_yaw = self.angles_y;
  
  self.legs.ai_dir = self.ideal_yaw;
  self.legs.attack_state = TR_TARG;
  self.legs.think = bot_leg_back1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_reverse_adjust1)
};

void() ai_mech_sk_reverse_adjust1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
  
  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust2)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;
  
  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust3)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;
  
  ChangeYaw();
  if( walkmove( self.ai_dir, dampen) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust4)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;
  
  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust5)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;
  
  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust6)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;
  
  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust7)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;

  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    macro_ai_frame(ai_mech_sk_reverse_adjust8)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};

void() ai_mech_sk_reverse_adjust8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_backward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;

  ChangeYaw();
  if( walkmove( self.ai_dir, dampen ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_mech_sk_reverse_adjust1)
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
