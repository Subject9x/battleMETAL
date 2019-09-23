/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Charge
  
  Setup
    
*/

/*
  self.lefty = 1 Forward | -1 Backward
  self.ideal_yaw = enemy yaw
*/
void() ai_mech_sk_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
    otemp = self;
    self = otemp.legs;
      self.attack_state = TR_NORM;
      bot_leg_walk1();
    self = otemp;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    otemp = self;
    self = otemp.legs;
      self.attack_state = TR_GOAL;
      self.ai_dir = anglemod(self.angles_y + 180);
      bot_leg_back1();
    self = otemp;
  }
  
  macro_ai_frame(ai_mech_sk_charge2)
};
void() ai_mech_sk_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_charge3)
};
void() ai_mech_sk_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  } 
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge4)
};
void() ai_mech_sk_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge5)
};
void() ai_mech_sk_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge6)
};
void() ai_mech_sk_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_charge7)
};
void() ai_mech_sk_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge8)
};
void() ai_mech_sk_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge9)
};
void() ai_mech_sk_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge10)
};
void() ai_mech_sk_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_charge11)
};
void() ai_mech_sk_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge12)
};
void() ai_mech_sk_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
    
  macro_ai_frame(ai_mech_sk_charge13)
};
void() ai_mech_sk_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge14)
};
void() ai_mech_sk_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_charge15)
};
void() ai_mech_sk_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge16)
};
void() ai_mech_sk_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward);
    self.legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame_count(ai_mech_sk_strafe1)
  
  if( random() < 0.75 ){
    macro_ai_frame(ai_mech_sk_pivot1)
    return;
  } 
  
  macro_ai_frame(ai_mech_sk_fight_prep)
};
