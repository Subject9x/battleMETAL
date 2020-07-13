/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _trail states are for pathfinding in the middle of a fight.
*/


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
void() mech_sk_trail_move={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_MOVE && self.ai_state_last != ST_TRAIL_MOVE ){
    self.ai_state_next = ST_STAND;
    self.pausetime = 5;
    return;
  }
 //------------------------------------------------------------------

  /*ai_attack();
  ai_face_origin(self.tetherOrg);
  //AI walking to self.trailDest value
  if( vlen(self.tetherOrg - self.origin) > AI_NODE_DISTANCE / 3 ){
    //cons_logAFloat("distLeft > AI_NODE_DISTANCE", distLeft);  //debug
    cons_logAFloat("walking to trail", self.trailTotal);  //debug

    
    trailparticles(self, particleeffectnum("TE_LAS_RAIL"), self.origin, self.tetherOrg);  //debug
    
    local float lean;
    lean = vectoyaw(self.tetherOrg - self.origin);
    if( ai_check_face_origin(self.tetherOrg, 0.85, FALSE) ){
      
      if( !walkmove(self.angles_y, self.data_speed_forward ) ){
        self.ai_state_next = ST_TRAIL_BLOCK;
        return;
      }
    }
    else{
      if( !walkmove(self.angles_y, (self.data_speed_forward / 3)) ){
        self.ai_state_next = ST_TRAIL_BLOCK;
        return;
      }
    }
    return;
  }
  //AI has arrived at trailDest
  
  if( self.trailDest == self.trail1 ){
    //reached end of trail
    ai_trail_clear();
    self.ai_moveflag = self.ai_dance_card;
    if( ai_valid_target(self.enemy) ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    else{
      self.ai_state_next = ST_STAND;
      self.pausetime = 2;
      return;
    }
  }
  else{
    if( ai_trail_back() ){
      self.ai_state_next = ST_TRAIL_MOVE;
      return;
    }
  }
  self.ai_state_next = ST_COMBAT;*/
};

/*
  STATE: ST_TRAIL_BLOCK
*/
void() mech_sk_trail_move_block={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_BLOCK && self.ai_state_last != ST_TRAIL_BLOCK ){

    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBACK
*/
void() mech_sk_trail_rollback={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBACK && self.ai_state_last != ST_TRAIL_ROLLBACK ){
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBLOCK
*/
void() mech_sk_trail_rollback_block={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBLOCK && self.ai_state_last != ST_TRAIL_ROLLBLOCK ){

    return;
  }
 //------------------------------------------------------------------
};
