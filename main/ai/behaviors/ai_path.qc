/*
battleMETAL 
Author: Peter Roohr
Date: 10/29/2020
Overview: 
  special state for using the nodegraph system
*/

/*
  ST_NODEGRAPH = 15;
*/
void() ai_state_nodegraph={
  if(self.ai_state == ST_NODEGRAPH &&  self.ai_state_last != ST_NODEGRAPH ){
    dprint(sprintf("path 1: %f\n", self.nq1));
    dprint(sprintf("path 2: %f\n", self.nq2));
    dprint(sprintf("path 3: %f\n", self.nq3));
    dprint(sprintf("path 4: %f\n", self.nq4));
    dprint(sprintf("path 5: %f\n", self.nq5));
    dprint(sprintf("path 6: %f\n", self.nq6));
    dprint(sprintf("path 7: %f\n", self.nq7));
    dprint(sprintf("path 8: %f\n", self.nq8));
    dprint(sprintf("path 9: %f\n", self.nq9));
    dprint(sprintf("path 10: %f\n", self.nq10));
    dprint(sprintf("path 11: %f\n", self.nq11));
    dprint(sprintf("path 12: %f\n", self.nq12));
    dprint(sprintf("path 13: %f\n", self.nq13));
    dprint(sprintf("path 14: %f\n", self.nq14));
    dprint(sprintf("path 15: %f\n", self.nq15));
    dprint(sprintf("path 16: %f\n", self.nq16));
    
    self.ai_state_next = ST_NODEGRAPH_MOVE;
    return;
  }
};

/*
  ST_NODEGRAPH_PAUSE = 16
*/
void() ai_state_nodegraph_pause={
  if(self.ai_state == ST_NODEGRAPH_PAUSE &&  self.ai_state_last != ST_NODEGRAPH_PAUSE ){
  
    return;
  }
};

/*
  ST_NODEGRAPH_MOVE = 17
*/
void() ai_state_nodegraph_travel={
  local float dist;
  local float walkSpeed;
  local vector nqOrg;
  local float turnSpeed;
  local float pathFind;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.moveState = MOVE_NORM;
  
  ai_update_accuracy( TRUE );
  if(self.ai_state == ST_NODEGRAPH_MOVE &&  self.ai_state_last != ST_NODEGRAPH_MOVE ){
    if( (self.flags & FL_TURRET) ){
      self.torsoCenter.attack_state = TR_NORM;
    }
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
    }
    //return; - make the state-ini seamless by processing node movement on the first tic as well.
  }
  
  if( self.ai_state_save == ST_COMBAT ){
    if( !ai_valid_target(self.enemy) ){
      //was in combat, had a target, now we don't.
      self.ai_state_next = ST_COMBAT;
      return;
    }
  }
  
  if( self.nq1 == -1){
    dprint("ai_state_nodegraph_travel() nq1 == -1!\n");  //debug
    return;
  }
  
  nqOrg = nodegraph_get_node_origin( self.nq1 );
  //dprint(sprintf("curret node: %f\n", self.nq1));
  //dprint(sprintf("curret origin: %f %f %f\n", nqOrg_x, nqOrg_y, nqOrg_z));
  if( vectoyaw(nqOrg - self.origin) != self.angles_y ){
    self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
    yawCache = self.yaw_speed;
    self.yaw_speed = self.yaw_speed * 2;
    ChangeYaw();  //double 
    self.yaw_speed = yawCache;
    turnSpeed = TRUE;
  }
  
  dist = vlen(nqOrg - self.origin);
  
  if( dist >= 128 ){
    if( NODEGRAPH_DATA_BLOCK[self.nq1] == num_for_edict(self) ){
      NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
    }
  }
  
  if( dist <= 64 ){
    if( NODEGRAPH_DATA_BLOCK[self.nq1] == FALSE ){
      NODEGRAPH_DATA_BLOCK[self.nq1] = num_for_edict(self);
    }
  }
  if( dist <= 48 ){
    //arriving at path node
    if( self.nq2 == -1 ){
      //completed pathfinding?
      if( self.nq1 == self.pathEndId){
        if( self.tether == TETHER_PATROL || self.tether == TETHER_NODE){
          if( ai_check_terrain_move(self.origin, self.patrolNode.origin) ){
            if( self.tether == TETHER_PATROL ){
              self.ai_state_next = ST_PTR;
            }
            else{
              self.ai_state_next = ST_THR;
            }
            if( NODEGRAPH_DATA_BLOCK[self.nq1] != FALSE ){
              NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
            }
            dprint("travel complete back to patrol \n");  //debug
            return;
          }
        }
      }
      else{
        //can't get path? ok, maybe the original path was > queue size
        dprint("AI - failed to see patrol node, pathfinding!\n");
        pathFind = ai_nodegraph_trace_vecToNode( self.origin, self.pathEndId );
        if( pathFind ){
          self.ai_state_next = ST_NODEGRAPH;
          return;
        }
      }
    }
    else{
      //still in the pathfinding
      if( ai_nodegraph_next() ){
        dprint(sprintf("path next: %f\n", self.nq2));
      }
    }
  }
  
  //not at node yet, keep moving.
  if( turnSpeed ){
    walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 3;
  }
  else{
    walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 2;
  }
  if( walkmove(self.angles_y, walkSpeed) == FALSE ){
    dprint("TODO blocked in ai_state_nodegraph_travel() \n");  //debug
  }
};

/*
  ST_NODEGRAPH_BLOCK = 18
*/
void() ai_state_nodegraph_travel_block={
  if(self.ai_state == ST_NODEGRAPH_BLOCK &&  self.ai_state_last != ST_NODEGRAPH_BLOCK ){
  
    return;
  }


};
