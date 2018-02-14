/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai state implementation
  state: ASSAULT
*/

//============================
//   ASSAULT STATES          
//============================
/*
  Assault nodes, to cover a large area (say a base) should be a series
  of nodes that either can see each other, or be seen by a central node.
  Give all nodes in the set of Defense nodes a .group id so that the
  AI can query all of them. 
*/
void() ai_assault_startWithNode={
  local entity e;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_defend_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_defend_gotoNode);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand); 
};


void() ai_assault_findNode={
  local entity e;
  e = find(world, targetname, self.target);
  self.ai_prev_state = ai_defend_startWithNode;
  if(e){
    if(e.isActive == TRUE){
      if(e.i_faction == self.i_faction){
        self.node = ai_findNode_searchGroup(e);
        self.enemy = self.node;
        self.goalentity = self.node;
        ai_state_control(ai_assault_gotoNode);
        return;
      }
    }
  }
  ai_state_control(ai_misc_stand); 
};

/*
  AI is traveling to an assault node
  could be from other types of nodes
*/
void() ai_assault_gotoNode={
  /*
    case A: traveling to node, no target
    case B: traveling to node with target
    case C: at node
    case D: fail, just stand
  */
};

/*
  AI is at the designated assault node
*/
void() ai_assault_atNode={
  /*
    case A: at node, no targets
    case B: have target, moving through node
    case C: do nothing.
  */
};