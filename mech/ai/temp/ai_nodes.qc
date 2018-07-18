/*
battleMETAL 
Author: Peter Roohr
Date: 7/17/2018
Overview: ai nodes
  all the various nodes needed for the game
*/


/*
  Patrol nodes have the specific touch function
  
*/
void() ai_node_patrols={
  if ( !self.targetname ){
		objerror ("ai_node_patrol - missing targetname");
    remove(self);
    return;
  }
  
  switch( self.nextVecChoice ){
    case AI_NODE_PATROL:
      self.touch = ai_node_t_patrol;
      break;
    case AI_NODE_DEFEND:
      self.touch = SUB_Null;
      break;
    case AI_NODE_ATTACK:
      self.touch = SUB_Null;
      break;
  }
  
  self.solid = SOLID_TRIGGER;
  setsize(self, '-4 -4 -16', '4 4 16');
  droptofloor();
};