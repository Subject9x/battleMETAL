/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
*/

void() ai_nodegraph_patrol_arrive;

/*
  based on lean AI impl
    all-in-one, flat if-checking for patrol
      also takes into account not being able to reach a patrolNode
  
  //lead-in ---> IF self.tether = TETHER_PATROL
*/
void( float turnSpeed, float walkSpeed ) ai_nodegraph_patrol_frame={
  /*
    note: ai_node entities are now mostly just 'meta' entities, the AI does not directly path to the
      entity itself, rather; the AI locates the nearest NODEGRAPH node to the patrolNode.
      
      the patrolNode itself also holds the closest NODEGRAPH node ID as well.
  */
  
  //-----------------
  
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float moveYaw;
  local float moveSpeed;
  local float walkAngle;
  
  if( self.nqLast != -1 ){
    ai_nodegraph_check_lastnode();
  }
  
  if( self.nq1 == -1 ){
    //maybe the destination > the 24 node-queue vars.
    ai_nodegraph_clear_locks();
    ai_nodegraph_trace_vecToNode( self.origin, self.patrolNode.pathEndId );
  }
  else{
    if( !self.ai_last_pathWait ){
      nqOrg = nodegraph_get_node_origin( self.nq1 );
      nodeDist = ai_check_dist_node(self.origin, nqOrg);
      //------------------------------------------------------------------------------------------------------------------------------------------
      if( nodeDist <= 8 ){
        //arrived at node
        if( self.nq1 == self.patrolNode.pathEndId ){
          ai_nodegraph_patrol_arrive();
        }
        else{
          //clustering fix-patch, if AI is 1-node away from path target, and target is occupied? early-exit, and keep moving.
          if( self.nq2 == self.patrolNode.pathEndId ){
            if( NODEGRAPH_DATA_BLOCK[self.nq2] != self.entnum ){
              //if actual node dest is already blocked by another bot, treat this node as destination and path to next node
              ai_nodegraph_patrol_arrive();
            }
          }
          else{
            pathFind = ai_nodegraph_next();
          }
        }
      //------------------------------------------------------------------------------------------------------------------------------------------
      }
      else{
        self.moveState = MOVE_NORM;
        if( self.legs_hp ){
          self.legs_attackState = TR_NORM;
        }
        moveSpeed = walkSpeed;
        //still traveling to node
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        //check yaw-to-node
        if( self.angles_y != self.ideal_yaw ){
          moveSpeed = turnSpeed;
          //yaw is too wide, stop moving and just pivot to node
          moveYaw = anglemod(self.angles_y - self.ideal_yaw);
          if(moveYaw > 135 && moveYaw < 225 ){
            if( self.nq2 == -1 ){
              self.ai_reverse = TRUE;
              moveSpeed = self.data_speed_backward;
            }
            else{
              nqOrg = nodegraph_get_node_origin( self.nq2 );
              if( ai_check_face_origin(nqOrg, 0.75, FALSE) ){
                self.ai_reverse = TRUE;
                moveSpeed = self.data_speed_backward;
              }
            }
          }
          else  if( moveYaw > 15 && moveYaw < 345 ){
            self.moveState = MOVE_STAND;
            moveSpeed = 0;
            if( self.legs_hp ){
              self.legs_attackState = TR_NORM;
            }
          }
          else{
            if( moveYaw > 10 && moveYaw < 350){
              moveSpeed = moveSpeed * 0.55; //0.33
            }
            else if( moveYaw > 5 && moveYaw < 355 ){
              moveSpeed = moveSpeed * 0.8; //0.67
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
      if( self.ai_reverse ){
        walkAngle = anglemod(self.angles_y - 180);
        self.ai_reverse = FALSE;
        //seriously only let AI try this per-frame, otherwise unbounded reverse sends bots moonwalking backwards into anything and everything.
        //it was a poorly implemented idea to get a simple "back up" move action for bots.
      }
      else{
        walkAngle = self.angles_y;
      }
      moveSpeed = ai_check_slope(walkAngle, moveSpeed);
      if( walkmove(walkAngle, moveSpeed) == FALSE ){
        if( time > self.ai_timer_pathWait ){
          self.ai_last_pathWait = TRUE;
          self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
        }
      }
    }
  }
};

/*
  made this a generic because AI runs the check in 2 places, 
    case 1: normal arrival to patrol path node they have a lock on.
    case 2: they're only 1 node away FROM patrol path node that's LOCKED BY another AI, so treat the node they're at AS IF
      they've reached the path node.
*/
void() ai_nodegraph_patrol_arrive={
  local float oldNode;
  local float pathFind;
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
  NODEGRAPH_DATA_BLOCK[self.nqLast] = FALSE;
};

