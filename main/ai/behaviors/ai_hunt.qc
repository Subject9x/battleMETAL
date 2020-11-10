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
  local float moveYaw;
  local float moveSpeed;
  local float turnFlag;
  
  if( self.nq1 == -1 ){
    //dprint("ai_nodegraph_frame()->self.nq1 == -1\n");  //debug
    ai_nodegraph_trace_vec( self.origin, self.enemy.position1 );
  }
  else{
    //dprint(sprintf("CURRENT NQ1 %0.0f\n", self.nq1));  //debug
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nodeDist = ai_check_dist_node(self.origin, nqOrg);
    if( nodeDist <= 16 ){
      //arrived at node
      //dprint(sprintf("ARRIVED NODE %0.0f\n", self.nq1));  //debug
      pathFind = ai_nodegraph_next();
      //dprint(sprintf("NEXT NODE %0.0f\n", self.nq1));  //debug
      if( !pathFind ){
        //dprint(sprintf("!FAILED-----NEXT NODE %0.0f || RETRACING \n", self.nq1));  //debug
        ai_nodegraph_trace_vec( self.origin, self.enemy.position2 );
      }
    }
    else{
     //dprint(sprintf("WALKING TO %0.0f\n", self.nq1));  //debug
      moveSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
      //still traveling to node
      nodeYaw = vectoyaw(nqOrg - self.origin);
      //check yaw-to-node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = nodeYaw;
        
        moveSpeed = self.data_speed_strafe;
        //yaw is too wide, stop moving and just pivot to node
        //dprint(sprintf("ideal_yaw %f\n",self.ideal_yaw)); //debug
        //dprint(sprintf("nodeYaw %f\n", fabs(self.ideal_yaw - self.angles_y))); //debug
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
        if( self.legs ){
          self.legs.attack_state = TR_TARG;
          self.legs.ai_dir = nodeYaw;
        }
      }
      if( self.ai_hardTurn ){
        //dprint("HARD TURN ACTIVE\n");  //debug
        self.moveState = MOVE_STAND;
        ChangeYaw();
        if( self.angles_y == nodeYaw ){
          self.ai_hardTurn = FALSE;
        }
      }
      else{
        //dprint("NORM MOVE\n");  //debug
        self.moveState = MOVE_NORM;
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
        }
      }
    }
  }
};