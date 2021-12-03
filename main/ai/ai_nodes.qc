/*
battleMETAL 
Author: Peter Roohr
10/29/2020 - nodegraph
Overview: ai nodes
  all the various nodes needed for the game
*/

//NODEGRAPH API-----------------------------------
//simple, clears out entire path, used generally when bot spawns,
//because values MUST be -1; (nodeID 0 is a valid ID).
void() ai_nodegraph_clear_path={
  self.nq1 = -1;
  self.nq2 = -1;
  self.nq3 = -1;
  self.nq4 = -1;
  self.nq5 = -1;
  self.nq6 = -1;
  self.nq7 = -1;
  self.nq8 = -1;
  self.nq9 = -1;
  self.nq10 = -1;
  self.nq11 = -1;
  self.nq12 = -1;
  self.nq13 = -1;
  self.nq14 = -1;
  self.nq15 = -1;
  self.nq16 = -1;
  self.nq17 = -1;
  self.nq18 = -1;
  self.nq19 = -1;
  self.nq20 = -1;
  self.nq21 = -1;
  self.nq22 = -1;
  self.nq23 = -1;
  self.nq24 = -1;
};

/*
  makes sure to clear any lingering node block flags
*/
void() ai_nodegraph_clear_locks={
  local float nodeItr;
  
  while( nodeItr < NODE_ID_COUNT ){
    if( NODEGRAPH_DATA_BLOCK[nodeItr] == self.entnum ){
      if( nodeItr != self.nqLast ){
        NODEGRAPH_DATA_BLOCK[nodeItr] = FALSE;
      }
    }
    nodeItr = nodeItr + 1;
  }
};

/*
  AI spawn edge-case.
  Assists mappers when placing AI, it scans for the closest node to the AI when the AI spawns in.
  
  IF that node is too close (128 units or less) AND the node is not blocked by another ent, mark it as blocked.
  
  This way, bots have a better idea of the nodegraph state as they spawn in, allowing moving bots to know
  if a just-ini'd bot is in the way.
*/
void() ai_nodegraph_mark_start={
  local float nodeItr;
  local float nodeDist;
  local float foundNode;
  local float testLen;
  
  node_t proxNode;
  nodeDist = 64;
  foundNode = -1;
  
  for( nodeItr = 0; nodeItr < NODE_ID_COUNT; nodeItr = nodeItr + 1){
    proxNode = NODEGRAPH_DATA[nodeItr];
    if( proxNode.id == -1 ){
      continue;
    }
    testLen = ai_check_dist_node( self.origin, proxNode.orig );
    if( testLen > nodeDist ){
      continue;
    }
    if( NODEGRAPH_DATA_BLOCK[nodeItr] == FALSE ){
      continue;
    }
    nodeDist = testLen;
    foundNode = nodeItr;
  }
  if( foundNode > -1 ){
    //mark as blocked, set nq1 reference to node id, so that it will be cleared when the AI calls their trace_route for the first time.
    NODEGRAPH_DATA_BLOCK[nodeItr] = self.entnum;
    self.nqLast = nodeItr;
  }
};

/*
  updates .nodeQueue slots, returns FALSE if there are no nodes left in the path.
*/
float() ai_nodegraph_next={
  
  self.nqLast = self.nq1;
  self.nq1 = self.nq2;
  self.nq2 = self.nq3;
  self.nq3 = self.nq4;
  self.nq4 = self.nq5;
  self.nq5 = self.nq6;
  self.nq6 = self.nq7;
  self.nq7 = self.nq8;
  self.nq8 = self.nq9;
  self.nq9 = self.nq10;
  self.nq10 = self.nq11;
  self.nq11 = self.nq12;
  self.nq12 = self.nq13;
  self.nq13 = self.nq14;
  self.nq14 = self.nq15;
  self.nq15 = self.nq16;
  self.nq16 = self.nq17;
  self.nq17 = self.nq18;
  self.nq18 = self.nq19;
  self.nq19 = self.nq20;
  self.nq20 = self.nq21;
  self.nq21 = self.nq22;
  self.nq22 = self.nq23;
  self.nq23 = self.nq24;
  self.nq24 = -1;
  
  if( self.nq1 == -1 ){
    //end of queue
    return FALSE;
  }
  
  if( NODEGRAPH_DATA_BLOCK[self.nq1] > FALSE && NODEGRAPH_DATA_BLOCK[self.nq1] != self.entnum ){
    //requested next node was occupied by someone else.
    return FALSE;
  }
  
  //simple safety check
  if( self.nqLast != -1 ){
    NODEGRAPH_DATA_BLOCK[self.nqLast] = self.entnum;
  }
  
  NODEGRAPH_DATA_BLOCK[self.nq1] = self.entnum;
  
  return TRUE;
};


