/*
battleMETAL 
Author: Peter Roohr
Date: 11/04/2020
Overview:
  AI_HUNT is for when an AI loses sight of its target.
  It is a timer-limited run of a nodegraph path
  
  
*/
/*
  A more stateless implementation of the nodegraph state from earlier;
    if the AI arrives here, it merely checks if a path exists -
      if there's a path, run it,
      if no path, make a new one
*/
void() ai_nodegraph_hunter_frame={
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