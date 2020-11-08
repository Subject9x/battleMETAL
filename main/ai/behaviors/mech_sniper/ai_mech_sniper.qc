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
  
  self.th_pain = ai_react_generic;
  self.th_die = ai_mech_sniper_die;
  self.touch = ai_touch;
  
  self.SendEntity = ctrl_send_mech_ai;
  local entity wep;
  for(wep = self.w_slot; wep != world; wep = wep.w_slot){
    wep.effects = wep.effects | EF_NODRAW;
  }  
  self.torsoCenter.effects = self.torsoCenter.effects | EF_NODRAW;
  
  //new state stuff
  self.ai_state_last = 0;
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND;
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ai_ctrl_update_mechplayer;
  
  //ai state interface--------------------------------------------------------
  self.ai_state_stand = ai_stand_generic;
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
  
  self.ai_fight_take_fire = mech_sniper_fight_target_fire;
  self.ai_fight_out_radius = mech_sniper_fight_out_radius;
  self.ai_fight_vis_friend = mech_sniper_fight_vis_friend;
  self.ai_fight_building = mech_sniper_fight_building;
  self.ai_fight_target = mech_sniper_fight_full;
  
  //--------------------------------------------------------------------------
  self.ai_set_state = ai_state_frame_2;
  self.think = ai_setup_patrol;
  self.nextthink = time + 2;
};