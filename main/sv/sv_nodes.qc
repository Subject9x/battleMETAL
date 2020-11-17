/*
battleMETAL 
Author: Peter Roohr
Date: 10/26/2020
Overview: 
  Ferris Bueller: what are you all still doing here? movies over...
    we're in overtime.
    
    nodegraph impl to get the bots to move very well.
*/


void(float dataNodeId, vector dataOrg ) nodegraph_read_new_node={
  local vector reflectOrg;
  
  local float reflectNode;
  local float reflectEdge;
  
  node_t nodeData;
  //node_t checkData;
  
  //nodeData = NODE_found;
  nodeData.id = dataNodeId;
  
  reflectOrg = dataOrg;
  nodeData.orig = reflectOrg;
  
  NODEGRAPH_DATA[dataNodeId] = nodeData;
  //checkData = NODEGRAPH_DATA[dataNodeId];
  //dprint("NODE LOADED---------------------------\n"); //debug
  //dprint(strcat(ftos(checkData.id),"\n")); //debug
  //dprint(strcat(vtos(checkData.orig),"\n")); //debug
  //dprint("--------------------------------------\n"); //debug
};

void( float dataNodeId, float edgeNum, float edgeId, float lenVal ) nodegraph_read_edge={
  
  node_t nodeData;
  
  nodeData = NODEGRAPH_DATA[dataNodeId];
  if( nodeData.id != -1 ){
    nodeData.nodes[edgeNum] = edgeId;
    nodeData.edge[edgeNum] = lenVal;
    NODEGRAPH_DATA[dataNodeId] = nodeData;  //!pass by value! 
    //dprint(sprintf("dataNodeId{%0.0f} | edgeNum(%0.0f) | edgeId[%0.0f] | lenVal[%0.3f]\n", dataNodeId, edgeNum, edgeId, lenVal));
  }
};


//NODEGRAPH API--------------------------------------------------------
/*
  the core trace, takes a start nodeID and end nodeID, runs the pathfinding algorithm
  and returns the nodeId of the first node that the bot needs to go to.
  
*/
float( float startId, float endId ) nodegraph_trace={
  
  local float bEnd;
  local vector vStart;
  local vector vEnd;
  
  local float queue;
  local float queueNext;
  local float currentId;
  
  //local float moveCost;
  local float itrEdge;
  local float nextId;
  
  local float visit;
  
  node_t trace;
  
  nodegraph_clear_search_queue();
  
  NODEGRAPH_SEARCH_QUEUE[0] = startId;
  NODEGRAPH_SEARCH_CAME_FROM[startId] = startId;
  //NODEGRAPH_SEARCH_COST[NODE_found.id] = 0;
  
  vStart = nodegraph_get_node_origin( startId );
  vEnd = nodegraph_get_node_origin( endId );
  
  //dprint(sprintf("Start org: %f %f %f | nodeid: %u | arr val %u\n", vStart_x,vStart_y,vStart_z, startId, NODEGRAPH_SEARCH_QUEUE[0])); //debug
  //dprint(sprintf("End org: %f %f %f | nodeid: %u\n",vEnd_x,vEnd_y,vEnd_z, endId)); //debug
  
  bEnd = FALSE;
  queue = 0;
  while( bEnd == FALSE ){
    currentId = NODEGRAPH_SEARCH_QUEUE[queue];
    if( currentId == endId ){
      bEnd = TRUE;  //early exit
    }
    else if( currentId == -1 ){
      bEnd = TRUE;
    }
    else{
      trace = NODEGRAPH_DATA[currentId];
      //dprint(sprintf("queue(%u) :: node[%u] \n", queue, trace.id)); //debug
      itrEdge = 0;
      while( itrEdge < 6 ){
        nextId = trace.nodes[itrEdge];
        if( nextId != -1 ){
          //todo - would be nice to figure out something closer to A*
          //moveCost = NODEGRAPH_SEARCH_COST[currentId] + trace.edge[itrEdge];
          visit = NODEGRAPH_SEARCH_CAME_FROM[nextId];
          //dprint(sprintf("      ->nextId(%u)\n", nextId )); //debug
          //dprint(sprintf("      ->visit(%f)\n", visit )); //debug
          //dprint(sprintf("      current cost(%f)\n", NODEGRAPH_SEARCH_COST[nextId])); //debug
          //dprint(sprintf("      add cost(%f)\n", moveCost )); //debug
          //if( visit < 0 || moveCost < NODEGRAPH_SEARCH_COST[nextId]){
          if( visit < 0 && NODEGRAPH_DATA_BLOCK[nextId] == FALSE){
            queueNext = queueNext + 1;  //error: something to do with iterating queueNext;
            NODEGRAPH_SEARCH_QUEUE[queueNext] = nextId;
            NODEGRAPH_SEARCH_CAME_FROM[nextId] = currentId;
            //NODEGRAPH_SEARCH_COST[nextId] = moveCost;
            //dprint(sprintf("             queueNext(%u) :: nextId(%u) :: <-currentId{%f}\n", queueNext, NODEGRAPH_SEARCH_QUEUE[queueNext], NODEGRAPH_SEARCH_CAME_FROM[nextId] )); //debug
          }
          else{
            //print(sprintf("            XXXXXXXXXXXXXX already visit!-nextId(%f)\n", nextId)); //debug
          }
        }
        else{
          //dprint(sprintf("      nextId(%d)\n", nextId )); //debug
          //dprint(sprintf("             XXXXXXXXXXXXXX NO EDGE-nextId(%f)\n", nextId)); //debug
        }
        itrEdge = itrEdge + 1;
      }
      queue = queue + 1;
      if( queue == NODE_ID_COUNT ){
        bEnd = TRUE;
      }
      //dprint("-------------------------\n"); //debug
    }
  }
  return queue;
};

