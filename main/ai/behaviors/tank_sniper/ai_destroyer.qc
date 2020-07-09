/*
battleMETAL 
Author: Peter Roohr
Date: 7/12/2018
rebuild: 2/16/2019
Overview: ai unit
  Tank Destroyer
  an on-ground, turret-less vehicle
*/
/*
  AI SPAWN FUNCTION
*/
void() ai_vec_dest={
  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  self.spawnflags = self.spawnflags | HAS_RADAR;
  ai_pilot_ini_stats(self.ai_rank);
  if( self.vec_size < 3 ){
     self.spawnflags = self.spawnflags | MUTE_ME;
  }
  ai_voice_ini( TRUE );
  
  //self.th_stand = ai_spg_stand1;
  //self.th_walk = ai_spg_enter_patrol;
  //self.th_missile = ai_spg_fight_prep;
  //self.th_pain = ai_spg_panic1;
  self.th_react = ai_spg_react1;
  self.th_die = ai_vec_dest_die;
  //self.th_rotate = ai_rotate_tank;
  self.touch = ai_touch;

  ai_setup_patrol();
  
  self.SendEntity = ctrl_send_spg;
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;   
  local entity wep;
  for(wep = self.w_slot; wep != world; wep = wep.w_slot){
    wep.effects = EF_NODRAW;
  } 
  
  //new state stuff
  self.ai_state_last = 0;
  self.ai_state_next = ST_STAND; //debug
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND; //debug
  self.ai_dance_card = ( MOVE_BACK | MOVE_STAND_FACE | MOVE_SNIPESHOT );
  if(self.ai_rank == AI_RANK_REG || self.ai_rank == AI_RANK_VET ){
    self.ai_dance_card = self.ai_dance_card | (MOVE_CHARGE_LEFT | MOVE_CHARGE_RIGHT); //oh ho ho 
  }
  if(self.ai_rank == AI_RANK_ACE){
    self.ai_dance_card = self.ai_dance_card | (MOVE_BACK_LEFT | MOVE_BACK_RIGHT);
  }
  self.ai_moveflag = self.ai_dance_card;
  self.dphitcontentsmask = 0;
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  
  self.ai_unit_update = ctrl_updateTank;
  self.ai_state_stand = ai_spg_stand;
  
  //ai state interface--------------------------------------------------------
  self.ai_state_patrol = ai_spg_patrol;
  self.ai_state_patrol_pause = ai_spg_ptr_pause;
  self.ai_state_patrol_travel_node = ai_spg_ptr_travel_node;
  self.ai_state_patrol_travel_blocked = ai_spg_ptr_travel_blocked;
  self.ai_state_patrol_tether = ai_spg_ptr_tether;
  self.ai_state_patrol_tether_blocked = ai_spg_ptr_tether_blocked;
  
  self.ai_state_combat = spg_combat;
  self.ai_state_combat_moveStart = spg_com_moveStart;
  self.ai_state_combat_moveExec = spg_com_moveExec;
  self.ai_state_combat_moveEnd = spg_com_moveEnd;
  self.ai_state_combat_blocked = spg_com_blocked;
  
  self.ai_state_trail_move = spg_trail_move;
  self.ai_state_trail_move_block = spg_trail_move_block;
  self.ai_state_trail_rollback = spg_trail_rollback;
  self.ai_state_trail_rollback_block = spg_trail_rollback_block;
  self.think = ai_state_frame;
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
  //--------------------------------------------------------------------------
};

/*
  STATE: STAND
*/
void() ai_spg_stand={
    ai_update_accuracy( FALSE );
  
  //Enter state
  if(self.ai_state == ST_STAND &&  self.ai_state_last != ST_STAND ){
    cons_logAString("new state", "spg_stand"); //debug
    //entering stand state
    self.goalentity = world;
    return;
  }
  //-----------------
  
  cons_logAString("running--------", "spg_stand"); //debug
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

  if( random() > 0.9 && self.angles_y == self.ai_dir){
    self.ai_dir = (crandom() * 45);
    self.ai_dir = self.ai_dir + -45;
    self.ai_dir = self.ai_dir * crandom();
    self.ai_dir = anglemod( self.angles_y + self.ai_dir);
    return;
  }
};

/*
  TH_STAND
*/
void() ai_spg_stand1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){ 
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  if( (self.movetarget) ){
    if( time > self.pausetime ){
      macro_ai_frame(ai_spg_patrol1)
      return;
    }
  }

  macro_ai_frame(ai_spg_stand1)
};

