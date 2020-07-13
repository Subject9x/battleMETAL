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
    cons_logAFloat("ENTER[ST_PTR]",  self.ai_state_next); //debug
    
    self.ai_state_next = ST_PTR_TRAVEL_NODE;
    self.goalentity = self.patrolNode;
    self.tetherStatus = TETHER_NODE;
    
    return;
  }
};

void() ai_spg_ptr_pause={
  ai_update_accuracy( FALSE );
  
  //entered pause state
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
     cons_logAFloat("ENTER[ST_PTR_PAUSE]",  self.ai_state_next); //debug
    self.pausetime = time + self.pausetime;
    return;
  }
  //--------------------------
  if( time > self.pausetime ){
    if( self.patrolNode != world ){
      self.ai_state_next = ST_PTR;
    }
    else{
      self.ai_state_next = ST_STAND;
    }
  }
};
void() ai_spg_ptr_travel_node={
  ai_update_accuracy( TRUE );

  ai_patrol_state_frame();
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.patrolState == PATROL_PAUSE ){
    self.ai_state_next = ST_PTR_PAUSE;
    return;
  }
  
  if(self.patrolState == PATROL_BLOCK ){
    self.ai_state_next = ST_PTR_TRAVEL_NODEBLOCK;
    return;
  }
};
void() ai_spg_ptr_travel_blocked={
  if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
    cons_logAFloat("ENTER[ST_PTR_TRAVEL_NODEBLOCK]",  self.ai_state_next); //debug
    if( ai_blocked_teleport() ){
      self.tetherOrg = self.patrolNode.origin;
      self.ai_state_next = ST_PTR;
      return;
    }
    self.ai_movewait = time + 30;
    return;
  }
  if( ai_blocked_teleport() ){
    self.tetherOrg = self.patrolNode.origin;
    self.ai_state_next = ST_PTR;
    return;
  }
};
void() ai_spg_ptr_tether={
  //if( self.ai_state == ST_PTR_TETHER && self.ai_state_last != ST_PTR_TETHER ){
     cons_logAFloat("ENTER[ST_PTR_TETHER]",  self.ai_state_next); //debug
    return;
  //}
};

void() ai_spg_ptr_tether_blocked={
  //if( self.ai_state == ST_PTR_TETHER_BLOCK && self.ai_state_last != ST_PTR_TETHER_BLOCK ){
     cons_logAFloat("ENTER[ST_PTR_TETHER_BLOCK]",  self.ai_state_next); //debug
    return;
 // }
};