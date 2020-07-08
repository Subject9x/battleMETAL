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
    cons_logAString("new state", "mech_sk_trail_move"); //debug
    
    self.legs.attack_state = TR_NORM;
    self.legs.think = bot_leg_walk1;
    self.legs.nextthink = time + 0.1;
    
    if( ai_trail_back() ){
      cons_logAString("mech_sk_trail_move", "ai_trail_back()"); //debug
      cons_logAFloat("self.trailTotal", self.trailTotal); //debug
      self.tetherOrg = self.trailDest;
      cons_logAVector("self.trailDest", self.trailDest); //debug
      cons_logAVector("self.tetherOrg", self.tetherOrg); //debug
      return;
    }
    self.tetherOrg = ai_trail_available();
    if( self.tetherOrg == self.origin ){
      cons_logAString("mech_sk_trail_move", " self.tetherOrg == self.origin"); //debug
      //failed to find trail dest, ok, scrap and try nodes?
      self.movetarget = ai_node_to_target(self);
      self.tetherOrg = self.movetarget.origin;
      return;
    }
    self.ai_state_next = ST_STAND;
    self.pausetime = 5;
    return;
  }
 //------------------------------------------------------------------

  ai_attack();
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
  self.ai_state_next = ST_COMBAT;
};

/*
  STATE: ST_TRAIL_BLOCK
*/
void() mech_sk_trail_move_block={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_BLOCK && self.ai_state_last != ST_TRAIL_BLOCK ){
    cons_logAString("new state", "mech_sk_trail_move_block"); //debug    
    if( ai_trail_back() ){
      cons_logAString("mech_sk_trail_move_block", "trail found"); //debug    
      cons_logAVector("mech_sk_trail_move_block", self.trailDest); //debug    
      self.tetherOrg = self.trailDest;
      self.tetherStatus = TETHER_NODE;
      self.ai_state_next = ST_TRAIL_MOVE;
      return;
    }
    if( self.tetherOrg == self.origin ){
      cons_logAString("mech_sk_trail_move_block", "------no trail found"); //debug    
      //failed to find trail dest, ok, scrap and try nodes?
      self.movetarget = ai_node_to_target(self);
      self.tetherOrg = self.movetarget.origin;
      self.ai_state_next = ST_TRAIL_MOVE;
    }
    if( self.tetherOrg == '0 0 0'){
      
    }
    self.ai_state_next = ST_TRAIL_ROLLBLOCK;
    
    cons_logAVector("self.origin", self.origin);//debug
    cons_logAVector("self.tetherOrg", self.tetherOrg);//debug
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
    cons_logAString("new state", "mech_sk_trail_rollback"); //debug
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
void() mech_sk_trail_rollback_block={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBLOCK && self.ai_state_last != ST_TRAIL_ROLLBLOCK ){
    cons_logAString("new state", "mech_sk_trail_rollback_block"); //debug
    ai_trail_forward();
    if( self.trailDest != '0 0 0' || self.trailDest != self.origin ){
      self.tetherOrg = self.trailDest;
      self.ai_state_next = ST_TRAIL_MOVE;
    }
    if( self.target ){
      self.movetarget = ai_node_to_target(self);
      self.ai_state_next = ST_COMBAT;
      self.ai_move_next = MOVE_PATROLNODE;
    }
    return;
  }
 //------------------------------------------------------------------
};
