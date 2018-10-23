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
    ai_move( self.ideal_yaw, self.m_fspeed * AI_RUN_SPD );
  }
  else{
    ai_generic_walk();
  }
};

void() ai_gev_run={
  self.attack_finished = 0;
  if( ai_valid_target( self.enemy ) ){
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis ){
      if( enemy_range <= 400 ){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){
            ai_next_state( ST_MISSILE_STRAFE );
            self.ai_dir = ( 25 + random() * 75 );
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
  ai_move( self.ai_dir, spd * AI_RUN_SPD );

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
  
  ai_move( self.ai_dir, self.m_fspeed * AI_RUN_SPD );
  
  if( skill > 1 || self.ai_rank < AI_RANK_REG ){
    ai_attack();
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
  }
};

/*
  ST_MELEE
  attempt to strafe around to rear of target
*/
void() ai_gev_melee={
  enemy_infront = ai_check_face( self.enemy, self.ai_fov );
  enemy_range = ai_check_range( self.enemy );
  
  ai_face_targ();
  ai_attack();
  ai_yaw_move( 75, self.m_fspeed * AI_RUN_SPD);
  
  if( !enemy_infront ){
    ai_next_state( ST_MISSILE );
    return;
  }
  
  if( time > self.ai_action_time ){
    if( enemy_infront ){
      if( enemy_range <= 400 ){
        ai_next_state( ST_RUN_STRAFE );
        //set dir away from target
        return;
      }
      ai_next_state( ST_MISSILE );
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
  
  ai_face_targ();
  ai_attack();
  
  if( time > self.ai_action_time ){
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    if( enemy_infront ){
      if( skill > 1 || self.ai_rank < AI_RANK_REG ){
        ai_next_state( ST_MISSILE_STRAFE );
        local float duration;
        duration = (self.m_fspeed * AI_RUN_SPD) * 10 ;
        duration = (self.m_fspeed * AI_RUN_SPD) * 10 ;
      }
    }
    ai_next_state( ST_RUN );
    return;
  }
};


void() ai_gev_missile_strafe={

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
  
  if( ai_valid_target( self.enemy ) ){
    ai_walkgoal( AI_RUN_SPD );
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

void() ai_gev_pain={

};

void() ai_gev_crash={
  
  if( other.takedamage > DAMAGE_NO ){
    t_damage( other, self, self, (self.health * -1), DMG_ENE | EFF_PRC, self.origin, '0 0 0');
  }
  
  self.think = BecomeExplosion;
  self.nextthink = time + 0.05;
};

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
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();
  
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
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
		objerror ("ai_gev - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats( self.ai_rank );
  
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