/*
  To reduce traffic jams further, self.nqLast holds the lock on THE
    last node an AI visited. 
    
  This function, run every nodegraph frame, we check to see if the AI is a good enough distance
  from the last node, if they are, clear the lock, otherwise the lock is held.
*/
void() ai_nodegraph_check_lastnode={
  local vector lastNodeOrg;
  local float lastNodeDist;
  
  lastNodeOrg = nodegraph_get_node_origin( self.nqLast );
  lastNodeDist = ai_check_dist_node(self.origin, lastNodeOrg);
  
  if( lastNodeDist > 64 ){
    NODEGRAPH_DATA_BLOCK[self.nqLast] = FALSE;
    self.nqLast = -1;
  }
};

/*
  ai_nodegraph_trace_vec_route() is the core tracing func for the AI.
  
  generally maintain 1 func that calls most of the nodegraph stuff to keep func jumps low.
    Its advised that you wrap nodegraph_trace() with other functions though, which
    is more maintainable.
*/
float( float startId, float endId ) ai_nodegraph_trace_route={
  
  local float traceEndId;
  local float pathCnt;
  
  ai_nodegraph_clear_locks();
  
  if( startId == -1 ){
    return FALSE;
  }
  
  if( endId == -1 ){
    return FALSE;
  }
  
  traceEndId = nodegraph_trace(startId, endId);
  if( traceEndId > -1 ){
    pathCnt = nodegraph_build_path( startId, traceEndId );
    if( pathCnt > -1 ){
      self.pathEndId = NODEGRAPH_SEARCH_PATH[0];  //set the end node so we can remember the end if we need to.
      
      ai_nodegraph_clear_path();
      
      pathCnt = ai_nodegraph_set_queue_val( nq1, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq2, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq3, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq4, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq5, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq6, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq7, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq8, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq9, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq10, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq11, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq12, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq13, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq14, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq15, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq16, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq17, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq18, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq19, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq20, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq21, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq22, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq23, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq24, pathCnt );
      
      if( self.nq1 > -1 ){
        return TRUE;
      }
    }
  }
  
  return FALSE;
};

float( .float queueVar, float pathCountVal ) ai_nodegraph_set_queue_val={
  if( -1 < pathCountVal ){
    self.queueVar = NODEGRAPH_SEARCH_PATH[pathCountVal];
    return pathCountVal - 1;
  }
  return -1;
};

float( float nodeStartId, float nodeEndId ) ai_nodegraph_trace_norm={
  local float traceStat;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  traceStat = ai_nodegraph_trace_route( nodeStartId, nodeEndId );
  
  return traceStat;
};

/*
  Wraps ai_nodegraph_trace_route() by allowing VECTOR input
*/
float( vector startPos, vector endPos ) ai_nodegraph_trace_vec={
  
  local float traceStat;
  local float startNode;
  local float endNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  startNode = ai_nodegraph_to_org( startPos, TRUE );
  endNode = ai_nodegraph_to_org( endPos, TRUE );
  
  traceStat = ai_nodegraph_trace_route( startNode, endNode );
  
  return traceStat;
};

/*
  Wraps ai_nodegraph_trace_route() by allowing VECTOR input for src, but you know the endId
*/
float( vector startPos, float endId ) ai_nodegraph_trace_vecToNode={
  
  local float traceStat;
  local float startNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  startNode = ai_nodegraph_to_org( startPos, TRUE );
  
  traceStat = ai_nodegraph_trace_route( startNode, endId );
  
  return traceStat;
};
//given a known endId, and a map org

/*
  Wraps ai_nodegraph_trace_route() by allowing NODE ID input for start, and you want to find closest node to a map position.
*/
float( float startId, vector endPos ) ai_nodegraph_trace_nodeToVec={
  
  local float traceStat;
  local float endNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  endNode = ai_nodegraph_to_org( endPos, TRUE );
  
  traceStat = ai_nodegraph_trace_route( startId, endNode );
  
  return traceStat;
};