/*
  TH_WALK
*/
void() ai_spg_patrol1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){    
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  ai_patrol_frame(ai_spg_patrol1, ai_spg_stand1);
};

void() ai_spg_enter_patrol={
  self.goalentity = self.movetarget;
   macro_ai_frame(ai_spg_patrol1)
};

/*
  FIGHT FILTER
*/
void() ai_spg_fight_prep={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(self.th_stand)
    return;
  } 
  
  if( (self.flags & FL_DISARMED) ){
    self.th_pain( world );
    return;
  }
  
  local float roll;
  self.speed = self.lefty;
  
  roll = random();
  self.ai_action_time = self.ai_action_mod;
  enemy_vis = ai_check_vis( self.enemy );
  enemy_range = self.stat_trg_dist;
  enemy_infront = ai_check_face( self.enemy, self.ai_fov, FALSE);
  
  if( enemy_vis == VIS_FRAC ){
    if( enemy_range <= 200 ){
      if( enemy_infront ){
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.6 ){
            //possibly charge astride the target
            macro_ai_frame(ai_spg_enter_charge)
            return;
          }
          //rotate, go down fighting
          macro_ai_frame(ai_spg_rotate1)
          return;
        }
        if( roll < 0.33 ){
          //possibly charge astride the target
          macro_ai_frame(ai_spg_enter_charge)
          return;
        }
        //reverse, worse shot overall
        macro_ai_frame(ai_spg_reverse1)
        return;
      }
      
      if( self.ai_rank > AI_RANK_REG ){
        if( roll < 0.45 ){
          macro_ai_frame(ai_spg_enter_charge)
          return;
        }
        macro_ai_frame(ai_spg_reverse1)
        return;
      }
      if( roll <= 0.33 ){
        macro_ai_frame(ai_spg_rotate1)
        return;
      }
      macro_ai_frame(ai_spg_reverse1)
      return;
    }

    if( enemy_range <= self.ai_minrange ){
      if( enemy_infront ){
        if( self.ai_rank > AI_RANK_REG ){
          //snipe or strafe
          if( roll < 0.1 ){
            macro_ai_frame(ai_spg_enter_strafe)
            return;
          }
          if( roll < 0.2 ){
            macro_ai_frame(ai_spg_enter_charge)
            return;
          }
          macro_ai_frame(ai_spg_snipe1)
          return;
        }
        if( roll < 0.1 ){
          macro_ai_frame(ai_spg_enter_strafe)
          return;
        }
        macro_ai_frame(ai_spg_snipe1)
        return;
      }
      if( self.ai_rank > AI_RANK_REG ){
        if( roll < 0.2 ){
          macro_ai_frame(ai_spg_enter_charge)
          return;
        }
        macro_ai_frame(ai_spg_snipe1)
        return;
      }
      if( roll < 0.33 ){
        macro_ai_frame(ai_spg_enter_strafe)
        return;
      }
      if( roll < 0.67 ){
        macro_ai_frame(ai_spg_snipe1)
        return;
      }
      macro_ai_frame(ai_spg_reverse1)
      return;
    }
    
    
    if( enemy_range > self.ai_minrange ){
      if( enemy_infront ){
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.33 ){
            macro_ai_frame(ai_spg_enter_strafe)
            return;
          }
          macro_ai_frame(ai_spg_enter_charge)
          return;
        }
        if( roll < 0.15 ){
          macro_ai_frame(ai_spg_enter_charge)
          return;
        }
        //tank destroyers don't hunt
        macro_ai_frame(ai_spg_rotate1)
        return;
      }
      
      if( self.ai_rank > AI_RANK_REG ){
        macro_ai_frame(ai_spg_enter_charge)
        return;
      }
      macro_ai_frame(ai_spg_rotate1)
      return;
    }
  }
  
  if( enemy_vis == VIS_FRN ){
    if( friend_blocker_dist < 200 ){
      macro_ai_frame(ai_spg_reverse1)
      return;
    }
    if( friend_blocker_dist <= self.ai_minrange ){
      macro_ai_frame(ai_spg_enter_strafe)
      return;
    }
    macro_ai_frame(ai_spg_rotate1)
    return;
  }

  self.enemy = world;
  macro_ai_frame(ai_spg_enter_patrol)
};