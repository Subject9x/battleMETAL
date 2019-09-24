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
void() ai_spg_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.lefty = self.lefty * -1;
  self.ai_dir = self.lefty * (45 + random() * 25);
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge2)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge3)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
   
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge4)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge5)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge6)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge7)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge8)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge9)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};

void() ai_spg_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( walkmove( self.angles_y, self.data_speed_forward ) ){  
    macro_ai_frame_count(ai_spg_charge1)
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_spg_rotate1)
};