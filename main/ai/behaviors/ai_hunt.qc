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
    ai_nodegraph_trace_vec( self.origin, self.enemy.position1 );
  }
  else{
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nodeDist = ai_check_dist_node(self.origin, nqOrg);
    if( nodeDist <= 16 ){
      //arrived at node
      pathFind = ai_nodegraph_next();
      if( !pathFind ){
        ai_nodegraph_trace_vec( self.origin, self.enemy.position2 );
      }
    }
    else{
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
        self.moveState = MOVE_NORM;
      }
      moveSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
      //still traveling to node
      nodeYaw = vectoyaw(nqOrg - self.origin);
      //check yaw-to-node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = nodeYaw;
        
        moveSpeed = self.data_speed_strafe;
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
      else{
        self.ai_hardTurn = FALSE;
      }
      if( self.ai_hardTurn ){
        if( self.legs ){
          self.legs.attack_state = TR_YAW;
          self.moveState = MOVE_STAND;
        }
        ChangeYaw();
        if( self.angles_y == nodeYaw ){
          self.ai_hardTurn = FALSE;
        }
      }
      else{
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
        }
      }
    }
  }
};