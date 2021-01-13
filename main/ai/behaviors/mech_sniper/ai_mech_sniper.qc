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
  
  self.th_pain = ai_react_generic;
  self.th_die = ai_mech_sniper_die;
  self.touch = ai_touch;
  
  self.SendEntity = ctrl_send_mech_ai;
  local entity wep;
  for(wep = self.w_slot; wep != world; wep = wep.w_slot){
    wep.effects = wep.effects | EF_NODRAW;
  }  
  self.torsoCenter.effects = self.torsoCenter.effects | EF_NODRAW;
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = self.dphitcontentsmask | (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ai_ctrl_update_mechplayer;
  
  self.ai_timer_tracepath = 1 + random() * 5; //seed the nodegraph timer check
  self.ai_findPath = TRUE;
  
  self.ai_set_state = ai_state_hunter_frame;
  self.think = ai_setup_patrol;
  self.nextthink = time + 2;
};