/*
battleMETAL 
Author: Peter Roohr
Date: 7/17/2018
mod - 01/20/2019
Overview: ai nodes
  all the various nodes needed for the game
*/

//NODE CONSTANTS

//AI Node
float AI_NODE_PATROL = 1;
float AI_NODE_DEFEND = 2;
float AI_NODE_ATTACK = 3;
float AI_NODE_RECALL = 4;

//SPAWNFLAGS
float NODE_SPAWN_DROP = 1;
float NODE_SPAWN_REMOVEONTOUCH = 2;
float NODE_SPAWN_INACTIVE = 4;
float NODE_SPAWN_INACTIVEONTOUCH = 8;

void() node_use={
  if( !self.isActive ){
    self.isActive = TRUE;
    trigger_event( self, trigOnSpawn );
  }
};

/*
  common ini for any node entity
*/
void() node_setup={

  self.flags = FL_NODE;
  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  self.solid = SOLID_TRIGGER;
  self.touch = node_touch;  
  self.isActive = TRUE;
  
  util_MapDeveloperMarker();
  setsize(self, '-10 -10 -18','10 10 18');
  
  self.alpha = 0;
  self.effects = self.effects | EF_NOSHADOW;
  //only render nodes when debugging
  //DEBUG
  if( cvar("developer" ) ){
    self.alpha = 1;
    switch( self.data_idx ){
      case AI_NODE_PATROL:
        self.color = '1 1 0';
        break;
      case AI_NODE_RECALL:
        self.color = '1 0 1';
        break;
    }
  }
  
  trigger_event( self, trigOnSpawn );
  if( !self.pausetime )
    self.pausetime = ((4 - skill) * -1) * 1.65; 

  if( (self.spawnflags & NODE_SPAWN_INACTIVE) )
    self.isActive = FALSE;
};

/*
  recallNode's are spawned instantly on switching to hunt state,
  therefore, delay the node's touch function assignment to give the
  bot a chance to move away from recallNode's origin
*/
void() node_recall_delay={
  self.isActive = TRUE;
};

void() node_recall_touch={
  local entity this;
  if( (other == self.owner) && (self.owner.deadflag == DEAD_NO) ){
    if( other.goalentity == self ){
      this = self;
      self = other;
        self.ai_node_recall = world;
        if( ai_check_vis( self.enemy ) ){
          self.th_missile();
        }
        else{
          self.enemy = world;
          ai_turret_set_state( TR_NORM );
          if( self.movetarget ){
            self.goalentity = self.movetarget;
            self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
            self.th_walk();
          }
          else{
            self.th_stand();
          }
        }
      self = this;
      self.touch = SUB_Null;
      self.think = SUB_Remove;
      self.nextthink = time + 0.001;
    }
  }
};

/*
  touch function that defines a node as a Patrol Node
  this will set the touchee's movetarget to self.target
  and send it on its way.
*/
void() node_patrol_touch={
  local entity node;
  local entity thisNode;
  thisNode = self;
    
  if( (other.flags & (FL_UNIT)) ){
    if( time > other.pausetime ){ 
      if( self.faction == other.faction ){
        if( self.target ){
          node = find (world, targetname, self.target);
          if( node ){
            self = other;
              self.target = thisNode.target;
              self.goalentity = self.movetarget = node;
              self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
             
              macro_ai_frame(  self.th_walk )
              if( thisNode.pausetime ){
                self.pausetime = thisNode.pausetime;
                self.pausetime = self.pausetime + (self.pausetime * (self.ai_action_mod / 10));
                self.pausetime = self.pausetime + time;
                if( self.th_stand ){
                  macro_ai_frame( self.th_stand )
                }
              }
          }
          else{
            self = other;
            if( self.th_stand ){
              self.th_stand();
            }
          }
        }
        else{
          self = other;
          if( self.th_stand ){
            self.th_stand();
          }
        }
      }
    }
    self = thisNode;
  }
};

void() node_defend_touch={
  
};

void() node_attack_touch={
  
};

/*
  node touch function is generic with a switch for a specific type
  they are required to be isActive, and to have a data_idx > 0;
*/
void() node_touch={
  if( !self.isActive ){
    return;
  }
  
  if( (other.flags & FL_MONSTER) ){
    
    if( ai_valid_target(other.enemy) )
      return;
     
    if( other.movetarget != self )
      return;
  
    //AI is currently chasing down a target / or resetting
    if( (self.ai_node_recall.flags & FL_NODE) )
      return;
    
    switch( self.data_idx ){
      case AI_NODE_PATROL:
        node_patrol_touch();
        break;
      case AI_NODE_DEFEND:
        //TODO - defend node behavior?
        break;
      case AI_NODE_ATTACK:
        //TODO - attack node behavior?
        break;
      case AI_NODE_RECALL:
        node_recall_touch();
        break;
    }
  }
  
  if( (self.spawnflags & NODE_SPAWN_REMOVEONTOUCH) ){
    trigger_event( world, trigOnDeath );
    remove( self );
  }
  if( (self.spawnflags & NODE_SPAWN_INACTIVEONTOUCH) ){
    self.isActive = FALSE;
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
    self.spawnflags = NODE_SPAWN_INACTIVE;
    self.data_idx = AI_NODE_RECALL;
    node_setup();
    makevectors( theBot.angles );
    nodeOrg = theBot.origin + (v_up * theBot.mins_z) + (v_forward * (self.mins_x + 10));
    traceline( nodeOrg, nodeOrg + (v_up * 18), TRUE, theBot);
    setorigin( self, trace_endpos );
    self.targetname = strzone(strcat("node_recall_for_", ftos(num_for_edict(theBot))));
    if( theBot.movetarget ){
      self.target = theBot.movetarget.targetname;
    }
    self.owner = theBot;
    self.think = node_recall_delay;//see node_recall_delay_touch
    self.nextthink = time + 1.5;
  self = theBot;
  
  return theNode;
};


void() ai_node_check={
  local entity nodeCheck;
  if( self.target ){
    nodeCheck = find(world, targetname, self.target );
    if( !nodeCheck ){
      self.target = "";
    }
  }
};

/*QUAKED ai_node (0.988 0.976 0.267) (-10 -10 -18) (10 10 18) - REMOVE_ONTOUCH START_INACTIVE INACTIVE_ONTOUCH
This is used to setup patrol and move paths for AI.
For best results, place manually as close to ground as possible!
-------- KEYS -------- 
.faction = <float> [faction number]
.targetname = <string> used by AI to find node
.target = <string> should target another AI node to form a chain
.trigOnDeath = <string> [target] trigger this item when node is removed
.trigOnSpawn = <string> [target] trigger this item when node isActive = true;
.data_idx = <float> [enum]
      AI_NODE_PATROL = 1;
      AI_NODE_DEFEND = 2;
      AI_NODE_ATTACK = 3;

-------- SPAWNFLAGS -------- 
REMOVE_ONTOUCH 2: removed when touched
START_INACTIVE 4: start with .isActive = FALSE
INACTIVE_ONTOUCH 8:  shutoff when touched by AI
*/
void() ai_node={
  
  if ( !self.targetname ){
		objerror ("node - missing targetname");
    remove(self);
    return;
  }
  node_setup();
  self.think = ai_node_check;
  self.nextthink = time + 1;
};