/*
  Find closest node to a desire map point (usually self, or target ai_node).
  Make sure that node is WALKABLE to that spot.
*/
float( vector testOrg, float checkLock ) ai_nodegraph_to_org={

  local float minDist;
  local float nodeItr;
  
  node_t closeNode;
  
  local float aNode;
  
  local vector ndOrg;
  local float testDist;
  local float testVis;
  
  aNode = -1;
  minDist = 1024;
  for( nodeItr = 0; nodeItr < NODE_ID_COUNT; nodeItr = nodeItr + 1){
    closeNode = NODEGRAPH_DATA[nodeItr];
    
    if( closeNode.id == -1 ){
      continue;
    }
    
    if( checkLock ){
      if( NODEGRAPH_DATA_BLOCK[nodeItr] > FALSE && NODEGRAPH_DATA_BLOCK[nodeItr] != self.entnum ){
        continue;
      }
    }
    
    ndOrg = closeNode.orig;
    testDist = ai_check_dist_node(testOrg, ndOrg);
    if( testDist > minDist ){
      continue;
    }
    
    testVis = ai_check_terrain_move( testOrg, ndOrg ); 
    if( !testVis ){
      continue;
    }
    
    minDist = testDist;
    aNode = nodeItr;
  }
  return aNode;
};

float( vector testOrg , float ignoreId, float checkLock ) ai_nodegraph_to_org_filter={
    local float minDist;
  local float nodeItr;
  
  node_t closeNode;
  
  local float aNode;
  
  local vector ndOrg;
  local float testDist;
  local float testVis;
  
  aNode = -1;
  minDist = 1024;
  for( nodeItr = 0; nodeItr < NODE_ID_COUNT; nodeItr = nodeItr + 1){
    closeNode = NODEGRAPH_DATA[nodeItr];
    
    if( closeNode.id == -1 ){
      continue;
    }
    
    if( ignoreId != -1 && closeNode.id == ignoreId ){
      continue;
    }
    
    if( checkLock ){
      if( NODEGRAPH_DATA_BLOCK[nodeItr] > FALSE && NODEGRAPH_DATA_BLOCK[nodeItr] != self.entnum ){
        continue;
      }
    }
    
    ndOrg = closeNode.orig;
    testDist = ai_check_dist_node(testOrg, ndOrg);
    if( testDist > minDist ){
      continue;
    }
    
    testVis = ai_check_terrain_move( testOrg, ndOrg ); 
    if( !testVis ){
      continue;
    }
    
    minDist = testDist;
    aNode = nodeItr;
  }
  return aNode;
};

void() ai_nodegraph_debug_queue={

  dprint("*****************NODE QUEUE THIS FRAME ************************\n");  //debug
  dprint(sprintf("------------%s-------------------\n", self.classname));  //debug
  dprint(sprintf("    nq1 = %s\n", ftos(self.nq1)));  //debug
  dprint(sprintf("    nq2 = %s\n", ftos(self.nq2)));  //debug
  dprint(sprintf("    nq3 = %s\n", ftos(self.nq3)));  //debug
  dprint(sprintf("    nq4 = %s\n", ftos(self.nq4)));  //debug
  dprint(sprintf("    nq5 = %s\n", ftos(self.nq5)));  //debug
  dprint(sprintf("    nq6 = %s\n", ftos(self.nq6)));  //debug
  dprint(sprintf("    nq7 = %s\n", ftos(self.nq7)));  //debug
  dprint(sprintf("    nq8 = %s\n", ftos(self.nq8)));  //debug
  dprint(sprintf("    nq9 = %s\n", ftos(self.nq9)));  //debug
  dprint(sprintf("    nq10 = %s\n", ftos(self.nq10)));  //debug
  dprint(sprintf("    nq11 = %s\n", ftos(self.nq11)));  //debug
  dprint(sprintf("    nq12 = %s\n", ftos(self.nq12)));  //debug
  dprint(sprintf("    nq13 = %s\n", ftos(self.nq13)));  //debug
  dprint(sprintf("    nq14 = %s\n", ftos(self.nq14)));  //debug
  dprint(sprintf("    nq15 = %s\n", ftos(self.nq15)));  //debug
  dprint(sprintf("    nq16 = %s\n", ftos(self.nq16)));  //debug
  dprint(sprintf("    nq17 = %s\n", ftos(self.nq17)));  //debug
  dprint(sprintf("    nq18 = %s\n", ftos(self.nq18)));  //debug
  dprint(sprintf("    nq19 = %s\n", ftos(self.nq19)));  //debug
  dprint(sprintf("    nq20 = %s\n", ftos(self.nq20)));  //debug
  dprint(sprintf("    nq21 = %s\n", ftos(self.nq21)));  //debug
  dprint(sprintf("    nq22 = %s\n", ftos(self.nq22)));  //debug
  dprint(sprintf("    nq23 = %s\n", ftos(self.nq23)));  //debug
  dprint(sprintf("    nq24 = %s\n", ftos(self.nq24)));  //debug
  dprint("*****************************************\n");  //debug

};