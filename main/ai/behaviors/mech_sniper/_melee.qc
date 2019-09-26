/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Melee
    melee for veterans, tries to shoot some,
    then strafes.
    self.ai_dir = strafe dir, rotate first
    
  Setup
    
*/
void() ai_mech_sniper_enter_melee={
  self.lefty = self.lefty * -1;
  self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
  
  macro_ai_frame(ai_mech_sniper_melee1)
};

void() ai_mech_sniper_melee1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  self.ideal_yaw = self.ai_dir;
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
    
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  
  macro_ai_frame(ai_mech_sniper_melee3)
};
void() ai_mech_sniper_melee3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)

  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_melee4)
};
void() ai_mech_sniper_melee4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_melee5)
};
void() ai_mech_sniper_melee5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee6)
};
void() ai_mech_sniper_melee6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee7)
};
void() ai_mech_sniper_melee7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
   
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_walk1;
  
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee9)
    return;
  }
};
void() ai_mech_sniper_melee8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee9)
    return;
  }
};
void() ai_mech_sniper_melee9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee10)
    return;
  }
};
void() ai_mech_sniper_melee10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
      
  if( self.ai_rank > AI_RANK_REG )
    ai_attack();
  
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee11)
    return;
  }
};
void() ai_mech_sniper_melee11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee12)
    return;
  }
};
void() ai_mech_sniper_melee12={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  

  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee13)
    return;
  }
};
void() ai_mech_sniper_melee13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_attack();
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame(ai_mech_sniper_melee14)
    return;
  }
  
};
void() ai_mech_sniper_melee14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  if( walkmove( self.angles_y, self.data_speed_strafe ) ){
    macro_ai_frame_count(ai_mech_sniper_melee1)
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
};
