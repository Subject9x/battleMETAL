/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _combat file contains the state code for ST_COMBAT states.
*/

/*
float ST_COM_REACT            = 12;
*/

/*
  STATE : COMBAT START
    used to filter out what the AI should do before entering combat sub-system
*/
void() mech_sk_combat={
  local float roll;
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
     cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      cons_logAFloat("!ai_valid_target(self.enemy) -> ST_STAND",  self.ai_state_next); //debug
      return;
    }
    
    //AI is outside node radius
    if( !ai_check_node_radius() ){
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_state_next = ST_COM_MOVE_START;
      cons_logAFloat("!ai_check_node_radius() -> ST_COM_MOVE_START",  ST_COM_MOVE_START); //debug
      cons_logAFloat("self.ai_move_next -> MOVE_NODE_RADIUS",  self.ai_move_next); //debug
      return;
    }
    
    //check if target is near a node of AI's patrol path
    if( self.ai_move != MOVE_PATROLNODE ){
      if( self.patrolNode ){
        prox = ai_node_to_target(self.enemy);
        if( prox != world ){
          self.ai_move_next = MOVE_PATROLNODE;
          self.ai_state_next = ST_COM_MOVE_START;
          self.goalentity = prox;
          //self.torsoCenter.attack_state = TR_GOAL;
          cons_logAString("goalentity.targetname",self.goalentity.targetname); //debug
          cons_logAString("goalentity.classname",self.goalentity.classname); //debug
          cons_logAFloat("ai_move_next: MOVE_PATROLNODE",  MOVE_PATROLNODE); //debug
          return;
        }
      }
    }
    //------------------------------------------------
    //otherwise prepare dancin'
    //self.speed = self.lefty;
    
    if( (self.flags & FL_DISARMED) ){
      //TODO pain / flee
      //self.th_pain( world );
      return;
    }
    
    self.ai_state_next = ST_COM_MOVE_START;
    
    enemy_hunt = FALSE;
    roll = random() * 1;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    self.ai_movedist = max((4 - self.ai_rank),1) * 2; //default move here, but can be overridden down the line.
    
    //run the tether node bounds check first
    if( vlen(self.origin - self.patrolNode.origin) > AI_RANGE_M ){
      //out of bounds
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    
    
    //clean LoS================================
    if( enemy_vis == VIS_FRAC ){
      //-------> RANGE SHORT
      if( enemy_range < 200 ) {
        //------------------> FACING FRONT
        if( enemy_infront ){
          mech_sk_fight_close_front(roll);
          return;
        }
        mech_sk_fight_close_rear(roll);
        return;
      }
      //------> RANGE COMBAT
      if( enemy_range <= self.ai_minrange ){
        //------------------> FACING FRONT
        if( enemy_infront ){
          mech_sk_fight_mid_front(roll);
          return;
        }
        //------------------> FACING REAR
        mech_sk_fight_mid_rear(roll);
        return;
      }
      //------> RANGE TOOO FAR
        //------------------> FACING FRONT
        if( enemy_infront ){
          mech_sk_fight_far_front(roll);
          return;
        }
        //------------------> FACING REAR
      mech_sk_fight_far_rear(roll);
      return;
    }
    
    //FRIENDLY FIRE================================
    if( enemy_vis == VIS_FRN ){
      local float lean;
      lean = vectoyaw(self.enemy.origin - self.origin);
      lean = anglemod(lean);
      //-------> RANGE SHORT
      if( enemy_range < 200 ) {
        //------------------> FACING FRONT
        if( enemy_infront ){
          if( self.ai_rank == AI_RANK_ROK ){
            self.ai_movedist = 5;
            self.ai_move_next = MOVE_STAND_FACE;
            return;
          }
          if( lean >= anglemod(self.angles_y + 45 ) ){
            self.ai_movedist = 3;
            self.ai_move_next = MOVE_STRAFE_RIGHT;
            return;
          }
          if( lean <= anglemod(self.angles_y - 45 ) ){
            self.ai_movedist = 3;
            self.ai_move_next = MOVE_STRAFE_LEFT;
            return;
          }
          self.ai_movedist = 5;
          self.ai_move_next = MOVE_BACK;
        }
        //------------------> FACING REAR
        
      }
      //------> RANGE COMBAT
      if( enemy_range <= self.ai_minrange ){
        //------------------> FACING FRONT
        if( enemy_infront ){
        
        }
        //------------------> FACING REAR
      }
      //------> RANGE TOOO FAR
        //------------------> FACING FRONT
        if( enemy_infront ){
          
        }
        //------------------> FACING REAR
      
    }
    
    //NO LoS================================
    if( enemy_vis == VIS_FAIL ){
      //-------> RANGE SHORT
      if( enemy_range < 200 ) {
        //------------------> FACING FRONT
        if( enemy_infront ){
        
        }
        //------------------> FACING REAR
      }
      //------> RANGE COMBAT
      if( enemy_range <= self.ai_minrange ){
        //------------------> FACING FRONT
        if( enemy_infront ){
        
        }
        //------------------> FACING REAR
      }
      
      //------> RANGE TOOO FAR
      //------------------> FACING FRONT
      if( enemy_infront ){
      
      }
      //------------------> FACING REAR
    }
    return;
  //---------------------------------------------------------------------------
  }
};

