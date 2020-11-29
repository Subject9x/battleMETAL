/*
battleMETAL 
Author: Peter Roohr
Date: 9/25/2018
Overview: ai unit
  VTOL Unit
    no turret
    flies around
    can actually hunt its target
*/

void() ai_vtol_crash;

void() ai_vtol_stand;       //normal hanging out
void() ai_vtol_walk;
void() ai_vtol_run;         //main combat sequencer
void() ai_vtol_run_strafe;  // attempting to close distance, better pilots may try to attack
void() ai_vtol_run_charge;  // low rank pilots attempt to do a fly over
void() ai_vtol_melee;       // high rank pilots do a fly over with attack
void() ai_vtol_missile;     // normal stationary attack
void() ai_vtol_missile_strafe;//  good pilot attack
void() ai_vtol_hunt;        //  will actually hunt player
void() ai_vtol_pain;        //
  
void() ai_vtol_die;
void() ai_vtol_th;


void() ai_vtol_stand={
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, self.ai_fov, FALSE) ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  else{
    ai_generic_stand();
    ai_fly_update( 350, 600); 
  }
};

void() ai_vtol_walk={
  if( ai_valid_target(self.enemy) ){
    ai_face_targ();
    walkmove( self.ideal_yaw, self.data_speed_forward * AI_RUN_SPD );
  }
  else{
    self.ideal_yaw = vectoyaw( self.movetarget.origin - self.origin );
    ChangeYaw();
    walkmove( self.angles_y, self.data_speed_forward * AI_RUN_SPD );
  }
  ai_fly_update( 350, 600); 
};

void() ai_vtol_run={
 /* self.attack_finished = 0;
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis ){
      if( enemy_range <= 400 ){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){
            ai_next_state( ST_MISSILE_STRAFE );
            self.ai_dir = ( 25 + random() * 65 );
            if( self.lefty > 0 ){
              self.lefty = self.lefty * -1;
            }
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
            self.ai_action_time = self.ai_action_time + 4;
            return;
          }
          ai_next_state( ST_MELEE );
          self.ai_action_time = self.ai_action_time + 2;
          return;
        }
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){
            ai_next_state( ST_MISSILE_STRAFE );
            self.ai_dir = ( 25 + random() * 65 );
            if( self.lefty > 0 ){
              self.lefty = self.lefty * -1;
            }
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
            self.ai_action_time = self.ai_action_time + 4;
            return;
          }
          ai_next_state( ST_MISSILE );
          return;
        }
        if( self.ai_rank > AI_RANK_VET ){
          ai_next_state( ST_STAND );
          return;
        }
        ai_next_state( ST_RUN_STRAFE );
        self.lefty = self.lefty * -45;
        self.ai_dir = anglemod( self.ideal_yaw + self.lefty );
        self.ai_action_time = self.ai_action_time + 2;
        return;
      }
      
      if( enemy_range <= self.ai_minrange * 2 ){
        if( enemy_infront ){
          ai_next_state( ST_RUN_STRAFE );
          self.lefty = self.lefty * -45;
          self.ai_dir = anglemod( self.ideal_yaw + self.lefty );
          self.ai_action_time = self.ai_action_time + 2;
          return;
        }
        ai_next_state( ST_HUNT );
        self.goalentity = self.enemy;
        self.ai_action_time = self.ai_action_time + (skill * 2) - self.ai_rank;
        return;
      }
      
      ai_face_targ();
      walkmove( self.ideal_yaw, self.data_speed_forward * AI_RUN_SPD );
      return;
    }
  }
  else{
    ai_next_state( ST_STAND );
    return;
  }*/
};


void() ai_vtol_run_strafe={
  local float speeed;
  
  ai_face_targ();
  speeed = ( self.data_speed_forward + self.data_speed_strafe ) / 2;
  walkmove( self.ai_dir, speeed * AI_RUN_SPD );
  ai_fly_update( 350, 600); 
  
  if( time > self.ai_action_time ){
    if( self.ai_rank < AI_RANK_REG ){
      ai_next_state( ST_MISSILE_STRAFE );
      self.ai_dir = ( 25 + random() * 65 );
      if( self.lefty > 0 ){
        self.lefty = self.lefty * -1;
      }
      self.ai_dir = self.ai_dir * self.lefty;
      self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
      self.ai_action_time = self.ai_action_time + 4;
      return;
    }
    if( skill > 2 ){
      ai_next_state( ST_MISSILE );
      return;
    }
    ai_next_state( ST_RUN );
    return;
  }
};


