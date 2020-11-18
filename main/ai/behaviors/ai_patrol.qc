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
  local vector nqOrg;
  local float nodeDist;
  local float nodeYaw;
  local float moveSpeed;
  local float turnFlag;
  local float moveYaw;
    
  /*
    note: ai_node entities are now mostly just 'meta' entities, the AI does not directly path to the
      entity itself, rather; the AI locates the nearest NODEGRAPH node to the patrolNode.
      
      the patrolNode itself also holds the closest NODEGRAPH node ID as well.
  */
  nqOrg = nodegraph_get_node_origin( self.patrolNode.pathEndId );
  nodeDist = ai_check_dist_node(self.origin, nqOrg);
  if( nodeDist <= 16 ){
    dprint(sprintf("[%s]( %0.2f %0.2f %0.2f) :: ai_nodegraph_patrol_frame()  - patrol node %s\n", self.classname, self.origin_x, self.origin_y, self.origin_z, self.patrolNode.targetname));  //debug
    //arrived at node.
    ai_nodegraph_clear_path();
    ai_nodegraph_clear_locks();
    if( self.patrolNode.partNext ){
      //set the next node if it exists
      self.patrolNode = self.patrolNode.partNext;
      ai_nodegraph_trace_vecToNode( self.origin, self.patrolNode.pathEndId );
    }
    else{
      //we're at the end, shut it all down.
      self.tether = TETHER_NONE;
      self.moveState = MOVE_STAND;
    }
    return;
  }
  //-----------------
  ai_nodegraph_frame( self.patrolNode.origin, self.patrolNode.origin, self.data_speed_strafe, self.data_speed_forward * 0.75 );
  
};

