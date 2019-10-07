/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
    turn perpendicular and move for a tad.
    these aren't the best moves a tank destroyer can make.
    
  Setup
    self.lefty = self.lefty * -1;
    self.ai_dir = 35 + ceil(roll * 60);
    self.ai_dir = self.ai_dir * self.lefty;
    self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
*/

void() ai_spg_enter_strafe={
  cons_logAFloat("ai_spg_enter_strafe", 1);  //DEBUG
  self.lefty = self.lefty * -1;
  self.ai_dir = 35 + random() * 60;
  self.ai_dir = self.ai_dir * self.lefty;

  macro_ai_frame(ai_spg_strafe1)
};
void() ai_spg_strafe1={
  
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();  
  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe2)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe3)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe4)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe5)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);

  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe6)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe7)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ideal_yaw = anglemod(self.ideal_yaw + self.ai_dir);
  ChangeYaw();
  if( walkmove( self.angles_y, self.data_speed_strafe )){
    macro_ai_frame(ai_spg_strafe8)
    return;
  }
  macro_ai_frame(ai_spg_reverse1)
};
void() ai_spg_strafe8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  macro_ai_frame_count(ai_spg_strafe1)
  macro_ai_frame(ai_spg_fight_prep)
};