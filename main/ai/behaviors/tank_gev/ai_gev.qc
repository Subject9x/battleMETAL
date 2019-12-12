/*
battleMETAL 
Author: Peter Roohr
Date: 9/25/2018
Rebuild - 02/16/2019
Overview: ai unit
  Tank - GEV
  Behavior - Skirmish
*/
/*
  AI SPAWN FUNCTION
*/
void() ai_gev={  
  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );

  self.th_stand = ai_gev_stand1;
  self.th_walk = ai_gev_enter_patrol;
  self.th_pain = ai_gev_panic1;
  self.th_missile = ai_gev_fight_prep;
  self.th_pain = ai_gev_panic1;
  self.th_react = ai_gev_react1;
  self.th_die = ai_gev_die;
  self.th_rotate = ai_rotate_tank;
  self.touch = ai_touch;
  
  ai_setup_patrol();
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
};

void() ai_gev_enter_patrol={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  self.goalentity = self.movetarget;
  self.torsoCenter.attack_state = TR_GOAL;
  
  macro_ai_frame(ai_gev_patrol1)
};

void() ai_gev_patrol1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }

  macro_ai_patrol(self.data_speed_forward / 2, ai_gev_stand1, ai_gev_patrol1)
};

void() ai_gev_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  
  if( self.movetarget ){
    if( time > self.pausetime ){
      macro_ai_frame(ai_gev_enter_patrol)
      return;
    }
  }
  
  macro_ai_frame(ai_gev_stand1)
};

void() ai_gev_walk1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  macro_ai_frame(ai_gev_walk1)
};

void() ai_gev_fight_prep={
  local float roll;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  self.speed = self.lefty;
  
  roll = random();
  
  if( ai_valid_target(self.enemy)){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    enemy_hunt = FALSE;
    
    if( enemy_vis == VIS_FRAC ){
      //enemy is danger close
      if( enemy_range <= 200 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = 1;
            if( roll < 0.6 ){
              self.lefty = -1;
              macro_ai_frame(ai_gev_enter_flank)
              return;
            }       
            macro_ai_frame(ai_gev_enter_flank)
            return;
          }
          if( roll > 0.6 ){
            self.lefty = -1;
            macro_ai_frame(ai_gev_charge1)
            return;
          }
          macro_ai_frame(ai_gev_rotate1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = 1;
          macro_ai_frame(ai_gev_enter_charge)
          return;
        }
        macro_ai_frame(ai_gev_enter_strafe)
        return;
      }
      
      //enemy is in prime combat range
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          //AI is a decent pilot
          if( self.ai_rank > AI_RANK_REG ){
            if( roll < 0.33 ){
              macro_ai_frame(ai_gev_enter_flank)
              return;
            }
            if( roll < 0.67 ){
              macro_ai_frame(ai_gev_enter_strafe)
              return;
            }
            self.lefty = -1;
            macro_ai_frame(ai_gev_enter_charge)
            return;
          }
          if( roll < 0.33 ){
              macro_ai_frame(ai_gev_enter_strafe)
              return;
          }
          if( roll < 0.67 ){
            self.lefty = -1;
            macro_ai_frame(ai_gev_enter_charge)
            return;
          }
          macro_ai_frame(ai_gev_enter_flank)
          return;
        }
        
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.33 ){
            macro_ai_frame(ai_gev_enter_strafe)
            return;
          }
          self.lefty = 1;
          macro_ai_frame(ai_gev_enter_charge)
          return;
        }
        if( roll < 0.33 ){
          macro_ai_frame(ai_gev_enter_flank)
          return;
        }
        self.lefty = -1;
        macro_ai_frame(ai_gev_enter_charge)
        return;
      }
      
      //enemy is out of combat range
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          self.lefty = 1;
          macro_ai_frame(ai_gev_enter_charge)
          return;
        }
        //dump target, find new one
        self.enemy = world;
        macro_ai_frame(ai_gev_stand1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      enemy_vis = VIS_FAIL;
    }
    if( enemy_vis == VIS_FAIL ){      
      if( self.stat_rdr_mode ){
        enemy_hunt = TRUE;
      }
    }
  }
  if( enemy_hunt ){
    if( self.ai_node_recall == world || !(self.ai_node_recall) ){
      macro_ai_frame(ai_gev_enter_hunt)
      return;
    }
    macro_ai_frame(ai_gev_enter_recall)
    return;
  }
  if( self.movetarget ){
    macro_ai_frame(ai_gev_enter_patrol)
    return;
  }
  macro_ai_frame(ai_gev_stand1)
};
