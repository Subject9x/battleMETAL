/*
battleMETAL 
Author: Peter Roohr
Date: 10/29/2020
Overview: 
  special state for using the nodegraph system
*/


/*
  A more stateless implementation of the nodegraph state from earlier;
    if the AI arrives here, it merely checks if a path exists -
      if there's a path, run it,
      if no path, make a new one
*/
void() ai_nodegraph_combat_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float turnSpeed;
  local float walkSpeed;
  
  if( self.nq1 == -1 ){
    //fresh path
    ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
  }
  else{
    nodeDist = ai_nodegraph_distance_check( self.nq1 );
    if( nodeDist != -1 ){
      //todo - path error
    }
    if( nodeDist <= 32 ){
      //arrived at node
      ai_nodegraph_next();
    }
    else{
      nqOrg = nodegraph_get_node_origin( self.nq1 );
      //still traveling to node
      if( vectoyaw(nqOrg - self.origin) != self.angles_y ){
        self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
        yawCache = self.yaw_speed;
        self.yaw_speed = self.yaw_speed * 2;
        ChangeYaw();  //double 
        self.yaw_speed = yawCache;
        turnSpeed = TRUE;
      }
      if( turnSpeed ){
        walkSpeed = self.data_speed_strafe * 0.75;
      }
      else{
        walkSpeed = self.data_speed_forward;
      }
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        ai_nodegraph_trace_vec( self.origin, self.enemy.position1 );
      }
    }
  }
};

/*
  Same deal as ai_nodegraph_combat_frame() 
    BUT!
    it checks AI's patrol node references instead of enemy position.
    
    this is used when a bot gets stuck trying to patrol
*/
void() ai_nodegraph_patrol_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float turnSpeed;
  local float walkSpeed;
  
  if( self.nq1 == -1 ){
    //fresh path
    ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
  }
  else{
    nodeDist = ai_nodegraph_distance_check( self.nq1 );
    if( nodeDist != -1 ){
      //todo - path error
    }
    if( nodeDist <= 32 ){
      //arrived at node
      ai_nodegraph_next();
    }
    else{
      nqOrg = nodegraph_get_node_origin( self.nq1 );
      //still traveling to node
      if( vectoyaw(nqOrg - self.origin) != self.angles_y ){
        self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
        yawCache = self.yaw_speed;
        self.yaw_speed = self.yaw_speed * 2;
        ChangeYaw();  //double 
        self.yaw_speed = yawCache;
        turnSpeed = TRUE;
      }
      if( turnSpeed ){
        walkSpeed = self.data_speed_strafe * 0.5;
      }
      else{
        walkSpeed = self.data_speed_forward * 0.67;
      }
      if( walkmove(self.angles_y, walkSpeed) == FALSE ){
        ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
      }
    }
  }
};


/*
  ST_NODEGRAPH = 15;
*/
void() ai_state_nodegraph={
  if(self.ai_state == ST_NODEGRAPH &&  self.ai_state_last != ST_NODEGRAPH ){
    dprint(sprintf("path 1: %f\n", self.nq1));
    dprint(sprintf("path 2: %f\n", self.nq2));
    dprint(sprintf("path 3: %f\n", self.nq3));
    dprint(sprintf("path 4: %f\n", self.nq4));
    dprint(sprintf("path 5: %f\n", self.nq5));
    dprint(sprintf("path 6: %f\n", self.nq6));
    dprint(sprintf("path 7: %f\n", self.nq7));
    dprint(sprintf("path 8: %f\n", self.nq8));
    dprint(sprintf("path 9: %f\n", self.nq9));
    dprint(sprintf("path 10: %f\n", self.nq10));
    dprint(sprintf("path 11: %f\n", self.nq11));
    dprint(sprintf("path 12: %f\n", self.nq12));
    dprint(sprintf("path 13: %f\n", self.nq13));
    dprint(sprintf("path 14: %f\n", self.nq14));
    dprint(sprintf("path 15: %f\n", self.nq15));
    dprint(sprintf("path 16: %f\n", self.nq16));
    
    self.ai_state_next = ST_NODEGRAPH_MOVE;
    return;
  }
};

