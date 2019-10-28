/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Patrol
    Patrol frames,
  16 for frame binding at 2 ai : 1 leg anim frame
  Setup
    
*/
void() ai_mech_sniper_patrol1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  self.legs.attack_state = TR_GOAL;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  self.torsoCenter.attack_state = TR_NORM;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol2 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol3 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol4 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol5 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol6 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol7 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol8 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol9 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol10 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol11 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol12 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol13 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol14 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol15 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol16 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
void() ai_mech_sniper_patrol16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  local float patrolCheck;
  patrolCheck = ai_patrol_logic( self.data_speed_forward, ai_mech_sniper_enter_stand, ai_mech_sniper_patrol1 );
  if( !patrolCheck ){
    macro_ai_frame(ai_mech_sniper_enter_stand)
  }
};
