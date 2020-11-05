/*
battleMETAL 
Author: Peter Roohr
Date: 11/04/2020
Overview:
  AI_HUNT is for when an AI loses sight of its target.
  It is a timer-limited run of a nodegraph path
  
  
*/
void() ai_hunt_start={
  local float pathFind;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_HUNT && self.ai_state_last != ST_HUNT ){
    /*
      INPUT
        + timer
        + target's position3 
        + valid node to run
    */
    //TODO - balance hunt time
    self.ai_movewait = time + 15;
    self.moveDest = self.enemy.position3;
    
    pathFind = ai_nodegraph_trace_vec( self.origin, self.moveDest );
    
    if( pathFind ){
      self.ai_state_next = ST_HUNT_MOVE;
      return;
    }
    
    self.ai_state_next = ST_COMBAT;
    return;
  }
}

void() ai_hunt_move={
  local float checkVis;
  local vector nqOrg;
  local float nodeYaw;
  local float turnSpeed;
  local float walkSpeed;
  local float dist;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_HUNT_MOVE && self.ai_state_last != ST_HUNT_MOVE ){
    /*
      CHECK
        Block
    */
  }
  
  //CHECK - TARGET VALID
  if( !ai_valid_target(self.enemy) ){
    //TODO - api func to revert state -> tether, patrol, self
  }
  
  //CHECK - REACQUIRED TARGET
  checkVis = ai_check_vis(self.enemy);
  if( checkVis == VIS_FRAC || checkVis == VIS_FRN ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.moveState = MOVE_NORM;
  ai_update_accuracy( TRUE );
  
  //CHECK - PATH ERROR
  if( self.nq1 == -1){
    dprint("ai_state_nodegraph_travel() nq1 == -1!\n");  //debug
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  //
  nqOrg = nodegraph_get_node_origin( self.nq1 );
  //dprint(sprintf("curret node: %f\n", self.nq1));
  //dprint(sprintf("curret origin: %f %f %f\n", nqOrg_x, nqOrg_y, nqOrg_z));
  nodeYaw = vectoyaw(nqOrg - self.origin);
  if( nodeYaw != self.angles_y ){
    self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
    yawCache = self.yaw_speed;
    self.yaw_speed = self.yaw_speed * 2;
    ChangeYaw();  //double 
    self.yaw_speed = yawCache;
    turnSpeed = TRUE;
  }

  //not at node yet, keep moving.
  if( turnSpeed || self.reverseFlag ){
    walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 3;
  }
  else{
    walkSpeed = self.data_speed_forward * 0.85;
  }
  
  if( walkmove(self.angles_y, walkSpeed) == FALSE ){
    dprint(sprintf("class %s\n", self.classname));
    dprint("TODO blocked in ai_state_nodegraph_travel() \n");  //debug
    //-> set self.ai_blockflag = time + X
    //check for timeout in THIS state first
    self.ai_state_next = ST_HUNT_BLOCK;
    return;
  }

  //ARRIVED AT NODE
  dist = vlen(nqOrg - self.origin);
  if( dist <= 32 ){
    self.ai_state_next = ST_HUNT_NODE;
    return;
  }
}

void() ai_hunt_check_node={
  local float nodeLen;
  local float pathFind;
  local float checkVis;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_HUNT_NODE && self.ai_state_last != ST_HUNT_NODE ){
    
    //early exit if target dead
    if( !ai_valid_target(self.enemy) ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    checkVis = ai_check_vis(self.enemy);
    if( checkVis == VIS_FRAC || checkVis == VIS_FRN ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //null node id error check.
    if(self.nq1 == -1){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //release node lock
    NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
    
    //at verified end of path
    if( self.pathEndId == self.nq1 ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //end of path BUT not desired destination
    if( self.nq2 == -1 ){
      dprint("AI - failed to see patrol node, pathfinding!\n");
      pathFind = ai_nodegraph_trace_vecToNode( self.origin, self.pathEndId );
      if( pathFind ){
        self.ai_state_next = ST_COM_MOVE_START;
        dprint("travel complete->ST_COM_MOVE_START \n");  //debug
        return;
      }
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //end of path, ready to go again
    pathFind = ai_nodegraph_next();
    if( pathFind ){
      dprint(sprintf("ai_combat() path next: %f\n", self.nq2));
      self.ai_state_next = ST_HUNT_MOVE;
      return;
    }
    self.ai_state_next = ST_COMBAT;
    return;
  }
};

void() ai_hunt_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_HUNT_BLOCK && self.ai_state_last != ST_HUNT_BLOCK ){
  
    return;
  }
}