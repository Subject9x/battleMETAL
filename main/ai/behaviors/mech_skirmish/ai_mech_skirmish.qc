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
  
  self.SendEntity = ctrl_send_mech_ai;
  
  self.ai_unit_update = ctrl_mech_update;
  
  self.th_pain = ai_react_generic;
  self.th_die = ai_mech_sk_die;
  self.touch = ai_touch;
  
  self.ai_timer_tracepath = 1 + random() * 5; //seed the nodegraph timer check
  self.ai_findPath = TRUE;
  
  self.ai_set_state = ai_state_hunter_frame;
  self.think = ai_setup_patrol;
  self.nextthink = time + 2;
};