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
    
  self.th_stand = ai_mech_sk_stand1;
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
  local entity nodeRecall;
  local float roll;
  
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  self.speed = self.lefty;
  roll = random();
  
  if( (self.flags & FL_DISARMED) ){
    self.th_pain( world );
    return;
  }
  
  if( ai_valid_target(self.enemy) ){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    enemy_hunt = FALSE;
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          if( self.yaw_speed < 2 ){
            if( self.ai_rank > AI_RANK_REG ){
            
            }
          }
        }
        
        if( self.ai_rank > AI_RANK_REG ){
            
        }
      
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.yaw_speed < 2 ){
            if( self.ai_rank > AI_RANK_REG ){
            
            }
          }
        }
        if( self.ai_rank > AI_RANK_REG ){
            
        }
      }

      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          macro_ai_update(ai_mech_sk_enter_charge)
          return;
        }
        macro_ai_update(ai_mech_sk_enter_flank)
        return;
      }
    }
    
    if( enemy_vis == VIS_FRN ){

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
        self.ai_action_time = ceil(self.ai_action_time * 6);
      }
      else{
        self.ai_action_time = ceil(self.ai_action_time * 4);
      }
      macro_ai_frame(ai_mech_sk_hunt1)
      return;
    }
    self.goalentity = self.ai_node_recall;
    macro_ai_frame(ai_mech_sk_hunt1)
    return;
  }
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_mech_sk_patrol1)
    return;
  }
  macro_ai_frame(ai_mech_sk_stand1)
};

void() ai_mech_sk_stand1={
  local entity this;

  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  this = self;
  self = this.legs;
  self.attack_state = TR_YAW;
    bot_leg_stand1();
  self = this;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_mech_sk_patrol1)
      return;
    }
  }
  macro_ai_frame(ai_mech_sk_stand1)
};