/*
battleMETAL 
Author: Peter Roohr
Date: 10/26/2020
Overview: 
  Ferris Bueller: what are you all still doing here? movies over...
    we're in overtime.
    
    nodegraph impl to get the bots to move very well.
*/


void(float nodeId, vector org, string edgeDat) nodegraph_read_new_node={
  
  local float arrIdx;
  
  local string edgeString;
  local float edgetokens;
  local float edgeItr;
  
  local float edgeCount;
  local float edgeNum;
  
  local vector reflectOrg;
  
  local float reflectNode;
  local float reflectEdge;
  
  //node_t theNode;
  nodegraph_get_node_byid( nodeId );
  
  NODE_found.id = nodeId;
  
  reflectOrg = org;
  NODE_found.orig = reflectOrg;
  
  edgeString = edgeDat;
  edgetokens = tokenizebyseparator(edgeString, " ", "-");
  //dprint("EDGE START---------------------------\n"); //debug
  //dprint(strcat("edgetokens: ", ftos(edgetokens), "\n")); //debug
  edgeNum = 0;
  while(edgeNum < 6){
    edgeItr = edgeNum * 2;
    //dprint(strcat("edgeItr(", ftos(edgeItr), ")= ", argv(edgeItr), "\n")); //debug
    //dprint(strcat("edgeItr+1(", ftos(edgeItr+1),")= ", argv(edgeItr+1),"\n")); //debug
    if( edgeItr <= edgetokens - 1 ){
      reflectNode = stof(argv(edgeItr));
      NODE_found.nodes[edgeNum] = reflectNode;
      //dprint(strcat(argv(edgeItr),"\n")); //debug
      
      reflectEdge = stof(argv(edgeItr+1));
      NODE_found.edge[edgeNum] = reflectEdge;
      //dprint(strcat(argv(edgeItr+1),"\n")); //debug
      //dprint(sprintf("NODE_found.nodes[%u]=%f\n", edgeNum, NODE_found.nodes[edgeNum] )); //debug
      //dprint(sprintf("NODE_found.edge[%u]=%f\n", edgeNum, NODE_found.edge[edgeNum] )); //debug
    }
    else{
      NODE_found.nodes[edgeNum] = -1;
      NODE_found.edge[edgeNum] = 0;
    }
    edgeNum = edgeNum + 1;
  }
  //dprint("EDGE END---------------------------\n"); //debug
  
  dprint(strcat(ftos(NODE_found.id),"\n")); //debug
  //dprint(strcat(vtos(NODE_found.orig),"\n")); //debug
  dprint("NODE LOADED---------------------------\n"); //debug
  NODEGRAPH_DATA[nodeId] = NODE_found;
};

