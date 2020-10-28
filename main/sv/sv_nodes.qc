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
  
  node_t theNode;;
  
  theNode.id = nodeId;
  
  reflectOrg = org;
  theNode.orig = reflectOrg;
  
  edgeString = edgeDat;
  edgetokens = tokenizebyseparator(edgeString, " ", "-");
  //dprint("EDGE START---------------------------\n"); //debug
  //dprint(strcat("edgetokens: ", ftos(edgetokens), "\n")); //debug
  for(edgeNum = 0; edgeNum < 6; edgeNum = edgeNum + 1){
    edgeItr = edgeNum * 2;
    //dprint(strcat("edgeItr(", ftos(edgeItr), ")= ", argv(edgeItr), "\n")); //debug
    //dprint(strcat("edgeItr+1(", ftos(edgeItr+1),")= ", argv(edgeItr+1),"\n")); //debug
    if( edgeItr <= edgetokens ){
      reflectNode = stof(argv(edgeItr));
      theNode.nodes[edgeNum] = reflectNode;
      //dprint(strcat(argv(edgeItr),"\n")); //debug
      
      reflectEdge = stof(argv(edgeItr+1));
      theNode.edge[edgeNum] = reflectEdge;
      //dprint(strcat(argv(edgeItr+1),"\n")); //debug
    }
    else{
      theNode.nodes[edgeNum] = -1;
      theNode.edge[edgeNum] = 0;
    }
  }
  //dprint("EDGE END---------------------------\n"); //debug
  
  dprint(strcat(ftos(theNode.id),"\n")); //debug
  //dprint(strcat(vtos(theNode.orig),"\n")); //debug
  dprint("NODE LOADED---------------------------\n"); //debug
  NODEGRAPH_DATA[nodeId] = theNode;
};

//NODEGRAPH API--------------------------------------------------------
/*
  The entry func for the AI to access the nodegraph system.
    They have an end vector they want to get to, and will use the nodegraph to get there.
*/
void( vector start, vector end ) nodegraph_trace_route={
  
  local float bEnd;
  
  local float frontier;
  local float frontNext;
  local float currentId;
  
  local float edgeItr;
  local float nextId;
  
  local float visit;
  
  node_t trace;
  
  nodegraph_clear_search_queue();
  
  nodegraph_node_by_origin(end);
  dprint(sprintf("End org: %f %f %f | nodeid: %u\n",end_x,end_y,end_z, NODE_found.id)); //debug
  
  NODE_found = trace;
  
  nodegraph_node_by_origin(start);
  NODEGRAPH_SEARCH_QUEUE[0] = NODE_found.id;
  dprint(sprintf("Start org: %f %f %f | nodeid: %u\n", start_x,start_y,start_z, NODE_found.id)); //debug
  
  bEnd = FALSE;
  frontier = 0;
  //nodegraph_check_visited( index, id);
  while( bEnd == FALSE ){
    currentId = NODEGRAPH_SEARCH_QUEUE[frontier];
    if( currentId < 0 ){
      bEnd = TRUE;
    }
    else{
      trace = NODEGRAPH_DATA[currentId];
      dprint(sprintf("frontier(%u)-node[%u] \n", frontier, trace.id)); //debug
      edgeItr = 0;
      frontNext = frontier;
      while( edgeItr < 6 ){
        nextId = trace.nodes[edgeItr];
        if( nextId > -1 ){
          if( nodegraph_check_visited(currentId, nextId) == FALSE ){
            if( frontNext < NODE_ID_COUNT - 1 ){
              frontNext = frontNext + 1;
              NODEGRAPH_SEARCH_QUEUE[frontNext] = nextId;
              NODEGRAPH_SEARCH_CAME_FROM[nextId] = currentId;
              dprint(sprintf("             frontNext(%u)-nextId(%u)<-currentId{%u}\n", frontNext, nextId, currentId )); //debug
            }
            else{
              bEnd = TRUE;
            }
          }
        }
        edgeItr = edgeItr + 1;
      }
      frontier = frontier + 1;
      if( frontier >= NODE_ID_COUNT ){
        bEnd = TRUE;
      }
      dprint("-------------------------\n"); //debug
    }
  }
};

/**
  Runs a 0 - index scan of NODEGRAPH_SEARCH_QUEUE[] to see if we've already been at this node
*/
float( float thisId, float newId ) nodegraph_check_visited={
  
  local float bVal;
  local float iitr;
  
  bVal = NODEGRAPH_SEARCH_CAME_FROM[newId];
  if( bVal == -1 ){
    return FALSE;
  }
  return TRUE;
};

/*
  Clear the search queue
*/
void() nodegraph_clear_search_queue={
  local float queueCount;
  
  node_t clearNode;
  
  for(queueCount = 0; queueCount < NODE_ID_COUNT; queueCount = queueCount + 1){
    NODEGRAPH_SEARCH_QUEUE[queueCount] = -1;
    NODEGRAPH_SEARCH_CAME_FROM[queueCount] = -1;
  }
};

vector( float nodeId ) nodegraph_get_node_origin={
  local float itr;
  local vector foundOrg;
  
  node_t check;
  
  for(itr = 0; itr < NODE_ID_COUNT; itr = itr + 1){
    check = NODEGRAPH_DATA[itr];
    if( check.id < 0 ){
      continue;
    }
    if( check.id == nodeId ){
      foundOrg = check.orig;
      break;
    }
  }
  return foundOrg;
};

/*
  Search nodegraph via origin, and sets the node_t globals CHECK and FOUND
*/
void( vector org ) nodegraph_node_by_origin={
  local float itr;
  local vector checkOrg;
  
  for(itr = 0; itr < NODE_ID_COUNT; itr = itr + 1){
    NODE_check = NODEGRAPH_DATA[itr];
    if( NODE_check.id < 0 ){
      continue;
    }
    checkOrg = NODE_check.orig;
    if( checkOrg == org ){
      NODE_found = NODE_check;
      break;
    }
  }
};


/*
  Search nodegraph via nodeid, and sets the node_t globals CHECK and FOUND
*/
void( float nodeId ) nodegraph_get_node_byid={

  local float itr;
  local vector foundOrg;
  
  for(itr = 0; itr < NODE_ID_COUNT; itr = itr + 1){
    NODE_check = NODEGRAPH_DATA[itr];
    if( NODE_check.id < 0){
      continue;
    }
    if( NODE_check.id == nodeId ){
      NODE_found = NODE_check;
      break;
    }
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
  nodegraph_debugger = spawn();
  nodegraph_debugger.classname = strzone("nodegraph_debugger");
  setmodel(nodegraph_debugger, "q3mdl/testball.md3");
  setsize(nodegraph_debugger, nodegraph_debugger.mins, nodegraph_debugger.maxs);
  setorigin(nodegraph_debugger, world.origin);
  
  nodegraph_trace_route( src, dst );
  
};
//--------------