/*
  Wraps nodegraph_trace() by supplying just the start and end VECTORS. 
*/
float( vector start, vector end ) nodegraph_trace_vec={
  
  local float startNodeId;
  local float endNodeId;
  
  local float path;
  local float dbgItr;
  
  nodegraph_clear_search_queue();
  
  startNodeId = nodegraph_node_by_origin(start);
  endNodeId = nodegraph_node_by_origin(end);
    
  //dprint(sprintf("Start org: %f %f %f | nodeid: %u | arr val %u\n", start_x,start_y,start_z, NODE_found.id, NODEGRAPH_SEARCH_QUEUE[0])); //debug
  //debug
  //while(dbgItr < NODE_ID_COUNT){
  //  dprint(sprintf("node(%0.0f) - block num[%0.0f]\n", dbgItr, NODEGRAPH_DATA_BLOCK[dbgItr]));
  //  dbgItr = dbgItr + 1;
  //}
  if( startNodeId == -1 ){
    return -1;
  }
  
  if( endNodeId == -1 ){
    return -1;
  }
  
  path = nodegraph_trace( startNodeId, endNodeId );
  
  return path;
};

/**
  The trace_route builds a path of GOAL -> START, 
    this verifies the path, and converts the values from CAME_FROM[]
    to the path list.
*/
float( float startNode, float endArrIdx, float endNodeId ) nodegraph_build_path={
  
  local float stack;
  local float endId;
  local float pathId;
  local float reflectPath;
  local float stackTotal;
  local vector dbgOrg;
  
  //dprint(sprintf("nodegraph_build_path( startNode[%u], endArrIdx[%u], endNodeId[%u] )\n", startNode, endArrIdx, endNodeId));  //debug
  stack = 0;
  //dprint("NODEGRAPH_SEARCH_CAME_FROM[] integrity check\n"); //debug
  //while( stack < NODE_ID_COUNT ){
  //  dprint(sprintf("itr[%u]-node(%d)\n", stack, NODEGRAPH_SEARCH_CAME_FROM[stack]));//debug
  //  stack = stack + 1;//debug
  //}//debug
  //dprint("============================\n"); //debug
  
  stack = 0;
  reflectPath = 0;
  pathId = endNodeId;
  //dprint(sprintf("===BULDING PATH===stack{%u}\n", stack));  //debug
  while( pathId != startNode && stack < endArrIdx ){
    NODEGRAPH_SEARCH_PATH[stack] = pathId;
    dbgOrg = nodegraph_get_node_origin(pathId);
     // dprint(sprintf("    itr[%u]-node(%d)-ORIGIN %0.3f %0.3f %0.3f\n", stack, pathId, dbgOrg_x, dbgOrg_y, dbgOrg_z));
    reflectPath = pathId;
    
    pathId = NODEGRAPH_SEARCH_CAME_FROM[reflectPath];
      //dprint(sprintf("            cameFrom(%d)\n", pathId));
    
    stack = stack + 1;
      //dprint("-------------------------\n"); //debug
  }
  
  //dprint("===Unwinding path stack\n");  //debug
  //dprint(sprintf("                stack(%f)\n",stack));  //debug
  stackTotal = stack;
  NODEGRAPH_SEARCH_PATH[stack] = startNode;
  while( stack >= 0 ){
    //dprint(sprintf("    itr[%u]-node(%d)\n", stack, NODEGRAPH_SEARCH_PATH[stack]));
    stack = stack - 1;
  }
  //dprint("============================\n"); //debug
  return stackTotal;
};


/**
  Runs a 0 - index scan of NODEGRAPH_SEARCH_QUEUE[] to see if we've already been at this node
*/
float( float thisId, float newId ) nodegraph_check_visited={
  
  local float bVal;
  
  bVal = NODEGRAPH_SEARCH_CAME_FROM[newId];
  if( bVal != -1 ){
    bVal = TRUE;
  }
  else{
    bVal = FALSE;
  }
  return bVal;
};


/*
  Utility, clear out any lingering nodeId's before the next re-population of the array.
*/
void() nodegraph_clear_search_queue={
  local float queueCount;
  
  for(queueCount = 0; queueCount < NODE_ID_COUNT; queueCount = queueCount + 1){
    NODEGRAPH_SEARCH_QUEUE[queueCount] = -1;
    NODEGRAPH_SEARCH_CAME_FROM[queueCount] = -1;
    //NODEGRAPH_SEARCH_COST[queueCount] = 0;
    NODEGRAPH_SEARCH_PATH[queueCount] = -1;
  }
};

