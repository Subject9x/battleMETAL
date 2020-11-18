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
float( vector targDest, vector offsetTargDest, float turnSpeed, float walkSpeed ) ai_nodegraph_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float moveYaw;
  local float moveSpeed;
  
  if( self.nq1 == -1 ){
    //maybe the destination > the 24 node-queue vars.
    ai_nodegraph_trace_vec( self.origin, targDest );
    return TRUE;
  }
  else{
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nodeDist = ai_check_dist_node(self.origin, nqOrg);
    if( nodeDist <= 16 ){
      //arrived at node
      if( self.pathEndId == self.nq1 ){
        //AI has finished its nodegraph run
        ai_nodegraph_clear_path();
        ai_nodegraph_clear_locks();
        return FALSE;
      }
      else{
        pathFind = ai_nodegraph_next();
        if( !pathFind ){
          ai_nodegraph_trace_vec( self.origin, targDest );
        }
        return TRUE;
      }
    }
    else{
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
        self.moveState = MOVE_NORM;
      }
      moveSpeed = walkSpeed;
      //still traveling to node
      self.ideal_yaw = vectoyaw(nqOrg - self.origin);
      //check yaw-to-node
      if( self.angles_y != self.ideal_yaw ){
        moveSpeed = turnSpeed;
        //yaw is too wide, stop moving and just pivot to node
        moveYaw = anglemod(self.angles_y - self.ideal_yaw);
        if( moveYaw > 45 && moveYaw < 315 ){
          self.ai_hardTurn = TRUE;
        }
        else{
          self.ai_hardTurn = FALSE;
          moveSpeed = turnSpeed;
          if( moveYaw > 15 && moveYaw < 345 ){
            moveSpeed = turnSpeed * 0.25;
          }
        }
        ChangeYaw();
      }
      else{
        self.ai_hardTurn = FALSE;
      }
      if( self.ai_hardTurn ){
        if( self.legs ){
          self.legs.attack_state = TR_YAW;
          self.moveState = MOVE_NORM;
        }
        ChangeYaw();
      }
      else{
        if( self.legs ){
          self.legs.attack_state = TR_NORM;
        }
        
        if( self.ai_last_pathWait ){
          if( time > self.ai_timer_pathWait ){
            pathFind = ai_nodegraph_trace_vec( self.origin, offsetTargDest );
            if( pathFind ){
              self.ai_last_pathWait = FALSE;
              self.moveState = MOVE_NORM;
            }
            self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
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
              dprint(sprintf("[%s]( %0.2f %0.2f %0.2f) :: ai_nodegraph_frame()  - ai_last_pathWait\n", self.classname, self.origin_x, self.origin_y, self.origin_z));  //debug
            }
          }
        }
      }
    }
    return TRUE;
  }
  return FALSE;
};