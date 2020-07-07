/*
battleMETAL 
Author: Peter Roohr
Date: 7/20/2018
rebuild: 2/16/2019
Overview: ai unit
  Mech - Skirmisher
  an on-ground, turreted, walking unit
  skirmishers play to engage targets at medium to close range
  they can strafe left and right against targets
*/

/*
  STATE : STAND
*/
void() ai_mech_sk_stand={
  ai_update_accuracy( FALSE );
  
  //Enter state
  if(self.ai_state == ST_STAND &&  self.ai_state_last != ST_STAND ){
    cons_logAString("new state", "sk_stand"); //debug
    //entering stand state
    self.torsoCenter.attack_state = TR_NORM;
    self.legs.attack_state = TR_NORM;
    self.legs.think = bot_leg_stand1;
    self.legs.nextthink = time + 0.1;
    self.goalentity = world;
    return;
  }
  //-----------------
  
  cons_logAString("running--------", "sk_stand"); //debug
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    self.ai_state_next = ST_COMBAT;
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
  
  if( self.movetarget != world ){
    if( time > self.pausetime ){
      self.ai_state_next = ST_PTR;
      cons_logAFloat("ENTER[ST_PTR]",  self.ai_state_next); //debug
      return;
    }
  }
  
  if( self.torsoCenter.angles_y == self.torsoCenter.ai_dir ){
    self.torsoCenter.attack_state = TR_NORM;
  }
  if( random() > 0.9 && self.torsoCenter.attack_state != TR_YAW){
    self.ai_action_time = self.ai_action_mod * (self.ai_rank * 2);
    self.torsoCenter.ai_dir = (crandom() * self.ai_angleLimits_x);
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir + self.ai_angleLimits_y;
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir * crandom();
    self.torsoCenter.ai_dir = anglemod( self.angles_y + self.torsoCenter.ai_dir);
    self.torsoCenter.attack_state = TR_YAW;
    return;
  }
};

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
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      cons_logAFloat("ENTER[ST_STAND]",  self.ai_state_next); //debug
      return;
    }
    
    //check if target is near a node of AI's patrol path
    if( self.ai_move_last != MOVE_PATROLNODE ){
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
    self.ai_movedist = max((4 - self.ai_rank),1) * 10; //default move here, but can be overridden down the line.
    //new, trail stack
    if( !ai_mark_trail() ){
      //TODO trailmixin
      cons_logAFloat("hit trail max!", 1);  //debug
      //ai_mech_sk_trail_gate();
      self.ai_state_next = ST_TRAIL_MOVE;
      return;
    }
    
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
        
        }
        //------------------> FACING REAR
    }
    
    //FRIENDLY FIRE================================
    if( enemy_vis == VIS_FRN ){
      local vector lean;
      lean = vectoangles(self.enemy.origin - self.origin);
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
    else{
      local float trail;
      trail = ai_mark_trail();
      if( !trail ){
        
      }
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
void() mech_sk_com_moveExec={
  local float nodeMove;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    cons_logAString("new state", "mech_sk_com_moveExec"); //debug
    
    //AI is moving to closest node
    if( self.ai_move_next == MOVE_PATROLNODE ){
      cons_logAFloat("ai_move_next : MOVE_PATROLNODE", self.ai_move_next); //debug
      nodeMove = ai_move_patrol_node();
      if( nodeMove == PATROL_ARRIVE ){
        cons_logAString("ai_mech_sk_com_maneuver", "nodeMove == PATROL_ARRIVE"); //debug
        self.ai_state_next = ST_COM_MOVE_END;
        cons_logAFloat("ENTER[ST_COM_MOVE_END]",  self.ai_state_next); //debug
        return;
      }
    }
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

/*
  STATE: ST_TRAIL_MOVE
*/
void() mech_sk_trail_move={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_MOVE && self.ai_state_last != ST_TRAIL_MOVE ){
    cons_logAString("new state", "mech_sk_trail_move"); //debug
    self.tetherOrg = ai_trail_available();
    if( self.tetherOrg == self.origin ){
      //failed to find trail dest, ok, scrap and try nodes?
      self.movetarget = ai_node_to_target(self);
      self.ai_state_next = ST_PTR;
      return;
    }
    return;
  }
 //------------------------------------------------------------------
  ai_attack();
  if( vlen(self.tetherOrg - self.origin) > AI_NODE_DISTANCE / 2 ){
    //cons_logAFloat("distLeft > AI_NODE_DISTANCE", distLeft);  //debug
    ai_face_origin(self.tetherOrg);
    
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }
    if( ai_check_face_origin(self.tetherOrg, 0.85, FALSE) ){
      if( !walkmove(self.angles_y, self.data_speed_forward * AI_RUN_SPD) ){
        self.ai_state_next = ST_TRAIL_BLOCK;
      }
    }
    else{
      if( !walkmove(self.angles_y, (self.data_speed_forward / 4)* AI_RUN_SPD) ){
        self.ai_state_next = ST_TRAIL_BLOCK;
      }
    }
    return;
  }
  self.trailTotal = self.trailTotal - 1;
  
  self.ai_state_next = ST_COMBAT;
};
/*
  STATE: ST_TRAIL_BLOCK
*/
void() mech_sk_trail_move_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_BLOCK && self.ai_state_last != ST_TRAIL_BLOCK ){
    cons_logAString("new state", "mech_sk_trail_move_block"); //debug    
    self.tetherOrg = ai_trail_available();
    if( self.tetherOrg == self.origin ){
      //failed to find trail dest, ok, scrap and try nodes?
      self.movetarget = ai_node_to_target(self);
      self.ai_state_next = ST_PTR;
      return;
    }
    self.ai_state_next = ST_TRAIL_MOVE;
    return;
  }
 //------------------------------------------------------------------
};
/*
  STATE: ST_TRAIL_ROLLBACK
*/
void() mech_sk_trail_rollback={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBACK && self.ai_state_last != ST_TRAIL_ROLLBACK ){
    cons_logAString("new state", "mech_sk_trail_rollback"); //debug
    if( self.tetherOrg == self.trail1 ){
      ai_trail_clear();
      self.ai_state_next = ST_COMBAT;
      return;
    }
    ai_trail_back();
    self.tetherOrg = self.trailDest;
    self.ai_state_next = ST_TRAIL_MOVE;
    return;
  }
 //------------------------------------------------------------------
};
/*
  STATE: ST_TRAIL_ROLLBLOCK
*/
void() mech_sk_trail_rollback_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBLOCK && self.ai_state_last != ST_TRAIL_ROLLBLOCK ){
    cons_logAString("new state", "mech_sk_trail_rollback_block"); //debug
    return;
  }
 //------------------------------------------------------------------
};



