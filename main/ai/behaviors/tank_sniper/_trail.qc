/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 

  tank snipers are basically missile / tank hunter vehicles.
*/

/*
  STATE: ST_TRAIL_MOVE
*/
void() spg_trail_move={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_MOVE && self.ai_state_last != ST_TRAIL_MOVE ){
    cons_logAString("new state", "spg_trail_move"); //debug
    if( ai_trail_back() ){
      self.tetherOrg = self.trailDest;
      self.tetherStatus = TETHER_NODE;
      return;
    }
    self.tetherOrg = ai_trail_available();
    if( self.tetherOrg == self.origin ){
      //failed to find trail dest, ok, scrap and try nodes?
      self.movetarget = ai_node_to_target(self);
      self.tetherOrg = self.movetarget.origin;
    }
    return;
  }
 //------------------------------------------------------------------
  ai_attack();
  if( vlen(self.tetherOrg - self.origin) > AI_NODE_DISTANCE / 2 ){
    //cons_logAFloat("distLeft > AI_NODE_DISTANCE", distLeft);  //debug
    ai_face_origin(self.tetherOrg);
    
    if( ai_check_face_origin(self.tetherOrg, 0.85, FALSE) ){
      if( !walkmove(self.angles_y, self.data_speed_forward * AI_RUN_SPD) ){
        self.ai_state_next = ST_TRAIL_BLOCK;
      }
      return; 
    }
    else{
      if( !walkmove(self.angles_y, (self.data_speed_forward / 4)* AI_RUN_SPD) ){
        self.ai_state_next = ST_TRAIL_BLOCK;
      }
      return;
    }
    if( self.trailDest == self.trail1 ){
      //reached end of trail
      ai_trail_clear();
    }
    return;
  }
  self.trailTotal = self.trailTotal - 1;
  self.ai_state_next = ST_COMBAT;
};

/*
  STATE: ST_TRAIL_BLOCK
*/
void() spg_trail_move_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_BLOCK && self.ai_state_last != ST_TRAIL_BLOCK ){
    cons_logAString("new state", "spg_trail_move_block"); //debug    
    if( ai_trail_back() ){
      cons_logAString("spg_trail_move_block", "trail found"); //debug    
      cons_logAVector("spg_trail_move_block", self.trailDest); //debug    
      self.tetherOrg = self.trailDest;
      self.tetherStatus = TETHER_NODE;
      return;
    }
    if( self.tetherOrg == self.origin ){
      cons_logAString("spg_trail_move_block", "------no trail found"); //debug    
      //failed to find trail dest, ok, scrap and try nodes?
      self.movetarget = ai_node_to_target(self);
      self.tetherOrg = self.movetarget.origin;
    }
    self.ai_state_next = ST_TRAIL_MOVE;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBACK
*/
void() spg_trail_rollback={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBACK && self.ai_state_last != ST_TRAIL_ROLLBACK ){
    cons_logAString("new state", "spg_trail_rollback"); //debug
    if( self.tetherOrg == self.trail1 ){
      ai_trail_clear();
      self.ai_state_next = ST_COMBAT;
      return;
    }
    ai_trail_back();
    self.tetherOrg = self.trailDest;
    self.ai_state_next = ST_TRAIL_MOVE;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBLOCK
*/
void() spg_trail_rollback_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBLOCK && self.ai_state_last != ST_TRAIL_ROLLBLOCK ){
    cons_logAString("new state", "spg_trail_rollback_block"); //debug
    return;
  }
 //------------------------------------------------------------------
};