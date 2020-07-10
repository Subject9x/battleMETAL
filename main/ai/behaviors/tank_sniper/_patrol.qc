/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 

  tank snipers are basically missile / tank hunter vehicles.
*/


void() ai_spg_patrol={
  ai_update_accuracy( TRUE );
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
    cons_logAString("new state", "ai_spg_patrol"); //debug
    self.ai_state_next = ST_PTR_TRAVEL_NODE;
    self.goalentity = self.movetarget;
    cons_logAFloat("ENTER[ST_PTR_TRAVEL_NODE]",  self.ai_state_next); //debug
    return;
  }
};
void() ai_spg_ptr_pause={
  ai_update_accuracy( FALSE );
  
  //entered pause state
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
    cons_logAString("new state", "ai_spg_ptr_pause"); //debug
    return;
  }
  //--------------------------
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
  
  if( time > self.pausetime ){
    if( self.movetarget != world ){
      self.ai_state_next = ST_PTR;
      cons_logAFloat("ENTER[ST_PTR]",  self.ai_state_next); //debug
    }
    else{
      self.ai_state_next = ST_STAND;
      cons_logAFloat("ENTER[ST_STAND]",  self.ai_state_next); //debug
    }
  }

};
void() ai_spg_ptr_travel_node={
  ai_update_accuracy( TRUE );

  cons_logAString("running--------", "ai_spg_ptr_travel_node"); //debug
  self.patrolState = ai_patrol_frame(ai_mech_sk_patrol1, ai_mech_sk_enter_stand);
  cons_logAFloat("running--------patrolState", self.patrolState); //debug
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
  
  if( self.patrolState == PATROL_PAUSE ){
    self.ai_state_next = ST_PTR_PAUSE;
    cons_logAFloat("ENTER[ST_PTR_PAUSE]",  self.ai_state_next); //debug
    return;
  }
  
  if( self.patrolState == PATROL_BLOCK ){
    self.ai_state_next = ST_PTR_TRAVEL_NODEBLOCK;
    cons_logAFloat("ENTER[ST_PTR_TRAVEL_NODEBLOCK]",  self.ai_state_next); //debug
    return;
  }
};
void() ai_spg_ptr_travel_blocked={
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
  //if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
    self.ai_movewait = time + (self.ai_rank * 2);
    cons_logAString("new state", "ai_spg_ptr_travel_blocked"); //debug
    return;
  //}
  if( time > self.ai_movewait ){
    self.tetherOrg = self.movetarget.origin;
    self.ai_state_next = ST_PTR;
    return;
  }
};
void() ai_spg_ptr_tether={
  //if( self.ai_state == ST_PTR_TETHER && self.ai_state_last != ST_PTR_TETHER ){
    cons_logAString("new state", "ai_spg_ptr_tether"); //debug
  //  return;
  //}

};
void() ai_spg_ptr_tether_blocked={
  //if( self.ai_state == ST_PTR_TETHER_BLOCK && self.ai_state_last != ST_PTR_TETHER_BLOCK ){
    cons_logAString("new state", "ai_spg_ptr_tether_blocked"); //debug
    return;
  //}
};