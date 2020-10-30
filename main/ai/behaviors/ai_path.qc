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
  if(self.ai_state == ST_NODEGRAPH_MOVE &&  self.ai_state_last != ST_NODEGRAPH_MOVE ){
  
    return;
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