void() ai_vtol_run_charge={
  ai_face_targ();
  walkmove( self.ai_dir, self.data_speed_forward * AI_RUN_SPD );
  ai_fly_update( 350, 600); 
  
  if( time > self.ai_action_time ){
    if( self.ai_rank > AI_RANK_VET ){
      ai_next_state( ST_STAND );
      return;
    }
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_vtol_melee={
  if( self.angles_y != self.ideal_yaw ){
    ai_face_targ();
  }
  
  walkmove( self.angles_y , self.data_speed_forward * AI_WALK_SPD );
  ai_fly_update( 350, 600); 
  
  if( self.ai_rank < AI_RANK_REG ){
    if( ai_check_face( self.enemy, 0.97, FALSE) ){
      ai_attack();
    }
  }
  
  if( time > self.ai_action_time ){
    if( self.ai_rank == AI_RANK_REG ){
      ai_next_state( ST_MISSILE );
      return;
    }
    if( self.ai_rank == AI_RANK_ROK ){
      ai_next_state( ST_STAND );
      self.ai_action_time = self.ai_action_time + 2;
      return;
    } 
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_vtol_missile={
  ai_face_targ();
  ai_fly_update( 350, 600); 
  if( ai_check_face( self.enemy, 0.97, FALSE) ){
    if( ai_attack() ){
      if( self.ai_rank < AI_RANK_REG ){
        ai_next_state( ST_MISSILE_STRAFE );
        return;
      }
      ai_next_state( ST_RUN );
      return;
    }
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};


void() ai_vtol_missile_strafe={
  local float speeed;
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    speeed = ( self.data_speed_forward + self.data_speed_strafe ) / 2;
    walkmove( self.ai_dir, speeed * AI_RUN_SPD );
    ai_fly_update( 250, 600); 
    
    if( ai_check_face( self.enemy, 0.97, FALSE) ){
      if( ai_attack() ){
        ai_next_state( ST_RUN_STRAFE );
        self.ai_action_time = self.ai_action_time + 2;
        return;
      }
    }
  }
  else{
    if( self.ai_rank < AI_RANK_REG ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    self.ai_action_time = self.ai_action_time + 2;
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
  VTOL's are actually allowed to hunt the player,
  something something no terrain
*/
void() ai_vtol_hunt={
  
  if( ai_valid_target( self.enemy ) ){
    //ai_walkgoal( AI_RUN_SPD ); DEPRECATED
    if( ai_check_vis( self.enemy ) ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  else{
    self.goalentity = self.movetarget;
    ai_next_state( ST_STAND );
    return;
  }
  if( time > self.ai_action_time ){
    self.goalentity = self.movetarget;
    ai_next_state( ST_STAND );
    self.ai_action_time = self.ai_action_time + 2;
    return;
  }
};

void() ai_vtol_pain={

};

void() ai_vtol_crash={
  
  if( other.takedamage > DAMAGE_NO ){
    t_damage( other, self, self, (self.health * -1), self.origin, '0 0 0');
  }
  
  self.think = BecomeExplosion;
  self.nextthink = time + 0.05;
};

void() ai_vtol_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_CORPSE;
  self.flags = self.flags - (self.flags & FL_FLY);
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.touch = ai_vtol_crash;
  
};

void() ai_vtol_th={
  
  ctrl_updateTank();
    
  if( !self.deadflag ){
    if( self.enemy ){
      if( ai_valid_target( self.enemy ) ){
        self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
        //ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
        //ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
        //ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
        ai_lock_on();
      }
      else{ 
        self.enemy = world;
      }
    } 
    ai_ranged_attack();
    self.button0 = 0;

    ai_state_control( self.attack_state );
  }
  self.think = ai_vtol_th;
  self.nextthink = time + 0.05;
};


/*
  AI SPAWN FUNCTION
*/
void() ai_vtol={

  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, self.trigOnSpawn); //event interface
  
  self.th_stand = ai_vtol_stand;
  self.th_walk = ai_vtol_walk;
  self.th_hunt = ai_vtol_hunt;
  self.th_pain = ai_vtol_pain;
  self.th_die = ai_vtol_die;

  
  self.think = ai_vtol_th;
  if( (self.spawnflags & COLD_START) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};