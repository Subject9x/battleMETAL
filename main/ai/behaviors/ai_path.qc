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
  local float moveSpeed;
  local float turnFlag;
  
  if( self.nq1 == -1 ){
    //fresh path
    //todo - queue and timer 
    ai_nodegraph_trace_vec( self.origin, targDest );
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
        //todo - queue and timer 
        ai_nodegraph_trace_vec( self.origin, targDest );
      }
    }
    else{
      //still traveling to node
      nodeYaw = vectoyaw(nqOrg - self.origin);
      //check yaw-to-node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        
        //yaw is too wide, stop moving and just pivot to node
        dprint(sprintf("nodeYaw %f\n", fabs(self.ideal_yaw - self.angles_y))); //debug
        if( fabs(self.ideal_yaw - self.angles_y) >= 90 ){
          if( time > self.ai_timer_checkTurn ){
            self.ai_hardTurn = TRUE;
            self.ai_timer_checkTurn = self.ai_timer_checkTurn + turnTime;
          }
        }
        else{
          self.ai_hardTurn = FALSE;
        }
        
        ChangeYaw();
        turnFlag = TRUE;
        if( self.legs ){
          self.legs.attack_state = TR_TARG;
          self.legs.ai_dir = nodeYaw;
        }
      }
      if( self.ai_hardTurn == TRUE ){
        self.moveState = MOVE_STAND;
        
      }
      else{
        if( turnFlag ){
          moveSpeed = turnSpeed;//self.data_speed_strafe * 0.5;
        }
        else{
          moveSpeed = walkSpeed;//self.data_speed_forward * 0.67;
        }
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          //todo - queue and timer 
          ai_nodegraph_trace_vec( self.origin, offsetTargDest );
        }
      }
    }
  }
};