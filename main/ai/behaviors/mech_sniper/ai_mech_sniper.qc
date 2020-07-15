/*
battleMETAL 
Author: Peter Roohr
Date: 10/24/2018
rebuild: 2/16/2019
Overview: ai unit
  Mech - Sniper
  an on-ground, turreted, walking unit
  sniperrs try to work the mid and long range
  close-up they're kinda useless, only should attack at longer ranges
*/

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_sniper={
  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  self.th_pain = ai_mech_sniper_react;
  self.th_die = ai_mech_sniper_die;
  self.touch = ai_touch;
  
  self.SendEntity = ctrl_send_mech_ai;
  
  //new state stuff
  self.ai_state_last = 0;
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND; //debug
  self.ai_dance_card = (MOVE_CHARGE | MOVE_CHARGE_LEFT | MOVE_CHARGE_RIGHT | MOVE_STRAFE_LEFT | MOVE_STRAFE_RIGHT | MOVE_BACK | MOVE_CIRCLE_LEFT | MOVE_CIRCLE_RIGHT | MOVE_STAND_FACE);
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ai_ctrl_update_mechplayer;
  
  //ai state interface--------------------------------------------------------
  self.ai_state_stand = ai_mech_sniper_stand;
  self.ai_state_patrol = ai_mech_sniper_patrol;
  self.ai_state_patrol_pause = ai_mech_sniper_ptr_pause;
  self.ai_state_patrol_travel_node = ai_mech_sniper_ptr_travel_node;
  self.ai_state_patrol_travel_blocked = ai_mech_sniper_ptr_travel_blocked;
  self.ai_state_patrol_tether = ai_mech_sniper_ptr_tether;
  self.ai_state_patrol_tether_blocked = ai_mech_sniper_ptr_tether_blocked;
    
  self.ai_state_tether = mech_sniper_tether;
  self.ai_state_tether_pause = mech_sniper_thr_pause;
  self.ai_state_tether_travel = mech_sniper_thr_travel;
  self.ai_state_tether_travel_block = mech_sniper_thr_travel_block;
  
  self.ai_state_combat = mech_sniper_combat;
  self.ai_state_combat_moveStart = mech_sniper_com_moveStart;
  self.ai_state_combat_moveExec = mech_sniper_com_moveExec;
  self.ai_state_combat_moveEnd = mech_sniper_com_moveEnd;
  self.ai_state_combat_blocked = mech_sniper_com_blocked;
  
  self.ai_state_trail_move = mech_sniper_trail_move;
  self.ai_state_trail_move_block = mech_sniper_trail_move_block;
  self.ai_state_trail_rollback = mech_sniper_trail_rollback;
  self.ai_state_trail_rollback_block = mech_sniper_trail_rollback_block;
  //--------------------------------------------------------------------------
  self.think = ai_setup_patrol;
  self.nextthink = time + 2;
};

/*
  STATE : STAND
*/
void() ai_mech_sniper_stand={
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

void( entity attacker ) ai_mech_sniper_react={
  local float enemyvis;
  
  if( !(attacker.flags & FL_MONSTER) && !(attacker.flags & FL_CLIENT)){
    return;
  }
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
  
  if( !attacker ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    return;
  }
  
  if( attacker == self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    return;
  }

  //AI currently has target
  if( self.enemy ){
    return;
  }
  
  if( ai_check_vis(self.enemy) == VIS_FRAC ){
    if( ai_check_node_radius(self.enemy) > 1.0 ){
      return;
    }
  }
  if( ai_check_vis(self.enemy) == VIS_FRN ){
    if( ai_check_node_radius(self.enemy) <= 1.0 ){
      return;
    }
  }
  self.enemy = attacker;
  self.ai_react_buffer = time + self.ai_react_time * 5;
  self.ai_state_next = ST_COMBAT;
};