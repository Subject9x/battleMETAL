/*
battleMETAL 
Author: Peter Roohr
Date: 7/17/2018
Overview: ai nodes
  all the various nodes needed for the game
*/

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
    cons_logAString( "node.targetname", self.targetname ); //DEBUG
    
    totes = totes - 1;
    if( totes > -1){
      self.target = strzone(strcat(nodeid,"_",ftos( totes )));
    }
    else{
      self.target = this.movetarget.targetname;
    }
    cons_logAString("node.target", self.target ); //DEBUG
    self.pausetime = time + fadetime;
    self.owner = this;
    self.th_stand = action;
    self.touch = ai_node_hunt_t;
    self.nextthink = time + 0.1;
    self.think = ai_node_hunt_th;
  self = this;
  return tnode;
};


//AI Nodes
//the patrol node touch 
void() ai_node_t_patrol={
  local entity	temp;
  
  if( other.movetarget != self ){
    cons_logAString("ai_node_t_patrol", "other.movetarget"); //DEBUG
    return;
  }
  
  if( other.enemy ){
    cons_logAString("ai_node_t_patrol", "other.enemy"); //DEBUG
    return;
  }
  
  if( other.ai_hunt_total > -1 ){
    cons_logAString("ai_node_t_patrol", "other.ai_hunt_total"); //DEBUG
    return;
  }
  
  temp = self;
	self = other;
	other = temp;

	//if (self.classname == "monster_ogre")
		//sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if ( !self.movetarget ){
		self.pausetime = time + 999999;
    ai_action_next( self.th_stand, 1, self.ai_action_mod );
		return;
	}
};

void() ai_node_t_defend={
  
};
void() ai_node_t_attack={
  
};

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
  setsize(self, '-2 -2 -16', '2 2 16');
  droptofloor();
};