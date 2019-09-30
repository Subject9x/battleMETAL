/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
    charge forward a little bit, tracking self.enemy as ideal yaw
    
  Setup
    self.ai_dir = self.lefty * (35 + rand * 25)
    then apply to ideal_yaw
*/

void() ai_spg_enter_charge={
  self.lefty = self.lefty * -1;
  self.ai_dir = self.lefty * (45 + random() * 25);
  macro_ai_frame(ai_spg_charge1)
};

void() ai_spg_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame_count(ai_spg_charge2)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  ai_attack();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge3)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
   
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge4)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge5)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge6)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge7)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge8)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame(ai_spg_charge9)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, dampen ) ){  
    macro_ai_frame_count(ai_spg_charge1)
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  self.ai_action_time = self.ai_action_mod;
  macro_ai_frame(ai_spg_rotate1)
};