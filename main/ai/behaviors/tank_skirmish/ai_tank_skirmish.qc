/*
battleMETAL 
Author: Peter Roohr
Date: 9/21/2018
rebuild: 2/16/2019
Overview: ai unit
  Tank - Skirmisher
  kinda like a mech skirmisher but slower,
  a default tank
*/

/*
  AI SPAWN FUNCTION
*/
void() ai_tank_skirmish={
  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  if( self.vec_size < 3 ){
    self.spawnflags = self.spawnflags | MUTE_ME;
  }
  
  self.th_pain = ai_react_generic;
  self.th_die = ai_tank_sk_die;
  self.touch = ai_touch;
  
  self.SendEntity = ctrl_send_tank;
  
  local entity wep;
  for(wep = self.w_slot; wep != world; wep = wep.w_slot){
    wep.effects = EF_NODRAW;
  }  
  self.torsoCenter.effects = EF_NODRAW;
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ctrl_updateTank;
  
  self.ai_timer_tracepath = 1 + random() * 5; //seed the nodegraph timer check
  self.ai_findPath = TRUE;
  
  self.ai_set_state = ai_state_brawler_frame;
  self.think = ai_setup_patrol;
  self.nextthink = time + 2;
};