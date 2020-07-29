/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  gev tanks are special hovercraft, usually fast and annoying
  _combat.qc contains the state function bodies for the state machine.
  
*/

/*
  STATE : COMBAT START
    used to filter out what the AI should do before entering combat sub-system
*/
void() gev_combat={
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      if( self.patrolNode ){
        self.goalentity = self.patrolNode;
        if( self.tetherStatus == TETHER_NODE ){
          self.ai_state_next = ST_THR;
        }
        if( self.tetherStatus == TETHER_PATROL ){
          self.ai_state_next = ST_PTR;
        }
        return;
      }
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    
    if( (self.flags & FL_DISARMED) ){
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
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
    if(1.0 < combat_dist ){
      //run
      if(self.tetherStatus == TETHER_PATROL ){
        prox = ai_node_to_target(self.enemy);
        if(prox != self.patrolNode){
          self.patrolNode = prox;
          self.ai_move_next = MOVE_NODE_TACTICAL;
          return;
        }
      }
    }
    
    combat_roll = random() * 1;  //engine doesn't like rolling a lot of dice, 
                          //so roll a single dice per instance of this
                          //frame...
    //AI is in bounds, but target is out of bounds
    if( 1.0 < enemy_dist ){
      if( combat_dist <= 1.0 ){
        //AI is on edge of bounds but inside radius
          gev_fight_target_fire();
        if(self.ai_move_next > MOVE_NODE_TACTICAL){
          self.ai_move_next = ai_move_director();
        }
        return;
      }
      if( 1.0 < combat_dist ){
        gev_fight_out_radius();
        if(self.ai_move_next > MOVE_NODE_TACTICAL){
          self.ai_move_next = ai_move_director();
        }
        return;
      }
    }
    
    if( enemy_vis == VIS_FRN ){
      gev_fight_vis_friend();
      if(self.ai_move_next > MOVE_NODE_TACTICAL){
        self.ai_move_next = ai_move_director();
      }
      return;
    }
    
    //target == building - those things don't really move or fight back...
    if(self.enemy.data_type == DATA_BLD){
      gev_fight_building();
      if(self.ai_move_next > MOVE_NODE_TACTICAL){
        self.ai_move_next = ai_move_director();
      }
      return;
    }
    //target < 1.0
    //combat_dist < 1.0
    //get fighting
    self.ai_move_next = MOVE_NODE_RADIUS;
    gev_fight_full();
    if(self.ai_move_next > MOVE_NODE_TACTICAL){
      self.ai_move_next = ai_move_director();
    }
    return;
  //---------------------------------------------------------------------------
  }
  //can't find WHY its sometimes ending up here, but it is.
  self.ai_state_last = 0;
  self.ai_state_next = ST_COMBAT;
};

/*
  STATE : COMBAT FIGHTING
    marks the beginning of the AI doing a combat maneuver.
*/
void() gev_com_moveStart={
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
void() gev_com_moveExec={
  local float nodeMove;
  local entity nodeCheck;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    return;
  }
  //------------------------------------------------------------------
  if( MOVE_NODE_TACTICAL < self.ai_move ){
    nodeMove = ai_check_node_radius(self);
    if( 1.0 < nodeMove ){
      if( self.tetherStatus == TETHER_PATROL ){
        nodeCheck = ai_node_to_target(self);
        if(nodeCheck != self.patrolNode){
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
void() gev_com_moveEnd={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    ai_attack();
    if( self.ai_move_last == MOVE_END_PAUSE ){
      if( self.ai_blockflag ){
        self.ai_blockflag = 0;
        self.ai_state_next = ST_COM_MOVE_START;
        self.ai_move_next = MOVE_NODE_RADIUS;
        return;
      }
    }
    if( self.ai_move > MOVE_NODE_TACTICAL){
      self.ai_move_next = MOVE_END_PAUSE;
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    self.ai_state_next = ST_COMBAT;
    self.ai_move_next = 0;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() gev_com_blocked={
  local entity blockNode;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    ai_attack();
    if( 1.0 < ai_check_node_radius(self) ){
      self.patrolState = 0;
      self.goalentity = self.patrolNode;
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_state_next = ST_COM_MOVE_START;
      self.ai_movewait = time + 8;
      return;
    }
    self.ai_movedist = 3;
    self.ai_move_next = ai_move_director(self.ai_movedist * self.data_speed_backward);
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
 //------------------------------------------------------------------
};