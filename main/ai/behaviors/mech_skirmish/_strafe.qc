/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Strafe
  
  Setup
    
*/
/*
  move 90d to target
  first adjusts to angle then walks that dir
  self.ideal_yaw = enemy_yaw + mod
  but bake it in
*/
void() ai_mech_sk_strafe1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  ChangeYaw();
  self.legs.attack_state = TR_NORM;
  otemp = self;
  self = self.legs;
    bot_leg_walk1();
  self = otemp;
  if( self.angles_y != self.ideal_yaw ){
    macro_ai_frame(ai_mech_sk_strafe1)
    return;
  }

  ai_attack();
  macro_ai_frame(ai_mech_sk_strafe2)
};
void() ai_mech_sk_strafe2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  local float dampen;
  dampen = 0.1;
  if( self.speed == self.lefty )
    dampen = 1;
    
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe3)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.2;
  if( self.speed == self.lefty )
    dampen = 1;
   

  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe4)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.2;
  if( self.speed == self.lefty )
    dampen = 1;
   
  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe5)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.4;
  if( self.speed == self.lefty )
    dampen = 1;
   
  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe6)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.5;
  if( self.speed == self.lefty )
    dampen = 1;
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe7)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
 
 local float dampen;
  dampen = 0.6;
  if( self.speed == self.lefty )
    dampen = 1;

  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe8)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.7;
  if( self.speed == self.lefty )
    dampen = 1;
   
  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe9)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.7;
  if( self.speed == self.lefty )
    dampen = 1;
   
  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe10)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
 
  local float dampen;
  dampen = 0.8;
  if( self.speed == self.lefty )
    dampen = 1;
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe11)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  local float dampen;
  dampen = 0.9;
  if( self.speed == self.lefty )
    dampen = 1;

  if( walkmove( self.angles_y, self.data_speed_strafe * dampen) ){
    macro_ai_frame(ai_mech_sk_strafe12)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  if( walkmove( self.angles_y, self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_strafe13)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_strafe14)
    return;
  }

  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
   
  if( walkmove( self.angles_y, self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_strafe15)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  if( walkmove( self.angles_y, self.data_speed_strafe) ){
    macro_ai_frame(ai_mech_sk_strafe16)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};
void() ai_mech_sk_strafe16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  if( walkmove( self.angles_y, self.data_speed_strafe) ){  
    self.speed = self.lefty;
    macro_ai_frame_count(ai_mech_sk_strafe1)
    
    if( random() < 0.67 ){
      macro_ai_frame(ai_mech_sk_pivot1)
      return;
    }
    
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  macro_ai_frame(ai_mech_sk_pivot1)
};