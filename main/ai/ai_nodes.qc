/*
battleMETAL 
Author: Peter Roohr
Date: 7/17/2018
mod - 01/20/2019
Overview: ai nodes
  all the various nodes needed for the game
*/

void() node_use={
  if( !self.isActive ){
    self.isActive = TRUE;
    trigger_event( self, self.trigOnSpawn );
  }
};

/*
  common ini for any node entity
*/
void() node_setup={

  self.flags = FL_NODE;
  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.isActive = TRUE;
  
  util_MapDeveloperMarker();
  setsize(self, '-10 -10 -18','10 10 18');
  setorigin(self, self.origin);
  
  trigger_event( self, self.trigOnSpawn );
  if( !self.pausetime ){
    self.pausetime = ((4 - skill) * -1) * 1.65; 
  }
};

/*
  Recall Nodes are created when an AI spawns a Hunt Node,
  Recall Nodes act as a breadcrumb to bring the AI back to exactly where they were before hunting.
  This only exist for a limited amount of time.
*/
entity() node_recall_setup={
  local entity theBot;
  local entity theNode;
  local vector nodeOrg;
  
  theNode = spawn();
  theBot = self;
  self = theNode;
    node_setup();
    makevectors( theBot.angles );
    nodeOrg = theBot.origin + (v_up * theBot.mins_z) + (v_forward * (self.mins_x + 10));
    traceline( nodeOrg, nodeOrg + (v_up * 18), MOVE_NORMAL, theBot);
    setorigin( self, trace_endpos );
    self.targetname = strzone(strcat("node_recall_for_", ftos(num_for_edict(theBot))));
    if( theBot.movetarget && theBot.movetarget.targetname != "" ){
      self.target = theBot.movetarget.targetname;
    }
    self.owner = theBot;
  self = theBot;
  
  return theNode;
};

void() ai_node_check={
  local entity nodeCheck;
  if( self.target ){
    nodeCheck = find(world, targetname, self.target );
    if( !nodeCheck ){
      if( cvar("developer") ){
        cons_log2Strings("node", self.targetname, "can't find target of", self.target);  //DEBUG
      }
      self.target = "";
    }
  }
};

/*QUAKED ai_node (0.988 0.976 0.267) (-10 -10 -18) (10 10 18) - START_INACTIVE
This is used to setup patrol and move paths for AI.
For best results, place manually as close to ground as possible!
-------- KEYS -------- 
.faction = <float> [faction number]
.targetname = <string> used by AI to find node
.target = <string> should target another AI node to form a chain
.trigOnDeath = <string> [target] trigger this item when node is removed
.trigOnSpawn = <string> [target] trigger this item when node isActive = true;

-------- SPAWNFLAGS -------- 
START_INACTIVE 1: start with .isActive = FALSE
*/
void() ai_node={
  
  if ( !self.targetname ){
		objerror ("node - missing targetname");
  }
  node_setup();
  self.think = ai_node_check;
  self.nextthink = time + 1;
};