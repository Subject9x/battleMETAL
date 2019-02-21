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

  self.flags = self.flags | FL_NODE;
  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  self.solid = SOLID_TRIGGER;
  setmodel(self, "q3mdl/testball.md3");
  
  //only render nodes when debugging
  if( cvar("developer" ) ){
    self.alpha = 1;
  }
  else{
    self.alpha = 0;
  }
  
  setsize(self, '-10 -10 -18','10 10 18');
  if( (self.spawnflags & NODE_SPAWN_DROP) ){
    setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4))); 
    droptofloor();
  }
  
  if( !self.pausetime ){
    self.pausetime = 0.1; 
  }
  self.touch = node_touch;
  
  self.isActive = TRUE;
  if( (self.spawnflags & NODE_SPAWN_INACTIVE) ){
    self.isActive = FALSE;
    return;
  }
  trigger_event( self, trigOnSpawn );
};

void() node_recall_touch={
  local entity this;
  if( (self.owner.deadflag == DEAD_NO) && (other == self.owner) ){
    if( other.attack_state != ST_HUNT ){
      this = self;
      self = other;
        if( self.movetarget ){
          self.goalentity = self.movetarget;
          //ai_next_state( ST_WALK );
        }
        else{
//ai_next_state( ST_STAND );
        }
        self.ai_action_time = self.ai_action_time + (1 + (self.ai_rank * 2)); 
      self = this;
      remove(self);
      return;
    }
  }
  return;
};


/*
  touch function that defines a node as a Patrol Node
  this will set the touchee's movetarget to self.target
  and send it on its way.
  
*/
void() node_patrol_touch={
  
  if( !self.isActive ){
    return;
  }
  
  if( other.movetarget != self ){
    return;
  }
  
  if( other.enemy ){
    return;
  }
  
  if( self.i_faction == other.i_faction ){
    if( self.target ){
      local entity node;
      node = find (world, targetname, other.target);
      if( node ){
        otemp = self;
        self = other;
        other = otemp;
          self.goalentity = self.movetarget = node;
          self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
          if( other.pausetime ){
            self.pausetime = other.pausetime;
            self.pausetime = self.pausetime * (self.ai_action_mod / 10);
            self.pausetime = time + self.pausetime;
            self.th_melee();
            self = otemp;
            return;
          }
        self.th_walk();
        self = otemp;
        return;
      }
    }
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
  
  if( (other.flags & FL_MONSTER ) ){
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
  local entity recallNode;
  local entity theBot;
  
  recallNode = spawn();
  theBot = self;
  self = recallNode;
    setorigin( self, theBot.origin);
    self.data_idx = AI_NODE_RECALL;
    node_setup();
    self.owner = theBot;
  self = theBot;
  
  return recallNode;
};

/*
  QUAKED call
  this is what the map script will actually call to create a node entity
*/  
void() ai_node={
  if ( !self.targetname ){
		objerror ("node - missing targetname");
    remove(self);
    return;
  }
  node_setup();
};