//NODEGRAPH API--------------------------------------------------------
/*
  The entry func for the AI to access the nodegraph system.
    They have an end vector they want to get to, and will use the nodegraph to get there.
*/
float( vector start, vector end ) nodegraph_trace_route={
  
  local float bEnd;
  
  local float queue;
  local float queueNext;
  local float currentId;
  
  local float itrEdge;
  local float nextId;
  
  local float visit;
  local float endId;
  
  node_t trace;
  
  nodegraph_clear_search_queue();
  
  nodegraph_node_by_origin(start);
  NODEGRAPH_SEARCH_QUEUE[0] = NODE_found.id;
  NODEGRAPH_SEARCH_CAME_FROM[ NODE_found.id] = NODE_found.id;
  dprint(sprintf("Start org: %f %f %f | nodeid: %u | arr val %u\n", start_x,start_y,start_z, NODE_found.id, NODEGRAPH_SEARCH_QUEUE[0])); //debug
  
  nodegraph_node_by_origin(end);
  endId = NODE_found.id;
  dprint(sprintf("End org: %f %f %f | nodeid: %u\n",end_x,end_y,end_z, NODE_found.id)); //debug
  
  //todo - early exit
  
  bEnd = FALSE;
  queue = 0;
  while( bEnd == FALSE ){
    currentId = NODEGRAPH_SEARCH_QUEUE[queue];
    if( currentId == -1 ){
      bEnd = TRUE;
    }
    else{
      trace = NODEGRAPH_DATA[currentId];
      dprint(sprintf("queue(%u)-node[%u] \n", queue, trace.id)); //debug
      itrEdge = 0;
      while( itrEdge < 6 ){
        nextId = trace.nodes[itrEdge];
        if( nextId != -1 ){
          visit = NODEGRAPH_SEARCH_CAME_FROM[nextId];
          dprint(sprintf("      nextId(%u)\n", nextId )); //debug
          dprint(sprintf("      visit(%f)\n", visit )); //debug
          if( visit < 0 ){
            queueNext = queueNext + 1;  //error: something to do with iterating queueNext;
            NODEGRAPH_SEARCH_QUEUE[queueNext] = nextId;
            NODEGRAPH_SEARCH_CAME_FROM[nextId] = currentId;
            dprint(sprintf("             queueNext(%u)-nextId(%u)<-currentId{%f}\n", queueNext, NODEGRAPH_SEARCH_QUEUE[queueNext], NODEGRAPH_SEARCH_CAME_FROM[nextId] )); //debug
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
      dprint("-------------------------\n"); //debug
    }
  }
  
  return queue;
};

/**

*/
void( float startNode, float endArrIdx, float endNodeId ) nodegraph_build_path={
  
  local float stack;
  local float endId;
  local float pathId;
  local float reflectPath;
  
  dprint(sprintf("nodegraph_build_path( startNode[%u], endArrIdx[%u], endNodeId[%u] )\n", startNode, endArrIdx, endNodeId));  //debug
  stack = 0;
  dprint("NODEGRAPH_SEARCH_CAME_FROM[] integrity check\n"); //debug
  while( stack < NODE_ID_COUNT ){
    dprint(sprintf("itr[%u]-node(%d)\n", stack, NODEGRAPH_SEARCH_CAME_FROM[stack]));
    stack = stack + 1;
  }
  dprint("============================\n"); //debug
  
  stack = 0;
  reflectPath = 0;
  pathId = endNodeId;
  dprint(sprintf("===BULDING PATH===stack{%u}\n", stack));  //debug
  while( pathId != startNode ){
    NODEGRAPH_SEARCH_PATH[stack] = pathId;
      dprint(sprintf("    itr[%u]-node(%d)\n", stack, pathId));
    reflectPath = pathId;
    
    pathId = NODEGRAPH_SEARCH_CAME_FROM[reflectPath];
      dprint(sprintf("            cameFrom(%d)\n", pathId));
    
    stack = stack + 1;
      dprint("-------------------------\n"); //debug
  }
  
  dprint("===Unwinding path stack\n");  //debug
  while( stack >= 0 ){
    dprint(sprintf("    itr[%u]-node(%d)\n", stack, NODEGRAPH_SEARCH_PATH[stack]));
    stack = stack - 1;
  }
  dprint("============================\n"); //debug
};


/**
  Runs a 0 - index scan of NODEGRAPH_SEARCH_QUEUE[] to see if we've already been at this node
*/
float( float thisId, float newId ) nodegraph_check_visited={
  
  local float bVal;
  local float iitr;
  
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
  Clear the search queue
*/
void() nodegraph_clear_search_queue={
  local float queueCount;
  
  for(queueCount = 0; queueCount < NODE_ID_COUNT; queueCount = queueCount + 1){
    NODEGRAPH_SEARCH_QUEUE[queueCount] = -1;
    NODEGRAPH_SEARCH_CAME_FROM[queueCount] = -1;
    NODEGRAPH_SEARCH_PATH[queueCount] = -1;
  }
};

vector( float nodeId ) nodegraph_get_node_origin={
  local float itr;
  local vector foundOrg;
  
  itr = 0;
  
  while( itr < NODE_ID_COUNT ){
    NODE_check = NODEGRAPH_DATA[itr];
    if( NODE_check.id < 0 ){
      continue;
    }
    if( NODE_check.id == nodeId ){
      foundOrg = NODE_check.orig;
      break;
    }
    itr = itr + 1;
  }
  return foundOrg;
};

/*
  Search nodegraph via origin, and sets the node_t globals CHECK and FOUND
*/
void( vector org ) nodegraph_node_by_origin={
  local float itr;
  local vector checkOrg;
  
  itr = 0;
  while(itr < NODE_ID_COUNT){
    NODE_check = NODEGRAPH_DATA[itr];
    if( NODE_check.id < 0 ){
      continue;
    }
    checkOrg = NODE_check.orig;
    if( checkOrg == org ){
      NODE_found = NODE_check;
    }
    itr = itr + 1;
  }
};


/*
  Search nodegraph via nodeid, and sets the node_t globals CHECK and FOUND
*/
void( float nodeId ) nodegraph_get_node_byid={
  if( nodeId > -1 ){
    NODE_check = NODEGRAPH_DATA[nodeId];
    dprint(strcat("nodegraph_get_node_byid(",ftos(nodeId),")-(", ftos(NODE_check.id),")\n"));  //debug
  }
};

//NODEGRAPH debugger--------------------------------------------------------
/*
  An entity that 'walks' the entire node graph
*/
void() nodegraph_debugger_th_node={

  self.think = nodegraph_debugger_th_node;
  self.nextthink = time + 1;
};

void() nodegraph_debugger_th_edge={

  self.think = nodegraph_debugger_th_edge;
  self.nextthink = time + 1.25;
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
  
  nodegraph_debugger = spawn();
  nodegraph_debugger.classname = strzone("nodegraph_debugger");
  setmodel(nodegraph_debugger, "q3mdl/testball.md3");
  setsize(nodegraph_debugger, nodegraph_debugger.mins, nodegraph_debugger.maxs);
  setorigin(nodegraph_debugger, world.origin);
  
  edgeTotal = nodegraph_trace_route( src, dst );
  
  nodegraph_node_by_origin(dst);
  enId = NODE_found.id;
  
  nodegraph_node_by_origin(src);
  strId = NODE_found.id;
  
  nodegraph_build_path( strId, edgeTotal, enId );
  

};
//--------------