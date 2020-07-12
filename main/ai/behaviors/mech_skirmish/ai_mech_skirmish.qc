/*
battleMETAL 
Author: Peter Roohr
Date: 7/20/2018
rebuild: 2/16/2019
rebuild: 07/01/2020
Overview: ai unit
  Mech - Skirmisher
  an on-ground, turreted, walking unit
  skirmishers play to engage targets at medium to close range
  they can strafe left and right against targets
*/

/*
  STATE : STAND
*/
void() ai_mech_sk_stand={
  ai_update_accuracy( FALSE );
  
  //Enter state
  if(self.ai_state == ST_STAND &&  self.ai_state_last != ST_STAND ){
    cons_logAString("new state", "sk_stand"); //debug
    //entering stand state
    self.torsoCenter.attack_state = TR_NORM;
    self.legs.attack_state = TR_NORM;
    self.legs.think = bot_leg_stand1;
    self.legs.nextthink = time + 0.1;
    self.goalentity = world;
    return;
  }
  //-----------------
  cons_logAString("running--------", "sk_stand"); //debug
  if( ai_valid_target(self.enemy) ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.patrolNode != world ){
    if( time > self.pausetime ){
      self.ai_state_next = ST_PTR;
      return;
    }
  }
  
  if( self.torsoCenter.angles_y == self.torsoCenter.ideal_yaw ){
    self.torsoCenter.attack_state = TR_NORM;
  }
  if( random() > 0.9 && self.torsoCenter.attack_state != TR_YAW){
    self.ai_action_time = self.ai_action_mod * (self.ai_rank * 2);
    self.torsoCenter.ai_dir = (crandom() * self.ai_angleLimits_x);
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir + self.ai_angleLimits_y;
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir * crandom();
    self.torsoCenter.ai_dir = anglemod( self.angles_y + self.torsoCenter.ai_dir);
    self.torsoCenter.attack_state = TR_YAW;
    return;
  }
};

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={
  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  self.th_react = ai_mech_sk_react1;
  self.th_die = ai_mech_sk_die;
  
  ai_setup_patrol();
  
  self.SendEntity = ctrl_send_mech_ai;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  //new state stuff
  self.ai_state_last = 0;
  
  if(self.patrolNode){
    self.ai_state_next = ST_PTR;
  }
  else{
    self.ai_state_next = ST_STAND; //debug
  }
  
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND; //debug
  self.ai_dance_card = (MOVE_CHARGE | MOVE_CHARGE_LEFT | MOVE_CHARGE_RIGHT | MOVE_STRAFE_LEFT | MOVE_STRAFE_RIGHT | MOVE_BACK | MOVE_CIRCLE_LEFT | MOVE_CIRCLE_RIGHT | MOVE_STAND_FACE);
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ai_ctrl_update_mechplayer;
  
  //ai state interface--------------------------------------------------------
  self.ai_state_stand = ai_mech_sk_stand;
  self.ai_state_patrol = ai_mech_sk_patrol;
  self.ai_state_patrol_pause = ai_mech_sk_ptr_pause;
  self.ai_state_patrol_travel_node = ai_mech_sk_ptr_travel_node;
  self.ai_state_patrol_travel_blocked = ai_mech_sk_ptr_travel_blocked;
  self.ai_state_patrol_tether = ai_mech_sk_ptr_tether;
  self.ai_state_patrol_tether_blocked = ai_mech_sk_ptr_tether_blocked;
  
  self.ai_state_combat = mech_sk_combat;
  self.ai_state_combat_moveStart = mech_sk_com_moveStart;
  self.ai_state_combat_moveExec = mech_sk_com_moveExec;
  self.ai_state_combat_moveEnd = mech_sk_com_moveEnd;
  self.ai_state_combat_blocked = mech_sk_com_blocked;
  
  self.ai_state_trail_move = mech_sk_trail_move;
  self.ai_state_trail_move_block = mech_sk_trail_move_block;
  self.ai_state_trail_rollback = mech_sk_trail_rollback;
  self.ai_state_trail_rollback_block = mech_sk_trail_rollback_block;
  //--------------------------------------------------------------------------
  self.think = ai_state_frame;
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
};