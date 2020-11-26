/*
battleMETAL 
Author: Peter Roohr
Date: 10/29/2020
Overview: 
  special state for using the nodegraph system
*/


/*
  Generic impl of the nodegraph_frame.
    What this does
      1) check to see if bot already is running a path
        if-not, build a path
      2) when running a path, walk towards the origin of self.nq1
        check yaw angle, if the angle is beyond the forward arc, stop moving and pivot only.
        
*/
void( vector targDest, vector offsetTargDest, float turnSpeed, float walkSpeed ) ai_nodegraph_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float moveYaw;
  local float moveSpeed;
  local float blockCheck;
  local vector lastNodeOrg;
  local float lastNodeDist;
  
  if( self.nqLast != -1 ){
    lastNodeOrg = nodegraph_get_node_origin( self.nqLast );
    lastNodeDist = ai_check_dist_node(self.origin, lastNodeOrg);
    if( lastNodeDist > 128 ){
      NODEGRAPH_DATA_BLOCK[self.nqLast] = FALSE;
    }
  }
  
  if( self.nq1 == -1 ){
    //maybe the destination > the 24 node-queue vars.
    ai_nodegraph_clear_locks();
    ai_nodegraph_trace_vec( self.origin, targDest );
  }
  else{
    if( !self.ai_last_pathWait ){
      nqOrg = nodegraph_get_node_origin( self.nq1 );
      nodeDist = ai_check_dist_node(self.origin, nqOrg);
      if( nodeDist <= 8 ){
        //arrived at node
        if( self.pathEndId == self.nq1 ){
          //AI has finished its nodegraph run
          ai_nodegraph_clear_path();
          ai_nodegraph_clear_locks();
        }
        else{
          pathFind = ai_nodegraph_next();
          if( !pathFind ){
            ai_nodegraph_trace_vec( self.origin, targDest );
          }
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
        NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
        pathFind = ai_nodegraph_trace_vec( self.origin, offsetTargDest );
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
        if( self.tether == TETHER_PATROL ){
          blockCheck = NODEGRAPH_DATA_BLOCK[self.patrolNode.pathEndId];
          if( blockCheck != FALSE || blockCheck != self.entnum ){
            pathFind = ai_nodegraph_trace_vec( self.origin, self.patrolNode.compOffset );
          }
          else{
            self.ai_last_pathWait = TRUE;
            self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
          }
        }
        else{
          if( time > self.ai_timer_pathWait ){
            self.ai_last_pathWait = TRUE;
            self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
          }
        }
      }
    }
  }
};