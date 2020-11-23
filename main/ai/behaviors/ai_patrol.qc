/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
*/

/*
  based on lean AI impl
    all-in-one, flat if-checking for patrol
      also takes into account not being able to reach a patrolNode
  
  //lead-in ---> IF self.tether = TETHER_PATROL
*/
void( float turnSpeed, float walkSpeed ) ai_nodegraph_patrol_frame={
  local float nextDist;
  
  /*
    note: ai_node entities are now mostly just 'meta' entities, the AI does not directly path to the
      entity itself, rather; the AI locates the nearest NODEGRAPH node to the patrolNode.
      
      the patrolNode itself also holds the closest NODEGRAPH node ID as well.
  */
 
    //check if we're actually closer to the NEXT node
  /*if( self.patrolNode.partNext ){
  
    nqOrg = nodegraph_get_node_origin( self.patrolNode.partNext.pathEndId );
    nextDist = ai_check_dist_node(self.origin, nqOrg);    
    if( nextDist <= nodeDist ){
      self.patrolNode = self.patrolNode.partNext;
      pathFind = ai_nodegraph_to_org_filter( self.origin , self.patrolNode.pathEndId, TRUE );
      ai_nodegraph_trace_vecToNode( self.origin, pathFind );
      return;
    }
  }*/
  //-----------------
  
  
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float moveYaw;
  local float moveSpeed;
  local float blockCheck;
  local float oldNode;
  
  if( self.nq1 == -1 ){
    //maybe the destination > the 24 node-queue vars.
    ai_nodegraph_trace_vecToNode( self.origin, self.patrolNode.pathEndId );
  }
  else{
    if( !self.ai_last_pathWait ){
      nqOrg = nodegraph_get_node_origin( self.nq1 );
      nodeDist = ai_check_dist_node(self.origin, nqOrg);
      if( nodeDist <= 8 ){
        //arrived at node
        if( self.nq1 == self.patrolNode.pathEndId ){ 
          //arrived at patrol node
          if( self.patrolNode.partNext ){
            oldNode = self.patrolNode.pathEndId;
            //continue the patrol route
            self.patrolNode = self.patrolNode.partNext;
            ai_nodegraph_clear_path();
            ai_nodegraph_trace_norm( oldNode, self.patrolNode.pathEndId );
          }
          else{
            //end of line
            self.tether = TETHER_NONE;
            self.moveState = MOVE_STAND;
            pathFind = ai_nodegraph_to_org_filter( self.origin , self.patrolNode.pathEndId, TRUE );
            if( pathFind != -1 ){
              ai_nodegraph_trace_vecToNode( self.origin, pathFind );
            }
            else{
              //ai_nodegraph_clear_locks();
            }
            self.patrolNode = world;
          }
        }
        else{
          pathFind = ai_nodegraph_next();
        }
      }
      else{
        self.moveState = MOVE_NORM;
        if( self.legs ){
          self.legs.attack_state = TR_NORM;
        }
        moveSpeed = walkSpeed;
        //still traveling to node
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        //check yaw-to-node
        if( self.angles_y != self.ideal_yaw ){
          moveSpeed = turnSpeed;
          //yaw is too wide, stop moving and just pivot to node
          moveYaw = anglemod(self.angles_y - self.ideal_yaw);
          if( moveYaw > 15 && moveYaw < 345 ){
            self.moveState = MOVE_STAND;
            moveSpeed = 0;
            if( self.legs ){
              self.legs.attack_state = TR_NORM;
            }
          }
          else{
            if( moveYaw > 10 && moveYaw < 350){
              moveSpeed = moveSpeed * 0.33;
            }
            else if( moveYaw > 5 && moveYaw < 355 ){
              moveSpeed = moveSpeed * 0.67;
            }
          }
          ChangeYaw();
        }
      }
    }
    if( self.ai_last_pathWait ){
      if( time > self.ai_timer_pathWait ){
        self.ai_last_pathWait = FALSE;
        self.ai_timer_pathWait = time + 1;
        pathFind = ai_nodegraph_trace_vecToNode( self.origin, self.patrolNode.pathEndId );
        if( pathFind ){
          self.moveState = MOVE_NORM;
        }
      }
      else{
        self.moveState = MOVE_STAND;
      }
    }
    else{
      if( walkmove(self.angles_y, moveSpeed) == FALSE ){
        if( time > self.ai_timer_pathWait ){
          self.ai_last_pathWait = TRUE;
          self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
        }
      }
    }
  }
};

