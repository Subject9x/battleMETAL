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

//set state time duration
float() ai_gev_setDuration={
  local float duration, vel;
  duration = 3.1 - skill;
  duration = duration + (4 - self.ai_rank);
  duration = duration + (self.vec_size - 1);
  duration = duration / 10;
  vel = self.m_fspeed * AI_RUN_SPD;
  vel = vel * 20 / 500;
  duration = duration + vel;
  duration = duration * random();
  return duration;
};

float() ai_gev_lefty={
  if( random() > 0.49 ){
    return self.lefty = 1 - self.lefty;
  }
  return self.lefty;
};

void() ai_gev_stand;        //normal hanging out
void() ai_gev_walk;         //  velocity style movement 
void() ai_gev_run;          //main combat sequencer
void() ai_gev_run_strafe;   // 
void() ai_gev_run_charge;   // 
void() ai_gev_melee;        // yaw-based attempt to flank target
void() ai_gev_missile;      // 
void() ai_gev_missile_strafe;//  
void() ai_gev_hunt;         //
void() ai_gev_pain;         //
  
void() ai_gev_die;
void() ai_gev_th;

void() ai_gev_stand={
  ai_update_accuracy( FALSE );  
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, self.ai_fov ) ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  else{
    ai_generic_stand();
  }
};

void() ai_gev_walk={
  ai_update_accuracy( TRUE ); 
  if( ai_valid_target(self.enemy) ){
    ai_face_targ();
    ai_move( self.angles_y, self.m_fspeed * AI_RUN_SPD );
  }
  else{
    ai_generic_walk();
  }
};

void() ai_gev_run={
  local float angl, range;
  
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis ){
      if( enemy_range <= 200 ){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){
            ai_next_state( ST_MELEE );
            return;
          }
          ai_next_state( ST_RUN_CHARGE );
          self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
          return;
        }
        ai_next_state( ST_MISSILE );
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){ 
          if( ai_check_face( self.enemy, 0.92 ) ){
            if( ai_attack() ){
              angl = 25 + (random() * 90);
              angl = angl * ai_gev_lefty();
              ai_next_state( ST_MISSILE_STRAFE );
              self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
              self.ai_dir = anglemod( self.ideal_yaw + angl );
              return;
            }
          }
          ai_next_state( ST_RUN_CHARGE );
          self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
          return;
        }
        ai_next_state( ST_MISSILE );
        self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
        return;
      }
      
      if( enemy_range <= self.ai_minrange * 2 ){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){            
            if( ai_check_face( self.enemy, 0.92 ) ){
              if( ai_attack() ){
                angl = 25 + (random() * 90);
                angl = angl * ai_gev_lefty();
                ai_next_state( ST_MISSILE_STRAFE );
                self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
                self.ai_dir = anglemod( self.ideal_yaw + angl );
                return;
              }
            }
          } 
          ai_next_state( ST_RUN_STRAFE );
          self.ai_dir = anglemod( self.ideal_yaw - 180 );
          return;
        }
        ai_next_state( ST_RUN_CHARGE );
        self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
        return;
      }
      
      ai_face_targ();
      ai_move( self.ideal_yaw, self.m_fspeed * AI_RUN_SPD );
      return;
    }
  }
  else{
    ai_next_state( ST_STAND );
    return;
  }
};

