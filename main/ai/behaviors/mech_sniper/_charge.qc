/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Charge
  
  Setup
    
*/
/*
  charges in direction of self.ai_dir
  
*/
void() ai_mech_sniper_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  self.ideal_yaw = self.ai_dir;
  ChangeYaw(); 
  otemp = self;
  self = self.legs;
    bot_leg_walk1();
    self.attack_state = TR_NORM;
  self = otemp;
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge2)
};
void() ai_mech_sniper_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge3)
};
void() ai_mech_sniper_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge4)
};
void() ai_mech_sniper_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge5)
};
void() ai_mech_sniper_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge6)
};
void() ai_mech_sniper_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge7)
};
void() ai_mech_sniper_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_charge8)
};
void() ai_mech_sniper_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_mech_sniper_charge9)
};
void() ai_mech_sniper_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );

  macro_ai_frame(ai_mech_sniper_charge10)
};
void() ai_mech_sniper_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );

  macro_ai_frame(ai_mech_sniper_charge11)
};
void() ai_mech_sniper_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge12)
};
void() ai_mech_sniper_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 
  macro_ai_frame(ai_mech_sniper_charge13)
};
void() ai_mech_sniper_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge14)
};
void() ai_mech_sniper_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge15)
};
void() ai_mech_sniper_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge16)
};
void() ai_mech_sniper_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};
