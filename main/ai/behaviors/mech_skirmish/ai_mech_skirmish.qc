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
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={

  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  trigger_event( self, trigOnSpawn); //event interface
    
  self.th_stand = ai_mech_sk_enter_stand;
  self.th_walk = ai_mech_sk_patrol1;
  self.th_missile = ai_mech_sk_fight_prep;
  self.th_pain = ai_mech_sk_panic1;
  self.th_react = ai_mech_sk_react1;
  self.th_die = ai_mech_sk_die;
  self.touch = ai_touch;

  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
};

/*
  Fight Prep is like the big combat-logic filter, TH_SCRUTINIZER? 
*/
void() ai_mech_sk_fight_prep={
  local float roll;

  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  self.speed = self.lefty;
      
  if( (self.flags & FL_DISARMED) ){
    self.th_pain( world );
    return;
  }

  enemy_hunt = FALSE;
  if( ai_valid_target(self.enemy) ){
    roll = random();
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    
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
            if( roll < 0.33 )
              self.lefty = self.lefty * -1;
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
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( self.movetarget != world ){
    if( time > self.pausetime ){
      macro_ai_frame(ai_mech_sk_patrol1)
      return;
    }
  }
  
  if( random() < 0.25 ){
    self.ideal_yaw = (random() * self.ai_angleLimits_x) * -1;
    self.ideal_yaw = self.ideal_yaw + self.ai_angleLimits_y;
    self.ideal_yaw = self.ideal_yaw * crandom();
    self.ideal_yaw = anglemod( self.angles_y + self.ideal_yaw);
    macro_ai_frame(ai_mech_sniper_turn1)
    return;
  }

  macro_ai_frame(ai_mech_sk_stand1)
};

void() ai_mech_sk_enter_stand={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  self.torsoCenter.attack_state = TR_NORM;
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_stand1;
  self.legs.nextthink = time + 0.1;
  self.goalentity = world;
  
  macro_ai_frame(ai_mech_sk_stand1)
};