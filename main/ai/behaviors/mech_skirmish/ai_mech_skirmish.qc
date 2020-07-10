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
  if( ai_valid_target(self.enemy) ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  if( self.patrolNode != world ){
    if( time > self.pausetime ){
      self.ai_state_next = ST_PTR;
      return;
    }
  }
  
  if( self.torsoCenter.angles_y == self.torsoCenter.ideal_yaw ){
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
  self.th_die = ai_mech_sk_die;
  //self.th_rotate = ai_rotate_mech;
  //self.touch = ai_touch;
  //-----------------

  ai_setup_patrol();
  
  self.SendEntity = ctrl_send_mech_ai;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  //new state stuff
  self.ai_state_last = 0;
  
  if(self.patrolNode){
    self.ai_state_next = ST_PTR;
  }
  else{
    self.ai_state_next = ST_STAND; //debug
  }
  
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