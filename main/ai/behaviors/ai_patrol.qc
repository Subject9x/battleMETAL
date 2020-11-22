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
  local float nextDist;
    
  /*
    note: ai_node entities are now mostly just 'meta' entities, the AI does not directly path to the
      entity itself, rather; the AI locates the nearest NODEGRAPH node to the patrolNode.
      
      the patrolNode itself also holds the closest NODEGRAPH node ID as well.
  */
  nqOrg = nodegraph_get_node_origin( self.patrolNode.pathEndId );
  nodeDist = ai_check_dist_node(self.origin, nqOrg);
   
  if( nodeDist <= 16 ){
    //dprint(sprintf("[%s]( %0.2f %0.2f %0.2f) :: ai_nodegraph_patrol_frame()  - patrol node %s\n", self.classname, self.origin_x, self.origin_y, self.origin_z, self.patrolNode.targetname));  //debug
    //arrived at node.
    if( self.patrolNode.partNext ){
      //set the next node if it exists
      self.patrolNode = self.patrolNode.partNext;
      ai_nodegraph_clear_path();
    }
    else{
      //we're at the end, shut it all down.
      self.tether = TETHER_NONE;
      self.moveState = MOVE_STAND;
      pathFind = ai_nodegraph_to_org_filter( self.origin , self.patrolNode.pathEndId );
      if( pathFind != -1 ){
        
        ai_nodegraph_trace_vecToNode( self.origin, pathFind );
      }
      else{
        //ai_nodegraph_clear_locks();
      }
      self.patrolNode = world;
      return;
    }
  }
  else{
    //check if we're actually closer to the NEXT node
    if( self.patrolNode.partNext ){
    
      nqOrg = nodegraph_get_node_origin( self.patrolNode.partNext.pathEndId );
      nextDist = ai_check_dist_node(self.origin, nqOrg);    
      if( nextDist <= nodeDist ){
        self.patrolNode = self.patrolNode.partNext;
        pathFind = ai_nodegraph_to_org_filter( self.origin , self.patrolNode.pathEndId );
        ai_nodegraph_trace_vecToNode( self.origin, pathFind );
        return;
      }
    }
  }
  //-----------------
  //run the nodegraph frame on the current trace path.
  
  ai_nodegraph_frame( self.patrolNode.compOffset, self.patrolNode.compOffset, self.data_speed_strafe, self.data_speed_forward * 0.75 );
  
};

