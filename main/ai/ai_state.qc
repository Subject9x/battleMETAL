/*
battleMETAL
Author: Peter Roohr
Date: 07/02/2020
Overview: 
  state machine for all AI
  
  my goals for this current AI death ride
    + make sure bots can maintain their set paths (think being ordered to do something)
    + dont get stuck while fighting the player
*/

/*
  The top-level State Controller for all AI brains.
*/
void() ai_state_frame={
  //run unit frame updates
  macro_ai_update(self.ai_unit_update)
  
  //State update
  self.ai_state_last = self.ai_state;
  self.ai_state = self.ai_state_next;
  
  //Move tracker update
  self.ai_move_last = self.ai_move;
  self.ai_move = self.ai_move_next;
  
  //state machine
  switch( self.ai_state ){
    case ST_STAND:
      self.ai_state_stand();
      break;
    case ST_PTR:
      self.ai_state_patrol();
      break;
    case ST_PTR_PAUSE:
      self.ai_state_patrol_pause();
      break;
    case ST_PTR_TRAVEL_NODE:
      self.ai_state_patrol_travel_node();
      break;
    case ST_PTR_TRAVEL_NODEBLOCK:
      self.ai_state_patrol_travel_blocked();
      break;
    case ST_PTR_TETHER:
      self.ai_state_patrol_tether();
      break;
    case ST_PTR_TETHER_BLOCK:
      self.ai_state_patrol_tether_blocked();
      break;
    case ST_COMBAT:
      self.ai_state_combat();
      break;
    case ST_COM_FIGHT:
      self.ai_state_combat_fight();
      break;
    case ST_COM_FIGHT_MOVE:
      self.ai_state_combat_maneuver();
      break;
    case ST_COM_FIGHT_MOVEBLOCK:
      self.ai_state_combat_maneuver_block();
      break;
  }
  
  if( (self.flags&FL_TURRET) ){
    ai_turret_control();
  }
  if( self.legs ){
    ai_leg_control();
  }
  
  self.think = ai_state_frame;
  self.nextthink = time + 0.05;
};