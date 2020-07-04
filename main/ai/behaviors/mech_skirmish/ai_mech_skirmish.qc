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

  cons_logAString("running--------", "sk_stand"); //debug
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    self.ai_state_next = ST_COMBAT;
    //macro_ai_frame(ai_mech_sk_fight_prep)
    //return;
  }
  
  if( self.movetarget != world ){
    if( time > self.pausetime ){
      self.ai_state_next = ST_PTR;
      //macro_ai_frame(ai_mech_sk_patrol1)
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
    // macro_ai_frame(ai_mech_sk_rotate1)
    //return;
  }

};

/*
  STATE : PATROL START
*/
void() ai_mech_sk_patrol={
  ai_update_accuracy( TRUE );
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
    if( self.ai_state_last == ST_COMBAT || self.ai_state_last == ST_COM_FIGHT || self.ai_state_last == ST_COM_FIGHT_MOVEBLOCK){
      if( self.movetarget != world ){
        
      }
    }
    else{
      cons_logAString("new state", "sk_patrol"); //debug
      self.goalentity = self.movetarget;
      self.legs.attack_state = TR_GOAL;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
      self.torsoCenter.attack_state = TR_GOAL;
      self.ai_state_next = ST_PTR_TRAVEL_NODE;
      cons_logAFloat("ENTER[ST_PTR_TRAVEL_NODE]",  self.ai_state_next); //debug
    }
    return;
  }
  else{
    cons_logAString("running--------", "sk_patrol"); //debug
  
  }

};
/*
  STATE : PATROL PAUSE
*/
void() ai_mech_sk_ptr_pause={
  ai_update_accuracy( FALSE );
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
    cons_logAString("new state", "sk_patrol_pause"); //debug
    self.legs.attack_state = TR_YAW;
    self.legs.angles_y = self.angles_y;
    self.legs.think = bot_leg_stand1;
    self.legs.nextthink = time + 0.1;
    return;
  }
  if( time > self.pausetime ){
    if( self.movetarget != world ){
      self.ai_state_next = ST_PTR;
    cons_logAFloat("ENTER[ST_PTR]",  self.ai_state_next); //debug
    }
    else{
      self.ai_state_next = ST_STAND;
    cons_logAFloat("ENTER[ST_STAND]",  self.ai_state_next); //debug
    }
  }
};
/*
  STATE : PATROL TRAVEL TO NODE
*/
void() ai_mech_sk_ptr_travel_node={
  ai_update_accuracy( TRUE );
  local float patrolState;
    cons_logAString("running--------", "ai_mech_sk_ptr_travel_node"); //debug
  patrolState = ai_patrol_frame(ai_mech_sk_patrol1, ai_mech_sk_enter_stand);
    cons_logAFloat("running--------patrolState", patrolState); //debug
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    //macro_ai_frame(ai_mech_sk_fight_prep)
    //return;
    self.ai_state_next = ST_COMBAT;
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
  
  if( patrolState == PATROL_PAUSE ){
    self.ai_state_next = ST_PTR_PAUSE;
    cons_logAFloat("ENTER[ST_PTR_PAUSE]",  self.ai_state_next); //debug
    return;
  }
};
/*
  STATE : PATROL TRAVEL TO NODE BLOCKED
*/
void() ai_mech_sk_ptr_travel_blocked={

};

/*
  STATE : PATROL USE TETHER
*/
void() ai_mech_sk_ptr_tether={

};

/*
  STATE : PATROL USE TETHER BLOCKED
*/
void() ai_mech_sk_ptr_tether_blocked={

};

/*
float ST_COM_REACT            = 12;
*/

