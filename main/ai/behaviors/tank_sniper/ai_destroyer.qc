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
  ai_voice_ini( TRUE );
  
  self.th_stand = ai_spg_stand1;
  self.th_walk = ai_spg_enter_patrol;
  self.th_missile = ai_spg_fight_prep;
  self.th_pain = ai_spg_panic1;
  self.th_react = ai_spg_react1;
  self.th_die = ai_vec_dest_die;
  self.th_rotate = ai_rotate_tank;
  self.touch = ai_touch;

  ai_setup_patrol();
  self.nextthink = self.nextthink + random() * 0.5; //spread out thinks
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
  
  if( ai_check_scan( self.stat_rdr_mode ) ){    
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  
  macro_ai_patrol(self.data_speed_forward, ai_spg_stand1, ai_spg_patrol1)
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
  
  local float roll;
  self.speed = self.lefty;
  
  if( ai_valid_target(self.enemy) ){
    roll = random();
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
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
  }
  self.enemy = world;
  macro_ai_frame(ai_spg_enter_patrol)
};