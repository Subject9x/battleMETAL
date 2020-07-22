/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 
  tank snipers are basically missile / tank hunter vehicles.
  the _combat file contains the state code for ST_COMBAT states.
*/

void() spg_combat={
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      if( self.patrolNode ){
        if( self.tetherStatus == TETHER_NODE ){
          self.goalentity = self.patrolNode;
          self.ai_state_next = ST_THR;
          return;
        }
        if( self.tetherStatus == TETHER_PATROL ){
          self.goalentity = self.patrolNode;
          self.ai_state_next = ST_PTR;
          return;
        }
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
    if( 1.0 < enemy_dist ){
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
    if( enemy_dist > 1.0 ){
      if( combat_dist <= 1.0 ){
        //AI is on edge of bounds but inside radius
        spg_fight_target_fire();
        return;
      }
      if( combat_dist > 1.0 ){
        spg_fight_out_radius();
        return;
      }
    }
    
    if( enemy_vis == VIS_FRN ){
      spg_fight_vis_friend();
      return;
    }
    
    //target == building - those things don't really move or fight back...
    if(self.enemy.data_type == DATA_BLD){
      spg_fight_building();
      return;
    }
    //target < 1.0
    //combat_dist < 1.0
    //get fighting
    self.ai_move_next = MOVE_NODE_RADIUS;
    spg_fight_full();
    return;
  //---------------------------------------------------------------------------
  }
  //can't find WHY its sometimes ending up here, but it is.
  self.ai_state_last = 0;
  self.ai_state_next = ST_COMBAT;
};

/*
  STATE : COMBAT FIGHTING
*/
void() spg_com_moveStart={
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
void() spg_com_moveExec={
  local float nodeMove;
  local entity nodeCheck;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    return;
  }
  //------------------------------------------------------------------
  if( self.ai_move != MOVE_PATROLNODE && self.ai_move != MOVE_NODE_RADIUS ){
    nodeMove = ai_check_node_radius(self);
    if(nodeMove > 0.95){
      if( self.tetherStatus == TETHER_PATROL ){
        nodeCheck = ai_node_to_target(self);
        if(nodeCheck != self.patrolNode){
          if( (vlen(nodeCheck.origin - self.origin) <= nodeCheck.ai_view) && (ai_check_node_radius(self) > 0.95)){
            self.patrolNode = nodeCheck;
          }
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
void() spg_com_moveEnd={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    if( !(self.ai_move_last & (MOVE_STAND_FACE | MOVE_STAND | MOVE_SNAPSHOT | MOVE_SNIPESHOT)) ){
      self.ai_move_next = MOVE_STAND_FACE;
      self.ai_movedist = self.ai_rank * 3;
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    self.ai_state_next = ST_COMBAT;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() spg_com_blocked={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    if( !(self.ai_move_last & (MOVE_STAND_FACE | MOVE_STAND | MOVE_SNAPSHOT | MOVE_SNIPESHOT)) ){
      self.ai_move_next = MOVE_STAND_FACE;
      self.ai_movedist = self.ai_rank * 4;
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    self.goalentity = self.patrolNode;
    self.ai_move_next = MOVE_NODE_RADIUS;
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
 //------------------------------------------------------------------
};


