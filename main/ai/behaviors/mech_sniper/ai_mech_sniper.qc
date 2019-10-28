/*
battleMETAL 
Author: Peter Roohr
Date: 10/24/2018
rebuild: 2/16/2019
Overview: ai unit
  Mech - Sniper
  an on-ground, turreted, walking unit
  sniperrs try to work the mid and long range
  close-up they're kinda useless, only should attack at longer ranges
*/

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_sniper={

  if( ai_unit_setup(ai_mech_sniper) ){
    return;
  }

  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
    
  trigger_event( self, self.trigOnSpawn); //event interface
  
  self.th_stand = ai_mech_sniper_enter_stand;
  self.th_walk = ai_mech_sniper_patrol1;
  self.th_missile = ai_mech_sniper_fight_prep;
  self.th_pain = ai_mech_sniper_panic1;
  self.th_react = ai_mech_sniper_react1;
  self.th_die = ai_mech_sniper_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
};

void() ai_mech_sniper_walk1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  macro_ai_frame(ai_mech_sniper_walk1)
};

void() ai_mech_sniper_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  self.legs.attack_state = TR_YAW;
  self.legs.think = bot_leg_stand1;
  self.legs.nextthink = time + 0.1;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  if( self.movetarget != world ){
    if( time > self.pausetime ){
      macro_ai_frame(ai_mech_sniper_patrol1)
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
  
  macro_ai_frame(ai_mech_sniper_stand1)
};

void() ai_mech_sniper_enter_stand={
  self.legs.ai_dir = self.legs.angles_y;
  self.legs.attack_state = TR_NORM;
  self.legs.think = bot_leg_stand1;
  self.legs.nextthink = time + 0.1;
  
  self.torsoCenter.attack_state = TR_NORM;
  
  macro_ai_frame(ai_mech_sniper_stand1)
};

void() ai_mech_sniper_fight_prep={
  local float roll;
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_valid_target(self.enemy) ){
    roll = random();
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            macro_ai_frame(ai_mech_sniper_enter_melee)
            return;
          }
          if( roll < 0.35 ){
            self.lefty = -1;
            macro_ai_frame(ai_mech_sniper_enter_charge)
            return;
          }
          macro_ai_frame(ai_mech_sniper_enter_reverse)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_mech_sniper_enter_reverse)
          return;
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            if( roll < 0.35 ){
              macro_ai_frame(ai_mech_sniper_enter_reverse)
              return;
            }
            if( roll < 0.67 ){
              //melee
              macro_ai_frame(ai_mech_sniper_enter_melee)
              return;
            }
          }
          if( roll < 0.15 ){
            macro_ai_frame(ai_mech_sniper_snipe1)
            return;
          }
          if( roll < 0.3 ){
            macro_ai_frame(ai_mech_sniper_enter_reverse)
            return;
          }
          if( roll < 0.67 ){
            self.lefty = 1;
            macro_ai_frame(ai_mech_sniper_enter_charge)
            return;
          }
          macro_ai_frame(ai_mech_sniper_rotate1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( roll < 0.2 ){
            //melee
            macro_ai_frame(ai_mech_sniper_enter_melee)
            return;
          }
          macro_ai_frame(ai_mech_sniper_enter_charge)
          return;
        }
        if( roll < 0.4 ){
          macro_ai_frame(ai_mech_sniper_enter_reverse)
          return;
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          if( roll < 0.35 ){
            self.lefty = 1;
            macro_ai_frame(ai_mech_sniper_enter_charge)
            return;
          }
          if( roll < 0.5 ){
            macro_ai_frame(ai_mech_sniper_snipe1)
            return;
          }
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      if( self.ai_rank > AI_RANK_REG ){
        //melee
        macro_ai_frame(ai_mech_sniper_enter_melee)
        return;
      }
      macro_ai_frame(ai_mech_sniper_enter_reverse)
      return;
    }
    self.enemy = world;
    //snipers don't hunt, snapshot last known yaw
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    macro_ai_frame(ai_mech_sniper_turn1)
    return;
  }
  
  macro_ai_frame(ai_mech_sniper_patrol1)
};
