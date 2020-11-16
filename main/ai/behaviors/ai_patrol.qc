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
  local float pathFind;
  local float nodeDist;
  local float nodeYaw;
  local float moveSpeed;
  local float turnFlag;
  local float moveYaw;
  
  nodeDist = ai_check_dist_node(self.origin, self.patrolNode.origin);
  if( nodeDist <= 16 ){
    //arrived at node.
    if( self.patrolNode.partNext ){
      //set the next node if it exists
      self.patrolNode = self.patrolNode.partNext;
    }
    else{
      //we're at the end, shut it all down.
      self.tether = TETHER_NONE;
      self.moveState = MOVE_STAND;
      pathFind = ai_nodegraph_to_org(self.origin);
      if( pathFind ){
        ai_nodegraph_trace_vecToNode( self.origin, pathFind );
      }
    }
  }
  else{
    //moving to node
    if( ai_check_terrain_move(self.origin, self.patrolNode.origin) ){
      //still traveling to node
      nodeYaw = vectoyaw(self.patrolNode.origin - self.origin);
      moveSpeed = walkSpeed;
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
            moveSpeed = turnSpeed * 0.33;
          }
          else if( moveYaw >= 35 ){
            moveSpeed = turnSpeed * 0.5;
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
          ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
        }
      }
    }
    else{
      ai_nodegraph_frame( self.patrolNode.origin, self.patrolNode.origin, self.data_speed_strafe, self.data_speed_forward * 0.75, 5);
    }
  }
};