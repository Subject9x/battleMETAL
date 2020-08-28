/*
battleMETAL 
Author: Peter Roohr
Date: 07/16/2020
Overview: 
  _tether.qc defines behavior for AI that have been set to TETHER_NODE.
  
  they must have a valid "ai_node_tether" near them when they spawn 
    to actually work.
  
  this is the generic implementation pretty much used across all behavior
  sets.
*/

/*
  ST_TETHER:
*/
void() ai_tether={
  //State entry block------------------------------------------------
  if(self.ai_state==ST_THR && self.ai_state_last != ST_THR){
    self.goalentity = self.patrolNode;
    self.tetherOrg = self.goalentity.origin;
    self.tetherStatus = TETHER_NODE;
    //check if out of node bounds
    if( ai_check_node_radius(self) > 1.0 ){
      self.ai_state_next = ST_THR_TRAVEL;
      return;
    }
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
      //prepare for war....
      self.ai_state_next = ST_COMBAT;
      return;
    }
    self.ai_state_next = ST_STAND;
    return;
  }
  //-------------------------------------------------------------
};

/*
  ST_THR_PAUSE:
*/
void() ai_thr_pause={
  //State entry block------------------------------------------------
  if(self.ai_state==ST_THR_PAUSE && self.ai_state_last != ST_THR_PAUSE){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_YAW;
      self.torsoCenter.ai_dir = self.angles_y;
    }
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
      //prepare for war....
      self.ai_state_next = ST_COMBAT;
      self.moveState = MOVE_NORM;
      return;
    }
    self.ai_movewait = time + 30;
    self.moveState = 0;
    return;
  }
  //-------------------------------------------------------------
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( time > self.ai_movewait ){
    if( ai_check_node_radius(self) > 1.0 ){
      self.ai_state_next = ST_THR_TRAVEL;
      return;
    }
    self.ai_state_next = ST_STAND;
  }
};

/*
  ST_THR_TRAVEL:
*/
void() ai_thr_travel={
  local float lastPatrol;
  //State entry block------------------------------------------------
  if(self.ai_state==ST_THR_TRAVEL && self.ai_state_last != ST_THR_TRAVEL){
    self.goalentity = self.patrolNode;
    self.tetherOrg = self.goalentity.origin;
    self.tetherStatus = TETHER_NODE;
    self.patrolState = 0;
    self.ai_movewait = time + 30;
    if(self.legs){
      self.legs.attack_state = TR_GOAL;
    }
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.moveState = MOVE_NORM;
    return;
  }
  //-------------------------------------------------------------
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
void() ai_thr_travel_block={
  //State entry block------------------------------------------------
  if(self.ai_state==ST_THR_TRAVEL_BLOCK && self.ai_state_last != ST_THR_TRAVEL_BLOCK){
    
    return;
  }
  //-------------------------------------------------------------
};