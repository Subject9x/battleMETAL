/*
battleMETAL 
Author: Peter Roohr
Date: 9/21/2018
rebuild: 2/16/2019
Overview: ai unit
  Tank - Skirmisher
  kinda like a mech skirmisher but slower,
  a default tank
*/

/*
  AI SPAWN FUNCTION
*/
void() ai_tank_skirmish={
  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  self.th_stand = ai_tank_sk_stand1;
  self.th_walk = ai_tank_sk_enter_patrol;
  self.th_missile = ai_tank_sk_fight_prep;
  self.th_pain = ai_tank_sk_panic1;
  self.th_react = ai_tank_sk_react1;
  self.th_die = ai_tank_sk_die;
  self.th_rotate = ai_rotate_tank;
  self.touch = ai_touch;
  
  ai_setup_patrol();
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
};

void() ai_tank_sk_fight_prep={
  local float roll;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( !ai_valid_target(self.enemy) ){
    macro_ai_frame(self.th_stand)
    return;
  } 
  
  if( (self.flags & FL_DISARMED) ){
    self.th_pain( world );
    return;
  }

  
  self.speed = self.lefty;
  roll = random();
  
  self.ai_action_time = self.ai_action_mod;
  enemy_vis = ai_check_vis( self.enemy );
  enemy_range = self.stat_trg_dist;
  enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, (self.flags & FL_TURRET));
  enemy_hunt = FALSE;
  
  if( enemy_vis == VIS_FRAC){
    //Enemy is danger-close, and getting stuck is now a risk
    if( enemy_range <= 200 ){
      if( enemy_infront){
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_tank_sk_enter_flank)
          return;
        }
        macro_ai_frame(ai_tank_sk_enter_strafe)
        return;
      }
      if( self.ai_rank > AI_RANK_REG ){
        macro_ai_frame(ai_tank_sk_juke1)
        return;
      }
      macro_ai_frame(ai_tank_sk_enter_reverse)
      return;
    }
    
    //enemy is in the sweet spot
    if( enemy_range <= self.ai_minrange ){
      if( enemy_infront){
        
        //low yaw is its own case here
        if( self.yaw_speed < 2 ){
          //slow but skilled
          if( self.ai_rank > AI_RANK_REG ){
            if( roll < 0.33 ){
              macro_ai_frame(ai_tank_sk_enter_flank)
              return;
            }
            self.lefty = -1;
            if( roll < 0.67 ){
              self.lefty = 1;
            }
            macro_ai_frame(ai_tank_sk_enter_charge)
            return;
          }
          //else
          if( roll < 0.33 ){
            self.lefty = -1;
            macro_ai_frame(ai_tank_sk_enter_charge)
            return;
          }
          if( roll < 0.67 ){
            macro_ai_frame(ai_tank_sk_enter_flank)
            return;
          }
          self.lefty = 1;
          macro_ai_frame(ai_tank_sk_enter_charge)
          return;
        }
        
        //a better yaw-speed
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.33 ){
            macro_ai_frame(ai_tank_sk_enter_flank)
            return;
          }
          if( roll < 0.67 ){
            self.lefty = 1;
            macro_ai_frame(ai_tank_sk_enter_juke)
            return;
          }
          macro_ai_frame(ai_tank_sk_enter_strafe)
          return;
        }
        if( roll < 0.33 ){
          macro_ai_frame(ai_tank_sk_enter_juke)
          return;
        }
        if( roll < 0.67 ){
          self.lefty = 1;
          macro_ai_frame(ai_tank_sk_enter_strafe)
          return;
        }
        self.lefty = 1;
        macro_ai_frame(ai_tank_sk_enter_charge)
        return;
      }
      //Enemy is not in front
      if( self.yaw_speed < 1.5 ){
        //and this bot's slow
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = -1;
          macro_ai_frame(ai_tank_sk_enter_charge)
          return;
        }
        macro_ai_frame(ai_tank_sk_enter_reverse)
        return;
      }
      if( self.ai_rank > AI_RANK_REG ){
        if( roll < 0.33 ){ 
          macro_ai_frame(ai_tank_sk_juke1)
          return; 
        }     
        macro_ai_frame(ai_tank_sk_enter_reverse)
        return;
      }
      if( roll < 0.33 ){
        self.lefty = 1;
        macro_ai_frame(ai_tank_sk_enter_charge)
        return;
      }
      macro_ai_frame(ai_tank_sk_enter_rotate)
      return;
    }
    
    //enemy is at long-range
    if( enemy_range > self.ai_minrange ){
      if( enemy_infront){
        if( self.ai_rank > AI_RANK_REG ){
          if( self.yaw_speed > 1.5 ){
            //interesting edge case: super low turn speed
            macro_ai_frame(ai_tank_sk_enter_flank)
            return;
          }
        }
      }
      //priority is to get back into combat range
      self.lefty = 1;
      macro_ai_frame(ai_tank_sk_enter_charge)
      return;
    }
  }
  
  if( enemy_vis == VIS_FRN ){
    if( self.ai_rank > AI_RANK_REG ){
      enemy_hunt = TRUE;
    }
    else{
      self.enemy = world;
      macro_ai_frame(ai_tank_sk_stand1)
      return;
    }
  }
  if( enemy_vis == VIS_FAIL ){
    if( enemy_range < 200 ){
      macro_ai_frame(ai_tank_sk_enter_rotate)
      return;
    }
    if( self.stat_rdr_mode ){
      enemy_hunt = TRUE;
    }
  }
  
  if( enemy_hunt ){
    if(  self.ai_node_recall == world || !(self.ai_node_recall) ){
      macro_ai_frame(ai_tank_sk_enter_hunt)
      return;
    }
    macro_ai_frame(ai_tank_sk_enter_recall)
    return;
  }

  if( self.movetarget ){
    macro_ai_frame(ai_tank_sk_enter_patrol)
    return;
  }

  macro_ai_frame(ai_tank_sk_stand1)
};

void() ai_tank_sk_enter_patrol={
  self.torsoCenter.attack_state = TR_GOAL;
  self.goalentity = self.movetarget;
  
  macro_ai_frame(ai_tank_sk_patrol1)
};

/*
  TH_WALK - Patrol
*/
void() ai_tank_sk_patrol1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
 
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  macro_ai_patrol(self.data_speed_forward, ai_tank_sk_enter_sentry, ai_tank_sk_patrol1)
};

/*
  TH_STAND - Stand1
*/
void() ai_tank_sk_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_tank_sk_enter_patrol)
      return;
    }
  }
  
  macro_ai_frame(ai_tank_sk_enter_sentry)
};
