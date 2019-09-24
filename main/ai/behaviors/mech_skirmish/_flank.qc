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
void() ai_mech_sk_flank1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  if( ai_check_move(walkAng) ){
    local float dampen;
    dampen = 0;
    if( self.speed != self.lefty ){
      //dampen jerk movement
      dampen = self.data_speed_strafe * 0.9;
    }
    
    ai_face_targ();
    walkmove( walkAng, self.data_speed_strafe - dampen);
    self.legs.ai_dir = walkAng;
    self.legs.attack_state = TR_GOAL;
    otemp = self;
    self = self.legs;
      bot_leg_walk1();
    self = otemp;
    
    macro_ai_frame(ai_mech_sk_flank2)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.8;
  }
  
  ai_face_targ();
  self.legs.ai_dir = walkAng;
  ai_attack();
  
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank3)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.7;
  }
  
  ai_face_targ();
  self.legs.ai_dir = walkAng;
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank4)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.6;
  }
  
  ai_face_targ();
  self.legs.ai_dir = walkAng;
  
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank5)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.5;
  }
  
  ai_face_targ();
  self.legs.ai_dir = walkAng;
  
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank6)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.4;
  }
  
  ai_face_targ();
  self.legs.ai_dir = walkAng;
  ai_attack();
  
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank7)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);
  
  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.3;
  }
  
  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe - dampen);
  self.legs.ai_dir = walkAng;
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank8)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.2;
  }
  
  ai_face_targ();
  self.legs.ai_dir = walkAng;
  
 
  if( walkmove( walkAng, self.data_speed_strafe - dampen) ){
    macro_ai_frame(ai_mech_sk_flank9)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_flank9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  local float dampen;
  dampen = 0;
  if( self.speed != self.lefty ){
    //dampen jerk movement
    dampen = self.data_speed_strafe * 0.1;
  }
  
  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe - dampen);
  self.legs.ai_dir = walkAng;
  
  macro_ai_frame(ai_mech_sk_flank10)
};
void() ai_mech_sk_flank10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank11)
};
void() ai_mech_sk_flank11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_flank12)
};
void() ai_mech_sk_flank12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
  
  macro_ai_frame(ai_mech_sk_flank13)
};
void() ai_mech_sk_flank13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
  
  macro_ai_frame(ai_mech_sk_flank14)
};
void() ai_mech_sk_flank14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
  ai_attack();

  macro_ai_frame(ai_mech_sk_flank15)
};
void() ai_mech_sk_flank15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_mech_sk_flank16)
};
void() ai_mech_sk_flank16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
    
  local float walkAng;
  walkAng = anglemod(self.angles_y + self.ai_dir);

  ai_face_targ();
  walkmove( walkAng, self.data_speed_strafe);
  self.legs.ai_dir = walkAng;
  
  self.speed = self.lefty;
  macro_ai_frame_count(ai_mech_sk_flank1)
  
  if( random() < 0.67 ){
    macro_ai_frame(ai_mech_sk_pivot1)
    return;
  } 
  
  macro_ai_frame(ai_mech_sk_fight_prep)
};