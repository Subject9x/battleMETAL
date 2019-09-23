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

  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
    
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_mech_sniper_stand1;
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
  
  otemp = self;
  self = self.legs;
    bot_leg_stand1();
    self.attack_state = TR_YAW;
  self = otemp;
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_mech_sniper_patrol1)
      return;
    }
  }
  
  macro_ai_frame(ai_mech_sniper_stand1)
};

void() ai_mech_sniper_fight_prep={
  local float rand;
  rand = random();
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_valid_target(self.enemy) ){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_melee1)
            return;
          }
          if( rand < 0.35 ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (random() * 45) * 2;
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.angles_y + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_charge1)
            return;
          }
          macro_ai_frame(ai_mech_sniper_reverse1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_mech_sniper_reverse1)
          return;
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            if( rand < 0.35 ){
              macro_ai_frame(ai_mech_sniper_reverse1)
              return;
            }
            if( rand < 0.67 ){
              //melee
              self.lefty = self.lefty * -1;
              self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
              self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
              self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
              macro_ai_frame(ai_mech_sniper_melee1)
              return;
            }
          }
          if( rand < 0.15 ){
            macro_ai_frame(ai_mech_sniper_snipe1)
            return;
          }
          if( rand < 0.3 ){
            macro_ai_frame(ai_mech_sniper_reverse1)
            return;
          }
          if( rand < 0.67 ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (random() * 45) * 2;
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.angles_y + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_charge1)
            return;
          }
          macro_ai_frame(ai_mech_sniper_rotate1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( rand < 0.2 ){
            //melee
            self.lefty = self.lefty * -1;
            self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_melee1)
            return;
          }
          self.lefty = self.lefty * -1;
          self.ai_dir = (random() * 45) * 2;
          self.ai_dir = self.ai_dir * self.lefty;
          self.ai_dir = anglemod( self.angles_y + self.ai_dir );
          macro_ai_frame(ai_mech_sniper_charge1)
          return;
        }
        if( rand < 0.4 ){
          macro_ai_frame(ai_mech_sniper_reverse1)
          return;
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          rand = random();
          if( rand < 0.35 ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (random() * 45) * 2;
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.angles_y + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_charge1)
            return;
          }
          if( rand < 0.5 ){
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
        self.lefty = self.lefty * -1;
        self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
        macro_ai_frame(ai_mech_sniper_melee1)
        return;
      }
      macro_ai_frame(ai_mech_sniper_reverse1)
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