/*
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={
  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  //deprecate this
  //self.th_stand = ai_mech_sk_enter_stand;
  //self.th_walk = ai_mech_sk_patrol1;
  //self.th_missile = ai_mech_sk_fight_prep;
  //self.th_pain = ai_mech_sk_panic1;
  self.th_react = ai_mech_sk_react1;
  //self.th_die = ai_mech_sk_die;
  //self.th_rotate = ai_rotate_mech;
  //self.touch = ai_touch;
  //-----------------

  ai_setup_patrol();
  
  self.SendEntity = ctrl_send_mech_ai;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  //new state stuff
  self.trailMax = 4;  //debug here
  self.trailTotal = 0;
  self.ai_state_last = 0;
  self.ai_state_next = ST_STAND; //debug
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND; //debug
  self.ai_dance_card = (MOVE_CHARGE | MOVE_CHARGE_LEFT | MOVE_CHARGE_RIGHT | MOVE_STRAFE_LEFT | MOVE_STRAFE_RIGHT | MOVE_BACK | MOVE_CIRCLE_LEFT | MOVE_CIRCLE_RIGHT | MOVE_STAND_FACE);
  
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ai_ctrl_update_mechplayer;
  self.ai_state_stand = ai_mech_sk_stand;
  
  //ai state interface--------------------------------------------------------
  self.ai_state_patrol = ai_mech_sk_patrol;
  self.ai_state_patrol_pause = ai_mech_sk_ptr_pause;
  self.ai_state_patrol_travel_node = ai_mech_sk_ptr_travel_node;
  self.ai_state_patrol_travel_blocked = ai_mech_sk_ptr_travel_blocked;
  self.ai_state_patrol_tether = ai_mech_sk_ptr_tether;
  self.ai_state_patrol_tether_blocked = ai_mech_sk_ptr_tether_blocked;
  
  self.ai_state_combat = mech_sk_combat;
  self.ai_state_combat_moveStart = mech_sk_com_moveStart;
  self.ai_state_combat_moveExec = mech_sk_com_moveExec;
  self.ai_state_combat_moveEnd = mech_sk_com_moveEnd;
  self.ai_state_combat_blocked = mech_sk_com_blocked;
  
  self.ai_state_trail_move = mech_sk_trail_move;
  self.ai_state_trail_move_block = mech_sk_trail_move_block;
  self.ai_state_trail_rollback = mech_sk_trail_rollback;
  self.ai_state_trail_rollback_block = mech_sk_trail_rollback_block;
  self.think = ai_state_frame;
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
  //--------------------------------------------------------------------------
};

void() ai_mech_sk_trail_gate={
  if( !ai_trail_back() ){
    cons_logAFloat("End of Trail, back to fight prep", 2);  //debug
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  self.tetherStatus = TETHER_NODE;
  self.tetherOrg = self.trailDest;
  
  cons_logAFloat("trailDest", self.trailMax);  //debug
  cons_logAFloat("trailTotal", self.trailTotal);  //debug
  
  macro_ai_frame(ai_mech_sk_patrol1)
};

/*
  Fight Prep is like the big combat-logic filter, TH_SCRUTINIZER? 
*/
void() ai_mech_sk_fight_prep={
  local float roll;

  ai_update_accuracy( FALSE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  self.speed = self.lefty;
      
  if( !ai_valid_target(self.enemy) ){
    //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
    macro_ai_frame(self.th_stand)
    return;
  } 
  
  if( (self.flags & FL_DISARMED) ){
    self.th_pain( world );
    return;
  }

  //new, trail stack
  if( !ai_mark_trail() ){
    cons_logAFloat("hit trail max!", 1);  //debug
    ai_mech_sk_trail_gate();
    return;
  }

  enemy_hunt = FALSE;

  roll = random();
  self.ai_action_time = self.ai_action_mod;
  enemy_vis = ai_check_vis( self.enemy );
  enemy_range = self.stat_trg_dist;
  enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, (self.flags & FL_TURRET));
  
  if( enemy_vis == VIS_FRAC ){
    if( enemy_range < 200 ){
      if( enemy_infront ){
        if( self.yaw_speed < 2 ){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = -1;
            macro_ai_frame(ai_mech_sk_enter_charge)
            return;
          }
          macro_ai_frame(ai_mech_sk_pivot1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_mech_sk_enter_strafe)
          return;
        }
        macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
        return;
      }
      //enemy is behind the unit
      if( self.yaw_speed < 2 ){
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.33 ){
            self.lefty = self.lefty * -1;
          }
          macro_ai_frame(ai_mech_sk_enter_strafe)
          return;
        }
        self.lefty = 1;
        macro_ai_frame(ai_mech_sk_enter_charge)
        return;
      }
      if( self.ai_rank > AI_RANK_REG ){
        self.lefty = self.lefty * -1;
        macro_ai_frame(ai_mech_sk_enter_flank)
        return;
      }
      self.lefty = 1;
      macro_ai_frame(ai_mech_sk_enter_charge)
      return;
    }
    
    if( enemy_range <= self.ai_minrange ){
      if( enemy_infront ){
        if( self.yaw_speed < 2 ){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = 1;
            macro_ai_frame(ai_mech_sk_enter_charge)
            return;
          }
          macro_ai_frame(ai_mech_sk_enter_flank)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.33 ){
            self.lefty = self.lefty * -1;
            macro_ai_frame(ai_mech_sk_enter_flank)
            return;
          }
          if( roll < 0.67 ){
            self.lefty = self.lefty * -1;
            macro_ai_frame(ai_mech_sk_enter_charge)
            return;
          }
          if( roll > 0.75 ){
            self.lefty = self.lefty * -1;
          }
          macro_ai_frame(ai_mech_sk_enter_strafe)
          return;
        }
        if( roll < 0.6 ){
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_mech_sk_enter_strafe)
          return;
        }
        self.lefty = 1;
        macro_ai_frame(ai_mech_sk_enter_charge)
        return;
      }
      if( self.ai_rank > AI_RANK_REG ){
        if( roll < 0.6 ){
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_mech_sk_enter_flank)
          return;
        }
        self.lefty = 1;
        macro_ai_frame(ai_mech_sk_enter_charge)
        return;
      }
      if( roll < 0.33 ){
        macro_ai_frame(ai_mech_sk_stand_fight1)
        return;
      }
      if( roll < 0.6 ){
        self.lefty = self.lefty * -1;
        macro_ai_frame(ai_mech_sk_enter_strafe)
        return;
      }
      self.lefty = self.lefty * -1;
      macro_ai_frame(ai_mech_sk_enter_charge)
      return;
    }

    if( enemy_range > self.ai_minrange ){
      if( enemy_infront ){
        self.lefty = 1;
        macro_ai_update(ai_mech_sk_enter_charge)
        return;
      }
      if( self.ai_rank > AI_RANK_REG ){
        self.lefty = self.lefty * -1;
        macro_ai_update(ai_mech_sk_enter_flank)
        return;
      }
      self.lefty = -1;
      macro_ai_update(ai_mech_sk_enter_charge)
      return;
    }
  }
  
  if( enemy_vis == VIS_FRN ){
    self.lefty = self.lefty * -1;
    if( self.ai_rank > AI_RANK_REG ){
      macro_ai_update(ai_mech_sk_enter_flank)
      return;
    }
    macro_ai_update(ai_mech_sk_enter_charge)
    return;
  }
  
  if( enemy_vis == VIS_FAIL ){
    if( self.ai_rank > AI_RANK_REG || self.stat_rdr_mode > 0){
      enemy_hunt = TRUE;
    }
  }
  
  if( enemy_hunt ){
    if(  self.ai_node_recall == world || !(self.ai_node_recall) ){
      macro_ai_frame(ai_mech_sk_enter_hunt)
      return;
    }
    macro_ai_frame(ai_mech_sk_enter_recall)
    return;
  }

  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_mech_sk_patrol1)
    return;
  }

  macro_ai_frame(ai_mech_sk_enter_stand)
};

void() ai_mech_sk_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.movetarget != world ){
    if( time > self.pausetime ){
      macro_ai_frame(ai_mech_sk_patrol1)
      return;
    }
  }
  
  if( random() > 0.9){
    self.ai_action_time = self.ai_action_mod * (self.ai_rank * 2);
    self.torsoCenter.ai_dir = (crandom() * self.ai_angleLimits_x);
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir + self.ai_angleLimits_y;
    self.torsoCenter.ai_dir = self.torsoCenter.ai_dir * crandom();
    self.torsoCenter.ai_dir = anglemod( self.angles_y + self.torsoCenter.ai_dir);
    self.torsoCenter.attack_state = TR_YAW;
    macro_ai_frame(ai_mech_sk_rotate1)
    return;
  }

  macro_ai_frame(ai_mech_sk_stand1)
};

void() ai_mech_sk_enter_stand={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  self.torsoCenter.attack_state = TR_NORM;
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_stand1;
  self.legs.nextthink = time + 0.1;
  self.goalentity = world;
  
  macro_ai_frame(ai_mech_sk_stand1)
};