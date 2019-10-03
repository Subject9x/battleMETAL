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
  
  trigger_event( self, trigOnSpawn ); //event interface
 
  self.th_stand = ai_gev_stand1;
  self.th_walk = ai_gev_patrol1;
  self.th_pain = ai_gev_panic1;
  self.th_missile = ai_gev_fight_prep;
  self.th_pain = ai_gev_panic1;
  self.th_react = ai_gev_react1;
  self.th_die = ai_gev_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
};

void() ai_gev_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1 );
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_gev_patrol1)
      return;
    }
  }
  
  macro_ai_frame(ai_gev_stand1)
};

void() ai_gev_walk1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1 );
  
  macro_ai_frame(ai_gev_walk1)
};

void() ai_gev_patrol1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_gev_patrol1)
};

void() ai_gev_fight_prep={
  local entity nodeRecall;
  local float roll;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  self.speed = self.lefty;
  
  roll = random();
  
  if( ai_valid_target(self.enemy)){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
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
        enemy_hunt = TRUE;
      }
    }
  }
  if( enemy_hunt ){
    if( !self.ai_node_recall ){
      ai_sfx_huntStart();
      nodeRecall = node_recall_setup();
      self.ai_node_recall = nodeRecall;
      self.goalentity = self.enemy;
        self.ai_action_time = (0 - self.ai_action_mod) * -1;
      if( self.stat_rdr_mode ){
        self.ai_action_time = ceil(self.ai_action_time * 4);
      }
      else{
        self.ai_action_time = ceil(self.ai_action_time * 2);
      }
      macro_ai_frame(ai_gev_hunt1)
      return;
    }
    self.goalentity = self.ai_node_recall;
    macro_ai_frame(ai_gev_hunt1)
    return;
  }
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_gev_patrol1)
    return;
  }
  macro_ai_frame(ai_gev_stand1)
};
