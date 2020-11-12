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
void( vector targDest, vector offsetTargDest, float turnSpeed, float walkSpeed, float turnTime ) ai_nodegraph_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float nodeYaw;
  local float moveYaw;
  local float moveSpeed;
  local float turnFlag;
  
  if( self.nq1 == -1 ){
    ai_nodegraph_clear_path();
    ai_nodegraph_trace_vec( self.origin, targDest );
  }
  else{
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nodeDist = ai_check_dist_node(self.origin, nqOrg);
    if( nodeDist <= 16 ){
      //arrived at node
      pathFind = ai_nodegraph_next();
      if( !pathFind ){
        ai_nodegraph_trace_vec( self.origin, targDest );
      }
    }
    else{
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
        self.moveState = MOVE_NORM;
      }
      moveSpeed = walkSpeed;
      //still traveling to node
      nodeYaw = vectoyaw(nqOrg - self.origin);
      //check yaw-to-node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = nodeYaw;
        
        moveSpeed = turnSpeed;
        //yaw is too wide, stop moving and just pivot to node
        moveYaw = fabs(self.ideal_yaw - self.angles_y);
        if( moveYaw >= 180 ){
          self.ai_hardTurn = TRUE;
        }
        else{
          self.ai_hardTurn = FALSE;
          if( moveYaw >= 90 ){
            moveSpeed = moveSpeed * 0.33;
          }
          else if( moveYaw >= 35 ){
            moveSpeed = moveSpeed * 0.5;
          }
        }
        ChangeYaw();
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
          self.moveState = MOVE_NORM;
        }
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          ai_nodegraph_trace_vec( self.origin, offsetTargDest );
        }
      }
    }
  }
};