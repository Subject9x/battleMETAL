/*
battleMETAL 
Author: Peter Roohr
Date: 07/20/2020
Overview: 
  turrets are static buildings with rotating turrets,
    they're tanks treated like buildings.
    
  _patrol has them rotate every once-and-a-while to do some scanning-like effect.
  
*/

void() turret_patrol={
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
  
    return;
  }
};

void() turret_patrol_pause={
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
  
    return;
  }
};

void() turret_patrol_travel={
  if( self.ai_state == ST_PTR_TRAVEL_NODE && self.ai_state_last != ST_PTR_TRAVEL_NODE ){
  
    return;
  }
};

void() turret_patrol_travel_block={
  if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
  
    return;
  }
};
