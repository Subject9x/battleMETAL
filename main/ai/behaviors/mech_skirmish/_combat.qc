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
    cons_logAString("new state", "mech_sk_combat"); //debug
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      //TODO 
        //-> exit combat with trailDest nodes, and far away from patrol node
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      cons_logAFloat("ENTER[ST_STAND]",  self.ai_state_next); //debug
      return;
    }
    
    //new, trail stack
    if( self.trailTotal == self.trailMax ){
      cons_logAFloat("mech_sk_combat->hit trail max!", 1);  //debug
      self.ai_state_next = ST_TRAIL_MOVE;
      cons_logAFloat("ENTER[ST_TRAIL_MOVE]",  self.ai_state_next); //debug
      return;
    }
    
    //check if target is near a node of AI's patrol path
    if( self.ai_move != MOVE_PATROLNODE ){
      if( self.movetarget ){
        prox = ai_node_to_target(self.movetarget);
        if( prox != world ){
          self.ai_move_next = MOVE_PATROLNODE;
          self.ai_state_next = ST_COM_MOVE_START;
          self.goalentity = prox;
          self.tetherOrg = self.goalentity.origin;
          self.ai_dampen = 1;
          
          self.legs.attack_state = TR_GOAL;
          self.legs.think = bot_leg_walk1;
          self.legs.nextthink = time + 0.1;
          
          self.torsoCenter.attack_state = TR_GOAL;
          cons_logAFloat("ENTER[ST_COM_MOVE_START]",  self.ai_state_next); //debug
          cons_logAString("self.goal",self.goalentity.targetname); //debug
          cons_logAFloat("self.ai_move_next: MOVE_PATROLNODE",  MOVE_PATROLNODE); //debug
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
    
    enemy_hunt = FALSE;
    roll = random() * 1;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    self.ai_movedist = max((4 - self.ai_rank),1) * 2; //default move here, but can be overridden down the line.
    
    self.ai_state_next = ST_COM_MOVE_START;
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
    cons_logAString("new state", "mech_sk_com_moveStart"); //debug
    cons_logAFloat("self.ai_move_next", self.ai_move_next); //debug
    
    if( self.ai_move_next == MOVE_PATROLNODE ){
      //called ai_node_to_target() before getting to this state
      cons_logAFloat(" self.ai_move_next == MOVE_PATROLNODE",  self.ai_state_next); //debug
      cons_logAFloat("ENTER[ST_COM_MOVE_EXEC]",  self.ai_state_next); //debug
      
    }
    if( (self.ai_blockflag & self.ai_move_next) ){
      //TODO - blocked move fall throughs
      self.ai_move_next = MOVE_STAND;
    }
    if( (self.ai_move_next & (MOVE_STRAFE_LEFT | MOVE_CHARGE_LEFT | MOVE_BACK_LEFT)) &&
      !(self.ai_move_last & (MOVE_STRAFE_RIGHT | MOVE_CHARGE_RIGHT | MOVE_BACK_RIGHT)) ){
      self.ai_dampen = 0;
    }
    
    if( !(self.ai_move_next & (MOVE_BACK | MOVE_BACK_LEFT | MOVE_BACK_RIGHT))){
      self.ai_dampen = 0;
    }
    self.ai_wishSpeed = 0;
    
    if( !(self.ai_move_next & (MOVE_STAND | MOVE_SNAPSHOT | MOVE_STAND_FACE | MOVE_SNIPESHOT)) ){  
      cons_logAString("mech_sk_com_moveStart", "Move is not a standing move, so mark the trail."); //debug
      if( !ai_mark_trail() ){
        //AI is out of trail markers, walk it back.
        cons_logAString("mech_sk_com_moveStart", "AI is out of trail markers, walk it back"); //debug
        self.ai_state_next = ST_TRAIL_MOVE;
        return;
      }
    }
    
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
    cons_logAString("new state", "mech_sk_com_moveExec"); //debug
    
    return;
  }
  //------------------------------------------------------------------
  if( self.ai_move == MOVE_PATROLNODE  && self.ai_move_last == MOVE_PATROLNODE ){
    //cons_logAString("ai_mech_sk_com_maneuver", "self.ai_move == MOVE_PATROLNODE"); //debug
    nodeMove = ai_move_patrol_node();
    if( nodeMove == PATROL_ARRIVE ){
      cons_logAString("ai_mech_sk_com_maneuver", "nodeMove == PATROL_ARRIVE"); //debug
      self.ai_state_next = ST_COM_MOVE_END;
      cons_logAFloat("ENTER[ST_COM_MOVE_END]",  self.ai_state_next); //debug
    }
    return;
  }
  if( time > self.ai_movewait ){
    cons_logAFloat("time > self.ai_movewait", self.ai_movewait); //debug
    self.ai_state_next = ST_COM_MOVE_END;
    cons_logAFloat("ENTER[ST_COM_MOVE_END]",  self.ai_state_next); //debug
    return;
  }
};

/*
  STATE : COMBAT MANEUVER COMPLETED
*/
void() mech_sk_com_moveEnd={
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    cons_logAString("new state", "mech_sk_com_moveEnd"); //debug
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
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() mech_sk_com_blocked={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    cons_logAString("new state", "mech_sk_com_blocked"); //debug
    cons_logAFloat("LAST MOVE", self.ai_move_last); //debug
    cons_logAFloat("MOVE", self.ai_move); //debug
    if( self.ai_move_last == MOVE_PATROLNODE ){      
      cons_logAString("self.ai_move_last == MOVE_PATROLNODE", "run"); //debug
      self.ai_blockflag = 0; 
      self.ai_moveflag = self.ai_dance_card;
      self.ai_state_next = ST_COMBAT;
      cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    }
    else{
      self.ai_movedist = 0;
      self.ai_blockflag = self.ai_blockflag | self.ai_move;
      self.ai_moveflag = self.ai_moveflag - (self.ai_moveflag & self.ai_move);
      self.ai_state_next = ST_TRAIL_MOVE;
    }
    return;
  }
 //------------------------------------------------------------------
};