/*
  ST_RUN_STRAFE
  Time limit set by distance calc.
*/
void() ai_gev_run_strafe={
  local float spd;
  ai_update_accuracy( TRUE );
  
  spd = self.m_fspeed / 2 + self.m_sspeed;
  
  ai_face_targ();
  if( !ai_move( self.ai_dir * self.lefty, spd * AI_RUN_SPD ) ){
    self.lefty = 1 - self.lefty;
  }

  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
  ST_RUN_CHARGE
  Time limit set by distance calc.
*/
void() ai_gev_run_charge={
  ai_update_accuracy( TRUE );
  ai_face_targ();
  ai_move( anglemod(self.angles_y + 45),  self.m_fspeed * AI_RUN_SPD);
  if( skill > 1 || self.ai_rank < AI_RANK_REG ){
    if( ai_check_face( self.enemy, 0.92 ) ){
      ai_attack();
    }
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
  ST_MELEE
  attempt to strafe around to rear of target
*/
void() ai_gev_melee={
  local float insights;
  ai_update_accuracy( TRUE );
  enemy_range = ai_check_range( self.enemy );
  otemp = self;
  self = otemp.enemy;
    insights = ai_check_face( otemp, 0.87 );
  self = otemp;
  
  ai_face_targ();
  
  if( ai_check_face( self.enemy, 0.92 ) ){
    ai_attack();
  }
  
  if( !ai_yaw_move( 65 * self.lefty, self.m_fspeed * AI_WALK_SPD) ){
    self.lefty = 0 - self.lefty;
  }
  if( !insights ){
    ai_next_state( ST_MISSILE );
    return;
  }
  
  if( time > self.ai_action_time ){
    if( !insights ){
      if( enemy_range <= 100 ){
        ai_next_state( ST_RUN_STRAFE );
        //set dir away from target
        self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
        self.ai_dir = anglemod( self.ideal_yaw - 180 );
        return;
      }
      ai_next_state( ST_MISSILE );
      self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
      return;
    }
    ai_next_state( ST_RUN );
    return;
  }
};

/*
  ST_MISSILE
  Time limit set by distance calc.
  no movement.
  AI tries to deliver fire on target.
*/
void() ai_gev_missile={
  local float insights;
  
  ai_update_accuracy( FALSE );
  if( ai_valid_target(self.enemy) ){
    otemp = self;
    self = otemp.enemy;
      insights = ai_check_face( otemp, 0.87 );
    self = otemp;
    
    ai_face_targ();
    if( ai_check_face( self.enemy, 0.92 ) ){
      ai_attack();
    }
  }
  
  if( time > self.ai_action_time ){
    if( insights ){
      if( skill > 1 || self.ai_rank < AI_RANK_REG ){
        local float angl;
        angl = 25 + (random() * 90);
        angl = angl * ai_gev_lefty();
        ai_next_state( ST_MISSILE_STRAFE );
        self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
        self.ai_dir = anglemod( self.ideal_yaw + angl );
        return;
      }
      ai_next_state( ST_RUN_CHARGE );
      self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
      return;
    }
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_gev_missile_strafe={
  local float spd;
  
  ai_update_accuracy( TRUE );
  spd = self.m_fspeed / 2 + self.m_sspeed;
  
  ai_face_targ();
  if( ai_check_face( self.enemy, 0.92 ) ){
    ai_attack();
  }
  if( !ai_move( self.ai_dir, spd * AI_RUN_SPD) ){        
    local float angl;
    angl = 25 + (random() * 90);
    angl = angl * ai_gev_lefty();
    ai_next_state( ST_MISSILE_STRAFE );
    self.ai_dir = anglemod( self.ai_dir - angl );
    self.ai_action_time = self.ai_action_time + ai_gev_setDuration();
    return;
  }

  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

void() ai_gev_hunt={
  ai_update_accuracy( TRUE ); 
  if( ai_valid_target(self.enemy) ){
    //as long as enemy is valid, move to node
    ai_walkgoal( AI_RUN_SPD );    
  }
  
  if( ai_line_of_sight( self.enemy ) ){
    //if spotted, dump hunt node, add more time to recall node
    ai_next_state( ST_RUN );
    if( self.ai_node_hunt ){
      remove(self.ai_node_hunt);
    }
    return;
  }
  
  if( time > self.ai_node_hunt.ai_action_time ){
    ai_sfx_huntEnd();
    //timer to reach the hunt node expired, recall time
    if( self.ai_node_hunt ){
      remove(self.ai_node_hunt);
    }
    if( self.ai_node_recall ){
      self.goalentity = self.ai_node_recall;
      ai_next_state( ST_WALK );
      self.ai_action_time = self.ai_action_time + ai_move_time(self.m_fspeed * AI_WALK_SPD, vlen(self.ai_node_recall.origin - self.origin), 0.1);
      return;
    }
    
    if( self.movetarget ){
      self.goalentity = self.goalentity.goalentity; //hunt node's recall node
      ai_next_state( ST_WALK );
      return;
    }
  }
};

/*
  setup 
  entity( float radiius ) ai_find_friend;
*/
void() ai_gev_pain={
  //TODO - finish
  ai_update_accuracy( TRUE );
  if( ai_valid_target( self.goalentity ) ){
    self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
    ai_move_turn();
    ai_move( self.ideal_yaw, self.m_fspeed * AI_RUN_SPD);
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
  
};

void() ai_gev_die2={
  self.think = ai_gev_die2;
  if( time > self.ai_action_time ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 1;
};

void() ai_gev_die1={
  self.deadflag = DEAD_DEAD;
  te_smoke_test(self.origin, '1 1 10', 4) ;
  
  self.think = ai_gev_die1;
  if( time > self.ai_action_time ){
    self.ai_action_time = time + (random() * 2000);
    self.think = ai_gev_die2;
  }
  self.nextthink = time + 0.5;
};

void() ai_gev_touch_death={
  local vector vel;
  if( other == world ){
    self.movetype = MOVETYPE_NONE;
    makevectors( self.angles );
    vel = self.origin + (v_up * 2);
    switch( self.vec_size ){
      case 2:
        te_med_flame_start( self.origin + (v_up * (self.maxs_y / 1.5)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 50); 
        break;
      case 3:
        te_big_flame_start( self.origin + (v_up * (self.maxs_y / 1.5)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 50); 
        break;
      default:
        te_small_flame_start( self.origin + (v_up * (self.maxs_y / 1.5)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 50); 
        break;
    }
    self.touch = SUB_Null;
  }
  self.think = ai_gev_die2;
  self.nextthink = time + 0.05;
};

void() ai_gev_die={
  local entity w_chain;
  local vector v;
  local vector t;
  
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_BBOX;
  self.colormod = '0.1 0.1 0.1'; 
  setsize(self, self.mins * 0.35, self.maxs * 0.35);
  setorigin(self, self.origin);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  ai_sfx_dead();
 
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);
  if( (self.flags & FL_TURRET) ){
    mech_player_compdie(self.e_tor_c);
  }
  
  t_y = self.ideal_yaw;
  
  makevectors( self.angles );

  v = self.origin + (v_forward * 2) + (v_right * (crandom() * 3)) + (v_up * 3);
  te_debris( self.origin, self.angles, normalize(v - self.origin) * 100, self.vec_size + (random() * 5), self.vec_size);
  
  if( self.attack_state != ST_STAND ){
    self.velocity = normalize( v - self.origin);
    self.velocity = self.velocity * 200;
    self.gravity = 0.25;
    self.avelocity_x = crandom() * 150;
    self.avelocity_y = crandom() * 300; 
    self.avelocity_z = crandom() * 400;
  }
  else{
    self.velocity = normalize( (self.origin + (v_up * -2)) - self.origin);
    self.velocity_z = self.velocity_z - 10;
    self.gravity = 0.25;
  }
  self.attack_state = -1;
  self.think = ai_gev_die1;
  self.nextthink = time + 0.01;
  self.ai_action_time = time + (random() * 500);
  self.attack_state = -1;
  self.touch = ai_gev_touch_death;
};

void() ai_gev_th={

  ctrl_updateTank();
  te_unit_dust( self.origin, self.angles, self.velocity, 1 );
  if( !(self.spawnflags & AI_SPAWNFLAG_DEBUG) ){
    if( !self.deadflag ){
      if( self.enemy ){
        //this is only for hunting functionality
        if( self.attack_state != ST_HUNT ){
          if( !ai_line_of_sight( self.enemy ) ){
            ai_hunt_setup();
          }
        }
        else{
          ai_turret_set_state( TR_TARG );
        }
        if( ai_valid_target( self.enemy ) ){
          self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
          ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
          ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
          ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
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
  }
  if( (self.flags & FL_TURRET) ){
    ai_turret_control();
  }

  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_gev_th;
    self.nextthink = time + 0.05;
  }
};


/*
  AI SPAWN FUNCTION
*/
void() ai_gev={  

  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_gev_stand;
  self.th_walk = ai_gev_walk;
  self.th_run = ai_gev_run;
  self.th_run_strafe = ai_gev_run_strafe;
  self.th_run_charge = ai_gev_run_charge;
  self.th_missile = ai_gev_missile;
  self.th_melee = ai_gev_melee;
  self.th_missile_strafe = ai_gev_missile_strafe;
  self.th_hunt = ai_gev_hunt;
  self.th_pain = ai_gev_pain;
  self.th_die = ai_gev_die;
  
  ai_initialize_system( ST_STAND );

  droptofloor();
  
  ai_walk_setup();
  
  self.think = ai_gev_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};