/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish tanks are the basic behavior of tanks in the game,
  _combat.qc contains the state function bodies for the state machine.
  
*/

/*
  STATE : COMBAT START
    used to filter out what the AI should do before entering combat sub-system
*/
void() tank_sk_combat={
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      if( self.patrolNode ){
        self.goalentity = self.patrolNode;
        self.tetherStatus = TETHER_NODE;
        self.ai_state_next = ST_PTR;
        return;
      }
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    
    
    if( (self.flags & FL_DISARMED) ){
      //TODO pain / flee
      return;
    }
    self.ai_state_next = ST_COM_MOVE_START;
    enemy_hunt = FALSE;
    /*
      Combat Frame State Checks
    */
    enemy_vis = ai_check_vis( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    enemy_dist = ai_check_node_radius(self.enemy);
    combat_dist = ai_check_node_radius(self);
    enemy_range = ai_check_node_radius_targdist();
   
    //out of bounds, do move override
    if(combat_dist > 1.0){
      //run
      prox = ai_node_to_target(self);
      if(prox != self.patrolNode){
        if( vlen(prox.origin - self.origin) <= prox.ai_view ){
          self.patrolNode = prox;
        }
      }
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    
    combat_roll = random() * 1;  //engine doesn't like rolling a lot of dice, 
                          //so roll a single dice per instance of this
                          //frame...
    //AI is in bounds, but target is out of bounds
    if( enemy_dist > 1.0 && combat_dist <= 1.0 ){
      tank_sk_fight_target_fire();
      return;
    }
    
    if( enemy_dist > 1.0 && combat_dist > 1.0 ){
      tank_sk_fight_out_radius();
      return;
    }
    
    if( enemy_vis == VIS_FRN ){
      tank_sk_fight_vis_friend();
      return;
    }
    
    //target == building - those things don't really move or fight back...
    if(self.enemy.data_type == DATA_BLD){
      tank_sk_fight_building();
      return;
    }
    //target < 1.0
    //combat_dist < 1.0
    //get fighting
    self.ai_move_next = MOVE_NODE_RADIUS;
    tank_sk_fight_full();
    return;
  //---------------------------------------------------------------------------
  }
};

/*
  STATE : COMBAT FIGHTING
    marks the beginning of the AI doing a combat maneuver.
*/
void() tank_sk_com_moveStart={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_state_next = ST_COM_MOVE_EXEC;
    return;
  }
  //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER
*/
void() tank_sk_com_moveExec={
  local float nodeMove;
  local entity nodeCheck;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    return;
  }
  //------------------------------------------------------------------
  if( self.ai_move != MOVE_PATROLNODE && self.ai_move != MOVE_NODE_RADIUS ){
    nodeMove = ai_check_node_radius(self);
    if(nodeMove > 0.99){
      nodeCheck = ai_node_to_target(self);
      if(nodeCheck != self.patrolNode){
        if( (vlen(nodeCheck.origin - self.origin) <= nodeCheck.ai_view) && (ai_check_node_radius(self) > 0.95)){
          self.patrolNode = nodeCheck;
        }
      }
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    if( time > self.ai_movewait ){
      self.ai_state_next = ST_COM_MOVE_END;
      return;
    }
  }
};

/*
  STATE : COMBAT MANEUVER COMPLETED
*/
void() tank_sk_com_moveEnd={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    if( ai_valid_target(self.enemy) ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    if( self.patrolNode ){
      self.ai_state_next = ST_PTR;
      return;
    }
    self.ai_state_next = ST_STAND;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() tank_sk_com_blocked={
  local entity blockNode;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    self.goalentity = self.patrolNode;
    self.ai_move_next = MOVE_NODE_RADIUS;
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
 //------------------------------------------------------------------
};