vector( float nodeId ) nodegraph_get_node_origin={
  local vector foundOrg;
  
  node_t testNode;
  
  testNode = NODEGRAPH_DATA[nodeId];
  if(testNode.id > -1){
    foundOrg = testNode.orig;
  }
  else{
    foundOrg = '0 0 0';
  }
  return foundOrg;
};

/*
  Search nodegraph via origin, and sets the node_t globals CHECK and FOUND
*/
float( vector org ) nodegraph_node_by_origin={
  local float itr;
  local vector checkOrg;
  local float foundId;
  
  node_t testNode;
  
  foundId = -1;
  
  itr = 0;
  while(itr < NODE_ID_COUNT){
    testNode = NODEGRAPH_DATA[itr];
    if( testNode.id < 0 ){
      continue;
    }
    checkOrg = testNode.orig;
    if( checkOrg == org ){
      foundId = testNode.id;
    }
    itr = itr + 1;
  }
  
  return foundId;
};


/*
  Search nodegraph via nodeid, and sets the node_t globals CHECK and FOUND
*/
void( float nodeId ) nodegraph_get_node_byid={
  if( nodeId > -1 ){
    NODE_found = NODEGRAPH_DATA[nodeId];
    //dprint(strcat("nodegraph_get_node_byid(",ftos(nodeId),")-(", ftos(NODE_check.id),")\n"));  //debug
  }
};

//NODEGRAPH debugger--------------------------------------------------------
//call via console "cmd m dbgnode X Y" 
                                //X = 
/*
  An entity that 'walks' the entire node graph, going from node-to-node every .think
*/
void() nodegraph_debugger_th_node={
  local float nd;
  local float nd2;
  
  if( nodegraph_debugger.count < 0 ){
    dprint("NODEGRAPH_DEBUGGER complete\n");  
    self.think = SUB_Remove;
    self.nextthink = time + 1;
    return;
  }
  
  nd = NODEGRAPH_SEARCH_PATH[nodegraph_debugger.count];
  
  nodegraph_debugger.count = nodegraph_debugger.count - 1;
  
  if( nodegraph_debugger.count < 0 ){
    dprint("NODEGRAPH_DEBUGGER complete\n");  
    self.think = SUB_Remove;
    self.nextthink = time + 1;
    return;
  }
  
  nd2 = NODEGRAPH_SEARCH_PATH[nodegraph_debugger.count];
  
  nodegraph_debugger.origin = nodegraph_get_node_origin(nd);
  nodegraph_debugger.compOffset = nodegraph_get_node_origin(nd2);

  self.data_lifetime = time + 4;
  self.think = nodegraph_debugger_th_edge;
  self.nextthink = time + 0.1;
};

void() nodegraph_debugger_th_edge={

  if( time > self.data_lifetime ){
    self.think = nodegraph_debugger_th_node;
    self.nextthink = time + 0.1;
    return;
  }
  trailparticles(self, particleeffectnum("TE_LAS_RAIL"), self.origin, self.compOffset);

  self.think = nodegraph_debugger_th_edge;
  self.nextthink = time + 0.1;
};

/*
  given a starting origin, and a destination origin,
    run the graph debugger to see if the algo works,
      the data works,
        and the node setup works.
*/
void( vector src, vector dst ) nodegraph_debug_graph={
  local float strId;
  local float enId;
  local float edgeTotal;
  local float pathCnt;
  
  local float startNodeId;
  local float endNodeId;
  
  local entity t;
  
  nodegraph_debugger = spawn();
  nodegraph_debugger.classname = strzone("nodegraph_debugger");
  setmodel(nodegraph_debugger, "q3mdl/testball.md3");
  setsize(nodegraph_debugger, nodegraph_debugger.mins, nodegraph_debugger.maxs);
  setorigin(nodegraph_debugger, world.origin);
  
  edgeTotal = nodegraph_trace_vec( src, dst );
  
  startNodeId = nodegraph_node_by_origin(dst);
  
  endNodeId = nodegraph_node_by_origin(src);
  
  pathCnt = nodegraph_build_path( startNodeId, edgeTotal, endNodeId );
  
  dprint(sprintf("debugger pathCnt %f", pathCnt));  //debug
  
  nodegraph_debugger.count = pathCnt;
  
  //freeze out everyone else
  for( t = nextent(world); t != world; t = nextent(t) ){
    if( !(t.flags & FL_UNIT) ){
      continue;
    }
    if( !ai_valid_target(t) ){
      continue;
    }
    if( (t.spawnflags & DEBUG_MODE) ){
      continue;
    }
    t.solid = SOLID_NOT;
    t.movetype = MOVETYPE_NONE;
    t.spawnflags = t.spawnflags | DEBUG_MODE;
  }
  
  nodegraph_debugger.think = nodegraph_debugger_th_node;
  nodegraph_debugger.nextthink = time + 1;
};
//--------------