/*
  STATE : COMBAT FIGHTING
*/
void() mech_sk_com_moveStart={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    cons_logAFloat("ENTER[ST_COM_MOVE_START]",  self.ai_state_next); //debug
    cons_logAFloat("self.ai_move_next", self.ai_move_next); //debug
    self.ai_wishSpeed = 0;
    self.ai_state_next = ST_COM_MOVE_EXEC;
    return;
  }
  //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER
*/
void() mech_sk_com_moveExec={
  local float nodeMove;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    cons_logAFloat("ENTER[ST_COM_MOVE_EXEC]",  self.ai_state_next); //debug
    cons_logAFloat("-----------------------MOVE NEXT",  self.ai_move_next); //debug
    return;
  }
  //------------------------------------------------------------------
  cons_logAFloat("-----------------------MOVE",  self.ai_move); //debug
  if( self.ai_move != MOVE_PATROLNODE ){
    if( vlen(self.goalentity.origin - self.origin) > AI_RANGE_M ){
      self.ai_state_next = ST_COM_MOVE_START;
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    if( time > self.ai_movewait ){
      cons_logAFloat("time > self.ai_movewait", self.ai_movewait); //debug
      self.ai_state_next = ST_COM_MOVE_END;
      return;
    }
  }
};

/*
  STATE : COMBAT MANEUVER COMPLETED
*/
void() mech_sk_com_moveEnd={
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
     cons_logAFloat("ENTER[ST_COM_MOVE_END]",  self.ai_state_next); //debug
    if( self.ai_move_last == MOVE_PATROLNODE ){      
      cons_logAString("self.ai_move_last == MOVE_PATROLNODE", "run"); //debug
      self.ai_blockflag = 0; 
      self.ai_moveflag = self.ai_dance_card;
    }
    else{
      self.ai_movedist = 0;
      self.ai_moveflag = self.ai_moveflag - (self.ai_moveflag & self.ai_move);
    }
    self.ai_state_next = ST_COMBAT;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() mech_sk_com_blocked={
  local entity blockNode;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    cons_logAFloat("ENTER[ST_COM_MOVE_BLOCK]",  self.ai_state_next); //debug
    self.ai_movedist = 0;
    self.ai_blockflag = self.ai_blockflag | self.ai_move;
    self.ai_moveflag = self.ai_moveflag - (self.ai_moveflag & self.ai_move);
    blockNode = ai_node_to_target(self);
    cons_logAString("mech_sk_com_blocked().blockNode.targetname", blockNode.targetname);
    if( blockNode ){
      self.ai_state_next = ST_COM_MOVE_START;
      self.ai_move_next = MOVE_PATROLNODE;
      cons_logAFloat("if blockNode-> ST_COM_MOVE_START",  self.ai_state_next); //debug
      return;
    }
    self.enemy = world;
    self.ai_state_next = ST_STAND;
    return;
  }
 //------------------------------------------------------------------
};
