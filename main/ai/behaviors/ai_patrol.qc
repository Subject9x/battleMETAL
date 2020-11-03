/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish tanks are the basic behavior of tanks in the game,
  _patrol.qc contains the state function bodies for the state machine.
  
*/


/*
  STATE: STAND - GENERIC
*/
void() ai_stand_generic={
  ai_update_accuracy( FALSE );
  //Enter state
  if(self.ai_state == ST_STAND &&  self.ai_state_last != ST_STAND ){
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_NORM;
    }
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
    }
    self.goalentity = world;
    self.moveState = 0;
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    return;
  }
  //-----------------
  if( ai_valid_target(self.enemy) ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.patrolNode != world ){
    if( self.patrolNode.classname == "ai_node" && self.tether == TETHER_PATROL ){
      if( time > self.pausetime ){
        self.ai_state_next = ST_PTR;
        return;
      }
    }
    else{
      self.ai_state_next = ST_THR;
      return;
    }
  }
  
  if( self.torsoCenter ){
    if( self.torsoCenter.angles_y == self.torsoCenter.ideal_yaw ){
      self.torsoCenter.attack_state = TR_NORM;
    }
    if( random() > 0.9 && self.torsoCenter.attack_state != TR_YAW){
      self.torsoCenter.ai_dir = (crandom() * self.ai_angleLimits_x);
      self.torsoCenter.ai_dir = self.torsoCenter.ai_dir + self.ai_angleLimits_y;
      self.torsoCenter.ai_dir = self.torsoCenter.ai_dir * crandom();
      self.torsoCenter.ai_dir = anglemod( self.angles_y + self.torsoCenter.ai_dir);
      self.torsoCenter.attack_state = TR_YAW;
      return;
    }
  }
};

/*
  STATE : PATROL START
*/
void() ai_patrol={
  local float pNodeId;
  local float pathFind;
  
  ai_update_accuracy( TRUE );
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
    //nodegraph
    if( NODEGRAPH_LOADED ){
      if( !ai_check_terrain_move(self.origin, self.patrolNode.origin) ){
        dprint("AI - failed to see tether node, pathfinding!\n");
        if( NODEGRAPH_queue_total < NODEGRAPH_MAX_REQUEST ){
          pathFind = ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
          if( pathFind ){
            self.ai_state_save = self.ai_state;
            self.ai_state_next = ST_NODEGRAPH;
            NODEGRAPH_queue_total = NODEGRAPH_queue_total + 1;
            return;
          }
        }
      }
    }
    
    self.ai_state_next = ST_PTR_TRAVEL_NODE;
    self.goalentity = self.patrolNode;
    self.tether = TETHER_PATROL;
    self.patrolState = PATROL_WALKING;
    
    if( self.legs ){
      self.legs.attack_state = TR_GOAL;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_GOAL;
    }
    
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
      //prepare for war....
      self.ai_state_next = ST_COMBAT;
      return;
    }
    self.moveState = MOVE_NORM;
    return;
  }
};
/*
  STATE : PATROL PAUSE
*/
void() ai_ptr_pause={
  ai_update_accuracy( FALSE );
  
  //entered pause state
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
      //prepare for war....
      self.ai_state_next = ST_COMBAT;
      self.moveState = MOVE_NORM;
      return;
    }
    self.pausetime = time + self.pausetime;
    self.moveState = 0;
    return;
  }
  //--------------------------
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( time > self.pausetime ){
    self.ai_state_next = ST_PTR;
  }
};
/*
  STATE : PATROL TRAVEL TO NODE
*/
void() ai_ptr_travel_node={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.moveState = MOVE_NORM;
  
  ai_update_accuracy( TRUE );
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.patrolState == PATROL_PAUSE && self.patrolStateLast != PATROL_PAUSE ){
    self.ai_state_next = ST_PTR_PAUSE;
    return;
  }
  
  if(self.patrolState == PATROL_ARRIVE){
    if(self.tether == TETHER_PATROL){
      self.ai_state_next = ST_PTR;
    }
    else{
      self.ai_movedist = max(self.patrolNode.ai_view, 250);
      self.ai_move_next = ai_move_director();
      self.ai_state_next = ST_COM_MOVE_START;
    }
    return;
  }
  
  if(self.patrolState == PATROL_BLOCK && self.patrolStateLast != PATROL_BLOCK ){
    self.ai_state_next = ST_PTR_TRAVEL_NODEBLOCK;
    return;
  }
  self.patrolStateLast = self.patrolState;
  ai_patrol_state_frame();
};
/*
  STATE : PATROL TRAVEL TO NODE BLOCKED
*/
void() ai_ptr_travel_blocked={
  if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.moveState = 0;
  
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
void() ai_ptr_tether={
  //if( self.ai_state == ST_PTR_TETHER && self.ai_state_last != ST_PTR_TETHER ){
  //}
};

/*
  STATE : PATROL USE TETHER BLOCKED
*/
void() ai_ptr_tether_blocked={
  //if( self.ai_state == ST_PTR_TETHER_BLOCK && self.ai_state_last != ST_PTR_TETHER_BLOCK ){
 // }
};