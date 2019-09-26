/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Charge
    mech moves towards target, maintaining yaw at the target,
    OR
    mech moves away from target, maintaining yaw at the target
  
  Setup
    self.lefty = 1 Forward | -1 Backward
    self.ideal_yaw = enemy yaw
*/
void() ai_mech_sk_enter_charge={
  
  if( self.lefty == -1 ){
    self.ai_dir = 180;
    self.legs.think = bot_leg_back1;
    self.legs.attack_state = TR_NORM;
  }
  else{
    self.ai_dir = 0;
    self.legs.think = bot_leg_walk1;
    self.legs.attack_state = TR_NORM;
  }
  
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_charge1)
};

void() ai_mech_sk_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
  
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge2)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;
    
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge3)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;
    
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge4)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;
    
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge5)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;
    
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge6)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;
    
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge7)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;
    
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge8)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;
    
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_charge9)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;
    
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen ) ){
    macro_ai_frame(ai_mech_sk_charge10)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
    
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sk_charge11)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
    
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sk_charge12)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float dampen;
  dampen = self.data_speed_forward;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
    
  ai_face_targ();
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sk_charge13)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();  
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sk_charge14)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sk_charge15)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();  
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    macro_ai_frame(ai_mech_sk_charge16)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_forward ) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_mech_sk_strafe1)
    
    if( random() < 0.75 ){
      macro_ai_frame(ai_mech_sk_pivot1)
      return;
    }
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_pivot1)
};
