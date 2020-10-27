/*
battleMETAL 
Author: Peter Roohr
Date: 10/26/2020
Overview: 
  Ferris Bueller: what are you all still doing here? movies over...
    we're in overtime.
    
    nodegraph impl to get the bots to move very well.
*/


void( node_t node, float nodeCounter, float nodeId, vector org, string edgeDat) nodegraph_read_new_node={
  //NODEGHRAPH_DATA[nodeCounter].id = nodeid;
  local string edgeString;
  local float edgetokens;
  local float edgeItr;
  
  local float edgeCount;
  local float edgeNum;
  
  node.id = nodeId;
  node.orig = org;
  
  edgeString = edgeDat;
  edgetokens = tokenizebyseparator(edgeString, " ", "-");
  edgeCount = 1;
  
  for(edgeNum = 0; edgeNum < 6; edgeNum = edgeNum + 1){
    node.nodes[edgeNum] = stof(argv(edgeItr));
    edgeItr = edgeItr + 1;
    node.edge[edgeNum] = stof(argv(edgeItr));
    edgeItr = edgeItr + 1;
  }
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