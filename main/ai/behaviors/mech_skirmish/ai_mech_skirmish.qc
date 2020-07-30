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
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={
  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  

  
  self.SendEntity = ctrl_send_mech_ai;
  
  //new state stuff
  self.ai_state_last = 0;
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND;
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ai_ctrl_update_mechplayer;
  
  self.th_pain = ai_react_generic;
  self.th_die = ai_mech_sk_die;
  //ai state interface--------------------------------------------------------
  self.ai_state_stand = ai_mech_sk_stand;
 
  self.ai_state_patrol = ai_patrol;
  self.ai_state_patrol_pause = ai_ptr_pause;
  self.ai_state_patrol_travel_node = ai_ptr_travel_node;
  self.ai_state_patrol_travel_blocked = ai_ptr_travel_blocked;
  self.ai_state_patrol_tether = ai_ptr_tether;
  self.ai_state_patrol_tether_blocked = ai_ptr_tether_blocked;
  
  self.ai_state_tether = ai_tether;
  self.ai_state_tether_pause = ai_thr_pause;
  self.ai_state_tether_travel = ai_thr_travel;
  self.ai_state_tether_travel_block = ai_thr_travel_block;
  
  self.ai_state_combat = ai_combat_start;
  self.ai_state_combat_moveStart = ai_com_moveStart;
  self.ai_state_combat_moveExec = ai_com_moveExec;
  self.ai_state_combat_moveEnd = ai_com_moveEnd;
  self.ai_state_combat_blocked = ai_com_blocked;
  
  self.ai_fight_take_fire = mech_sk_fight_target_fire;
  self.ai_fight_out_radius = mech_sk_fight_out_radius;
  self.ai_fight_vis_friend = mech_sk_fight_vis_friend;
  self.ai_fight_building = mech_sk_fight_building;
  self.ai_fight_target = mech_sk_fight_full;
  //--------------------------------------------------------------------------
  self.think = ai_setup_patrol;
  self.nextthink = time + 2;
};

/*
  STATE : STAND
*/
void() ai_mech_sk_stand={
  ai_update_accuracy( FALSE );
  
  //Enter state
  if(self.ai_state == ST_STAND &&  self.ai_state_last != ST_STAND ){
    //entering stand state
    self.torsoCenter.attack_state = TR_NORM;
    self.legs.attack_state = TR_NORM;
    self.legs.think = bot_leg_stand1;
    self.legs.nextthink = time + 0.1;
    self.goalentity = world;
    return;
  }
  //-----------------
  if( ai_valid_target(self.enemy) ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.patrolNode != world ){
    if( self.patrolNode.classname == "ai_node" && self.tetherStatus == TETHER_PATROL ){
      if( time > self.pausetime ){
        self.ai_state_next = ST_PTR;
        return;
      }
    }
    else{
      self.ai_state_next = ST_THR;
      return;
    }
  }
  
  if( self.torsoCenter.angles_y == self.torsoCenter.ideal_yaw ){
    self.torsoCenter.attack_state = TR_NORM;
  }
  if( random() > 0.9 && self.torsoCenter.attack_state != TR_YAW){
    self.torsoCenter.ai_dir = (crandom() * self.ai_angleLimits_x);
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir + self.ai_angleLimits_y;
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir * crandom();
    self.torsoCenter.ai_dir = anglemod( self.angles_y + self.torsoCenter.ai_dir);
    self.torsoCenter.attack_state = TR_YAW;
    return;
  }
};