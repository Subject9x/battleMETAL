/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish tanks are the basic behavior of tanks in the game,
  _patrol.qc contains the state function bodies for the state machine.
  
*/



/*
  based on lean AI impl
    all-in-one, flat if-checking for patrol
      also takes into account not being able to reach a patrolNode
  
  //lead-in ---> IF self.tether = TETHER_PATROL
*/
void() ai_patrol_frame_2={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float turnSpeed;
  local float walkSpeed;
  
  makevectors(self.angles);
  if( vlen((self.patrolNode.origin + (v_forward * 32)) - self.origin) <= 32 ){
    //arrived at node.
    if( self.patrolNode.partNext ){
      //set the next node if it exists
      self.patrolNode = self.patrolNode.partNext;
    }
    else{
      //we're at the end?
      self.tether = TETHER_NONE;
    }
  }
  else{
    //moving to node
    if( ai_check_terrain_move(self.origin, self.patrolNode.origin) ){
      dprint("patrol -> ai_check_terrain_move \n"); //debug
      //can free-move to the node
      if( vectoyaw(self.patrolNode.origin - self.origin) != self.angles_y ){
        self.ideal_yaw = vectoyaw(self.patrolNode.origin - self.origin) ;
        yawCache = self.yaw_speed;
        self.yaw_speed = self.yaw_speed * 1.5;
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
    else{
      //dprint("patrol -> FALSE ai_check_terrain_move \n"); //debug
      //blocked, use nodegraph
      if( self.nq1 == -1 ){
        //dprint("patrol -> FALSE ai_check_terrain_move \n"); //debug
        //fresh path
        ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
      }
      else{
        nqOrg = nodegraph_get_node_origin( self.nq1 );
        if( vectoyaw(nqOrg - self.origin) != self.angles_y ){
          self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
          yawCache = self.yaw_speed;
          self.yaw_speed = self.yaw_speed * 1.5;
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
        makevectors(self.angles);
        if( vlen((nqOrg + (v_forward * 32)) - self.origin) <= 32 ){
          ai_nodegraph_next();
        }
        if( walkmove(self.angles_y, walkSpeed) == FALSE ){
          
          ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
        }
      }
    }
  }
};