/*
  ST_NODEGRAPH_PAUSE = 16
*/
void() ai_state_nodegraph_pause={
  local vector terrainScan;
  local float nextState;
  local float pathFind;
  
  if(self.ai_state == ST_NODEGRAPH_PAUSE &&  self.ai_state_last != ST_NODEGRAPH_PAUSE ){
    if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
      //prepare for war....
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //null node id error check.
    if(self.nq1 == -1){
      self.ai_state_next = ST_STAND;
      return;
    }
    
    //release node lock
    NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
    
    //at verified end of path
    if( self.pathEndId == self.nq1 ){
      if( self.tether ){
        switch( self.tether ){
          case TETHER_PATROL:
            terrainScan = self.patrolNode.origin;
            nextState = ST_PTR;
            break;
          case TETHER_NODE:
            terrainScan = self.patrolNode.origin;
            nextState = ST_THR;
            break;
          case TETHER_SELF:
            terrainScan = self.tetherOrg;
            break;
        }
        if( terrainScan ){
          if( ai_check_terrain_move(self.origin, terrainScan) ){
            self.ai_state_next = nextState;
            return;
          }
        }
      }
      self.ai_state_next = ST_STAND;
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
      self.ai_state_next = ST_COM_MOVE_START;
    }
    self.ai_state_next = ST_COMBAT;
    return;
  }
};

/*
  ST_NODEGRAPH_MOVE = 17
*/
void() ai_state_nodegraph_travel={
  local float dist;
  local float walkSpeed;
  local vector nqOrg;
  local float turnSpeed;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.moveState = MOVE_NORM;
  ai_update_accuracy( TRUE );
  
  //ENTER STATE=====================================================
  if(self.ai_state == ST_NODEGRAPH_MOVE &&  self.ai_state_last != ST_NODEGRAPH_MOVE ){
    if( (self.flags & FL_TURRET) ){
      self.torsoCenter.attack_state = TR_NORM;
    }
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
    }
    //return; - make the state-ini seamless by processing node movement on the first tic as well.
  }
  //=================================================================
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.nq1 == -1){
    dprint("ai_state_nodegraph_travel() nq1 == -1!\n");  //debug
    return;
  }
  
  nqOrg = nodegraph_get_node_origin( self.nq1 );
  //dprint(sprintf("curret node: %f\n", self.nq1));
  //dprint(sprintf("curret origin: %f %f %f\n", nqOrg_x, nqOrg_y, nqOrg_z));
  if( vectoyaw(nqOrg - self.origin) != self.angles_y ){
    self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
    yawCache = self.yaw_speed;
    self.yaw_speed = self.yaw_speed * 2;
    ChangeYaw();  //double 
    self.yaw_speed = yawCache;
    turnSpeed = TRUE;
  }
  //not at node yet, keep moving.
  if( turnSpeed ){
    walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 3.75;
  }
  else{
    walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 2;
  }
  if( walkmove(self.angles_y, walkSpeed) == FALSE ){
    dprint(sprintf("class %s\n", self.classname));
    dprint("TODO blocked in ai_state_nodegraph_travel() \n");  //debug
    self.ai_state_next = ST_COM_MOVE_BLOCK;
    return;
  }
  
  dist = vlen(nqOrg - self.origin);
  if( dist <= 32 ){
    self.ai_state_next = ST_COM_MOVE_END;
    return;
  }
};

/*
  ST_NODEGRAPH_BLOCK = 18
*/
void() ai_state_nodegraph_travel_block={
  if(self.ai_state == ST_NODEGRAPH_BLOCK &&  self.ai_state_last != ST_NODEGRAPH_BLOCK ){
  
    return;
  }


};
