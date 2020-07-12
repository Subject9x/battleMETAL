/*
battleMETAL 
Author: Peter Roohr
Date: 7/12/2018
rebuild: 2/16/2019
Overview: ai unit
  Tank Destroyer
  an on-ground, turret-less vehicle
*/
/*
  AI SPAWN FUNCTION
*/
void() ai_vec_dest={
  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  self.spawnflags = self.spawnflags | HAS_RADAR;
  ai_pilot_ini_stats(self.ai_rank);
  if( self.vec_size < 3 ){
     self.spawnflags = self.spawnflags | MUTE_ME;
  }
  ai_voice_ini( TRUE );

  self.th_react = ai_spg_react1;
  self.th_die = ai_vec_dest_die;
  self.touch = ai_touch;

  ai_setup_patrol();
  
  self.SendEntity = ctrl_send_spg;
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;   
  local entity wep;
  for(wep = self.w_slot; wep != world; wep = wep.w_slot){
    wep.effects = EF_NODRAW;
  } 
  
  //new state stuff
  self.ai_state_last = 0;
  self.ai_state_next = ST_STAND; //debug
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND; //debug
  self.ai_dance_card = ( MOVE_BACK | MOVE_STAND_FACE | MOVE_SNIPESHOT );
  if(self.ai_rank == AI_RANK_REG || self.ai_rank == AI_RANK_VET ){
    self.ai_dance_card = self.ai_dance_card | (MOVE_CHARGE_LEFT | MOVE_CHARGE_RIGHT); //oh ho ho 
  }
  if(self.ai_rank == AI_RANK_ACE){
    self.ai_dance_card = self.ai_dance_card | (MOVE_BACK_LEFT | MOVE_BACK_RIGHT);
  }
  self.ai_moveflag = self.ai_dance_card;
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ctrl_updateTank;
  self.ai_state_stand = ai_spg_stand;
  
  //ai state interface--------------------------------------------------------
  self.ai_state_patrol = ai_spg_patrol;
  self.ai_state_patrol_pause = ai_spg_ptr_pause;
  self.ai_state_patrol_travel_node = ai_spg_ptr_travel_node;
  self.ai_state_patrol_travel_blocked = ai_spg_ptr_travel_blocked;
  self.ai_state_patrol_tether = ai_spg_ptr_tether;
  self.ai_state_patrol_tether_blocked = ai_spg_ptr_tether_blocked;
  
  self.ai_state_combat = spg_combat;
  self.ai_state_combat_moveStart = spg_com_moveStart;
  self.ai_state_combat_moveExec = spg_com_moveExec;
  self.ai_state_combat_moveEnd = spg_com_moveEnd;
  self.ai_state_combat_blocked = spg_com_blocked;
  
  self.ai_state_trail_move = spg_trail_move;
  self.ai_state_trail_move_block = spg_trail_move_block;
  self.ai_state_trail_rollback = spg_trail_rollback;
  self.ai_state_trail_rollback_block = spg_trail_rollback_block;
  self.think = ai_state_frame;
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
  //--------------------------------------------------------------------------
};

/*
  STATE: STAND
*/
void() ai_spg_stand={
  ai_update_accuracy( FALSE );
  
  //Enter state
  if(self.ai_state == ST_STAND &&  self.ai_state_last != ST_STAND ){
    cons_logAString("new state", "tank_sniper_stand"); //debug
    //entering stand state
    if(self.torsoCenter){
      self.torsoCenter.attack_state = TR_NORM;
    }
    self.goalentity = world;
    return;
  }
  //-----------------
  cons_logAString("running--------", "tank_sniper_stand"); //debug
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
