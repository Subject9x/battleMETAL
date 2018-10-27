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
void() ai_gev_setStrafe={
  

};

float() ai_gev_lefty={
  if( random() > 0.49 ){
    return self.lefty = 1 - self.lefty;
  }
  return self.lefty;
};

void() ai_gev_crash;

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
          if( (skill > 1) || (self.ai_rank < AI_RANK_REG) ){
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
          if( (skill > 1) || (self.ai_rank < AI_RANK_REG) ){            
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

/*
  VTOL's are actually allowed to hunt the player,
  something something no terrain
*/
void() ai_gev_hunt={
  

  
};

/*
  setup 
  entity( float radiius ) ai_find_friend;
*/
void() ai_gev_pain={
  //TODO - finish
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

void() ai_gev_crash={
  
  if( other.takedamage > DAMAGE_NO ){
    t_damage( other, self, self, (self.health * -1), DMG_ENE | EFF_PRC, self.origin, '0 0 0');
  }
  
  self.think = BecomeExplosion;
  self.nextthink = time + 0.05;
};

//TODO - fix death, needs to  go flying
void() ai_gev_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  local vector v;
  makevectors( self.angles );
  v = self.origin + (v_forward * self.m_fspeed) + (v_right * self.m_sspeed) + (v_up * 500);
  self.velocity = normalize( self.origin - v );
  self.velocity = self.velocity * 400;
  self.avelocity = '250 100 500';
};

void() ai_gev_th={
  local entity wep;
  
  ctrl_updateCenterTorso();
  wep = self.w_slot;
  while(wep){
    ctrl_wpn_think(wep);
    wep = wep.w_slot;
  }
    
  if( !self.deadflag ){
    if( self.enemy ){
      if( ai_valid_target( self.enemy ) ){
        self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
        ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
        ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
        ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
      }
      else{ 
        self.enemy = world;
      }
    } 
    ai_ranged_attack();
    self.button0 = 0;

    ai_state_control( self.attack_state );
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
  if( !ai_create_unit( data_iniVehc )){
    return;
  }
  
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
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
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