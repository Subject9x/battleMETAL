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
  
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_tank_sk_stand1;
  self.th_walk = ai_tank_sk_patrol1;
  self.th_missile = ai_tank_sk_fight_prep;
  self.th_pain = ai_tank_sk_panic1;
  self.th_react = ai_tank_sk_react1;
  self.th_die = ai_tank_sk_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
};

void() ai_tank_sk_fight_prep={
  local entity nodeRecall;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  self.speed = self.lefty;
  
  if( ai_valid_target(self.enemy)){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, FALSE);
    enemy_hunt = FALSE;
    
    if( enemy_vis == VIS_FRAC){
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
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront){
          if( self.ai_rank > AI_RANK_REG ){
            if( random() < 0.5 ){
              self.lefty = self.lefty * -1;
              macro_ai_frame(ai_tank_sk_charge1)
              return;
            }
            macro_ai_frame(ai_tank_sk_enter_flank)
            return;
          }
          if( random() < 0.25 ){
            macro_ai_frame(ai_tank_sk_enter_strafe)
            return;
          }
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_tank_sk_charge1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( random() < 0.25 ){       
            macro_ai_frame(ai_tank_sk_enter_reverse)
            return;
          }
          macro_ai_frame(ai_tank_sk_juke1)
          return;
        }
        ai_face_targ();
        macro_ai_frame(ai_tank_sk_rotate1)
        return;
      }
      
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront){
          if( self.ai_rank > AI_RANK_REG ){
            macro_ai_frame(ai_tank_sk_enter_flank)
            return;
          }
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_tank_sk_charge1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_tank_sk_juke1)
          return;
        }
        ai_face_targ();
        macro_ai_frame(ai_tank_sk_rotate1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      macro_ai_frame(ai_tank_sk_enter_strafe)
      return;
    }
    if( enemy_vis == VIS_FAIL ){
      if( self.ai_rank > AI_RANK_REG ){
        if( util_getMechHpAverage(self) > 0.45){
          enemy_hunt = TRUE;
        }
        if( util_getMechHpAverage(self.enemy) <= 0.25 ){
          enemy_hunt = TRUE;
        }
      }
      if( util_getMechHpAverage(self) > 0.75 ){
        if( self.enemy.vec_size < self.vec_size ){
          enemy_hunt = TRUE;
        }
      }
      if( util_getMechHpAverage(self.enemy) <= 0.25 ){
        if( self.enemy.vec_size < self.vec_size ){
          enemy_hunt = TRUE;
        }
      }
    }
  }
  if( enemy_hunt ){
    if( !(self.ai_node_recall.flags & FL_NODE) ){
      ai_sfx_huntStart();
      nodeRecall = node_recall_setup();
      self.ai_node_recall = nodeRecall;
      self.goalentity = self.enemy;
        self.ai_action_time = (0 - self.ai_action_mod) * -1;
      if( self.stat_rdr_mode ){
        self.ai_action_time = ceil(self.ai_action_time * 8);
      }
      else{
        self.ai_action_time = ceil(self.ai_action_time * 4);
      }
      macro_ai_frame(ai_tank_sk_hunt1)
      return;
    }
    self.goalentity = self.ai_node_recall;
    macro_ai_frame(ai_tank_sk_hunt1)
    return;
  }
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_tank_sk_patrol1)
    return;
  }
  macro_ai_frame(ai_tank_sk_stand1)
};

/*
  TH_WALK - Patrol
*/
void() ai_tank_sk_patrol1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){    
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_tank_sk_patrol1)
};

/*
  TH_STAND - Stand1
*/
void() ai_tank_sk_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_tank_sk_patrol1)
      return;
    }
  }
  
  macro_ai_frame(ai_tank_sk_stand1)
};
