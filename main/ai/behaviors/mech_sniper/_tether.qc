/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 
  _tether.qc defines behavior for AI that have been set to TETHER_NODE.
  
  they must have a valid "ai_node_tether" near them when they spawn 
    to actually work.
*/

/*
  ST_TETHER:
*/
void() mech_sniper_tether={
  if(self.ai_state==ST_THR && self.ai_state_last != ST_THR){
  
    return;
  }
};

/*
  ST_THR_PAUSE:
*/
void() mech_sniper_thr_pause={
  if(self.ai_state==ST_THR_PAUSE && self.ai_state_last != ST_THR_PAUSE){
  
    return;
  }
};

/*
  ST_THR_TRAVEL:
*/
void() mech_sniper_thr_travel={
  if(self.ai_state==ST_THR_TRAVEL && self.ai_state_last != ST_THR_TRAVEL){
  
    return;
  }
};


/*
  ST_THR_TRAVEL_BLOCK:
*/
void() mech_sniper_thr_travel_block={
  if(self.ai_state==ST_THR_TRAVEL_BLOCK && self.ai_state_last != ST_THR_TRAVEL_BLOCK){
  
    return;
  }
};