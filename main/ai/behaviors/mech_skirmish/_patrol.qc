/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
rebuild: 07/01/2020
Overview: ai unit
  Mech - Skirmisher
  Behavior - Patrol
    AI must be given a valid .target that links to an ai_node entity
*/

/*
  STATE : PATROL START
*/
void() ai_mech_sk_patrol={
  ai_update_accuracy( TRUE );
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
    
    self.ai_state_next = ST_PTR_TRAVEL_NODE;
    self.goalentity = self.patrolNode;
    self.tetherStatus = TETHER_NODE;
    
    self.legs.attack_state = TR_GOAL;
    self.legs.think = bot_leg_walk1;
    self.legs.nextthink = time + 0.1;
    
    self.torsoCenter.attack_state = TR_GOAL;
    
    return;
  }
};
/*
  STATE : PATROL PAUSE
*/
void() ai_mech_sk_ptr_pause={
  ai_update_accuracy( FALSE );
  
  //entered pause state
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
    self.legs.attack_state = TR_YAW;
    self.legs.angles_y = self.angles_y;
    self.legs.think = bot_leg_stand1;
    self.legs.nextthink = time + 0.1;
    self.pausetime = time + self.pausetime;
    return;
  }
  //--------------------------
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( time > self.pausetime ){
    if( self.patrolNode != world ){
      self.ai_state_next = ST_PTR;
    }
    else{
      self.ai_state_next = ST_STAND;
    }
  }
};
/*
  STATE : PATROL TRAVEL TO NODE
*/
void() ai_mech_sk_ptr_travel_node={
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
/*
  STATE : PATROL TRAVEL TO NODE BLOCKED
*/
void() ai_mech_sk_ptr_travel_blocked={
  if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
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

/*
  STATE : PATROL USE TETHER
*/
void() ai_mech_sk_ptr_tether={
  //if( self.ai_state == ST_PTR_TETHER && self.ai_state_last != ST_PTR_TETHER ){
  //}
};

/*
  STATE : PATROL USE TETHER BLOCKED
*/
void() ai_mech_sk_ptr_tether_blocked={
  //if( self.ai_state == ST_PTR_TETHER_BLOCK && self.ai_state_last != ST_PTR_TETHER_BLOCK ){
 // }
};