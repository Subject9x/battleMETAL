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
  -> move to ai_combat
*/
void() ai_nodegraph_combat_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float nodeYaw;
  local float turnSpeed;
  local float walkSpeed;
  
  if( self.nq1 == -1 ){
    //fresh path
    ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
  }
  else{
    makevectors(self.angles);
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nqOrg = nqOrg + (v_forward * 16);
    nodeDist = vlen(nqOrg - self.origin);
    if( nodeDist != -1 ){
      //todo - path error
    }
    if( nodeDist <= 32 ){
      //arrived at node
      pathFind = ai_nodegraph_next();
      if( !pathFind ){
        ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
      }
    }
    else{
      nodeYaw = vectoyaw(nqOrg - self.origin);
      //still traveling to node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        
        if( fabs(self.ideal_yaw - self.angles_y) >= 90 ){
          if( time > self.ai_timer_checkTurn ){
            self.ai_hardTurn = TRUE;
            self.ai_timer_checkTurn = self.ai_timer_checkTurn + 5;
          }
        }
        else{
          self.ai_hardTurn = FALSE;
        }
        
        ChangeYaw();
        turnSpeed = TRUE;
        if( self.legs ){
          self.legs.attack_state = TR_TARG;
          self.legs.ai_dir = nodeYaw;
        }
      }
      if( !self.ai_hardTurn ){
        if( turnSpeed ){
          walkSpeed = self.data_speed_strafe * 0.5;
        }
        else{
          walkSpeed = self.data_speed_forward * 0.67;
        }
        if( walkmove(self.angles_y, walkSpeed) == FALSE ){
          ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
        }
      }
    }
  }
};

/*
  Same deal as ai_nodegraph_combat_frame() 
    BUT!
    it checks AI's patrol node references instead of enemy position.
    
    this is used when a bot gets stuck trying to patrol
    
-> move to ai_patrol
*/
void() ai_nodegraph_patrol_frame={
  local float pathFind;
  local float nodeDist;
  local float nodeYaw;
  local vector nqOrg;
  local float turnSpeed;
  local float walkSpeed;
  
  if( self.nq1 == -1 ){
    //fresh path
    ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
  }
  else{
    makevectors(self.angles);
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nqOrg = nqOrg + (v_forward * 16);
    nodeDist = vlen(nqOrg - self.origin);
    if( nodeDist != -1 ){
      //todo - path error
    }
    if( nodeDist <= 32 ){
      //arrived at node
      pathFind = ai_nodegraph_next();
      if( !pathFind ){
        ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
      }
      self.moveState = MOVE_STAND;
    }
    else{
      nodeYaw = vectoyaw(nqOrg - self.origin);
      //still traveling to node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        
        //if node angle is 
        if( fabs(self.ideal_yaw - self.angles_y) >= 90 ){
          if( time > self.ai_timer_checkTurn ){
            self.ai_hardTurn = TRUE;
            self.ai_timer_checkTurn = self.ai_timer_checkTurn + 5;
          }
        }
        else{
          self.ai_hardTurn = FALSE;
        }
        
        yawCache = self.yaw_speed;
        self.yaw_speed = self.yaw_speed * 2;
        ChangeYaw();
        self.yaw_speed = yawCache;
        turnSpeed = TRUE;
        if( self.legs ){
          self.legs.attack_state = TR_TARG;
          self.legs.ai_dir = nodeYaw;
        }
        
      }
      //turning hard to node.
      if( !self.ai_hardTurn ){
        self.moveState = MOVE_NORM;
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
      else{
        self.moveState = MOVE_STAND;
      }
    }
  }
};