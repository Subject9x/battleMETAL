/*
battleMETAL 
Author: Peter Roohr
Date: 07/20/2020
Overview: 
  turrets are static buildings with rotating turrets,
    they're tanks treated like buildings.
    
  _patrol has them rotate every once-and-a-while to do some scanning-like effect.
  
*/

/*
  STATE::ST_PTR
*/
void() turret_patrol={
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
    self.ai_state_next = ST_PTR_PAUSE;
    self.ai_movewait = 5;
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
      self.ai_state_next = ST_COMBAT;
    }
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE  ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
};

/*
  STATE::ST_PTR_PAUSE
*/
void() turret_patrol_pause={
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE  ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    self.ai_movewait = time + self.ai_movewait;
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE  ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( time > self.ai_movewait ){
    self.ai_state_next = ST_PTR_TRAVEL_NODE;
  }
};

/*
  STATE::ST_PTR_TRAVEL_NODE
*/
void() turret_patrol_travel={
  if( self.ai_state == ST_PTR_TRAVEL_NODE && self.ai_state_last != ST_PTR_TRAVEL_NODE ){
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE  ){
      self.ai_state_next = ST_COMBAT;
    }
    else{
      self.torsoCenter.ai_dir = self.torsoCenter.angles_y + (crandom() * (25 + random() * 75));
      self.torsoCenter.attack_state = TR_YAW;
    }
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE  ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if(self.torsoCenter.angles_y == self.torsoCenter.ideal_yaw){
    self.ai_state_next = ST_PTR_PAUSE;
    self.ai_movewait = random() * (self.ai_rank * 3);
    return;
  }
};

/*
  STATE::ST_PTR_TRAVEL_NODEBLOCK
  --modified here to be more a fade-out state from combat
*/
void() turret_patrol_travel_block={
  if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
    return;
  }
};
