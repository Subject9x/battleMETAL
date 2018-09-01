/*
battleMETAL 
Author: Peter Roohr
Date: 7/17/2018
Overview: ai nodes
  all the various nodes needed for the game
*/


//NODE CONSTANTS

//AI Node
float AI_NODE_PATROL = 1;
float AI_NODE_DEFEND = 2;
float AI_NODE_ATTACK = 3;

//SPAWNFLAGS
float NODE_SPAWN_DROP = 1;
float NODE_SPAWN_REMOVEONTOUCH = 2;
float NODE_SPAWN_INACTIVE = 4;
float NODE_SPAWN_INACTIVEONTOUCH = 8;

/*
  common ini for any node entity
*/
void() node_setup={

  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, '-15 -15 -59','15 15 1');
  if( (self.spawnflags & NODE_SPAWN_DROP) ){
    setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4))); 
    droptofloor();
  }
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_TRIGGER;
  
  if( !self.pausetime ){
    self.pausetime = 0.1; 
  }
  self.touch = node_touch;
  
  self.isActive = TRUE;
  if( (self.spawnflags & NODE_SPAWN_INACTIVE) ){
    self.isActive = FALSE;
  }
};

void() ai_node_hunt_t={
  if( other == self.owner && self.owner.deadflag == DEAD_NO){
    local entity this;
    this = self;
    self = other;
      self.ai_hunt_total = self.ai_hunt_total - 1;
      if( self.ai_hunt_total == -1 ){
        self.goalentity = self.movetarget;
      }
      else{
        if( this.target){
          self.goalentity = self.ai_hunt_node = find(world, targetname, this.target );
         }
        else{
          self.goalentity = self.movetarget;
        }
      }
      makevectors( self.angles );
      setorigin( self,  self.origin + (v_up * 0.5) );
      droptofloor();
      local float t;
      t = ai_move_time(self.m_fspeed * AI_WALK_SPD, vlen(self.goalentity.origin - self.origin), 0.05);
      ai_action_next( self.th_walk, t, self.ai_action_mod );
      if( self.e_legs){
        ai_leg_frame( leg_walk1 );
      }
      self.ai_viewtime = time + self.ai_viewcheck;
    self = this;
    remove( self );
    return;
  }
  return;
};

void() ai_node_hunt_th={
  if( time > self.pausetime ){
    if( self.owner && self.owner.deadflag == DEAD_NO){
      local entity this;
      this = self;
      self = this.owner;
        self.ai_hunt_total = self.ai_hunt_total - 1;
        if( self.ai_hunt_total == -1 ){
          self.goalentity = self.movetarget;
        }
        else{
          if( this.target ){
            cons_logAString("ai_node_hunt_th-> this.target", this.target ); //DEBUG
            self.goalentity = self.ai_hunt_node = find(world, targetname, this.target);
          }
          else{
            self.goalentity = self.movetarget;
          }
        }
        makevectors( self.angles );
        setorigin( self,  self.origin + (v_up * 0.5) );
        droptofloor();
        self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
        ai_action_next( self.th_walk, 1, self.ai_action_mod );
        ai_leg_frame( leg_walk1 );
        self.ai_viewtime = time + self.ai_viewcheck;
        
      self = this;
    }
    remove(self);
    return;
  }
  self.nextthink = time + 0.1;
  self.think = ai_node_hunt_th;
};

/*
  hunting nodes are generated when an AI loses LoS with a target.
  the node only lasts for FADETIME number of seconds, regardless if
  the hunting AI reaches the node. when the node expires, it orders
  its owner, the AI, to go back to w/e it was doing.
*/
entity(vector orig, string nodeid, float id, float fadetime, void() action) ai_node_hunt={
  local entity this, tnode;
  local float totes;
  totes = id;
  tnode = spawn();
  this = self;
  self = tnode;
    self.solid = SOLID_TRIGGER;
    setsize( self, '-2 -2 -16', '2 2 16' );
    setorigin( self, orig );
    droptofloor();
    self.targetname = strzone( strcat( nodeid,"_",ftos( id ) ) );
    
    totes = totes - 1;
    if( totes > -1){
      self.target = strzone(strcat(nodeid,"_",ftos( totes )));
    }
    else{
      self.target = this.movetarget.targetname;
    }
    self.pausetime = time + fadetime;
    self.owner = this;
    self.th_stand = action;
    self.touch = ai_node_hunt_t;
    self.nextthink = time + 0.1;
    self.think = ai_node_hunt_th;
  self = this;
  return tnode;
};


/*
  touch function that defines a node as a Patrol Node
  this will set the touchee's movetarget to self.target
  and send it on its way.
  
*/
void(entity o) node_patrol_t={
  local entity	temp;
  //other = o;
  
  if( other.movetarget != self ){
    return;
  }
  
  if( other.enemy ){
    return;
  }
  
  if( self.i_faction == other.i_faction ){  
    temp = self;
    self = other;
    other = temp;

    //if (self.classname == "monster_ogre")
      //sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

  //dprint ("t_movetarget\n");
    self.goalentity = self.movetarget = find (world, targetname, other.target);
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    ai_leg_frame( leg_stand1 );
    if ( self.movetarget ){
      if( other.pausetime ){
        ai_next_state( ST_STAND );
        self = temp;
        return;
      }
      ai_next_state( ST_WALK );
      ai_leg_frame( leg_walk1 );
      self = temp;
      return;
    }
    ai_next_state( ST_STAND );
    self = temp;
    return;
  }
};

void() ai_node_t_defend={
  
};

void() ai_node_t_attack={
  
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
        node_patrol_t( other );
        break;
      case AI_NODE_DEFEND:
        //TODO - defend node behavior?
        break;
      case AI_NODE_ATTACK:
        //TODO - attack node behavior?
        break;
    }
  }
  
  if( (self.spawnflags & NODE_SPAWN_REMOVEONTOUCH) ){
    remove( self );
  }
  if( (self.spawnflags & NODE_SPAWN_INACTIVEONTOUCH) ){
    self.isActive = FALSE;
  }
};

/*
  QUAKED call
  this is what the map script will actually call to create a node entity
*/  
void() msc_ai_node={
  if ( !self.targetname ){
		objerror ("node - missing targetname");
    remove(self);
    return;
  }
  node_setup();
};