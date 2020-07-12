/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 
  tank snipers are basically missile / tank hunter vehicles.
  the _combat file contains the state code for ST_COMBAT states.
*/

void() spg_combat={
  local float roll;
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    cons_logAString("new state", "spg_combat"); //debug

   
    
    //------------------------------------------------
    //otherwise prepare dancin'
    
    enemy_hunt = FALSE;
    roll = random() * 1;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, FALSE);
    self.ai_movedist = max((4 - self.ai_rank),1) * 10; //default move here, but can be overridden down the line.
    
    self.ai_state_next = ST_COM_MOVE_START;
    //clean LoS================================
    if( enemy_vis == VIS_FRAC ){
      //-------> RANGE SHORT
      if( enemy_range < 200 ) {
        //------------------> FACING FRONT
        if( enemy_infront ){
          spg_fight_close_front(roll);
          return;
        }
        spg_fight_close_rear(roll);
        return;
      }
      //------> RANGE COMBAT
      if( enemy_range <= self.ai_minrange ){
        //------------------> FACING FRONT
        if( enemy_infront ){
          spg_fight_mid_front(roll);
          return;
        }
        //------------------> FACING REAR
        spg_fight_mid_rear(roll);
        return;
      }
      //------> RANGE TOOO FAR
        //------------------> FACING FRONT
        if( enemy_infront ){
          spg_fight_far_front(roll);
          return;
        }
        //------------------> FACING REAR
        spg_fight_far_rear(roll);
        return;
    }
    
    //FRIENDLY FIRE================================
    if( enemy_vis == VIS_FRN ){
      //-------> RANGE SHORT
      if( enemy_range < 200 ) {
        //------------------> FACING FRONT
        if( enemy_infront ){
          if(self.ai_rank == AI_RANK_ROK){
            self.ai_movedist = 3;
            self.ai_move_next = MOVE_STAND_FACE;
            return;
          }
          self.ai_movedist = 3;
          self.ai_move_next = MOVE_BACK;
          return;
        }
        //------------------> FACING REAR
      }
      //------> RANGE COMBAT
      if( enemy_range <= self.ai_minrange ){
        //------------------> FACING FRONT
        if( enemy_infront ){
          self.ai_movedist = 3;
          self.ai_move_next = MOVE_SNIPESHOT;
          return;
        }
        //------------------> FACING REAR
      }
      //------> RANGE TOOO FAR
        //------------------> FACING FRONT
        //------------------> FACING REAR          
      self.ai_movedist = 3;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    
    //NO LoS================================
      //-------> RANGE SHORT
        //------------------> FACING FRONT
  
        //------------------> FACING REAR

      //------> RANGE COMBAT
        //------------------> FACING FRONT

        //------------------> FACING REAR

      
      //------> RANGE TOOO FAR
      //------------------> FACING FRONT

      //------------------> FACING REAR
    self.enemy = world;
    self.ai_movedist = 1;
    self.ai_state_next = ST_STAND;
    return;
  //---------------------------------------------------------------------------
  }
};

/*
  STATE : COMBAT FIGHTING
*/
void() spg_com_moveStart={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    cons_logAString("new state", "spg_com_moveStart"); //debug
    cons_logAFloat("self.ai_move_next", self.ai_move_next); //debug
    
    if( self.ai_move_next == MOVE_PATROLNODE ){
      //called ai_node_to_target() before getting to this state
      cons_logAFloat(" self.ai_move_next == MOVE_PATROLNODE",  self.ai_state_next); //debug
      cons_logAFloat("ENTER[ST_COM_MOVE_EXEC]",  self.ai_state_next); //debug
    }
    if( (self.ai_blockflag & self.ai_move_next) ){
      self.ai_move_next = MOVE_STAND;
    }
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
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    cons_logAFloat("ENTER[ST_COM_MOVE_EXEC]",  self.ai_state_next); //debug
    cons_logAFloat("-----------------------MOVE NEXT",  self.ai_move_next); //debug
    return;
  }
  //------------------------------------------------------------------
  cons_logAFloat("-----------------------MOVE",  self.ai_move); //debug
  if( self.ai_move != MOVE_PATROLNODE && self.ai_move != MOVE_NODE_RADIUS ){
    nodeMove = ai_check_node_radius(self);
    if(nodeMove > 0.95){
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
    cons_logAFloat("ENTER[ST_COM_MOVE_END]",  self.ai_state_next); //debug
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
void() spg_com_blocked={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    cons_logAFloat("ENTER[ST_COM_MOVE_BLOCK]",  self.ai_state_next); //debug
    self.goalentity = self.patrolNode;
    self.ai_move_next = MOVE_NODE_RADIUS;
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
 //------------------------------------------------------------------
};


