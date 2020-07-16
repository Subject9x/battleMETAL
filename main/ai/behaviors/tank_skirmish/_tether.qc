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
void() tank_tether={
  if(self.ai_state==ST_THR && self.ai_state_last != ST_THR){
    //check if out of node bounds
    if( ai_check_node_radius(self) > 1.0 ){
      self.ai_state_next = ST_THR_TRAVEL;
      return;
    }
    return;
  }
};

/*
  ST_THR_PAUSE:
*/
void() tank_thr_pause={
  if(self.ai_state==ST_THR_PAUSE && self.ai_state_last != ST_THR_PAUSE){
  
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
};

/*
  ST_THR_TRAVEL:
*/
void() tank_thr_travel={
  local float lastPatrol;
  if(self.ai_state==ST_THR_TRAVEL && self.ai_state_last != ST_THR_TRAVEL){
    self.goalentity = self.patrolNode;
    self.tetherOrg = self.goalentity.origin;
    self.tetherStatus = TETHER_NODE;
    self.patrolState = 0;
    self.ai_movewait = time + 30;
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( time > self.ai_movewait ){
    if( ai_check_node_radius(self) <= 0.75 ){
      self.ai_state_next = ST_THR_PAUSE;
      return;
    }
    self.ai_state_next = ST_THR_TRAVEL;
    self.ai_movewait = time + 30;
    return;
  }
  lastPatrol = self.patrolState;
  ai_patrol_state_frame();
  if( self.patrolState == PATROL_ARRIVE && lastPatrol != PATROL_ARRIVE ){
    self.ai_state_next = ST_THR_PAUSE;
  }
};


/*
  ST_THR_TRAVEL_BLOCK:
*/
void() tank_thr_travel_block={
  if(self.ai_state==ST_THR_TRAVEL_BLOCK && self.ai_state_last != ST_THR_TRAVEL_BLOCK){
  
    return;
  }
};