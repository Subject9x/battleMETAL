/*
battleMETAL 
Author: Peter Roohr
Date: 10/26/2020
Overview: 
  Ferris Bueller: what are you all still doing here? movies over...
    we're in overtime.
    
    nodegraph impl to get the bots to move very well.
*/


void(float nodeCount, float nodeId, vector org, string edgeDat) nodegraph_read_new_node={
  
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
      theNode.nodes[edgeNum] = 0;
      theNode.edge[edgeNum] = 0;
    }
  }
  //dprint("EDGE END---------------------------\n"); //debug
  
  //dprint(strcat(ftos(theNode.id),"\n")); //debug
  //dprint(strcat(vtos(theNode.orig),"\n")); //debug
  //dprint("NODE LOADED---------------------------\n"); //debug
  NODEGRAPH_DATA[nodeCount] = theNode;
};

/*
  The entry func for the AI to access the nodegraph system.
    They have an end vector they want to get to, and will use the nodegraph to get there.
*/
void( vector start, vector end ) nodegraph_trace_route={

};

void( node_t aNode ) nodegraph_test={

  //dprint(strcat(vtos(aNode.orig), "\n"));

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

void() nodegraph_debug_graph={
  
};
//--------------