/*
  STATE : COMBAT START
*/
void() ai_mech_sk_combat={
  local float roll;
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    cons_logAString("new state", "ai_mech_sk_combat"); //debug
    self.ai_state_next = ST_COM_FIGHT;
    cons_logAFloat("ENTER[ST_COM_FIGHT]",  self.ai_state_next); //debug
    
  }
  else{

    ai_update_accuracy( FALSE );
    macro_ai_update(ai_ctrl_update_mechplayer)
    self.speed = self.lefty;
        
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      //macro_ai_frame(self.th_stand)
      self.ai_state_next = ST_PTR;
      return;
    } 
    
    if( (self.flags & FL_DISARMED) ){
      //TODO pain / flee
      //self.th_pain( world );
      return;
    }

    //new, trail stack
    if( !ai_mark_trail() ){
      //TODO trailmixin
      cons_logAFloat("hit trail max!", 1);  //debug
      //ai_mech_sk_trail_gate();
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
              //macro_ai_frame(ai_mech_sk_enter_charge)
              return;
            }
            macro_ai_frame(ai_mech_sk_pivot1)
            return;
          }
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            //macro_ai_frame(ai_mech_sk_enter_strafe)
            return;
          }
          //macro_ai_frame(ai_mech_sk_enter_reverse_adjust)
          return;
        }
        //enemy is behind the unit
        if( self.yaw_speed < 2 ){
          if( self.ai_rank > AI_RANK_REG ){
            if( roll < 0.33 ){
              self.lefty = self.lefty * -1;
            }
            //macro_ai_frame(ai_mech_sk_enter_strafe)
            return;
          }
          self.lefty = 1;
          //macro_ai_frame(ai_mech_sk_enter_charge)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = self.lefty * -1;
          //macro_ai_frame(ai_mech_sk_enter_flank)
          return;
        }
        self.lefty = 1;
        //macro_ai_frame(ai_mech_sk_enter_charge)
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.yaw_speed < 2 ){
            if( self.ai_rank > AI_RANK_REG ){
              self.lefty = 1;
              //macro_ai_frame(ai_mech_sk_enter_charge)
              return;
            }
            //macro_ai_frame(ai_mech_sk_enter_flank)
            return;
          }
          if( self.ai_rank > AI_RANK_REG ){
            if( roll < 0.33 ){
              self.lefty = self.lefty * -1;
              //macro_ai_frame(ai_mech_sk_enter_flank)
              return;
            }
            if( roll < 0.67 ){
              self.lefty = self.lefty * -1;
              //macro_ai_frame(ai_mech_sk_enter_charge)
              return;
            }
            if( roll > 0.75 ){
              self.lefty = self.lefty * -1;
            }
            //macro_ai_frame(ai_mech_sk_enter_strafe)
            return;
          }
          if( roll < 0.6 ){
            self.lefty = self.lefty * -1;
            //macro_ai_frame(ai_mech_sk_enter_strafe)
            return;
          }
          self.lefty = 1;
          //macro_ai_frame(ai_mech_sk_enter_charge)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.6 ){
            self.lefty = self.lefty * -1;
            //macro_ai_frame(ai_mech_sk_enter_flank)
            return;
          }
          self.lefty = 1;
          //macro_ai_frame(ai_mech_sk_enter_charge)
          return;
        }
        if( roll < 0.33 ){
          //macro_ai_frame(ai_mech_sk_stand_fight1)
          return;
        }
        if( roll < 0.6 ){
          self.lefty = self.lefty * -1;
          //macro_ai_frame(ai_mech_sk_enter_strafe)
          return;
        }
        self.lefty = self.lefty * -1;
        //macro_ai_frame(ai_mech_sk_enter_charge)
        return;
      }

      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          self.lefty = 1;
          //macro_ai_update(ai_mech_sk_enter_charge)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = self.lefty * -1;
          //macro_ai_update(ai_mech_sk_enter_flank)
          return;
        }
        self.lefty = -1;
        //macro_ai_update(ai_mech_sk_enter_charge)
        return;
      }
    }
    
    if( enemy_vis == VIS_FRN ){
      self.lefty = self.lefty * -1;
      if( self.ai_rank > AI_RANK_REG ){
        //macro_ai_update(ai_mech_sk_enter_flank)
        return;
      }
      //macro_ai_update(ai_mech_sk_enter_charge)
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
      //macro_ai_frame(ai_mech_sk_enter_recall)
      return;
    }

    if( self.movetarget ){
      self.goalentity = self.movetarget;
      macro_ai_frame(ai_mech_sk_patrol1)
      return;
    }

    //macro_ai_frame(ai_mech_sk_enter_stand)
  }
};

/*
  STATE : COMBAT FIGHTING
*/
void() ai_mech_sk_com_fight={
  if( self.ai_state == ST_COM_FIGHT && self.ai_state_last != ST_COM_FIGHT ){
    cons_logAString("new state", "ai_mech_sk_com_fight"); //debug
    
  }
  else{
  
  }

};

/*
  STATE : COMBAT MANEUVER
*/
void() ai_mech_sk_com_maneuver={
  if( self.ai_state == ST_COM_FIGHT_MOVE && self.ai_state_last != ST_COM_FIGHT_MOVE ){
    if( self.ai_moveflag > 0 ){
      //AI still has moves it can do for now
    }
    else{
      
    }
    cons_logAString("new state", "ai_mech_sk_com_maneuver"); //debug
    return;
  }

};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() ai_mech_sk_com_maneuver_block={
  if( self.ai_state == ST_COM_FIGHT_MOVEBLOCK && self.ai_state_last != ST_COM_FIGHT_MOVEBLOCK ){
    cons_logAString("new state", "ai_mech_sk_com_maneuver_block"); //debug
  }
  else{
  
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
    
  self.th_stand = ai_mech_sk_enter_stand;
  self.th_walk = ai_mech_sk_patrol1;
  self.th_missile = ai_mech_sk_fight_prep;
  self.th_pain = ai_mech_sk_panic1;
  self.th_react = ai_mech_sk_react1;
  self.th_die = ai_mech_sk_die;
  self.th_rotate = ai_rotate_mech;
  self.touch = ai_touch;

  ai_setup_patrol();
  
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
  
  self.SendEntity = ctrl_send_mech_ai;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;

  
  //new state stuff
  self.trailMax = 4;  //debug here
  self.trailTotal = 0;
  self.ai_state_last = 0;
  self.ai_state_next = ST_STAND; //debug
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND; //debug
  self.ai_dance_card = (MOVE_CHARGE | MOVE_CHARGE_LEFT | MOVE_CHARGE_RIGHT | MOVE_STRAFE_LEFT | MOVE_STRAFE_RIGHT | MOVE_BACK | MOVE_CIRCLE_LEFT | MOVE_CIRCLE_RIGHT);
  
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
  
  self.ai_state_combat = ai_mech_sk_combat;
  self.ai_state_combat_fight =ai_mech_sk_com_fight;
  self.ai_state_combat_maneuver = ai_mech_sk_com_maneuver;
  self.ai_state_combat_maneuver_block = ai_mech_sk_com_maneuver_block;
  //--------------------------------------------------------------------------
  self.think = ai_state_frame;
  self.nextthink = time + 0.01;
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