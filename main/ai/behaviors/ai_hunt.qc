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
  local float moveYaw;
  local float moveSpeed;
  
  if( self.nqLast != -1 ){
    ai_nodegraph_check_lastnode();
  }
  
  if( self.nq1 == -1 ){
    ai_nodegraph_clear_locks();
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
      self.moveState = MOVE_NORM;
      if( self.legs ){
        self.legs.attack_state = TR_NORM;
      }
      self.yawCache = self.yaw_speed;
      moveSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
      //still traveling to node
      self.ideal_yaw = vectoyaw(nqOrg - self.origin);
      //check yaw-to-node
      if( self.angles_y != self.ideal_yaw){
        moveSpeed = self.data_speed_strafe;
        
        //yaw is too wide, stop moving and just pivot to node
        moveYaw = anglemod(self.angles_y - self.ideal_yaw);
        if( moveYaw > 15 && moveYaw < 345 ){
          self.moveState = MOVE_STAND;
          moveSpeed = 0;
          if( self.legs ){
            self.legs.attack_state = TR_NORM;
          }
          self.yaw_speed = self.yaw_speed * 3;
        }
        else{
          if( moveYaw > 10 && moveYaw < 350){
            moveSpeed = moveSpeed * 0.33; //0.15
          }
          else if( moveYaw > 5 && moveYaw < 355 ){
            moveSpeed = moveSpeed * 0.67; //0.33
          }
          self.yaw_speed = self.yaw_speed * 2;
        }
        ChangeYaw();
        self.yaw_speed = self.yawCache;
      }
      
      if( self.ai_last_pathWait ){
        if( time > self.ai_timer_pathWait ){
          NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
          pathFind = ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
          if( pathFind ){
            self.moveState = MOVE_NORM;
            self.ai_last_pathWait = FALSE;
          }
          else{
            self.ai_timer_pathWait = time + 1;
          }
        }
        else{
          self.moveState = MOVE_STAND;
        }
      }
      else{
        moveSpeed = ai_check_slope(self.angles_y, moveSpeed);
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          if( time > self.ai_timer_pathWait ){
            self.ai_last_pathWait = TRUE;
            self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
          }
        }
      }
    }
  }
};