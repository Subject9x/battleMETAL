/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Flank
    Mech moves to the side of its target, maintaining an offset yaw
  
  Setup
    self.lefty
    self.ai_dir = self.lefty * (45 + random() * 60);
    self.ideal_yaw = enemy yaw + self.ai_dir
*/
void() ai_mech_sk_enter_flank={
  self.ai_dir = self.lefty * (60 + (random() * 30));
  
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_flank1)
};

void() ai_mech_sk_flank1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.1;
  
  ai_face_targ();
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank2)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.2;
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank3)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.3;
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank4)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.4;
  
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank5)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.5;
  
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank6)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.6;
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank7)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.7;
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank8)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.8;
  
  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank9)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  local float dampen;
  dampen = self.data_speed_strafe;
  if( self.speed != self.lefty )
    dampen = dampen * 0.9;
  
  ai_face_targ();
  if( walkmove( anglemod(self.angles_y + self.ai_dir), dampen) ){
    macro_ai_frame(ai_mech_sk_flank10)
    return;
  }
  
};
void() ai_mech_sk_flank10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_flank11)
    return;
  }
  
};
void() ai_mech_sk_flank11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_flank12)
    return;
  }
  
};
void() ai_mech_sk_flank12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_face_targ();
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_flank13)
    return;
  }
  
};
void() ai_mech_sk_flank13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_face_targ();

  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_flank14)
    return;
  }
  
};
void() ai_mech_sk_flank14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_face_targ();
  ai_attack();

  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_flank15)
    return;
  }
  
};
void() ai_mech_sk_flank15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)


  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_flank16)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};
void() ai_mech_sk_flank16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  
  if( walkmove( anglemod(self.angles_y + self.ai_dir), self.data_speed_strafe) ){
    self.speed = self.lefty;
    macro_ai_frame_count(ai_mech_sk_flank1)
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
};