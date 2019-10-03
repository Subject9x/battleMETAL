/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Patrol
    Patrol frames,
    16 for frame binding at 2 ai : 1 leg anim frame
  Setup
    
*/
void() ai_mech_sk_patrol1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  self.legs.ideal_yaw = self.angles_y;
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol2)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol3)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol4)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol5)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol6)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol7)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol8)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol9)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol10)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol11)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol12)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol13)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol14)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol15)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    movetogoal( self.data_speed_forward );
    macro_ai_frame(ai_mech_sk_patrol16)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};
void() ai_mech_sk_patrol16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.goalentity && self.goalentity != world ){
    macro_ai_frame(ai_mech_sk_patrol1)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_enter_stand)
};