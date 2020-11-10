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
void( float turnSpeed, float walkSpeed, float turnTime ) ai_nodegraph_patrol_frame={
  local float pathFind;
  local float nodeDist;
  local float nodeYaw;
  local float moveSpeed;
  local float turnFlag;
  
  nodeDist = vlen( self.patrolNode.origin - self.origin );
  //debug
  if( self.classname == "unit_matok_survest_gunner" ){
    dprint(sprintf("node dist %f\n", nodeDist));  //debug
  }
  //TODO - adjust node target origin to ent's height
  //something like 
  if( nodeDist <= 16 ){
    //arrived at node.
    if( self.patrolNode.partNext ){
      //set the next node if it exists
      self.patrolNode = self.patrolNode.partNext;
      dprint(sprintf("%s\n", self.patrolNode.targetname));  //debug
    }
    else{
      //we're at the end, shut it all down.
      self.tether = TETHER_NONE;
    }
  }
  else{
    //moving to node
    if( ai_check_terrain_move(self.origin, self.patrolNode.origin) ){
      //still traveling to node
      nodeYaw = vectoyaw(self.patrolNode.origin - self.origin);
      //check yaw-to-node
      if( nodeYaw != self.angles_y ){
        self.ideal_yaw = vectoyaw(self.patrolNode.origin - self.origin);
        
        //yaw is too wide, stop moving and just pivot to node
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
      if( !self.ai_hardTurn ){
        self.moveState = MOVE_NORM;
        if( turnFlag ){
          moveSpeed = turnSpeed;
        }
        else{
          moveSpeed = walkSpeed;
        }
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          ai_nodegraph_trace_vec( self.origin, self.patrolNode.origin );
        }
      }
      else{
        self.moveState = MOVE_STAND;
      }
    }
    else{
      ai_nodegraph_frame( self.enemy.origin, self.enemy.origin, self.data_speed_strafe, self.data_speed_forward * 0.75, 5);
    }
  }
};